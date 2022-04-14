start: in AL,00h;110
cmp al, 0
jz zerocandstart
cmp al, cl ; same thing?
jz start
mov cl, al
xor al, ah
out 00h,AL;112, AL
mov ah, al
;mov AL, 0
jmp start
zerocandstart:
mov cl, 0
jmp start