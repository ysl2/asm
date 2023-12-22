; Copy array.
assume cs:code, ds:data, ss:stack

data segment
    arr db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    res db 10 dup (0)
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
        mov cx, 10
        for:
            mov al, arr[bx]
            mov res[bx], al
            inc bx
        loop for

        ; mov dx, ax
        ; mov ah, 9
        ; int 21

        mov ax, 4c00h
        int 21
code ends
end start
