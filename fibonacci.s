.intel_syntax noprefix

UsageStatement:
    .asciz "Usage: ./10times <word>"

NumPrint:
    .asciz "test: %lu\n"

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


    mov rbx, rax # count number of iterations/determin fibnum
    sub rbx, 1

    mov r12, 0 # start A
    mov rsi, 1 # start B

    sub rsp, 16 # Put storage space on stack.

1:
    #mov r15, rsi # store B
    xadd rsi, r12 # B = A + B (C)

Print:
    mov [rsp + 8], rsi # store value on stack
    mov rdi, OFFSET NumPrint
    sub rsp, 8
    call printf
    add rsp, 8
    mov rsi, [rsp + 8] # get value back from stack.


    #mov r12, r15 # a = b(stored in C)

    sub rbx, 1

    jz Exit # cmp ecx to user input
    jmp 1b # je Finish




#Finish:


Exit: 
    add rsp, 16 # restore stack.

    mov rdi, OFFSET UsageStatement
    call puts
    mov eax, 1
    ret
