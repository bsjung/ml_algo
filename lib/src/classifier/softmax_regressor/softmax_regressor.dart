import 'package:ml_algo/src/classifier/linear_classifier.dart';
import 'package:ml_algo/src/classifier/softmax_regressor/_helpers/create_softmax_regressor.dart';
import 'package:ml_algo/src/linear_optimizer/gradient_optimizer/learning_rate_generator/learning_rate_type.dart';
import 'package:ml_algo/src/linear_optimizer/initial_coefficients_generator/initial_coefficients_type.dart';
import 'package:ml_algo/src/linear_optimizer/linear_optimizer_type.dart';
import 'package:ml_algo/src/linear_optimizer/regularization_type.dart';
import 'package:ml_algo/src/model_selection/assessable.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';

/// A class that performs softmax regression-based classification
///
/// Softmax regression is an algorithm that solves a multiclass classification
/// problem. The algorithm uses maximization of the passed
/// data likelihood (as well as
/// [Logistic regression](https://en.wikipedia.org/wiki/Logistic_regression).
/// In other words, the regressor iteratively tries to select coefficients,
/// that makes combination of passed features and their coefficients most
/// likely. But, instead of [Logit link function](https://en.wikipedia.org/wiki/Logit)
/// it uses [Softmax link function](https://en.wikipedia.org/wiki/Softmax_function),
/// that's why the algorithm has such a name.
///
/// Also, it is worth to mention, that the algorithm is a generalization of
/// [Logistic regression](https://en.wikipedia.org/wiki/Logistic_regression))
abstract class SoftmaxRegressor implements LinearClassifier, Assessable {
  /// Parameters:
  ///
  /// [trainData] A [DataFrame] with observations, that will be used by the
  /// classifier to learn coefficients. Must contain [targetNames] columns.
  ///
  /// [targetNames] A collection of strings, that serves as names for the
  /// encoded target columns (a column, that contains class labels or outcomes
  /// for the associated features).
  ///
  /// [optimizerType] Defines an algorithm of optimization, that will be used
  /// to find the best coefficients of log-likelihood cost function. Also
  /// defines, which regularization type (L1 or L2) one may use to learn a
  /// logistic regressor.
  ///
  /// [iterationsLimit] A number of fitting iterations. Uses as a condition of
  /// convergence in the optimization algorithm. Default value is `100`.
  ///
  /// [initialLearningRate] A value, defining velocity of the convergence of the
  /// gradient descent optimizer. Default value is `1e-3`.
  ///
  /// [minCoefficientsUpdate] A minimum distance between coefficient vectors in
  /// two contiguous iterations. Uses as a condition of convergence in the
  /// optimization algorithm. If difference between the two vectors is small
  /// enough, there is no reason to continue fitting. Default value is `1e-12`.
  ///
  /// [lambda] A coefficient of regularization. Uses to prevent the regressor's
  /// overfitting. The more the value of [lambda], the more regular the
  /// coefficients of the equation of the predicting hyperplane are. Extremely
  /// large [lambda] may decrease the coefficients to nothing, otherwise too
  /// small [lambda] may be a cause of too large absolute values of the
  /// coefficients, that is also bad.
  ///
  /// [regularizationType] A way the coefficients of the classifier will be
  /// regularized to prevent a model overfitting.
  ///
  /// [randomSeed] A seed, that will be passed to a random value generator,
  /// used by stochastic optimizers. Will be ignored, if the solver cannot be
  /// stochastic. Remember, each time you run the stochastic regressor with the
  /// same parameters but with unspecified [randomSeed], you will receive
  /// different results. To avoid it, define [randomSeed]
  ///
  /// [batchSize] A size of data (in rows), that will be used for fitting per
  /// one iteration. Applicable not for all optimizers. If gradient-based
  /// optimizer uses and If [batchSize] == `1`, stochastic mode will be
  /// activated; if `1` < [batchSize] < `total number of rows`, mini-batch mode
  /// will be activated; if [batchSize] == `total number of rows`, full-batch
  /// mode will be activated.
  ///
  /// [fitIntercept] Whether or not to fit intercept term. Default value is
  /// `false`. Intercept in 2-dimensional space is a bias of the line (relative
  /// to X-axis) to be learned by the classifier.
  ///
  /// [interceptScale] A value, defining a size of the intercept.
  ///
  /// [learningRateType] A value, defining a strategy for the learning rate
  /// behaviour throughout the whole fitting process.
  ///
  /// [isFittingDataNormalized] Defines, whether the [trainData] normalized
  /// or not. Normalization should be performed column-wise. Normalized data
  /// may be needed for some optimizers (e.g., for
  /// [LinearOptimizerType.coordinate])
  ///
  /// [initialCoefficientsType] Defines the coefficients, that will be
  /// autogenerated before the first iteration of optimization. By default,
  /// all the autogenerated coefficients are equal to zeroes at the start.
  /// If [initialCoefficients] are provided, the parameter will be ignored
  ///
  /// [initialCoefficients] Coefficients to be used in the first iteration of
  /// an optimization algorithm. [initialCoefficients] is a [Matrix], where the
  /// number of columns must be equal to the number of classes (or
  /// length of [targetNames]) and the number of rows must be equal to the
  /// number of features in [trainData]. In other words, every column of
  /// [initialCoefficients] matrix is a vector of coefficients of a certain
  /// class.
  ///
  /// [positiveLabel] Defines the value, that will be used for `positive` class.
  /// By default, `1`.
  ///
  /// [negativeLabel] Defines the value, that will be used for `negative` class.
  /// By default, `0`.
  ///
  /// [dtype] A data type for all the numeric values, used by the algorithm. Can
  /// affect performance or accuracy of the computations. Default value is
  /// [DType.float32]
  factory SoftmaxRegressor(
      DataFrame trainData,
      List<String> targetNames,
      {
        LinearOptimizerType optimizerType = LinearOptimizerType.gradient,
        int iterationsLimit = 100,
        double initialLearningRate = 1e-3,
        double minCoefficientsUpdate = 1e-12,
        double lambda,
        RegularizationType regularizationType,
        int randomSeed,
        int batchSize = 1,
        bool fitIntercept = false,
        double interceptScale = 1.0,
        LearningRateType learningRateType,
        bool isFittingDataNormalized,
        InitialCoefficientsType initialCoefficientsType =
            InitialCoefficientsType.zeroes,
        Matrix initialCoefficients,
        num positiveLabel = 1,
        num negativeLabel = 0,
        DType dtype = DType.float32,
      }
  ) => createSoftmaxRegressor(
    trainData,
    targetNames,
    optimizerType,
    iterationsLimit,
    initialLearningRate,
    minCoefficientsUpdate,
    lambda,
    regularizationType,
    randomSeed,
    batchSize,
    fitIntercept,
    interceptScale,
    learningRateType,
    isFittingDataNormalized,
    initialCoefficientsType,
    initialCoefficients,
    positiveLabel,
    negativeLabel,
    dtype,
  );
}
