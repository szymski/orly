module orly.engine.renderer.vertexarray;

import orly.engine.backend.ibackend;
import orly.engine.renderer.renderer;
import orly.engine.renderer.mesh;

final class VertexArray {
 private:
	int id;
	int vertexCount;

 public:

	this(Mesh mesh) {
		id = Backend.VertexArrayCreate(mesh);
		vertexCount = mesh.VertexCount;
	}

	~this() {
		Backend.VertexArrayDestroy(id);
	}

	void Render() {
		Backend.VertexArrayBind(id);
		Backend.VertexArrayDraw(id, vertexCount);
		Backend.VertexArrayUnbind();
	}
}