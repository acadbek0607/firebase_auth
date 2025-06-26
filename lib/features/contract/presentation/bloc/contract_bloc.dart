import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/helpers/metadata_helper.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/contract_usecases.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final CreateContract createContract;
  final UpdateContract updateContract;
  final DeleteContract deleteContract;
  final GetContracts getContracts;

  ContractBloc({
    required this.createContract,
    required this.updateContract,
    required this.deleteContract,
    required this.getContracts,
  }) : super(ContractInitial()) {
    on<LoadContracts>(_onLoadContracts);
    on<CreateContractEvent>(_onCreateContract);
    on<UpdateContractEvent>(_onUpdateContract);
    on<DeleteContractEvent>(_onDeleteContract);
  }

  Future<void> _onLoadContracts(
    LoadContracts event,
    Emitter<ContractState> emit,
  ) async {
    emit(ContractLoading());
    try {
      final contracts = await getContracts.call();
      final enriched = enrichContracts(contracts);
      emit(ContractLoaded(enriched));
    } catch (e) {
      emit(ContractError(e.toString()));
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
      emit(ContractError(e.toString()));
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
      emit(ContractError(e.toString()));
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
      emit(ContractError(e.toString()));
    }
  }
}
