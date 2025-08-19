import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/repair/viewmodel/repair_draft_setters.dart';

// Local provider for repair button logic
final isRepairInfoButtonEnabled = Provider<bool>((ref) {
  final repairState = ref.watch(repairDraftProvider);
  return repairState.isPartValid &&
      repairState.isKilometerValid &&
      repairState.isLocationValid &&
      repairState.isCostValid &&
      repairState.isNoteValid &&
      repairState.date != null &&
      repairState.part != null &&
      repairState.repairAction != null &&
      repairState.kilometer != null &&
      repairState.location != null &&
      repairState.cost != null;
});
