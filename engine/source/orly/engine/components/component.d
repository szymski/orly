module orly.engine.components.component;

import orly.engine.components.factory;
import orly.engine.gameobjects.gameobject;

alias GameObject _GameObject;

/**
	Component class
*/
class Component {
 private:
	
	_GameObject gameObject;

 public:

	@property ref _GameObject GameObject() { return gameObject; }

	void OnStart() { }
	void OnDestroy() { }
	void OnUpdate() { }
	void OnRender() { }

}