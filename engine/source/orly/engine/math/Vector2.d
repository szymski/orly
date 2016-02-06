module orly.engine.math.vector2;

import std.math;

class Vector2 {
	
	float x, y;

	public this() {
	
	}

	public this(float x, float y) {
		X = x;
		Y = y;
	}

	@property ref float X() { return x; }
	@property ref float Y() { return y; }

	@property float Length() { return sqrt(x * x + y * y); }

	@property Vector2 Normalized() {
		float m = Length;
		return new Vector2(x / m, y / m);
	}

}

unittest {
	Vector2 vec = new Vector2(1, 2);

	assert(vec.X == 1);
	assert(vec.Y == 2);

	vec = new Vector2(12, 8);
}