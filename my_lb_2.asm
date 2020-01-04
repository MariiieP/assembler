.model tiny                   ;модель tiny предназначена для создания файлов типа com
.code	                      ;эта директива начинает сегмент кода
org 100h                      ;команда устанавливает значеное счетчика в 100h                             
 
Start:	
 

;ввод кол-ва элементов массива   

    ;ввод подсказки  'введите размер'
	mov	ah,09h              ;номер функции в dos- в AH выводим строки на экран
	lea	dx,text1            ;строка подсказка 'введите размер'
	int	21h	                ;вызов функции  
	  
	;считывание введенного числа в ax и помещение его в n  
    call ReadInteger		;ввод с клавиатур, конвертирует в int 
	mov	n,ax				;запомнить число элементов массива
    
    ;перевод строки
	mov ah,09h			  
	lea dx,crlf
	int 21h   
	
	;ввод подсказки  'n='
	mov ah,09h    			
	lea dx,resn             ;строка-подсказка 'n='
	int 21h   
	
    ;вывод n
    mov ax,n                ;помещаем n в ax
    call WriteInteger		;преобразование в символ и вывод на экран
    
    ;перевод строки
	mov ah,09h				
	lea dx,crlf
	int 21h  
	
;ввод элементов массива      
	lea	di,mas			    ;адрес первого элемента    
    ;ввод подсказки  'Введите элементы'
	mov	ah,09h
	lea	dx,text2            ;подсказка 'Введите элементы'
	int	21h                 
	
	mov	bx,0	
	
masi: 
    call ReadInteger		;ввод с клавиатур, конвертирует в int 

	mov	[di],ax				;запоминаем элемент массива
	add	di,2				;подготовка адреса следующего элемента
    
    ;перевод строки
	mov ah,09h
	lea dx,crlf
	int 21h

	inc	bx                  ;увеличиваем bx
	cmp	bx,n                ;сравниваем с n 
	jb	masi                ;если bx < n - продолжаем вводить. Если не конец массива

;вывод элементов массива	
	lea	di,mas			
	mov	ah,09h
	lea	dx,text3            ;подсказка 'Массив'
	int	21h         	
	mov	bx,0   
	
maso:
	mov ax,[di]             ;запоминаем первый элемент массива
	add	di,2				;сдвигаем
    call WriteInteger		;печатаем число
           
    ;перевод строки
	mov ah,09h				
	lea dx,crlf
	int 21h

	inc	bx                  ;увеличиваем bx
	cmp	bx,n                ;сравниваем с n 
	jb	maso                ;если bx < n - продолжаем выводить. Если не конец массива

    ;сохранить параметры в стеке
	lea	bp,mas
	push bp
	mov	bp,n
	push bp
     
    ;вызов основной процедуры
	call work	
	ret	  
	
;главная процедура
work proc 

    push bp				;сохраняем bp
    mov bp, sp
    push ax				;сохраняем регистры 
    push cx
    push dx
    push si	
	 
	mov di, [bp+4]   ;заносим в cx длину массива (обращение к сегменту)
	mov cx, di
	
	mov di,[bp+6]    ;заносим в si указатель на начало массива
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
cmp [si],0    ;если дошли до конца массива              
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
	pop dx		        ;восстанавливаем регистры
	pop cx
	pop ax
	mov sp, bp
	pop bp
	mov ah,4ch	     
	
work EndP 	                                                          


;ввод числа в ax    

ReadInteger proc  
	push cx            ;сохраняем регистр
	push bx
 	push dx 
 	mov fl,0           ;флаг отрицательного числа
 	xor cx, cx  
 	mov bx, 10 
  	call ReadChar      ;ввод первого символа, обращение к процедуре прочтения одного числа 

 	cmp al,'-'         ;если минус 
 	je nnn             ;то в метке nnn устанавливаем флаг
 	
	jmp nn             ;если нет то к метке nn
	
;устанавливаем флаг отрицательного числа
nnn:
 	mov fl,1

;ввод следующего символа    
read:  
 	call ReadChar      ;обращение к процедуре прочтения одного числа 

 	
nn: cmp al, 13        ;Enter ?
    je done           ;если да, то завершение
    
    sub al, '0'       ;если нет, то перевод из символа в int
    xor ah, ah  
    xor dx, dx   
    xchg cx, ax  
    mul bx  
    add ax, cx  
    xchg ax, cx   
    	
    jmp read          ;ввод следующего символа, затем обратно возращаемся сюда же

done:  
    xchg ax, cx  
    cmp fl,1          ;если есть флаг отрицательного
    je negat          ;переходим к метке negat и делаем его отрицательным
    	
    jmp norm          ;иначе в метку norm  
    	
;делаем  число отрицательным
negat:
    neg ax    
    	
norm: 
 	pop dx            ;восстанавливаем регистры
    pop bx  
    pop cx 
    ret  
ReadInteger endp  

; ввод одного символа  
ReadChar proc  
    	mov ah,1 
    	int 21h 
    	ret  
ReadChar endp

 
;вывод числа
WriteInteger proc near 
    push ax           ;сохраняем регистры
    push cx  
    push bx  
    push dx  
    xor cx, cx  
    mov bx, 10     
    
;проверка на отрицательность   
    cmp ax,0
    jl ddd	          ;да    
    jmp divl	      ;нет   
    
;вывести минус и поменять знак
ddd:
    push ax
    mov dl, '-'  
    mov ah, 2  
    int 21h
    pop ax
    neg ax  

;получить 10-цифры и поместить их в стек,
;в cx - количество полученных цифр
divl:  
    xor dx, dx  
    idiv bx  
    push dx  
    inc cx  
    cmp ax,0         ;if ax > 0 - продолжаем преобразование
    jg  divl  

;достать из стека, перевести в код ASCII и вывести
popl:  
    pop ax  
    add al, '0'      ;преобразование в символ
    call WriteChar   ;обращение к процедуре вывода одного символа
    loop popl  

    pop dx           ;восстанавливаем регистры
   	pop bx  
    pop cx  
   	pop ax 
    ret  
WriteInteger endp  

;вывод одного символа 
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

n	dw	10		;число элементов массива
fl 	dw 	?		;флаг отрицательного числа

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