import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RefuelSortType { newest, oldest }

final refuelSortProvider = StateProvider<RefuelSortType>(
  (ref) => RefuelSortType.newest,
);
