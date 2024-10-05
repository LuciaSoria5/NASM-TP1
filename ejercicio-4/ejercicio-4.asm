%include "io.inc"

section .data
    ; Variables
    N1 db 10
    N2 db 5
    N3 db 20
    N4 db 20
    N5 db 127
    N6 db 1
    N7 db 0x80
    N8 db 0x80

    ; Mensajes
    msg_n1_mayor db "N1 es mayor que N2", 10, 0xa
    len_msg_n1_mayor equ $ - msg_n1_mayor
    
    msg_n3_igual db "N3 - N4 es cero", 10, 0xa
    len_msg_n3_igual equ $ - msg_n3_igual
    
    msg_n5_n6_overflow db "N5 + N6 produce desbordamiento", 10, 0xa
    len_msg_n5_n6_overflow equ $ - msg_n5_n6_overflow
    
    msg_n5_n6_no_overflow db "N5 + N6 no produce desbordamiento", 10, 0xa
    len_msg_n5_n6_no_overflow equ $ - msg_n5_n6_no_overflow
    
    msg_n5_signo_pos db "N5 es positivo", 10, 0xa
    len_msg_n5_signo_pos equ $ - msg_n5_signo_pos
    
    msg_n5_signo_neg db "N5 es negativo", 10, 0xa
    len_msg_n5_signo_neg equ $ - msg_n5_signo_neg
    
    msg_n7_n8_carry db "N7 + N8 produce acarreo", 10, 0xa
    len_msg_n7_n8_carry equ $ - msg_n7_n8_carry
    
    msg_n7_n8_no_carry db "N7 + N8 no produce acarreo", 10, 0xa
    len_msg_n7_n8_no_carry equ $ - msg_n7_n8_no_carry
    
    msg_paridad_par db "N5 + N6 tiene paridad par", 10, 0xa
    len_msg_paridad_par equ $ - msg_paridad_par
    
    msg_paridad_impar db "N5 + N6 no tiene paridad par", 10, 0xa
    len_msg_paridad_impar equ $ - msg_paridad_impar

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging

comparacion_n1_n2:
    ; a. Si N1 es mayor que N2
    mov al, [N1]
    mov bl, [N2]
    cmp al, bl
    jg n1_mayor
    
n1_mayor:
    mov ecx, msg_n1_mayor
    mov edx, len_msg_n1_mayor
    call imprimir
    jmp comparacion_n3_n4

comparacion_n3_n4:
    ; b. Si N3 - N4 es cero
    mov al, [N3]
    mov bl, [N4]
    sub al, bl
    jz n3_igual

comparacion_des_n5_n6:
    ; c. Si N5 + N6 produce desbordamiento
    mov al, [N5]
    mov bl, [N6]
    add al, bl
    jo n5_n6_overflow
    jno n5_n6_no_overflow

signo_n5:
    ; d. Si N5 es negativo o positivo
    mov al, [N5]
    test al, al
    js n5_negativo
    jmp n5_positivo

comparacion_n7_n8:
    ; e. Si N7 + N8 produce acarreo
    mov al, [N7]
    mov bl, [N8]
    add al, bl
    jc n7_n8_carry
    
    jmp n7_n8_no_carry

comparacion_suma_n5_n6:
    ; f. Si el resultado de N5 + N6 tiene paridad par
    mov al, [N5]
    mov bl, [N6]
    add al, bl
    
    test al, 1
    jnz paridad_impar
    
    jmp paridad_par

exit:
    mov eax, 1        ; syscall: exit
    xor ebx, ebx      ; código de salida 0
    int 0x80

; Imprimir mensajes



n3_igual:
    mov ecx, msg_n3_igual
    mov edx, len_msg_n3_igual
    call imprimir
    jmp comparacion_des_n5_n6

n5_n6_overflow:
    mov ecx, msg_n5_n6_overflow
    mov edx, len_msg_n5_n6_overflow
    call imprimir
    jmp signo_n5
    
n5_n6_no_overflow:
    mov ecx, msg_n5_n6_no_overflow
    mov edx, len_msg_n5_n6_no_overflow
    call imprimir
    jmp signo_n5

n5_positivo:
    mov ecx, msg_n5_signo_pos
    mov edx, len_msg_n5_signo_pos
    call imprimir
    jmp comparacion_n7_n8

n5_negativo:
    mov ecx, msg_n5_signo_neg
    mov edx, len_msg_n5_signo_neg
    call imprimir
    jmp comparacion_n7_n8

n7_n8_carry:
    mov ecx, msg_n7_n8_carry
    mov edx, len_msg_n7_n8_carry
    call imprimir
    jmp comparacion_suma_n5_n6
    
n7_n8_no_carry:
    mov ecx, msg_n7_n8_no_carry
    mov edx, len_msg_n7_n8_no_carry
    call imprimir
    jmp comparacion_suma_n5_n6

paridad_par:
    mov ecx, msg_paridad_par
    mov edx, len_msg_paridad_par
    call imprimir
    jmp exit
    
paridad_impar:
    mov ecx, msg_paridad_impar
    mov edx, len_msg_paridad_impar
    call imprimir
    jmp exit
    
; Parametros:
; ECX = direccion del String
; EDX = longitud del String
imprimir:
    mov eax, 4  ; numero de syscall
    mov ebx, 1  ; stdout
    int 0x80    ; llamada al sistema
    ret
