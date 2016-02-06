module orly.engine.debugging.log;

import std.stdio;
import std.array;
import std.file;
import std.conv;
import std.datetime;

static class Log {

	static string[] lines;

	/**
		Prints a message to the console
	*/
	static void Print(T...)(T args) {
		string str = "<" ~ Clock.currTime().toISOExtString() ~ "> ";

		foreach(string obj; args)
			str ~= obj;
		
		lines ~= str;
		
		writeln(str);
	}
    
	/**
	Prints an error message to the console
	*/
    static void PrintError(T...)(T args) {
		string str = "<" ~ Clock.currTime().toISOExtString() ~ "> ERROR: ";

		foreach(string obj; args)
			str ~= obj;
		
		lines ~= str;
		
		writeln(str);
	}

	/**
		Saves the configuration to a file
	*/
	static void SaveToFile(string filename = "log.txt") {
		std.file.write(filename, lines.join("\n"));
	}

}
