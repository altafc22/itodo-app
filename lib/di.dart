import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:itodo/common/network/api_config.dart';
import 'package:itodo/common/network/connection_checker.dart';
import 'package:itodo/features/projects/domain/usecase/delete_project.dart';
import 'package:itodo/features/projects/domain/usecase/get_all_projects.dart';
import 'package:itodo/common/cubits/task/task_cubit.dart';
import 'package:itodo/features/tasks/domain/usecase/get_all_completed_tasks.dart';
import 'package:itodo/features/tasks/domain/usecase/move_task.dart';
import 'package:itodo/features/tasks/domain/usecase/reorder_task.dart';
import 'package:itodo/x_bloc_pack/blocs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/cubits/comment/comment_cubit.dart';
import 'common/network/api_client.dart';
import 'common/utils/shared_prefs_util.dart';

import 'features/comments/data/datasource/comment_remote_datasource.dart';
import 'features/comments/data/repository/comment_repository_impl.dart';
import 'features/comments/domain/repository/project_repository.dart';
import 'features/comments/domain/usecase/add_comment.dart';
import 'features/comments/domain/usecase/get_all_comments.dart';
import 'features/projects/data/datasource/project_local_datasource.dart';
import 'features/projects/data/datasource/project_remote_datasource.dart';
import 'features/projects/data/repository/project_repository_impl.dart';
import 'features/projects/domain/repository/project_repository.dart';
import 'features/projects/domain/usecase/add_project.dart';
import 'features/projects/domain/usecase/get_project.dart';
import 'features/projects/domain/usecase/update_project.dart';
import 'common/cubits/project/project_cubit.dart';
import 'features/sections/data/datasource/section_local_datasource.dart';
import 'features/sections/data/datasource/section_remote_datasource.dart';
import 'features/sections/data/repository/section_repository_impl.dart';
import 'features/sections/domain/repository/section_repository.dart';
import 'features/sections/domain/usecase/add_section.dart';
import 'features/sections/domain/usecase/delete_section.dart';
import 'features/sections/domain/usecase/get_all_sections.dart';
import 'features/sections/domain/usecase/get_section.dart';
import 'features/sections/domain/usecase/update_section.dart';
import 'features/sections/presentation/cubit/section_cubit.dart';
import 'features/tasks/data/datasources/task_local_datasource.dart';
import 'features/tasks/data/datasources/task_remote_datasource.dart';
import 'features/tasks/data/repository/task_repository_impl.dart';
import 'features/tasks/domain/repository/task_repository.dart';
import 'features/tasks/domain/usecase/add_task.dart';
import 'features/tasks/domain/usecase/close_task.dart';
import 'features/tasks/domain/usecase/delete_task.dart';
import 'features/tasks/domain/usecase/get_all_tasks.dart';
import 'features/tasks/domain/usecase/get_task.dart';
import 'features/tasks/domain/usecase/reopen_task.dart';
import 'features/tasks/domain/usecase/update_task.dart';

final serviceLocator = GetIt.instance;

setupDependencyInjection() async {
  await _registerSharePreference();
  await _registerApiClient();
  await _initDb();
  await _initCore();
  await _initBlocs();
}

Future<void> _registerSharePreference() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  final SharedPrefsUtil sharedPrefsUtil =
      await SharedPrefsUtil.getInstance(sharedPreferences);
  serviceLocator.registerSingleton<SharedPrefsUtil>(sharedPrefsUtil);
}

_initDb() async {
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
}

Future<void> _registerApiClient() async {
  serviceLocator.registerLazySingleton<ApiClient>(
      () => ApiClient(baseUrl: ApiConfig.baseUrl));
}

_initBlocs() {
  _initTheme();
  _initLocale();
  _initProjects();
  _initSections();
  _initTask();
  _initComments();
}

_initTheme() {
  serviceLocator.registerLazySingleton(() => ThemeCubit());
}

_initLocale() {
  serviceLocator.registerLazySingleton(() => LocaleCubit());
}

_initCore() async {
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));
}

_initProjects() {
  serviceLocator
    //datasource
    ..registerFactory<ProjectRemoteDataSource>(
        () => ProjectRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<ProjectLocalDataSource>(
      () => ProjectLocalDataSourceImpl(
        Hive.box(name: "projects"),
      ),
    )
    //repository
    ..registerFactory<ProjectRepository>(() => ProjectRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionChecker: serviceLocator(),
        ))
    // usecases
    ..registerFactory(() => AddProject(serviceLocator()))
    ..registerFactory(() => UpdateProject(serviceLocator()))
    ..registerFactory(() => GetProject(serviceLocator()))
    ..registerFactory(() => GetAllProjects(serviceLocator()))
    ..registerFactory(() => DeleteProject(serviceLocator()))
    //cubit
    ..registerLazySingleton(
      () => ProjectCubit(
          addProjectUseCase: serviceLocator(),
          updateProjectUseCase: serviceLocator(),
          getProjectUseCase: serviceLocator(),
          getAllProjectsUseCase: serviceLocator(),
          deleteProjectUseCase: serviceLocator()),
    );
}

_initSections() {
  serviceLocator
    //datasource
    ..registerFactory<SectionRemoteDataSource>(
        () => SectionRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<SectionLocalDataSource>(
      () => SectionLocalDataSourceImpl(
        Hive.box(name: "sections"),
      ),
    )
    //repository
    ..registerFactory<SectionRepository>(() => SectionRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionChecker: serviceLocator(),
        ))
    // usecases
    ..registerFactory(() => AddSection(serviceLocator()))
    ..registerFactory(() => UpdateSection(serviceLocator()))
    ..registerFactory(() => GetSection(serviceLocator()))
    ..registerFactory(() => GetAllSections(serviceLocator()))
    ..registerFactory(() => DeleteSection(serviceLocator()))
    //cubit
    ..registerLazySingleton(
      () => SectionCubit(
          addSectionUseCase: serviceLocator(),
          updateSectionUseCase: serviceLocator(),
          getSectionUseCase: serviceLocator(),
          getAllSectionsUseCase: serviceLocator(),
          deleteSectionUseCase: serviceLocator()),
    );
}

_initTask() {
  serviceLocator
    //datasource
    ..registerFactory<TaskRemoteDataSource>(
        () => TaskRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<TaskLocalDataSource>(() => TaskLocalDataSourceImpl(
          Hive.box(name: "tasks"),
          Hive.box(name: "completed_tasks"),
        ))
    //repository
    ..registerFactory<TaskRepository>(() => TaskRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionChecker: serviceLocator(),
        ))
    // usecases
    ..registerFactory(() => AddTask(serviceLocator()))
    ..registerFactory(() => UpdateTask(serviceLocator()))
    ..registerFactory(() => GetTask(serviceLocator()))
    ..registerFactory(() => GetAllTasks(serviceLocator()))
    ..registerFactory(() => DeleteTask(serviceLocator()))
    ..registerFactory(() => CloseTask(serviceLocator()))
    ..registerFactory(() => ReopenTask(serviceLocator()))
    ..registerFactory(() => MoveTask(serviceLocator()))
    ..registerFactory(() => ReorderTasks(serviceLocator()))
    ..registerFactory(() => GetCompletedTasks(serviceLocator()))
    //cubit
    ..registerLazySingleton(
      () => TaskCubit(
        addTaskUseCase: serviceLocator(),
        updateTaskUseCase: serviceLocator(),
        getTaskUseCase: serviceLocator(),
        getAllTasksUseCase: serviceLocator(),
        deleteTaskUseCase: serviceLocator(),
        reopenTaskUseCase: serviceLocator(),
        closeTaskUseCase: serviceLocator(),
        moveTaskUseCase: serviceLocator(),
        reorderTaskUseCase: serviceLocator(),
        getCompletedTasksUseCase: serviceLocator(),
      ),
    );
}

_initComments() {
  serviceLocator
    //datasource
    ..registerFactory<CommentRemoteDataSource>(
        () => CommentRemoteDataSourceImpl(serviceLocator()))

    //repository
    ..registerFactory<CommentRepository>(() => CommentRepositoryImpl(
          remoteDataSource: serviceLocator(),
          connectionChecker: serviceLocator(),
        ))
    // usecases
    ..registerFactory(() => AddComment(serviceLocator()))
    ..registerFactory(() => GetAllComments(serviceLocator()))
    //cubit
    ..registerLazySingleton(
      () => CommentCubit(
          addCommentUseCase: serviceLocator(),
          getAllCommentsUseCase: serviceLocator()),
    );
}
