;Phase Beta
;
;
;IDEA: have master file that does a final check to 
;       ensure that our code is exitable, but otherwise
;       have each our files start at specific adrress and
;       with floppydisk, load them into memory, and jmp to
;       for certain key presses... hmm.....?
bits 16

org 0x100

IVT8_OFFSET_SLOT	equ	4 * 8
IVT8_SEGMENT_SLOT	equ	IVT8_OFFSET_SLOT + 2

section .rdata
    main_str:       db "I am task main", 13, 10, 0
    main_a:         db "I am task a", 13, 10, 0
    main_b:         db "I am task b", 13, 10, 0

section .data

    real_ivt8_seg   dw 0
    real_ivt8_offst dw 0

    semaph:         dw 1

    current_task:   db 0

    stack_status:
    status_1:       db 1 ; this is for Main
    status_2:       db 0
    status_3:       db 0
    

    stacks: times 256 * 2 db 0

    stack_pointers:
        dw 0 ; this is for Main
        dw stacks + 256
        dw stacks + 512

;I find it interesting that we can have a named operation,
;not necessarily a variable. hm...
calc_8_offset       equ    4 * 8
calc_8_segment      equ     calc_8_offset + 2

section .text
    ;replace the interrupt first thing
    mov     ax, 0x0000
    mov     es, ax

    cli
    mov     ax, [es:calc_8_offset]
    mov     [real_ivt8_offst], ax
    mov     ax, [es:calc_8_segment]
    mov     [real_ivt8_seg], ax

    mov     ax, [_timer]
    mov     [es:calc_8_offset], ax
    mov     ax, cs
    mov     [es:calc_8_segment], ax 
    sti

    mov		ax, cs
	mov		ds, ax
	
_main:
	
    mov     ah, 0x0
    mov     al, 0x1
    int     0x10 

    lea     si, [_task_a]
    call    _spawn_new_task

    lea     si, [_task_b]
    call    _spawn_new_task

    ; lea     di, [_task_c]
    ; call    _spawn_new_task

    ; lea     dx, [_task_d]
    ; call    _spawn_new_task
	

.loop_forever:
    call    _semaphore    
    mov     ax, 0xB800
    mov     es, ax                  ; moving directly into a segment register is not allowed
    mov     bx, 990                 ; offset for approximately the middle of the screen

    ; set video to text mode
    mov     word [es:bx+0], 0x2454  ; T dark blue background, white font
    mov     word [es:bx+2], 0x2461  ; a dark blue background, white font
    mov     word [es:bx+4], 0x2473  ; s dark blue background, white font
    mov     word [es:bx+6], 0x246b  ; k dark blue background, white font
    mov     word [es:bx+8], 0x2420  ; space 
    mov     word [es:bx+10], 0x424d ; M
    mov     word [es:bx+12], 0x4241 ; a
    mov     word [es:bx+14], 0x4249 ; i
    mov     word [es:bx+16], 0x424e ; N
    mov     word [es:bx+18], 0x4221 ; !
    
    call    _restore
    jmp     .loop_forever

_task_a:
.loop_forever:
    call    _semaphore
    mov     ax, 0xB800
    mov     es, ax                  ; moving directly into a segment register is not allowed
    mov     bx, 332 ;            996                 ; offset for approximately the middle of the screen

    mov     word [es:bx+0], 0x4254  ; T dark blue background, white font
    mov     word [es:bx+2], 0x4261  ; a dark blue background, white font
    mov     word [es:bx+4], 0x4273  ; s dark blue background, white font
    mov     word [es:bx+6], 0x426b  ; k dark blue background, white font
    mov     word [es:bx+8], 0x4220  ; space 
    mov     word [es:bx+10], 0x4241 ; A
    mov     word [es:bx+12], 0x4221 ; !

    call    _restore
    ;call    _yield
    jmp     .loop_forever

_task_b:
.loop_forever:
    call    _semaphore
    mov     ax, 0xB800
    mov     es, ax                  ; moving directly into a segment register is not allowed
    mov     bx, 100 ;            996                 ; offset for approximately the middle of the screen

    mov     word [es:bx+0], 0x2454  ; T dark blue background, white font
    mov     word [es:bx+2], 0x2461  ; a dark blue background, white font
    mov     word [es:bx+4], 0x2473  ; s dark blue background, white font
    mov     word [es:bx+6], 0x246b  ; k dark blue background, white font
    mov     word [es:bx+8], 0x2420  ; space 
    mov     word [es:bx+10], 0x2442 ; B
    mov     word [es:bx+12], 0x2421 ; !
    
    call    _restore
    ;call    _yield
    jmp     .loop_forever

; _task_c:
; .loop_forever:
    ; call    _semaphore
    ; mov     ax, 0xB800
    ; mov     es, ax                  ; moving directly into a segment register is not allowed
    ; mov     bx, 800 ;            996                 ; offset for approximately the middle of the screen

    ; mov     word [es:bx+0], 0x2454  ; T dark blue background, white font
    ; mov     word [es:bx+2], 0x2461  ; a dark blue background, white font
    ; mov     word [es:bx+4], 0x2473  ; s dark blue background, white font
    ; mov     word [es:bx+6], 0x246b  ; k dark blue background, white font
    ; mov     word [es:bx+8], 0x2420  ; space 
    ; mov     word [es:bx+10], 0x2443 ; C
    ; mov     word [es:bx+12], 0x2421 ; !
    
    ; call    _restore
    ; ;call    _yield
    ; jmp     .loop_forever

; _task_d:
; .loop_forever:
    ; call    _semaphore
    ; mov     ax, 0xB800
    ; mov     es, ax                  ; moving directly into a segment register is not allowed
    ; mov     bx, 1500 ;            996                 ; offset for approximately the middle of the screen

    ; mov     word [es:bx+0], 0x2454  ; T dark blue background, white font
    ; mov     word [es:bx+2], 0x2461  ; a dark blue background, white font
    ; mov     word [es:bx+4], 0x2473  ; s dark blue background, white font
    ; mov     word [es:bx+6], 0x246b  ; k dark blue background, white font
    ; mov     word [es:bx+8], 0x2420  ; space 
    ; mov     word [es:bx+10], 0x2444 ; D
    ; mov     word [es:bx+12], 0x2421 ; !
    
    ; call    _restore
    ; ;call    _yield
    ; jmp     .loop_forever

_spawn_new_task:
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
    pushf
    push    cs
    push    si                      ; push stuff
    pusha
    mov     [bx], sp                ; save new stack's new pointer
    mov     sp, [stack_pointers]    ; change back to main
    ret

;Custom_Timer that yields for us instead of each task doing it seperately.
;hopefully will scrunch code.
_timer:
    ; ret already saved by call
    pusha
    ;pushf
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
    ;popf
    popa
    ;call    _semaphore
    ;call _yield     ;we can switch tasks here if possible to switch them
    jmp     far [cs:calc_8_offset]  ; don't ever forget that since we want 
                                    ; to keep firing our interrupt

 _semaphore:      ;I like the name; this also known as a lock
    push    ax
    mov     ax, 0
    jmp     .check
.fire:
    int     0x8
.check:
    xchg    [semaph], ax           ;swap the two values
    cmp     ax, 0                  ;check to see if semaphore is 0
    je      .fire                  ;if not, meaning that there is task using it, fire the interrupt
    pop     ax   
	ret
    
_restore:           ;sets the semaphore back to 1 to make it available
    push    ax
    mov     ax, 1
    xchg    [semaph], ax
    pop     ax
    int     0x8     ;we need to make sure we have something else take the semaph before exiting
    ret 


; _yield:
    ; ; ret already saved by call
    ; pusha
    ; pushf
    ; movzx   cx, byte [current_task]
    ; ; save current stack pointer
    ; lea     bx, [stack_pointers]
    ; add     bx, cx
    ; add     bx, cx
    ; mov     [bx], sp
    ; ; loop through stack status looking for a 1
    ; lea     bx, [stack_status]
    ; add     bx, cx                  ; make sure we start looking at next task
; .loop:
    ; inc     bx
    ; inc     cx
    ; cmp     cx, 4                   ; increment this for more tasks
    ; jl      .continue
    ; xor     cx, cx                  ; clear cx
    ; lea     bx, [stack_status]      ; reset bx back to start
; .continue:
    ; cmp     byte [bx], 1            ; is this stack active
    ; je      .found_one
    ; jmp     .loop
; .found_one:
    ; mov     [current_task], cl
    ; ; switch to new stack
    ; lea     bx, [stack_pointers]
    ; add     bx, cx
    ; add     bx, cx
    ; mov     sp, [bx]
    ; popf
    ; popa
    ; ret

;takes an address to write to in si
;writes to address until a null term is encountered
;returns nothing
_putstring:
    mov     ah, 0xE             ; interrupt setup
.continue:
    lodsb                       ; put char to write in al
    test    al, al              ; simulate and
    je      .done               ; was al 0?
    int     0x10                ; call interrupt
    jmp     _putstring
.done:
    ret