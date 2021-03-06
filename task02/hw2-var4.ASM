; ���������� �.�. ������� 4
; ������ ����� ������� A
; ������ ������ A
; ������������ ������ B �� ��������� ��������:
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
        strEndl db '', 10, 0
        strVecA  db 'Vector A:', 10, 0
        strVecB  db 'Vector B:', 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strPressKey db 'Press any key to exit...', 10, 0

        vec_size     dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?   ;��������� ���� ��� ������� ����� ����� ��� ������ ��������� �������

        vecA         rd 100 ;����������� ����� ��� ������� A
        vecB         rd 100 ;����������� ����� ��� ������� B

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        call VectorInput

        call VectorGen

        push strEndl
        call [printf]

        push strVecA    ; ������� A
        call [printf]
        call OutVecA

        push strVecB    ; ������� B
        call [printf]
        call OutVecB
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
        jle VectorInput ; ������������ ������ ����� ��� ����� ������� ��� ������ ����. ��� ����� �������� ��������� ������ � ����������� ����. ���� ��� �� ����� ������� �� ���� ������

        call [getch]
        push 0
        call [ExitProcess]

getVector:
        xor ecx, ecx             ; ecx = 0
        mov ebx, vecA            ; ebx = &vecA (��������� �� ������ ������� A)

getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]      ; ���� ����� �� �����, �� ��������� ����
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
        mov ebx, vecA     ; ebx ��������� � ������� A
        mov edx, vecB     ; edx - � B

genVecLoop:
        cmp ecx, [vec_size]
        je endGenVector

        mov eax, 0
        cmp [ebx], eax  ; ���������� �������� �������� ������� A � �����
        jg AddOne       ; � � ����������� �� ���������� ����������� �������� ������� B ������ ��������
        je AddZero
        jl AddNeg

        Continue:
        add ebx, 4  ; ��������� �� 4 ����� ������ � ����� ��������
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

OutVecB:
        mov [tmpStack], esp
        xor ecx, ecx             ; ecx = 0
        mov edx, vecB            ; edx = &vec
putVecBLoop:
        mov [tmp], edx
        cmp ecx, [vec_size]
        je endOutVecB       ; to end of loop
        mov [i], ecx

        push dword [edx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov edx, [tmp]
        add edx, 4
        jmp putVecBLoop

endOutVecB:
        mov esp, [tmpStack]
        ret

OutVecA:
        mov [tmpStack], esp
        xor ecx, ecx             ; ecx = 0
        mov ebx, vecA            ; edx = &vec
putVecALoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutVecA       ; to end of loop
        mov [i], ecx

        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecALoop

endOutVecA:
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