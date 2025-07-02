import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  bool showSearch = false;

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
                  // Get latest contracts from bloc state
                  final state = context.read<ContractBloc>().state;
                  if (state.status == BlocStatus.loaded) {
                    Navigator.pushNamed(
                      context,
                      '/filter',
                      arguments: {'allContracts': state.contracts},
                    );
                  }
                },
              ),
              SizedBox(width: 4.0),
              SvgPicture.asset('assets/svg/divider.svg'),
              SizedBox(width: 4.0),
              IconButton(
                icon: SvgPicture.asset('assets/svg/search.svg', height: 20.0),
                onPressed: () => Navigator.pushNamed(context, '/search'),
              ),
              SizedBox(width: 16.0),
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

                if (savedContracts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/bookmark.svg',
                          height: 88.0,
                          colorFilter: ColorFilter.mode(
                            Color(0xFF323232),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(height: 16.0),
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
                  itemCount: savedContracts.length,
                  itemBuilder: (_, i) {
                    return ContractCard(
                      contract: savedContracts[i],
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
