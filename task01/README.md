# HSE-ASM
Репозиторий с моими работами по предмету "Архитектура вычислительных систем"

## Беловицкий Владислав Ильич БПИ191

## 1) Hello World!
Первая программа выводит в консоли классический "Привет, мир!", а также через строку мое имя.</br>
Программа завершится после считывания любой клавиши (getch).
![](1-helloWorld/screenshot.JPG)</br>

## 2) Диалоговое окошко.
Пример вызова MessageBox с двумя опциями выбора. Выбранный ответ будет записан в регистр eax,</br>
в зависимости от ответа вызываем новое окошко с сообщением.
![](2-dialogForm/dialog-screenshot.JPG)</br>
Попробуем перейти на оффлайн обучение:
![](2-dialogForm/error-screenshot.JPG)</br>
Интересно то, что если код вынести в секцию (закомментировал на изображении), то потребуются явные импорты сборок/функций

## 3) Запуск исполняемого файла
Третья программа запускает программу по указанному пути. Для примера запустим блокнот.
![](3-startProcess/screenshot.JPG)</br>
Я попытался сделать возможность самостоятельно вводить путь до exe-шника с помощью консоли,</br>
но пока что не удалось. Также пробовал с помошью функции ReadConsoleA.

Напишем послание и сохраним из открытого нами блокнота файл myfile.txt в папку четвертой программы:
![](3-startProcess/notepad-screenshot.JPG)</br>

## 4) Чтение файла
Четвертая программа считывает содержимое файла и выводит результат в окошко.</br>
Считаем содержимое файлика, созданного нами выше:
![](4-readFile/screenshot.JPG)

## 5) Консольный калькулятор
Последняя программа представляет собой простой калькулятор, который может выполнять операции над двумя числами.</br>
Я написал его по видео-уроку.</br>
С исходным кодом можно ознакомиться в папке 5-calculator (на одном скиншоте он не помещается).
### Результат работы:
Сложение (нужно ввести символ +):
![](5-calculator/add.JPG)

Вычитание (нужно ввести сивол -):
![](5-calculator/sub.JPG)

Умножение (нужно ввести сивол *):
![](5-calculator/mul.JPG)

Деление с правильной дробной частью (нужно ввести сивол %):
![](5-calculator/mod.JPG)

Деление с десятичной дробью, 3 знака после запятой (нужно ввести сивол /):
![](5-calculator/div.JPG)
Вывод дробной части реализован с помощью "цикла" - повторяющемуся переходу к одной и той же метке.

## Источники
1. Vitali Kremez. FASM: Flat Assembler, also known as "FASM": Sample Code. [Электронный
ресурс] Режим доступа: https://www.vkremez.com/2017/04/fasm-flat-assembler-also-known-as-fasm.html
2. byte++. FASM. Калькулятор на ассемблере. Метки, циклы, условные переходы. Установка FASM.
[Электронный ресурс] Режим доступа: https://www.youtube.com/watch?v=ttS0tc1igpw
3. Урок 1:Создаём программу выводящую сообщение. [Электронный ресурс] Режим доступа: http://cyberdino.narod.ru/les1p1.html

