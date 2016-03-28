module orly.engine.math.vector2;

import std.math;
import std.string : format;

struct Vector2 {
 private:

	float x = 0, y = 0;

 public:

	this(float x = 0, float y = 0) {
		this.x = x;
		this.y = y;
	}

	@property ref float X() { return x; }
	@property ref float Y() { return y; }

	/** Returns the length of the vector. **/
	@property float Length() { return sqrt(x * x + y * y); }

	/**
		Returns a normalized vector.
	*/
	@property Vector2 Normalized() {
		float m = Length;
		return Vector2(x / m, y / m);
	}

	/**
		Returns a copy of the vector.
	*/
	Vector2 Copy() {
		return Vector2(x, y);
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
		static if(op == "+") return Vector2(x + other.x, y + other.y);
		else static if(op == "-") return Vector2(x - other.x, y - other.y);
		else static if(op == "*") return Vector2(x * other.x, y * other.y);
		else static if(op == "/") return Vector2(x / other.x, y / other.y);
	}

	Vector2 opBinary(string op)(int other) {
		static if(op == "*") return Vector2(x * other, y * other);
		else static if(op == "/") return Vector2(x / other, y / other);
	}

	Vector2 opBinary(string op)(float other) {
		static if(op == "*") return Vector2(x * other, y * other);
		else static if(op == "/") return Vector2(x / other, y / other);
	}

	Vector2 opUnary(string op)() if (op == "-")
    {
        return Vector2(-x, -y);
    }

	string toString() {
		return format("Vector2 { %f, %f }", x, y);
	}

 static:

	/**
		Returns distance between two vectors.
	*/
	float Distance(Vector2 left, Vector2 right) {
		return (left - right).Length;
	}

}

unittest {
	Vector2 vec = Vector2(1, 2);

	assert(vec.X == 1);
	assert(vec.Y == 2);

	vec = Vector2(4, 3);
	assert(vec.Length == 5);

	vec = Vector2(12, 8);
	auto vec2 = Vector2(51, 8);

	assert((vec + vec2).X == 63);

	vec = Vector2(1, 1);
	assert((vec * 10).X == 10);
}