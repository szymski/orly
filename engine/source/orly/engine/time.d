module orly.engine.time;

final static class Time {
 private:

	static float deltaTime = 0f;
	static float seconds = 0f;

 public:

	/** Delta time. */
	@property static ref float DeltaTime() { return deltaTime; }
	/** Seconds since the start. */
	@property static ref float Seconds() { return seconds; }
}