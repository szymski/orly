module orly.engine.components.component;

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

/**
	Component factory

	Class internally used by the engine to create instances of components.
*/
static class ComponentFactory {
 private:
	static Component delegate()[string] delegates;

 public:

	/**
		Registers a Component creating delegate
	*/
	static void RegisterComponent(string name, Component delegate() func) {
		delegates[name] = func;
		std.stdio.writeln("Registered " ~ name ~ " component");
	}

	/**
		Creates a new Component object from the specified name
	*/
	static Component CreateNew(string name) {
		auto p = name in delegates; 
		
		if(p is null)
			throw new Exception("No such component (" ~ name ~ ") registered");

		return (*p)();
	}
}

/*
	Registering mixin
*/

/**
	Mixin used to register a component.
	You should use it once for each component.
*/
mixin template RegisterComponent(T) {
	shared static this() {
		ComponentFactory.RegisterComponent(__traits(identifier, T), delegate() {
			return new T();
		});
	}
}