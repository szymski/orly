module orly.engine.math.vector3;

import std.math;

class Vector3 {
	
	float x, y, z;

	public this() {
	
	}

	public this(float x, float y, float z) {
		X = x;
		Y = y;
		Z = z;
	}

	@property ref float X() { return x; }
	@property ref float Y() { return y; }
	@property ref float Z() { return z; }

	@property float Length() { return sqrt(x * x + y * y + z * z); }

	@property Vector3 Normalized() {
		float m = Length;
		return new Vector3(x / m, y / m, z / m);
	}

	public static float Distance(Vector3 left, Vector3 right) {
		return (left - right).Length;
	}

	/*
		Operator overloading
	*/

	void opOpAssign(string op)(Vector3 other) {
		static if(op == "+") {
			x += other.x;
			y += other.y;
			z += other.z;
		}
		else static if(op == "-") {
			x -= other.x;
			y -= other.y;
			z -= other.z;
		}
		else static if(op == "*") {
			x *= other.x;
			y *= other.y;
			z *= other.z;
		}
		else static if(op == "/") {
			x /= other.x;
			y /= other.y;
			z /= other.z;
		}
	}

	void opOpAssign(string op)(float other) {
		static if(op == "*") {
			x *= other;
			y *= other;
			z *= other;
		}
		else static if(op == "/") {
			x /= other;
			y /= other;
			z /= other;
		}
	}

	Vector3 opBinary(string op)(Vector3 other) {
		static if(op == "+") return new Vector3(x + other.x, y + other.y, z + other.z);
		else static if(op == "-") return new Vector3(x - other.x, y - other.y, z - other.z);
		else static if(op == "*") return new Vector3(x * other.x, y * other.y, z * other.z);
		else static if(op == "/") return new Vector3(x / other.x, y / other.y, z / other.z);
	}

	Vector3 opBinary(string op)(int other) {
		static if(op == "*") return new Vector3(x * other, y * other, z * other);
		else static if(op == "/") return new Vector3(x / other, y / other, z / other);
	}

	Vector3 opBinary(string op)(float other) {
		static if(op == "*") return new Vector3(x * other, y * other, z * other);
		else static if(op == "/") return new Vector3(x / other, y / other, z / other);
	}
}

unittest {
	Vector3 vec = new Vector3(1, 2, 3);

	assert(vec.X == 1);
	assert(vec.Y == 2);
	assert(vec.Z == 3);

	vec = new Vector3(12, 8, 3);
	auto vec2 = new Vector3(51, 8, 4);

	assert((vec + vec2).X == 63);

	vec = new Vector3(1, 1, 1);
	assert((vec * 10).X == 10);

	vec *= 5f;
	assert(vec.Y == 5f);

	Vector3.Distance(vec, vec2);

}