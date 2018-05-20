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
            "hoge": Command("hoge", &this.hoge),
        ];
    }

    int prompt(string[] args) {
        (USER_NAME ~ " >").writeln;
        return 1;
    }

    int ls(string[] args) {
        foreach(string e; dirEntries(getcwd, SpanMode.shallow)) {
            e.split("/")[$ - 1].writeln;
        }
        return 1;
    }

    int hoge(string[] args) {
        "hoge".writeln;
        return 1;
    }
}

void main() {
    Dish dish = new Dish();
    dish.commands["prompt"].command([]);
    dish.commands["ls"].command([getcwd]);
    dish.commands["hoge"].command([]);
}