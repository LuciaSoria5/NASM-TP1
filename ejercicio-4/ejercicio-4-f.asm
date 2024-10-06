%include "io.inc"

section .data
    N5 db 127
    N6 db 1
    
    msg_paridad_par db "N5 + N6 tiene paridad par", 10, 0xa
    len_msg_paridad_par equ $ - msg_paridad_par
    
    msg_paridad_impar db "N5 + N6 no tiene paridad par", 10, 0xa
    len_msg_paridad_impar equ $ - msg_paridad_impar

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging

    mov al, [N5]
    mov bl, [N6]
    add al, bl
    jp paridad_par

    ; Si no tiene paridad par
    mov ecx, msg_paridad_impar
    mov edx, len_msg_paridad_impar
    call imprimir
    jmp exit
    
paridad_par:
    mov ecx, msg_paridad_par
    mov edx, len_msg_paridad_par
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
