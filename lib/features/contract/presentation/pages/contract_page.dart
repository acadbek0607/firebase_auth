// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';

class ContractsPage extends StatefulWidget {
  final List<ContractEntity> contracts;
  final bool canLoadMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const ContractsPage({
    super.key,
    required this.contracts,
    this.canLoadMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  int _itemsToShow = 20;
  bool _isLoadingMore = false;

  void _loadMore(int total) async {
    if (_isLoadingMore || _itemsToShow >= total) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingMore = false;
      _itemsToShow = (_itemsToShow + 10).clamp(0, total);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingMore && widget.contracts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.contracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/contracts.svg',
              colorFilter: ColorFilter.mode(Color(0xFF323232), BlendMode.srcIn),
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
    return ListView.builder(
      itemCount:
          widget.contracts.length +
          (widget.canLoadMore || widget.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < widget.contracts.length) {
          final contract = widget.contracts[index];
          return ContractCard(
            contract: contract,
            allContracts: widget.contracts,
          );
        } else {
          if (widget.isLoadingMore) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  "Loading...",
                  style: Kstyle.textStyle.copyWith(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00A795),
                  ),
                ),
              ),
            );
          }
          if (!widget.canLoadMore) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: widget.onLoadMore,
                style: Kstyle.buttonStyle,
                child: Text('Load more', style: Kstyle.textStyle),
              ),
            ),
          );
        }
      },
    );
  }
}
