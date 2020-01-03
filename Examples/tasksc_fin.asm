bits 16

org 0x100

section .rdata

    main_str: db "I am task main", 13, 10, 0
    main_a: db "I am task a", 13, 10, 0
    main_b: db "I am task b", 13, 10, 0

section .data

    current_task: db 0

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
    lea     si, [task_a]
    call    spawn_new_task

    lea     si, [task_b]
    call    spawn_new_task

.loop_forever:
    lea     si, [main_str]
    call    putstring
    call    yield
    jmp     .loop_forever

task_a:
.loop_forever:
    lea     si, [main_a]
    call    putstring
    call    yield
    jmp     .loop_forever

task_b:
.loop_forever:
    lea     si, [main_b]
    call    putstring
    call    yield
    jmp     .loop_forever

spawn_new_task:
    ; find a free task, start pointers off at -1
    mov     cx, 0
    lea     bx, [stack_status]
.loop:
    ; increment our pointers by one
    cmp     cx, 3                   ; change this to add more tasks
    jl      .continue
    ret                             ; no free task, return immediately
.continue:
    cmp     byte [bx], 0
    je      .done                   ; if equal, tasks is free
    inc     cx
    inc     bx
    jmp     .loop
.done:
    mov     byte [bx], 1            ; task was free, reserve it
    
    lea     bx, [stack_pointers]
    mov     [bx], sp                ; save main's stack pointer
    ; switch to free stack
    add     bx, cx
    add     bx, cx                  ; free stack is list of words (not bytes) and add is cheaper than mul
    mov     sp, [bx]                ; change to free stack
    push    si                      ; push stuff
    pusha
    pushf
    mov     [bx], sp                ; save new stack's new pointer
    mov     sp, [stack_pointers]    ; change back to main
    ret

yield:
    ; ret already saved by call
    pusha
    pushf
    movzx   cx, byte [current_task]
    ; save current stack pointer
    lea     bx, [stack_pointers]
    add     bx, cx
    add     bx, cx
    mov     [bx], sp
    ; loop through stack status looking for a 1
    lea     bx, [stack_status]
    add     bx, cx                  ; make sure we start looking at next task
.loop:
    inc     bx
    inc     cx
    cmp     cx, 3                   ; increment this for more tasks
    jl      .continue
    xor     cx, cx                  ; clear cx
    lea     bx, [stack_status]      ; reset bx back to start
.continue:
    cmp     byte [bx], 1            ; is this stack active
    je      .found_one
    jmp     .loop
.found_one:
    mov     [current_task], cl
    ; switch to new stack
    lea     bx, [stack_pointers]
    add     bx, cx
    add     bx, cx
    mov     sp, [bx]
    popf
    popa
    ret

;takes an address to write to in si
;writes to address until a null term is encountered
;returns nothing
putstring:
    mov     ah, 0xE             ; interrupt setup
.continue:
    lodsb                       ; put char to write in al
    test    al, al              ; simulate and
    je      .done               ; was al 0?
    int     0x10                ; call interrupt
    jmp     putstring
.done:
    ret