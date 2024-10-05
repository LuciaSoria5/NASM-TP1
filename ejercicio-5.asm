%include "io.inc"

section .data
    T db "Hola, mundo!", 0        ; cadena y un carácter nulo
    buffer db "0", 0              ; buffer para la longitud (puede almacenar hasta 2 dígitos)

section .text
global CMAIN
CMAIN:
    mov ecx, 0                     ; inicializa el contador en 0
    mov esi, T                     ; carga la dirección de la cadena en esi

LOOP:
    cmp byte [esi], 0              ; compara el byte apuntado por esi con 0
    je FIN                         ; si es 0, salta al final del bucle
    inc ecx                        ; incrementa el contador
    inc esi                        ; incrementa el puntero
    jmp LOOP                       ; salta al inicio del bucle

FIN:
    ; Convertir la longitud en ASCII (2 dígitos, máx 99)
    mov eax, ecx                   ; mover la longitud a eax
    mov edi, buffer                ; dirección del buffer para guardar los caracteres
    mov ebx, 10                    ; divisor para extraer los dígitos decimales

    ; Calcular el primer dígito (decenas)
    xor edx, edx                   ; limpiar edx antes de la división
    div ebx                        ; dividir eax (longitud) por 10
    add al, '0'                    ; convertir el cociente a ASCII
    mov [edi], al                  ; almacenar el carácter en el buffer

    ; Calcular el segundo dígito (unidades)
    mov eax, edx                   ; el resto es el segundo dígito
    add al, '0'                    ; convertir el dígito a ASCII
    mov [edi+1], al                ; almacenar el segundo carácter

    ; Mostrar el resultado
    mov eax, 4                     ; syscall para write
    mov ebx, 1                     ; file descriptor (stdout)
    mov ecx, buffer                ; cargar la dirección del buffer
    mov edx, 2                     ; longitud de la cadena a imprimir (2 dígitos)
    int 0x80                       ; llamada al sistema para mostrar el resultado
