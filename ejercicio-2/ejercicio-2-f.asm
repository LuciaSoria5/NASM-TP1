%include "io.inc"

section .data
    N7 dq 0x1111111122222222 ; enteros sin signo de 64 bits
    N8 dq 0x4444444433333333

    msg db 'El resultado de N7 + N8 (en hexadecimal) es: ', 10
    len_msg equ $ - msg
    resultado dq 0x0000000000000000

section .bss
    resultado_str resd 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp

    ; Realizo la suma en registros de propósito general
    mov eax, dword[N7]
    mov ebx, dword[N7 + 4]
    
    add eax, dword[N8]
    add ebx, dword[N8 + 4]
    
    mov dword[resultado], eax
    mov dword[resultado + 4], ebx
    
    ; Convierto el resultado a string:
    mov eax, [resultado]
    mov edi, resultado_str + 16
    call convertir
    mov eax, [resultado + 4]
    mov edi, resultado_str + 8
    call convertir
    
    ; Imprimo el resultado
    call imprimir 
    
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
    
convertir:
    mov ecx, 8
    xor edx, edx
    loopConvertir:
        dec edi
        mov ebx, eax
        and ebx, 0xF
        cmp ebx, 9
        jg letra
        add ebx, '0'
        jmp almacenar
        
    letra:
        add ebx, 'A' - 10
    almacenar:
        mov [edi], bl
        shr eax, 4
        loop loopConvertir
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