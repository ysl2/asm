comment *
Max value in array

c++
数组当中的最大值
int res = 0
for(int i = 0; i < str.size(); i++)
    if(res < s[i])
        res = s[i];
return res

求最小值
int res = FF
for(int i = 0; i < str.size(); i++)
    if(res > s[i])
        res = s[i];
return res

for(int i = 0; i < str.size(); i++)
    str[i]转大写
* comment

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

        mov bx,0
        mov cx,11
        mov ah,0FFh
	s:
		mov al,[bx]
		cmp ah,al
		jna s1
		mov ah,al
	s1:
		mov [bx],al
		inc bx
		loop s

		; mov dx,offset str
		lea dx,str
		mov ah,9
		int 21h

		mov ah,4Ch
		int 21h
code ends
end start
