import 'package:ml_algo/src/classifier/linear_classifier_mixin/linear_classifier_mixin.dart';
import 'package:ml_algo/src/classifier/softmax_regressor/softmax_regressor.dart';
import 'package:ml_algo/src/cost_function/cost_function_type.dart';
import 'package:ml_algo/src/helpers/add_intercept.dart';
import 'package:ml_algo/src/optimizer/gradient/learning_rate_generator/learning_rate_type.dart';
import 'package:ml_algo/src/optimizer/initial_weights_generator/initial_weights_type.dart';
import 'package:ml_algo/src/optimizer/optimizer_factory.dart';
import 'package:ml_algo/src/optimizer/optimizer_factory_impl.dart';
import 'package:ml_algo/src/score_to_prob_mapper/score_to_prob_mapper.dart';
import 'package:ml_algo/src/score_to_prob_mapper/score_to_prob_mapper_factory.dart';
import 'package:ml_algo/src/score_to_prob_mapper/score_to_prob_mapper_factory_impl.dart';
import 'package:ml_algo/src/score_to_prob_mapper/score_to_prob_mapper_type.dart';
import 'package:ml_algo/src/utils/default_parameter_values.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

class GradientSoftmaxRegressor with LinearClassifierMixin
    implements SoftmaxRegressor {
  GradientSoftmaxRegressor(
      this.trainingFeatures,
      this.trainingOutcomes, {
        // public arguments
        int iterationsLimit = DefaultParameterValues.iterationsLimit,
        double initialLearningRate = DefaultParameterValues.initialLearningRate,
        double minWeightsUpdate = DefaultParameterValues.minCoefficientsUpdate,
        double lambda,
        int randomSeed,
        int batchSize = 1,
        bool fitIntercept = false,
        double interceptScale = 1.0,
        Matrix initialWeights,
        LearningRateType learningRateType = LearningRateType.constant,
        InitialWeightsType initialWeightsType = InitialWeightsType.zeroes,

        this.dtype = DefaultParameterValues.dtype,

        // private arguments
        ScoreToProbMapperFactory scoreToProbMapperFactory =
          const ScoreToProbMapperFactoryImpl(),

        OptimizerFactory optimizerFactory =
          const OptimizerFactoryImpl(),
      }) :
        fitIntercept = fitIntercept,
        interceptScale = interceptScale,
        scoreToProbMapper =
          scoreToProbMapperFactory.fromType(_scoreToProbMapperType, dtype),
        classLabels = trainingOutcomes.uniqueRows(),
        weightsByClasses = optimizerFactory.gradient(
          addInterceptIf(fitIntercept, trainingFeatures, interceptScale),
          trainingOutcomes,
          dtype: dtype,
          costFnType: CostFunctionType.logLikelihood,
          scoreToProbMapperType: _scoreToProbMapperType,
          learningRateType: learningRateType,
          initialWeightsType: initialWeightsType,
          initialLearningRate: initialLearningRate,
          minCoefficientsUpdate: minWeightsUpdate,
          iterationLimit: iterationsLimit,
          lambda: lambda,
          batchSize: batchSize,
          randomSeed: randomSeed,
        ).findExtrema(
          initialWeights: initialWeights,
          isMinimizingObjective: false,
        );

  static const _scoreToProbMapperType = ScoreToProbMapperType.softmax;

  @override
  final bool fitIntercept;

  @override
  final double interceptScale;

  @override
  final Matrix trainingFeatures;

  @override
  final Matrix trainingOutcomes;

  @override
  final Matrix classLabels;

  @override
  final Matrix weightsByClasses;

  final DType dtype;

  @override
  final ScoreToProbMapper scoreToProbMapper;

  @override
  Matrix predict(Matrix features) {
    final processedFeatures = addInterceptIf(fitIntercept, trainingFeatures,
        interceptScale);
    return checkDataAndPredictProbabilities(processedFeatures)
        .mapRows((probabilities) {
      final labelIdx = probabilities.toList().indexOf(probabilities.max());
      return classLabels.getRow(labelIdx);
    });
  }
}
