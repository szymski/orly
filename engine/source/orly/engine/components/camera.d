module orly.engine.components.camera;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.math.matrix4x4;
import orly.engine.components.factory;
import orly.engine.backend.ibackend;
import orly.engine.screen;

mixin RegisterComponents;

class Camera : Component {
 private:
	

 public:
	
	float fov;
	float zNear, zFar;
	Matrix4x4 projectionMatrix;
	
	this() {
		fov = 90f;
		zNear = 0.1f;
		zFar = 10000f;

		main = this;
	}

	void SetupRendering() {
		Backend.EnableDepth();
		Backend.EnableFaceCulling();
		Backend.SetFaceCullingMode(CullingMode.Back);

		projectionMatrix = Matrix4x4.Perspective(fov, zNear, zFar);
		Backend.SetMatrixMode(MatrixMode.Projection);
		Backend.SetViewport(0, 0, Screen.Width, Screen.Height);
		Backend.SetMatrix(projectionMatrix);
		
		Backend.SetMatrixMode(MatrixMode.ModelView);	
		//Backend.SetMatrix(GetViewMatrix());
	}

	// TODO: Obliczanie macierzy tylko raz podczas danej klatki

	Matrix4x4 GetViewMatrix() {
		auto translationMatrix = Matrix4x4.Translation(-GameObject.Transform.Position);
		auto rotationMatrix = GameObject.Transform.Rotation.Conjugated.Matrix;

		return rotationMatrix * translationMatrix;
	}
	
 static:

	Camera main;
}