// features/car_info/viewmodels/car_use_case_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/user_info/data/user_respository.dart';
import 'package:motogen/features/user_info/viewmodels/personal_info_controller_view_model.dart';
import 'package:motogen/features/user_info/viewmodels/phone_number_controller_view_model.dart'; // To update state

final userUseCaseProvider = NotifierProvider<UserUseCaseNotifier, void>(
  () => UserUseCaseNotifier(),
);

class UserUseCaseNotifier extends Notifier<void> {
  final _userRepository = UserRespository();

  @override
  void build() {
    // No state needed
  }

  Future<void> getUserProfile() async {
    final personalInfoController = ref.read(personalInfoProvider.notifier);
    final phoneNumberController = ref.read(phoneNumberControllerProvider);
    final userData = await _userRepository.getUserProfile();
    personalInfoController.nameController.text = userData['firstName'] ?? '';
    personalInfoController.lastNameController.text = userData['lastName'] ?? '';
    phoneNumberController.phoneController.text = userData['phoneNumber'] ?? '';
  }
}
