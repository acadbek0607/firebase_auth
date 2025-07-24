import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/filter_utils.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/ui/saved/bloc/saved_bloc.dart';
import 'package:fire_auth/ui/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  Filters currentFilter = Filters.empty;
  List<ContractEntity>? filteredContracts;

  bool get isFiltered => currentFilter != Filters.empty;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    if (profileState.status == BlocStatus.loaded) {
      _loadInitial(profileState.profile!.savedContractIds);
    }
  }

  void _loadInitial(List<String> ids) {
    context.read<SavedBloc>().add(LoadSavedContracts(ids: ids));
  }

  void _loadMore(List<String> ids) {
    context.read<SavedBloc>().add(LoadSavedContracts(ids: ids, loadMore: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('saved'),
          style: Kstyle.textStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset('assets/svg/filter.svg', height: 16.0),
                onPressed: () async {
                  final savedState = context.read<SavedBloc>().state;
                  if (savedState.status == BlocStatus.loaded) {
                    final savedContracts = savedState.contracts;

                    final result = await Navigator.pushNamed(
                      context,
                      '/filter',
                      arguments: {
                        'allContracts': savedContracts,
                        'currentFilter': currentFilter,
                        'originIndex': 2,
                      },
                    );

                    if (result != null && result is Filters) {
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
                icon: SvgPicture.asset('assets/svg/search.svg', height: 16.0),
                onPressed: () {
                  final state = context.read<SavedBloc>().state;

                  if (state.status == BlocStatus.loaded) {
                    final savedContracts = state.contracts;

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
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (p, c) => p.savedContractIds != c.savedContractIds,
        listener: (context, profileState) {
          if (profileState.status == BlocStatus.loaded) {
            _loadInitial(profileState.profile!.savedContractIds);
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState.status != BlocStatus.loaded) {
              return Center(
                child: Text(tr('no_saved_contracts', context: context)),
              );
            }

            final savedIds = profileState.profile!.savedContractIds;

            return BlocBuilder<SavedBloc, SavedContractsState>(
              builder: (context, state) {
                if (state.status == BlocStatus.initial) {
                  _loadInitial(savedIds);
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == BlocStatus.loading &&
                    state.contracts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == BlocStatus.loaded ||
                    state.isLoadingMore) {
                  final contractsToShow = isFiltered
                      ? (filteredContracts ??
                            FilterUtils.apply(state.contracts, currentFilter))
                      : state.contracts;

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
                            tr('no_saved_contracts', context: context),
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

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                    child: ContractsPage(
                      contracts: contractsToShow,
                      canLoadMore: state.canLoadMore,
                      isLoadingMore: state.isLoadingMore,
                      onLoadMore: () => _loadMore(savedIds),
                      openFromDetail: true,
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      tr('failed_to_load_contracts', context: context),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
