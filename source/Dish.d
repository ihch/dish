module Dish;

import std.stdio;
import std.conv;
import std.string;
import std.file;
import std.process;
import Command : Command;

class Dish {
    private {
        const string USER_NAME;
        const string[] PATH;
        string current_dir;
    }

    public {
        Command[string] commands;
    }

    this() {
        this.USER_NAME = environment["USER"];
        this.PATH = environment["PATH"].split(":");

        commands = [
            "prompt": Command("prompt", &this.prompt),
            "ls": Command("ls", &this.ls),
            "exit": Command("exit", &this.exit),
            "hoge": Command("hoge", &this.hoge),
        ];
    }

    int prompt(string[] args) {
        (USER_NAME ~ " > ").write;
        return 1;
    }

    int ls(string[] args) {
        foreach(string e; dirEntries(getcwd, SpanMode.shallow)) {
            e.split("/")[$ - 1].writeln;
        }
        return 1;
    }

    int echo(string[] args) {
        // ex1. args[0] : "echo hoge"
        // ex2. args[0] : "echo $USER"
    }

    int exit(string[] args) {
        "see you again.".writeln;
        return 0;
    }

    int hoge(string[] args) {
        "hoge".writeln;
        return 1;
    }
}