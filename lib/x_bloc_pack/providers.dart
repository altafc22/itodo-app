import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/di.dart';
import 'package:itodo/common/cubits/task/task_cubit.dart';

import '../common/cubits/project/project_cubit.dart';
import '../features/sections/presentation/cubit/section_cubit.dart';
import 'blocs.dart';

class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider(create: (_) => serviceLocator<ThemeCubit>()),
    BlocProvider(create: (_) => serviceLocator<LocaleCubit>()),
    BlocProvider(create: (_) => serviceLocator<ProjectCubit>()),
    BlocProvider(create: (_) => serviceLocator<SectionCubit>()),
    BlocProvider(create: (_) => serviceLocator<TaskCubit>()),
  ];
}
