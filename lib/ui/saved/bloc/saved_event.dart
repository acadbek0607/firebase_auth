part of 'saved_bloc.dart';

sealed class SavedContractsEvent extends Equatable {
  const SavedContractsEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedContracts extends SavedContractsEvent {
  final List<String> ids;
  final bool loadMore;
  final int limit;

  const LoadSavedContracts({
    required this.ids,
    this.loadMore = false,
    this.limit = 10,
  });

  @override
  List<Object> get props => [ids, loadMore, limit];
}
