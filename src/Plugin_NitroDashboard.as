#name               "Nitro Dashboard"
#author             "NitroQuery"
#category           "Utilities"
#version            "0.2.0"
#min_game_version   "2021-05-20"

// Positioning settings
[Setting name="Position X" min=0 max=1]
float setting_posX = 0.65;
[Setting name="Position Y" min=0 max=1]
float setting_posY = 1.0;

// Scale setting
[Setting name="Scale" min=0.5 max=2.0]
float setting_scale = 1.0;

// Background color setting
[Setting name="Background color R"]
float setting_bgColorR = 0.730f;
[Setting name="Background color G"]
float setting_bgColorG = 0.850f;
[Setting name="Background color B"]
float setting_bgColorB = 0.950f;
[Setting name="Background color A"]
float setting_bgColorA = 0.900f;

[Setting name="RPM fill color R"]
float setting_rpmFillColorR = 0.600;
[Setting name="RPM fill color G"]
float setting_rpmFillColorG = 0.900;
[Setting name="RPM fill color B"]
float setting_rpmFillColorB = 1.000;
[Setting name="RPM fill color A"]
float setting_rpmFillColorA = 0.300;

[Setting name="RPM fill gear down color R"]
float setting_rpmFillGearDownColorR = 0.700;
[Setting name="RPM fill gear Down color G"]
float setting_rpmFillGearDownColorG = 0.700;
[Setting name="RPM fill gear Down color B"]
float setting_rpmFillGearDownColorB = 0.020;
[Setting name="RPM fill gear Down color A"]
float setting_rpmFillGearDownColorA = 0.300;

[Setting name="RPM Fill gear up color R"]
float setting_rpmFillGearUpColorR = 0.250;
[Setting name="RPM Fill gear up color G"]
float setting_rpmFillGearUpColorG = 0.700;
[Setting name="RPM Fill gear Up color B"]
float setting_rpmFillGearUpColorB = 0.020;
[Setting name="RPM Fill gear up color A"]
float setting_rpmFillGearUpColorA = 0.300;

[Setting name="RPM Fill high rev color R"]
float setting_rpmFillHighColorR = 0.800;
[Setting name="RPM Fill high rev color G"]
float setting_rpmFillHighColorG = 0.000;
[Setting name="RPM Fill high rev color B"]
float setting_rpmFillHighColorB = 0.000;
[Setting name="RPM Fill high rev color A"]
float setting_rpmFillHighColorA = 0.300;

[Setting name="Font color R"]
float setting_fontColorR = 0.100;
[Setting name="Font color G"]
float setting_fontColorG = 0.300;
[Setting name="Font color B"]
float setting_fontColorB = 0.400;
[Setting name="Font color A"]
float setting_fontColorA = 1.000;

[Setting name="Rpm digits font color R"]
float setting_fontRpmDigitColorR = 0.100;
[Setting name="Rpm digits font color G"]
float setting_fontRpmDigitColorG = 0.400;
[Setting name="Rpm digits font color B"]
float setting_fontRpmDigitColorB = 0.700;
[Setting name="Rpm digits font color A"]
float setting_fontRpmDigitColorA = 1.000;

[Setting name="RPM step color R"]
float setting_rpmStepColorR = 0.090;
[Setting name="RPM step color G"]
float setting_rpmStepColorG = 0.000;
[Setting name="RPM step color B"]
float setting_rpmStepColorB = 0.400;
[Setting name="RPM step color A"]
float setting_rpmStepColorA = 1.000;

[Setting name="Edge color R"]
float setting_rpmEdgeColorR = 0.090;
[Setting name="Edge color G"]
float setting_rpmEdgeColorG = 0.000;
[Setting name="Edge color B"]
float setting_rpmEdgeColorB = 0.400;
[Setting name="Edge color A"]
float setting_rpmEdgeColorA = 1.000;

[Setting name="RPM needle color R"]
float setting_rpmNeedleColorR = 1.000;
[Setting name="RPM needle color G"]
float setting_rpmNeedleColorG = 0.000;
[Setting name="RPM needle color B"]
float setting_rpmNeedleColorB = 0.000;
[Setting name="RPM needle color A"]
float setting_rpmNeedleColorA = 1.000;

// OP Libs
#include "Icons.as";

// Nitro libs
#include "Dashboard.as";

Nitro::Dashboard ndash = Nitro::Dashboard();

// Plugin Main
void Main() {
  ndash.Init();
}

// Plugin Update
void Update(float dt) {
  ndash.Update(dt);
}

// Plugin RenderMenu
void RenderMenu() {
  vec3 color(1.0f, 1.0f, 1.0f);
  if (UI::BeginMenu("\\$09f" + Icons::Car + "\\$z Nitro Dashboard")) {

    if (UI::BeginMenu("Position & Scale")) {
      // Horizontal position
      setting_posX = UI::SliderFloat("Position X", setting_posX, 0, 1.0f);

      // Vertical position
      setting_posY = UI::SliderFloat("Position Y", setting_posY, 0, 1.0f);

      //  Scale
      setting_scale = UI::SliderFloat("Scale", setting_scale, 0.5, 1.5f);
      UI::EndMenu();
    }

    if (UI::BeginMenu("Theme")) {
      if (UI::BeginMenu("Base colors")) {
        color = vec3(setting_bgColorR, setting_bgColorG, setting_bgColorB);
        color = UI::InputColor3("Background Color", color);
        setting_bgColorR = color.x;
        setting_bgColorG = color.y;
        setting_bgColorB = color.z;
        setting_bgColorA = UI::SliderFloat("Background Color Alpha", setting_bgColorA, 0.0f, 1.0f);
        UI::EndMenu();
      }

      if (UI::BeginMenu("Rpm colors")) {
        color = vec3(setting_rpmFillColorR, setting_rpmFillColorG, setting_rpmFillColorB);
        color = UI::InputColor3("RPM fill Color", color);
        setting_rpmFillColorR = color.x;
        setting_rpmFillColorG = color.y;
        setting_rpmFillColorB = color.z;
        setting_rpmFillColorA = UI::SliderFloat("RPM fill Color Alpha", setting_rpmFillColorA, 0.0f, 1.0f);
        UI::Separator();

        color = vec3(setting_rpmFillGearDownColorR, setting_rpmFillGearDownColorG, setting_rpmFillGearDownColorB);
        color = UI::InputColor3("RPM Fill Gear Down", color);
        setting_rpmFillGearDownColorR = color.x;
        setting_rpmFillGearDownColorG = color.y;
        setting_rpmFillGearDownColorB = color.z;
        setting_rpmFillGearDownColorA = UI::SliderFloat("RPM Fill Gear Down Alpha", setting_rpmFillGearDownColorA, 0.0f, 1.0f);
        UI::Separator();

        color = vec3(setting_rpmFillGearUpColorR, setting_rpmFillGearUpColorG, setting_rpmFillGearUpColorB);
        color = UI::InputColor3("RPM Fill Gear Up", color);
        setting_rpmFillGearUpColorR = color.x;
        setting_rpmFillGearUpColorG = color.y;
        setting_rpmFillGearUpColorB = color.z;
        setting_rpmFillGearUpColorA = UI::SliderFloat("RPM Fill Gear Up Alpha", setting_rpmFillGearUpColorA, 0.0f, 1.0f);
        UI::Separator();

        color = vec3(setting_rpmFillHighColorR, setting_rpmFillHighColorG, setting_rpmFillHighColorB);
        color = UI::InputColor3("RPM Fill High rev", color);
        setting_rpmFillHighColorR = color.x;
        setting_rpmFillHighColorG = color.y;
        setting_rpmFillHighColorB = color.z;
        setting_rpmFillHighColorA = UI::SliderFloat("RPM Fill High rev Alpha", setting_rpmFillHighColorA, 0.0f, 1.0f);
        UI::Separator();

        color = vec3(setting_rpmStepColorR, setting_rpmStepColorG, setting_rpmStepColorB);
        color = UI::InputColor3("Step Color", color);
        setting_rpmStepColorR = color.x;
        setting_rpmStepColorG = color.y;
        setting_rpmStepColorB = color.z;
        setting_rpmStepColorA = UI::SliderFloat("Step Color Alpha", setting_rpmStepColorA, 0.0f, 1.0f);

        UI::Separator();
        color = vec3(setting_rpmEdgeColorR, setting_rpmEdgeColorG, setting_rpmEdgeColorB);
        color = UI::InputColor3("Edge Color", color);
        setting_rpmEdgeColorR = color.x;
        setting_rpmEdgeColorG = color.y;
        setting_rpmEdgeColorB = color.z;
        setting_rpmEdgeColorA = UI::SliderFloat("Edge Color Alpha", setting_rpmEdgeColorA, 0.0f, 1.0f);
        UI::Separator();

        color = vec3(setting_rpmNeedleColorR, setting_rpmNeedleColorG, setting_rpmNeedleColorB);
        color = UI::InputColor3("Needle Color", color);
        setting_rpmNeedleColorR = color.x;
        setting_rpmNeedleColorG = color.y;
        setting_rpmNeedleColorB = color.z;
        setting_rpmNeedleColorA = UI::SliderFloat("Needle Color Alpha", setting_rpmNeedleColorA, 0.0f, 1.0f);
        UI::Separator();
        
        UI::EndMenu();
      }

      if (UI::BeginMenu("Font colors")) {
        color = vec3(setting_fontColorR, setting_fontColorG, setting_fontColorB);
        color = UI::InputColor3("Font Color", color);
        setting_fontColorR = color.x;
        setting_fontColorG = color.y;
        setting_fontColorB = color.z;
        setting_fontColorA = UI::SliderFloat("Font Color Alpha", setting_fontColorA, 0.0f, 1.0f);

        color = vec3(setting_fontRpmDigitColorR, setting_fontRpmDigitColorG, setting_fontRpmDigitColorB);
        color = UI::InputColor3("Rpm Digits Font Color", color);
        setting_fontRpmDigitColorR = color.x;
        setting_fontRpmDigitColorG = color.y;
        setting_fontRpmDigitColorB = color.z;
        setting_fontRpmDigitColorA = UI::SliderFloat("Rpm Digits Font Color Alpha", setting_fontRpmDigitColorA, 0.0f, 1.0f);
        UI::EndMenu();
      }

      UI::EndMenu();
    }

    UI::EndMenu();
  }
}

// Plugin Render
void Render() {
  ndash.Render();
}
