module orly.engine.input.keyboard;

import std.algorithm.iteration;

public import orly.engine.input.keyboardkeys;

final static class Keyboard {
 private:

	static bool[1024] keys;
	static bool[1024] downKeys;
	static bool[1024] upKeys;

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

	/**
		Returns all held keys.
	*/
	@property static KeyboardKey[] AllKeys() {
		KeyboardKey[] allKeys;

		foreach(i, key; keys) if(key)
			allKeys ~= cast(KeyboardKey)i;

		return allKeys;
	}

	/**
		Returns all keys pressed in current frame.
	*/
	@property static KeyboardKey[] AllDownKeys() {
		KeyboardKey[] allKeys;

		foreach(i, key; downKeys) if(key)
			allKeys ~= cast(KeyboardKey)i;

		return allKeys;
	}

	/**
		Returns all keys released in current frame.
	*/
	@property static KeyboardKey[] AllUpKeys() {
		KeyboardKey[] allKeys;

		foreach(i, key; upKeys) if(key)
			allKeys ~= cast(KeyboardKey)i;

		return allKeys;
	}
}
