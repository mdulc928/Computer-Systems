bits 16
org 0x100

SECTION .text
main:
    mov     ax, 0xB800
    mov     es, ax                  ; moving directly into a segment register is not allowed
    mov     bx, 332 ;            996                 ; offset for approximately the middle of the screen

    mov     ah, 0x0
    mov     al, 0x1
    int     0x10                    ; set video to text mode

    mov     word [es:bx+0], 0x4254  ; T dark blue background, white font
    mov     word [es:bx+2], 0x4261  ; a dark blue background, white font
    mov     word [es:bx+4], 0x4273  ; s dark blue background, white font
    mov     word [es:bx+6], 0x426b  ; k dark blue background, white font
    mov     word [es:bx+8], 0x4220  ; space 
    mov     word [es:bx+10], 0x4241 ; A
    mov     word [es:bx+12], 0x4221 ; !

    mov     ah, 0x0                 ; wait for user input
    int     0x16

    mov     ah, 0x4c                ; exit
    mov     al, 0
    int     0x21