module orly.engine.gameobjects.gameobject;

import orly.engine.components.component;
import orly.engine.components.transform;
import orly.engine.components.factory;

alias Transform _Transform;

class GameObject {
 private:

	Component[] components;
	string tag = "";

	_Transform transform;

 public:

	this() {
		transform = AddComponent!_Transform();
	}

	@property ref string Tag() { return tag; }
	@property ref _Transform Transform() { return transform; }

	/**
		Returns a list of the components.
	*/
	@property Component[] Components() { return components; }

	/**
		Updates the game object.
	*/
	void Update() {
		foreach(c; components)
			c.OnUpdate();
	}

	/**
		Renders the game object.
	*/
	void Render() {
		foreach(c; components) 
			c.OnRender();
	}

	/**
		Adds a new component of specified type.
	*/
	T AddComponent(T : Component)() {
		T component = new T();
		component.GameObject = this;
		components ~= component;
		component.OnStart();
		return component;
	}

	/**
		Gets the component of specified type.
	*/
	T GetComponent(T : Component)() {
		foreach(component; components)
			if(cast(T)component)
				return cast(T)component;

		return null;
	}

	/**
		Removes the component of specified type.
	*/
	void RemoveComponent(T : Component)() {
		for(int i = 0; i < components.length; i++)
			components.remove(i);

		// TODO: Component removing
	}
}

unittest {
	
	import orly.engine.components.transform;

	GameObject obj = new GameObject();

	// AddComponent and GetComponent
	obj.AddComponent!Transform();
	assert(obj.GetComponent!Transform().GameObject == obj, "Invalid parent");

	// RemoveComponent
	//obj.RemoveComponent!Transform();
	//assert(obj.GetComponent!Transform() is null, "Removed component isn't null");
}