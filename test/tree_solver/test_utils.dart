import 'package:ml_algo/src/tree_solver/tree_node.dart';
import 'package:ml_algo/src/tree_solver/leaf_label/leaf_label.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void testTreeNode(
    TreeNode node,
    {
      bool shouldBeLeaf,
      double expectedSplittingValue,
      int expectedSplittingColumnIdx,
      int expectedChildrenLength,
      TreeLeafLabel expectedLabel,
      Map<Vector, bool> samplesToCheck,
    }
) {
  expect(node.isLeaf, equals(shouldBeLeaf));
  expect(node.splittingValue, equals(expectedSplittingValue));
  expect(node.splittingIdx, equals(expectedSplittingColumnIdx));
  expectedChildrenLength == null
      ? expect(node.children, isNull)
      : expect(node.children, hasLength(expectedChildrenLength));
  expectedLabel == null
      ? expect(node.label, isNull)
      : testLeafLabel(node.label, expectedLabel);
  samplesToCheck?.entries?.forEach((entry) {
    expect(node.testSample(entry.key), entry.value);
  });
}

void testLeafLabel(TreeLeafLabel label,
    TreeLeafLabel expectedLabel) {
  expect(label.value, equals(expectedLabel.value));
  expect(label.probability, equals(expectedLabel.probability));
}
