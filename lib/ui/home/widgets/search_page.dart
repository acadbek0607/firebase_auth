import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

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
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    contracts = (args?['allContracts'] as List?)?.cast<ContractEntity>() ?? [];
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
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _query = val.trim()),
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search contracts...',
            hintStyle: const TextStyle(color: Colors.grey),
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

          final contracts = state.contracts;

          final results = _query.isEmpty
              ? []
              : contracts.where((contract) {
                  final query = _query.toLowerCase();
                  final fullName = contract.fullName.toLowerCase();
                  final status = contract.status.label.toLowerCase();
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
            return const Center(
              child: Text(
                'No results found.',
                style: TextStyle(color: Colors.grey),
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
                allContracts: contracts,
              );
            },
          );
        },
      ),
    );
  }
}
