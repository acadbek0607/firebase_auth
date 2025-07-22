part of 'related_bloc.dart';

sealed class RelatedEvent extends Equatable {
  const RelatedEvent();

  @override
  List<Object> get props => [];
}

class LoadRelatedContracts extends RelatedEvent {
  final String fullName;
  final DocumentSnapshot? startAfterDoc;
  final int limit;

  const LoadRelatedContracts({
    required this.fullName,
    this.startAfterDoc,
    this.limit = 10,
  });
}
