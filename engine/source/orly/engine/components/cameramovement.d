module orly.engine.components.cameramovement;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.components.factory;
import orly.engine.backend.ibackend;

import orly.engine.input.keyboard;
import orly.engine.time;

class CameraMovement : Component {
	
	override public void OnUpdate() {
		if(Keyboard.GetKey(KeyboardKey.A)) {
			GameObject.Transform.Position.X += Time.DeltaTime;
		}
	}

}

mixin RegisterComponent!CameraMovement;