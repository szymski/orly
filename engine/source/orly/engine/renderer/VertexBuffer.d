module orly.engine.renderer.vertexbuffer;

import orly.engine.backend.ibackend;
import orly.engine.renderer.renderer;
import orly.engine.renderer.mesh;

final class VertexBuffer {
 private:
	int id;
	int vertexCount;

 public:

	this(Mesh mesh) {
		id = Backend.VertexBufferCreate(mesh);
		vertexCount = mesh.VertexCount;
	}

	~this() {
		Backend.VertexBufferDestroy(id);
	}

	void Render() {
		Backend.VertexBufferDraw(id, vertexCount);
	}
}