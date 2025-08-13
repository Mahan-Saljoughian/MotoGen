import 'package:hive_flutter/hive_flutter.dart';

import 'package:motogen/features/car_info/models/car_form_state_item.dart';


// need to adjust for list of states if needed to use hive 
class HiveStorage {
  static const String carBoxName = 'carInfo';

/*   static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CarFormStateAdapter());
    Hive.registerAdapter(PickerItemAdapter());
    await Hive.deleteBoxFromDisk(carBoxName);
  }
 */
  static Future<void> saveCarInfo(CarFormStateItem carState) async {
    final box = await Hive.openBox(carBoxName);
    await box.put('currentCar', carState);
  }

  static Future<CarFormStateItem?> loadCarInfo() async {
    final box = await Hive.openBox(carBoxName);
    return box.get('currentCar') as CarFormStateItem?;
  }

  static Future<void> clearCarInfo() async {
    final box = await Hive.openBox(carBoxName);
    await box.delete('currentCar');
  }
}
