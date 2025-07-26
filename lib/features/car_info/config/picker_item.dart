import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickerItem {
  final String id;
  final String title;
  
  PickerItem({required this.id, required this.title});
  factory PickerItem.fromJson(Map<String, dynamic> json) =>
      PickerItem(id: json['id'], title: json['title']);

  Map<String, dynamic> toJson() => {'id': id, 'title': title};

  @override
  String toString() => 'PickerItem(id: $id, title: $title)';

  static final noValueString = PickerItem(id: "__none__", title: "default");
  static const int yearNoValue = -1;
}

final carColorsProvider = Provider.autoDispose<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'white', title: 'سفید'),
    PickerItem(id: 'black', title: 'مشکی'),
    PickerItem(id: 'silver', title: 'نقره‌ای'),
    PickerItem(id: 'gray', title: 'خاکستری'),
    PickerItem(id: 'blue', title: 'آبی'),
    PickerItem(id: 'red', title: 'قرمز'),
    PickerItem(id: 'green', title: 'سبز'),
    PickerItem(id: 'yellow', title: 'زرد'),
    PickerItem(id: 'brown', title: 'قهوه‌ای'),
    PickerItem(id: 'other', title: 'سایر'),
  ],
);

final fuelTypesProvider = Provider.autoDispose<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'gasoline', title: 'بنزین'),
    PickerItem(id: 'diesel', title: 'دیزل'),
    PickerItem(id: 'gas', title: 'گازسوز'),
    PickerItem(id: 'hybrid', title: 'هیبریدی'),
    PickerItem(id: 'electric', title: 'برقی'),
  ],
);
