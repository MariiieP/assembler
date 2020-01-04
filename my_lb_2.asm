.model tiny                   ;������ tiny ������������� ��� �������� ������ ���� com
.code	                      ;��� ��������� �������� ������� ����
org 100h                      ;������� ������������� �������� �������� � 100h                             
 
Start:	
 

;���� ���-�� ��������� �������   

    ;���� ���������  '������� ������'
	mov	ah,09h              ;����� ������� � dos- � AH ������� ������ �� �����
	lea	dx,text1            ;������ ��������� '������� ������'
	int	21h	                ;����� �������  
	  
	;���������� ���������� ����� � ax � ��������� ��� � n  
    call ReadInteger		;���� � ���������, ������������ � int 
	mov	n,ax				;��������� ����� ��������� �������
    
    ;������� ������
	mov ah,09h			  
	lea dx,crlf
	int 21h   
	
	;���� ���������  'n='
	mov ah,09h    			
	lea dx,resn             ;������-��������� 'n='
	int 21h   
	
    ;����� n
    mov ax,n                ;�������� n � ax
    call WriteInteger		;�������������� � ������ � ����� �� �����
    
    ;������� ������
	mov ah,09h				
	lea dx,crlf
	int 21h  
	
;���� ��������� �������      
	lea	di,mas			    ;����� ������� ��������    
    ;���� ���������  '������� ��������'
	mov	ah,09h
	lea	dx,text2            ;��������� '������� ��������'
	int	21h                 
	
	mov	bx,0	
	
masi: 
    call ReadInteger		;���� � ���������, ������������ � int 

	mov	[di],ax				;���������� ������� �������
	add	di,2				;���������� ������ ���������� ��������
    
    ;������� ������
	mov ah,09h
	lea dx,crlf
	int 21h

	inc	bx                  ;����������� bx
	cmp	bx,n                ;���������� � n 
	jb	masi                ;���� bx < n - ���������� �������. ���� �� ����� �������

;����� ��������� �������	
	lea	di,mas			
	mov	ah,09h
	lea	dx,text3            ;��������� '������'
	int	21h         	
	mov	bx,0   
	
maso:
	mov ax,[di]             ;���������� ������ ������� �������
	add	di,2				;��������
    call WriteInteger		;�������� �����
           
    ;������� ������
	mov ah,09h				
	lea dx,crlf
	int 21h

	inc	bx                  ;����������� bx
	cmp	bx,n                ;���������� � n 
	jb	maso                ;���� bx < n - ���������� ��������. ���� �� ����� �������

    ;��������� ��������� � �����
	lea	bp,mas
	push bp
	mov	bp,n
	push bp
     
    ;����� �������� ���������
	call work	
	ret	  
	
;������� ���������
work proc 

    push bp				;��������� bp
    mov bp, sp
    push ax				;��������� �������� 
    push cx
    push dx
    push si	
	 
	mov di, [bp+4]   ;������� � cx ����� ������� (��������� � ��������)
	mov cx, di
	
	mov di,[bp+6]    ;������� � si ��������� �� ������ �������
	mov si, di 
	

initial: 
  cmp cx,0
  je NO
  mov ax,[si]   
  add si,2
  mov bx,[si]      
  add si,2  
  

check:                
mov dx,[si]  
add si,2     
dec cx     
add ax,bx
cmp ax,dx 

jne NO        ;if cmp <> 0  
cmp [si],0    ;���� ����� �� ����� �������              
je Yes  
jne comp
jmp check
  
comp: 
mov ax,bx     ;  last = current   
mov bx,dx    ;  current = next
jmp CHECK
 
     
YES:
mov ah,9
mov dx,offset StrYes
int 21h   
jmp Final 
 
NO:
mov ah,9
mov dx,offset StrNo
int 21h
jmp Final 
                 
Final: 
	pop si
	pop dx		        ;��������������� ��������
	pop cx
	pop ax
	mov sp, bp
	pop bp
	mov ah,4ch	     
	
work EndP 	                                                          


;���� ����� � ax    

ReadInteger proc  
	push cx            ;��������� �������
	push bx
 	push dx 
 	mov fl,0           ;���� �������������� �����
 	xor cx, cx  
 	mov bx, 10 
  	call ReadChar      ;���� ������� �������, ��������� � ��������� ��������� ������ ����� 

 	cmp al,'-'         ;���� ����� 
 	je nnn             ;�� � ����� nnn ������������� ����
 	
	jmp nn             ;���� ��� �� � ����� nn
	
;������������� ���� �������������� �����
nnn:
 	mov fl,1

;���� ���������� �������    
read:  
 	call ReadChar      ;��������� � ��������� ��������� ������ ����� 

 	
nn: cmp al, 13        ;Enter ?
    je done           ;���� ��, �� ����������
    
    sub al, '0'       ;���� ���, �� ������� �� ������� � int
    xor ah, ah  
    xor dx, dx   
    xchg cx, ax  
    mul bx  
    add ax, cx  
    xchg ax, cx   
    	
    jmp read          ;���� ���������� �������, ����� ������� ����������� ���� ��

done:  
    xchg ax, cx  
    cmp fl,1          ;���� ���� ���� ��������������
    je negat          ;��������� � ����� negat � ������ ��� �������������
    	
    jmp norm          ;����� � ����� norm  
    	
;������  ����� �������������
negat:
    neg ax    
    	
norm: 
 	pop dx            ;��������������� ��������
    pop bx  
    pop cx 
    ret  
ReadInteger endp  

; ���� ������ �������  
ReadChar proc  
    	mov ah,1 
    	int 21h 
    	ret  
ReadChar endp

 
;����� �����
WriteInteger proc near 
    push ax           ;��������� ��������
    push cx  
    push bx  
    push dx  
    xor cx, cx  
    mov bx, 10     
    
;�������� �� ���������������   
    cmp ax,0
    jl ddd	          ;��    
    jmp divl	      ;���   
    
;������� ����� � �������� ����
ddd:
    push ax
    mov dl, '-'  
    mov ah, 2  
    int 21h
    pop ax
    neg ax  

;�������� 10-����� � ��������� �� � ����,
;� cx - ���������� ���������� ����
divl:  
    xor dx, dx  
    idiv bx  
    push dx  
    inc cx  
    cmp ax,0         ;if ax > 0 - ���������� ��������������
    jg  divl  

;������� �� �����, ��������� � ��� ASCII � �������
popl:  
    pop ax  
    add al, '0'      ;�������������� � ������
    call WriteChar   ;��������� � ��������� ������ ������ �������
    loop popl  

    pop dx           ;��������������� ��������
   	pop bx  
    pop cx  
   	pop ax 
    ret  
WriteInteger endp  

;����� ������ ������� 
WriteChar proc  
    push ax  
    push dx  
    mov dl, al  
    mov ah, 2  
    int 21h  
    pop dx  
    pop ax  
    ret
WriteChar endp      
                                                                

jmp Start   

n	dw	10		;����� ��������� �������
fl 	dw 	?		;���� �������������� �����

StrYes db "Fib: YES",13,10,"$"     
StrNo db "Fib: NO",13,10,"$"       

text1	db	'input size  ','$'
text2	db	'input elem',0dh,0ah,'$'
text3	db	'array',0dh,0ah,'$'

resn	db	'n= ','$'
res	db	'   ','$'
crlf	db  0dh,0ah,'$'

mas	dw	50 DUP(?)

end _START   

ret