import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractDetailPage extends StatelessWidget {
  final ContractEntity contract;
  final List<ContractEntity> allContracts;

  const ContractDetailPage({
    super.key,
    required this.contract,
    required this.allContracts,
  });

  void _showDeleteDialog(BuildContext context, String contractId) {
    final controller = TextEditingController();
    bool canDelete = false;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xFF2a2a2d),
              title: Text(
                'Why do you want to delete this contract?',
                style: Kstyle.textStyle,
                textAlign: TextAlign.center,
              ),
              content: TextField(
                controller: controller,
                maxLines: 3,
                onChanged: (val) => setState(() => canDelete = val.isNotEmpty),
                decoration: Kstyle.textFieldStyle.copyWith(
                  hintText: 'Enter reason...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                if (canDelete)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      context.read<ContractBloc>().add(
                        DeleteContractEvent(contractId),
                      );
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // go back from detail
                    },
                    child: const Text('Delete'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final relatedContracts = allContracts
        .where((c) => c.fullName == contract.fullName && c.id != contract.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Contract Detail')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: const Color(0xFF1E1E20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailText('Fisher’s full name', contract.fullName),
                      _detailText('Status', contract.status.label),
                      _detailText('Amount', '${contract.amount}'),
                      _detailText('Address', contract.organizationAddress),
                      _detailText('ITN/IEC', contract.inn),
                      _detailText('Created at', contract.createdAt.toString()),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showDeleteDialog(context, contract.id!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withAlpha(60),
                      elevation: 0,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff008F7F),
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
                    allContracts: allContracts,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Color(0xFF999999),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
