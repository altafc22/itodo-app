part of 'project_cubit.dart';

sealed class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<ProjectEntity> items;

  const ProjectLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ProjectSuccess extends ProjectState {
  final ProjectEntity item;

  const ProjectSuccess(this.item);

  @override
  List<Object> get props => [item];
}

class ProjectSuccessMessage extends ProjectState {
  final String message;

  const ProjectSuccessMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ProjectError extends ProjectState {
  final String message;

  const ProjectError(this.message);

  @override
  List<Object> get props => [message];
}
