module orly.engine.components.camera;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.components.factory;
import orly.engine.backend.ibackend;

class Camera : Component {
 private:
	

 public:
	
	float fov = 90;
	
	this() {
		main = this;
	}

	void SetupRendering() {
		import derelict.opengl3.gl;

		Backend.SetupPerspective(fov, 0.1f, 500f);
		glLoadIdentity();

		glTranslatef(-GameObject.Transform.Position.X, -GameObject.Transform.Position.Y, -GameObject.Transform.Position.Z);
	}
	
 static:

	Camera main;
}

mixin RegisterComponent!Camera;