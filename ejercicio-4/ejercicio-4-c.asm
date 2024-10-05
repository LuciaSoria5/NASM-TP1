%include "io.inc"

section .data
    N5 db 127
    N6 db 1

    msg_n5_n6_overflow db "N5 + N6 produce desbordamiento", 10, 0xa
    len_msg_n5_n6_overflow equ $ - msg_n5_n6_overflow
    
    msg_n5_n6_no_overflow db "N5 + N6 no produce desbordamiento", 10, 0xa
    len_msg_n5_n6_no_overflow equ $ - msg_n5_n6_no_overflow

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging

    mov al, [N5]
    mov bl, [N6]
    add al, bl
    jo n5_n6_overflow
   
    ; Si N5 + N6 no produce desbordamiento
    mov ecx, msg_n5_n6_no_overflow
    mov edx, len_msg_n5_n6_no_overflow
    call imprimir
    jmp exit
    
n5_n6_overflow:
    mov ecx, msg_n5_n6_overflow
    mov edx, len_msg_n5_n6_overflow
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