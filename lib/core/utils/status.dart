import 'package:flutter/material.dart';

enum StatusType { paid, inProcess, rejectedByPayme, rejectedByIQ }

extension StatusTypeExtension on StatusType {
  String get label {
    switch (this) {
      case StatusType.paid:
        return 'Paid';
      case StatusType.inProcess:
        return 'In Process';
      case StatusType.rejectedByPayme:
        return 'Rejected by Payme';
      case StatusType.rejectedByIQ:
        return 'Rejected by IQ';
    }
  }

  Color get color {
    switch (this) {
      case StatusType.paid:
        return const Color(0xff00C566);
      case StatusType.inProcess:
        return const Color(0xffFFB800);
      case StatusType.rejectedByPayme:
        return const Color(0xffFF426D);
      case StatusType.rejectedByIQ:
        return const Color(0xffFF426D);
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
