module orly.engine.math.matrix4x4;

import orly.engine.screen;
import orly.engine.math.vector3;
import std.math;

struct Matrix4x4 {
 private:

 public:

	float[4][4] m;

	@property void* Pointer() { return m.ptr; }

	static Matrix4x4 Identity() {
		Matrix4x4 nM;

		nM.m[0][0] = 1;	nM.m[1][0] = 0;	nM.m[2][0] = 0;	nM.m[3][0] = 0; 
		nM.m[0][1] = 0;	nM.m[1][1] = 1;	nM.m[2][1] = 0;	nM.m[3][1] = 0; 
		nM.m[0][2] = 0;	nM.m[1][2] = 0;	nM.m[2][2] = 1;	nM.m[3][2] = 0; 
		nM.m[0][3] = 0;	nM.m[1][3] = 0;	nM.m[2][3] = 0;	nM.m[3][3] = 1; 

		return nM;
	}
	
	/*
		Initializers
	*/

	/**
		Setups perspective projection matrix.
	*/
	static Matrix4x4 Perspective(float fov, float zNear, float zFar) {
		Matrix4x4 nM;

		float scale = 1f / tan(fov / 2f * PI / 180f);

		nM.m[0][0] = scale / (cast(float)Screen.Width / cast(float)Screen.Height);	nM.m[1][0] = 0;		nM.m[2][0] = 0;								nM.m[3][0] = 0; 
		nM.m[0][1] = 0;															nM.m[1][1] = scale;	nM.m[2][1] = 0;								nM.m[3][1] = 0; 
		nM.m[0][2] = 0;															nM.m[1][2] = 0;		nM.m[2][2] = -zFar / (zFar - zNear);			nM.m[3][2] = -zFar * zNear / (zFar - zNear); 
		nM.m[0][3] = 0;															nM.m[1][3] = 0;		nM.m[2][3] = -1;								nM.m[3][3] = 0; 
		
		return nM;
	}

	/**
		Setups orthographic projection matrix.
	*/
	static Matrix4x4 Orthographic(float left, float top, float right, float bottom, float zNear, float zFar) {
		Matrix4x4 nM;

		nM.m[0][0] = 2f / (right - left);	nM.m[1][0] = 0;					nM.m[2][0] = 0;					nM.m[3][0] = -((right + left) / (right - left)); 
		nM.m[0][1] = 0;					nM.m[1][1] = 2f / (top - bottom);	nM.m[2][1] = 0;					nM.m[3][1] = -((top + bottom) / (top - bottom)); 
		nM.m[0][2] = 0;					nM.m[1][2] = 0;					nM.m[2][2] = -2f / (zFar - zNear);	nM.m[3][2] = -((zFar + zNear) / (zFar - zNear)); 
		nM.m[0][3] = 0;					nM.m[1][3] = 0;					nM.m[2][3] = 0;					nM.m[3][3] = 1; 

		return nM;
	}

	/**
		Setups translation matrix.
	*/
	static Matrix4x4 Translation(float x, float y, float z) {
		Matrix4x4 nM;

		nM.m[0][0] = 1;	nM.m[1][0] = 0;	nM.m[2][0] = 0;	nM.m[3][0] = x; 
		nM.m[0][1] = 0;	nM.m[1][1] = 1;	nM.m[2][1] = 0;	nM.m[3][1] = y; 
		nM.m[0][2] = 0;	nM.m[1][2] = 0;	nM.m[2][2] = 1;	nM.m[3][2] = z; 
		nM.m[0][3] = 0;	nM.m[1][3] = 0;	nM.m[2][3] = 0;	nM.m[3][3] = 1; 

		return nM;
	}

	/**
		Setups translation matrix.
	*/
	static Matrix4x4 Translation(Vector3 v) {
		return Translation(v.X, v.Y, v.Z);
	}

	/**
		Setups rotation matrix from euler angles.
	*/
	static Matrix4x4 Rotation(float x, float y, float z) {
		Matrix4x4 rx;
		Matrix4x4 ry;
		Matrix4x4 rz;

		x /= 180f * PI;
		y /= 180f * PI;
		z /= 180f * PI;

		rz.m[0][0] = cos(z);			rz.m[1][0] = -sin(z);			rz.m[2][0] = 0;					rz.m[3][0] = 0;
		rz.m[0][1] = sin(z);			rz.m[1][1] = cos(z);			rz.m[2][1] = 0;					rz.m[3][1] = 0;
		rz.m[0][2] = 0;					rz.m[1][2] = 0;					rz.m[2][2] = 1;					rz.m[3][2] = 0;
		rz.m[0][3] = 0;					rz.m[1][3] = 0;					rz.m[2][3] = 0;					rz.m[3][3] = 1;

		rx.m[0][0] = 1;					rx.m[1][0] = 0;					rx.m[2][0] = 0;					rx.m[3][0] = 0;
		rx.m[0][1] = 0;					rx.m[1][1] = cos(x);			rx.m[2][1] = -sin(x);			rx.m[3][1] = 0;
		rx.m[0][2] = 0;					rx.m[1][2] = sin(x);			rx.m[2][2] = cos(x);			rx.m[3][2] = 0;
		rx.m[0][3] = 0;					rx.m[1][3] = 0;					rx.m[2][3] = 0;					rx.m[3][3] = 1;

		ry.m[0][0] = cos(y);			ry.m[1][0] = 0;					ry.m[2][0] = -sin(y);			ry.m[3][0] = 0;
		ry.m[0][1] = 0;					ry.m[1][1] = 1;					ry.m[2][1] = 0;					ry.m[3][1] = 0;
		ry.m[0][2] = sin(y);			ry.m[1][2] = 0;					ry.m[2][2] = cos(y);			ry.m[3][2] = 0;
		ry.m[0][3] = 0;					ry.m[1][3] = 0;					ry.m[2][3] = 0;					ry.m[3][3] = 1;

		return (rz * (ry * rx));
	}

	/**
		Setups rotation matrix.
	*/
	static Matrix4x4 Rotation(Vector3 v) {
		return Rotation(v.X, v.Y, v.Z);
	}

	/**
		Setups rotation matrix.
	*/
	static Matrix4x4 Rotation(Vector3 forward, Vector3 up, Vector3 right) {
		Matrix4x4 nM;

		alias f = forward;
		alias u = up;
		alias r = right;

		nM.m[0][0] = r.X;			nM.m[1][0] = r.Y;			nM.m[2][0] = r.Z;				nM.m[3][0] = 0;
		nM.m[0][1] = u.X;			nM.m[1][1] = u.Y;			nM.m[2][1] = u.Z;				nM.m[3][1] = 0;
		nM.m[0][2] = f.X;			nM.m[1][2] = f.Y;			nM.m[2][2] = f.Z;				nM.m[3][2] = 0;
		nM.m[0][3] = 0;				nM.m[1][3] = 0;				nM.m[2][3] = 0;					nM.m[3][3] = 1;

		return nM;
	}


	/**
		Setups scale matrix.
	*/
	static Matrix4x4 Scale(float x, float y, float z) {
		Matrix4x4 nM;

		nM.m[0][0] = x;	nM.m[1][0] = 0;	nM.m[2][0] = 0;	nM.m[3][0] = 0; 
		nM.m[0][1] = 0;	nM.m[1][1] = y;	nM.m[2][1] = 0;	nM.m[3][1] = 0; 
		nM.m[0][2] = 0;	nM.m[1][2] = 0;	nM.m[2][2] = z;	nM.m[3][2] = 0; 
		nM.m[0][3] = 0;	nM.m[1][3] = 0;	nM.m[2][3] = 0;	nM.m[3][3] = 1; 

		return nM;
	}

	/**
		Setups scale matrix.
	*/
	static Matrix4x4 Scale(Vector3 v) {
		return Scale(v.X, v.Y, v.Z);
	}

	/*
		Operator overloading
	*/
	
	Matrix4x4 opBinary(string op)(Matrix4x4 other) {
		Matrix4x4 nM;

		static if(op == "*") {
			for(int i = 0; i < 4; i++)
				for(int j = 0; j < 4; j++) 
					nM.m[j][i] = m[0][i] * other.m[j][0] +
								 m[1][i] * other.m[j][1] +
								 m[2][i] * other.m[j][2] +
								 m[3][i] * other.m[j][3];
		}

		return nM;
	}

	void opOpAssign(string op)(Matrix4x4 other) {
		static if(op == "*") {
			for(int i = 0; i < 4; i++)
				for(int j = 0; j < 4; j++) 
				m[j][i] *= m[0][i] * other.m[j][0] +
					m[1][i] * other.m[j][1] +
					m[2][i] * other.m[j][2] +
					m[3][i] * other.m[j][3];
		}
	}
}