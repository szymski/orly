module orly.engine.components.camera;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.math.matrix4x4;
import orly.engine.components.factory;
import orly.engine.backend.ibackend;
import orly.engine.screen;

class Camera : Component {
 private:
	

 public:
	
	float fov = 90;
	Matrix4x4 projectionMatrix = new Matrix4x4();
	
	this() {
		main = this;
		projectionMatrix.InitPerspective(fov, 0.1f, 500f);
	}

	void SetupRendering() {
		import derelict.opengl3.gl;

		Backend.SetMatrixMode(MatrixMode.Projection);
		Backend.SetViewport(0, 0, Screen.Width, Screen.Height);
		Backend.SetMatrix(projectionMatrix);
		
		Backend.SetMatrixMode(MatrixMode.ModelView);	
		Matrix4x4 matrix = new Matrix4x4();
		matrix.InitIdentity();
		Backend.SetMatrix(matrix);


		glRotatef(-GameObject.Transform.Rotation.Y, 1, 0, 0);
		glRotatef(-GameObject.Transform.Rotation.X, 0, 1, 0);

		glTranslatef(-GameObject.Transform.Position.X, -GameObject.Transform.Position.Y, -GameObject.Transform.Position.Z);
	}
	
 static:

	Camera main;
}

mixin RegisterComponent!Camera;