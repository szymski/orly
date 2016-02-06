module orly.engine.renderer.vertexbuffer;

import orly.engine.backend.ibackend;
import orly.engine.renderer.renderer;

final class VertexBuffer {
 private:
	int id;

 public:

	this() {
		id = Backend.VertexBufferCreate();
	}

	~this() {
		Backend.VertexBufferDestroy(id);
	}

}