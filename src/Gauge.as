namespace Nitro {
  class Gauge : OpenUtils::Widget {

    private bool GearDown;
    private bool GearUp;
    private uint RPM = 1000;
    private uint Speed = 0;
    private uint Gear = 1;
    private bool TractionControl = false;
    private bool Icing = false;
    private bool EngineOff = false;
    private bool AirBrake = false;
    private bool IsTurbo = false;
    private bool Wet = false;
    private CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl ReactorBoostLvl;

    Resources::Texture@ tractionIcon;
    Resources::Texture@ engineFaultIcon;
    Resources::Texture@ icingIcon;
    Resources::Texture@ airbrakeIcon;
    Resources::Texture@ inactiveIcon;
    Resources::Texture@ wetIcon;

    // Contruct Gauge Widget
    Gauge() {
      super("Gauge");
      @tractionIcon = Resources::GetTexture("assets/images/icons/traction.png");
      @engineFaultIcon = Resources::GetTexture("assets/images/icons/engine-fault.png");
      @icingIcon = Resources::GetTexture("assets/images/icons/icing.png");
      @airbrakeIcon = Resources::GetTexture("assets/images/icons/airbrake.png");
      @inactiveIcon = Resources::GetTexture("assets/images/icons/inactive.png");
      @wetIcon = Resources::GetTexture("assets/images/icons/wet.png");
    }

    void UpdateVechicleData(CSceneVehicleVisState@ state) {
      if (Setting_Enabled_Demo) return;

      uint rpm = uint(Vehicle::GetRPM(state));
      this.Speed = uint(Math::Abs(state.FrontSpeed * 3.6f));
      this.EngineOff = rpm == 0 && this.Speed > 0;
      if (rpm < 1000 && !this.EngineOff) rpm += 1000;
      this.RPM = rpm;
      this.Gear = state.CurGear;
      this.GearUp = false;
      this.GearDown = false;
      this.IsTurbo = state.IsTurbo;
      this.ReactorBoostLvl = state.ReactorBoostLvl;

      this.Wet = state.WetnessValue01 > 0;
      this.AirBrake = state.AirBrakeNormed > 0 && !state.IsGroundContact;
      this.Icing = (state.FLIcing01 + state.FRIcing01 + state.RLIcing01 + state.RRSlipCoef) > 1;

      this.TractionControl = false;
      if (state.IsGroundContact) {
        switch (Setting_Traction_Behaviour) {
          case TractionBehaviour::FrontWheelsOnly:
            this.TractionControl = (state.FLSlipCoef + state.FRSlipCoef) > 0.0f;
            break;
          case TractionBehaviour::AllWheels:
            this.TractionControl = (state.FLSlipCoef + state.FRSlipCoef + state.RLSlipCoef + state.RRSlipCoef) > 0.0f;
            break;
          default: // TractionBehaviour::RearWheelsOnly
            this.TractionControl = (state.RLSlipCoef + state.RRSlipCoef) > 0.0f;
            break;
        }
      }

      // Gear up/down
      switch (this.Gear) {
        case 1:
          if (rpm > 10000) {
            this.GearUp = true;
          }
        break;
        case 2:
          if (rpm > 9500) {
            this.GearUp = true;
          } else if (rpm < 5750) {
            this.GearDown = true;
          }
        break;
        case 3:
          if (rpm > 10000) {
            this.GearUp = true;
          } else if (rpm < 6600) {
            this.GearDown = true;
          }
        case 4:
          if (rpm > 10000) {
            this.GearUp = true;
          } else if (rpm < 6250) {
            this.GearDown = true;
          }
        break;
        case 5:
          if (rpm < 7000) {
            this.GearDown = true;
          }
        break;
        default:
          this.GearUp = false;
        break;
      }
    }

    // Render Gauge
    void Render(OpenUtils::Theme theme) override {
      if (!this.Visible) return;

      vec2 screen = vec2(Draw::GetWidth(), Draw::GetHeight());
      int size = int(screen.x * Setting_Gauge_Scale);
      float startAngle = 140.0f;
      float endAngle = 375.0f;
      float angleTotal = endAngle - startAngle;
      float innerRadius = size * 0.425;
      float outerRadius = size * 0.475;
      float xs, ys, xe, ye, angle;

      vec2 pose = screen * Setting_Gauge_Pos;

      // background
      nvg::BeginPath();
      nvg::Rect(pose.x - (size / 2), pose.y - (size / 2), size, size);
      nvg::FillPaint(nvg::RadialGradient(vec2(pose.x, pose.y), size * 0.475, size * 0.5, theme.Background, vec4(0, 0, 0, 0)));
      nvg::Fill();
      nvg::ClosePath();

      vec4 stateColor = theme.Accent;

      // Boost
      switch (this.ReactorBoostLvl) {
        case CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl::Lvl1:
          stateColor = theme.Warning;
        break;
        case CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl::Lvl2:
          stateColor = theme.Negative;
        break;
        default:
          if (this.RPM > 10500) {
            stateColor = theme.Negative;
          } else if (this.GearDown || this.IsTurbo) {
            stateColor = theme.Warning;
          } else if (this.GearUp) {
            stateColor = theme.Positive;
          }
        break;
      }

      nvg::StrokeColor(stateColor);
      nvg::StrokeWidth(size * 0.04f);
      nvg::BeginPath();
      nvg::Arc(pose, size * 0.45, OpenUtils::DegreeToRadiant(startAngle), OpenUtils::DegreeToRadiant(startAngle + (angleTotal * (this.RPM * 0.0001))), nvg::Winding::CW);
      nvg::Stroke();
      nvg::ClosePath();

      // Inner Ring
      nvg::StrokeColor(theme.Secondary);
      nvg::StrokeWidth(size * 0.003f);
      nvg::BeginPath();
      nvg::Arc(pose, innerRadius, OpenUtils::DegreeToRadiant(startAngle), OpenUtils::DegreeToRadiant(endAngle + 24), nvg::Winding::CW);
      nvg::Stroke();
      nvg::ClosePath();

      // Outer Ring
      nvg::StrokeColor(theme.Secondary);
      nvg::StrokeWidth(size * 0.003f);
      nvg::BeginPath();
      nvg::Arc(pose, outerRadius, OpenUtils::DegreeToRadiant(startAngle), OpenUtils::DegreeToRadiant(endAngle + 24), nvg::Winding::CW);
      nvg::Stroke();
      nvg::ClosePath();

      float iconSize = size * 0.09;
      // Engine Fault
      this.renderDashIcon(this.EngineOff, engineFaultIcon, vec2(pose.x - (size * 0.23), pose.y - (size * 0.12)), iconSize);

      // Traction
      this.renderDashIcon(this.TractionControl, tractionIcon, vec2(pose.x - (size * 0.16), pose.y - (size * 0.215)), iconSize);

      // Icing
      this.renderDashIcon(this.Icing, icingIcon, vec2(pose.x - (size * 0.05), pose.y - (size * 0.25)), iconSize);

      // AirBrake
      this.renderDashIcon(this.AirBrake, airbrakeIcon, vec2(pose.x + (size * 0.06), pose.y - (size * 0.22)), iconSize);

      // Wet
      this.renderDashIcon(this.Wet, wetIcon, vec2(pose.x + (size * 0.14), pose.y - (size * 0.13)), iconSize);


      // Change font
      nvg::FontFace(font);

      // Draw steps
      nvg::StrokeColor(theme.Primary);
      nvg::StrokeWidth((size * 0.005f));
      int fontSizeRpmDigits = int(size * 0.075);
      nvg::FillColor(theme.Secondary);
      nvg::FontSize(fontSizeRpmDigits);
      nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);
      nvg::FillColor(theme.Primary);
      for(int i = 0; i < 12; i++)	{
        nvg::BeginPath();
        angle = startAngle + (angleTotal * 0.1 * float(i));
        xs = pose.x + innerRadius * Math::Cos(OpenUtils::DegreeToRadiant(angle));
        ys = pose.y + innerRadius * Math::Sin(OpenUtils::DegreeToRadiant(angle));
        xe = pose.x + outerRadius * Math::Cos(OpenUtils::DegreeToRadiant(angle));
        ye = pose.y + outerRadius * Math::Sin(OpenUtils::DegreeToRadiant(angle));
        nvg::MoveTo(vec2(xs, ys));
        nvg::LineTo(vec2(xe, ye));
        nvg::Stroke();
        nvg::ClosePath();

        xs = pose.x + (innerRadius - (size * 0.04f)) * Math::Cos(OpenUtils::DegreeToRadiant(angle));
        ys = pose.y + (innerRadius - (size * 0.04f)) * Math::Sin(OpenUtils::DegreeToRadiant(angle));
        nvg::Text(xs, ys, i + "");
      }

      // rpm label
      int fontSizeLabel = int(0.06 * size);
      nvg::FillColor(theme.Secondary);
      nvg::FontSize(fontSizeLabel);
      nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);
      nvg::Text(pose.x - (fontSizeLabel*0.05), pose.y + (fontSizeLabel*-5), "RPM x 1000");

      // Draw needle
      nvg::StrokeColor(theme.Primary);
      nvg::StrokeWidth(size * 0.01f);
      nvg::BeginPath();
      xs = pose.x + (innerRadius/3) * Math::Cos(OpenUtils::DegreeToRadiant(startAngle + (angleTotal * 0.0001 * this.RPM)));
      ys = pose.y + (innerRadius/3) * Math::Sin(OpenUtils::DegreeToRadiant(startAngle + (angleTotal * 0.0001 * this.RPM)));
      xe = pose.x + innerRadius * Math::Cos(OpenUtils::DegreeToRadiant(startAngle + (angleTotal * 0.0001 * this.RPM)));
      ye = pose.y + innerRadius * Math::Sin(OpenUtils::DegreeToRadiant(startAngle + (angleTotal * 0.0001 * this.RPM)));
      nvg::MoveTo(vec2(xs, ys));
      nvg::LineTo(vec2(xe, ye));
      nvg::Stroke();
      nvg::ClosePath();

      // center background border
      nvg::BeginPath();
      nvg::Circle(pose, size / 7);
      nvg::FillPaint(nvg::RadialGradient(pose, size * 0.21, size * 0.22, vec4(theme.Secondary.x, theme.Secondary.y, theme.Secondary.z, 0.7), vec4(theme.Dark.x, theme.Dark.y, theme.Dark.z, 0)));
      nvg::Fill();
      nvg::ClosePath();

      // center background
      nvg::BeginPath();
      nvg::Circle(pose, size / 8);
      nvg::FillColor(theme.Background);
      nvg::Fill();
      nvg::ClosePath();

      // Gear
      string gear;
      if (this.Speed < 2) {
        gear = "N";
      } else if (this.Gear == 0) {
        gear = "R";
      } else {
        gear = this.Gear + "";
      }

      int fontSizeGear = int(0.25 * size);

      switch (this.ReactorBoostLvl) {
        case CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl::Lvl1:
          nvg::FillColor(theme.Warning);
        break;
        case CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl::Lvl2:
          nvg::FillColor(theme.Negative);
        break;
        default:
          nvg::FillColor(theme.Secondary);
        break;
      }
      nvg::FontSize(fontSizeGear);
      nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);
      nvg::Text(pose.x - (fontSizeGear*0.08), pose.y + (fontSizeGear*0.05), gear);

      // Speed
      float fontSizeSpeed = 0.15 * size;
      string speed = "" + this.Speed;
      nvg::FillColor(theme.Primary);
      nvg::FontSize(fontSizeSpeed);
      nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);
      nvg::Text(pose.x - (fontSizeGear*0.05), pose.y + (fontSizeSpeed*2), speed);

      // Speed label
      nvg::FillColor(theme.Secondary);
      nvg::FontSize(fontSizeLabel);
      nvg::TextAlign(nvg::Align::Center | nvg::Align::Middle);
      nvg::Text(pose.x - (fontSizeLabel*0.05), pose.y + (fontSizeLabel*3.5), "km/h");
    }

    void RenderInterface() override {
      vec3 newpns = this.MoveAndScale(Setting_Gauge_Pos, Setting_Gauge_Scale);
      Setting_Gauge_Pos.x = newpns.x;
      Setting_Gauge_Pos.y = newpns.y;
      Setting_Gauge_Scale = newpns.z;
    }

    // Render dash indicator icons
    void renderDashIcon(bool visible, Resources::Texture@ txt, vec2 pos, float size) {
      UI::DrawList@ draw = UI::GetForegroundDrawList();
      if (visible) draw.AddImage(txt, pos, vec2(size, size));
      else draw.AddImage(inactiveIcon, pos, vec2(size, size));
    }

    // Displays demo data instead of real data.
    // Useful when creating the theme
    void SetVechicleDemoData() {
      uint rpm = uint(Setting_Demo_RPM);
      this.Speed = uint(Setting_Demo_Speed);
      this.EngineOff = (rpm == 0 && this.Speed > 0) || Setting_Demo_EngineFault;
      if (rpm < 1000 && !this.EngineOff) rpm += 1000;
      this.RPM = rpm;
      this.Gear = uint(Setting_Demo_Gear);
      this.GearUp = Setting_Demo_GearState == DemoGearState::GearUp;
      this.GearDown = Setting_Demo_GearState == DemoGearState::GearDown;
      this.TractionControl = Setting_Demo_TractionControl;
      this.Icing = Setting_Demo_Icing;
      this.AirBrake = Setting_Demo_AirBrake;
      this.IsTurbo = Setting_Demo_SpecialState == DemoSpecialState::Turbo;
      this.Wet = Setting_Demo_Wet;
      if (Setting_Demo_SpecialState == DemoSpecialState::ReactorBoostLvl1) {
        this.ReactorBoostLvl = CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl::Lvl1;
      } else if (Setting_Demo_SpecialState == DemoSpecialState::ReactorBoostLvl2) {
        this.ReactorBoostLvl = CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl::Lvl2;
      } else {
        this.ReactorBoostLvl = CSceneVehicleVisState::ESceneVehicleVisReactorBoostLvl::None;
      }

      if (this.Gear == 0) {
        // Gear up/down
        switch (this.Gear) {
          case 1:
            if (rpm > 10000) {
              this.GearUp = true;
            }
          break;
          case 2:
            if (rpm > 9500) {
              this.GearUp = true;
            } else if (rpm < 5750) {
              this.GearDown = true;
            }
          break;
          case 3:
            if (rpm > 10000) {
              this.GearUp = true;
            } else if (rpm < 6600) {
              this.GearDown = true;
            }
          case 4:
            if (rpm > 10000) {
              this.GearUp = true;
            } else if (rpm < 6250) {
              this.GearDown = true;
            }
          break;
          case 5:
            if (rpm < 7000) {
              this.GearDown = true;
            }
          break;
          default:
            this.GearUp = false;
          break;
        }
      }
    }
  }
}
