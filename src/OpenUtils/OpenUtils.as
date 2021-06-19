namespace OpenUtils {
  float DegreeToRadiant(float degrees) { return degrees * Math::PI / 180.0f; }

  // GetGUIPlayer
  // Returns Currently active player
  CSmPlayer@ GetGUIPlayer() {
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    if (app.CurrentPlayground is null) {
      return null;
    }
    if (app.CurrentPlayground.GameTerminals.Length <= 0
      || app.CurrentPlayground.GameTerminals[0].GUIPlayer is null) {
      return null;
    }
    return cast<CSmPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer);
  }
}
