module orly.engine.math.utils;

import orly.engine.math.vector2;
import orly.engine.math.vector3;

float Lerp(float t, float from, float to) {
	return (1 - t) * from + t * to;
}

Vector2 Lerp(float t, Vector2 from, Vector2 to) {
	return new Vector2(Lerp(t, from.X, to.X), Lerp(t, from.Y, to.Y));
}

Vector3 Lerp(float t, Vector3 from, Vector3 to) {
	return new Vector3(Lerp(t, from.X, to.X), Lerp(t, from.Y, to.Y), Lerp(t, from.Z, to.Z));
}