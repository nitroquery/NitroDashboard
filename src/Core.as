namespace Nitro {
  class Core {
    bool InGame;

    CTrackMania@ app;

    Core() {

    }

    void Tick(float dt) {
      @this.app = cast<CTrackMania>(GetApp());

      this.InGame = true;
    }

    ISceneVis@ Scene() {
      return this.app.GameScene;
    }

    CSmPlayer@ Player() {
      if (this.app.CurrentPlayground is null) {
        return null;
      }
      if (this.app.CurrentPlayground.GameTerminals.Length <= 0
        || this.app.CurrentPlayground.GameTerminals[0].GUIPlayer is null) {
        this.InGame = false;
        return null;
      }
      this.InGame = false;
      CSmPlayer@ player = cast<CSmPlayer>(this.app.CurrentPlayground.GameTerminals[0].GUIPlayer);
      if (player is null) {
        this.InGame = false;
      }
      return player;
    }
  }
}
