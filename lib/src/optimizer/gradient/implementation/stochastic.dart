part of gradient_optimizer_base;

class SGDOptimizerImpl extends GradientOptimizerImpl implements SGDOptimizer {
  final Randomizer _randomizer = injector.get(Randomizer);

  @override
  Iterable<int> _getSamplesRange(int totalSamplesCount) {
    int k = _randomizer.getIntegerFromInterval(0, totalSamplesCount);
    return [k, k + 1];
  }
}
