; Беловицкий В.И. Вариант 4
; задать длину массива A
; ввести массив A
; сформировать массив B по следующим правилам:
; B[i] = 1,  A[i]>0
; B[i] = -1, A[i]<0
; B[i] = 0,  A[i]=0

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'Specify size of vector A: ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strVecB  db 'Vector B:', 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strPressKey db 'Press any key to exit...', 10, 0

        vec_size     dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?   ;временный стэк для повтора ввода длины или вывода элементов массива

        vecA         rd 100 ;резервируем место для массива A
        vecB         rd 100 ;резервируем место для массива B

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        call VectorInput

        call VectorGen

        push strVecB
        call [printf]

        call VectorOut
finish:
        push strPressKey
        call [printf]
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        mov [tmpStack], esp
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector

; fail size

        push [vec_size]
        push strIncorSize
        call [printf]
        mov esp, [tmpStack]
       ; mov eax, 0
       ; mov [vec_size], eax
        jle VectorInput ; предусмотрел повтор ввода при длине меньшей или равной нулю. При вводе символов программа входит в бесконечный цикл. Пока что не нашел решения на этот случай

        call [getch]
        push 0
        call [ExitProcess]

getVector:
        xor ecx, ecx             ; ecx = 0
        mov ebx, vecA            ; ebx = &vecA (ссылаемся на начало массива A)

getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]      ; если дошли до конца, то завершаем цикл
        jge endInputVector

        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add  esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4

        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
VectorGen:
        xor ecx, ecx
        mov ebx, vecA     ; ebx относится к массиву A
        mov edx, vecB     ; edx - к B

genVecLoop:
        cmp ecx, [vec_size]
        je endGenVector

        mov eax, 0
        cmp [ebx], eax  ; сравниваем значение элемента массива A с нулем
        jg AddOne       ; и в зависимости от результата присваиваем элементу массива B нужное значение
        je AddZero
        jl AddNeg

        Continue:
        add ebx, 4  ; двигаемся на 4 байта вперед в обоих массивах
        add edx, 4
        inc ecx

        jmp genVecLoop

endGenVector:
        ret

AddOne:
        mov eax, 1
        mov [edx], eax
        jmp Continue
AddZero:
        mov eax, 0
        mov [edx], eax
        jmp Continue
AddNeg:
        mov eax, -1
        mov [edx], eax
        jmp Continue

;--------------------------------------------------------------------------

VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx             ; ecx = 0
        mov edx, vecB            ; edx = &vec
putVecLoop:
        mov [tmp], edx
        cmp ecx, [vec_size]
        je endOutputVector       ; to end of loop
        mov [i], ecx

        push dword [edx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov edx, [tmp]
        add edx, 4
        jmp putVecLoop

endOutputVector:
        mov esp, [tmpStack]
        ret
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32, 'USER32.DLL'
include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess'
include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'