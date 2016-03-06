module orly.engine.components.cameramovement;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.components.factory;
import orly.engine.components.camera;
import orly.engine.backend.ibackend;

import orly.engine.input.keyboard;
import orly.engine.input.mouse;
import orly.engine.time;

class CameraMovement : Component {
	
	override public void OnUpdate() {

		if(Keyboard.GetKey(KeyboardKey.A)) {
			GameObject.Transform.Position.X -= Time.DeltaTime * 20f;
		}

		if(Keyboard.GetKey(KeyboardKey.D)) {
			GameObject.Transform.Position.X += Time.DeltaTime * 20f;
		}

		if(Keyboard.GetKey(KeyboardKey.W)) {
			GameObject.Transform.Position.Z += Time.DeltaTime * 20f;
		}

		if(Keyboard.GetKey(KeyboardKey.S)) {
			GameObject.Transform.Position.Z -= Time.DeltaTime * 20f;
		}

		GameObject.Transform.Rotation.Y += Mouse.Acceleration.X * 800f * Time.DeltaTime;
		GameObject.Transform.Rotation.X -= Mouse.Acceleration.Y * 800f * Time.DeltaTime;

		if(Mouse.GetButton(0))
			GameObject.GetComponent!Camera().fov += 100f * Time.DeltaTime;

		if(Mouse.GetButton(1))
			GameObject.GetComponent!Camera().fov -= 100f * Time.DeltaTime;
	}

}

mixin RegisterComponent!CameraMovement;