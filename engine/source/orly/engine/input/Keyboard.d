module orly.engine.input.keyboard;

enum KeyboardKey : int {
	A = 'a',
}

final static class Keyboard {
 private:

	static bool[255] keys;
	static bool[255] downKeys;
	static bool[255] upKeys;

 public:

	static bool GetKey(KeyboardKey key) {
		return keys[key];
	}

	static bool GetKeyDown(KeyboardKey key) {
		return downKeys[key];
	}

	static bool GetKeyUp(KeyboardKey key) {
		return upKeys[key];
	}

	static void SetKey(KeyboardKey key, bool state) {
		keys[key] = state;

		if(state)
			downKeys[key] = true;
		else
			upKeys[key] = true;
	}

	static void Reset() {
		for(KeyboardKey i; i < 255; i++) {
			downKeys[i] = false;
			upKeys[i] = false;
		}
	}
}
