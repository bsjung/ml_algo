import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:csv/csv.dart' as csv;

List<List<double>> features;
MLVector<Float32x4> labels;
LogisticRegressor regressor;

class LogisticRegressorBenchmark extends BenchmarkBase {
  const LogisticRegressorBenchmark() : super('Logistic regressor');

  static void main() {
    const LogisticRegressorBenchmark().report();
  }

  @override
  void run() {
    regressor.fit(Float32x4MatrixFactory.from(features), labels);
  }

  @override
  void setup() {
    regressor = LogisticRegressor();
  }

  void tearDown() {}
}

Future logisticRegression() async {
  final csvCodec = csv.CsvCodec(eol: '\n');
  final input = File('example/datasets/pima_indians_diabetes_database.csv').openRead();
  final fields = (await input.transform(utf8.decoder).transform(csvCodec.decoder).toList()).sublist(1);

  List<double> extractFeatures(List<Object> item) => item.map((Object feature) => (feature as num).toDouble()).toList();

  features = fields.map((List item) => extractFeatures(item.sublist(0, item.length - 1))).toList(growable: false);
  labels = Float32x4VectorFactory.from(fields.map((List item) => (item.last as num).toDouble()));

  LogisticRegressorBenchmark.main();
}
