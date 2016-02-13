module orly.engine.renderer.mesh;

import orly.engine.renderer.vertex;

final class Mesh {

	Vertex[] vertices;

	this() {
		
	}

	this(Vertex[] vertices) {
		this.vertices = vertices;
	}

	@property int VertexCount() { return vertices.length; }

	@property float[] DataXYZ() {
		float[] data = new float[vertices.length * 3];

		foreach(int i, Vertex v; vertices) {
			data[i * 3] = v.x;
			data[i * 3 + 1] = v.y;
			data[i * 3 + 2] = v.z;
		}

		return data;
	}

	@property float[] DataUV() {
		float[] data = new float[vertices.length * 2];

		foreach(int i, Vertex v; vertices) {
			data[i * 2] = v.u;
			data[i * 2 + 1] = v.v;
		}

		return data;
	}
}