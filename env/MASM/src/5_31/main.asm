; Reverse array by stack.
assume cs:code, ds:data, ss:stack

data segment
    arr dw 1, 2, 3, 4, 5, 6, 7, 8
data ends

stack segment
    db 16 dup (0)
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        mov ax, stack
        mov ss, ax
        mov sp, 16

        mov bx, 0
        mov cx, 8
        for:
            push arr[bx]
            add bx, 2
        loop for

        mov bx, 0
        mov cx, 8
        for1:
            pop arr[bx]
            add bx, 2
        loop for1

        mov ax, 4C00h
        int 21h
code ends
end start
