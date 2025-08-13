class PickerItem {
  final String? id;

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


