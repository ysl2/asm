; Fibonacci
assume cs:code, ds:data, ss:stack
data segment
    arr dw 1, 1, 100 dup (0)
data ends

stack segment
    db 100 dup (0)
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        mov ax, stack
        mov ss, ax

        mov bx, 4
        mov cx, 30
        for:
            mov dx, 0
            add dx, arr[bx - 2]
            add dx, arr[bx - 4]
            mov arr[bx], dx
            add bx, 2
        loop for

        mov ax, 4C00h
        int 21h
code ends
end start
