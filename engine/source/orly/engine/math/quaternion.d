module orly.engine.math.quaternion;

import orly.engine.math.vector3;
import std.math;

class Quaternion {
 private:

	float x = 0, y = 0, z = 0, w = 0;

 public:

	this() {

	}

	this(float x, float y, float z, float w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
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

	@property Quaternion Conjugated() {
		return new Quaternion(-x, -y, -z, -w);
	}

	/*
		Operator overloading - with other quaternions
	*/

	void opOpAssign(string op)(Quaternion other) {
		static if(op == "*") {
			x = x * other.w + w * other.x + y * other.z - z * other.y;
			y = y * other.w + w * other.y + z * other.x - x * other.z;
			z = z * other.w + w * other.z + x * other.y - y * other.x;
			w = w * other.w - x * other.x - y * other.y - z * other.z;
		}
	}

	Quaternion opBinary(string op)(Quaternion other) {
		static if(op == "*")
			return new Quaternion(
				x * other.w + w * other.x + y * other.z - z * other.y,
				y * other.w + w * other.y + z * other.x - x * other.z,
				z * other.w + w * other.z + x * other.y - y * other.x,
				w * other.w - x * other.x - y * other.y - z * other.z,
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
			w = -x * v.X - y * v.Y - z * v.X;
		}
	}

	Quaternion opBinary(string op)(Vector3 v) {
		static if(op == "*")
			return new Quaternion(
				w * v.X + y * v.Z - z * v.Y,
				w * v.Y + z * v.X - x * v.Z,
				w * v.Z + x * v.Y - y * v.X,
				-x * v.X - y * v.Y - z * v.X,
			);
	}

}