module orly.engine.components.transform;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.components.factory;
import orly.engine.math.matrix4x4;

class Transform : Component {
 private:
	Vector3 position = new Vector3();
	Vector3 scale = new Vector3(1, 1, 1);
	Vector3 rotation = new Vector3();

 public:

	@property ref Vector3 Position() { return position; }
	@property ref Vector3 Scale() { return scale; }
	@property ref Vector3 Rotation() { return rotation; }

	Matrix4x4 GetMatrix() {
		auto translationMatrix = new Matrix4x4();
		auto rotationMatrix = new Matrix4x4();
		auto scaleMatrix = new Matrix4x4();

		translationMatrix.InitTranslation(position);
		rotationMatrix.InitRotation(rotation);
		scaleMatrix.InitScale(scale);

		return translationMatrix * (rotationMatrix * scaleMatrix);
	}
}

mixin RegisterComponent!Transform;