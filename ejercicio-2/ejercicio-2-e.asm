%include "io.inc"

section .data
    N5 dd 100 ; enteros de 32 bits
    N6 dd 200

    msg db 'El resultado de N5 + N6 es: ', 10
    len_msg equ $ - msg
    resultado_str db '0000000000', 0

section .bss
    resultado resd 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp

    ; Realizo la suma
    mov eax, [N5]
    mov ebx, [N6]    
    add eax, ebx
    mov [resultado], eax
    
    ; Convierto el resultado a string:
    mov eax, [resultado]
    mov edi, resultado_str + 10
    call convertir
    
    ; Imprimo el resultado
    call imprimir 
    
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
    
convertir:   
    mov ecx, 10
    xor edx, edx
    loop_convertir:
        xor edx, edx    
        div ecx         
        add dl, '0'    
        mov [edi], dl  
        dec edi         
        inc edx         
        test eax, eax   
        jnz loop_convertir
    ret
    
imprimir:
    ; imprimir mensaje:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len_msg 
    int 0x80
    ; imprimir resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado_str
    mov edx, 11
    int 0x80
    ret    
