; CpS 230 Lab : Alice B. College-Student (acoll555)
;---------------------------------------------------
; Warm-up lab exercise to introduce the basics of
; writing, building, and running IA-64 assembly code
; programs on Windows.
;---------------------------------------------------
default rel

; We use these functions (printf and scanf) from an external library
extern printf
extern scanf
;extern rand_s

; Begin the "data" section of our output OBJ file
section .data
	magic_Number: 	dq 53
	num_Guesses		dq 0
	your_Guess: 	dq 0
	fmt_G: 			dq "%d", 0
	
	str_Prompt:		dq "I'm thinking of a number between 1 and 100; what is it? ", 0
	str_R_Equals:	db "You guessed it in %d move(s)! Thanks for playing...", 13, 10, 0;
	str_R_Less:		db "Too low!", 13, 10, 0
	str_R_Greater:	db "Too high!", 13, 10, 0
	
; Begin the "code" section of our output OBJ file
section .text

; Mark the label "main" as an exported/global symbol
global main

; "main" marks the spot where our code actually is (i.e., calling "main()" takes you here)
main:
    ; Boilerplate "function prologue"
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32             ; create shared shadow space
	
.hiswhile:	
	mov 	rcx, str_Prompt
	call	printf
	
	mov 	rdx, your_Guess
	mov		rcx, fmt_G
	call 	scanf
	
	add		qword [num_Guesses], 1
	
	mov		rax, [magic_Number]
	cmp		qword [your_Guess], rax
	
	jl		.ifless
	jg		.ifgreater
	
.ifequals:
	mov 	rdx, [num_Guesses]
	mov 	rcx, str_R_Equals
	call 	printf
	jmp 	.end
	
.ifless:
	mov 	rcx, str_R_Less
	call 	printf
	
	jmp		.hiswhile
.ifgreater:
	mov 	rcx, str_R_Greater
	call 	printf
	
	jmp 	.hiswhile
.end:
    
    ; Boilerplate "function epilogue"/return
    mov     rsp, rbp
    pop     rbp
	ret
	
