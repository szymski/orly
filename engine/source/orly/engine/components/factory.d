module orly.engine.components.factory;

import orly.engine.components.component;
import orly.engine.debugging.log;
import std.stdio;

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
		if(delegates.get(name, null) !is null)
			Log.Throw(new Exception("Component (" ~ name ~ ") is already registered"));

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

alias ToType(alias T) = T;

/**
	Mixin used to register all components from current module.
*/
mixin template RegisterComponents(string moduleName = __MODULE__) {
	static this() {
		mixin(`import mod = ` ~ moduleName ~ `;`);
		
		foreach(m; __traits(allMembers, mod)) static if(__traits(compiles, __traits(getMember, mod, m))) {
			alias member = ToType!(__traits(getMember, mod, m));

			static if(is(member : Component))
				ComponentFactory.RegisterComponent(__traits(identifier, member), delegate() {
					return new member();
				});
		}
	}
}