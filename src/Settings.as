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
