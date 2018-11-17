import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_ml/dart_ml.dart';
import 'package:csv/csv.dart' as csv;

Future main() async {
  final csvCodec = csv.CsvCodec(eol: '\n');
  final input = File('example/datasets/pima_indians_diabetes_database.csv').openRead();
  final fields = (await input.transform(utf8.decoder)
      .transform(csvCodec.decoder).toList())
      .sublist(1);

  List<double> extractFeatures(List<Object> item) =>
      item.map((Object feature) => (feature as num).toDouble()).toList();

  final features = fields
      .map((List item) => Float32x4VectorFactory.from(extractFeatures(item.sublist(0, item.length - 1))))
      .toList(growable: false);

  final labels = Float32x4VectorFactory.from(fields.map((List<dynamic> item) => (item.last as num).toDouble()));
  final logisticRegressor = LogisticRegressor(iterationLimit: 100, learningRate: 0.0531, batchSize: 768,
    learningRateType: LearningRateType.constant, fitIntercept: true);
  final validator = CrossValidator<Float32x4List, Float32List, Float32x4>.kFold(numberOfFolds: 7);

  print('Logistic regression, error on cross validation: ');
  print('${(validator.evaluate(logisticRegressor, features, labels, MetricType.accuracy) * 100).toStringAsFixed(2)}%');
}