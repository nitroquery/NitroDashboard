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
  dash.Theme.Background = Setting_Theme_Background;
  dash.Theme.Primary = Setting_Theme_Primary;
  dash.Theme.Secondary = Setting_Theme_Secondary;
  dash.Theme.Accent = Setting_Theme_Accent;
  dash.Theme.Dark = Setting_Theme_Accent;
  dash.Theme.Positive = Setting_Theme_Positive;
  dash.Theme.Negative = Setting_Theme_Negative;
  dash.Theme.Info = Setting_Theme_Info;
  dash.Theme.Warning = Setting_Theme_Warning;
}
