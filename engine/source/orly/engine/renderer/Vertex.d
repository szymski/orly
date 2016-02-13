module orly.engine.renderer.vertex;

import orly.engine.renderer.renderer;

struct Vertex {
	
	float x, y, z, u, v, n;

	this(float x, float y, float z, float u = 0, float v = 0, float n = 0) {
		this.x = x, this.y = y, this.z = z, this.u = u, this.v = v, this.n = n;
	}
		
}