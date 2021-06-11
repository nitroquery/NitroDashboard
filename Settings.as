[Setting category="General" name="Visible" description="If you have any issues with the Plugin or want to see more features you can report these on Github
\\$69fhttps://github.com/nitroquery/NitroDashboard/issues\\$z"]
bool Setting_Enabled = true;

enum TractionBehaviour {
  RearWheelsOnly, // Default
  FrontWheelsOnly,
  AllWheels,
}

[Setting category="General" name="Traction light behaviour" description="Select which wheel slips trigger the traction light."]
TractionBehaviour Setting_Traction_Behaviour = TractionBehaviour::RearWheelsOnly;

// Positioning settings
[Setting category="Gauge" name="Move/Scale Gauge" description="Move and Scale the Gauge."]
bool Setting_Gauge_MoveAndScale = false;
[Setting category="Gauge" name="Gauge Position"]
vec2 Setting_Gauge_Pos = vec2(0.365f, 0.9f);
[Setting category="Gauge" name="Gauge Scale" min=-0.1 max=1.1]
float Setting_Gauge_Scale = 0.15f;

// Theme Customize
enum CurrentTheme {
  Default,
  Nitro,
  Custom,
}
[Setting category="Theme" name="Theme" description="Select one of the themes or customize it and create your own.
To use custom theme select \\$a87'Custom\\$z'. You can contribute your Theme
by taking your '[Setting category=\"Theme\"' values from Settings.ini file
found in your User Folder and positing them as issue on
\\$69fhttps://github.com/nitroquery/NitroDashboard/issues\\$z"]
CurrentTheme Setting_Theme_Name = CurrentTheme::Default;

[Setting category="Theme" name="Background color" color]
vec4 Setting_Theme_Background = vec4(0.0f, 0.0f, 0.0f, 0.7f);
[Setting category="Theme" name="Primary color" color]
vec4 Setting_Theme_Primary = vec4(0.098f, 0.463f, 0.824f, 1.0f);
[Setting category="Theme" name="Secondary color" color]
vec4 Setting_Theme_Secondary = vec4(0.149f, 0.651f, 0.604f, 1.0f);
[Setting category="Theme" name="Accent color" color]
vec4 Setting_Theme_Accent = vec4(0.612f, 0.153f, 0.69f, 1.0f);
[Setting category="Theme" name="Dark color" color]
vec4 Setting_Theme_Dark = vec4(0.114f, 0.114f, 0.114, 1.0f);
[Setting category="Theme" name="Positive color" color]
vec4 Setting_Theme_Positive = vec4(0.129f, 0.729f, 0.271f, 1.0f);
[Setting category="Theme" name="Negative color" color]
vec4 Setting_Theme_Negative = vec4(0.757f, 0.0f, 0.082f, 1.0f);
[Setting category="Theme" name="Info color" color]
vec4 Setting_Theme_Info = vec4(0.192f, 0.8f, 0.925f, 1.0f);
[Setting category="Theme" name="Warning color" color]
vec4 Setting_Theme_Warning = vec4(0.949f, 0.753f, 0.216f, 1.0f);

// DEMO MODE
[Setting category="Demo Mode" name="Enable Demo Mode" description="Demomode is useful for when customizing your theme."]
bool Setting_Enabled_Demo = false;
[Setting category="Demo Mode" name="Set engine RPM" min=0 max=11000]
int Setting_Demo_RPM = 6500;
[Setting category="Demo Mode" name="Set Speed" min=0 max=700]
int Setting_Demo_Speed = 469;
[Setting category="Demo Mode" name="Set Gear" min=0 max=5]
int Setting_Demo_Gear = 5;

enum DemoGearState {
  Normal,
  GearUp,
  GearDown
}
[Setting category="Demo Mode" name="Set Gear up/down state"]
DemoGearState Setting_Demo_GearState = DemoGearState::GearUp;
[Setting category="Demo Mode" name="Traction Control Light"]
bool Setting_Demo_TractionControl = true;
[Setting category="Demo Mode" name="Icing Light"]
bool Setting_Demo_Icing = true;
[Setting category="Demo Mode" name="Airbrake Light"]
bool Setting_Demo_AirBrake = true;
[Setting category="Demo Mode" name="Engine Fault Light"]
bool Setting_Demo_EngineFault = true;

enum DemoSpecialState {
  Normal,
  Turbo,
  ReactorBoostLvl1,
  ReactorBoostLvl2
}
[Setting category="Demo Mode" name="Special state"]
DemoSpecialState Setting_Demo_SpecialState = DemoSpecialState::Normal;
