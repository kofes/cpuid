    global    main
    extern printf

    section   .text
main:
    enter 0,0
    call cpuid_2
    leave
    ret

cpuid_2:
    enter 32, 0

    mov rax, 2
    cpuid
    mov dword [rbp-4], eax
    mov dword [rbp-8], ebx
    mov dword [rbp-12], ecx
    mov dword [rbp-16], edx
    mov byte [rbp-17], al

cpuid_2_loop:
    mov al, 16
    mov byte [rbp-18], al
cpuid_2_print_per_byte:
    xor rax, rax
    mov al, byte [rbp-18]
    cmp al, 0
    je cpuid_2_loop_continue

    xor rsi, rsi
    mov rsi, rbp
    sub rsi, rax

    dec al
    mov byte [rbp-18], al

    xor rdi, rdi
    mov dil, byte [rsi]
    jmp cpuid_switch_start
cpuid_switch_end:
    mov rdi, new_line_fmt
    call printf

    jmp cpuid_2_print_per_byte
cpuid_2_loop_continue:
    mov rdi, raw_description_fmt
    call printf

    mov rdi, hex_fmt
    xor rsi, rsi
    mov esi, dword [rbp-4]
    call printf

    mov rdi, hex_fmt
    xor rsi, rsi
    mov esi, dword [rbp-8]
    call printf

    mov rdi, hex_fmt
    xor rsi, rsi
    mov esi, dword [rbp-12]
    call printf

    mov rdi, hex_fmt
    xor rsi, rsi
    mov esi, dword [rbp-16]
    call printf

    mov al, byte [rbp-17]
    dec al
    mov byte [rbp-17], al

    cmp byte [rbp-17], 0x00
    je cpuid_2_exit_loop

; re-copy
    mov rax, 2
    cpuid
    mov dword [rbp-4], eax
    mov dword [rbp-8], ebx
    mov dword [rbp-12], ecx
    mov dword [rbp-16], edx

    jmp cpuid_2_loop
cpuid_2_exit_loop:
    leave
    ret

section .data
hex_fmt:                db  "%08x", 0xA, 0x00
new_line_fmt:           db  0xA, 0x00
raw_description_fmt:    db "---raw data---", 0xA, 0x00
;;;;;;;
descriptor_00_description:  db  "null descriptor (=unused descriptor)", 0x00
descriptor_01_description:  db  "code TLB, 4K pages, 4 ways, 32 entries", 0x00
descriptor_02_description:  db  "code TLB, 4M pages, fully, 2 entries", 0x00
descriptor_03_description:  db  "data TLB, 4K pages, 4 ways, 64 entries", 0x00
descriptor_04_description:  db  "data TLB, 4M pages, 4 ways, 8 entries", 0x00
descriptor_05_description:  db  "data TLB, 4M pages, 4 ways, 32 entries", 0x00
descriptor_06_description:  db  "code L1 cache, 8 KB, 4 ways, 32 byte lines", 0x00
descriptor_08_description:  db  "code L1 cache, 16 KB, 4 ways, 32 byte lines", 0x00
descriptor_09_description:  db  "code L1 cache, 32 KB, 4 ways, 64 byte lines", 0x00
descriptor_0A_description:  db  "data L1 cache, 8 KB, 2 ways, 32 byte lines", 0x00
descriptor_0B_description:  db  "code TLB, 4M pages, 4 ways, 4 entries", 0x00
descriptor_0C_description:  db  "data L1 cache, 16 KB, 4 ways, 32 byte lines", 0x00
descriptor_0D_description:  db  "data L1 cache, 16 KB, 4 ways, 64 byte lines (ECC)", 0x00
descriptor_0E_description:  db  "data L1 cache, 24 KB, 6 ways, 64 byte lines", 0x00
descriptor_10_description:  db  "data L1 cache, 16 KB, 4 ways, 32 byte lines (IA-64)", 0x00
descriptor_15_description:  db  "code L1 cache, 16 KB, 4 ways, 32 byte lines (IA-64)", 0x00
descriptor_1A_description:  db  "code and data L2 cache, 96 KB, 6 ways, 64 byte lines (IA-64)", 0x00
descriptor_1D_description:  db  "code and data L2 cache, 128 KB, 2 ways, 64 byte lines", 0x00
descriptor_21_description:  db  "code and data L2 cache, 256 KB, 8 ways, 64 byte lines", 0x00
descriptor_22_description:  db  "code and data L3 cache, 512 KB, 4 ways (!), 64 byte lines, dual-sectored", 0x00
descriptor_23_description:  db  "code and data L3 cache, 1024 KB, 8 ways, 64 byte lines, dual-sectored", 0x00
descriptor_24_description:  db  "code and data L2 cache, 1024 KB, 16 ways, 64 byte lines", 0x00
descriptor_25_description:  db  "code and data L3 cache, 2048 KB, 8 ways, 64 byte lines, dual-sectored", 0x00
descriptor_29_description:  db  "code and data L3 cache, 4096 KB, 8 ways, 64 byte lines, dual-sectored", 0x00
descriptor_2C_description:  db  "data L1 cache, 32 KB, 8 ways, 64 byte lines", 0x00
descriptor_30_description:  db  "code L1 cache, 32 KB, 8 ways, 64 byte lines", 0x00
descriptor_39_description:  db  "code and data L2 cache, 128 KB, 4 ways, 64 byte lines, sectored", 0x00
descriptor_3A_description:  db  "code and data L2 cache, 192 KB, 6 ways, 64 byte lines, sectored", 0x00
descriptor_3B_description:  db  "code and data L2 cache, 128 KB, 2 ways, 64 byte lines, sectored", 0x00
descriptor_3C_description:  db  "code and data L2 cache, 256 KB, 4 ways, 64 byte lines, sectored", 0x00
descriptor_3D_description:  db  "code and data L2 cache, 384 KB, 6 ways, 64 byte lines, sectored", 0x00
descriptor_3E_description:  db  "code and data L2 cache, 512 KB, 4 ways, 64 byte lines, sectored", 0x00
descriptor_40_description:  db  "no integrated L2 cache (P6 core) or L3 cache (P4 core)", 0x00
descriptor_41_description:  db  "code and data L2 cache, 128 KB, 4 ways, 32 byte lines", 0x00
descriptor_42_description:  db  "code and data L2 cache, 256 KB, 4 ways, 32 byte lines", 0x00
descriptor_43_description:  db  "code and data L2 cache, 512 KB, 4 ways, 32 byte lines", 0x00
descriptor_44_description:  db  "code and data L2 cache, 1024 KB, 4 ways, 32 byte lines", 0x00
descriptor_45_description:  db  "code and data L2 cache, 2048 KB, 4 ways, 32 byte lines", 0x00
descriptor_46_description:  db  "code and data L3 cache, 4096 KB, 4 ways, 64 byte lines", 0x00
descriptor_47_description:  db  "code and data L3 cache, 8192 KB, 8 ways, 64 byte lines", 0x00
descriptor_48_description:  db  "code and data L2 cache, 3072 KB, 12 ways, 64 byte lines", 0x00
descriptor_49_description:  db  "code and data L3 cache, 4096 KB, 16 ways, 64 byte lines (P4) or code and data L2 cache, 4096 KB, 16 ways, 64 byte lines (Core 2)", 0x00
descriptor_4A_description:  db  "code and data L3 cache, 6144 KB, 12 ways, 64 byte lines", 0x00
descriptor_4B_description:  db  "code and data L3 cache, 8192 KB, 16 ways, 64 byte lines", 0x00
descriptor_4C_description:  db  "code and data L3 cache, 12288 KB, 12 ways, 64 byte lines", 0x00
descriptor_4D_description:  db  "code and data L3 cache, 16384 KB, 16 ways, 64 byte lines", 0x00
descriptor_4E_description:  db  "code and data L2 cache, 6144 KB, 24 ways, 64 byte lines", 0x00
descriptor_4F_description:  db  "code TLB, 4K pages, ???, 32 entries", 0x00
descriptor_50_description:  db  "code TLB, 4K/4M/2M pages, fully, 64 entries", 0x00
descriptor_51_description:  db  "code TLB, 4K/4M/2M pages, fully, 128 entries", 0x00
descriptor_52_description:  db  "code TLB, 4K/4M/2M pages, fully, 256 entries", 0x00
descriptor_55_description:  db  "code TLB, 2M/4M, fully, 7 entries", 0x00
descriptor_56_description:  db  "L0 data TLB, 4M pages, 4 ways, 16 entries", 0x00
descriptor_57_description:  db  "L0 data TLB, 4K pages, 4 ways, 16 entries", 0x00
descriptor_59_description:  db  "L0 data TLB, 4K pages, fully, 16 entries", 0x00
descriptor_5A_description:  db  "L0 data TLB, 2M/4M, 4 ways, 32 entries", 0x00
descriptor_5B_description:  db  "data TLB, 4K/4M pages, fully, 64 entries", 0x00
descriptor_5C_description:  db  "data TLB, 4K/4M pages, fully, 128 entries", 0x00
descriptor_5D_description:  db  "data TLB, 4K/4M pages, fully, 256 entries", 0x00
descriptor_60_description:  db  "data L1 cache, 16 KB, 8 ways, 64 byte lines, sectored", 0x00
descriptor_61_description:  db  "code TLB, 4K pages, fully, 48 entries", 0x00
descriptor_63_description:  db  "data TLB, 2M/4M pages, 4-way, 32-entries, and data TLB, 1G pages, 4-way, 4 entries", 0x00
descriptor_64_description:  db  "data TLB, 4K pages, 4-way, 512 entries", 0x00
descriptor_66_description:  db  "data L1 cache, 8 KB, 4 ways, 64 byte lines, sectored", 0x00
descriptor_67_description:  db  "data L1 cache, 16 KB, 4 ways, 64 byte lines, sectored", 0x00
descriptor_68_description:  db  "data L1 cache, 32 KB, 4 ways, 64 byte lines, sectored", 0x00
descriptor_6A_description:  db  "L0 data TLB, 4K pages, 8-way, 64 entries", 0x00
descriptor_6B_description:  db  "data TLB, 4K pages, 8-way, 256 entries", 0x00
descriptor_6C_description:  db  "data TLB, 2M/4M pages, 8-way, 126 entries", 0x00
descriptor_6D_description:  db  "data TLB, 1G pages, fully, 16 entries", 0x00
descriptor_70_description:  db  "trace L1 cache, 12 KµOPs, 8 ways", 0x00
descriptor_71_description:  db  "trace L1 cache, 16 KµOPs, 8 ways", 0x00
descriptor_72_description:  db  "trace L1 cache, 32 KµOPs, 8 ways", 0x00
descriptor_73_description:  db  "trace L1 cache, 64 KµOPs, 8 ways", 0x00
descriptor_76_description:  db  "code TLB, 2M/4M pages, fully, 8 entries", 0x00
descriptor_77_description:  db  "code L1 cache, 16 KB, 4 ways, 64 byte lines, sectored (IA-64)", 0x00
descriptor_78_description:  db  "code and data L2 cache, 1024 KB, 4 ways, 64 byte lines", 0x00
descriptor_79_description:  db  "code and data L2 cache, 128 KB, 8 ways, 64 byte lines, dual-sectored", 0x00
descriptor_7A_description:  db  "code and data L2 cache, 256 KB, 8 ways, 64 byte lines, dual-sectored", 0x00
descriptor_7B_description:  db  "code and data L2 cache, 512 KB, 8 ways, 64 byte lines, dual-sectored", 0x00
descriptor_7C_description:  db  "code and data L2 cache, 1024 KB, 8 ways, 64 byte lines, dual-sectored", 0x00
descriptor_7D_description:  db  "code and data L2 cache, 2048 KB, 8 ways, 64 byte lines", 0x00
descriptor_7E_description:  db  "code and data L2 cache, 256 KB, 8 ways, 128 byte lines, sect. (IA-64)", 0x00
descriptor_7F_description:  db  "code and data L2 cache, 512 KB, 2 ways, 64 byte lines", 0x00
descriptor_80_description:  db  "code and data L2 cache, 512 KB, 8 ways, 64 byte lines", 0x00
descriptor_81_description:  db  "code and data L2 cache, 128 KB, 8 ways, 32 byte lines", 0x00
descriptor_82_description:  db  "code and data L2 cache, 256 KB, 8 ways, 32 byte lines", 0x00
descriptor_83_description:  db  "code and data L2 cache, 512 KB, 8 ways, 32 byte lines", 0x00
descriptor_84_description:  db  "code and data L2 cache, 1024 KB, 8 ways, 32 byte lines", 0x00
descriptor_85_description:  db  "code and data L2 cache, 2048 KB, 8 ways, 32 byte lines", 0x00
descriptor_86_description:  db  "code and data L2 cache, 512 KB, 4 ways, 64 byte lines", 0x00
descriptor_87_description:  db  "code and data L2 cache, 1024 KB, 8 ways, 64 byte lines", 0x00
descriptor_88_description:  db  "code and data L3 cache, 2048 KB, 4 ways, 64 byte lines (IA-64)", 0x00
descriptor_89_description:  db  "code and data L3 cache, 4096 KB, 4 ways, 64 byte lines (IA-64)", 0x00
descriptor_8A_description:  db  "code and data L3 cache, 8192 KB, 4 ways, 64 byte lines (IA-64)", 0x00
descriptor_8D_description:  db  "code and data L3 cache, 3072 KB, 12 ways, 128 byte lines (IA-64)", 0x00
descriptor_90_description:  db  "code TLB, 4K...256M pages, fully, 64 entries (IA-64)", 0x00
descriptor_96_description:  db  "data L1 TLB, 4K...256M pages, fully, 32 entries (IA-64)", 0x00
descriptor_9B_description:  db  "data L2 TLB, 4K...256M pages, fully, 96 entries (IA-64)", 0x00
descriptor_A0_description:  db  "data TLB, 4K pages, fully, 32 entries", 0x00
descriptor_B0_description:  db  "code TLB, 4K pages, 4 ways, 128 entries", 0x00
descriptor_B1_description:  db  "code TLB, 4M pages, 4 ways, 4 entries and code TLB, 2M pages, 4 ways, 8 entries", 0x00
descriptor_B2_description:  db  "code TLB, 4K pages, 4 ways, 64 entries", 0x00
descriptor_B3_description:  db  "data TLB, 4K pages, 4 ways, 128 entries", 0x00
descriptor_B4_description:  db  "data TLB, 4K pages, 4 ways, 256 entries", 0x00
descriptor_B5_description:  db  "code TLB, 4K pages, 8 ways, 64 entries", 0x00
descriptor_B6_description:  db  "code TLB, 4K pages, 8 ways, 128 entries", 0x00
descriptor_BA_description:  db  "data TLB, 4K pages, 4 ways, 64 entries", 0x00
descriptor_C0_description:  db  "data TLB, 4K/4M pages, 4 ways, 8 entries", 0x00
descriptor_C1_description:  db  "L2 code and data TLB, 4K/2M pages, 8 ways, 1024 entries", 0x00
descriptor_C2_description:  db  "data TLB, 2M/4M pages, 4 ways, 16 entries", 0x00
descriptor_C3_description:  db  "L2 code and data TLB, 4K/2M pages, 6 ways, 1536 entries and L2 code and data TLB, 1G pages, 4 ways, 16 entries", 0x00
descriptor_C4_description:  db  "data TLB, 2M/4M pages, 4-way, 32 entries", 0x00
descriptor_CA_description:  db  "L2 code and data TLB, 4K pages, 4 ways, 512 entries", 0x00
descriptor_D0_description:  db  "code and data L3 cache, 512-kb, 4 ways, 64 byte lines", 0x00
descriptor_D1_description:  db  "code and data L3 cache, 1024-kb, 4 ways, 64 byte lines", 0x00
descriptor_D2_description:  db  "code and data L3 cache, 2048-kb, 4 ways, 64 byte lines", 0x00
descriptor_D6_description:  db  "code and data L3 cache, 1024-kb, 8 ways, 64 byte lines", 0x00
descriptor_D7_description:  db  "code and data L3 cache, 2048-kb, 8 ways, 64 byte lines", 0x00
descriptor_D8_description:  db  "code and data L3 cache, 4096-kb, 8 ways, 64 byte lines", 0x00
descriptor_DC_description:  db  "code and data L3 cache, 1536-kb, 12 ways, 64 byte lines", 0x00
descriptor_DD_description:  db  "code and data L3 cache, 3072-kb, 12 ways, 64 byte lines", 0x00
descriptor_DE_description:  db  "code and data L3 cache, 6144-kb, 12 ways, 64 byte lines", 0x00
descriptor_E2_description:  db  "code and data L3 cache, 2048-kb, 16 ways, 64 byte lines", 0x00
descriptor_E3_description:  db  "code and data L3 cache, 4096-kb, 16 ways, 64 byte lines", 0x00
descriptor_E4_description:  db  "code and data L3 cache, 8192-kb, 16 ways, 64 byte lines", 0x00
descriptor_EA_description:  db  "code and data L3 cache, 12288-kb, 24 ways, 64 byte lines", 0x00
descriptor_EB_description:  db  "code and data L3 cache, 18432-kb, 24 ways, 64 byte lines", 0x00
descriptor_EC_description:  db  "code and data L3 cache, 24576-kb, 24 ways, 64 byte lines", 0x00
descriptor_F0_description:  db  "64 byte prefetching", 0x00
descriptor_F1_description:  db  "128 byte prefetching", 0x00
descriptor_FE_description:  db  "query standard level 0000_0018h instead", 0x00
descriptor_FF_description:  db  "query standard level 0000_0004h instead", 0x00
descriptor_reserved:        db  "reserved", 0x00

section .text
cpuid_switch_start:
    cmp rdi, 0x00
    jne next_descriptor_00
    mov rdi, descriptor_00_description
    jmp resolve_descriptor_description
next_descriptor_00:
    cmp rdi, 0x01
    jne next_descriptor_01
    mov rdi, descriptor_01_description
    jmp resolve_descriptor_description
next_descriptor_01:
    cmp rdi, 0x02
    jne next_descriptor_02
    mov rdi, descriptor_02_description
    jmp resolve_descriptor_description
next_descriptor_02:
    cmp rdi, 0x03
    jne next_descriptor_03
    mov rdi, descriptor_03_description
    jmp resolve_descriptor_description
next_descriptor_03:
    cmp rdi, 0x04
    jne next_descriptor_04
    mov rdi, descriptor_04_description
    jmp resolve_descriptor_description
next_descriptor_04:
    cmp rdi, 0x05
    jne next_descriptor_05
    mov rdi, descriptor_05_description
    jmp resolve_descriptor_description
next_descriptor_05:
    cmp rdi, 0x06
    jne next_descriptor_06
    mov rdi, descriptor_06_description
    jmp resolve_descriptor_description
next_descriptor_06:
    cmp rdi, 0x08
    jne next_descriptor_08
    mov rdi, descriptor_08_description
    jmp resolve_descriptor_description
next_descriptor_08:
    cmp rdi, 0x09
    jne next_descriptor_09
    mov rdi, descriptor_09_description
    jmp resolve_descriptor_description
next_descriptor_09:
    cmp rdi, 0x0A
    jne next_descriptor_0A
    mov rdi, descriptor_0A_description
    jmp resolve_descriptor_description
next_descriptor_0A:
    cmp rdi, 0x0B
    jne next_descriptor_0B
    mov rdi, descriptor_0B_description
    jmp resolve_descriptor_description
next_descriptor_0B:
    cmp rdi, 0x0C
    jne next_descriptor_0C
    mov rdi, descriptor_0C_description
    jmp resolve_descriptor_description
next_descriptor_0C:
    cmp rdi, 0x0D
    jne next_descriptor_0D
    mov rdi, descriptor_0D_description
    jmp resolve_descriptor_description
next_descriptor_0D:
    cmp rdi, 0x0E
    jne next_descriptor_0E
    mov rdi, descriptor_0E_description
    jmp resolve_descriptor_description
next_descriptor_0E:
    cmp rdi, 0x10
    jne next_descriptor_10
    mov rdi, descriptor_10_description
    jmp resolve_descriptor_description
next_descriptor_10:
    cmp rdi, 0x15
    jne next_descriptor_15
    mov rdi, descriptor_15_description
    jmp resolve_descriptor_description
next_descriptor_15:
    cmp rdi, 0x1A
    jne next_descriptor_1A
    mov rdi, descriptor_1A_description
    jmp resolve_descriptor_description
next_descriptor_1A:
    cmp rdi, 0x1D
    jne next_descriptor_1D
    mov rdi, descriptor_1D_description
    jmp resolve_descriptor_description
next_descriptor_1D:
    cmp rdi, 0x21
    jne next_descriptor_21
    mov rdi, descriptor_21_description
    jmp resolve_descriptor_description
next_descriptor_21:
    cmp rdi, 0x22
    jne next_descriptor_22
    mov rdi, descriptor_22_description
    jmp resolve_descriptor_description
next_descriptor_22:
    cmp rdi, 0x23
    jne next_descriptor_23
    mov rdi, descriptor_23_description
    jmp resolve_descriptor_description
next_descriptor_23:
    cmp rdi, 0x24
    jne next_descriptor_24
    mov rdi, descriptor_24_description
    jmp resolve_descriptor_description
next_descriptor_24:
    cmp rdi, 0x25
    jne next_descriptor_25
    mov rdi, descriptor_25_description
    jmp resolve_descriptor_description
next_descriptor_25:
    cmp rdi, 0x29
    jne next_descriptor_29
    mov rdi, descriptor_29_description
    jmp resolve_descriptor_description
next_descriptor_29:
    cmp rdi, 0x2C
    jne next_descriptor_2C
    mov rdi, descriptor_2C_description
    jmp resolve_descriptor_description
next_descriptor_2C:
    cmp rdi, 0x30
    jne next_descriptor_30
    mov rdi, descriptor_30_description
    jmp resolve_descriptor_description
next_descriptor_30:
    cmp rdi, 0x39
    jne next_descriptor_39
    mov rdi, descriptor_39_description
    jmp resolve_descriptor_description
next_descriptor_39:
    cmp rdi, 0x3A
    jne next_descriptor_3A
    mov rdi, descriptor_3A_description
    jmp resolve_descriptor_description
next_descriptor_3A:
    cmp rdi, 0x3B
    jne next_descriptor_3B
    mov rdi, descriptor_3B_description
    jmp resolve_descriptor_description
next_descriptor_3B:
    cmp rdi, 0x3C
    jne next_descriptor_3C
    mov rdi, descriptor_3C_description
    jmp resolve_descriptor_description
next_descriptor_3C:
    cmp rdi, 0x3D
    jne next_descriptor_3D
    mov rdi, descriptor_3D_description
    jmp resolve_descriptor_description
next_descriptor_3D:
    cmp rdi, 0x3E
    jne next_descriptor_3E
    mov rdi, descriptor_3E_description
    jmp resolve_descriptor_description
next_descriptor_3E:
    cmp rdi, 0x40
    jne next_descriptor_40
    mov rdi, descriptor_40_description
    jmp resolve_descriptor_description
next_descriptor_40:
    cmp rdi, 0x41
    jne next_descriptor_41
    mov rdi, descriptor_41_description
    jmp resolve_descriptor_description
next_descriptor_41:
    cmp rdi, 0x42
    jne next_descriptor_42
    mov rdi, descriptor_42_description
    jmp resolve_descriptor_description
next_descriptor_42:
    cmp rdi, 0x43
    jne next_descriptor_43
    mov rdi, descriptor_43_description
    jmp resolve_descriptor_description
next_descriptor_43:
    cmp rdi, 0x44
    jne next_descriptor_44
    mov rdi, descriptor_44_description
    jmp resolve_descriptor_description
next_descriptor_44:
    cmp rdi, 0x45
    jne next_descriptor_45
    mov rdi, descriptor_45_description
    jmp resolve_descriptor_description
next_descriptor_45:
    cmp rdi, 0x46
    jne next_descriptor_46
    mov rdi, descriptor_46_description
    jmp resolve_descriptor_description
next_descriptor_46:
    cmp rdi, 0x47
    jne next_descriptor_47
    mov rdi, descriptor_47_description
    jmp resolve_descriptor_description
next_descriptor_47:
    cmp rdi, 0x48
    jne next_descriptor_48
    mov rdi, descriptor_48_description
    jmp resolve_descriptor_description
next_descriptor_48:
    cmp rdi, 0x49
    jne next_descriptor_49
    mov rdi, descriptor_49_description
    jmp resolve_descriptor_description
next_descriptor_49:
    cmp rdi, 0x4A
    jne next_descriptor_4A
    mov rdi, descriptor_4A_description
    jmp resolve_descriptor_description
next_descriptor_4A:
    cmp rdi, 0x4B
    jne next_descriptor_4B
    mov rdi, descriptor_4B_description
    jmp resolve_descriptor_description
next_descriptor_4B:
    cmp rdi, 0x4C
    jne next_descriptor_4C
    mov rdi, descriptor_4C_description
    jmp resolve_descriptor_description
next_descriptor_4C:
    cmp rdi, 0x4D
    jne next_descriptor_4D
    mov rdi, descriptor_4D_description
    jmp resolve_descriptor_description
next_descriptor_4D:
    cmp rdi, 0x4E
    jne next_descriptor_4E
    mov rdi, descriptor_4E_description
    jmp resolve_descriptor_description
next_descriptor_4E:
    cmp rdi, 0x4F
    jne next_descriptor_4F
    mov rdi, descriptor_4F_description
    jmp resolve_descriptor_description
next_descriptor_4F:
    cmp rdi, 0x50
    jne next_descriptor_50
    mov rdi, descriptor_50_description
    jmp resolve_descriptor_description
next_descriptor_50:
    cmp rdi, 0x51
    jne next_descriptor_51
    mov rdi, descriptor_51_description
    jmp resolve_descriptor_description
next_descriptor_51:
    cmp rdi, 0x52
    jne next_descriptor_52
    mov rdi, descriptor_52_description
    jmp resolve_descriptor_description
next_descriptor_52:
    cmp rdi, 0x55
    jne next_descriptor_55
    mov rdi, descriptor_55_description
    jmp resolve_descriptor_description
next_descriptor_55:
    cmp rdi, 0x56
    jne next_descriptor_56
    mov rdi, descriptor_56_description
    jmp resolve_descriptor_description
next_descriptor_56:
    cmp rdi, 0x57
    jne next_descriptor_57
    mov rdi, descriptor_57_description
    jmp resolve_descriptor_description
next_descriptor_57:
    cmp rdi, 0x59
    jne next_descriptor_59
    mov rdi, descriptor_59_description
    jmp resolve_descriptor_description
next_descriptor_59:
    cmp rdi, 0x5A
    jne next_descriptor_5A
    mov rdi, descriptor_5A_description
    jmp resolve_descriptor_description
next_descriptor_5A:
    cmp rdi, 0x5B
    jne next_descriptor_5B
    mov rdi, descriptor_5B_description
    jmp resolve_descriptor_description
next_descriptor_5B:
    cmp rdi, 0x5C
    jne next_descriptor_5C
    mov rdi, descriptor_5C_description
    jmp resolve_descriptor_description
next_descriptor_5C:
    cmp rdi, 0x5D
    jne next_descriptor_5D
    mov rdi, descriptor_5D_description
    jmp resolve_descriptor_description
next_descriptor_5D:
    cmp rdi, 0x60
    jne next_descriptor_60
    mov rdi, descriptor_60_description
    jmp resolve_descriptor_description
next_descriptor_60:
    cmp rdi, 0x61
    jne next_descriptor_61
    mov rdi, descriptor_61_description
    jmp resolve_descriptor_description
next_descriptor_61:
    cmp rdi, 0x63
    jne next_descriptor_63
    mov rdi, descriptor_63_description
    jmp resolve_descriptor_description
next_descriptor_63:
    cmp rdi, 0x64
    jne next_descriptor_64
    mov rdi, descriptor_64_description
    jmp resolve_descriptor_description
next_descriptor_64:
    cmp rdi, 0x66
    jne next_descriptor_66
    mov rdi, descriptor_66_description
    jmp resolve_descriptor_description
next_descriptor_66:
    cmp rdi, 0x67
    jne next_descriptor_67
    mov rdi, descriptor_67_description
    jmp resolve_descriptor_description
next_descriptor_67:
    cmp rdi, 0x68
    jne next_descriptor_68
    mov rdi, descriptor_68_description
    jmp resolve_descriptor_description
next_descriptor_68:
    cmp rdi, 0x6A
    jne next_descriptor_6A
    mov rdi, descriptor_6A_description
    jmp resolve_descriptor_description
next_descriptor_6A:
    cmp rdi, 0x6B
    jne next_descriptor_6B
    mov rdi, descriptor_6B_description
    jmp resolve_descriptor_description
next_descriptor_6B:
    cmp rdi, 0x6C
    jne next_descriptor_6C
    mov rdi, descriptor_6C_description
    jmp resolve_descriptor_description
next_descriptor_6C:
    cmp rdi, 0x6D
    jne next_descriptor_6D
    mov rdi, descriptor_6D_description
    jmp resolve_descriptor_description
next_descriptor_6D:
    cmp rdi, 0x70
    jne next_descriptor_70
    mov rdi, descriptor_70_description
    jmp resolve_descriptor_description
next_descriptor_70:
    cmp rdi, 0x71
    jne next_descriptor_71
    mov rdi, descriptor_71_description
    jmp resolve_descriptor_description
next_descriptor_71:
    cmp rdi, 0x72
    jne next_descriptor_72
    mov rdi, descriptor_72_description
    jmp resolve_descriptor_description
next_descriptor_72:
    cmp rdi, 0x73
    jne next_descriptor_73
    mov rdi, descriptor_73_description
    jmp resolve_descriptor_description
next_descriptor_73:
    cmp rdi, 0x76
    jne next_descriptor_76
    mov rdi, descriptor_76_description
    jmp resolve_descriptor_description
next_descriptor_76:
    cmp rdi, 0x77
    jne next_descriptor_77
    mov rdi, descriptor_77_description
    jmp resolve_descriptor_description
next_descriptor_77:
    cmp rdi, 0x78
    jne next_descriptor_78
    mov rdi, descriptor_78_description
    jmp resolve_descriptor_description
next_descriptor_78:
    cmp rdi, 0x79
    jne next_descriptor_79
    mov rdi, descriptor_79_description
    jmp resolve_descriptor_description
next_descriptor_79:
    cmp rdi, 0x7A
    jne next_descriptor_7A
    mov rdi, descriptor_7A_description
    jmp resolve_descriptor_description
next_descriptor_7A:
    cmp rdi, 0x7B
    jne next_descriptor_7B
    mov rdi, descriptor_7B_description
    jmp resolve_descriptor_description
next_descriptor_7B:
    cmp rdi, 0x7C
    jne next_descriptor_7C
    mov rdi, descriptor_7C_description
    jmp resolve_descriptor_description
next_descriptor_7C:
    cmp rdi, 0x7D
    jne next_descriptor_7D
    mov rdi, descriptor_7D_description
    jmp resolve_descriptor_description
next_descriptor_7D:
    cmp rdi, 0x7E
    jne next_descriptor_7E
    mov rdi, descriptor_7E_description
    jmp resolve_descriptor_description
next_descriptor_7E:
    cmp rdi, 0x7F
    jne next_descriptor_7F
    mov rdi, descriptor_7F_description
    jmp resolve_descriptor_description
next_descriptor_7F:
    cmp rdi, 0x80
    jne next_descriptor_80
    mov rdi, descriptor_80_description
    jmp resolve_descriptor_description
next_descriptor_80:
    cmp rdi, 0x81
    jne next_descriptor_81
    mov rdi, descriptor_81_description
    jmp resolve_descriptor_description
next_descriptor_81:
    cmp rdi, 0x82
    jne next_descriptor_82
    mov rdi, descriptor_82_description
    jmp resolve_descriptor_description
next_descriptor_82:
    cmp rdi, 0x83
    jne next_descriptor_83
    mov rdi, descriptor_83_description
    jmp resolve_descriptor_description
next_descriptor_83:
    cmp rdi, 0x84
    jne next_descriptor_84
    mov rdi, descriptor_84_description
    jmp resolve_descriptor_description
next_descriptor_84:
    cmp rdi, 0x85
    jne next_descriptor_85
    mov rdi, descriptor_85_description
    jmp resolve_descriptor_description
next_descriptor_85:
    cmp rdi, 0x86
    jne next_descriptor_86
    mov rdi, descriptor_86_description
    jmp resolve_descriptor_description
next_descriptor_86:
    cmp rdi, 0x87
    jne next_descriptor_87
    mov rdi, descriptor_87_description
    jmp resolve_descriptor_description
next_descriptor_87:
    cmp rdi, 0x88
    jne next_descriptor_88
    mov rdi, descriptor_88_description
    jmp resolve_descriptor_description
next_descriptor_88:
    cmp rdi, 0x89
    jne next_descriptor_89
    mov rdi, descriptor_89_description
    jmp resolve_descriptor_description
next_descriptor_89:
    cmp rdi, 0x8A
    jne next_descriptor_8A
    mov rdi, descriptor_8A_description
    jmp resolve_descriptor_description
next_descriptor_8A:
    cmp rdi, 0x8D
    jne next_descriptor_8D
    mov rdi, descriptor_8D_description
    jmp resolve_descriptor_description
next_descriptor_8D:
    cmp rdi, 0x90
    jne next_descriptor_90
    mov rdi, descriptor_90_description
    jmp resolve_descriptor_description
next_descriptor_90:
    cmp rdi, 0x96
    jne next_descriptor_96
    mov rdi, descriptor_96_description
    jmp resolve_descriptor_description
next_descriptor_96:
    cmp rdi, 0x9B
    jne next_descriptor_9B
    mov rdi, descriptor_9B_description
    jmp resolve_descriptor_description
next_descriptor_9B:
    cmp rdi, 0xA0
    jne next_descriptor_A0
    mov rdi, descriptor_A0_description
    jmp resolve_descriptor_description
next_descriptor_A0:
    cmp rdi, 0xB0
    jne next_descriptor_B0
    mov rdi, descriptor_B0_description
    jmp resolve_descriptor_description
next_descriptor_B0:
    cmp rdi, 0xB1
    jne next_descriptor_B1
    mov rdi, descriptor_B1_description
    jmp resolve_descriptor_description
next_descriptor_B1:
    cmp rdi, 0xB2
    jne next_descriptor_B2
    mov rdi, descriptor_B2_description
    jmp resolve_descriptor_description
next_descriptor_B2:
    cmp rdi, 0xB3
    jne next_descriptor_B3
    mov rdi, descriptor_B3_description
    jmp resolve_descriptor_description
next_descriptor_B3:
    cmp rdi, 0xB4
    jne next_descriptor_B4
    mov rdi, descriptor_B4_description
    jmp resolve_descriptor_description
next_descriptor_B4:
    cmp rdi, 0xB5
    jne next_descriptor_B5
    mov rdi, descriptor_B5_description
    jmp resolve_descriptor_description
next_descriptor_B5:
    cmp rdi, 0xB6
    jne next_descriptor_B6
    mov rdi, descriptor_B6_description
    jmp resolve_descriptor_description
next_descriptor_B6:
    cmp rdi, 0xBA
    jne next_descriptor_BA
    mov rdi, descriptor_BA_description
    jmp resolve_descriptor_description
next_descriptor_BA:
    cmp rdi, 0xC0
    jne next_descriptor_C0
    mov rdi, descriptor_C0_description
    jmp resolve_descriptor_description
next_descriptor_C0:
    cmp rdi, 0xC1
    jne next_descriptor_C1
    mov rdi, descriptor_C1_description
    jmp resolve_descriptor_description
next_descriptor_C1:
    cmp rdi, 0xC2
    jne next_descriptor_C2
    mov rdi, descriptor_C2_description
    jmp resolve_descriptor_description
next_descriptor_C2:
    cmp rdi, 0xC3
    jne next_descriptor_C3
    mov rdi, descriptor_C3_description
    jmp resolve_descriptor_description
next_descriptor_C3:
    cmp rdi, 0xC4
    jne next_descriptor_C4
    mov rdi, descriptor_C4_description
    jmp resolve_descriptor_description
next_descriptor_C4:
    cmp rdi, 0xCA
    jne next_descriptor_CA
    mov rdi, descriptor_CA_description
    jmp resolve_descriptor_description
next_descriptor_CA:
    cmp rdi, 0xD0
    jne next_descriptor_D0
    mov rdi, descriptor_D0_description
    jmp resolve_descriptor_description
next_descriptor_D0:
    cmp rdi, 0xD1
    jne next_descriptor_D1
    mov rdi, descriptor_D1_description
    jmp resolve_descriptor_description
next_descriptor_D1:
    cmp rdi, 0xD2
    jne next_descriptor_D2
    mov rdi, descriptor_D2_description
    jmp resolve_descriptor_description
next_descriptor_D2:
    cmp rdi, 0xD6
    jne next_descriptor_D6
    mov rdi, descriptor_D6_description
    jmp resolve_descriptor_description
next_descriptor_D6:
    cmp rdi, 0xD7
    jne next_descriptor_D7
    mov rdi, descriptor_D7_description
    jmp resolve_descriptor_description
next_descriptor_D7:
    cmp rdi, 0xD8
    jne next_descriptor_D8
    mov rdi, descriptor_D8_description
    jmp resolve_descriptor_description
next_descriptor_D8:
    cmp rdi, 0xDC
    jne next_descriptor_DC
    mov rdi, descriptor_DC_description
    jmp resolve_descriptor_description
next_descriptor_DC:
    cmp rdi, 0xDD
    jne next_descriptor_DD
    mov rdi, descriptor_DD_description
    jmp resolve_descriptor_description
next_descriptor_DD:
    cmp rdi, 0xDE
    jne next_descriptor_DE
    mov rdi, descriptor_DE_description
    jmp resolve_descriptor_description
next_descriptor_DE:
    cmp rdi, 0xE2
    jne next_descriptor_E2
    mov rdi, descriptor_E2_description
    jmp resolve_descriptor_description
next_descriptor_E2:
    cmp rdi, 0xE3
    jne next_descriptor_E3
    mov rdi, descriptor_E3_description
    jmp resolve_descriptor_description
next_descriptor_E3:
    cmp rdi, 0xE4
    jne next_descriptor_E4
    mov rdi, descriptor_E4_description
    jmp resolve_descriptor_description
next_descriptor_E4:
    cmp rdi, 0xEA
    jne next_descriptor_EA
    mov rdi, descriptor_EA_description
    jmp resolve_descriptor_description
next_descriptor_EA:
    cmp rdi, 0xEB
    jne next_descriptor_EB
    mov rdi, descriptor_EB_description
    jmp resolve_descriptor_description
next_descriptor_EB:
    cmp rdi, 0xEC
    jne next_descriptor_EC
    mov rdi, descriptor_EC_description
    jmp resolve_descriptor_description
next_descriptor_EC:
    cmp rdi, 0xF0
    jne next_descriptor_F0
    mov rdi, descriptor_F0_description
    jmp resolve_descriptor_description
next_descriptor_F0:
    cmp rdi, 0xF1
    jne next_descriptor_F1
    mov rdi, descriptor_F1_description
    jmp resolve_descriptor_description
next_descriptor_F1:
    cmp rdi, 0xFE
    jne next_descriptor_FE
    mov rdi, descriptor_FE_description
    jmp resolve_descriptor_description
next_descriptor_FE:
    cmp rdi, 0xFF
    jne next_descriptor_FF
    mov rdi, descriptor_FF_description
    jmp resolve_descriptor_description
next_descriptor_FF:
    mov rdi, descriptor_reserved
resolve_descriptor_description:
    call printf
    jmp cpuid_switch_end