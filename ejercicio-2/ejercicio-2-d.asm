%include "io.inc"

section .data
    N3 dw 6   ; 16 bits con signo
    N4 dw 3
    
    msg db 'El resultado de N3/N4 es:', 10
    len_msg equ $ - msg
    msg_resto db 10,'El resto es:', 10
    len_msg_resto equ $ - msg_resto
    
    resultado_str db '00000'
    resto_str db '00000'

section .bss
    resultado resw 1
    resto resw 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    
    ; Realizo la division
    mov ax, [N3]
    mov bx, [N4]    
    xor dx, dx
    div bx
    mov [resultado], ax
    mov [resto], dx
    
ver_cociente:    ; Convierto el resultado a string:
    movsx eax, word[resultado]
    mov edi, resultado_str + 4 
    test eax, eax 
    js negativo
    call convertir
    call imprimir
    
negativo:
    neg eax
    mov byte[resultado_str], '-' ; añado el simbolo negativo    
    call convertir
    call imprimir    
    
ver_resto:    ; Convierto el resto a string:
    movsx eax, word[resto]
    mov edi, resto_str + 4
    call convertir
    call imprimir_resto
    
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
    mov edx, 5
    int 0x80
    jmp ver_resto

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
    mov edx, 5
    int 0x80
    jmp exit    