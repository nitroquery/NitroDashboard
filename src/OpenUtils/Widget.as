namespace OpenUtils {
  // Base class for UI Widgets
  class Widget {
    private string Name = 'Untitled';
    bool Visible = false;

    Widget(string name) {
      this.Name = name;
    }

    void Update(float dt) {}
    void Render(Theme theme) {}
    void RenderInterface() {}

    // Move and scale the widget
    vec3 MoveAndScale(vec2 &in pos, float &in scale) {
      vec2 screen = vec2(Draw::GetWidth(), Draw::GetHeight());
      vec2 wsize = vec2(screen.x * scale, screen.x * scale);
      vec2 wpos = (screen * pos);

      UI::SetNextWindowPos(int(wpos.x-125), int(wpos.y-80), UI::Cond::Appearing);
      UI::SetNextWindowSize(int(250), int(80), UI::Cond::Appearing);
      UI::Begin(Icons::ArrowsAlt + " Move & Scale: " + this.Name, UI::WindowFlags::NoCollapse | UI::WindowFlags::NoSavedSettings | UI::WindowFlags::NoDocking);

      int newx = (UI::SliderInt("Size WxH", int(wsize.x), 32, int(screen.x/2)));

      vec2 newpos = UI::GetWindowPos();
      newpos.x = (newpos.x + 125) / screen.x;
      newpos.y = (newpos.y + 80) / screen.y;
      UI::End();

      return vec3(newpos.x, newpos.y, newx / screen.x);
    }
  }
}
