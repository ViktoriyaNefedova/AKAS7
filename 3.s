section .data
    supported_msg db "Supported:", 10, 0
    not_supported_msg db "Not supported:", 10, 0

section .text
    global _start

    _start:
        ; Check for BMI1 support (bit 3 in ECX after calling CPUID with EAX=7)
        mov eax, 7
        xor ecx, ecx   ; Clear ECX
        cpuid
        bt ecx, 3      ; Check bit 3 of ECX
        jc bmi1_supported
        mov eax, 4      ; sys_write
        mov ebx, 1      ; File descriptor: stdout
        mov ecx, not_supported_msg
        mov edx, 16     ; Message length
        int 0x80
        jmp bmi2_check

    bmi1_supported:
        mov eax, 4      ; sys_write
        mov ebx, 1      ; File descriptor: stdout
        mov ecx, supported_msg
        mov edx, 11     ; Message length
        int 0x80

    bmi2_check:
        ; Check for BMI2 support (bit 8 in ECX after calling CPUID with EAX=7)
        bt ecx, 8      ; Check bit 8 of ECX
        jc bmi2_supported
        mov eax, 4      ; sys_write
        mov ebx, 1      ; File descriptor: stdout
        mov ecx, not_supported_msg
        mov edx, 16     ; Message length
        int 0x80
        jmp adx_check

    bmi2_supported:
        mov eax, 4      ; sys_write
        mov ebx, 1      ; File descriptor: stdout
        mov ecx, supported_msg
        mov edx, 11     ; Message length
        int 0x80

    adx_check:
        ; Check for ADX support (bit 19 in ECX after calling CPUID with EAX=7)
        bt ecx, 19     ; Check bit 19 of ECX
        jc adx_supported
        mov eax, 4     ; sys_write
        mov ebx, 1     ; File descriptor: stdout
        mov ecx, not_supported_msg
        mov edx, 16    ; Message length
        int 0x80
        jmp exit_program

    adx_supported:
        mov eax, 4     ; sys_write
        mov ebx, 1     ; File descriptor: stdout
        mov ecx, supported_msg
        mov edx, 11    ; Message length
        int 0x80

    exit_program:
        ; Exit the program
        mov eax, 1     ; sys_exit
        xor ebx, ebx   ; Exit status 0
        int 0x80
