import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/home/page/home_page.dart';
import 'package:fire_auth/ui/widgets/filters.dart';
import 'package:flutter/material.dart';

final ValueNotifier<HomeViewType> selectedViewNotifier = ValueNotifier(
  HomeViewType.contract,
);
ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);

final ValueNotifier<List<ContractEntity>> allContractsNotifier = ValueNotifier(
  [],
);

final savedContractsNotifier = ValueNotifier<List<ContractEntity>>([]);

final ValueNotifier<UserEntity?> currentUserNotifier = ValueNotifier(null);

/// Holds the currently built FilterPage widget when it is active.
final ValueNotifier<Widget?> filterPageNotifier = ValueNotifier(null);

/// Remembers the index of the page from which the FilterPage was opened.
final ValueNotifier<int> filterOriginIndexNotifier = ValueNotifier(0);

/// Stores the active [Filters] for each page by its index.
final ValueNotifier<Map<int, Filters>> activeFiltersNotifier = ValueNotifier(
  <int, Filters>{},
);

/// Holds the currently built ContractDetailPage widget when it is active.
final ValueNotifier<Widget?> detailPageNotifier = ValueNotifier(null);

/// Remembers the index of the page from which the ContractDetailPage was opened.
final ValueNotifier<int> detailOriginIndexNotifier = ValueNotifier(0);
