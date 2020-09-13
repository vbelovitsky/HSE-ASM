format PE console
entry start
include 'win32a.inc'

section '.data' data readable writable

        helloStr db 'Hello world!',10,0
        nameStr db 'My name is Vlad.',0

        NULL = 0

section '.code' code readable executable

        start:
                push helloStr
                call [printf]

                push nameStr
                call [printf]

                call [getch]

                push NULL
                call [ExitProcess]

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch'