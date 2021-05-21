namespace Nitro {
  class Data {
    Data() {
      this.DisplaySpeed = 0;
      this.EngineCurGear = 0;
      this.EngineRpm = 0.0f;
      this.InputIsBraking = false;
      this.InputGasPedal = 0.0f;
    }

    int DisplaySpeed;
    int EngineCurGear;
    float EngineRpm;
    bool InputIsBraking;
    float InputGasPedal;
  }
}
