; Bubble Sort
assume cs:code, ds:data, ss:stack

data segment
    ; arr db 0A2h, 24h, 07h, 3Ah, 1Bh, 0F1h, 3Bh, 25h, 81h
    arr db 242o, 44o, 7o, 72o, 33o, 361o, 73o, 45o, 201o
data ends

stack segment
    db 10 dup (0)
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        mov bx, 0
        mov cx, 8
        for:
            mov si, 8
            mov dx, cx
            mov cx, 8
            sub cx, bx
            for1:
                mov al, arr[si - 1]
                mov ah, arr[si]
                cmp ah, al
                ; if ah >= al, jump to `all`
                jnb all
                    xchg al, ah
                    mov arr[si - 1], al
                    mov arr[si], ah
                all:
                    dec si
            loop for1
            mov cx, dx
            add bx, 1
        loop for

    mov ah, 4Ch
    int 21h
code ends
end start
