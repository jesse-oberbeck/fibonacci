.intel_syntax noprefix

UsageStatement:
    .asciz "Usage: ./10times <word>"

NumPrint:
    .asciz "test: %lx %lx\n"

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


    mov rbx, rax # count number of iterations/determin fibnum
    sub rbx, 1

    mov rax, 0 # start A
    mov rsi, 1 # start B

    sub rsp, 16 # Put storage space on stack.

1:
    xadd rsi, rax # B = A + B (C)
    adc r14, r15
    xchg r14, r15

    sub rbx, 1

    jz Exit # cmp ecx to user input
    jmp 1b # je Finish



#Finish:


Exit: 

    mov [rsp + 8], rsi # store value on stack
    mov rdx, rsi #Set up third arg.
    mov rsi, r15 #Set up second arg.
    mov rdi, OFFSET NumPrint #Set up first arg.
    sub rsp, 8
    call printf
    add rsp, 8

    mov rsi, [rsp + 8] # get value back from stack.



    add rsp, 16 # restore stack.

    mov rdi, OFFSET UsageStatement
    call puts
    mov eax, 1
    ret
