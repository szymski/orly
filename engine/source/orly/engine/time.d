module orly.engine.time;

final static class Time {
 private:
	static float deltaTime;

 public:
	@property static ref float DeltaTime() { return deltaTime; }
}