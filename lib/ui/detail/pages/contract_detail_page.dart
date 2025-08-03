// contract_detail_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/ui/detail/bloc/related_bloc.dart';
import 'package:fire_auth/ui/detail/widgets/contract_detail_info_card.dart';
import 'package:fire_auth/ui/detail/widgets/delete_contract_dialog.dart';
import 'package:fire_auth/ui/home/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContractDetailPage extends StatefulWidget {
  final ContractEntity contract;
  final List<ContractEntity> allContracts;
  final bool openFromDetail;

  const ContractDetailPage({
    super.key,
    required this.contract,
    required this.allContracts,
    this.openFromDetail = false,
  });

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    if (widget.contract.id != null) {
      context.read<ProfileBloc>().add(CheckSavedStatus(widget.contract.id!));
    }
    context.read<RelatedBloc>().add(
      LoadRelatedContracts(fullName: widget.contract.fullName),
    );
  }

  Future<bool> _onPop() async {
    if (widget.openFromDetail) {
      Navigator.pop(context);
      return false;
    }

    selectedPageNotifier.value = detailOriginIndexNotifier.value;
    selectedViewNotifier.value = HomeViewType.contract;

    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/main');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final contract = widget.contract;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onPop(),
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.black,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 0, 14),
            child: SvgPicture.asset('assets/svg/contract.svg'),
          ),
          title: Text(
            '№ ${contract.id}',
            style: Kstyle.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          actions: [
            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state.status == BlocStatus.loaded && contract.id != null) {
                  setState(() {
                    isSaved = state.savedContractIds.contains(contract.id);
                  });
                } else if (state.status == BlocStatus.error) {
                  setState(() => isSaved = !isSaved);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        tr('failed_to_save_contract', context: context),
                      ),
                      backgroundColor: AppColors.statusRejected,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return IconButton(
                  icon: isSaved
                      ? SvgPicture.asset('assets/svg/s_saved.svg')
                      : SvgPicture.asset('assets/svg/saved.svg'),
                  onPressed: () {
                    if (contract.id != null) {
                      setState(() => isSaved = !isSaved);
                      context.read<ProfileBloc>().add(
                        ToggleSavedContractEvent(contract.id!),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContractDetailInfoCard(
                contract: contract,
                allContracts: widget.allContracts,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => showDeleteContractDialog(
                          context,
                          contract.id!,
                          contract,
                        ),
                        style: Kstyle.buttonStyle.copyWith(
                          backgroundColor: WidgetStateProperty.all(
                            AppColors.statusRejected.withAlpha(60),
                          ),
                          elevation: WidgetStateProperty.all(0.0),
                        ),
                        child: Text(
                          tr('delete_contract', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.statusRejected,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          selectedPageNotifier.value = 5;
                          Navigator.pushReplacementNamed(context, '/main');
                        },
                        style: Kstyle.buttonStyle.copyWith(
                          backgroundColor: WidgetStateProperty.all(
                            AppColors.darkGreen,
                          ),
                        ),
                        child: Text(
                          tr('create_contract', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${tr('other_contracts', context: context)} ${contract.fullName}',
                style: Kstyle.textStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<RelatedBloc, RelatedState>(
                  builder: (context, state) {
                    final others = state.relatedContracts
                        .where(
                          (c) =>
                              c.id != contract.id &&
                              c.fullName == contract.fullName,
                        )
                        .toList();
                    return ContractsPage(
                      contracts: others,
                      canLoadMore: state.canLoadMore,
                      isLoadingMore: state.isLoadingMore,
                      openFromDetail: true,
                      originIndex: detailOriginIndexNotifier.value,
                      onLoadMore: () {
                        context.read<RelatedBloc>().add(
                          LoadRelatedContracts(
                            fullName: contract.fullName,
                            startAfterDoc: state.lastDocSnap,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
