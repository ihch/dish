import core.sys.posix.termios;
import std.stdio;
import std.string;


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

    // ch.write;
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
          if (c == 65) { /+ write("<up>"); +/ }
          if (c == 66) { /+ write("<down>"); +/ }
          if (c == 67) { /+ write("<right>"); +/ }
          if (c == 68) { /+ write("<left>"); +/ }
          continue;
        }
        if (c == 127) {
          backspace(buffer);
          continue;
        }
        buffer ~= cast(char)c;
        write(cast(char)c);
    } while (buffer.length == 0 || buffer[$ - 1] != '\n');

    return buffer.chomp;
}

void backspace(ref string s) {
  if (s.length <= 0) return;
  s = s[0..$-1];
  write("\b \b");
}
