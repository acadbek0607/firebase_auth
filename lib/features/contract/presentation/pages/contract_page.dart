// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fire_auth/ui/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';

class ContractsPage extends StatelessWidget {
  final List<ContractEntity>? filteredContracts;

  const ContractsPage({super.key, this.filteredContracts});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == BlocStatus.loaded) {
          final contracts = filteredContracts ?? state.contracts;

          if (contracts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/contracts.svg',
                    colorFilter: ColorFilter.mode(
                      Color(0xFF323232),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    "No contracts available",
                    style: Kstyle.textStyle.copyWith(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF323232),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ContractBloc>().add(LoadContracts());
            },
            child: ListView.builder(
              itemCount: contracts.length,
              itemBuilder: (context, index) {
                final contract = contracts[index];
                return ContractCard(
                  contract: contract,
                  allContracts: contracts,
                );
              },
            ),
          );
        } else if (state.status == BlocStatus.error) {
          return Center(child: Text("Error: ${state.errorMessage!}"));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
