;Phase Beta
;
; ;

; %macro push_s 1
    ; mov     	dx, %1
    ; call    	_push
; %endmacro


; %macro pop_s 0
    ; call    	_pop
; %endmacro                            


; %macro    peek_s 2
    ; lea        cx, [%1]
    ; mov        dx, [%2]
    ; call    	_peek
; %endmacro

; ;Dr. McGee
; %macro    str_peek_s 2
    ; lea        	cx, [%1]
    ; mov        	dx, [%2]
    ; call    	_str_peek
; %endmacro

; ;---------------------------------------Calculate ----------------------------------------

; %macro add_s 0
	; push 
    ; pop_s
    ; mov        di, ax
    ; pop_s
    ; ;mov        si, ax
    ; ;sub        eax, 512
    ; add        ax, di
    
    ; mov        dx, ax
    
    ; ; mov        rcx, strT_fmt6
    ; ; mov        rdx, r12
    ; ; mov        r8, r13
    ; ; mov        r9, r14
    ; ; call    printf
    
    ; push_s    dx
; %endmacro


; %macro sub_s 0
    ; ; pop_s
    ; ; mov        r12, rax
    ; ; pop_s
    ; ; sub        rax, r12
    ; ; push_s    rax
    
    ; pop_s
    ; mov        di, ax
    ; pop_s
    ; ;mov        r13, rax
    ; ;sub        rax, 512
    ; sub        di, ax 
    ; ;mov        r14, di
    
    ; ; mov        rcx, strT_fmt6
    ; ; mov        rdx, r12
    ; ; mov        r8, r13
    ; ; mov        r9, r14
    ; ; call    printf
    
    ; push_s    di
; %endmacro


; %macro not_s 0
    ; pop_s
    ; mov        di, ax
    ; ;sub        rax, 512
    ; neg        ax
    
    ; mov        dx, ax
    
    ; ; mov        rcx, strT_fmt7
    ; ; mov        rdx, r12
    ; ; mov        r8, r13
    ; ; call    printf
    
    ; push_s    dx
; %endmacro


bits 16

org 0x100

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

    stacks times 256 * 2 db 0

    stack_pointers:
        dw 0 ; this is for Main
        dw stacks + 256
        dw stacks + 512
    
    ;supported operators
    str_opr 	db        "+-~", 10, 0			;used
    
    ;base 19 Chars
    str_b19 	db        "0123456789ABCDEFGHI", 10, 0		;used

     ;stack manipulation
    opr_top 	dw        0        ;how many items on stack currently			;used
    len_inp 	dw        0        ;length of input string						;used
    
    ;console or prompt messages
    str_prmt:   db    "> ", 0
    str_close:  db    "Thank you for visiting Earth. We hope you make it back safely.", 13, 10, 0
    
    str_fmt	   	db    "%s", 13, 10, 0
    str_fmt2   	db    "%d", 13, 10, 0

    
    str_inp    	times 80 db 80						;Probably not going to use.
    opr_stk    	times 256 * 3 db 0        	;operation stack
	
	;input_buff	times 32 db 0				;use this instead of str_inp


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

    ; lea     di, [_task_c]
    ; call    _spawn_new_task

    ; lea     dx, [_task_d]
    ; call    _spawn_new_task

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
    
    call    _yield
    jmp     .loop_forever

_task_a:
.loop_forever:
    .do:
        ; mov        di, 640
		; call    calloc    
		; mov        [opr_stk], rax            ;allocated memory using calloc
		lea		bx, [opr_stk]
		xor		bx, bx
		
		
        mov     dx, str_prmt
        call    _puts                ;print little carrot at the beginning of each prompt
        
        mov     dx, str_inp
		mov		cx, 32
        call    _gets               ;read input
        
        ; mov     cx, si			;stored the length of the input string in si instead	
      ; ; call    strlen           ;get length of string
        
        ; mov     [len_inp], rax        ;store length of string
        
        
        cmp     si, 0 				;qword [len_inp], 0
        je      .endDo              ;jmp to end if nothing is in stream
        
        ; str_peek_s        str_inp, len_inp
        
    ; .iterate:    
        ; str_peek_s    str_inp, len_inp    
        ; mov            bx, ax                ;store the last value in string input in rbx to free rax
        
        ; mov            cx, ax            
        ; call        _From_base_19            ;convert the single character into decimal number
        ; add            ax, 1
        ; cmp            ax, 0
        ; je            .handler
        ; sub            ax, 1


        ; push_s        ax                        ;push decimal value onto operation stack
        ; peek_s      opr_stk, opr_top
        ; ; mov            r8, rax
        ; ; mov            rdx, rbx
        ; ; mov            rcx, strT_fmt
        ; ; call        printf                    ;print prime and converted values
        
        ; ;pop_s                            ;pop off the value once 
        ; jmp            .finishIter
    ; .handler:
        ; mov     cx, bx
        ; call    _Handle_Opers
        
        ; add        ax, 1
        ; cmp        ax, 0    
        ; je        .finishIter
        ; cmp        ax, 3
        ; je        .handleMantis
        ; cmp        ax, 2
        ; je        .handleSub
    ; .handleAdd:
        ; ; mov        rcx, strT_fmt3
        ; ; mov        rdx, rbx
        ; ; call    printf
        ; ;add_s
        ; jmp        .finishIter
    ; .handleSub:
        ; ; mov        rcx, strT_fmt4
        ; ; mov        rdx, rbx
        ; ; call    printf
        ; sub_s
        ; jmp        .finishIter
    ; .handleMantis:
        ; ; mov        rcx, strT_fmt5
        ; ; mov        rdx, rbx
        ; ; call    printf
        ; not_s
        ; ;jmp        .finishIter


    ; .finishIter:
        ; dec            dword[len_inp]
        ; cmp            dword[len_inp], 0        ;check if you are done reading the input into the output
        ; jne            .iterate
        
        ; peek_s      opr_stk, opr_top
        
        ; mov     	cx, str_fmt2
        ; mov    		dx, ax
        ; call    	_puts
        
        ; jmp        	.do


        
     .endDo:
        mov     dx, str_close
        call    _puts
        
		popa
		popf
 
    ; mov     ax, 0xB800
    ; mov     es, ax                  ; moving directly into a segment register is not allowed
    ; mov     bx, 332 ;            996                 ; offset for approximately the middle of the screen

    ; mov     word [es:bx+0], 0x4254  ; T dark blue background, white font
    ; mov     word [es:bx+2], 0x4261  ; a dark blue background, white font
    ; mov     word [es:bx+4], 0x4273  ; s dark blue background, white font
    ; mov     word [es:bx+6], 0x426b  ; k dark blue background, white font
    ; mov     word [es:bx+8], 0x4220  ; space 
    ; mov     word [es:bx+10], 0x4241 ; A
    ; mov     word [es:bx+12], 0x4221 ; !

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


;PN Calculator------------------------------------------------------------------------------------------------------------
; _Handle_Opers:      ;handles operations for the calculator
    ; pusha
    ; pushf
    ; ;DOC|    rcx: value to convert
    ; mov        bl, cl
    ; mov        di, str_opr
    ; cld
    ; mov        al, cl
    
    ; mov        cx, 3
    ; repne      scasb
    
    ; mov        ax, 3
    ; sub        ax, cx
    ; sub        ax, 1
    
    ; cmp        ax, 2
    ; je        .checkNeg
    ; jmp        .endho
; .checkNeg:
    ; cmp        bl, '~'
    ; je        .endho
    ; mov        ax, -1    
; .endho:
    ; popa
    ; popf
    ; ret

; _From_base_19:          ;converts input to base 10;
    ; ;DOC|    rcx: value to convert
    ; pusha
    ; pushf
    ; mov        bl, cl
    ; mov        di, str_b19
    ; cld
    ; mov        al, cl
    
    ; mov        cx, 19
    ; repne      scasb
    
    ; mov        ax, 19
    ; sub        ax, cx
    ; sub        ax, 1
    
    ; cmp        ax, 18
    ; je         .checkI
    ; jmp        .endfb19
; .checkI:
    ; cmp        bl, 'I'
    ; je        .endfb19
    ; mov        ax, -1    
; .endfb19:
    ; popf
    ; popa
    ; ret

; _push:
    ; pusha
    ; pushf
    ; ;DOC| rcx: value to be pushed
    ; lea     bx, [opr_stk]
	; add		bx, [opr_top]			;increase index by top
	; mov		word[bx], cx
	; ; ;			dx, cx  			;  
    ; ; mov        cx, [opr_top]   
    ; ; mov        [ax + cx * 8], dx
    ; inc     word[opr_top]

    ; popf
    ; popa
    
    ; ret

; _pop:
    ; pusha
    ; pushf
    ; peek_s        opr_stk, opr_top
    ; dec           dword[opr_top]
    ; popf
    ; popa    
    ; ret

; _peek:
    ; pusha
    ; pushf
    ; mov        bx, cx
    ; mov        cx, dx
    ; sub        cx, 1
	; add		   bx, cx						;index into the array
    ; ;mov        ax, [ax + cx * 8]
    
    ; popf
    ; popa

    ; ret

; _str_peek:
    ; push		bx

    ; mov        	bx, cx
    ; mov        	cx, dx
    ; sub        	cx, 1
	; add		   	bx, cx
; ;    mov        ax, [ax + cx]
    
    ; popf
    ; popa

    ; ret

;------------------------------------------Utility Functions------------------------------------------------------------

_puts:					;prints characters
	push	ax
	push	cx
	push	si
	
	mov	ah, 0x0e
	mov	cx, 1		; no repetition of chars
	
	mov	si, dx
.loop:	mov	al, [si]
	inc	si
	cmp	al, 0
	jz	.end
	int	0x10
	jmp	.loop
.end:
	pop	cx
	pop	ax
	ret


_gets:				;reads characters from keyboard input
	cmp	cx, 1
	ja	.ok
	xor	ax, ax
	ret
.ok:
	push 	si
	push	di
	push	cx
	
	xor	si, si
	mov	di, dx
	dec	cx		; Reserve space for NUL
.loop:
	mov	ah, 0x10
	int	0x16
	cmp	al, 13		; Stop on CR (Enter key)
	je	.gotcr
	
	push	cx		; Echo entered character
	mov	cx, 1
	mov	ah, 0x1e
	int	0x10
	pop	cx
	
	mov	[di], al	; Stash entered character
	inc	di
	inc	si
	loop	.loop
.flush:
	cmp	al, 13		; Read (and drop) chars until we get a CR
	je	.gotcr		; (This happens if we run out of room before CR)
	mov	ah, 0x10
	int	0x16
	
	push	cx		; Echo entered character
	mov	cx, 1
	mov	ah, 0x1e
	int	0x10
	pop	cx
	
	jmp	.flush

.gotcr:	mov	byte [di], 0	; Tack on the NUL
	
	mov	ax, 0x0e0a	; Always emit a CRLF pair
	mov	cx, 1
	int	0x10
	mov	al, 13
	int	0x10
	
	mov	ax, di		; Compute &end - &start - 1 (number of non-NUL chars)
	sub	ax, dx
	
	pop	cx
	pop	di
	ret

