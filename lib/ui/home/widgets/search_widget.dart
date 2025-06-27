import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';

class SearchWidget extends StatefulWidget {
  final VoidCallback onClose;

  const SearchWidget({super.key, required this.onClose});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onClose,
        child: Stack(
          children: [
            // 👇 Blur + Dimmed Background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withAlpha(77), // translucent dark overlay
              ),
            ),

            // 👇 Centered Search Box
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
              child: GestureDetector(
                onTap: () {}, // prevent tap-through
                child: _buildSearchBox(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        if (state is! ContractLoaded) return const SizedBox.shrink();
        final contracts = state.contracts;
        final results = _query.isEmpty
            ? []
            : contracts
                  .where(
                    (c) =>
                        c.fullName.toLowerCase().contains(_query.toLowerCase()),
                  )
                  .toList();

        return Material(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (val) => setState(() => _query = val.trim()),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by full name',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF2C2C2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (_, index) {
                      final contract = results[index];
                      return ListTile(
                        title: Text(
                          contract.fullName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '№ ${contract.id ?? '--'}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/contract_detail',
                            arguments: {
                              'contract': contract,
                              'allContracts': contracts,
                            },
                          );
                          widget.onClose();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
