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


int exec_command(string command) {
    auto args = command.split;
    if (args.length == 0) {
        return 0;
    }
    // auto pid = fork;
    auto pid = fork;
    command.writeln;
    args.writeln;
    // auto pid = corde.sys.posix.unistd.fork;
    writeln("command: ", command);
    if (pid == 0) {
        // executeShell(command);
        // if (execvp(command, path) == -1) {
        // execvp(args[0], args);

        void f() { execvp(args[0], args); }
        new Thread(&f).start;

        // new Thread(() => {execve(command, [], path);}).start;
        // if (execvp(command, []) == -1) {
        // // if (execvpe(command, path, path) == -1) {
        //     writeln("dish");
        // }
        // else {
        //     writeln("hoge");
        // }
    }
    return 1;
}


void d_shell() {
    dish_func_names["ls"] = 0;
    const USER_NAME = environment["USER"];
    string current_dir = getcwd;
    auto PATH = environment["PATH"].split(":");
    PATH.writeln;
    PATH.length.writeln;
    do {
        prompt;
        string command = read_line;

        if (command in dish_func_names) {
            dish_funcs[dish_func_names[command]](current_dir);
        }
        else {
            // execvp(command, PATH);
            // execvp(command, []);
            exec_command(command);
        }

        // writeln;
    } while (true);
}


void main()
{
    d_shell;
}
