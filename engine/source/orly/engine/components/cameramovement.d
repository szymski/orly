module orly.engine.components.cameramovement;

import orly.engine.gameobjects.gameobject;
import orly.engine.components.component;
import orly.engine.math.vector3;
import orly.engine.math.vector2;
import orly.engine.math.quaternion;
import orly.engine.components.factory;
import orly.engine.components.camera;
import orly.engine.backend.ibackend;

import orly.engine.input.keyboard;
import orly.engine.input.mouse;
import orly.engine.time;

import std.stdio;

mixin RegisterComponents;

class CameraMovement : Component {
	
	Vector2 angles = new Vector2();

	override public void OnUpdate() {

		if(Keyboard.GetKey(KeyboardKey.W))
			GameObject.Transform.Position -= GameObject.Transform.Rotation.Forward * Time.DeltaTime * 200f;

		if(Keyboard.GetKey(KeyboardKey.S))
			GameObject.Transform.Position += GameObject.Transform.Rotation.Forward * Time.DeltaTime * 200f;

		if(Keyboard.GetKey(KeyboardKey.A))
			GameObject.Transform.Position += GameObject.Transform.Rotation.Left * Time.DeltaTime * 200f;

		if(Keyboard.GetKey(KeyboardKey.D))
			GameObject.Transform.Position += GameObject.Transform.Rotation.Right * Time.DeltaTime * 200f;

		//writeln(GameObject.Transform.Position);

		//GameObject.Transform.Rotation.Y += Mouse.Acceleration.X * 800f * Time.DeltaTime;
		//GameObject.Transform.Rotation.X -= Mouse.Acceleration.Y * 800f * Time.DeltaTime;

		angles += new Vector2(-Mouse.Acceleration.X * Time.DeltaTime * 20f, -Mouse.Acceleration.Y * Time.DeltaTime * 20f);

		if(angles.Y > 89f)
			angles.Y = 89f;

		if(angles.Y < -89f)
			angles.Y = -89f;

		angles.X %= 360f;

		//writeln(GameObject.Transform.Rotation.EulerAngles);

		GameObject.Transform.Rotation = new Quaternion(new Vector3(0, 1f, 0), angles.X);
		GameObject.Transform.Rotation *= new Quaternion(new Vector3(1f, 0, 0), angles.Y);

		
		//writeln(GameObject.Transform.Rotation);

		if(Mouse.GetButton(0))
			GameObject.GetComponent!Camera().fov += 100f * Time.DeltaTime;

		if(Mouse.GetButton(1))
			GameObject.GetComponent!Camera().fov -= 100f * Time.DeltaTime;
	}

}