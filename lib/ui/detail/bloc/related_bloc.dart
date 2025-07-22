import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/usecases/get_contracts_by_fullname.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'related_event.dart';
part 'related_state.dart';

class RelatedBloc extends Bloc<RelatedEvent, RelatedState> {
  final GetContractsByFullName getContractsByFullName;

  RelatedBloc({required this.getContractsByFullName})
    : super(RelatedInitial()) {
    on<LoadRelatedContracts>(_onLoadRelatedContracts);
  }

  Future<void> _onLoadRelatedContracts(
    LoadRelatedContracts event,
    Emitter<RelatedState> emit,
  ) async {
    if (event.startAfterDoc != null) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(status: BlocStatus.loading, errorMessage: null));
    }

    try {
      final result = await getContractsByFullName(
        fullName: event.fullName,
        startAfterDoc: event.startAfterDoc,
        limit: event.limit,
      );
      final contracts = result.contracts;
      final lastDoc = result.lastDoc;
      final canLoadMore = contracts.length == event.limit;
      emit(
        state.copyWith(
          status: BlocStatus.loaded,
          relatedContracts: event.startAfterDoc != null
              ? [...state.relatedContracts, ...contracts]
              : contracts,
          lastDocSnap: lastDoc,
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
    }
  }
}
