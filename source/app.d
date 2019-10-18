import core.sys.posix.termios;
import std.stdio;
import std.file;
import std.process;
import std.string;
import std.path : buildPath;

import Command : Command;
import Dish : Dish;


int getch()
{
    int ch;
    termios oldt;
    termios newt;

    tcgetattr(0, &oldt);
    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(0, TCSANOW, &newt);
    ch = getchar();
    tcsetattr(0, TCSANOW, &oldt);

    ch.write;
    // write(cast(char) ch);
    return ch;
}

/++
  read user input command

  return: result string
+/
string read_line() {
    string buffer = "";

    do {
        int c = getch();
        if (c == 27) {
          getch();
          c = getch();
          if (c == 65) write("<up>");
          if (c == 66) write("<down>");
          if (c == 67) write("<right>");
          if (c == 68) write("<left>");
          continue;
        }
        if (c == 127) write("<BS>");
        buffer ~= c;
        // write(c);
    } while (buffer.length == 0 || buffer[$ - 1] != '\n');
    writeln(buffer);

    return buffer.chomp;
}

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
