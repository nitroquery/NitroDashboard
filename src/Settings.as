[Setting category="General" name="Visible"]
bool Setting_Enabled = true;

// Positioning settings
[Setting category="Gauge" name="Move/Scale Gauge" description="Move and Scale the Gauge."]
bool Setting_Gauge_MoveAndScale = false;
[Setting category="Gauge" name="Gauge Position"]
vec2 Setting_Gauge_Pos = vec2(0.670f, 0.875f);
[Setting category="Gauge" name="Gauge Scale" min=-0.1 max=1.1]
float Setting_Gauge_Scale = 0.18f;

[Setting category="Customize" name="Background color" color]
vec4 Setting_Theme_Background = vec4(0.0f, 0.0f, 0.0f, 0.7f);
[Setting category="Customize" name="Primary color" color]
vec4 Setting_Theme_Primary = vec4(0.098f, 0.463f, 0.824f, 1.0f);
[Setting category="Customize" name="Secondary color" color]
vec4 Setting_Theme_Secondary = vec4(0.149f, 0.651f, 0.604f, 1.0f);
[Setting category="Customize" name="Accent color" color]
vec4 Setting_Theme_Accent = vec4(0.612f, 0.153f, 0.69f, 1.0f);
[Setting category="Customize" name="Dark color" color]
vec4 Setting_Theme_Dark = vec4(0.114f, 0.114f, 0.114, 1.0f);
[Setting category="Customize" name="Positive color" color]
vec4 Setting_Theme_Positive = vec4(0.129f, 0.729f, 0.271f, 1.0f);
[Setting category="Customize" name="Negative color" color]
vec4 Setting_Theme_Negative = vec4(0.757f, 0.0f, 0.082f, 1.0f);
[Setting category="Customize" name="Info color" color]
vec4 Setting_Theme_Info = vec4(0.192f, 0.8f, 0.925f, 1.0f);
[Setting category="Customize" name="Warning color" color]
vec4 Setting_Theme_Warning = vec4(0.949f, 0.753f, 0.216f, 1.0f);

[Setting category="Demo" name="Enable Demo Mode"]
bool Setting_Enabled_Demo = false;
[Setting category="Demo" name="Set engine RPM" min=0 max=11000]
int Setting_Demo_RPM = 6500;
[Setting category="Demo" name="Set Speed" min=0 max=700]
int Setting_Demo_Speed = 469;
[Setting category="Demo" name="Set Gear" min=0 max=5]
int Setting_Demo_Gear = 5;

enum DemoGearState {
  Normal,
  GearUp,
  GearDown
}
[Setting category="Demo" name="Set Gear up/down state"]
DemoGearState Setting_Demo_GearState = DemoGearState::GearUp;
[Setting category="Demo" name="Traction Control Light"]
bool Setting_Demo_TractionControl = true;
[Setting category="Demo" name="Icing Light"]
bool Setting_Demo_Icing = true;
[Setting category="Demo" name="Airbrake Light"]
bool Setting_Demo_AirBrake = true;
[Setting category="Demo" name="Engine Fault Light"]
bool Setting_Demo_EngineFault = true;

enum DemoSpecialState {
  Normal,
  Turbo,
  ReactorBoostLvl1,
  ReactorBoostLvl2
}
[Setting category="Demo" name="Special state"]
DemoSpecialState Setting_Demo_SpecialState = DemoSpecialState::Normal;
