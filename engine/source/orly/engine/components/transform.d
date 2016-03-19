module orly.engine.components.transform;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.components.factory;
import orly.engine.math.matrix4x4;
import orly.engine.math.quaternion;

mixin RegisterComponents;

class Transform : Component {
 private:

	Vector3 position;
	Vector3 scale;
	Quaternion rotation;

 public:

	this() {
		position = new Vector3();
		scale = new Vector3(1, 1, 1);
		rotation = new Quaternion();
	}

	@property ref Vector3 Position() { return position; }
	@property ref Vector3 Scale() { return scale; }
	@property ref Quaternion Rotation() { return rotation; }

	Matrix4x4 GetMatrix() {
		auto translationMatrix = new Matrix4x4();
		auto rotationMatrix = rotation.Matrix;
		auto scaleMatrix = new Matrix4x4();

		translationMatrix.InitTranslation(position);
		scaleMatrix.InitScale(scale);

		return translationMatrix * (rotationMatrix * scaleMatrix);
	}
}