import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/cubits/comment/comment_cubit.dart';

import 'package:itodo/di.dart';
import 'package:itodo/common/cubits/project/project_cubit.dart';
import 'package:itodo/features/sections/presentation/cubit/section_cubit.dart';
import 'package:itodo/features/splash/presentation/splash_screen.dart';
import 'package:itodo/x_bloc_pack/blocs.dart';

import 'const/theme.dart';
import 'common/cubits/task/task_cubit.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencyInjection();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<ThemeCubit>()),
        BlocProvider(create: (_) => serviceLocator<LocaleCubit>()),
        BlocProvider(create: (_) => serviceLocator<ProjectCubit>()),
        BlocProvider(create: (_) => serviceLocator<SectionCubit>()),
        BlocProvider(create: (_) => serviceLocator<TaskCubit>()),
        BlocProvider(create: (_) => serviceLocator<CommentCubit>()),
      ],
      //BlocProviders.providers,
      child: const AppView(),
    ),
  );
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previousTheme, currentTheme) =>
            previousTheme.themeMode != currentTheme.themeMode,
        builder: (context, themeState) {
          return BlocProvider(
            create: (context) => LocaleCubit(),
            child: BlocBuilder<LocaleCubit, LocaleState>(
              buildWhen: (previousLanguage, currenctLanguage) =>
                  previousLanguage.locale != currenctLanguage.locale,
              builder: (context, localeState) {
                return MaterialApp(
                  title: 'iToDo',
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.themeMode,
                  home: const SplashScreen(),
                  locale: localeState.locale,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
