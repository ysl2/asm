assume cs:code
code segment
    ; Use the following code to exit safely.
    mov ax,4C00h
    int 21h
code ends
end
