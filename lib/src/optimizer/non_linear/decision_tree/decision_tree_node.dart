import 'package:ml_algo/src/optimizer/non_linear/decision_tree/decision_tree_leaf_label.dart';
import 'package:ml_linalg/vector.dart';
import 'package:xrange/zrange.dart';

typedef TestSamplePredicate = bool Function(Vector sample);

class DecisionTreeNode {
  DecisionTreeNode(
      this.testSample,
      this.splittingNumericalValue,
      this.splittingNominalValue,
      this.splittingColumnRange,
      this.children,
      this.label,
  );

  final List<DecisionTreeNode> children;
  final DecisionTreeLeafLabel label;
  final TestSamplePredicate testSample;
  final double splittingNumericalValue;
  final Vector splittingNominalValue;
  final ZRange splittingColumnRange;

  bool get isLeaf => children == null || children.isEmpty;
}
