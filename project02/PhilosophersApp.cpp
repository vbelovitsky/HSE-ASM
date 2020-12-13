#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>

// Кроссплатформенный sleep
#ifdef _WIN32
#include <windows.h>
void sleep(unsigned milliseconds)
{
    Sleep(milliseconds);
}
#else
#include <unistd.h>
void sleep(unsigned milliseconds)
{
    usleep(milliseconds * 1000);
}
#endif

// Количество философов
#define N 5
// Время для sleep в миллисекундах 
#define STIME 3000

// Числовые значения состояний
#define THINKING 0
#define HUNGRY 1
#define EATING 2

// Удобные обозначения левого и правого соседов phnum-го философа
#define LEFT (phnum + 4) % N
#define RIGHT (phnum + 1) % N

// Массив состояний философов
int state[N];
// Массив номеров философов
int phil[N] = { 0, 1, 2, 3, 4 };

// Общий бинарный семафор, необходимый для того, чтобы философы не могли одновременно взять/положить вилки
sem_t mutex;
// Общие бинарные семафоры для каждой вилки
sem_t S[N];

// попытка поесть
void test(int phnum) {
    if (state[phnum] == HUNGRY
        && state[LEFT] != EATING
        && state[RIGHT] != EATING) {

        // меняем статус на "ем"
        state[phnum] = EATING;
        sleep(STIME);

        printf("Philosopher %d take fork %d and %d\n", phnum + 1, LEFT + 1, phnum + 1);
        printf("Philosopher %d is Eating\n", phnum + 1);

        // при take_fork() не имеет эффекта
        // при put_fork() пробуждает голодных философов
        sem_post(&S[phnum]);
    }
}


// процесс взятия вилок
void take_fork(int phnum) {
    sem_wait(&mutex);

    // меняем состояние на голодное
    state[phnum] = HUNGRY;

    printf("Philosopher %d is Hungry\n", phnum + 1);

    // Пытаемся поесть
    test(phnum);

    sem_post(&mutex);

    // если нет возможности подождать, пока не будет получен сигнал
    sem_wait(&S[phnum]);
}


// процесс возврата вилок
void put_fork(int phnum) {
    sem_wait(&mutex);

    // переходим обратно в думающее состояние
    state[phnum] = THINKING;

    printf("Philosopher %d put back fork %d and %d\n", phnum + 1, LEFT + 1, phnum + 1);
    printf("Philosopher %d is Thinking\n", phnum + 1);

    // Вежливо предлагаем правому и левому соседам поесть
    test(LEFT);
    test(RIGHT);

    sem_post(&mutex);
}

// имитация деятельности философа
void* philospher(void* num) {

    while (true) {
        int* i = (int*)num;

        sleep(STIME);
        // Пытаемся взять вилки
        take_fork(*i);

        sleep(STIME);
        // Кладем вилки обратно на стол
        put_fork(*i);
    }
}

int main(){

    pthread_t thread_id[N];

    // инициализируем семафоры
    sem_init(&mutex, 0, 1);
    for (int i = 0; i < N; i++) {
        sem_init(&S[i], 0, 0);
    }

    for (int i = 0; i < N; i++) {
        // создаем и запускаем процессы философов
        pthread_create(&thread_id[i], NULL, philospher, &phil[i]);

        // перед началом трапезы философы думают
        printf("Philosopher %d is Thinking\n", i + 1);
    }

    // ждем завершения работы потоков 
    // (но в данной реализации философы ведут свою деятельность бесконечно)
    for (int i = 0; i < N; i++) {
        pthread_join(thread_id[i], NULL);
    }

}

