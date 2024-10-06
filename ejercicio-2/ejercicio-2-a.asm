%include "io.inc"

section .data
    N1 db 12    ; 8 bits sin signo
    N2 db 12

    msg db 'El resultado de N1 + N2 es: ', 10
    len_msg equ $ - msg
    resultado_str db '000', 0

section .bss
    resultado resb 1

section .text
    global CMAIN
CMAIN:
    mov ebp, esp

    ; Realizo la suma
    mov al, [N1]
    mov bl, [N2]    
    add al, bl
    mov [resultado], al
    
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
    mov edx, 3
    int 0x80
    ret    