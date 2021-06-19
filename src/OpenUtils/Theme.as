namespace OpenUtils {
  // Theme is common shared theme for different plugins
  class Theme {
    vec4 Background;
    vec4 Primary;
    vec4 Secondary;
    vec4 Accent;
    vec4 Dark;
    vec4 Positive;
    vec4 Negative;
    vec4 Info;
    vec4 Warning;

    // Contruc default theme
    Theme() {
      this.Background = vec4(0,0,0, 0.7);
      this.Primary = vec4(0.098,0.463,0.824, 1);
      this.Secondary = vec4(0.149,0.651,0.604, 1);
      this.Accent = vec4(0.612,0.153,0.69, 1);
      this.Dark = vec4(0.114,0.114,0.114, 1);
      this.Positive = vec4(0.129,0.729,0.271, 1);
      this.Negative = vec4(0.757,0.,0.082, 1);
      this.Info = vec4(0.192,0.8,0.925, 1);
      this.Warning = vec4(0.949,0.753,0.216, 1);
    }
  }
}
