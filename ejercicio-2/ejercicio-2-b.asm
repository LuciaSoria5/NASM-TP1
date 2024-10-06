%include "io.inc"

section .data
    N3 dw 32   ; 16 bits con signo
    N4 dw 100
    
    msg db 'El resultado de N3 - N4 es:', 10
    len_msg equ $ - msg
    resultado_str db '00000', 0

section .bss
    resultado resw 1

section .text
global CMAIN

CMAIN:
    mov ebp, esp
    
    ; Realizo la resta
    mov ax, [N3]
    mov bx, [N4]    
    sub ax, bx
    mov [resultado], ax
    
    ; Convierto el resultado a string:
    movsx eax, word[resultado]
    mov edi, resultado_str + 5 
                
    test eax, eax 
    js negativo

    call convertir
    call imprimir 
    
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
    
negativo:
    neg eax
    mov byte[resultado_str], '-' ; añado el simbolo negativo    
    call convertir
    call imprimir
    
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
    mov edx, 6
    int 0x80
    jmp exit    