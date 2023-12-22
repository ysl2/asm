; Print helloworld.
assume cs:code, ds:data, ss:stack

data segment
    db 10 dup (0)
data ends

stack segment
    db 10 dup (0)
stack ends

code segment
    start:
        mov ax, 4C00h
        int 21h
code ends

end start
