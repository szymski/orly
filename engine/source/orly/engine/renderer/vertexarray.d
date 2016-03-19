module orly.engine.renderer.vertexarray;

import orly.engine.backend.ibackend;
import orly.engine.renderer.renderer;
import orly.engine.renderer.mesh;

enum DrawType {
	Points,
	Lines,
	Triangles,
	Quads,
}

final class VertexArray {
 private:

	int id;
	int vertexCount;

 public:

	DrawType drawType;

	this(Mesh mesh, DrawType drawType = DrawType.Triangles) {
		this.drawType = drawType;

		id = Backend.VertexArrayCreate(mesh);
		vertexCount = mesh.VertexCount;
	}

	~this() {
		Backend.VertexArrayDestroy(id);
	}

	void Render() {
		Backend.VertexArrayBind(id);
		Backend.VertexArrayDraw(id, vertexCount, drawType);
		Backend.VertexArrayUnbind();
	}
}