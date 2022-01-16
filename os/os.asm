[org 0x7c00]

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 2
; dl is set by bios to boot disk
call disk_load

mov dx, [0x9000]
call print_hex

call print_nl

mov dx, [0x9000 + 512]
call print_hex

jmp $

; dh = sector count, dl - drive index
; loads into es:bx
disk_load:
    pusha
    push dx
    mov ah, 0x02 ; read
    mov al, dh
    mov cl, 0x02 ; 0x01 is the boot sector
    mov ch, 0x00 ; cylinder
    mov dh, 0x00 ; head
    int 0x13
    jc disk_load_disk_error
    pop dx
    cmp al, dh ; al is sectors read
    jne disk_load_sectors_error
    popa
    ret

disk_load_disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah ; ah is error code
    call print_hex
    jmp disk_load_loop

disk_load_sectors_error:
    mov bx, SECTORS_ERROR
    call print

disk_load_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0

; bx = base string index
print:
    pusha
    mov ah, 0x0e

print_start:
    mov al, [bx]
    cmp al, 0
    je print_done
    int 0x10
    add bx, 1
    jmp print_start

print_done:
    popa
    ret

print_nl:
    pusha
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10
    popa
    ret

; dx = data (e.g. 0x1234)
print_hex:
    pusha
    mov cx, 0

print_hex_loop:
    mov ax, dx
    and ax, 0x000f
    add al, 0x30 ; 0x30-0x39 are ascii digits
    cmp al, 0x39
    jle print_hex_step2
    add al, 7 ; jump to ascii 'A'-'F'

print_hex_step2:
    mov bx, HEX_OUT + 5
    sub bx, cx
    mov [bx], al
    ror dx, 4
    add cx, 1
    cmp cx, 4
    jl print_hex_loop

print_hex_done:
    mov bx, HEX_OUT
    call print
    popa
    ret

HEX_OUT:db '0x0000',0

times 510 - ($-$$) db 0
dw 0xaa55

dw 0xdada
times 255 dw 0x1111
dw 0xface
times 255 dw 0x2222
