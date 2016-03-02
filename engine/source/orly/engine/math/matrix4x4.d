module orly.engine.math.matrix4x4;

import std.math;

class Matrix4x4 {
 private:

 public:

	float[4][4] m;

	@property void* Pointer() { return m.ptr; }
	
	void InitIdentity() {
		m[0][0] = 1;	m[0][1] = 0;	m[0][2] = 0;	m[0][3] = 0; 
		m[1][0] = 0;	m[1][1] = 1;	m[1][2] = 0;	m[1][3] = 0; 
		m[2][0] = 0;	m[2][1] = 0;	m[2][2] = 1;	m[2][3] = 0; 
		m[3][0] = 0;	m[3][1] = 0;	m[3][2] = 0;	m[3][3] = 1; 
	}
	
	/**
		Setups perspective projection matrix.
	*/
	void InitPerspective(float fov, float zNear, float zFar) {
		float scale = 1f / tan(fov / 2f * PI / 180f);

		m[0][0] = scale;	m[0][1] = 0;	m[0][2] = 0;	m[0][3] = 0; 
		m[1][0] = 0;	m[1][1] = scale;	m[1][2] = 0;	m[1][3] = 0; 
		m[2][0] = 0;	m[2][1] = 0;	m[2][2] = -zFar / (zFar - zNear);	m[2][3] = -1f; 
		m[3][0] = 0;	m[3][1] = 0;	m[3][2] = -zFar * zNear / (zFar - zNear);	m[3][3] = 0; 
	}

	/**
		Setups orthographic projection matrix.
	*/
	void InitOrthographic(float left, float top, float right, float bottom, float zNear, float zFar) {
		m[0][0] = 2f / (right - left);	m[0][1] = 0;	m[0][2] = 0;	m[0][3] = -((right + left) / (right - left)); 
		m[1][0] = 0;	m[1][1] = 2f / (top - bottom);	m[1][2] = 0;	m[1][3] = -((top + bottom) / (top - bottom)); 
		m[2][0] = 0;	m[2][1] = 0;	m[2][2] = -2f / (zFar - zNear);	m[2][3] = -((zFar + zNear) / (zFar - zNear)); 
		m[3][0] = 0;	m[3][1] = 0;	m[3][2] = 0;	m[3][3] = 1; 
	}

	/*
		Operator overloading
	*/
	
	Matrix4x4 opBinary(string op)(Matrix4x4 other) {
		Matrix4x4 nM = new Matrix4x4();

		static if(op == "*") {
			for(int i = 0; i < 4; i++)
				for(int j = 0; j < 4; j++) 
					nM.m[i][j] = m[i][j] * other.m[i][j];
		}

		return nM;
	}

	void opOpAssign(string op)(Matrix4x4 other) {
		static if(op == "*") {
			for(int i = 0; i < 4; i++)
				for(int j = 0; j < 4; j++) 
					m[i][j] *= other.m[i][j];
		}
	}
}