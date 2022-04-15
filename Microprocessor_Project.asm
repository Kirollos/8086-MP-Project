;start:
;in AL,00h;110
;cmp al, 0
;jz zerocandstart
;cmp al, 11h ; 10001b
;jz counterinit
;cmp al, 12h ; 10010b
;jz counterinit
;cmp al, cl ; same thing?
;jz start
;mov cl, al
;xor al, ah
;out 00h,AL;112, AL
;mov ah, al
;jmp start
;zerocandstart:
;mov cl, 0
;jmp start

delayloop macro timedelay
    
    mov bx, timedelay
    dec bx
    nop
    jnz $-2
    
endm

init:           ;
mov ax, 05h     ;
mov bx, 0       ; Initialize the system by resetting all registers
mov cx, 0       ;
out 00h, AL     ; Count from five to zero as an indication for us
delayloop 03644h; to make sure that the Microprocessor successfully
dec al          ; initiated.
jnz $-11        ;
out 00h, AL     ;
     
start:     
in AL,00h
cmp al, 0
; if zero
jz $+6   ; next v
; if non zero   v
or cl, al    ;  v
jmp start    ;  v
cmp cl, 0    ;  <
jz start
cmp cl, 11h ; 10001b
jz counterinit
cmp cl, 12h ; 10010b
jz counterinit
mov al, cl
xor al, ah
out 00h,AL
mov ah, al
mov cl, 0
jmp start

     

; Counter code
    
    ; Counter exit code
    
    counterexit:
        mov cl, al
        mov ax, 0000h
        mov bx, 0000h
        jmp start      

    ; ------------------
; Counter main

counterinit:
;mov ah, al     ; 
;mov al, 0FFh   ; let the count start from last value
xchg ah, al     ;

    cmp ah, 12h ; Go to decrement loop if input = 12h / 10010b 
    jz loop_decrement;
    
loop_increment: ; Increment loop
     
;    mov bx, 0251ch;01644h   ; 
;    dec bx                  ;  Delay loop
;    nop                     ;
;    jnz $-2                 ;
    delayloop 0251ch
    
    xchg cx, ax                         ; Input command retrieved
    in al, 00h                          ; in case we have
    xchg ax, cx                         ; another cmd to exec. 
    
    cmp cx, 0130h ; unfreeze, jmp the loop  
    jz $+62

    cmp cx, 0180h ; frozen: inc +1
    jnz $+6;         ;>v
        inc al       ; v
        out 00h, al  ; v
                     ; v
    cmp cx, 0140h ; frozen: dec -1
    jnz $+6          ;>v
        dec al       ; v
        out 00h, al  ; v
                     ; v
    cmp cx, 0108h ; frozen: lsh (left shift)
    jnz $+6          ;>v
        shl al, 1    ; v
        out 00h, al  ; v
                     ; v
    cmp cx, 0104h ; frozen: rsh (right shift)
    jnz $+6          ;>v
        shr al, 1    ; v
        out 00h, al  ; v
                     ; v
    and ch, 01h         ; check frozen case, if true,
    jnz loop_increment  ; jump to loop_increment 
    
    cmp cl, 03h ; 11b   ; Terminate counting
    jz counterexit      ; if input = 03h / 0000 0011b
       
    cmp cl, 12h ; 10010b  ; Move counting to decrement mode
    jz loop_decrement     ; if input = 12h / 10010b 
    
    and cl, 20h ; freeze  ; Check if input = 0010 0000b
    jz $+5        ;>v     ; If true, activate freeze mode
    xor ch, 01h   ; v     ; using XOR operand.
                  ; v
inc al            ; <     ; Increment AL register (increment loop)
out 00h, al               ; Output to port 00h

cmp al, 0FFh              ; If counter did not reach 255 decimal
jnz loop_increment        ; yet, then jump back to loop_increment

;    mov bx, 03644h        ;
;        dec bx            ;  Delay loop
;        nop               ;
;        jnz $-2           ;   
    delayloop 03644h        
        
loop_decrement: ; Decrement loop

;    mov bx, 0251ch;01644h ;
;    dec bx                ; Delay loop
;    nop                   ;
;    jnz $-2               ;     
    delayloop 0251ch
    
    xchg cx, ax                         ; Input command retrieved
    in al, 00h                          ; in case we have
    xchg ax, cx                         ; another cmd to exec.

    cmp cx, 0130h ; unfreeze, jmp the loop
    jz $+68

    cmp cx, 0180h ; frozen: inc +1
    jnz $+6;         ;>v
        inc al       ; v
        out 00h, al  ; v
                     ; v
    cmp cx, 0140h ; frozen: dec -1
    jnz $+6          ;>v
        dec al       ; v
        out 00h, al  ; v
                     ; v
    cmp cx, 0108h ; frozen: lsh (left shift)
    jnz $+6          ;>v
        shl al, 1    ; v
        out 00h, al  ; v
                     ; v
    cmp cx, 0104h ; frozen: rsh (right shift)
    jnz $+6          ;>v
        shr al, 1    ; v
        out 00h, al  ; v
                     ; v        
        
    and ch, 01h         ; check frozen case, if true,
    jnz loop_decrement  ; jump to loop_decrement 
    
    cmp cl, 03h ; 11b   ; Terminate counting
    jz counterexit      ; if input = 03h / 0000 0011b     
    
    cmp cl, 11h ; 10010b    ; Move counting to decrement mode
    jz loop_increment      ; if input = 11h / 10001b
    
    and cl, 20h ; freeze  ; Check if input = 0010 0000b
    jz $+5        ;>v     ; If true, activate freeze mode
    xor ch, 01h   ; v     ; using XOR operand.
                  ; v
dec al            ; <     ; Decrement AL register (decrement loop)
out 00h, al               ; Output to port 00h

cmp al, 0                 ; If counter did not reach 0 decimal
jnz loop_decrement        ; yet, then jump back to loop_decrement

;mov al, 0                  ; TO BE REMOVED
;out 00h, al                ; ^^^^^^^^^^^^^


;    mov bx, 0251ch;01644h       ;
;    dec bx                      ; Delay loop
;    nop                         ;
;    jnz $-2                     ;
    delayloop 0251ch

cmp al, 0
jz loop_increment

jmp start
;mov al, 0
;out 00h, al                     


;delayloop proc
;    cmp bx, 0
;    jnz $+5          ;>v
;    mov bx, 0251ch   ; v
;                     ; v
;    dec bx      ;<   <<
;    nop         ; ^
;    jnz $-2     ;>^
;    ;ret
;    jmp bp
;delayloop endp
