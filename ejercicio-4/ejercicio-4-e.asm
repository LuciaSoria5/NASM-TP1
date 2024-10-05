%include "io.inc"

section .data
    N7 db 0x80
    N8 db 0x80

    msg_n7_n8_carry db "N7 + N8 produce acarreo", 10, 0xa
    len_msg_n7_n8_carry equ $ - msg_n7_n8_carry

    msg_n7_n8_no_carry db "N7 + N8 no produce acarreo", 10, 0xa
    len_msg_n7_n8_no_carry equ $ - msg_n7_n8_no_carry

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging

    mov al, [N7]
    mov bl, [N8]
    add al, bl
    jc n7_n8_carry

    ; Si N7 + N8 no produce acarreo
    mov ecx, msg_n7_n8_no_carry
    mov edx, len_msg_n7_n8_no_carry
    call imprimir
    jmp exit

n7_n8_carry:
    mov ecx, msg_n7_n8_carry
    mov edx, len_msg_n7_n8_carry
    call imprimir

exit:
    mov eax, 1        ; syscall: exit
    xor ebx, ebx      ; código de salida 0
    int 0x80

; Parametros:
; ECX = direccion del String
; EDX = longitud del String
imprimir:
    mov eax, 4  ; numero de syscall
    mov ebx, 1  ; stdout
    int 0x80    ; llamada al sistema
    ret
