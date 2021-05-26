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
      float posY = (height - size) * setting_posY + (size/2);
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
      fvec2.y = (height * 0.08f) * setting_scale;
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

      // center background
      nvg::BeginPath();
      nvg::Rect(pose.x-(size/4), pose.y-(size/4), (size/2), (size/2));
      nvg::FillPaint(nvg::RadialGradient(vec2(pose.x, pose.y), size*0.21, size*0.22, vec4(0, 0, 0, 0.5), vec4(0, 0, 0, 0)));
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

      float fontSizeGear = (width * 0.025) * setting_scale;
      fvec2 = Draw::MeasureString(gear, font, fontSizeGear/2);
      fvec2.y = (height * 0.045f) * setting_scale;
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
      if (vehicle.State.InputIsBraking) {
        float fontSizeBreak = (width * 0.01) * setting_scale;
        fvec2 = Draw::MeasureString("BRAKE", font, fontSizeBreak/2);
        fvec2.y = (height * -0.025f) * setting_scale;

        nvg::BeginPath();
        nvg::Rect(pose.x - (fvec2.x * 1.2), pose.y - fvec2.y + (height * -0.0025f), size*0.2, size*0.1);
        nvg::FillColor(vec4(1, 0, 0, 0.5));
        nvg::Fill();
        nvg::ClosePath();

        Draw::DrawString(vec2(pose.x - fvec2.x, pose.y - fvec2.y + (height * 0.005f)), vec4(1.0f, 1.0f, 1.0f, 1.0f), "BRAKE", font, fontSizeBreak);

      }

      // Gas pedal
      int ssize = 25 * setting_scale;
      float gasX = pose.x - (ssize * 0.5);
      float gasY = (pose.y - (ssize * 0.8));
      this.RenderArrow(ssize, vec2(gasX, gasY), vec4(1.0f, 1.0f, 1.0f, 0.5f), 300.0f, 1.0);
      if (vehicle.State.InputGasPedal > 0) {
        this.RenderArrow(ssize, vec2(gasX, gasY), this.theme.rpmFillGearUp, 300.0f, vehicle.State.InputGasPedal);
      }

      // Steer right
      float stearRX = pose.x + (size * 0.08);
      float stearRY = (pose.y + (ssize / 2) - ssize);
      this.RenderArrow(ssize, vec2(stearRX, stearRY), vec4(1.0f, 1.0f, 1.0f, 0.5f), 30.0, 1.0);
      if (vehicle.State.InputSteer > 0) {
        this.RenderArrow(ssize, vec2(stearRX, stearRY), this.theme.rpmFillGearDown , 30.0, vehicle.State.InputSteer);
      }
      // Steer left
      float stearLX = pose.x + (size * -0.08);
      float stearLY = pose.y + (ssize / 2);
      this.RenderArrow(ssize, vec2(stearLX, stearLY), vec4(1.0f, 1.0f, 1.0f, 0.5f), 210.0, 1.0);
      if (vehicle.State.InputSteer < 0) {
        this.RenderArrow(ssize, vec2(stearLX, stearLY), this.theme.rpmFillGearDown , 210.0, Math::Abs(vehicle.State.InputSteer));
      }
    }

    void RenderArrow(int _size, vec2 coords, vec4 color, float angle, float percent)
    {
      nvg::BeginPath();
      nvg::MoveTo(coords);
      vec2 next_coords = rotate(vec2(_size, 0), angle)*percent + coords;
      vec2 next_coords_2 = rotate(vec2(_size, 0), angle+60.0) + coords;
      nvg::LineTo(next_coords);
      if(percent != 1.0) {
        vec2 normal_next_coords = rotate(vec2(_size, 0), angle) + coords;
        vec2 next_quad_coord = (normal_next_coords - next_coords_2)*percent + next_coords_2;
        nvg::LineTo(next_quad_coord);
      }
      nvg::LineTo(next_coords_2);
      nvg::LineTo(coords);
      nvg::FillColor(color);
      nvg::Fill();
      nvg::ClosePath();
    }
  }
}
