import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Optional equality checker.
typedef EqualityChecker<T> = bool Function(T, T);

/// Builder for animated diff transitions.
typedef AnimatedDiffUtilWidgetBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

/// --- Diff Operation Definitions ---
/// These classes represent diff operations produced when comparing two lists.
abstract class DiffOp<T> {}

class InsertOp<T> extends DiffOp<T> {
  final int index;
  final T item;
  InsertOp(this.index, this.item);
}

class RemoveOp<T> extends DiffOp<T> {
  final int index;
  final T item;
  RemoveOp(this.index, this.item);
}

class EqualOp<T> extends DiffOp<T> {
  final int oldIndex;
  final int newIndex;
  final T item;
  EqualOp(this.oldIndex, this.newIndex, this.item);
}

/// --- Custom Diff Algorithm (LCS-based) ---
/// Given an [oldList] and a [newList], returns a list of diff operations that
/// describe how to transform the old list into the new list.
List<DiffOp<T>> calculateDiff<T>(List<T> oldList, List<T> newList, bool Function(T, T) equals) {
  final int n = oldList.length;
  final int m = newList.length;

  // Build a DP table for the longest common subsequence.
  List<List<int>> dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0), growable: false);
  for (int i = n - 1; i >= 0; i--) {
    for (int j = m - 1; j >= 0; j--) {
      if (equals(oldList[i], newList[j])) {
        dp[i][j] = dp[i + 1][j + 1] + 1;
      } else {
        dp[i][j] = max(dp[i + 1][j], dp[i][j + 1]);
      }
    }
  }

  int i = 0, j = 0;
  List<DiffOp<T>> ops = [];
  while (i < n || j < m) {
    if (i < n && j < m && equals(oldList[i], newList[j])) {
      ops.add(EqualOp(i, j, newList[j]));
      i++;
      j++;
    } else if (j < m && (i == n || dp[i][j + 1] >= dp[i + 1][j])) {
      ops.add(InsertOp(j, newList[j]));
      j++;
    } else if (i < n && (j == m || dp[i][j + 1] < dp[i + 1][j])) {
      ops.add(RemoveOp(i, oldList[i]));
      i++;
    }
  }
  return ops;
}

/// --- CustomDiffUtilSliverList Widget ---
/// This widget drives smooth animations for list updates. It maintains an internal
/// temporary list and uses our custom diff algorithm to compute insertions and removals.
class CustomDiffUtilSliverList<T> extends StatefulWidget {
  /// The (immutable) list of items.
  final List<T> items;

  /// Builder that renders a single (non-animated) item.
  final Widget Function(BuildContext, T) builder;

  /// Builder for the insertion animation.
  final AnimatedDiffUtilWidgetBuilder insertAnimationBuilder;

  /// Builder for the removal animation.
  final AnimatedDiffUtilWidgetBuilder removeAnimationBuilder;

  /// Duration for the insertion animation.
  final Duration insertAnimationDuration;

  /// Duration for the removal animation.
  final Duration removeAnimationDuration;

  /// Optional equality checker (defaults to ==).
  final EqualityChecker<T>? equalityChecker;

  const CustomDiffUtilSliverList({
    Key? key,
    required this.items,
    required this.builder,
    required this.insertAnimationBuilder,
    required this.removeAnimationBuilder,
    this.insertAnimationDuration = const Duration(milliseconds: 300),
    this.removeAnimationDuration = const Duration(milliseconds: 300),
    this.equalityChecker,
  }) : super(key: key);

  /// Helper constructor that accepts a list of keyed widgets.
  /// Keys are used to ensure uniqueness.
  static CustomDiffUtilSliverList<Widget> fromKeyedWidgetList({
    required List<Widget> children,
    required AnimatedDiffUtilWidgetBuilder insertAnimationBuilder,
    required AnimatedDiffUtilWidgetBuilder removeAnimationBuilder,
    Duration insertAnimationDuration = const Duration(milliseconds: 300),
    Duration removeAnimationDuration = const Duration(milliseconds: 300),
  }) {
    if (kDebugMode) {
      final keys = <Key?>{};
      for (final child in children) {
        if (!keys.add(child.key)) {
          throw FlutterError(
              'CustomDiffUtilSliverList.fromKeyedWidgetList called with widgets that do not have unique keys! '
              'Make sure each widget has a unique key.');
        }
      }
    }
    return CustomDiffUtilSliverList<Widget>(
      items: children,
      builder: (context, widget) => widget,
      insertAnimationBuilder: insertAnimationBuilder,
      removeAnimationBuilder: removeAnimationBuilder,
      insertAnimationDuration: insertAnimationDuration,
      removeAnimationDuration: removeAnimationDuration,
      equalityChecker: (a, b) => a.key == b.key,
    );
  }

  @override
  _CustomDiffUtilSliverListState<T> createState() => _CustomDiffUtilSliverListState<T>();
}

class _CustomDiffUtilSliverListState<T> extends State<CustomDiffUtilSliverList<T>> {
  late GlobalKey<SliverAnimatedListState> _listKey;
  late List<T> _tempList;

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey<SliverAnimatedListState>();
    // Initialize the temporary list with the current items.
    _tempList = List<T>.from(widget.items);
  }

  @override
  void didUpdateWidget(CustomDiffUtilSliverList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newList = widget.items;
    final diffOps = calculateDiff<T>(
      _tempList,
      newList,
      widget.equalityChecker ?? ((a, b) => a == b),
    );

    // Process removals first (in descending order so indices remain valid).
    final removals = diffOps.whereType<RemoveOp<T>>().toList();
    removals.sort((a, b) => b.index.compareTo(a.index));
    for (final op in removals) {
      final removedItem = _tempList.removeAt(op.index);
      _listKey.currentState?.removeItem(
        op.index,
        (context, animation) => widget.removeAnimationBuilder(
          context,
          animation,
          widget.builder(context, removedItem),
        ),
        duration: widget.removeAnimationDuration,
      );
    }

    // Then process insertions (in ascending order).
    final insertions = diffOps.whereType<InsertOp<T>>().toList();
    insertions.sort((a, b) => a.index.compareTo(b.index));
    for (final op in insertions) {
      _tempList.insert(op.index, op.item);
      _listKey.currentState?.insertItem(
        op.index,
        duration: widget.insertAnimationDuration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _tempList.length,
      itemBuilder: (context, index, animation) {
        return widget.insertAnimationBuilder(
          context,
          animation,
          widget.builder(context, _tempList[index]),
        );
      },
    );
  }
}
