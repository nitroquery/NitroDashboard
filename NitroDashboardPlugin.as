Nitro::Dashboard@ dash;

// The main entry point. (Yieldable)
void Main() {
  @dash = Nitro::Dashboard();
  dash.Init();
  refreshTheme();
}

// Called every frame. dt is the delta time (milliseconds since last frame).
void Update(float dt) {
  if (!Setting_Enabled) return;
  dash.Update(dt);
}

// Render function called every frame.
void Render() {
  if (!Setting_Enabled) return;
  dash.Render();
}

// Render function called every frame intended only for menu items in UI.
void RenderMenu() {
  if (UI::MenuItem("\\$a87" + Icons::Car + "\\$z Nitro Dashboard", "", Setting_Enabled)) {
    Setting_Enabled = !Setting_Enabled;
  }
}

// Render function called every frame intended for UI.
// e.g. moving scaling the widgets
void RenderInterface() {
  dash.RenderInterface();
}

// Called when a setting in the settings panel was changed.
void OnSettingsChanged() {
  refreshTheme();
}

// Refresh Theme
void refreshTheme() {
  if (dash is null) {
    return;
  }

  switch (Setting_Theme_Name) {
    case CurrentTheme::Nitro:
      dash.Theme.Background = vec4(0.162162f, 0.162161f, 0.162161f, 0.7f);
      dash.Theme.Primary = vec4(0.888031f, 0.479562f, 0.0137148f, 1.0f);
      dash.Theme.Secondary = vec4(0.772201f, 0.447221f, 0.0f, 1.0f);
      dash.Theme.Accent = vec4(0.915058f, 0.821112f, 0.664212f, 1.0f);
      dash.Theme.Dark = vec4(0.114f, 0.114f, 0.114, 1.0f);
      dash.Theme.Positive = vec4(0.129f, 0.729f, 0.271f, 1.0f);
      dash.Theme.Negative = vec4(0.757f, 0.0f, 0.082f, 1.0f);
      dash.Theme.Info = vec4(0.192f, 0.8f, 0.925f, 1.0f);
      dash.Theme.Warning = vec4(0.949f, 0.753f, 0.216f, 1.0f);
    break;
    case CurrentTheme::Custom:
      dash.Theme.Background = Setting_Theme_Background;
      dash.Theme.Primary = Setting_Theme_Primary;
      dash.Theme.Secondary = Setting_Theme_Secondary;
      dash.Theme.Accent = Setting_Theme_Accent;
      dash.Theme.Dark = Setting_Theme_Accent;
      dash.Theme.Positive = Setting_Theme_Positive;
      dash.Theme.Negative = Setting_Theme_Negative;
      dash.Theme.Info = Setting_Theme_Info;
      dash.Theme.Warning = Setting_Theme_Warning;
    break;
    default: // CurrentTheme::Default
      dash.Theme.Background = vec4(0.0f, 0.0f, 0.0f, 0.7f);
      dash.Theme.Primary = vec4(0.098f, 0.463f, 0.824f, 1.0f);
      dash.Theme.Secondary = vec4(0.149f, 0.651f, 0.604f, 1.0f);
      dash.Theme.Accent = vec4(0.612f, 0.153f, 0.69f, 1.0f);
      dash.Theme.Dark = vec4(0.114f, 0.114f, 0.114, 1.0f);
      dash.Theme.Positive = vec4(0.129f, 0.729f, 0.271f, 1.0f);
      dash.Theme.Negative = vec4(0.757f, 0.0f, 0.082f, 1.0f);
      dash.Theme.Info = vec4(0.192f, 0.8f, 0.925f, 1.0f);
      dash.Theme.Warning = vec4(0.949f, 0.753f, 0.216f, 1.0f);
    break;
  }
}
