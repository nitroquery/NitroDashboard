#include "Icons.as"

namespace Nitro {
	#include "Theme.as"
	#include "Helpers.as"
	#include "Data.as"

	Resources::Font@ font;

	class Dashboard {
		// Are we in game should ui be shown
		bool inGame;

		Data data;

		Dashboard() {
			this.data = Data();
		}

		// Init Nitro Dashboard Plugin
		void Init() {
			@font = Resources::GetFont("hemi_head_bd_it.ttf", 32.0f);
		}

		void Update(float dt) {
			// Do nothihing user disabled the dash
			if (!setting_enabled) {
				return;
			}
			if (cast<CSmArenaClient>(GetApp().CurrentPlayground) is null) {
				this.inGame = false;
	      return;
			}

			CSmArenaClient@ playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);

			if(playground.GameTerminals.Length <= 0
       || playground.GameTerminals[0].UISequence_Current != ESGamePlaygroundUIConfig__EUISequence::Playing
       || playground.GameTerminals[0].GUIPlayer is null
       || playground.Arena is null
       || playground.Map is null) {
	      this.inGame = false;
	      return;
	    }

			CGameTerminal@ terminal = cast<CGameTerminal>(playground.GameTerminals[0]);
			CSmPlayer@ player = cast<CSmPlayer>(terminal.GUIPlayer);
	    CSmScriptPlayer@ scriptApi = cast<CSmScriptPlayer>(player.ScriptAPI);

			if(scriptApi is null) {
				this.inGame = false;
				return;
			}
			// Update ingame data used to show in ui
			this.data.DisplaySpeed = scriptApi.Speed * 3.6f;
			this.data.InputIsBraking = scriptApi.InputIsBraking;
			this.data.InputGasPedal = scriptApi.InputGasPedal;

			this.data.EngineRpm = scriptApi.EngineRpm;
			// Visual correction for low rpm nr
			if (scriptApi.EngineRpm < 900) {
				this.data.EngineRpm = 900 + scriptApi.EngineRpm;
			}

			if (scriptApi.EngineCurGear > this.data.EngineCurGear) {
				print(Text::Format("gear up to %d", scriptApi.EngineCurGear) + Text::Format(", speed: %d", this.data.DisplaySpeed) + Text::Format(", rpm: %.f", this.data.EngineRpm));
			} else if (scriptApi.EngineCurGear < this.data.EngineCurGear) {
				print(Text::Format("gear down to %d", scriptApi.EngineCurGear) + Text::Format(", speed: %d", this.data.DisplaySpeed) + Text::Format(", rpm: %.f", this.data.EngineRpm));
			}
			this.data.EngineCurGear = scriptApi.EngineCurGear;

			this.inGame = true;
		}

		// Render function
		void Render() {
			// Do nothing if we are not in game
	    if (!this.inGame || !setting_enabled) {
	      return;
	    }

			int width = Draw::GetWidth();
			int height = Draw::GetHeight();
			Theme theme = Theme();

			float startAngle = 135.0f;
			float endAngle = 405.0f;
			float angleTotal = endAngle - startAngle;
			float fontSizeRpmDigits = (width * 0.014) * setting_scale;
			float fontSizeLabel = (width * 0.01) * setting_scale;
			float fontSizeGear = (width * 0.04) * setting_scale;
			float fontSizeSpeed = (width * 0.02) * setting_scale;

			float radiusOuterRing =  (width * 0.078125) * setting_scale;
			float radiusInnerRing = (width * 0.0703125) * setting_scale;

			float tmp = radiusOuterRing - (radiusOuterRing * Math::Sin(DegreeToRadiant(startAngle)));
			vec2 positionGauge((width - (radiusOuterRing * 2.0f)) * setting_posX + radiusOuterRing, (height - (radiusOuterRing * 2.0f) + tmp) * setting_posY + radiusOuterRing);

			// background
			nvg::BeginPath();
			nvg::Rect(positionGauge.x-radiusOuterRing, positionGauge.y-radiusOuterRing, radiusOuterRing*2, radiusOuterRing*2);
			nvg::FillPaint(nvg::RadialGradient(vec2(positionGauge.x, positionGauge.y), radiusOuterRing*0.975, radiusOuterRing, theme.background, vec4(0, 0, 0, 0)));
			nvg::Fill();
			nvg::ClosePath();

			// Inner Ring
			nvg::StrokeColor(theme.rpmEdge);
			nvg::StrokeWidth((height * 0.001) * setting_scale);
			nvg::BeginPath();
			nvg::Arc(positionGauge, radiusInnerRing, DegreeToRadiant(startAngle), DegreeToRadiant(endAngle), nvg::Winding::CW);
			nvg::Stroke();
			nvg::ClosePath();

			// Outer Ring
			nvg::BeginPath();
			nvg::Arc(positionGauge, radiusOuterRing, DegreeToRadiant(startAngle), DegreeToRadiant(endAngle), nvg::Winding::CW);
			nvg::Stroke();
			nvg::ClosePath();

			// ring bar
			if(this.data.EngineRpm > 7250 and this.data.EngineRpm < 9500) {
				nvg::StrokeColor(theme.rpmFillGearUp);
			} else if (this.data.EngineRpm > 9500) {
				nvg::StrokeColor(theme.rpmFillHigh);
			}	else if (this.data.EngineRpm > 5500 and this.data.EngineRpm < 7251) {
				nvg::StrokeColor(theme.rpmFillGearDown);
			} else {
				nvg::StrokeColor(theme.rpmFill);
			}

			nvg::StrokeWidth(radiusOuterRing - radiusInnerRing);
			nvg::BeginPath();
			nvg::Arc(positionGauge, radiusInnerRing + ((radiusOuterRing - radiusInnerRing) * 0.5f), DegreeToRadiant(startAngle), DegreeToRadiant(startAngle + (angleTotal * 0.000083 * this.data.EngineRpm)), nvg::Winding::CW);
			nvg::Stroke();
			nvg::ClosePath();

			float xs, ys, xe, ye, angle;
			vec2 fvec2;

			// Drav start rpm step
			nvg::StrokeColor(theme.rpmStep);
			nvg::StrokeWidth((height * 0.0015f) * setting_scale);

			// Draw steps
			for(int i = 0; i < 13; i++)	{
				nvg::BeginPath();
				angle = startAngle + angleTotal * 0.083 * float(i);
				xs = positionGauge.x + radiusInnerRing * Math::Cos(DegreeToRadiant(angle));
				ys = positionGauge.y + radiusInnerRing * Math::Sin(DegreeToRadiant(angle));
				xe = positionGauge.x + radiusOuterRing * Math::Cos(DegreeToRadiant(angle));
				ye = positionGauge.y + radiusOuterRing * Math::Sin(DegreeToRadiant(angle));
				nvg::MoveTo(vec2(xs, ys));
				nvg::LineTo(vec2(xe, ye));
				nvg::Stroke();
				nvg::ClosePath();
				fvec2 = Draw::MeasureString(i + "", font, fontSizeRpmDigits);
				fvec2.x = fvec2.x * 0.5f + (height * 0.002f);
				fvec2.y = fvec2.y * 0.5f;
				xs = positionGauge.x + (radiusInnerRing - (height * 0.0148148f)) * Math::Cos(DegreeToRadiant(angle));
				ys = positionGauge.y + (radiusInnerRing - (height * 0.0148148f)) * Math::Sin(DegreeToRadiant(angle));
				Draw::DrawString(vec2(xs, ys) - fvec2, theme.fontRpmDigits, i + "", font, fontSizeRpmDigits);
			}

			// Draw needle
			nvg::StrokeColor(theme.rpmNeedle);
			nvg::StrokeWidth(height * 0.005f);
			nvg::BeginPath();
			xs = positionGauge.x;
			ys = positionGauge.y;
			xe = positionGauge.x + radiusInnerRing * Math::Cos(DegreeToRadiant(startAngle + (angleTotal * 0.000083 * this.data.EngineRpm)));
			ye = positionGauge.y + radiusInnerRing * Math::Sin(DegreeToRadiant(startAngle + (angleTotal * 0.000083 * this.data.EngineRpm)));
			nvg::MoveTo(vec2(xs, ys));
			nvg::LineTo(vec2(xe, ye));
			nvg::Stroke();
			nvg::ClosePath();

			// rpm label
			fvec2 = Draw::MeasureString("rpm", font, fontSizeLabel/2);
			fvec2.y = (height * 0.10f) * setting_scale;
			Draw::DrawString(vec2(positionGauge.x - fvec2.x, positionGauge.y - fvec2.y + (height * 0.005f)), theme.font, "rpm", font, fontSizeLabel);
			fvec2 = Draw::MeasureString("X 100", font, fontSizeLabel/2);
			fvec2.y = (height * 0.085f) * setting_scale;
			Draw::DrawString(vec2(positionGauge.x - fvec2.x, positionGauge.y - fvec2.y + (height * 0.005f)), theme.font, "x 1000", font, fontSizeLabel/1.3);

			// Gear
			string gear;
			if (this.data.DisplaySpeed < 2) {
				gear = "N";
			} else if (this.data.EngineCurGear == 0) {
				gear = "R";
			} else {
				gear = this.data.EngineCurGear + "";
			}
			fvec2 = Draw::MeasureString(gear, font, fontSizeGear/2);
			fvec2.y = (height * 0.08f) * setting_scale;
			Draw::DrawString(vec2(positionGauge.x - fvec2.x, positionGauge.y - fvec2.y + (height * 0.005f)), theme.font, gear, font, fontSizeGear);

			// Speed label
			fvec2 = Draw::MeasureString("km/h", font, fontSizeLabel/2);
			fvec2.y = (height * -0.03f) * setting_scale;
			Draw::DrawString(vec2(positionGauge.x - fvec2.x, positionGauge.y - fvec2.y + (height * 0.005f)), theme.font, "km/h", font, fontSizeLabel);

			// Break indicator
			float dotSize = fontSizeSpeed/2;
			if (this.data.InputIsBraking) {
				nvg::BeginPath();
				float breakDotX = positionGauge.x - (fvec2.x * 2.5);
				float breakDotY = positionGauge.y - (fvec2.y * 1.15);
				nvg::Rect(breakDotX, breakDotY, dotSize, dotSize);
				nvg::FillPaint(nvg::RadialGradient(vec2(breakDotX+(dotSize/2), breakDotY+(dotSize/2)), dotSize/4, dotSize/2, vec4(1, 0, 0, 1), vec4(0, 0, 0, 0)));
				nvg::Fill();
				nvg::ClosePath();
			}
			if (this.data.InputGasPedal > 0) {
				nvg::BeginPath();
				float gasDotX = positionGauge.x - (fvec2.x * -1.5);
				float gasDotY = positionGauge.y - (fvec2.y * 1.15);
				nvg::Rect(gasDotX, gasDotY, dotSize, dotSize);
				nvg::FillPaint(nvg::RadialGradient(vec2(gasDotX+(dotSize/2), gasDotY+(dotSize/2)), dotSize/4, dotSize/2, vec4(0, 1, 0, 1), vec4(0, 0, 0, 0)));
				nvg::Fill();
				nvg::ClosePath();
			}

			// Speed
			fvec2 = Draw::MeasureString(this.data.DisplaySpeed + "", font, fontSizeSpeed/2);
			fvec2.y = (height * -0.05) * setting_scale;
			Draw::DrawString(vec2(positionGauge.x - fvec2.x, positionGauge.y - fvec2.y + (height * 0.005f)), theme.font, this.data.DisplaySpeed + "", font, fontSizeSpeed);
		}
	}
}
