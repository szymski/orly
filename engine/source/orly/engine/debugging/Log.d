module orly.engine.debugging.log;

import std.stdio;
import std.array;
import std.file;
import std.conv;
import std.datetime;

static class Log {

	static string[] lines;

	/**
		Prints a message to the console.
	*/
	static void Print(T...)(T args) {
		string str = "<" ~ Clock.currTime().toSimpleString() ~ "> ";

		foreach(obj; args)
			str ~= to!string(obj);
		
		lines ~= str;
		
		writeln(str);
	}

	/**
		Prints a debug message to the console.
	*/
	static void PrintDebug(T...)(T args) {
		string str = "<" ~ Clock.currTime().toSimpleString() ~ "> DEBUG: ";

		foreach(obj; args)
			str ~= to!string(obj);

		lines ~= str;

		writeln(str);
	}
    
	/**
		Prints an error message to the console.
	*/
    static void PrintError(T...)(T args) {
		string str = "<" ~ Clock.currTime().toSimpleString() ~ "> ERROR: ";

		foreach(obj; args)
			str ~= to!string(obj);
		
		lines ~= str;
		
		writeln(str);
	}

	/**
		Throws an exception and prints the message into the console.
	*/
	static void Throw(Exception e) {
		PrintError(e.msg);
		throw e;
	}

	/**
		Saves the log to a file.
	*/
	static void SaveToFile(string filename = "log.txt") {
		std.file.write(filename, lines.join("\n"));
	}

}
