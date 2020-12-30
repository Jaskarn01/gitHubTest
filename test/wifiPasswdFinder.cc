#include <bits/stdc++.h>
using namespace std;

bool check_for_name(string line, string sub_str) {
    size_t found = line.find(sub_str);
    if (found != string::npos) return true;
    return false;
}

string get_name(string line) {
    string name = "";
    for (int i=27; i<line.length(); i++) name += line[i];
    return name;
}

int main() {
    system("if exist file.txt del file.txt");system("type nul > file.txt");system("netsh wlan show profile > file.txt");
    ifstream in;
    string line;
    in.open("file.txt");
    string passwords[10];
    while (in.eof() == 0) {
        getline(in, line);
        if (check_for_name(line, "All User Profile")) {
            string name = get_name(line);
            system("if exist passwd.txt del passwd.txt");system("type nul > passwd.txt");system("netsh wlan show profile > passwd.txt");
            ifstream out;
            string str_command = "netsh wlan show profile " + name + " key=clear > passwd.txt";
            char command[1000];for (int i=0; i<str_command.length();i++) command[i] = str_command[i];
            system(command);
            out.open("passwd.txt");
            string line_out;
            while (out.eof() == 0) {
                getline(out, line_out);
                if(check_for_name(line_out, "Key Content")) {
                    cout<<" Singh"<<endl;
                };
            }
            out.close();
        }
    }
    in.close();

}
