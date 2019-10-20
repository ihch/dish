import std.stdio;
import std.file;
import std.process;
import std.string;
import std.path : buildPath;

import readline;
import Command : Command;
import Dish : Dish;


/++
  run dish
+/
void d_shell() {
    auto dish = new Dish;

    writefln("Hello, %s. Let's Hack!\n\n", environment["USER"]);

    int status = 1;
    do {
        dish.commands["prompt"].command([]);
        string command = read_line;

        if (command == "") {
            continue;
        }

        Command* p = (command.split[0] in dish.commands);
        if (p != null) {
            status = p.command([command]);
        }
        else {
            // " 2> /dev/null" 標準エラー出力を虚無の世界に投げています
            const auto exec_status = spawnShell(command ~ " 2> /dev/null").wait;
            if (exec_status != 0 && exec_status != 1) {
                "dish: unknown command '%s'".writefln(command.split[0]);
            }
        }
    }
    while (status > 0);
}

void main() {
    d_shell;
}
