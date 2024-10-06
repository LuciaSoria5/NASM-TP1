%include "io.inc"

section .data
    N5 db 127
    
    msg_n5_signo_pos db "N5 es positivo", 10, 0xa
    len_msg_n5_signo_pos equ $ - msg_n5_signo_pos
    
    msg_n5_signo_neg db "N5 es negativo", 10, 0xa
    len_msg_n5_signo_neg equ $ - msg_n5_signo_neg

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging

    mov al, [N5]
    test al, al
    js n5_negativo
    
    ; Si N5 es positivo
    mov ecx, msg_n5_signo_pos
    mov edx, len_msg_n5_signo_pos
    call imprimir
    jmp exit

n5_negativo:
    mov ecx, msg_n5_signo_neg
    mov edx, len_msg_n5_signo_neg
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
