import 'package:ml_algo/ml_algo.dart';
import 'package:ml_algo/src/classifier/linear/softmax_regressor/softmax_regressor_impl.dart';
import 'package:ml_algo/src/solver/linear/initial_weights_generator/initial_weights_type.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_2d_almost_equal_to.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/mocks.dart';

void main() {
  group('SoftmaxRegressor', () {
    final dtype = DType.float32;

    test('should initialize properly', () {
      final observations = Matrix.fromList([[1.0]]);
      final outcomes = Matrix.fromList([[0]]);
      final optimizerMock = LinearOptimizerMock();
      final optimizerFactoryMock = createGradientOptimizerFactoryMock(
        observations, outcomes, optimizerMock);

      SoftmaxRegressorImpl(
        observations, outcomes,
        dtype: dtype,
        learningRateType: LearningRateType.constant,
        initialWeightsType: InitialWeightsType.zeroes,
        iterationsLimit: 100,
        initialLearningRate: 0.01,
        minWeightsUpdate: 0.001,
        lambda: 0.1,
        optimizerFactory: optimizerFactoryMock,
        randomSeed: 123,
      );

      verify(optimizerFactoryMock.gradient(
        observations,
        outcomes,
        dtype: dtype,
        costFunction: anyNamed('costFunction'),
        learningRateType: LearningRateType.constant,
        initialWeightsType: InitialWeightsType.zeroes,
        initialLearningRate: 0.01,
        minCoefficientsUpdate: 0.001,
        iterationLimit: 100,
        lambda: 0.1,
        batchSize: 1,
        randomSeed: 123,
      )).called(1);
    });

    test('should call solver\'s `findExtrema` method with proper '
        'parameters and consider intercept term', () {
      final observations = Matrix.fromList([
        [10.1, 10.2, 12.0, 13.4],
        [13.1, 15.2, 61.0, 27.2],
        [30.1, 25.2, 62.0, 34.1],
        [32.1, 35.2, 36.0, 41.5],
        [35.1, 95.2, 56.0, 52.6],
        [90.1, 20.2, 10.0, 12.1],
      ]);

      final outcomes = Matrix.fromList([
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 1.0, 0.0],
        [1.0, 0.0, 0.0],
        [1.0, 0.0, 0.0],
        [1.0, 0.0, 0.0],
      ]);

      final initialWeights = Matrix.fromList([
        [1.0],
        [10.0],
        [20.0],
        [30.0],
        [40.0],
      ]);

      final optimizerMock = LinearOptimizerMock();
      final optimizerFactoryMock = createGradientOptimizerFactoryMock(
        argThat(iterable2dAlmostEqualTo([
          [2.0, 10.1, 10.2, 12.0, 13.4],
          [2.0, 13.1, 15.2, 61.0, 27.2],
          [2.0, 30.1, 25.2, 62.0, 34.1],
          [2.0, 32.1, 35.2, 36.0, 41.5],
          [2.0, 35.1, 95.2, 56.0, 52.6],
          [2.0, 90.1, 20.2, 10.0, 12.1],
        ], 1e-2)), outcomes, optimizerMock,
      );

      SoftmaxRegressorImpl(
        observations,
        outcomes,
        dtype: dtype,
        learningRateType: LearningRateType.constant,
        initialWeightsType: InitialWeightsType.zeroes,
        iterationsLimit: 100,
        initialLearningRate: 0.01,
        minWeightsUpdate: 0.001,
        lambda: 0.1,
        fitIntercept: true,
        interceptScale: 2.0,
        optimizerFactory: optimizerFactoryMock,
        initialWeights: initialWeights,
        randomSeed: 123,
      );

      verify(optimizerFactoryMock.gradient(
        argThat(iterable2dAlmostEqualTo([
          [2.0, 10.1, 10.2, 12.0, 13.4],
          [2.0, 13.1, 15.2, 61.0, 27.2],
          [2.0, 30.1, 25.2, 62.0, 34.1],
          [2.0, 32.1, 35.2, 36.0, 41.5],
          [2.0, 35.1, 95.2, 56.0, 52.6],
          [2.0, 90.1, 20.2, 10.0, 12.1],
        ], 1e-2)),
        argThat(equals([
          [1.0, 0.0, 0.0],
          [0.0, 1.0, 0.0],
          [0.0, 1.0, 0.0],
          [1.0, 0.0, 0.0],
          [1.0, 0.0, 0.0],
          [1.0, 0.0, 0.0],
        ])),
        dtype: dtype,
        costFunction: anyNamed('costFunction'),
        learningRateType: LearningRateType.constant,
        initialWeightsType: InitialWeightsType.zeroes,
        initialLearningRate: 0.01,
        minCoefficientsUpdate: 0.001,
        iterationLimit: 100,
        lambda: 0.1,
        batchSize: 1,
        randomSeed: 123,
      )).called(1);

      verify(optimizerMock.findExtrema(
        initialWeights: initialWeights,
        isMinimizingObjective: false,
      )).called(1);
    });
  });
}
