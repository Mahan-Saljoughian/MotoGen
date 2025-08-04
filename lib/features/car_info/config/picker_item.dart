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



final fuelTypesProvider = Provider.autoDispose<List<PickerItem>>(
  (ref) => [
    PickerItem(id: 'GASOLINE', title: 'بنزین'),
    PickerItem(id: 'GAS', title: 'گاز'),
    PickerItem(id: 'DIESEL', title: 'گازوییل'),
    PickerItem(id: ' GASOLINE_GAS', title: 'بنزین-گاز'),
  ],
);


