%include "io.inc"

section .data
    N3 dw 20    ; 16 bits con signo
    N4 dw 100
    
    msg db 'El resultado de N3 - N4 es '
    len_msg equ $ - msg
    resultado_str db '00', 0

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
    ;mov byte[resultado_str], '-' ; añado el simbolo negativo
    call imprimir
    
convertir:   
    mov ecx, 10
    xor edx, edx
    loopConvertir:
        xor edx, edx    ; limpiar el contador
        div ecx         ; eax/10
        add dl, '0'     ; convertir a ascii
        mov [edi], dl   ; guardar el digito
        dec edi         ; mover el puntero hacia atras
        inc edx         ; aumentar contador de digitos
        test eax, eax   ; si el cociente no es 0 repito
        jnz loopConvertir
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
    mov edx, 8
    int 0x80
    jmp exit    