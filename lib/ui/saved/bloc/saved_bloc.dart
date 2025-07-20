import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/usecases/get_contracts_by_ids.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedContractsEvent, SavedContractsState> {
  final GetContractsByIds getContractsByIds;

  SavedBloc({required this.getContractsByIds}) : super(SavedContractsState()) {
    on<LoadSavedContracts>(_onLoadSavedContracts);
  }

  Future<void> _onLoadSavedContracts(
    LoadSavedContracts event,
    Emitter<SavedContractsState> emit,
  ) async {
    final ids = event.ids;
    final startIndex = event.loadMore ? state.nextIndex : 0;
    final chunk = ids.skip(startIndex).take(event.limit).toList();

    if (chunk.isEmpty) {
      emit(state.copyWith(canLoadMore: false, isLoadingMore: false));
      return;
    }

    if (event.loadMore) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(status: BlocStatus.loading, errorMessage: null));
    }

    try {
      final contracts = await getContractsByIds(chunk);
      final allContracts = event.loadMore
          ? [...state.contracts, ...contracts]
          : contracts;
      final newIndex = startIndex + chunk.length;
      final canLoadMore = newIndex < ids.length;
      emit(
        state.copyWith(
          status: BlocStatus.loaded,
          contracts: allContracts,
          nextIndex: newIndex,
          canLoadMore: canLoadMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          errorMessage: e.toString(),
          isLoadingMore: false,
        ),
      );
      return;
    }
  }
}
