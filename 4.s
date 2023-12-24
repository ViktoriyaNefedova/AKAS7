section .data 
    sse_msg db "SSE is supported", 0xA, 0 
    avx_msg db "AVX is supported", 0xA, 0 

section .bss 
    buffer resb 128 

section .text 
    global _start 

_start: 
    ; Проверка поддержки SSE 
    mov eax, 1 
    cpuid 
    test edx, 1 << 25 ; Проверяем SSE бит (EDX[25]) 
    jz .check_avx ; Если SSE не поддерживается, переходим к AVX 
    mov ecx, sse_msg 
    call print_message ; Вывод сообщения о поддержке SSE 

.check_avx: 
    ; Проверка поддержки AVX 
    mov eax, 1
    cpuid
    test ecx, 1 << 28 ; Проверяем AVX бит (ECX[28]) 
    jz .exit ; Если AVX не поддерживается, выходим 
    mov ecx, avx_msg 
    call print_message ; Вывод сообщения о поддержке AVX 

.exit: 
    mov eax, 60 ; Вызов системного вызова exit 
    xor edi, edi ; Код выхода 0 
    syscall 

; Подпрограмма для вывода сообщений 
print_message: 
    mov eax, 1 ; System call number (sys_write) 
    mov edi, 1 ; File descriptor 1 is stdout 
    ; Начнём поиск длины с нуля и увеличиваем rdx пока не встретим 
    ; нуль-терминатор. 
    mov rsi, rcx 
    xor rdx, rdx ; Zero rdx before we start counting the 
                 ; message length 
.find_length: 
    cmp byte [rcx + rdx], 0 
    je .done_counting 
    inc rdx 
    jmp .find_length 
.done_counting:
    syscall ; Write the message to stdout 
    ret
