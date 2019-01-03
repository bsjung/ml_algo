import 'dart:async';

import 'package:ml_algo/float32x4_cross_validator.dart';
import 'package:ml_algo/float32x4_csv_ml_data.dart';
import 'package:ml_algo/gradient_regressor.dart';
import 'package:ml_algo/gradient_type.dart';
import 'package:ml_algo/learning_rate_type.dart';
import 'package:ml_algo/metric_type.dart';
import 'package:tuple/tuple.dart';

Future main() async {
  final data = Float32x4CsvMLData.fromFile('datasets/black_friday.csv',
    labelIdx: 11,
    rows: [const Tuple2(0, 3000)],
    columns: [const Tuple2(2, 11)],
    categories: {
      'Gender': ['M', 'F'],
      'Age': ['0-17', '18-25', '26-35', '36-45', '46-50', '51-55', '55+'],
      'City_Category': ['A', 'B', 'C'],
      'Stay_In_Current_City_Years': [0, 1, 2, 3, '4+'],
      'Martial_Status': [0, 1],
      'Product_Category_1': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
      'Product_Category_2': [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
      'Product_Category_3': [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
    }
  );
  final features = await data.features;
  final labels = await data.labels;

  final validator = Float32x4CrossValidator.kFold(numberOfFolds: 5);

  final step = 0.00001;
  final start = 0.0001;
  final limit = 0.02;

  double minError = double.infinity;
  double bestLearningRate = 0.0;

  for (double rate = start; rate < limit; rate += step) {
    final regressor = GradientRegressor(
        type: GradientType.stochastic,
        iterationLimit: 100000,
        learningRate: rate,
        learningRateType: LearningRateType.constant);

    final error = validator.evaluate(regressor, features, labels, MetricType.mape);

    if (error < minError) {
      minError = error;
      bestLearningRate = rate;
      print('error: $minError, learning rate: $bestLearningRate');
    }
  }
}
