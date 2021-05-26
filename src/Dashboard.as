#include "Core.as";
#include "Vehicle.as";
#include "Theme.as";

namespace Nitro {
  Resources::Font@ font;

  class Dashboard {
    Nitro::Core core;
    Theme theme;
    float Gear = 0;
    // Init Nitro Dashboard Plugin
    Dashboard() {
      this.core = Nitro::Core();
		}

    // Init Nitro Dashboard Plugin
		void Init() {
      @font = Resources::GetFont("hemi_head_bd_it.ttf");
    }

    void Update(float dt) {
      this.core.Tick(dt);
      this.theme = Theme();
    }

    // Render function
		void Render() {
      // Do nothing if we are not in game
	    if (!this.core.InGame) {
	      return;
	    }

      CSmPlayer@ player = this.core.Player();
      if (player is null) {
        return;
      }

      Nitro::Vehicle vehicle = Nitro::Vehicle(this.core.Scene(), player);
      if (vehicle.State is null) {
        return;
      }

      int width = Draw::GetWidth();
			int height = Draw::GetHeight();

      // Set Size
      float size = (width * 0.15) * setting_scale;
      // Set Position
      float posX = (width - size) * setting_posX + (size/2);
      float posY = (height - (size / 2)) * 1.03;
      vec2 pose = vec2(posX, posY);

      float startAngle = 140.0f;
      float endAngle = 375.0f;
      float angleTotal = endAngle - startAngle;

      // background
      nvg::BeginPath();
      nvg::Rect(pose.x-(size/2), pose.y-(size/2), size, size);
      nvg::FillPaint(nvg::RadialGradient(vec2(pose.x, pose.y), size*0.475, size*0.5, this.theme.background, vec4(0, 0, 0, 0)));
      nvg::Fill();
      nvg::ClosePath();

      // Rpm Bar
      vec4 gearIndicatorColor = this.theme.rpmFill;
      if (vehicle.RPM > 10500.0f) {
        gearIndicatorColor = this.theme.rpmFillHigh;
      } else if (vehicle.IsGearingDown) {
        gearIndicatorColor = this.theme.rpmFillGearDown;
      } else if (vehicle.IsGearingUp) {
        gearIndicatorColor = this.theme.rpmFillGearUp;
      }
      nvg::StrokeColor(gearIndicatorColor);

      nvg::StrokeWidth(size * 0.03f);
      nvg::BeginPath();
      nvg::Arc(pose, size*0.46, DegreeToRadiant(startAngle), DegreeToRadiant(startAngle + (angleTotal * (vehicle.RPM * 0.0001))), nvg::Winding::CW);
      nvg::Stroke();
      nvg::ClosePath();

      float fontSizeRpmDigits = (width * 0.01) * setting_scale;
      float outerRadius = size * 0.48;
      float innerRadius = size * 0.425;
      float xs, ys, xe, ye, angle;
      vec2 fvec2;

      // Inner Ring
      nvg::StrokeColor(theme.rpmEdge);
      nvg::StrokeWidth((height * 0.001) * setting_scale);
      nvg::BeginPath();
      nvg::Arc(pose, innerRadius, DegreeToRadiant(startAngle), DegreeToRadiant(endAngle+24), nvg::Winding::CW);
      nvg::Stroke();
      nvg::ClosePath();

      // Draw steps
      nvg::StrokeColor(this.theme.rpmStep);
      nvg::StrokeWidth((height * 0.0015f) * setting_scale);
      for(int i = 0; i < 12; i++)	{
        nvg::BeginPath();
        angle = startAngle + (angleTotal * 0.1 * float(i));
        xs = pose.x + innerRadius * Math::Cos(DegreeToRadiant(angle));
        ys = pose.y + innerRadius * Math::Sin(DegreeToRadiant(angle));
        xe = pose.x + outerRadius * Math::Cos(DegreeToRadiant(angle));
        ye = pose.y + outerRadius * Math::Sin(DegreeToRadiant(angle));
        nvg::MoveTo(vec2(xs, ys));
        nvg::LineTo(vec2(xe, ye));
        nvg::Stroke();
        nvg::ClosePath();
        fvec2 = Draw::MeasureString(i + "", font, fontSizeRpmDigits);
        fvec2.x = fvec2.x * 0.425f + (height * 0.002166f);
        fvec2.y = fvec2.y * 0.425f;
        xs = pose.x + (innerRadius - (height * 0.015f)) * Math::Cos(DegreeToRadiant(angle));
        ys = pose.y + (innerRadius - (height * 0.015f)) * Math::Sin(DegreeToRadiant(angle));
        Draw::DrawString(vec2(xs, ys) - fvec2, theme.fontRpmDigits, i + "", font, fontSizeRpmDigits);
      }

      // rpm label
      float fontSizeLabel = (width * 0.0075) * setting_scale;
      fvec2 = Draw::MeasureString("RPM x 1000", font, fontSizeLabel/2);
      fvec2.y = (height * 0.09f) * setting_scale;
      Draw::DrawString(vec2(pose.x - fvec2.x, pose.y - fvec2.y + (height * 0.005f)), theme.font, "RPM x 1000", font, fontSizeLabel);

      // Draw needle
      nvg::StrokeColor(theme.rpmNeedle);
      nvg::StrokeWidth(height * 0.005f);
      nvg::BeginPath();
      xs = pose.x + (innerRadius/2) * Math::Cos(DegreeToRadiant(startAngle + (angleTotal * 0.0001 * vehicle.RPM)));
      ys = pose.y + (innerRadius/2) * Math::Sin(DegreeToRadiant(startAngle + (angleTotal * 0.0001 * vehicle.RPM)));
      xe = pose.x + innerRadius * Math::Cos(DegreeToRadiant(startAngle + (angleTotal * 0.0001 * vehicle.RPM)));
      ye = pose.y + innerRadius * Math::Sin(DegreeToRadiant(startAngle + (angleTotal * 0.0001 * vehicle.RPM)));
      nvg::MoveTo(vec2(xs, ys));
      nvg::LineTo(vec2(xe, ye));
      nvg::Stroke();
      nvg::ClosePath();

      // gear background
      nvg::BeginPath();
      nvg::Rect(pose.x-(size/4), pose.y-(size/4), (size/2), (size/2));
      nvg::FillPaint(nvg::RadialGradient(vec2(pose.x, pose.y), size*0.21, size*0.22, vec4(0, 0, 0, 0.8), vec4(0, 0, 0, 0)));
      nvg::Fill();
      nvg::ClosePath();

      // Gear
      string gear;
      if (vehicle.Speed < 2) {
        gear = "N";
      } else if (vehicle.State.CurGear == 0) {
        gear = "R";
      } else {
        gear = vehicle.State.CurGear + "";
      }

      float fontSizeGear = (width * 0.04) * setting_scale;
      fvec2 = Draw::MeasureString(gear, font, fontSizeGear/2);
      fvec2.y = (height * 0.075f) * setting_scale;
      Draw::DrawString(vec2(pose.x - fvec2.x, pose.y - (fvec2.y/2)), vec4(gearIndicatorColor.x, gearIndicatorColor.y, gearIndicatorColor.z, 1.0f), gear, font, fontSizeGear);


      // Speed
      float fontSizeSpeed = (width * 0.02) * setting_scale;
      string speed = Text::Format("%.f", vehicle.Speed);
      fvec2 = Draw::MeasureString(speed, font, fontSizeSpeed/2);
      fvec2.y = (height * -0.07) * setting_scale;
      Draw::DrawString(vec2(pose.x - fvec2.x, pose.y - fvec2.y), theme.font, speed, font, fontSizeSpeed);
      // Speed label
      fvec2 = Draw::MeasureString("km/h", font, fontSizeLabel/2);
      fvec2.y = (height * -0.055f) * setting_scale;
      Draw::DrawString(vec2(pose.x - fvec2.x, pose.y - fvec2.y + (height * 0.005f)), theme.font, "km/h", font, fontSizeLabel);

      // Break indicator
      float dotSize = fontSizeSpeed/2;
      if (vehicle.State.InputIsBraking) {
        nvg::BeginPath();
        float breakDotX = pose.x - (fvec2.x * 0.5);
        float breakDotY = pose.y - (fvec2.y * 0.6);
        nvg::Rect(breakDotX, breakDotY, dotSize, dotSize);
        nvg::FillPaint(nvg::RadialGradient(vec2(breakDotX+(dotSize/2), breakDotY+(dotSize/2)), dotSize/4, dotSize/2, vec4(1, 0, 0, 1), vec4(0, 0, 0, 0)));
        nvg::Fill();
        nvg::ClosePath();
      }

      if (vehicle.State.InputGasPedal > 0) {
        nvg::BeginPath();
        float gasDotX = pose.x - (fvec2.x * 0.5);
        float gasDotY = pose.y - (fvec2.y * -0.9);
        nvg::Rect(gasDotX, gasDotY, dotSize, dotSize);
        nvg::FillPaint(nvg::RadialGradient(vec2(gasDotX+(dotSize/2), gasDotY+(dotSize/2)), dotSize/4, dotSize/2, vec4(0, 1, 0, 1), vec4(0, 0, 0, 0)));
        nvg::Fill();
        nvg::ClosePath();
      }

      if (vehicle.State.InputSteer < 0) {
        nvg::BeginPath();
        float gasDotX = pose.x - (fvec2.x * 4);
        float gasDotY = pose.y - (fvec2.y * -0.0001);
        nvg::Rect(gasDotX, gasDotY, dotSize, dotSize);
        nvg::FillPaint(nvg::RadialGradient(vec2(gasDotX+(dotSize/2), gasDotY+(dotSize/2)), dotSize/4, dotSize/2, this.theme.rpmFillGearDown, vec4(0, 0, 0, 0)));
        nvg::Fill();
        nvg::ClosePath();
      }
      if (vehicle.State.InputSteer > 0) {
        nvg::BeginPath();
        float gasDotX = pose.x - (fvec2.x * -2.5);
        float gasDotY = pose.y - (fvec2.y * -0.0001);
        nvg::Rect(gasDotX, gasDotY, dotSize, dotSize);
        nvg::FillPaint(nvg::RadialGradient(vec2(gasDotX+(dotSize/2), gasDotY+(dotSize/2)), dotSize/4, dotSize/2, this.theme.rpmFillGearDown, vec4(0, 0, 0, 0)));
        nvg::Fill();
        nvg::ClosePath();
      }
    }
  }
}
