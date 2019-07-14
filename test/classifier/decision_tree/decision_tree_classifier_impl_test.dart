import 'package:ml_algo/src/classifier/decision_tree/decision_tree_classifier_impl.dart';
import 'package:ml_algo/src/optimizer/non_linear/decision_tree/decision_tree_leaf_label.dart';
import 'package:ml_algo/src/optimizer/non_linear/decision_tree/decision_tree_solver.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/mocks.dart';

void main() {
  group('DecisionTreeClassifierImpl', () {
    test('should call appropriate method from `solver` when making '
        'classes prediction for nominal class labels', () {
      final sample1 = Vector.fromList([1, 2, 3]);
      final sample2 = Vector.fromList([10, 20, 30]);
      final sample3 = Vector.fromList([100, 200, 300]);

      final features = Matrix.fromRows([
        sample1,
        sample2,
        sample3,
      ]);

      final label1 = Vector.fromList([1, 0, 0]);
      final label2 = Vector.fromList([0, 0, 1]);
      final label3 = Vector.fromList([1, 0, 0]);

      final solverMock = createSolver<Vector>({
        sample1: DecisionTreeLeafLabel.nominal(label1),
        sample2: DecisionTreeLeafLabel.nominal(label2),
        sample3: DecisionTreeLeafLabel.nominal(label3),
      });

      final classifier = DecisionTreeClassifierImpl(solverMock);
      final predictedLabels = classifier.predictClasses(features);

      expect(predictedLabels, equals(Matrix.fromColumns(
          [label1, label2, label3],
      )));
    });

    test('should return an empty matrix if input features matrix is '
        'empty', () {
      final solverMock = DecisionTreeSolverMock();
      final classifier = DecisionTreeClassifierImpl(solverMock);
      final predictedLabels = classifier.predictClasses(Matrix.fromRows([]));

      expect(predictedLabels, isEmpty);
    });

    test('should call appropriate method from `solver` when making '
        'classes prediction for nominal class probabilities', () {
      final sample1 = Vector.fromList([1, 2, 3]);
      final sample2 = Vector.fromList([10, 20, 30]);
      final sample3 = Vector.fromList([100, 200, 300]);

      final features = Matrix.fromRows([
        sample1,
        sample2,
        sample3,
      ]);

      final label1 = DecisionTreeLeafLabel.nominal(
        Vector.fromList([1, 0, 0]),
        probability: 0.7,
      );
      final label2 = DecisionTreeLeafLabel.nominal(
        Vector.fromList([0, 0, 1]),
        probability: 0.6,
      );
      final label3 = DecisionTreeLeafLabel.nominal(
        Vector.fromList([1, 0, 0]),
        probability: 0.8,
      );

      final solverMock = createSolver<Vector>({
        sample1: label1,
        sample2: label2,
        sample3: label3,
      });

      final classifier = DecisionTreeClassifierImpl(solverMock);
      final predictedLabels = classifier.predictProbabilities(features);

      expect(predictedLabels, equals(Matrix.fromColumns([
        Vector.fromList([
          label1.probability,
          label2.probability,
          label3.probability
        ]),
      ])));
    });
  });
}

DecisionTreeSolver createSolver<T>(Map<Vector, DecisionTreeLeafLabel> samples) {
  final solverMock = DecisionTreeSolverMock();
  samples.forEach((sample, leafLabel) =>
    when(solverMock.getLabelForSample(sample)).thenReturn(leafLabel));
  return solverMock;
}
