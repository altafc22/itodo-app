import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodo/common/cubits/locale/locale_cubit.dart';
import 'package:itodo/const/constants.dart';

import '../../l10n/l10n.dart';
import '../models/language_model.dart';

final class AppUtils {
  AppUtils._();
  static void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseLanguage,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: Language.values.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          context
                              .read<LocaleCubit>()
                              .changeLanguage(Language.values[index].value);
                          Future.delayed(const Duration(milliseconds: 300))
                              .then((value) => Navigator.of(context).pop());
                        },
                        title: Text(Language.values[index].text),
                        trailing:
                            _isSameLocale(Language.values[index].value, context)
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: primaryColor,
                                  )
                                : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: _isSameLocale(
                                  Language.values[index].value, context)
                              ? const BorderSide(
                                  color: primaryColor, width: 1.5)
                              : BorderSide(color: Colors.grey[300]!),
                        ),
                        tileColor:
                            _isSameLocale(Language.values[index].value, context)
                                ? primaryColor.withOpacity(0.05)
                                : null,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16.0);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static bool _isSameLocale(Locale locale, BuildContext context) {
    final currentLocaleCode =
        context.read<LocaleCubit>().currentLocale.languageCode;

    return locale.languageCode == currentLocaleCode;
  }

  static Color getPriorityColor(int prioriy) {
    switch (prioriy) {
      case 4:
        return getColorByName('red');
      case 3:
        return getColorByName('orange');
      case 2:
        return getColorByName('blue');
      case 1:
        return getColorByName('green');
      default:
        return getColorByName('grey');
    }
  }

  static String getPriorityName(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      case 4:
        return 'Urgent';
      default:
        return 'Unknown';
    }
  }

  static Color getSectionColor(String sectionName) {
    switch (sectionName.toLowerCase()) {
      case 'done':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'to do':
        return Colors.redAccent;
    }
    return Colors.amber;
  }
}
