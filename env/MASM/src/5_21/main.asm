; Sum array.
assume cs:code, ds:data, ss:stack

data segment
    arr db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30
data ends

stack segment
    db 100 dup (0)
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        mov ax, 0
        mov bx, 0
        mov cx, 30
        for:
            add al, arr[bx]
            adc ah, 0
            inc bx
        loop for

        ; mov dx, ax
        ; mov ah, 9
        ; int 21

        mov ax, 4C00h
        int 21h
code ends
end start
