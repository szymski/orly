module orly.engine.input.mouse;

import orly.engine.backend.ibackend;
import orly.engine.math.vector2;

final static class Mouse {
 private:

	static bool[32] buttons;
	static bool[32] downButtons;
	static bool[32] upButtons;

	static __gshared Vector2 position = new Vector2();
	static __gshared Vector2 acceleration = new Vector2();

	static float wheelDelta = 0f;

 public:

	/** Returns the position of the cursor. */
	@property static Vector2 Position() { return position; }
	/** Returns the acceleration of the mouse. */
	@property static Vector2 Acceleration() { return acceleration; }

	/** Returns mouse wheel delta. */
	@property static ref float WheelDelta() { return wheelDelta; }

	/** If true, the cursor will be locked in one place. */
	@property static bool LockCursor() { return Backend.LockCursor; }
	/** If true, the cursor will be locked in one place. */
	@property static void LockCursor(bool value) { Backend.LockCursor = value; }

	/**
		Returns true, if the specified button is being held.
	*/
	static bool GetButton(int button) {
		return buttons[button];
	}

	/**
		Returns true, if the specified button was pressed in the current frame.
	*/
	static bool GetButtonDown(int button) {
		return downButtons[button];
	}

	/**
		Returns true, if the specified button was released in the current frame.
	*/
	static bool GetButtonUp(int button) {
		return upButtons[button];
	}

	/**
		Sets the specified button into the specified state. Used by the backend.
	*/
	static void SetButton(int button, bool state) {
		buttons[button] = state;

		if(state)
			downButtons[button] = true;
		else
			upButtons[button] = true;
	}

	/**
		Resets button states. Called once per frame, in the main loop.
	*/
	static void Reset() {
		for(int i; i < 32; i++) {
			downButtons[i] = false;
			upButtons[i] = false;
		}

		acceleration.X = 0;
		acceleration.Y = 0;
	}
}
