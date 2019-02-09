import 'dart:async';
import 'dart:typed_data';

import 'package:ml_algo/cross_validator.dart';
import 'package:ml_algo/learning_rate_type.dart';
import 'package:ml_algo/linear_classifier.dart';
import 'package:ml_algo/metric_type.dart';
import 'package:ml_algo/ml_data.dart';

Future main() async {
  final data = MLData.fromCsvFile('datasets/pima_indians_diabetes_database.csv', labelIdx: 8, dtype: Float32x4);

  final features = await data.features;
  final labels = await data.labels;

  final validator = CrossValidator.kFold(numberOfFolds: 5, dtype: Float32x4);

  // lr=0.0102, randomSeed=134, minWeightsUpdate: 0.000000000001, iterationLimit: 100 => error = 0.3449

  final logisticRegressor = LinearClassifier.logisticRegressor(
      iterationLimit: 100,
      minWeightsUpdate: 1e-12,
      learningRate: 0.0102,
      learningRateType: LearningRateType.constant,
      randomSeed: 134);

  final error = validator.evaluate(logisticRegressor, features, labels, MetricType.accuracy);

  print('Error is ${(error * 100).toStringAsFixed(2)}%');
}
