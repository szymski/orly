module orly.engine.assets.models.modelasset;

public import orly.engine.renderer.vertex;
public import orly.engine.renderer.mesh;
import orly.engine.debugging.log;
import orly.engine.assets.asset;
import derelict.assimp3.assimp;
import std.stdio;

alias Mesh _Mesh;

class ModelAsset : Asset {
 private:
	_Mesh mesh;

 public:

	this(string filename) {
		Log.Print("Loading model - ", filename);

		const(aiScene*) scene = aiImportFile(cast(char*)filename, aiProcess_Triangulate | aiProcess_JoinIdenticalVertices | aiProcess_FlipUVs);

		Log.Print("Vertex count - ", scene.mMeshes[0].mNumVertices);
		Log.Print("TexCoords count - ", scene.mMeshes[0].mNumUVComponents);
		Log.Print("Faces count - ",  scene.mMeshes[0].mNumFaces);

		Vertex[] vertices = new Vertex[scene.mMeshes[0].mNumFaces * 3];

		foreach(int i; 0 .. scene.mMeshes[0].mNumFaces) {
			auto face = scene.mMeshes[0].mFaces[i];

			vertices[i * 3] = Vertex(scene.mMeshes[0].mVertices[face.mIndices[0]].x,
									 scene.mMeshes[0].mVertices[face.mIndices[0]].y,
									 scene.mMeshes[0].mVertices[face.mIndices[0]].z,
									 scene.mMeshes[0].mTextureCoords[0][face.mIndices[0]].x,
									 scene.mMeshes[0].mTextureCoords[0][face.mIndices[0]].y,
									 scene.mMeshes[0].mNormals[face.mIndices[0]].x);
			vertices[i * 3 + 1] = Vertex(scene.mMeshes[0].mVertices[face.mIndices[1]].x,
										 scene.mMeshes[0].mVertices[face.mIndices[1]].y,
										 scene.mMeshes[0].mVertices[face.mIndices[1]].z,
										 scene.mMeshes[0].mTextureCoords[0][face.mIndices[1]].x,
										 scene.mMeshes[0].mTextureCoords[0][face.mIndices[1]].y,
										 scene.mMeshes[0].mNormals[face.mIndices[1]].x);
			vertices[i * 3 + 2] = Vertex(scene.mMeshes[0].mVertices[face.mIndices[2]].x,
										 scene.mMeshes[0].mVertices[face.mIndices[2]].y,
										 scene.mMeshes[0].mVertices[face.mIndices[2]].z,
										 scene.mMeshes[0].mTextureCoords[0][face.mIndices[2]].x,
										 scene.mMeshes[0].mTextureCoords[0][face.mIndices[2]].y,
										 scene.mMeshes[0].mNormals[face.mIndices[2]].x);
		}
		aiReleaseImport(scene);

		mesh = new _Mesh(vertices);
	}

	@property _Mesh Mesh() {
		return mesh;
	}

	override public bool CanHandle(string filename) {
		return true;
	}

}