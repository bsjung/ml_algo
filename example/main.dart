import 'dart:async';

import 'package:ml_algo/ml_algo.dart';
import 'package:ml_linalg/matrix.dart';

/// A simple usage example using synthetic data. To see more complex examples,
/// please, visit other directories in this folder
Future main() async {
  // Let's create a feature matrix (a set of independent variables)
  final features = Matrix.fromList([
    [2.0, 3.0, 4.0, 5.0],
    [12.0, 32.0, 1.0, 3.0],
    [27.0, 3.0, 0.0, 59.0],
  ]);

  // Let's create dependent variables vector. It will be used as `true` values
  // to adjust regression coefficients
  final labels = Matrix.fromList([
    [4.3],
    [3.5],
    [2.1]
  ]);

  // Let's create a regressor itself and train it
  final regressor = LinearRegressor.gradient(
      features, labels,
      iterationsLimit: 100,
      initialLearningRate: 0.0005,
      learningRateType: LearningRateType.constant);

  // Let's see adjusted coefficients
  print('Regression coefficients: ${regressor.coefficients}');
}
