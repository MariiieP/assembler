cseg segment      ;ystanavl segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg     ;kazdomu registry ykaz derectivy
org 100h          ; smehenie na 100bait
Start:            ; tozka vxoda v programmu
mov si,offset Array           ; zagruzaem adres (smezenie) massiva     

INITIAL:
lodsb
mov bl,al
lodsb
mov dl,al   

CHECK:
lodsb
cmp al,24h
je STRCOMP    ;if cmp == 0                   
mov cl,al
add bl,dl
cmp bl,cl
jne NO        ;if cmp <> 0
je COMP
jmp CHECK
 
 
COMP:
mov bl,dl     ;  last = current
mov dl,cl     ;  current = next
jmp CHECK
 
STRCOMP:
mov ah,9
mov dx,offset String1
int 21h
jmp YES
     
YES:
mov ah,9
mov dx,offset String2
int 21h
jmp EXIT
 
NO:
mov ah,9
mov dx,offset String1
int 21h
mov ah,9
mov dx,offset String3
int 21h
 
EXIT:
mov ah,10h
int 16h                        ; zavershenie programmi posle nazatiya luboi knopki
int 20h                        ; vihod is programmi
 
Array db 1,1,5,3,5,8,13,24h
String1 db '1,1,5,3,5,8,13.$'
String2 db 10, 13, 'FIB: YES$'
String3 db 10, 13, 'FIB: NO$'
cseg ends
end Start
