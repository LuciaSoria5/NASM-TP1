%include "io.inc"

section .data
    N5 dd 1000000021 ; enteros de 32 bits
    N6 dd 2
    
    msg db 'El resultado de N5/N6 es:', 10
    len_msg equ $ - msg
    msg_resto db 10,'El resto es:', 10
    len_msg_resto equ $ - msg_resto
    
    resultado_str db '0000000000'
    resto_str db '0000000000'

section .bss
    resultado resd 1
    resto resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; Realizo la division
    mov eax, [N5]
    mov ebx, [N6]    
    cdq     ; extender el signo de EAX a EDX
    ;xor edx, edx
    idiv ebx    ; para division con signo
    mov [resultado], eax
    mov [resto], edx
    
    call ver_cociente
    call ver_resto

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
    
ver_cociente:    ; Convierto el resultado a string:
    mov eax, [resultado]
    mov edi, resultado_str + 9
    test eax, eax 
    js negativo
    call convertir
    call imprimir_resultado
    ret
    
negativo:
    neg eax
    mov byte[resultado_str], '-' ; añado el simbolo negativo    
    call convertir
    call imprimir_resultado
    ret
    
ver_resto:    ; Convierto el resto a string:
    mov eax, [resto]
    mov edi, resto_str + 9
    test eax, eax 
    js negativo_resto
    call convertir
    call imprimir_resto
    ret
    
negativo_resto:
    neg eax
    mov byte[resto_str], '-' ; añado el simbolo negativo    
    call convertir
    call imprimir_resto
    ret       
    
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
    
imprimir_resultado:
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
    mov edx, 10
    int 0x80
    ret

imprimir_resto:    
    ; imprimir mensaje del resto:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_resto
    mov edx, len_msg_resto 
    int 0x80
    ; imprimir resto
    mov eax, 4
    mov ebx, 1
    mov ecx, resto_str
    mov edx, 10
    int 0x80
    ret  