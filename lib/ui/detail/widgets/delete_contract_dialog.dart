// delete_contract_dialog.dart
import 'package:easy_localization/easy_localization.dart';
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
            insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27.0),
              child: Text(
                tr('delete_title', context: context),
                style: Kstyle.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            content: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: const Color(0xFF5C5C5C),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                onChanged: (val) => setState(() => canDelete = val.isNotEmpty),
                decoration: Kstyle.textFieldStyle.copyWith(
                  hintText: tr('comment', context: context),
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
              if (canDelete) ...{
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: Kstyle.buttonStyle.copyWith(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xFFFF426D).withAlpha(38),
                          ),
                        ),
                        child: Text(
                          tr('cancel', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF426D),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton(
                        style: Kstyle.buttonStyle.copyWith(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xFFFF426D),
                          ),
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
                        child: Text(
                          tr('done', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              },
            ],
          );
        },
      );
    },
  );
}
