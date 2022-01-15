bits 16
org 0x7c00

start:
    mov ax, 0
    mov ds, ax
    jmp 0x0000:outstr
outstr:
    mov si, str
    mov bx, 0
    mov ah, 0x0e
outchr:
    mov al, [si]
    add si, 1
    cmp al, 0
    je fin
    int 0x10
    jmp outchr
fin:
    hlt
    jmp fin

str: db `Hello, World!\r\n\0`

times 510-($-$$) db 0
db 0x55
db 0xaa
