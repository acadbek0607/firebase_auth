import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/detail/widgets/suggestion_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';

class SearchPage extends StatefulWidget {
  final List<ContractEntity>? allContracts;

  const SearchPage({super.key, this.allContracts});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  late List<ContractEntity> contracts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    contracts =
        widget.allContracts ??
        (args?['allContracts'] as List?)?.cast<ContractEntity>() ??
        <ContractEntity>[];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _query = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withAlpha(210),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: SuggestionFormField(
          prefsKey: 'search_queries',
          controller: _searchController,
          onChanged: (val) => setState(() => _query = val.trim()),
          style: Kstyle.textStyle,
          decoration: InputDecoration(
            hintText: tr('search', context: context),
            hintStyle: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(icon: const Icon(Icons.close), onPressed: _clearSearch),
        ],
      ),
      body: BlocBuilder<ContractBloc, ContractState>(
        builder: (context, state) {
          if (state.status != BlocStatus.loaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final source = contracts.isNotEmpty ? contracts : state.contracts;

          final results = _query.isEmpty
              ? []
              : source.where((contract) {
                  final query = _query.toLowerCase();
                  final fullName = contract.fullName.toLowerCase();
                  final status = contract.status.label(context).toLowerCase();
                  final amount = contract.amount.toString();
                  final sum = contract.contractCount?.toString() ?? '';
                  final lastInvoice = contract.lastContractId?.toString() ?? '';
                  final created = DateFormat(
                    'dd.MM.yyyy',
                  ).format(contract.createdAt);

                  return fullName.contains(query) ||
                      status.contains(query) ||
                      amount.contains(query) ||
                      sum.contains(query) ||
                      lastInvoice.contains(query) ||
                      created.contains(query);
                }).toList();

          if (_query.isNotEmpty && results.isEmpty) {
            return Center(
              child: Text(
                tr('no_results_found', context: context),
                style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              return ContractCard(
                contract: results[index],
                allContracts: source,
              );
            },
          );
        },
      ),
    );
  }
}

Future<Future<Object?>> showSearchPageDialog(
  BuildContext context, {
  List<ContractEntity>? contracts,
}) async {
  return showGeneralDialog(
    barrierColor: Colors.transparent,
    context: context,
    barrierDismissible: true,
    barrierLabel: 'SearchPageDialog',
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) {
      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: Container(color: Colors.transparent),
            ),
          ),
          SearchPage(allContracts: contracts),
        ],
      );
    },
  );
}
