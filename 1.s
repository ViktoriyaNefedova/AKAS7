section .data
    format db "Number of CPU cores: %d", 10, 0

section .text
    extern printf
    global main
main:
    mov eax, 1
    cpuid
    
    
    shr ebx, 16
    and ebx, 0x00FF
    
    ; Подготовка параметров для вызова printf
    push rdi 
    mov edi, format
    mov esi, ebx
    xor eax, eax 
    
    ; Вызываем printf
    call printf
    add rsp, 8 
    
    ; Восстанавливаем сохраненное значение регистра rdi
    pop rdi
    
    ; Возврат из программы
    mov eax, 0
    ret

