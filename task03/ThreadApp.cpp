﻿#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <thread>
#include <fstream>
#include <vector>
using namespace std;

vector<vector<float>> readInput(const std::string& input,  unsigned int* n, unsigned int* threadNum) {
    ifstream in(input);
    unsigned int thN, N;
    in >> thN >> N;

    *n = N;
    *threadNum = thN;

    vector<vector<float>> matrix(N, vector<float>(N * 2));

    float num;
    for (unsigned int i = 0; i < N; i++) {
        for (unsigned int j = 0; j < N; j++) {
            in >> num;
            matrix[i][j] = num;
        }
    }

    for (unsigned int i = 0; i < N; i++) {
        for (unsigned int j = 0; j < N; j++) {
            if (i == j) {
                matrix[i][j + N] = 1;
            }
            else {
                matrix[i][j + N] = 0;
            }
        }
    }
    return matrix;
}

void Gauss(vector<vector<float>> &matrix, unsigned int n) {

    unsigned int temp;
    for (unsigned int j = 0; j < n; j++) {
        temp = j; // индекс строки, в которой должен быть ведущий элемент (i==j)
        if (matrix[temp][j] == 0) { // если на месте ведущего элемента 0, то ищем ненулевой элемент, находящийся ниже в столбце
            for (unsigned int i = j + 1; i < n; i++) {
                if (matrix[i][j] != 0) {
                    temp = i;
                    break;
                }
            }
            if (matrix[temp][j] == 0) {
                throw new runtime_error("Matrix determinant equals 0");
            }
            else {
                // меняем текущую строку со строкой с найденным ненулевым элементом
                for (unsigned int k = j; k < 2 * n; k++) {
                    float tempEl = matrix[temp][k];
                    matrix[temp][k] = matrix[j][k];
                    matrix[j][k] = tempEl;
                }
            }

        }

        // проходимся по всем строкам
        for (unsigned int i = 0; i < n; i++) {
            if (i == j) { // если строка с текущим ведущим элементом, то делим строку на ведущий элемент
                float lead = matrix[i][j]; // текущий ведущий элементом
                for (unsigned int k = j; k < 2 * n; k++) { // начинаем с j, т.к. до j элементы равны 0
                    matrix[i][k] /= lead;
                }
            }
            else { // иначе вычитаем из строки линейную комбинацию строки с ведущим элементом
                float lead = matrix[i][j]; // элемент строки с ведущим элементом
                for (unsigned int k = j; k < 2 * n; k++) {
                    matrix[i][k] -= matrix[j][k] * lead / matrix[j][j];
                }
            }
        }

    }
}

int main(int argc, char* argv[]) {
    string input = argv[1];

    unsigned int threadNum;
    unsigned int n;
    vector<vector<float>> matrix = readInput(input, &n, &threadNum);

    for (unsigned int i = 0; i < n; i++) {
        for (unsigned int j = 0; j < 2*n; j++) {
            cout << matrix[i][j] << "  ";
        }
        cout << endl;
    }

    Gauss(matrix, n);

    for (unsigned int i = 0; i < n; i++) {
        for (unsigned int j = 0; j < n; j++) {
            cout << matrix[i][j+n] << "  ";
        }
        cout << endl;
    }
    
}


