namespace Nitro {
  class Theme {
		// Colors
		vec4 background;
		vec4 rpmEdge;
		vec4 rpmStep;
		vec4 rpmNeedle;
		vec4 rpmFill;
		vec4 rpmFillGearDown;
		vec4 rpmFillGearUp;
		vec4 rpmFillHigh;
		vec4 font;
		vec4 fontRpmDigits;

		Theme() {
			this.background = vec4(setting_bgColorR, setting_bgColorG, setting_bgColorB, setting_bgColorA);
			this.rpmEdge = vec4(setting_rpmEdgeColorR, setting_rpmEdgeColorG, setting_rpmEdgeColorB, setting_rpmEdgeColorA);
			this.rpmStep = vec4(setting_rpmStepColorR, setting_rpmStepColorG, setting_rpmStepColorB, setting_rpmStepColorA);
			this.rpmNeedle = vec4(setting_rpmNeedleColorR, setting_rpmNeedleColorG, setting_rpmNeedleColorB, setting_rpmNeedleColorA);
			this.rpmFill = vec4(setting_rpmFillColorR, setting_rpmFillColorG, setting_rpmFillColorB, setting_rpmFillColorA);
			this.rpmFillGearDown = vec4(setting_rpmFillGearDownColorR, setting_rpmFillGearDownColorG, setting_rpmFillGearDownColorB, setting_rpmFillGearDownColorA);
			this.rpmFillGearUp = vec4(setting_rpmFillGearUpColorR, setting_rpmFillGearUpColorG, setting_rpmFillGearUpColorB, setting_rpmFillGearUpColorA);
			this.rpmFillHigh = vec4(setting_rpmFillHighColorR, setting_rpmFillHighColorG, setting_rpmFillHighColorB, setting_rpmFillHighColorA);
			this.font = vec4(setting_fontColorR, setting_fontColorG, setting_fontColorB, setting_fontColorA);
			this.fontRpmDigits = vec4(setting_fontRpmDigitColorR, setting_fontRpmDigitColorG, setting_fontRpmDigitColorB, setting_fontRpmDigitColorA);
		}
	}
}
