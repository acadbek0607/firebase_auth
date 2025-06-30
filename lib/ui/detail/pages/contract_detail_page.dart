// contract_detail_page.dart
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/ui/detail/widgets/contract_detail_info_card.dart';
import 'package:fire_auth/ui/detail/widgets/delete_contract_dialog.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
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

class _ContractDetailPageState extends State<ContractDetailPage> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    if (widget.contract.id != null) {
      context.read<ProfileBloc>().add(CheckSavedStatus(widget.contract.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final contract = widget.contract;
    final relatedContracts = widget.allContracts
        .where((c) => c.fullName == contract.fullName && c.id != contract.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Detail'),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded && contract.id != null) {
                isSaved = state.savedContractIds.contains(contract.id);
              }

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
                      Navigator.pushNamed(context, '/create_contract');
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
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
