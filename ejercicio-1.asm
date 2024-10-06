%include "io.inc"

section .data
N1 db 48
N2 db 48
N3 dw 148
N4 dw 148
N5 dd 10987654
N6 dd 10987654
N7 dq 123456
N8 dq 123456
F1 dd 1.234567
T db 'Cadena de caracteres',0

formato db 'Todo cargado!',0xa
LenFormato equ $ - formato

section .text
global CMAIN

CMAIN:
    push dword 48
    push formato
    call imprimir
    
    add esp, 8
    mov eax, 1
    xor ebx, ebx
    int 0x80
    
imprimir:
    mov eax, 4
    mov ebx, 1
    mov ecx, formato
    mov edx, LenFormato
    int 0x80
    
    mov eax, 1
    mov ebx, 0
    int 0x80
    
    ret
    
    
    