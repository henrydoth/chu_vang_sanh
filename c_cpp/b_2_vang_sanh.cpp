#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main() {
  ifstream file("../chu_vang_sanh.md");
  
  if (!file.is_open()) {
    cout << "Cannot open file chu_vang_sanh.md\n";
    return 1;
  }
  
  string line;
  while (getline(file, line)) {
    cout << line << endl;
  }
  
  file.close();
  return 0;
}
