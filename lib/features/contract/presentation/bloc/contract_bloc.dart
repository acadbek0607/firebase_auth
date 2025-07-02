import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/helpers/metadata_helper.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/contract_usecases.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final CreateContract createContract;
  final UpdateContract updateContract;
  final DeleteContract deleteContract;
  final GetContracts getContracts;

  List<ContractEntity> _allContracts = [];

  ContractBloc({
    required this.createContract,
    required this.updateContract,
    required this.deleteContract,
    required this.getContracts,
  }) : super(ContractState.initial()) {
    on<LoadContracts>(_onLoadContracts);
    on<CreateContractEvent>(_onCreateContract);
    on<UpdateContractEvent>(_onUpdateContract);
    on<DeleteContractEvent>(_onDeleteContract);
    on<FilterContractsEvent>(_onFilterContracts);
  }

  Future<void> _onLoadContracts(
    LoadContracts event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: null));
    try {
      final contracts = await getContracts();
      final enriched = enrichContracts(contracts);
      _allContracts = enriched; // Save for filtering
      emit(state.copyWith(status: BlocStatus.loaded, contracts: enriched));
    } catch (e) {
      emit(
        state.copyWith(status: BlocStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onCreateContract(
    CreateContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    try {
      await createContract(event.contract);
      add(LoadContracts());
    } catch (e) {
      emit(
        state.copyWith(status: BlocStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateContract(
    UpdateContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    try {
      await updateContract(event.contract);
      add(LoadContracts());
    } catch (e) {
      emit(
        state.copyWith(status: BlocStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDeleteContract(
    DeleteContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    try {
      await deleteContract(event.contractId);
      add(LoadContracts());
    } catch (e) {
      emit(
        state.copyWith(status: BlocStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFilterContracts(
    FilterContractsEvent event,
    Emitter<ContractState> emit,
  ) async {
    List<ContractEntity> filtered = _allContracts;

    if (event.status != null) {
      filtered = filtered.where((c) => c.status == event.status).toList();
    }

    if (event.from != null) {
      filtered = filtered
          .where((c) => c.createdAt.isAfter(event.from!))
          .toList();
    }

    if (event.to != null) {
      filtered = filtered
          .where((c) => c.createdAt.isBefore(event.to!))
          .toList();
    }

    emit(state.copyWith(status: BlocStatus.loaded, contracts: filtered));
  }
}
