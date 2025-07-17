import 'package:feature_voting/features/voting/domain/entities/feature.dart';
import 'package:feature_voting/features/voting/domain/usecases/get_features.dart';
import 'package:feature_voting/features/voting/presentation/cubits/feature_cubit.dart';
import 'package:feature_voting/features/voting/presentation/cubits/feature_state.dart';
import 'package:feature_voting/features/voting/presentation/pages/add_feature_page.dart';
import 'package:feature_voting/features/voting/presentation/widgets/feature_card.dart';
import 'package:feature_voting/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  SortBy _sortBy = SortBy.votes;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final status = _getStatusFromIndex(_tabController.index);
    context.read<FeatureCubit>().loadFeatures(status: status, sortBy: _sortBy);
  }

  FeatureStatus? _getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return null; // All
      case 1:
        return FeatureStatus.pending;
      case 2:
        return FeatureStatus.inProgress;
      case 3:
        return FeatureStatus.completed;
      case 4:
        return FeatureStatus.rejected;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feature Voting',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
              final status = _getStatusFromIndex(_tabController.index);
              context.read<FeatureCubit>().loadFeatures(
                status: status,
                sortBy: _sortBy,
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortBy.votes,
                child: Row(
                  children: [
                    Icon(Icons.trending_up),
                    SizedBox(width: 8),
                    Text('Sort by Votes'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortBy.date,
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 8),
                    Text('Sort by Date'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (_) => _onTabChanged(),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: BlocConsumer<FeatureCubit, FeatureState>(
        listener: (context, state) {
          if (state is FeatureError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is FeatureLoaded && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
            context.read<FeatureCubit>().clearSuccessMessage();
          }
        },
        builder: (context, state) {
          if (state is FeatureLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FeatureLoaded) {
            if (state.features.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No features found',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<FeatureCubit>().refreshFeatures();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.features.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FeatureCard(
                      feature: state.features[index],
                      onVote: () {
                        context.read<FeatureCubit>().voteFeature(
                          featureId: state.features[index].id,
                          userId: 'current_user',
                        );
                      },
                      hasVoted: state.features[index].hasUserVoted(
                        'current_user',
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is FeatureError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FeatureCubit>().refreshFeatures();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Welcome to Feature Voting!'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => getIt<FeatureCubit>(),
                child: const AddFeaturePage(),
              ),
            ),
          );
          if (result == true) {
            context.read<FeatureCubit>().refreshFeatures();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Feature'),
      ),
    );
  }
}
