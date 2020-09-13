format PE console

entry Start
include 'win32a.inc'

section '.code' code readable executable
        Start:
                ;invoke scanf, spaceStr, exePath
                ;invoke printf, exePath,

                invoke CreateProcessA, exePath, 0,0,0,0,CREATE_NEW_CONSOLE,0,0,StartupInfo,ProcessInfo
                call [ExitProcess]

section '.data' data readable writeable

        exePath  db 'C:\Windows\System32\notepad.exe',0

        ;exePath db ?
        ;spaceStr dp '%s', 0

        NULL = 0

        StartupInfo STARTUPINFO

        ProcessInfo PROCESS_INFORMATION

section '.idata' import data readable writeable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               CreateProcessA, 'CreateProcessA'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'