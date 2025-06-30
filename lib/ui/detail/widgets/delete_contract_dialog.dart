// delete_contract_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';

void showDeleteContractDialog(
  BuildContext context,
  String contractId,
  ContractEntity contract,
) {
  final controller = TextEditingController();
  bool canDelete = false;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2a2a2d),
            title: Text(
              'Why do you want to delete this contract?',
              style: Kstyle.textStyle,
              textAlign: TextAlign.center,
            ),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: const Color(0xFF5C5C5C),
              ),
              child: TextField(
                controller: controller,
                maxLines: 3,
                onChanged: (val) => setState(() => canDelete = val.isNotEmpty),
                decoration: Kstyle.textFieldStyle.copyWith(
                  hintText: 'Enter reason...',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: Kstyle.buttonStyle,
                child: const Text('Cancel'),
              ),
              if (canDelete)
                ElevatedButton(
                  style: Kstyle.buttonStyle.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    context.read<ProfileBloc>().add(
                      ToggleSavedContractEvent(contract.id!),
                    );
                    context.read<ContractBloc>().add(
                      DeleteContractEvent(contractId),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
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
