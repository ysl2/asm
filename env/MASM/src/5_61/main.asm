; Number string to real number.
assume cs:code, ds:data, ss:stack

data segment
    str db '00002333', '$'
    res db '0000', '$'
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
        mov sp, 100

        mov bx, 0
        mov cx, 8
        mov ax, 0
        for:
            ; ax multiply 10
            mov dx, ax
            shl ax, 1
            shl ax, 1
            shl ax, 1
            shl dx, 1
            add ax, dx

            add al, str[bx]
            adc ah, 0
            sub ax, 30h

            inc bx
        loop for

        ; ax=3039
        mov si, 4
        mov cx, 4
        for1:
            mov dx, ax
            and dx, 0Fh
            add dx, 30h
            cmp dx, 3Ah
            jb goto
                add dx, 7h
            ; 求出3039的ASCII码，push
            goto:
                dec si
                mov res[si], dl
                shr ax, 1
                shr ax, 1
                shr ax, 1
                shr ax, 1
        loop for1

        ; mov dx,offset res
        lea dx, res
        mov ah, 9
        int 21h

        mov ah, 4Ch
        int 21h
code ends
end start



comment *
string str="00000100"
int res=0
for(int i=0;i<8;i++)res=res*10+str[i]-'0';
return res


if (res=0)ans++;

cmp ax,bx
jne s1
inc dx
s1:


if (x==1)res=10
else res =20


mov res,10
cmp x,1
je s1
add res,10
s1:


*comment
