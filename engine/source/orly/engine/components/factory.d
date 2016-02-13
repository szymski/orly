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

/**
	Mixin used to register a component.
	You should use it once for each component.
*/
mixin template RegisterComponent(T) {
	static this() {
		ComponentFactory.RegisterComponent(__traits(identifier, T), delegate() {
			return new T();
		});
	}
}

import std.string;

mixin template PrintMembers() {
	import std.string : replace;
	import std.stdio : writeln;
	mixin(q{
			static this() {
				import mod = %moduleName%;

				foreach(m; __traits(allMembers, mod)) {
					if(is(m : Component))
					writeln(m);
				}
			}
		}.replace("%moduleName%", __MODULE__));
}