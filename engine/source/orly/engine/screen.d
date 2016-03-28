module orly.engine.screen;

import orly.engine.backend.ibackend;
import orly.engine.math.vector2;

final static class Screen {
 private:
	

 public:
	
	@property static int Width() { return Backend.Width; }
	@property static void Width(int value) { Backend.SetWindowSize(value, Height); }

	@property static int Height() { return Backend.Height; }
	@property static void Height(int value) { Backend.SetWindowSize(Width, value); }

	@property static Vector2 Size() { return Vector2(Width, Height); };
	@property static void Size(Vector2 size) { Backend.SetWindowSize(cast(int)size.X, cast(int)size.Y); };

}