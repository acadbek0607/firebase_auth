// lib/features/contract/domain/entities/contract_filter.dart
import 'package:fire_auth/core/utils/status.dart';

class Filters {
  final List<StatusType> statuses;
  final DateTime? fromDate;
  final DateTime? toDate;
  const Filters({this.statuses = const [], this.fromDate, this.toDate});
  Filters copyWith({
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
  }) => Filters(
    statuses: statuses ?? this.statuses,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
  );
  static const empty = Filters();
  @override
  bool operator ==(Object other) =>
      other is Filters &&
      _listEquals(statuses, other.statuses) &&
      fromDate == other.fromDate &&
      toDate == other.toDate;
  @override
  int get hashCode => Object.hash(statuses, fromDate, toDate);
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
