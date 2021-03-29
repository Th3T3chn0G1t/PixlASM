; SPDX-License-Identifier: GPL-3.0-or-later
; Copyright (C) 2021 TTG <prs.ttg+pixl@pm.me>
[org 0x7C00]
[bits 16]

%define SQR_X_ADR 0x7C00
%define SQR_Y_ADR 0x7C02

load:
    xor ah, ah
    mov al, 0x13
    int 0x10

    mov al, 0xF
    ; 0:0   5x200
        xor cx, cx
        xor dx, dx
        mov di, 5
        mov bx, 200
        call fill_rect
    ; 0:0   320x5
        mov bx, di
        mov di, 320
        call fill_rect
    ; 0:60  320x140
        mov dx, 35
        mov bx, 165
        call fill_rect
    ; 0:15  15x5
        mov dx, 15
        mov di, 15
        mov bx, 5
        call fill_rect
    ; 21:15 10x5
        mov cx, 21
        mov di, 15
        mov bx, 10
        call fill_rect
    ; 0:35  50x5
        xor cx, cx
        mov dx, 25
        mov di, 35
        mov bx, 5
        call fill_rect

    ; 15:0 5x20
        mov cx, 15
        xor dx, dx
        mov di, bx
        mov bx, 20
        call fill_rect
    ; 35:6 5x24
        mov cx, 35
        mov dx, 6
        mov di, 5
        mov bx, 24
        call fill_rect
    ; 45:6 5x29
        mov cx, 45
        mov dx, 6
        mov di, 5
        mov bx, 29
        call fill_rect
    ; 55:0 265x30
        mov cx, 55
        mov dx, 0
        mov di, 265
        mov bx, 35
        call fill_rect

    mov di, 5
    mov bx, di
    ; 30:20
        mov al, 0x4
        mov cx, 30
        mov dx, 20
        call fill_rect
    ; 50:5
        inc al
        add cx, dx
        mov dx, di
        call fill_rect
    ; 50:10
        inc al
        add dx, di
        call fill_rect
    ; 5:30
        inc al
        mov cx, di
        mov dx, 30
        call fill_rect
    ; 20:5
        inc al
        mov cx, 20
        mov dx, di
        call fill_rect
    ; 55:15
        inc al
        mov cx, 55
        mov dx, 15
        call fill_rect
    ; 10:35
        inc al
        mov cx, 10
        mov dx, 35
        call fill_rect

    mov cx, 7
    mov dx, 20
    mov word [SQR_X_ADR], cx
    mov word [SQR_Y_ADR], dx

    gameloop:
        xor ah, ah
        int 0x16

        mov si, SQR_X_ADR
        cmp al, 'd'
        jne .next_0
            call move_pos

        .next_0:
        cmp al, 'a'
        jne .next_1
            call move_neg

        .next_1:
        mov si, SQR_Y_ADR
        cmp al, 's'
        jne .next_2
            call move_pos
        
        .next_2:
        cmp al, 'w'
        jne .next_3
            call move_neg

        .next_3:
        cmp al, 'r'
        jne switch_end
            int 0x19
    switch_end:
        mov al, 0xF
        call set_pixel

        jmp gameloop

move_pos:
    inc word [si]
    call get_pixel
    dec word [si]
    ret
move_neg:
    dec word [si]
    call get_pixel
    inc word [si]
    ret

get_pixel:
    mov ah, 0x0D
    mov cx, [SQR_X_ADR]
    mov dx, [SQR_Y_ADR]
    int 0x10

    xor bx, bx

    cmp al, 0x4
    jne .next_0
        int 0x19
    .next_0:

    cmp al, 0x5
    jne .next_1
        mov cx, 6
    .next_1:

    cmp al, 0x6
    jne .next_2
        mov cx, 43
    .next_2:

    cmp al, 0x7
    jne .next_3
        mov cx, 50
    .next_3:

    pusha
    cmp al, 0x8
    jne .next_4
        xor al, al
        mov cx, 5
        mov dx, 15
        mov di, 1
        mov bx, 5
        call fill_rect
    .next_4:

    cmp al, 0x9
    jne .next_5
        xor al, al
        mov cx, 25
        mov dx, 20
        mov di, 5
        mov bx, 5
        call fill_rect
    .next_5:

    cmp al, 0xA
    jne .next_6
        xor al, al
        mov cx, 20
        mov dx, 20
        mov di, 5
        mov bx, 5
        call fill_rect
    .next_6:

    popa  
    .switch_end:

    mov word [SQR_X_ADR], cx

    cmp al, 0
    jz switch_end
    ret

; Fill a rectangle in the screen
; cx: x pos
; dx: y pos
; al: color
fill_rect:
    pusha
    mov si, cx
    add di, cx
    add bx, dx

    .loop_y:
        .loop_x:
            call set_pixel
            inc cx
            cmp cx, di
            jl .loop_x
        mov cx, si
        inc dx
        cmp dx, bx
        jl .loop_y
    popa
    ret

set_pixel:
    mov ah, 0x0C
    int 0x10
    ret

times 503 - ($ - $$) nop
credits:
    db "by TTG|"
magic:
    dw 0xAA55

; HEX     BIN       COLOR
; 0       0000      black
; 1       0001      blue
; 2       0010      green
; 3       0011      cyan
; 4       0100      red
; 5       0101      magenta
; 6       0110      orange
; 7       0111      light gray
; 8       1000      dark gray
; 9       1001      light blue
; A       1010      light green
; B       1011      light cyan
; C       1100      light red
; D       1101      light magenta
; E       1110      yellow
; F       1111      white
; G       0002      good night america
