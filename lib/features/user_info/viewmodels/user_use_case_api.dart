import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}
