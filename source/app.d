import std.stdio;
import std.file;
import std.process;
import std.string;
import std.path : buildPath;
import core.thread : Thread;
import core.sys.posix.unistd : fork;

auto dish_funcs = [
    &dish_ls
];

int[string] dish_func_names;

void prompt() {
    const userName = environment["USER"];
    writef(userName ~ " > " );
}


int dish_ls(string current_dir) {
    foreach (string e; dirEntries(current_dir, SpanMode.shallow)) {
        e.split("/")[$ - 1].writeln;
    }
    return 1;
}


string read_line() {
    string line = readln;
    if (line[$ - 1] == '\n') {
        return line.chomp;
    }
    return null;
}


int exec_command(string command, string current_dir) {
    auto args = command.split;
    if (args.length == 0) {
        return 0;
    }

    int status;
    if (command in dish_func_names) {
        status = dish_funcs[dish_func_names[command]](current_dir);
    }
    else {
        auto pid = spawnShell(command);
        status = pid.wait;
    }

    return status;
}


void d_shell() {
    dish_func_names["ls"] = 0;
    const USER_NAME = environment["USER"];
    string current_dir = getcwd;
    auto PATH = environment["PATH"].split(":");
    PATH.writeln;
    PATH.length.writeln;
    current_dir.writeln;
    do {
        prompt;
        string command = read_line;
        exec_command(command, current_dir);

    } while (true);
}


void main()
{
    d_shell;
}
