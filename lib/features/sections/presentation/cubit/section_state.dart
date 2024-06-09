part of 'section_cubit.dart';

sealed class SectionState extends Equatable {
  const SectionState();

  @override
  List<Object> get props => [];
}

class SectionInitial extends SectionState {}

class SectionLoading extends SectionState {}

class SectionLoaded extends SectionState {
  final List<SectionEntity> items;

  const SectionLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class SectionSuccess extends SectionState {
  final SectionEntity item;

  const SectionSuccess(this.item);

  @override
  List<Object> get props => [item];
}

class SectionSuccessMessage extends SectionState {
  final String message;

  const SectionSuccessMessage(this.message);

  @override
  List<Object> get props => [message];
}

class SectionError extends SectionState {
  final String message;

  const SectionError(this.message);

  @override
  List<Object> get props => [message];
}
