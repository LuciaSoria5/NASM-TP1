%include "io.inc"

section .data
    N1 db 2    ; 8 bits sin signo
    N2 db 100
    
    msg db 'El resultado de N1 * N2 es: ', 10
    len_msg equ $ - msg
    resultado_str db '000', 0

section .bss
    resultado resb 1

section .text
    global CMAIN
    
CMAIN:
    mov ebp, esp

    ; Realizo la multiplicacion
    mov al, [N1]
    mov bl, [N2]
    mul bl
    mov [resultado], ax
    
    ; Convierto el resultado a string:
    movzx eax, byte[resultado]
    mov edi, resultado_str + 2
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
    mov edx, 3
    int 0x80
    ret    