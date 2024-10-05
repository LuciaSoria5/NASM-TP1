%include "io.inc"

section .data
    num1 dq 0x1111111122222222, 0x3333333344444444
    num2 dq 0x1111111122222222, 0x3333333344444444
    resultado dq 0x0000000000000000, 0x0000000000000000
    
section .bss
    resultado_str resb 33
        
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ; Muevo los valores a registros de 8 bits
    mov eax, dword[num1]
    mov ebx, dword[num1 + 4]
    mov ecx, dword[num1 + 8]
    mov edx, dword[num1 + 12]
    
    ; Sumo los valorescon el otro número
    add eax, dword[num2]
    add ebx, dword[num2 + 4]
    add ecx, dword[num2 + 8]
    add edx, dword[num2 + 12]
    
    ; Guardo el resultado en la variable
    mov dword[resultado], eax
    mov dword[resultado + 4], ebx
    mov dword[resultado + 8], ecx
    mov dword[resultado + 12], edx
    
    ; Imprimir resultado
    mov eax, [resultado]
    mov edi, resultado_str + 16
    call convertir
    mov eax, [resultado + 4]
    mov edi, resultado_str + 8
    call convertir
    call imprimir
    
    mov eax, [resultado + 8]
    mov edi, resultado_str + 16
    call convertir
    mov eax, [resultado + 12]
    mov edi, resultado_str + 8
    call convertir
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
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, 16
    int 0x80
    ret