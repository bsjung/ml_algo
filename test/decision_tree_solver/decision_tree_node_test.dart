import 'package:ml_algo/src/decision_tree_solver/decision_tree_node.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_tech/unit_testing/readers/json.dart';
import 'package:test/test.dart';

void main() {
  group('DecisionTreeNode', () {
    test('should serialize itself', () async {
      final dummyTestFn = (Vector v) => true;

      final child31 = DecisionTreeNode(dummyTestFn, 600, null, [],
          null, 3);
      final child32 = DecisionTreeNode(dummyTestFn, 700, null, [],
          null, 3);
      final child33 = DecisionTreeNode(dummyTestFn, 800, null, [],
          null, 3);
      final child34 = DecisionTreeNode(dummyTestFn, 900, null, [],
          null, 3);
      final child35 = DecisionTreeNode(dummyTestFn, 900, null, [],
          null, 3);
      final child36 = DecisionTreeNode(dummyTestFn, 901, null, [],
          null, 3);
      final child37 = DecisionTreeNode(dummyTestFn, 911, null, [],
          null, 3);

      final child21 = DecisionTreeNode(dummyTestFn, 100, null, [
        child31,
        child32,
      ], null, 2);
      final child22 = DecisionTreeNode(dummyTestFn, 200, null, [
        child33,
        child34,
      ], null, 2);
      final child23 = DecisionTreeNode(dummyTestFn, 300, null, [
        child35,
        child36,
      ], null, 2);
      final child24 = DecisionTreeNode(dummyTestFn, 400, null, [
        child37,
      ], null, 2);

      final child25 = DecisionTreeNode(dummyTestFn, 500, null, [],
          null, 2);

      final child11 = DecisionTreeNode(dummyTestFn, 10, null, [
        child21,
        child22
      ], null, 1);
      final child12 = DecisionTreeNode(dummyTestFn, 12, null, [
        child23,
        child24,
      ], null, 1);
      final child13 = DecisionTreeNode(dummyTestFn, 13, null, [
        child25,
      ], null, 1);

      final root = DecisionTreeNode(dummyTestFn, null, null, [
        child11,
        child12,
        child13,
      ], null);

      final snapshotFileName = 'test/decision_tree_solver/'
          'decision_tree_node_test.json';
      final actual = root.serialize();
      final expected = await readJSON(snapshotFileName);

      expect(actual, expected);
    });
  });
}