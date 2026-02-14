#include <iostream>
#include <vector>
#include <iomanip>
#include <string>
#include <cmath>

using namespace std;

struct Student {
  string name;
  int height;   // cm
  int weight;   // kg
  float bmi;
};

void enterStudent(vector<Student>& vec) {
  Student newStudent;
  
  cout << "Enter name: ";
  cin >> newStudent.name;
  
  cout << "Enter height (cm): ";
  cin >> newStudent.height;
  
  cout << "Enter weight (kg): ";
  cin >> newStudent.weight;
  
  // BMI = kg / (m^2) = 10000 * kg / (cm^2)
  newStudent.bmi = 10000.0f * newStudent.weight / pow(newStudent.height, 2);
  
  vec.push_back(newStudent);
}

bool ishealthy(float bmi) {
  return bmi <= 23.0f;
}

void printname(const vector<Student>& vec) {
  if (vec.empty()) {
    cout << "No students yet.\n";
    return;
  }
  
  for (const Student& stu : vec) {
    cout << stu.name << " has a BMI of: "
         << fixed << setprecision(2) << stu.bmi << " ";
    
    if (ishealthy(stu.bmi)) {
      cout << "and is healthy\n";
    } else {
      cout << "and isn't healthy\n";
    }
  }
}

int main() {
  vector<Student> vec;
  int choice = 0;
  
  do {
    cout << "\n0. Exit\n";
    cout << "1. Enter new student\n";
    cout << "2. Print all students\n";
    cout << "Choice: ";
    
    cin >> choice;
    
    switch (choice) {
    case 1:
      enterStudent(vec);
      break;
      
    case 2:
      printname(vec);
      break;
      
    case 0:
      cout << "Bye!\n";
      break;
      
    default:
      cout << "Invalid choice.\n";
    break;
    }
    
  } while (choice != 0);
  
  return 0;
}
