%include "io.inc"

section .data
    N3 db 20
    N4 db 20
    
    msg_n3_n4_iguales db "N3 - N4 es cero", 10, 0xa
    len_msg_n3_n4_iguales equ $ - msg_n3_n4_iguales
    
    msg_n3_n4_no_iguales db "N3 - N4 no es cero", 10, 0xa
    len_msg_n3_n4_no_iguales equ $ - msg_n3_n4_no_iguales

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging

    mov al, [N3]
    mov bl, [N4]
    sub al, bl
    jz n3_n4_iguales
    
    ; Si n3 y n4 no son iguales
    mov ecx, msg_n3_n4_no_iguales
    mov edx, len_msg_n3_n4_no_iguales
    call imprimir
    jmp exit
    
n3_n4_iguales:
    mov ecx, msg_n3_n4_iguales
    mov edx, len_msg_n3_n4_iguales
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
