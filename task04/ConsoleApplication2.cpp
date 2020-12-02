#include <iostream>
#include <iomanip>
#include <thread>
#include <fstream>
#include <sstream>
#include <vector>
#include <mutex>
#include <string>
#include <omp.h>
using namespace std;

vector<vector<float>> readInput(const std::string& input, unsigned int* n, unsigned int* threadNum) {
    ifstream in(input);
    unsigned int thN, N;
    in >> thN >> N;

    *n = N;
    *threadNum = thN;

    vector<vector<float>> matrix(N, vector<float>(N * 2));

    // считываем исходную матрицу
    float num;
    for (unsigned int i = 0; i < N; i++) {
        for (unsigned int j = 0; j < N; j++) {
            in >> num;
            matrix[i][j] = num;
        }
    }

    // заполняем единичную матрицу
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


void writeOutput(const std::string& output, vector<vector<float>> matrix, unsigned int n) {
    std::ofstream out(output);

    for (unsigned int i = 0; i < n; i++) {
        for (unsigned int j = 0; j < n; j++) {
            out << matrix[i][j] << " ";
        }
        out << endl;
    }
}


void GaussJordan(vector<vector<float>>& matrix, unsigned int n, unsigned int threadNum) {

    if (threadNum > n) {
        // если количество доступных потоков больше размерности, то используем только n потоков
        threadNum = n;
        cout << "Number of available threads is greater than matrix dimension. " + to_string(n) + " threads will be used";
    }

    vector<thread> threads(threadNum);

    unsigned int temp;
    for (unsigned int j = 0; j < n; j++) {
        cout << "Column #" + to_string(j + 1) << endl;
        temp = j; // индекс строки, в которой должен быть ведущий элемент (i==j)
        if (matrix[temp][j] == 0) { // если на месте ведущего элемента 0, то ищем ненулевой элемент, находящийся ниже в столбце
            for (unsigned int i = j + 1; i < n; i++) {
                if (matrix[i][j] != 0) {
                    temp = i;
                    break;
                }
            }
            if (matrix[temp][j] == 0) {
                cout << endl << "Error: matrix determinant equals 0" << endl;
                exit(1);
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

        int i = 0;
        // Устанавливаем общие для всех потоков переменные и количество потоков
        #pragma omp parallel shared(matrix, j, i) num_threads(threadNum)
        {
            #pragma omp for
            for (i = 0; i < n; i++) {

                // Получаем порядковый номер (идентификатор) текущего потока
                int threadId = omp_get_thread_num();
                cout << "Thread # " + to_string(threadId + 1) + " row# " + to_string(i + 1) +"\n";

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

}



int main(int argc, char* argv[]) {
    string input = argv[1];
    string output = argv[2];

    unsigned int threadNum;
    unsigned int n;
    vector<vector<float>> matrix = readInput(input, &n, &threadNum);

    if (n <= 15) {
        cout << "Initial matrix:" << endl;
        for (unsigned int i = 0; i < n; i++) {
            for (unsigned int j = 0; j < n; j++) {
                cout << matrix[i][j] << "  ";
            }
            cout << endl;
        }
    }

    cout << endl;
    GaussJordan(matrix, n, threadNum);
    cout << endl;

    if (n <= 15) {
        cout << "Inverse matrix: " << endl;
        for (unsigned int i = 0; i < n; i++) {
            for (unsigned int j = 0; j < n; j++) {
                cout << matrix[i][j + n] << "  ";
            }
            cout << endl;
        }
    }

    writeOutput(output, matrix, n);

}


