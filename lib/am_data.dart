class Sinusoid {
  double amplitude = 0;
  double frequency = 0;
  double phase = 0;
  Sinusoid(this.amplitude, this.frequency, this.phase);
}

class AmData {
  Sinusoid modulator = Sinusoid(5, 100, 0);
  bool showModulator = true;
  Sinusoid carrier = Sinusoid(5, 4000, 0);
  bool showCarrier = true;
  bool showAm = true;
}
