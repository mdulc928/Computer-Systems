;Phase Beta
;
;

bits 16

org 0x0

;I find it interesting that we can have a named operation,
;not necessarily a variable. hm...
real_8_offset       equ    4 * 8
real_8_segment      equ     real_8_offset + 2

section .rdata
    main_str:       db "I am task main", 13, 10, 0
    main_a:         db "I am task a", 13, 10, 0
    main_b:         db "I am task b", 13, 10, 0

section .data

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

section .text
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

    lea     di, [_task_c]
    call    _spawn_new_task

    lea     dx, [_task_d]
    call    _spawn_new_task

.loop_forever:
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

    call    _startmusic
    
    call    _yield
    jmp     .loop_forever

_task_a:
.loop_forever:
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

    call    _yield
    jmp     .loop_forever

_task_b:
.loop_forever:
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
    
    call    _yield
    jmp     .loop_forever

_task_c:
.loop_forever:
    mov     ax, 0xB800
    mov     es, ax                  ; moving directly into a segment register is not allowed
    mov     bx, 800 ;            996                 ; offset for approximately the middle of the screen

    mov     word [es:bx+0], 0x2454  ; T dark blue background, white font
    mov     word [es:bx+2], 0x2461  ; a dark blue background, white font
    mov     word [es:bx+4], 0x2473  ; s dark blue background, white font
    mov     word [es:bx+6], 0x246b  ; k dark blue background, white font
    mov     word [es:bx+8], 0x2420  ; space 
    mov     word [es:bx+10], 0x2443 ; C
    mov     word [es:bx+12], 0x2421 ; !
    
    call    _yield
    jmp     .loop_forever

_task_d:
.loop_forever:
    mov     ax, 0xB800
    mov     es, ax                  ; moving directly into a segment register is not allowed
    mov     bx, 1500 ;            996                 ; offset for approximately the middle of the screen

    mov     word [es:bx+0], 0x2454  ; T dark blue background, white font
    mov     word [es:bx+2], 0x2461  ; a dark blue background, white font
    mov     word [es:bx+4], 0x2473  ; s dark blue background, white font
    mov     word [es:bx+6], 0x246b  ; k dark blue background, white font
    mov     word [es:bx+8], 0x2420  ; space 
    mov     word [es:bx+10], 0x2444 ; D
    mov     word [es:bx+12], 0x2421 ; !
    
    call    _yield
    jmp     .loop_forever

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
    push    si                      ; push stuff
    pusha
    pushf
    mov     [bx], sp                ; save new stack's new pointer
    mov     sp, [stack_pointers]    ; change back to main
    ret

_yield:
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
    cmp     cx, 4                   ; increment this for more tasks
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

_startmusic:
    pusha
.A1:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 5423        ; Frequency number (in decimal)
                            ;  for middle A.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25          ; Pause for duration of note.
    jmp     .pause1

.pause1:
    mov     cx, 65535
.pause2:
    dec     cx
    jne     .pause2
    dec     bx
    jne     .pause1
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.

.G1:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 6087        ; Frequency number (in decimal)
                            ;  for G.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause3:
    mov     cx, 65535
.pause4:
    dec     cx
    jne     .pause4
    dec     bx
    jne     .pause3
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.

.F1:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 6833        ; Frequency number (in decimal)
                            ;  for F.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause5:
    mov     cx, 65535
.pause6:
    dec     cx
    jne     .pause6
    dec     bx
    jne     .pause5
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.

.G2:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 6087        ; Frequency number (in decimal)
                            ;  for G.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause7:
    mov     cx, 65535
.pause8:
    dec     cx
    jne     .pause8
    dec     bx
    jne     .pause7
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.

.A2:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 5423        ; Frequency number (in decimal)
                            ;  for A.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause9:
    mov     cx, 65535
.pause10:
    dec     cx
    jne     .pause10
    dec     bx
    jne     .pause9
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.

.A3:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 5423        ; Frequency number (in decimal)
                            ;  for A.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause11:
    mov     cx, 65535
.pause12:
    dec     cx
    jne     .pause12
    dec     bx
    jne     .pause11
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.

.A4:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 5423        ; Frequency number (in decimal)
                            ;  for A.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause13:
    mov     cx, 65535
.pause14:
    dec     cx
    jne     .pause14
    dec     bx
    jne     .pause13
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.


.G3:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 6087        ; Frequency number (in decimal)
                            ;  for G.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause15:
    mov     cx, 65535
.pause16:
    dec     cx
    jne     .pause16
    dec     bx
    jne     .pause15
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al 

.G4:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 6087        ; Frequency number (in decimal)
                            ;  for G.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause17:
    mov     cx, 65535
.pause18:
    dec     cx
    jne     .pause18
    dec     bx
    jne     .pause17
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al

.G5:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 6087        ; Frequency number (in decimal)
                            ;  for G.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause19:
    mov     cx, 65535
.pause20:
    dec     cx
    jne     .pause20
    dec     bx
    jne     .pause19
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al

.A5:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 5423        ; Frequency number (in decimal)
                            ;  for A.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause21:
    mov     cx, 65535
.pause22:
    dec     cx
    jne     .pause22
    dec     bx
    jne     .pause21
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al  

.C1:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 4560        ; Frequency number (in decimal)
                            ;  for C.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause23:
    mov     cx, 65535
.pause24:
    dec     cx
    jne     .pause24
    dec     bx
    jne     .pause23
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al  

.C2:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, 4560        ; Frequency number (in decimal)
                            ;  for C.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
    mov     bx, 25

.pause25:
    mov     cx, 65535
.pause26:
    dec     cx
    jne     .pause26
    dec     bx
    jne     .pause25
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al
