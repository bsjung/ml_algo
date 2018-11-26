import 'dart:typed_data';

import 'package:dart_ml/src/data_preprocessing/intercept_preprocessor.dart';
import 'package:dart_ml/src/score_to_prob_link_function/link_function.dart' as scoreToProbLink;
import 'package:dart_ml/src/metric/factory.dart';
import 'package:dart_ml/src/metric/type.dart';
import 'package:dart_ml/src/model_selection/evaluable.dart';
import 'package:dart_ml/src/optimizer/optimizer.dart';
import 'package:linalg/linalg.dart';

abstract class LinearClassifier implements Evaluable<Float32x4> {

  final Optimizer<Float32x4> _optimizer;
  final _weightsByClasses = <Vector<Float32x4>>[];
  final scoreToProbLink.ScoreToProbLinkFunction _linkScoreToProbability;
  final InterceptPreprocessor _interceptPreprocessor;

  LinearClassifier(this._optimizer, this._linkScoreToProbability, double interceptScale) :
        _interceptPreprocessor = InterceptPreprocessor(interceptScale: interceptScale);

  List<Vector<Float32x4>> get weightsByClasses => _weightsByClasses;
  Vector<Float32x4> get classLabels => _classLabels;
  Vector<Float32x4> _classLabels;

  @override
  void fit(
    List<Vector<Float32x4>> features,
    Vector<Float32x4> origLabels,
    {
      Vector<Float32x4> initialWeights,
      bool isDataNormalized = false
    }
  ) {
    _classLabels = origLabels.unique();
    final _features = _interceptPreprocessor.addIntercept(features);
    for (int i = 0; i < _classLabels.length; i++) {
      final targetLabel =_classLabels[i];
      final labels = _makeLabelsOneVsAll(origLabels, targetLabel);
      _weightsByClasses.add(_optimizer.findExtrema(_features, labels,
        initialWeights: initialWeights,
        arePointsNormalized: isDataNormalized,
        isMinimizingObjective: false
      ));
    }
  }

  Vector<Float32x4> _makeLabelsOneVsAll(Vector<Float32x4> origLabels, double targetLabel) {
    final target = Float32x4.splat(targetLabel);
    final zero = Float32x4.zero();
    return origLabels
        .vectorizedMap((Float32x4 element) => element.equal(target).select(element, zero));
  }

  @override
  double test(
    List<Vector<Float32x4>> features,
    Vector<Float32x4> origLabels,
    MetricType metricType
  ) {
    final metric = MetricFactory.createByType(metricType);
    final prediction = predictClasses(features);
    return metric.getError(prediction, origLabels);
  }

  List<Vector<Float32x4>> predictProbabilities(List<Vector<Float32x4>> features, {bool interceptConsidered = false}) {
    final _features = !interceptConsidered ? _interceptPreprocessor.addIntercept(features) : features;
    final distributions = List<Vector<Float32x4>>(_features.length);
    for (int i = 0; i < _features.length; i++) {
      final probabilities = List<double>(_weightsByClasses.length);
      for (int i = 0; i < _weightsByClasses.length; i++) {
        final score = _weightsByClasses[i].dot(_features[i]);
        probabilities[i] = _linkScoreToProbability(score);
      }
      distributions[i] = Float32x4VectorFactory.from(probabilities);
    }
    return distributions;
  }

  Vector<Float32x4> predictClasses(List<Vector<Float32x4>> features, {bool interceptConsidered = false}) {
    final _features = interceptConsidered ? features : _interceptPreprocessor.addIntercept(features);
    final distributions = predictProbabilities(_features, interceptConsidered: true);
    final classes = List<double>(_features.length);
    for (int i = 0; i < distributions.length; i++) {
      final probabilities = distributions[i];
      classes[i] = probabilities.toList().indexOf(probabilities.max()) * 1.0;
    }
    return Float32x4VectorFactory.from(classes);
  }
}
