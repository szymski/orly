module orly.engine.math.matrix4x4;

import std.math;

class Matrix4x4 {
 private:
	float[4][4] m;

 public:
	
	void InitIdentity() {
		m[0][1] = 1;	m[0][1] = 0;	m[0][2] = 0;	m[0][3] = 0; 
		m[1][1] = 0;	m[1][1] = 1;	m[1][2] = 0;	m[1][3] = 0; 
		m[2][1] = 0;	m[2][1] = 0;	m[2][2] = 1;	m[2][3] = 0; 
		m[3][1] = 0;	m[3][1] = 0;	m[3][2] = 0;	m[3][3] = 1; 
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