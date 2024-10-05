%include "io.inc"

section .data
    N1 db 10
    N2 db 5

    msg_n1_mayor db "N1 es mayor que N2", 10, 0xa
    len_msg_n1_mayor equ $ - msg_n1_mayor
    
    msg_n1_menor db "N1 no es mayor que N2", 10, 0xa
    len_msg_n1_menor equ $ - msg_n1_menor

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging

    mov al, [N1]
    mov bl, [N2]
    cmp al, bl
    jg n1_mayor
    
    ; SI N1 no es mayor que N2:
    mov ecx, msg_n1_menor
    mov edx, len_msg_n1_menor
    call imprimir
    jmp exit
    
n1_mayor:
    mov ecx, msg_n1_mayor
    mov edx, len_msg_n1_mayor
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
