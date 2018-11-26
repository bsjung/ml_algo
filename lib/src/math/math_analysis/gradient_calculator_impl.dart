import 'dart:typed_data';

import 'package:dart_ml/src/math/math_analysis/gradient_calculator.dart';
import 'package:linalg/linalg.dart';

class GradientCalculatorImpl implements GradientCalculator<Float32x4> {

  List<Vector<Float32x4>> _argumentDeltaMatrix;
  double _argumentDelta;

  @override
  Vector<Float32x4> getGradient(
    OptimizationFunction<Float32x4> function,
    Vector<Float32x4> targetVector,
    Iterable<Vector<Float32x4>> vectorArgs,
    Iterable<double> scalarArgs,
    double argumentDelta
  ) {
    if (argumentDelta != _argumentDelta) {
      _argumentDeltaMatrix = _generateArgumentsDeltaMatrix(argumentDelta, targetVector.length);
      _argumentDelta = argumentDelta;
    }
    final gradient = List<double>.generate(
      targetVector.length,
      (int position) => _partialDerivative(
        function,
        argumentDelta,
        targetVector,
        vectorArgs,
        scalarArgs,
        position
      ));
    return Float32x4VectorFactory.from(gradient);
  }

  double _partialDerivative(
    OptimizationFunction<Float32x4> function,
    double argumentDelta,
    Vector<Float32x4> targetVector,
    Iterable<Vector<Float32x4>> vectorArgs,
    Iterable<double> scalarArgs,
    int targetArgPosition
  ) {
    final deltaK = _argumentDeltaMatrix[targetArgPosition];
    return (function(targetVector + deltaK, vectorArgs, scalarArgs) -
            function(targetVector - deltaK, vectorArgs, scalarArgs)) / 2 / argumentDelta;
  }

  List<Vector<Float32x4>> _generateArgumentsDeltaMatrix(double delta, int length) {
    final matrix = List<Vector<Float32x4>>(length);
    for (int i = 0; i < length; i++) {
      matrix[i] = Float32x4VectorFactory.from(List<double>.generate(length, (int idx) => idx == i ? delta : 0.0));
    }
    return matrix;
  }
}
