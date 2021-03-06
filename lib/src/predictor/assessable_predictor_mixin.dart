import 'package:ml_algo/src/helpers/features_target_split.dart';
import 'package:ml_algo/src/metric/factory.dart';
import 'package:ml_algo/src/metric/metric_type.dart';
import 'package:ml_algo/src/model_selection/assessable.dart';
import 'package:ml_algo/src/predictor/predictor.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

mixin AssessablePredictorMixin implements Assessable, Predictor {
  @override
  double assess(DataFrame samples, Iterable<String> targetNames,
      MetricType metricType) {
    final splits = featuresTargetSplit(samples,
      targetNames: targetNames,
    ).toList();

    final metric = MetricFactory.createByType(metricType);
    final prediction = predict(splits[0]);
    final origLabels = splits[1].toMatrix(dtype);

    return metric.getScore(prediction.toMatrix(dtype), origLabels);
  }
}
