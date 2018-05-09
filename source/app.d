import std.stdio;
import std.file;
import std.process;
import std.string;
import std.path : buildPath;

auto dish_funcs = [
    &dish_ls
];

int[string] dish_func_names;

void prompt() {
    const userName = environment["USER"];
    writef(userName ~ " > " );
}


void dish_ls(string current_dir) {
    foreach (string e; dirEntries(current_dir, SpanMode.shallow)) {
        e.split("/")[$ - 1].writeln;
    }
}


string read_line() {
    string line = readln;
    if (line[$ - 1] == '\n') {
        return line.chomp;
    }
    return null;
}


void d_shell() {
    dish_func_names["ls"] = 0;
    const USER_NAME = environment["USER"];
    string current_dir = getcwd;
    auto PATH = environment["PATH"].split(":");
    PATH.writeln;
    PATH.length.writeln;
    while (true) {
        prompt;
        string command = read_line;

        if (command in dish_func_names) {
            dish_funcs[dish_func_names[command]](current_dir);
        }
        else {
            // execvp(command, PATH);
            // execvp(command, []);
        }
    }
}


void main()
{
    d_shell;
}
