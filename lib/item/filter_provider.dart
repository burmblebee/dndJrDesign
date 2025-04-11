import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterProvider = StateNotifierProvider<FilterNotifier, List<bool>>(
      (ref) => FilterNotifier(),
);

class FilterNotifier extends StateNotifier<List<bool>> {
  FilterNotifier() : super([true, true, true, true]);

  void toggle(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) !state[i] else state[i],
    ];
  }

  void set(int index, bool value) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) value else state[i],
    ];
  }
}
