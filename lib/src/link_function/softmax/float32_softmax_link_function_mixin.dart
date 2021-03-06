import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

mixin Float32SoftmaxLinkFunction {
  Matrix float32x4ScoresToProbs(Matrix scores) {
    final maxValue = scores.max();
    final stableScores = scores - maxValue;
    final allProba = _toFloat32x4Probs(stableScores);
    final summedProba = allProba
        .reduceColumns(
            (Vector resultColumn, Vector scores) => resultColumn + scores);
    return allProba / summedProba;
  }

  Matrix _toFloat32x4Probs(Matrix scores) =>
      scores.fastMap<Float32x4>(_float32x4Logit);

  Float32x4 _float32x4Logit(Float32x4 scores) => Float32x4(
    //@TODO: find a more efficient way to raise exponent to the float power in SIMD way
    math.exp(scores.x),
    math.exp(scores.y),
    math.exp(scores.z),
    math.exp(scores.w),
  );
}