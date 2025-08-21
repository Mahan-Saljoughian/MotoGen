import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:motogen/core/services/api_service.dart';

import 'package:motogen/features/bottom_sheet/config/picker_item.dart';
import 'package:motogen/features/car_info/models/car_form_state_item.dart';

final api = ApiService();
final carBrandsProvider = FutureProvider.autoDispose<List<PickerItem>>((
  ref,
) async {
  final result = await api.get('cars/brands', skipAuth: true);
  final List data = result['data'];
  Logger().i("API response: $result");
  return data
      .map(
        (e) => PickerItem(id: e['id'].toString(), title: e['title'] as String),
      )
      .toList();
});

// Models depend on brand selection
final carModelsProvider = FutureProvider.autoDispose
    .family<List<PickerItem>, String>((ref, brandId) async {
      final result = await api.get(
        'cars/brands/$brandId/models',
        skipAuth: true,
      );
      final List data = result['data'];
      Logger().i("API response: $result");
      return data
          .map(
            (e) =>
                PickerItem(id: e['id'].toString(), title: e['title'] as String),
          )
          .toList();
    });

final carTrimsApiProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, modelId) async {
      final api = ApiService();
      // Only calls API when modelId changes, or when explicitly refreshed.
      return await api.get('cars/models/$modelId/trims', skipAuth: true);
    });

// Types (trims) depend on model selection
final carTypesProvider = Provider.autoDispose
    .family<AsyncValue<List<PickerItem>>, String>((ref, modelId) {
      final apiAsync = ref.watch(carTrimsApiProvider(modelId));
      return apiAsync.whenData((result) {
        final List dataList = result['data'];
        return dataList
            .map(
              (e) => PickerItem(
                id: e['id'].toString(),
                title: e['title'].toString(),
              ),
            )
            .toList();
      });
    });

class TrimRange {
  final int firstYearProd, lastYearProd;
  TrimRange({required this.firstYearProd, required this.lastYearProd});
}

final trimRangeProvider = Provider.autoDispose
    .family<AsyncValue<TrimRange?>, ({String modelId, String typeId})>((
      ref,
      args,
    ) {
      final apiAsync = ref.watch(carTrimsApiProvider(args.modelId));
      return apiAsync.whenData((result) {
        final data = result['data'];
        if (data == null || data is! List || data.isEmpty) return null;

        final item = data.firstWhere((e) => e['id'] == args.typeId);
        if (item == null) return null;

        final firstYear = item['firstYearProd'];
        final lastYear = item['lastYearProd'];

        if (firstYear == null || lastYear == null) return null;

        if (firstYear == null || lastYear == null) return null;
        return TrimRange(firstYearProd: firstYear, lastYearProd: lastYear);
      });
    });

final yearMadeProvider = Provider.autoDispose
    .family<AsyncValue<List<PickerItem>>, ({String modelId, String typeId})>((
      ref,
      args,
    ) {
      final trimRangeAsync = ref.watch(
        trimRangeProvider((modelId: args.modelId, typeId: args.typeId)),
      );
      return trimRangeAsync.whenData((range) {
        if (range == null) return <PickerItem>[];
        final start = range.firstYearProd;
        final end = range.lastYearProd;
        return List.generate(end - start + 1, (i) {
          final year = start + i;
          return PickerItem(id: year.toString(), title: year.toString());
        });
      });
    });

final colorProvider = FutureProvider.autoDispose<List<PickerItem>>((ref) async {
  final result = await api.get('colors', skipAuth: true);
  final List data = result['data'];
  return data
      .map(
        (e) => PickerItem(
          id: e['englishTitle'].toString(),
          title: e['persianTitle'] as String,
        ),
      )
      .toList();
});

final fuelTypesProvider = Provider.autoDispose<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'GASOLINE', title: 'بنزین'),
    PickerItem(id: 'GAS', title: 'گاز'),
    PickerItem(id: 'DIESEL', title: 'گازوییل'),
    PickerItem(id: ' GASOLINE_GAS', title: 'بنزین-گاز'),
  ],
);

ProviderListenable<AsyncValue<List<PickerItem>>> fuelTypesAsyncProviderBuilder(
  CarFormStateItem state,
) {
  return Provider.autoDispose<AsyncValue<List<PickerItem>>>((ref) {
    final list = ref.watch(fuelTypesProvider);
    return AsyncValue.data(list);
  });
}
