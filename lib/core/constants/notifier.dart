import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/home/page/home_page.dart';
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
