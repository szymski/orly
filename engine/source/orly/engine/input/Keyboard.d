module orly.engine.input.keyboard;

public import orly.engine.input.keyboardkeys;

final static class Keyboard {
 private:

	static bool[255] keys;
	static bool[255] downKeys;
	static bool[255] upKeys;

 public:

	/**
		Returns true, if the specified key is being held.
	*/
	static bool GetKey(KeyboardKey key) {
		return keys[key];
	}

	/**
		Returns true, if the specified key was pressed in the current frame.
	*/
	static bool GetKeyDown(KeyboardKey key) {
		return downKeys[key];
	}

	/**
		Returns true, if the specified key was released in the current frame.
	*/
	static bool GetKeyUp(KeyboardKey key) {
		return upKeys[key];
	}

	/**
		Sets the specified key into the specified state. Used by the backend.
	*/
	static void SetKey(KeyboardKey key, bool state) {
		keys[key] = state;

		if(state)
			downKeys[key] = true;
		else
			upKeys[key] = true;
	}

	/**
		Resets key states. Called once per frame, in the main loop.
	*/
	static void Reset() {
		for(KeyboardKey i; i < 255; i++) {
			downKeys[i] = false;
			upKeys[i] = false;
		}
	}

	// TODO: Get all keys
}
