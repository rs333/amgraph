enum AdcOutputState { raw, sampled, quantized, encoded }

class AdcData {
  double vMin = -10;
  double vMax = 10;
  double sampleRate = 400;
  int bitsPerSample = 3;
  AdcOutputState show = AdcOutputState.raw;
}
