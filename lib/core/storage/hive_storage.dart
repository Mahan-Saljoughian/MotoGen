import 'package:hive_flutter/hive_flutter.dart';
import 'package:motogen/features/car_info/config/picker_item.dart';
import 'package:motogen/features/car_info/models/car_form_state.dart';

class HiveStorage {
  static const String carBoxName = 'carInfo';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CarFormStateAdapter());
    Hive.registerAdapter(PickerItemAdapter());
  }

  static Future<void> saveCarInfo(CarFormState carState) async {
    final box = await Hive.openBox(carBoxName);
    await box.put('currentCar', carState);
  }

  static Future<CarFormState?> loadCarInfo() async {
    final box = await Hive.openBox(carBoxName);
    return box.get('currentCar') as CarFormState?;
  }

  static Future<void> clearCarInfo() async {
    final box = await Hive.openBox(carBoxName);
    await box.delete('currentCar');
  }
}
