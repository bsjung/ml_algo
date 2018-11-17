import 'package:dart_ml/src/metric/classification/accuracy.dart';
import 'package:dart_ml/src/metric/classification/metric.dart';
import 'package:dart_ml/src/metric/classification/type.dart';

abstract class ClassificationMetricFactory {
  static ClassificationMetric accuracy() => const AccuracyMetric();

  static ClassificationMetric createByType(ClassificationMetricType type) {
    ClassificationMetric metric;

    switch (type) {
      case ClassificationMetricType.accuracy:
        metric = accuracy();
        break;

      default:
        throw UnsupportedError('Unsupported classification metric type: ${type}');
    }

    return metric;
  }
}