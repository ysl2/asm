; Reverse array.
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
        mov si, 0
        mov di, 9
        mov cx, 10
        for:
            mov al, arr[si]
            mov res[di], al
            inc si
            dec di
        loop for

        ; mov dx, ax
        ; mov ah, 9
        ; int 21

        mov ax, 4C00h
        int 21h
code ends
end start
