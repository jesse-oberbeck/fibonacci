.intel_syntax noprefix

UsageStatement:
    .asciz "Usage: ./10times <word>"

NumPrint:
    .asciz "\nNumber in Hex: %016lx%016lx%016lx%016lx\n\n"

NumPrintHigh:
    .asciz "%lx ~~\n"

.globl main
main:

# Check for a parameter on the command line
    cmp edi, 2
    jne Exit

# strtol
    mov rdi, QWORD PTR[rsi + 8]
    mov rsi, 0
    mov rdx, 10
    sub rsp, 8
    call strtol
    add rsp, 8

    xor rcx, rcx
    xor rdx, rdx

    mov rbx, rax # count number of iterations/determine fibnum
    sub rbx, 1

    xor r8, r8
    xor r9, r9
    xor r10, r10
    xor r11, r11
    xor r12, r12
    xor r14, r14
    xor r15, r15

    mov rax, 0 # start A
    mov rsi, 1 # start B

    #sub rsp, 16 # Put storage space on stack.


1:  # Fibonacci Loop.
    xadd rsi, rax
    adc rcx, rdx
    xchg rcx, rdx

    adc r10, r11
    xchg r10, r11

    adc r8, r9
    xchg r8, r9

    sub rbx, 1

    jz Exit # Exit loop when count hits zero.
    jmp 1b  # Otherwise go to beginning of loop.



Exit: 

    mov rdi, OFFSET NumPrint #Set up first arg.
    #xchg rsi, r11 # Change order of args for print.
    mov r15, rsi #save
    mov r14, rcx #save
    mov r13, rdx #save
    mov r12, r9 #save

    mov rsi, r12 #arg2 - highest
    mov rcx, r13 #arg4 - second lowest
    mov rdx, r11 #arg3 - second highest
    mov r8, r15 #arg5 - lowest



    sub rsp, 8
    call printf
    add rsp, 8



    #add rsp, 16 # restore stack.

    mov rdi, OFFSET UsageStatement
    call puts
    mov eax, 1
    ret
