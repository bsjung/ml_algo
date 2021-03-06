import 'package:ml_algo/src/classifier/linear_classifier.dart';
import 'package:ml_algo/src/helpers/add_intercept_if.dart';
import 'package:ml_algo/src/helpers/validate_coefficients_matrix.dart';
import 'package:ml_algo/src/helpers/validate_test_features.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/matrix.dart';

mixin LinearClassifierMixin implements LinearClassifier {
  @override
  DataFrame predictProbabilities(DataFrame testFeatures) {
    final probabilities = getProbabilitiesMatrix(testFeatures);

    return DataFrame.fromMatrix(
      probabilities,
      header: classNames,
    );
  }

  Matrix getProbabilitiesMatrix(DataFrame testFeatures) {
    validateTestFeatures(testFeatures, dtype);

    final processedFeatures = addInterceptIf(
      fitIntercept,
      testFeatures.toMatrix(dtype),
      interceptScale,
    );

    validateCoefficientsMatrix(coefficientsByClasses,
        processedFeatures.columnsNum);

    return linkFunction
        .link(processedFeatures * coefficientsByClasses);
  }
}
