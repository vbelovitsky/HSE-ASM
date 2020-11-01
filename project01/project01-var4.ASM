; Беловицкий В.И. Вариант 4
; определить, являются ли 4 введенных числа взаимно простыми


format PE console
entry start

include 'win32a.inc'


section '.data' data readable writable

        strVecSize   db 'Input how many numbers check on coprime: ', 0
        strIncorNumber db 'Number should be in range [%hu, %hu]. Your input: %hu. Try again:',10, 0
        strVecElemI  db '[%hu]? ', 0
        strScanNum   db '%hu', 0

        strNotCoprime db 'Numbers are not coprime.', 0
        strAreCoprime db 'Numbers are coprime.', 0

        strGCD db 'GCD = %hu', 0
        strEndl db '', 10, 0
        strPressKey db 'Press any key to exit...', 10, 0

        vec_size     dd 0
        vec_min_size dd 1
        vec_max_size dd 10

        num_min      dd 1
        num_max      dd 65535

        i            dd ?
        tmp          dd ?

        tmpStack     dd ?   ;временный стэк для повтора ввода длины или элементов массива

        vec          dd 0  ; указатель на первый элемент массива

;--------------------------------------------------------------------------
section '.code' code readable executable
start:

        call VectorInput

        push strEndl
        call [printf]

        call FindGCD
        mov [tmp], eax

        push eax
        push strGCD
        call [printf]
        push strEndl
        call [printf]

        cmp [tmp], 1        ; GCD = 1 -> coprime
        je AreCoprime
        push strNotCoprime
        call [printf]
        jmp finish
AreCoprime:
        push strAreCoprime
        call [printf]


finish:
        push strEndl
        call [printf]

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
        push strScanNum
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg checkUpperBound
        jle sizeIncorrect

checkUpperBound:
        mov eax, [vec_size]
        cmp eax, [vec_max_size]
        jg sizeIncorrect
        jle getVector

sizeIncorrect:
        push [vec_size]
        push [vec_max_size]
        push [vec_min_size]
        push strIncorNumber
        call [printf]
        push strEndl
        call [printf]

        mov esp, [tmpStack]

        jle VectorInput

getVector:
        xor ecx, ecx          ; ecx = 0
        mov ebx, vec          ; ebx = &vec (ссылаемся на начало массива)

getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]   ; если дошли до конца, то завершаем цикл
        jge endInputVector

inputNumber:
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanNum
        call [scanf]
        add  esp, 8

        mov eax, [ebx]
        cmp eax, [num_max]
        jg incorNumber
        cmp eax, [num_min]
        jl incorNumber
        jmp correctNumber

incorNumber:
        push eax
        push [num_max]
        push [num_min]
        push strIncorNumber
        call [printf]
        add esp, 16
        mov ecx, [i]
        mov ebx, [tmp]
        jmp inputNumber

correctNumber:
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop

endInputVector:
        ret


FindGCD:
        xor ecx, ecx
        mov ebx, vec
        mov eax, [ebx]
GCDloop:
        add ebx, 4
        mov edx, [ebx]
        inc ecx
gcd:
        cmp  eax, edx
        jge  fGEs
        xchg eax, edx
fGEs:
        cmp edx, 0
        je  gcdEnd
        sub eax, edx
        jmp gcd
gcdEnd:

        cmp ecx, [vec_size]
        jge GCDFound
        jmp GCDloop

GCDFound:
        ret

;--------------------------------------------------------------------------
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