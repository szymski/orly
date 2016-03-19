module orly.engine.math.vector3;

import orly.engine.math.quaternion;
import std.math;
import std.string : format;

class Vector3 {
 private:

	float x , y , z;

 public:

	this() {
		x = 0;
		y = 0;
		z = 0;
	}

	this(float x, float y, float z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	@property ref float X() { return x; }
	@property ref float Y() { return y; }
	@property ref float Z() { return z; }

	/** Returns the length of the vector. **/
	@property float Length() { return sqrt(x * x + y * y + z * z); }

	/**
		Returns a normalized vector.
	*/
	@property Vector3 Normalized() {
		float m = Length;
		return new Vector3(x / m, y / m, z / m);
	}

	/**
		Rotates the vector.
	*/
	Vector3 Rotate(Quaternion rotation) {
		auto w = rotation * this * rotation.Conjugated;
		x = w.X;
		y = w.Y;
		z = w.Z;

		return this;
	}

	/**
		Returns a rotated vector.
	*/
	Vector3 Rotated(Quaternion rotation) {
		auto v = this.Copy;
		v.Rotate(rotation);
		return v;
	}

	/**
		Returns a copy of the vector.
	*/
	Vector3 Copy() {
		return new Vector3(x, y, z);
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

	Vector3 opUnary(string op)() if (op == "-")
    {
        return new Vector3(-x, -y, -z);
    }

	override string toString() {
		return format("Vector3 { %f, %f, %f }", x, y, z);
	}

 static:

	/**
		Returns distance between two vectors.
	*/
	float Distance(Vector3 left, Vector3 right) {
		return (left - right).Length;
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