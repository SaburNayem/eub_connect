import 'package:eub_connect/core/data/async_value.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';
import 'package:eub_connect/feature/common/assignment_quiz/repository/assignment_quiz_repository.dart';
import 'package:eub_connect/feature/student/assingment/model/assingment_model.dart';
import 'package:get/get.dart';

class AssingmentController extends GetxController {
  AssingmentController({AssignmentQuizRepository? repository})
    : _repository = repository ?? AssignmentQuizRepository();

  final AssignmentQuizRepository _repository;
  final moduleStatus = 'Ready'.obs;
  final model = const AssingmentModel().obs;
  final selectedSubjectCode = 'all'.obs;
  final workspace = const AsyncValue<AssignmentQuizWorkspace>.loading().obs;
  Worker? _demoRevisionWorker;

  @override
  void onInit() {
    super.onInit();
    _demoRevisionWorker = ever(DemoStore.instance.revision, (_) => load());
    load();
  }

  List<CourseSubject> get subjects => workspace.value.data?.subjects ?? [];

  List<AssignmentSubmission> get submissions {
    return workspace.value.data?.submissions ?? [];
  }

  List<CourseAssignment> get assignments {
    final selectedCode = selectedSubjectCode.value;
    final allAssignments = workspace.value.data?.assignments ?? [];
    final filtered = selectedCode == 'all'
        ? allAssignments
        : allAssignments.where(
            (assignment) => assignment.subject.sectionId == selectedCode,
          );
    return filtered.toList();
  }

  int get openCount {
    final allAssignments = workspace.value.data?.assignments ?? [];
    return allAssignments.where((assignment) {
      return assignment.status.toLowerCase() == 'published' &&
          submissionFor(assignment.id) == null;
    }).length;
  }

  int get submittedCount => submissions.length;

  int get reviewedCount {
    return submissions
        .where((submission) => submission.status.toLowerCase() == 'reviewed')
        .length;
  }

  void selectSubject(String code) {
    selectedSubjectCode.value = code;
  }

  Future<void> load() async {
    workspace.value = const AsyncValue.loading();
    final result = await _repository.loadWorkspace();
    if (result.isSuccess) {
      workspace.value = AsyncValue.data(result.requireData);
      return;
    }
    workspace.value = AsyncValue.error(
      result.failure?.message ?? 'Unable to load assignments.',
    );
  }

  AssignmentSubmission? submissionFor(String assignmentId) {
    for (final submission in submissions) {
      if (submission.assignmentId == assignmentId) {
        return submission;
      }
    }
    return null;
  }

  Future<void> submitAssignment({
    required CourseAssignment assignment,
    required String fileName,
    required String note,
  }) async {
    final cleanNote = note.trim().isEmpty
        ? 'Submitted from EUB Connect.'
        : note.trim();

    final result = await _repository.submitAssignment(
      assignmentId: assignment.id,
      note: cleanNote,
    );
    if (result.isSuccess) {
      moduleStatus.value = 'Submitted';
      await load();
      return;
    }

    moduleStatus.value = result.failure?.message ?? 'Submission failed';
  }

  @override
  void onClose() {
    _demoRevisionWorker?.dispose();
    super.onClose();
  }
}
