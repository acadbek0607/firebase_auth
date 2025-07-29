import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum StatusType { paid, inProcess, rejectedByPayme, rejectedByIQ }

extension StatusTypeExtension on StatusType {
  String label(BuildContext context) {
    switch (this) {
      case StatusType.paid:
        return tr('paid', context: context);
      case StatusType.inProcess:
        return tr('in_process', context: context);
      case StatusType.rejectedByPayme:
        return tr('rejected_payme', context: context);
      case StatusType.rejectedByIQ:
        return tr('rejected_iq', context: context);
    }
  }

  Color get color {
    switch (this) {
      case StatusType.paid:
        return AppColors.statusPaid;
      case StatusType.inProcess:
        return AppColors.statusInProcess;
      case StatusType.rejectedByPayme:
        return AppColors.statusRejected;
      case StatusType.rejectedByIQ:
        return AppColors.statusRejected;
    }
  }

  static StatusType fromString(String status) {
    return StatusType.values.firstWhere(
      (e) => e.name == status,
      orElse: () => StatusType.inProcess,
    );
  }

  static StatusType fromLabel(String label, BuildContext context) {
    return StatusType.values.firstWhere(
      (e) => e.label(context) == label,
      orElse: () => StatusType.inProcess,
    );
  }

  String toFirestoreString() {
    return name;
  }
}
