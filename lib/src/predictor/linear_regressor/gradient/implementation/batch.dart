import 'package:dart_ml/src/di/injector.dart';
import 'package:dart_ml/src/estimator/estimator_type.dart';
import 'package:dart_ml/src/optimizer/gradient/interface/batch.dart';
import 'package:dart_ml/src/optimizer/regularization/regularization.dart';
import 'package:dart_ml/src/loss_function/loss_function.dart';
import 'package:dart_ml/src/loss_function/squared_loss.dart';

import 'base.dart';

class BGDRegressor extends GradientLinearRegressor {
  BGDRegressor({double learningRate = 1e-5,
                 double minWeightsDistance = 1e-8,
                 int iterationLimit = 10000,
                 EstimatorType estimatorType = EstimatorType.RMSE,
                 Regularization regularization = Regularization.L2,
                 LossFunction lossFunction = const SquaredLoss(),
                 alpha = .00001})
      : super(
      (injector.get(BGDOptimizer) as BGDOptimizer)
        ..configure(learningRate, minWeightsDistance, iterationLimit, regularization, lossFunction, alpha: alpha),
      estimatorType: estimatorType);
}