module Command;

struct Command {
    string command_name;
    int delegate(string[]) command;
}