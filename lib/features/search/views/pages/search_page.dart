import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/search/cubit/search_cubit.dart';
import 'package:news_app/features/search/cubit/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        context.read<SearchCubit>().search(query.trim());
      } else {
        context.read<SearchCubit>().clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _onSearchChanged,
          cursorColor: AppColors.catGeneral,
          style: const TextStyle(fontWeight: FontWeight.bold),
          cursorErrorColor: AppColors.catHealth,
          
          decoration: const InputDecoration(
            hintText: 'Search news...',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.catGeneral),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            filled: true,
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchSuccess) {
            return ListView.builder(
              itemCount: state.response.articles!.length,
              itemBuilder: (context, index) {
                final article = state.response.articles![index];
                return ListTile(
                  title: Text(article.title ?? 'No Title'),
                  subtitle: Text(article.description ?? ''),
                );
              },
            );
          }
          if (state is SearchFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
