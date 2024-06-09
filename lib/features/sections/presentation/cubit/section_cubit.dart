import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/log_utils.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entity/section_entity.dart';
import '../../domain/usecase/add_section.dart';
import '../../domain/usecase/delete_section.dart';
import '../../domain/usecase/get_all_sections.dart';
import '../../domain/usecase/get_section.dart';
import '../../domain/usecase/update_section.dart';

part 'section_state.dart';

class SectionCubit extends Cubit<SectionState> {
  SectionCubit({
    required this.addSectionUseCase,
    required this.updateSectionUseCase,
    required this.getAllSectionsUseCase,
    required this.getSectionUseCase,
    required this.deleteSectionUseCase,
  }) : super(SectionInitial());

  final AddSection addSectionUseCase;
  final UpdateSection updateSectionUseCase;
  final GetAllSections getAllSectionsUseCase;
  final GetSection getSectionUseCase;
  final DeleteSection deleteSectionUseCase;

  void addSection(String name) async {
    emit(SectionLoading());
    final res = await addSectionUseCase.call(name);
    res.fold(
      (l) => emit(SectionError(l.message)),
      (r) => emit(SectionSuccess(r)),
    );
  }

  void updateSection(UpdateSectionParams params) async {
    emit(SectionLoading());
    final res = await updateSectionUseCase.call(params);
    res.fold(
      (l) => emit(SectionError(l.message)),
      (r) => emit(SectionSuccess(r)),
    );
  }

  void getAllSections() async {
    emit(SectionLoading());
    final res = await getAllSectionsUseCase.call(NoParams());
    res.fold((l) => emit(SectionError(l.message)), (r) {
      printInfo(r.toString());
      return emit(SectionLoaded(r));
    });
  }

  void getSection(String id) async {
    emit(SectionLoading());
    final res = await getSectionUseCase.call(id);
    res.fold(
      (l) => emit(SectionError(l.message)),
      (r) => emit(SectionLoaded([r])),
    );
  }

  void deleteSection(String id) async {
    emit(SectionLoading());
    final res = await deleteSectionUseCase.call(id);
    res.fold(
      (l) => emit(SectionError(l.message)),
      (r) => emit(SectionSuccessMessage(r)),
    );
  }

  void getAllByProjectId(String id) async {
    emit(SectionLoading());
    final res = getAllSectionsUseCase.getAllByProjectId(id);
    res.fold(
      (l) => emit(SectionError(l.message)),
      (r) => emit(SectionLoaded(r)),
    );
  }
}
