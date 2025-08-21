import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motogen/features/car_services/purchases/viewmodel/purchase_draft_setters.dart';

// Local provider for purchase button logic
final isPurchaseInfoButtonEnabled = Provider<bool>((ref) {
  final purchaseState = ref.watch(purchaseDraftProvider);
  return purchaseState.isPartValid &&
      purchaseState.isLocationValid &&
      purchaseState.isCostValid &&
      purchaseState.isNoteValid &&
      purchaseState.date != null &&
      purchaseState.part != null &&
      purchaseState.purchaseCategory != null &&
      purchaseState.location != null &&
      purchaseState.cost != null;
});
