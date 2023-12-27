section .data
    rdrand_supported_msg db "RDRAND instruction supported", 10, 0
    aesni_supported_msg db "AES-NI instruction set supported", 10, 0
    sha_supported_msg db "SHA instruction set supported", 10, 0
    not_supported_msg db "Instruction set not supported", 10, 0

section .text
    global _start

    _start:
        ; Проверка наличия поддержки RDRAND (бит 30 в ECX после вызова CPUID с EAX=1)
        mov eax, 1
        cpuid
        bt ecx, 30  ; Checking bit 30 of ECX
        jc rdrand_supported
        mov eax, 4       ; sys_write
        mov ebx, 1       ; File descriptor: stdout
        mov ecx, not_supported_msg
        mov edx, 31      ; Message length
        int 0x80
        jmp aesni_check

    rdrand_supported:
        mov eax, 4       ; sys_write
        mov ebx, 1       ; File descriptor: stdout
        mov ecx, rdrand_supported_msg
        mov edx, 30      ; Message length
        int 0x80

    aesni_check:
        ; Проверка наличия поддержки AES-NI (бит 25 в ECX после вызова CPUID с EAX=1)
        bt ecx, 25  ; Checking bit 25 of ECX
        jc aesni_supported
        mov eax, 4       ; sys_write
        mov ebx, 1       ; File descriptor: stdout
        mov ecx, not_supported_msg
        mov edx, 31      ; Message length
        int 0x80
        jmp sha_check

    aesni_supported:
        mov eax, 4       ; sys_write
        mov ebx, 1       ; File descriptor: stdout
        mov ecx, aesni_supported_msg
        mov edx, 28      ; Message length
        int 0x80

    sha_check:
        ; Проверка наличия поддержки SHA (бит 29 в ECX после вызова CPUID с EAX=7)
        mov eax, 7
        xor ecx, ecx  ; Clearing ECX
        cpuid
        bt ebx, 29  ; Checking bit 29 of EBX
        jc sha_supported
        mov eax, 4       ; sys_write
        mov ebx, 1       ; File descriptor: stdout
        mov ecx, not_supported_msg
        mov edx, 31      ; Message length
        int 0x80
        jmp exit_program

    sha_supported:
        mov eax, 4       ; sys_write
        mov ebx, 1       ; File descriptor: stdout
        mov ecx, sha_supported_msg
        mov edx, 29      ; Message length
        int 0x80

    exit_program:
        ; Terminate the program
        mov eax, 1       ; sys_exit
        xor ebx, ebx     ; Exit status 0
        int 0x80
