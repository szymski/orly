module orly.engine.components.transform;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.components.factory;

class Transform : Component {
 private:
	Vector3 position = new Vector3();
	Vector3 scale = new Vector3();

 public:

	@property ref Vector3 Position() { return position; }
	@property ref Vector3 Scale() { return scale; }

}

mixin RegisterComponent!Transform;