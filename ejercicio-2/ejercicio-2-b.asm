%include "io.inc"

section .data
    N3 dw 2    ; 16 bits con signo
    N4 dw 65537
    
    msg db 'El resultado de N3 - N4 es ', 0
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
    movzx eax, word[resultado]
    mov edi, resultado_str
;    call convertir
        
    test eax, eax 
    js negativo
    call convertir
    
    ; Imprimo el resultado
    call imprimir 
    
exit:
    mov eax, 1        ; syscall: exit
    xor ebx, ebx      ; código de salida 0
    int 0x80
    
negativo:
    neg eax
   ; call convertir
    mov byte[resultado_str], '-' ; añado el simbolo negativo
    
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
    mov edx, 1
    int 0x80
    ret    