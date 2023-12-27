section .data
    format db "Number of CPU cores: %d", 10, 0

section .text
    extern printf
    global main
main:
    mov eax, 1
    cpuid
    
    ; Количество ядер хранится в EBX[16:23]
    shr ebx, 16
    and ebx, 0x00FF
    
    ; Подготовка параметров для вызова printf
    push rdi ; Сохраняем rdi, так как он используется printf
    mov edi, format
    mov esi, ebx
    xor eax, eax ; Используем регистр eax для передачи аргументов в printf
    
    ; Вызываем printf
    call printf
    add rsp, 8 ; Очистка стека от аргументов
    
    ; Восстанавливаем сохраненное значение регистра rdi
    pop rdi
    
    ; Возврат из программы
    mov eax, 0
    ret
