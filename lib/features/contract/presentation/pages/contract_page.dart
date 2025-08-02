// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';

class ContractsPage extends StatelessWidget {
  final List<ContractEntity> contracts;
  final bool canLoadMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final bool openFromDetail;
  final int originIndex;

  const ContractsPage({
    super.key,
    required this.contracts,
    this.canLoadMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.openFromDetail = false,
    this.originIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore && contracts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (contracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/s_contracts.svg',
              height: 88.0,
              colorFilter: ColorFilter.mode(
                AppColors.iconBlur,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              tr('no_contracts', context: context),
              style: Kstyle.textStyle.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.iconBlur,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: contracts.length + (canLoadMore || isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < contracts.length) {
          final contract = contracts[index];
          return ContractCard(
            contract: contract,
            allContracts: contracts,
            openFromDetail: openFromDetail,
            originIndex: originIndex,
          );
        } else {
          if (isLoadingMore) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  tr('loading', context: context),
                  style: Kstyle.textStyle.copyWith(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightGreen,
                  ),
                ),
              ),
            );
          }
          if (!canLoadMore) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: onLoadMore,
                style: Kstyle.buttonStyle,
                child: Text(
                  tr('load_more', context: context),
                  style: Kstyle.textStyle,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
