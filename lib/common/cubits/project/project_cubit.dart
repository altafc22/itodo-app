import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import '../../../features/projects/domain/entity/project_entity.dart';
import '../../../features/projects/domain/usecase/add_project.dart';
import '../../../features/projects/domain/usecase/delete_project.dart';
import '../../../features/projects/domain/usecase/get_all_projects.dart';
import '../../../features/projects/domain/usecase/get_project.dart';
import '../../../features/projects/domain/usecase/update_project.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit({
    required this.addProjectUseCase,
    required this.updateProjectUseCase,
    required this.getAllProjectsUseCase,
    required this.getProjectUseCase,
    required this.deleteProjectUseCase,
  }) : super(ProjectInitial());

  final AddProject addProjectUseCase;
  final UpdateProject updateProjectUseCase;
  final GetAllProjects getAllProjectsUseCase;
  final GetProject getProjectUseCase;
  final DeleteProject deleteProjectUseCase;

  void addProject(String name) async {
    emit(ProjectLoading());
    final res = await addProjectUseCase.call(name);
    res.fold(
      (l) => emit(ProjectError(l.message)),
      (r) => emit(ProjectSuccess(r)),
    );
  }

  void updateProject(UpdateProjectParams params) async {
    emit(ProjectLoading());
    final res = await updateProjectUseCase.call(params);
    res.fold(
      (l) => emit(ProjectError(l.message)),
      (r) => emit(ProjectSuccess(r)),
    );
  }

  void getAllProjects() async {
    emit(ProjectLoading());
    final res = await getAllProjectsUseCase.call(NoParams());
    res.fold(
        (l) => emit(ProjectError(l.message)), (r) => emit(ProjectLoaded(r)));
  }

  void getProject(String id, {bool isLocal = false}) async {
    emit(ProjectLoading());
    if (isLocal) {
      final res = getProjectUseCase.callLocal(id);
      res.fold(
        (l) => emit(ProjectError(l.message)),
        (r) => emit(ProjectLoaded([r])),
      );
    } else {
      final res = await getProjectUseCase.call(id);
      res.fold(
        (l) => emit(ProjectError(l.message)),
        (r) => emit(ProjectLoaded([r])),
      );
    }
  }

  void deleteProject(String id) async {
    emit(ProjectLoading());
    final res = await deleteProjectUseCase.call(id);
    res.fold(
      (l) => emit(ProjectError(l.message)),
      (r) => emit(ProjectSuccessMessage(r)),
    );
  }
}
