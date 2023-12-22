; 2D string array from lower to upper.
comment *
         bx
    for(int i=0;循环4次;i+=16){
                si
        for(int j=0;循环五次;j++){
            arr[j+i]转大写
        }
    }


    for(int i=0;i<;i+=16)
        arr[i+5]转大写

    for(int i=0;i<arr.size();i++){
        for(int j=0;j<arr[0].size();j++){
                cout <<arr[2][5]<<" ";
}cout<<endl;
}
*comment

assume cs:code, ds:data, ss:stack

data segment
    str db 'aaaaabbbbbccccc '
        db 'aaaaabbbbbccccc '
        db 'aaaaabbbbbccccc '
        db 'aaaaabbbbbccccc ', '$'
data ends

stack segment
    db 10 dup (0)
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        mov bx, 0
        mov cx, 4
        for:
            mov dx, cx
            mov si, 0
            mov cx, 5
            for1:
                mov al, str[bx + si]
                and al, 11011111B
                mov str[bx + si], al
                inc si
            loop for1
            mov cx, dx
            add bx, 16
        loop for

        lea dx, str
        mov ah, 9
        int 21h

        mov ah, 4Ch
        int 21h
code ends
end start
