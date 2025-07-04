// contract_detail_page.dart
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/ui/detail/widgets/contract_detail_info_card.dart';
import 'package:fire_auth/ui/detail/widgets/delete_contract_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContractDetailPage extends StatefulWidget {
  final ContractEntity contract;
  final List<ContractEntity> allContracts;

  const ContractDetailPage({
    super.key,
    required this.contract,
    required this.allContracts,
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
  }

  Future<bool> _onPop() async {
    selectedPageNotifier.value = 0;
    Navigator.pushReplacementNamed(context, '/main');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final contract = widget.contract;
    final relatedContracts = widget.allContracts
        .where((c) => c.fullName == contract.fullName && c.id != contract.id)
        .toList();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onPop(),
      child: Scaffold(
        appBar: AppBar(
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
                    const SnackBar(
                      content: Text('Failed to save contract.'),
                      backgroundColor: Colors.red,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContractDetailInfoCard(contract: contract),
              const SizedBox(height: 20),
              Row(
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
                          Colors.red.withAlpha(60),
                        ),
                        elevation: WidgetStateProperty.all(0.0),
                      ),
                      child: Text(
                        'Delete contract',
                        style: Kstyle.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffFF426D),
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
                          const Color(0xff008F7F),
                        ),
                      ),
                      child: Text(
                        'Create contract',
                        style: Kstyle.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Other contracts with ${contract.fullName}',
                style: Kstyle.textStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: relatedContracts.length,
                  itemBuilder: (_, i) {
                    return ContractCard(
                      contract: relatedContracts[i],
                      allContracts: widget.allContracts,
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
