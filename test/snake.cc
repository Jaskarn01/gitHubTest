#include <iostream>
#include <time.h>
#include <cstdlib>
#include <windows.h>
#include <process.h>
#include <conio.h>
using namespace std;
#define MAX 100
#define WIDTH 77
#define HEIGHT 22
#define INIT_SNAKE_LENGTH 4
#define FOOD 1
#define WALL -2
#define SNAKE -1
#define NOTHING 0
#define RIGHT 0
#define UP 1
#define LEFT 2
#define DOWN 3
#define EXIT -1
static int dx[5] = {1, 0, -1, 0};
static int dy[5] = {0, -1, 0, 1};
int input = RIGHT;
int item = NOTHING;
void gotoxy(int column, int row) {
    HANDLE hStdOut;
    COORD coord;
    hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
    if (hStdOut == INVALID_HANDLE_VALUE) return;

    coord.X = column;
    coord.Y = row;
    SetConsoleCursorPosition(hStdOut, coord);
}
int main() {return 0;}
