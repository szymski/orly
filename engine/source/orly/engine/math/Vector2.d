module orly.engine.math.vector2;

import std.math;

class Vector2 {
 private:

	float x, y;

 public:

	this() {
	
	}

	this(float x, float y) {
		this.x = x;
		this.y = y;
	}

	@property ref float X() { return x; }
	@property ref float Y() { return y; }

	@property float Length() { return sqrt(x * x + y * y); }

	@property Vector2 Normalized() {
		float m = Length;
		return new Vector2(x / m, y / m);
	}

	static float Distance(Vector2 left, Vector2 right) {
		return (left - right).Length;
	}

	/*
		Operator overloading
	*/

	void opOpAssign(string op)(Vector2 other) {
		static if(op == "+") {
			x += other.x;
			y += other.y;
		}
		else static if(op == "-") {
			x -= other.x;
			y -= other.y;
		}
		else static if(op == "*") {
			x *= other.x;
			y *= other.y;
		}
		else static if(op == "/") {
			x /= other.x;
			y /= other.y;
		}
	}

	void opOpAssign(string op)(float other) {
		static if(op == "*") {
			x *= other;
			y *= other;
		}
		else static if(op == "/") {
			x /= other;
			y /= other;
		}
	}

	Vector2 opBinary(string op)(Vector2 other) {
		static if(op == "+") return new Vector2(x + other.x, y + other.y);
		else static if(op == "-") return new Vector2(x - other.x, y - other.y);
		else static if(op == "*") return new Vector2(x * other.x, y * other.y);
		else static if(op == "/") return new Vector2(x / other.x, y / other.y);
	}

	Vector2 opBinary(string op)(int other) {
		static if(op == "*") return new Vector2(x * other, y * other);
		else static if(op == "/") return new Vector2(x / other, y / other);
	}

	Vector2 opBinary(string op)(float other) {
		static if(op == "*") return new Vector2(x * other, y * other);
		else static if(op == "/") return new Vector2(x / other, y / other);
	}

	Vector2 opUnary(string op)() if (op == "-")
    {
        return new Vector2(-x, -y);
    }
}

unittest {
	Vector2 vec = new Vector2(1, 2);

	assert(vec.X == 1);
	assert(vec.Y == 2);

	vec = new Vector2(4, 3);
	assert(vec.Length == 5);

	vec = new Vector2(12, 8);
	auto vec2 = new Vector2(51, 8);

	assert((vec + vec2).X == 63);

	vec = new Vector2(1, 1);
	assert((vec * 10).X == 10);
}