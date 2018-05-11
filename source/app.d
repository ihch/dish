import std.stdio;
import std.file;
import std.process;
import std.string;
import std.path : buildPath;
import core.thread : Thread;
import core.sys.posix.unistd : fork;

auto dish_funcs = [
    &dish_ls,
    &dish_exit
];

ulong[string] dish_func_names;

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


int dish_exit(string current_dir) {
    writeln("exit dish. good bye!");
    return -1;
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
    dish_func_names["ls"] = dish_func_names.length;
    dish_func_names["exit"] = dish_func_names.length;
    const USER_NAME = environment["USER"];
    string current_dir = getcwd;
    auto PATH = environment["PATH"].split(":");
    PATH.writeln;
    PATH.length.writeln;
    current_dir.writeln;

    int status;
    do {
        prompt;
        string command = read_line;
        status = exec_command(command, current_dir);

    } while (status != -1);
}


void main()
{
    d_shell;
}
