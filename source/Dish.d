module Dish;

import std.stdio;
import std.file;
import std.process;
import Command;

class Dish {
    private {
        const string USER_NAME;
        const string[] PATH;
        string current_dir;
    }

    public {
        Command[] commands;
    }

    this() {
        this.USER_NAME = environment["USER"];
        this.PATH = environment["PATH"];
        this.current_dir = getcwd;
    }
}

// void main() {
//     Dish dish = new Dish();
// }