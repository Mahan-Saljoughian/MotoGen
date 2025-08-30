import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:motogen/features/user_info/data/user_respository.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart';

extension UserUseCaseApi on WidgetRef {
  UserRespository get _userRepository => UserRespository();

  Future<void> getUserProfile() async {
    final personalInfoController = read(personalInfoProvider.notifier);
    final phoneNumberController = read(phoneNumberControllerProvider);

    final userData = await _userRepository.getUserProfile();

    personalInfoController.nameController.text = userData['firstName'] ?? '';
    personalInfoController.lastNameController.text = userData['lastName'] ?? '';
    phoneNumberController.phoneController.text = userData['phoneNumber'] ?? '';
  }

  Future<void> updateUserProfile(
    TextEditingController draftNameController,
    TextEditingController draftLastNameController,
  ) async {
    // Build patch payload only for fields that have changed
    final Map<String, String> changes = {};

    final personalInfoController = read(personalInfoProvider.notifier);
    final originalNameControllerText = personalInfoController
        .nameController
        .text
        .trim();
    final originalLastNameControllerText = personalInfoController
        .lastNameController
        .text
        .trim();
    final draftNametext = draftNameController.text.trim();
    final draftLastNametext = draftLastNameController.text.trim();

    if (originalNameControllerText != draftNametext) {
      changes['firstName'] = draftNametext;
    }
    if (originalLastNameControllerText != draftLastNametext) {
      changes['lastName'] = draftLastNametext;
    }
    if (changes.isEmpty) {
      return;
    }
    try {
      await _userRepository.patchUserProfile(changes);
    } catch (e, st) {
      Logger().e(
        "Error patching user profile with draftName: $draftNametext and draftLastName: $draftLastNametext, error : $e , stacktrace: $st",
      );
      rethrow;
    }
  }
}
