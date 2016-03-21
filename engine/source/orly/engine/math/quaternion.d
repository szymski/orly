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
		axis = axis.Normalized;

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
			float lx = x;
            float ly = y;
            float lz = z;
            float lw = w;

            float rx = other.x;
            float ry = other.y;
            float rz = other.z;
            float rw = other.w;

            float a = (ly * rz - lz * ry);
            float b = (lz * rx - lx * rz);
            float c = (lx * ry - ly * rx);
            float d = (lx * rx + ly * ry + lz * rz);

            x = (lx * rw + rx * lw) + a;
            y = (ly * rw + ry * lw) + b;
            z = (lz * rw + rz * lw) + c;
            w = lw * rw - d;
		}
	}

	Quaternion opBinary(string op)(Quaternion other) {
		static if(op == "*")
			float lx = x;
			float ly = y;
			float lz = z;
			float lw = w;

			float rx = other.x;
			float ry = other.y;
			float rz = other.z;
			float rw = other.w;

			float a = (ly * rz - lz * ry);
			float b = (lz * rx - lx * rz);
			float c = (lx * ry - ly * rx);
			float d = (lx * rx + ly * ry + lz * rz);

			return new Quaternion(
				(lx * rw + rx * lw) + a,
				(ly * rw + ry * lw) + b,
				(lz * rw + rz * lw) + c,
				lw * rw - d
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
	import std.stdio;

	auto AngleAxis(float b, Vector3 a) { return new Quaternion(a, b); }

	writeln(AngleAxis(-80f, new Vector3(0, 1, 0)));
	writeln(AngleAxis(38f, new Vector3(0, 0, 1)));
	writeln(AngleAxis(345f, new Vector3(-1, 0, 0)));
	writeln(AngleAxis(-65f, new Vector3(1, 1, 1)));
	writeln(AngleAxis(90f, new Vector3(0, 0, 1)));
	writeln(AngleAxis(82f, new Vector3(0, 1, 1)));

	writeln(PI);

	//auto q = new Quaternion(new Vector3(0, 1, 0), -80f);
	//q *= new Quaternion(new Vector3(-1, 0, 0), 18f);
	//q *= new Quaternion(new Vector3(1, 0, 0), 67f);
	//q *= new Quaternion(new Vector3(0, 0, 1), -35f);

	
	//writeln(q);
}