module orly.engine.components.transform;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;

class Transform : Component {
 private:
	Vector3 position;

 public:

	@property ref Vector3 Position() { return position; }

}

mixin RegisterComponent!Transform;