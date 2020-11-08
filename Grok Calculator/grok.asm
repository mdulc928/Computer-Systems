;File: grok.asm
;Author: Melchisedek Dulcio (mdulc928)
;Desc:    Contains implementation of the grok calculator

;stack implementation:


%macro push_s 1
    mov        rcx, %1
    call    _push
%endmacro


%macro pop_s 0
    call    _pop
%endmacro                            


%macro    peek_s 2
    lea        rcx, [%1]
    mov        rdx, [%2]
    call    _peek
%endmacro

;Dr. McGee
%macro    str_peek_s 2
    lea        rcx, [%1]
    mov        rdx, [%2]
    call    _str_peek
%endmacro


; ;Will also need operation macros for operations


; %macro multi
    ; pop_s
    ; r
; %endmacro


; %macro div_s 2
; %endmacro


%macro add_s 0
    pop_s
    mov        r12, rax
    pop_s
    mov        r13, rax
    ;sub        eax, 512
    add        rax, r12
    
    mov        r14, rax
    
    ; mov        rcx, strT_fmt6
    ; mov        rdx, r12
    ; mov        r8, r13
    ; mov        r9, r14
    ; call    printf
    
    push_s    r14
%endmacro


%macro sub_s 0
    ; pop_s
    ; mov        r12, rax
    ; pop_s
    ; sub        rax, r12
    ; push_s    rax
    
    pop_s
    mov        r12, rax
    pop_s
    mov        r13, rax
    ;sub        rax, 512
    sub        r12, rax   
    mov        r14, r12
    
    ; mov        rcx, strT_fmt6
    ; mov        rdx, r12
    ; mov        r8, r13
    ; mov        r9, r14
    ; call    printf
    
    push_s    r14
%endmacro


%macro not_s 0
    pop_s
    mov        r12, rax
    ;sub        rax, 512
    neg        rax
    
    mov        r13, rax
    
    ; mov        rcx, strT_fmt7
    ; mov        rdx, r12
    ; mov        r8, r13
    ; call    printf
    
    push_s    r13
%endmacro


;Macro for stack frames
%macro sub_sf 0
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
%endmacro


%macro add_sf 0
    mov     rsp, rbp
    pop     rbp
%endmacro



default rel


extern printf, gets, isdigit, isalpha, strlen, calloc


section .data
    ;supported operators
    str_opr: db        "+-~", 10, 0
    
    ;base 19 Chars
    str_b19: db        "0123456789ABCDEFGHI", 10, 0
    
    ;fromBase19 vars: haven't actually used them
    num_f19: dq        0
    cnt_f19: dq        0
    l_f19:   dq        0    
    c_f19:   db        0
    
    ;stack manipulation
    opr_top: dq        0        ;how many items on stack currently
    len_inp: dq        0        ;length of input string
    
    ;console or prompt messages
    str_prmt:   db    "> ", 0
    str_close:  db    "Thank you for visiting Earth. We hope you make it back safely.", 13, 10, 0
    
    str_fmt:    db    "%s", 13, 10, 0
    str_fmt2:   db    "%d", 13, 10, 0
    
    ; ;testing: not actually necessary but will use these for testing stages
    ; strT_fmt:    db     "last: %c value: %d", 13, 10, 0
    ; ;strT_fmtv:    db    "value: %d", 13, 10, 0
    ; strT_fmt2:    db    "stack:%c length: %d Input: %c", 13, 10, 0
    ; strT_fmt3:    db     "In add now: %c", 13, 10, 0
    ; strT_fmt4:    db     "In sub now: %c", 13, 10, 0
    ;strT_fmt5:    db     "In not now: %c", 13, 10, 0    
    ; strT_fmt6:    db     "First Pop: %d, Second Pop: %d Result: %d", 13, 10, 0
    ; strT_fmt7:    db     "First Pop: %d Result: %d", 13, 10, 0
    
section .bss
    ;TODO: Finish at least converter by this weekend. So you
    ; you can work on actually finishing the rest.
    
    str_inp:    resb 80
    opr_stk:    resq 640        ;operation stack
section .text


global _Handle_Opers
_Handle_Opers:
    ;DOC|    rcx: value to convert
    mov        bl, cl
    mov        rdi, str_opr
    cld
    mov        al, cl
    
    mov        rcx, 3
    repne      scasb
    
    mov        rax, 3
    sub        rax, rcx
    sub        rax, 1
    
    cmp        rax, 2
    je        .checkNeg
    jmp        .endho
.checkNeg:
    cmp        bl, '~'
    je        .endho
    mov        rax, -1    
.endho:
    ret


; global _To_base_19
; _To_base_19:    
    


global _From_base_19
_From_base_19:
    ;DOC|    rcx: value to convert
    mov        bl, cl
    mov        rdi, str_b19
    cld
    mov        al, cl
    
    mov        rcx, 19
    repne    scasb
    
    mov        rax, 19
    sub     rax, rcx
    sub        rax, 1
    
    cmp        rax, 18
    je        .checkI
    jmp        .endfb19
.checkI:
    cmp        bl, 'I'
    je        .endfb19
    mov        rax, -1    
.endfb19:
    ret
    
global _push
_push:
    ;DOC| rcx: value to be pushed
    lea        rax, [opr_stk]    
    mov        rdx, rcx    
    mov        rcx, [opr_top]    
    mov        [rax + rcx * 8], rdx
    inc        qword[opr_top]
    
    ret
    
global _pop
_pop:
    peek_s        opr_stk, opr_top
    dec            qword[opr_top]    
    ret
    
global _peek
_peek:
    mov        rax, rcx
    mov        rcx, rdx
    sub        rcx, 1
    mov        rax, [rax + rcx * 8]
    
    ret

global _str_peek
_str_peek:
    mov        rax, rcx
    mov        rcx, rdx
    sub        rcx, 1
    mov        rax, [rax + rcx]
    
    ret

global main:
main:
    sub_sf    
.do:
    mov        rdi, 640
    call    calloc    
    mov        [opr_stk], rax            ;allocated memory using calloc
    
    mov        rcx, str_prmt
    call     printf                ;print little carrot at the beginning of each prompt
    
    lea        rcx, [str_inp]
    call    gets                ;read input
    
    mov        rcx, str_inp
    call    strlen                ;get length of string
    
    mov        [len_inp], rax        ;store length of string
    
    
    cmp        qword [len_inp], 0
    je        .endDo                ;jmp to end if nothing is in stream
    
    ; lea        rcx, [str_inp]
    ; mov        rdx, [len_inp]
    ; call    _peek
    
    str_peek_s        str_inp, len_inp
    
.iterate:    
    str_peek_s    str_inp, len_inp    
    mov            rbx, rax                ;store the last value in string input in rbx to free rax
    
    mov            rcx, rax            
    call        _From_base_19            ;convert the single character into decimal number
    add            rax, 1
    cmp            rax, 0
    je            .handler
    sub            rax, 1


    push_s        rax                        ;push decimal value onto operation stack
    peek_s      opr_stk, opr_top
    ; mov            r8, rax
    ; mov            rdx, rbx
    ; mov            rcx, strT_fmt
    ; call        printf                    ;print prime and converted values
    
    ;pop_s                            ;pop off the value once 
    jmp            .finishIter
.handler:
    mov        rcx, rbx
    call    _Handle_Opers
    
    add        rax, 1
    cmp        rax, 0    
    je        .finishIter
    cmp        rax, 3
    je        .handleMantis
    cmp        rax, 2
    je        .handleSub
.handleAdd:
    ; mov        rcx, strT_fmt3
    ; mov        rdx, rbx
    ; call    printf
    add_s
    jmp        .finishIter
.handleSub:
    ; mov        rcx, strT_fmt4
    ; mov        rdx, rbx
    ; call    printf
    sub_s
    jmp        .finishIter
.handleMantis:
    ; mov        rcx, strT_fmt5
    ; mov        rdx, rbx
    ; call    printf
    not_s
    ;jmp        .finishIter


.finishIter:
    dec            qword[len_inp]
    cmp            qword[len_inp], 0        ;check if you are done reading the input into the output
    jne            .iterate
    
    peek_s        opr_stk, opr_top
    
    mov        rcx, str_fmt2
    mov        rdx, rax
    call    printf
    
    jmp        .do


    
.endDo:
    mov        rcx, str_close
    call    printf
    
    add_sf
 





