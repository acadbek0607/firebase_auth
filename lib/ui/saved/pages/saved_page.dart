import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/filter_utils.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';
import 'package:fire_auth/ui/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  FilterWidget currentFilter = FilterWidget.empty;
  List<ContractEntity>? filteredContracts;

  bool get isFiltered => currentFilter != FilterWidget.empty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset('assets/svg/filter.svg', height: 24.0),
                onPressed: () async {
                  final contractState = context.read<ContractBloc>().state;
                  final profileState = context.read<ProfileBloc>().state;

                  if (contractState.status == BlocStatus.loaded &&
                      profileState.status == BlocStatus.loaded) {
                    final allContracts = contractState.contracts;
                    final savedIds = profileState.profile!.savedContractIds;
                    final savedContracts = allContracts
                        .where((c) => savedIds.contains(c.id))
                        .toList();

                    final result = await Navigator.pushNamed(
                      context,
                      '/filter',
                      arguments: {
                        'allContracts': savedContracts,
                        'currentFilter': currentFilter,
                        'originIndex': 2,
                      },
                    );

                    if (result != null && result is FilterWidget) {
                      setState(() {
                        currentFilter = result;
                        filteredContracts = isFiltered
                            ? FilterUtils.apply(savedContracts, result)
                            : null;
                      });
                    }
                  }
                },
              ),
              const SizedBox(width: 4.0),
              SvgPicture.asset('assets/svg/divider.svg'),
              const SizedBox(width: 4.0),
              IconButton(
                icon: SvgPicture.asset('assets/svg/search.svg', height: 20.0),
                onPressed: () {
                  final state = context.read<ContractBloc>().state;
                  final savedIds =
                      context
                          .read<ProfileBloc>()
                          .state
                          .profile
                          ?.savedContractIds ??
                      [];

                  if (state.status == BlocStatus.loaded) {
                    final savedContracts = state.contracts
                        .where((c) => savedIds.contains(c.id))
                        .toList();

                    Navigator.pushNamed(
                      context,
                      '/search',
                      arguments: {
                        'allContracts': savedContracts,
                        'originIndex': 4,
                      },
                    );
                  }
                },
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState.status != BlocStatus.loaded) {
            return const Center(child: Text('No saved contracts.'));
          }

          final savedIds = profileState.profile!.savedContractIds;

          return BlocBuilder<ContractBloc, ContractState>(
            builder: (context, contractState) {
              if (contractState.status == BlocStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (contractState.status == BlocStatus.loaded) {
                final allContracts = contractState.contracts;
                final savedContracts = allContracts
                    .where((c) => savedIds.contains(c.id))
                    .toList();

                final contractsToShow = isFiltered
                    ? (filteredContracts ??
                          FilterUtils.apply(savedContracts, currentFilter))
                    : savedContracts;

                if (contractsToShow.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/bookmark.svg',
                          height: 88.0,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF323232),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'No saved contracts.',
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

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: contractsToShow.length,
                  itemBuilder: (_, i) {
                    return ContractCard(
                      contract: contractsToShow[i],
                      allContracts: allContracts,
                    );
                  },
                );
              } else {
                return const Center(child: Text('Failed to load contracts.'));
              }
            },
          );
        },
      ),
    );
  }
}
