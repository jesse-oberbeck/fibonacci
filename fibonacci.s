.intel_syntax noprefix

UsageStatement:
    .asciz "Usage: ./fibonacci <word>"

NumPrint:
    .asciz "\nNumber in Hex: %016lx%016lx%016lx%016lx\n\n"

ScanPrompt:
    .asciz "Please enter the desired Fibonacci Number (0 - 300): %d"

ZeroStatement:
    .asciz "\nNumber in Hex: 0000000000000000000000000000000000000000000000000000000000000000\n\n"

OneStatement:
    .asciz "\nNumber in Hex: 0000000000000000000000000000000000000000000000000000000000000001\n\n"

.globl main
main:

# Check for a parameter on the command line
    cmp edi, 2      #check argc.
    jne Prompt      #ask for input if no arg.

# strtol
    mov rdi, QWORD PTR[rsi + 8] #give a location
    mov rsi, 0      #send the un-needed text to NULL.
    mov rdx, 10     #base 10.
    sub rsp, 8      #make room.
    call strtol     #call function.
    add rsp, 8      #take room back.

# check if 1 or zero, will also catch invalid input (which yields 0).
Checks:
    cmp rsi, 0      #check if input was 0.
    jle ExitZero    #send to proper exit point.
    cmp rsi, 1      #check if input was 1.
    je ExitOne      #send to proper exit point.
    cmp rsi, 2      #check if answer was actually usable.
    jge Start       #send to main Fibonacci.

Prompt:
    mov rdi, OFFSET ScanPrompt
    call puts       #print the prompt for input.
    mov rbp, rsp    #save the stack pointer
    sub rsp, 64     #move the stack pointer to make a new frame.
    mov rdi, rsp    #put the new stack address in rdi
    mov rsi, 64     #give a size for the read.
    mov rdx, stdin  #tell it where to get input.

    call fgets      #call the function.

    mov rdi, rsp    #put the data in place for strtol.
    mov rsi, 0      #send un-needed text to NULL.
    mov rdx, 10     #specify base 10
    sub rsp, 8      #small frame for strtol.
    call strtol     #call strtol.
    add rsp, 8      #restore stack from strtol.
    add rsp, 64     #restore stack from prompt.
    jmp Checks      #check for numbers less than 2.

Start:
    xor rcx, rcx    #clear the register
    xor rdx, rdx    #clear the register
    mov rbx, rax    #count number of iterations/determine fibnum
    sub rbx, 1      #line up the count with the Fibonacci numbers.

    xor r8, r8      #clear the register
    xor r9, r9      #clear the register
    xor r10, r10    #clear the register
    xor r11, r11    #clear the register
    xor r12, r12    #clear the register
    xor r14, r14    #clear the register
    xor r15, r15    #clear the register

    mov rax, 0      #start A
    mov rsi, 1      #start B

1:  # Fibonacci Loop.
    xadd rsi, rax   #add and switch the registers.
    adc rcx, rdx    #carryover...
    xchg rcx, rdx   #chinese fire drill.

    adc r10, r11    #caryover...
    xchg r10, r11   #chinese fire drill.

    adc r8, r9      #carryover...
    xchg r8, r9     #chinese fire drill.

    sub rbx, 1      #decrement the counter.

    jz Exit # Exit loop when count hits zero.
    jmp 1b  # Otherwise go to beginning of loop.

Exit: 
    mov rdi, OFFSET NumPrint #Set up first arg.
    #xchg rsi, r11  #Change order of args for print.
    mov r15, rsi    #save.
    mov r14, rcx    #save.
    mov r13, rdx    #save.
    mov r12, r9     #save. now reposition them...

    mov rsi, r12    #arg2 - highest
    mov rcx, r13    #arg4 - second lowest
    mov rdx, r11    #arg3 - second highest
    mov r8, r15     #arg5 - lowest

    sub rsp, 8  #make room for printf.
    call printf #use printf.
    add rsp, 8  #take the space away.
    ret         #done!

Usage:
    mov rdi, OFFSET UsageStatement  #load text
    call puts   #print text.
    mov eax, 1  #return value.
    ret         #exit.

ExitZero:
    mov rdi, OFFSET ZeroStatement   #load text.
    call puts   #print text.
    mov eax, 0  #return value.
    ret         #exit.

ExitOne:
    mov rdi, OFFSET OneStatement    #load text.
    call puts   #print text.
    mov eax, 0  #return value.
    ret         #exit.
