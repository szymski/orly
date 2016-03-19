module orly.engine.math.quaternion;

import orly.engine.math.vector3;
import orly.engine.math.matrix4x4;
import std.math;
import std.string : format;

class Quaternion {
 private:

	float x, y, z, w;

 public:

	this() {
		x = 0;
		y = 0;
		z = 0;
		w = 1;
	}

	this(float x, float y, float z, float w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;

		Normalize();
	}

	this(Vector3 axis, float angle) {
		float sinHalfAngle = sin(angle / 180f * PI / 2f);
		float cosHalfAngle = cos(angle / 180f * PI / 2f);

		x = axis.X * sinHalfAngle;
		y = axis.Y * sinHalfAngle;
		z = axis.Z * sinHalfAngle;
		w = cosHalfAngle;

		Normalize();
	}

	@property ref float X() { return x; }
	@property ref float Y() { return y; }
	@property ref float Z() { return z; }
	@property ref float W() { return w; }

	@property float Length() { return sqrt(x * x + y * y + z * z + w * w); }

	@property Quaternion Normalized() {
		float m = Length;
		return new Quaternion(x / m, y / m, z / m, w / m);
	}

	void Normalize() {
		float m = Length;

		x /= m;
		y /= m;
		z /= m;
		w /= m;
	}

	@property Quaternion Conjugated() { return new Quaternion(-x, -y, -z, w); }

	@property Matrix4x4 Matrix()
	{
		Vector3 forward = new Vector3(2.0f * (X * Z - W * Y), 2.0f * (Y * Z + W * X), 1.0f - 2.0f * (X * X + Y * Y));
		Vector3 up = new Vector3(2.0f * (X * Y + W * Z), 1.0f - 2.0f * (X * X + Z * Z), 2.0f * (Y * Z - W * X));
		Vector3 right = new Vector3(1.0f - 2.0f * (Y * Y + Z * Z), 2.0f * (X * Y - W * Z), 2.0f * (X * Z + W * Y));
		
		auto m = new Matrix4x4();
		m.InitRotation(forward, up, right);
		return m;
	}

	@property Vector3 EulerAngles() {
		return new Vector3(atan2(2 * x * w - 2 * y * z, 1 - 2 * x * x - 2 * z * z) / PI * 180f, atan2(2 * y * w - 2 * x * z, 1 - 2 * y * y - 2 * z * z) / PI * 180f, asin(2 * x * y + 2 * z * w) / PI * 180f);
	}

	/*
		Direction functions
	*/

	@property Vector3 Forward() { return new Vector3(0, 0, 1).Rotate(this); }
	@property Vector3 Back() { return new Vector3(0, 0, -1).Rotate(this); }

	@property Vector3 Up() { return new Vector3(0, 1, 0).Rotate(this); }
	@property Vector3 Down() { return new Vector3(0, -1, 0).Rotate(this); }

	@property Vector3 Right() { return new Vector3(1, 0, 0).Rotate(this); }
	@property Vector3 Left() { return new Vector3(-1, 0, 0).Rotate(this); }

	/*
		Operator overloading - with other quaternions
	*/

	void opOpAssign(string op)(Quaternion other) {
		static if(op == "*") {
			x = (((w * other.x) + (x * other.w)) + (y * other.z)) - (z * other.y);
			y = (((w * other.y) + (y * other.w)) + (z * other.x)) - (x * other.z);
			z = (((w * other.z) + (z * other.w)) + (x * other.y)) - (y * other.x);
			w = (((w * other.w) - (x * other.x)) - (y * other.y)) - (z * other.z);
			Normalize();
		}
	}

	Quaternion opBinary(string op)(Quaternion other) {
		static if(op == "*")
			return new Quaternion(
				(((w * other.x) + (x * other.w)) + (y * other.z)) - (z * other.y),
				(((w * other.y) + (y * other.w)) + (z * other.x)) - (x * other.z),
				(((w * other.z) + (z * other.w)) + (x * other.y)) - (y * other.x),
				(((w * other.w) - (x * other.x)) - (y * other.y)) - (z * other.z)
			);
	}

	/*
		Operator overloading - with vectors
	*/

	void opOpAssign(string op)(Vector3 v) {
		static if(op == "*") {
			x = w * v.X + y * v.Z - z * v.Y;
			y = w * v.Y + z * v.X - x * v.Z;
			z = w * v.Z + x * v.Y - y * v.X;
			w = -x * v.X - y * v.Y - z * v.Z;
		}
	}

	Quaternion opBinary(string op)(Vector3 v) {
		static if(op == "*")
			return new Quaternion(
				w * v.X + y * v.Z - z * v.Y,
				w * v.Y + z * v.X - x * v.Z,
				w * v.Z + x * v.Y - y * v.X,
				-x * v.X - y * v.Y - z * v.Z,
			);
	}

	override string toString() {
		return format("Quaternion { %f, %f, %f, %f }", x, y, z, w);
	}
}

unittest {
	auto quat = new Quaternion(new Vector3(0, 1, 0), -90f) * new Quaternion(new Vector3(-1, 0, 0), 245f) * new Quaternion(new Vector3(0, 0, 1), -34975f);

	import std.stdio;
	writeln(quat);
}