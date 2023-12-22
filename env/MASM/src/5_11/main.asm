; Print helloworld.
assume cs:code,ds:data,ss:stack

data segment
    str db 'hello world','$'
data ends

stack segment
    db 10 dup (0)
stack ends

code segment
    start:
        mov ax,data
        mov ds,ax
        lea dx,str
        mov ah,9
        int 21h

        mov ah,4Ch
        int 21h
code ends

end start
