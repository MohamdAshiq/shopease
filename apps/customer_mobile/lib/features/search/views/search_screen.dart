import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopease_core/shopease_core.dart';

import '../cubits/search_cubit.dart';
import '../cubits/search_state.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_empty_state.dart';
import '../widgets/search_recent_section.dart';
import '../widgets/search_results_grid.dart';

// Search Screen
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(initialQuery: initialQuery),
      child: const _SearchScreenView(),
    );
  }
}

class _SearchScreenView extends StatefulWidget {
  const _SearchScreenView();

  @override
  State<_SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<_SearchScreenView> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SearchCubit>();
    _searchController = TextEditingController(text: cubit.state.searchQuery);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _applySearch(String term) {
    _searchController.text = term;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    context.read<SearchCubit>().submitSearch(term);
    _focusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchCubit>().updateQuery('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: SearchAppBar(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: cubit.updateQuery,
            onSubmitted: (term) {
              cubit.submitSearch(term);
              _focusNode.unfocus();
            },
            onClear: _clearSearch,
          ),
          body: state.isIdle
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: SearchRecentSection(
                    recentSearches: state.recentSearches,
                    isLoading: state.isLoadingHistory,
                    onTapItem: _applySearch,
                    onRemoveItem: cubit.removeRecentSearch,
                    onClearAll: cubit.clearRecentSearches,
                  ),
                )
              : state.hasResults
              ? SearchResultsGrid(
                  products: state.searchResults,
                  query: state.searchQuery,
                  onProductTap: () => cubit.submitSearch(state.searchQuery),
                )
              : SearchEmptyState(
                  query: state.searchQuery,
                  onClearQuery: _clearSearch,
                ),
        );
      },
    );
  }
}
