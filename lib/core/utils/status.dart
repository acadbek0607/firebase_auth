import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum StatusType { paid, inProcess, rejectedByPayme, rejectedByIQ }

extension StatusTypeExtension on StatusType {
  String get label {
    switch (this) {
      case StatusType.paid:
        return tr('paid');
      case StatusType.inProcess:
        return tr('in_process');
      case StatusType.rejectedByPayme:
        return tr('rejected_payme');
      case StatusType.rejectedByIQ:
        return tr('rejected_iq');
    }
  }

  Color get color {
    switch (this) {
      case StatusType.paid:
        return const Color(0xFF49B7A5);
      case StatusType.inProcess:
        return const Color(0xFFFDAB2A);
      case StatusType.rejectedByPayme:
        return const Color(0xFFFF426D);
      case StatusType.rejectedByIQ:
        return const Color(0xFFFF426D);
    }
  }

  static StatusType fromString(String status) {
    return StatusType.values.firstWhere(
      (e) => e.name == status,
      orElse: () => StatusType.inProcess,
    );
  }

  static StatusType fromLabel(String label) {
    return StatusType.values.firstWhere((e) => e.label == label);
  }

  String toFirestoreString() {
    return name;
  }
}
