module orly.engine.math.matrix4x4;

import orly.engine.screen;
import orly.engine.math.vector3;
import std.math;

class Matrix4x4 {
 private:

 public:

	float[4][4] m;

	@property void* Pointer() { return m.ptr; }

	void InitIdentity() {
		m[0][0] = 1;	m[1][0] = 0;	m[2][0] = 0;	m[3][0] = 0; 
		m[0][1] = 0;	m[1][1] = 1;	m[2][1] = 0;	m[3][1] = 0; 
		m[0][2] = 0;	m[1][2] = 0;	m[2][2] = 1;	m[3][2] = 0; 
		m[0][3] = 0;	m[1][3] = 0;	m[2][3] = 0;	m[3][3] = 1; 
	}
	
	/*
		Initializers
	*/

	/**
		Setups perspective projection matrix.
	*/
	void InitPerspective(float fov, float zNear, float zFar) {
		float scale = 1f / tan(fov / 2f * PI / 180f);

		m[0][0] = scale / (cast(float)Screen.Width / cast(float)Screen.Height);	m[1][0] = 0;		m[2][0] = 0;								m[3][0] = 0; 
		m[0][1] = 0;															m[1][1] = scale;	m[2][1] = 0;								m[3][1] = 0; 
		m[0][2] = 0;															m[1][2] = 0;		m[2][2] = -zFar / (zFar - zNear);			m[3][2] = -zFar * zNear / (zFar - zNear); 
		m[0][3] = 0;															m[1][3] = 0;		m[2][3] = -1;								m[3][3] = 0; 
	}

	/**
		Setups orthographic projection matrix.
	*/
	void InitOrthographic(float left, float top, float right, float bottom, float zNear, float zFar) {
		m[0][0] = 2f / (right - left);	m[1][0] = 0;	m[2][0] = 0;	m[3][0] = -((right + left) / (right - left)); 
		m[0][1] = 0;	m[1][1] = 2f / (top - bottom);	m[2][1] = 0;	m[3][1] = -((top + bottom) / (top - bottom)); 
		m[0][2] = 0;	m[1][2] = 0;	m[2][2] = -2f / (zFar - zNear);	m[3][2] = -((zFar + zNear) / (zFar - zNear)); 
		m[0][3] = 0;	m[1][3] = 0;	m[2][3] = 0;	m[3][3] = 1; 
	}

	/**
		Setups translation matrix.
	*/
	void InitTranslation(float x, float y, float z) {
		m[0][0] = 1;	m[1][0] = 0;	m[2][0] = 0;	m[3][0] = x; 
		m[0][1] = 0;	m[1][1] = 1;	m[2][1] = 0;	m[3][1] = y; 
		m[0][2] = 0;	m[1][2] = 0;	m[2][2] = 1;	m[3][2] = z; 
		m[0][3] = 0;	m[1][3] = 0;	m[2][3] = 0;	m[3][3] = 1; 
	}

	/**
		Setups translation matrix.
	*/
	void InitTranslation(Vector3 v) {
		InitTranslation(v.X, v.Y, v.Z);
	}

	/**
		Setups rotation matrix.
	*/
	void InitRotation(float x, float y, float z) {
		Matrix4x4 rx = new Matrix4x4();
		Matrix4x4 ry = new Matrix4x4();
		Matrix4x4 rz = new Matrix4x4();

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

		m = (rz * (ry * rx)).m;
	}

	/**
		Setups rotation matrix.
	*/
	void InitRotation(Vector3 v) {
		InitRotation(v.X, v.Y, v.Z);
	}

	/**
		Setups rotation matrix.
	*/
	void InitRotation(Vector3 forward, Vector3 up, Vector3 right) {
		alias f = forward;
		alias u = up;
		alias r = right;

		m[0][0] = r.X;			m[1][0] = r.Y;			m[2][0] = r.Z;				m[3][0] = 0;
		m[0][1] = u.X;			m[1][1] = u.Y;			m[2][1] = u.Z;				m[3][1] = 0;
		m[0][2] = f.X;			m[1][2] = f.Y;			m[2][2] = f.Z;				m[3][2] = 0;
		m[0][3] = 0;			m[1][3] = 0;			m[2][3] = 0;				m[3][3] = 1;
	}


	/**
		Setups scale matrix.
	*/
	void InitScale(float x, float y, float z) {
		m[0][0] = x;	m[1][0] = 0;	m[2][0] = 0;	m[3][0] = 0; 
		m[0][1] = 0;	m[1][1] = y;	m[2][1] = 0;	m[3][1] = 0; 
		m[0][2] = 0;	m[1][2] = 0;	m[2][2] = z;	m[3][2] = 0; 
		m[0][3] = 0;	m[1][3] = 0;	m[2][3] = 0;	m[3][3] = 1; 
	}

	/**
		Setups scale matrix.
	*/
	void InitScale(Vector3 v) {
		InitScale(v.X, v.Y, v.Z);
	}

	/*
		Operator overloading
	*/
	
	Matrix4x4 opBinary(string op)(Matrix4x4 other) {
		Matrix4x4 nM = new Matrix4x4();

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
					m[0][i] *= other.m[j][0] +
					m[1][i] *= other.m[j][1] +
					m[2][i] *= other.m[j][2] +
					m[3][i] *= other.m[j][3];
		}
	}
}