bits 16

org 0x100

section .rdata

    main_str: db "I am task main", 13, 10, 0
    main_a: db "I am task a", 13, 10, 0
    main_b: db "I am task b", 13, 10, 0

section .data

    stack_status:
    status_1: db 1 ; this is for Main
    status_2: db 0
    status_3: db 0

    stacks: times 256 * 2 db 0

    stack_pointers:
    dw 0 ; this is for Main
    dw stacks + 256
    dw stacks + 512

section .text

main:
    lea si, [task_a]
    call spawn_new_task

    lea si, [task_b]
    call spawn_new_task

.loop_forever:
    lea di, [main_str]
    call putstring
    call yield
    jmp .loop_forever

task_a:
.loop_forever:
    lea di, [main_a]
    call putstring
    call yield
    jmp .loop_forever

task_b:
.loop_forever:
    lea di, [main_b]
    call putstring
    call yield
    jmp .loop_forever

spawn_new_task:
    ; find a free task
    mov cx, -1
    lea bx, [stack_status]
.loop:
    inc cx
    cmp cx, 3 ; change this to add more tasks
    jl .continue
    ret
.continue:
    cmp [bx], 0
    inc bx
    jne .loop
    lea bx, [stack_pointers]
    mov [bx], sp
    ; switch to it
    add bx, cx
    add bx, cx
    mov sp, [bx]
    push si
    pusha
    pushf
    lea bx, [stack_status]
    add bx, cx
    mov [bx], 1
    mov sp, [stack_pointers]
    ret

yield:
    ; ret already saved by call
    ; pusha
    ; pushf
    ; loop through stack status looking for a 1
    ; make sure to wrap back to 0
    ; switch to new stack
    ; popf
    ; popa
    ret

; takes a char to print in dx
; no return value
putchar:
    mov     ax, dx          ; call interrupt x10 sub interrupt xE
    mov     ah, 0x0E
    mov     cx, 1
    int     0x10
    ret

;takes an address to write to in di
;writes to address until a newline is encountered
;returns nothing
putstring:
    cmp     byte [di], 0        ; see if the current byte is a null terminator
    je      .done               ; nope keep printing
.continue:
    mov     dl, [di]            ; grab the next character of the string
    mov     dh, 0               ; print it
    call    putchar
    inc     di                  ; move to the next character
    jmp     putstring
.done:
    ret