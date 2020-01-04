
;�������� ������� ��� �������� ���� ������������� 
;�� ���� � �� �� �����
use16
org 100h

jmp start
;//////////////////////////////////////
;����������
str_buffer db 255,0,255 dup(?)
endline    db 13,10,'$'
error      db 'The text must end with "."','$'
answer     db 'The number of neighboring words with the same end letter: ','$'

;//////////////////////////////////////


start:
    
    call input_str
    call print_endline
    
    push dx
    call print_str
    call print_endline
    
    push ax
    push dx
    call count_same_title_character
    
    cmp al,-1
    jne OK
    
    push error
    call print_str
    call print_endline
    jmp EXIT
    
    OK:
    push answer
    call print_str
    push ax
    call write_uinteger
    call print_endline
    
    EXIT:
        
    ;����� ���������
    mov ax,4C00h
    int 21h



;//////////////////////////////////////
; �������� �������� �����
; �������� ���������� ����� ���� ( ����� ������, ����� ������)
; ������: DX - ����� ������,AL - ����� ������     
;//////////////////////////////////////
remove_left_space:
    push bp
    mov bp,sp
    push cx
    push di
    
    xor cx,cx
    mov cx,[bp+6]  ;����� ������
    mov di,[bp+4]  ;����� ������
    mov al,' '  ;������
    repe scasb  ;����� �� ������� �� �������
    mov al,cl
    mov dx,di
    dec dx      ;�������� ������ �� ������ �� ������
    inc al      ;�������� �����
     
    pop di
    pop cx
    pop bp
    ret 4

;//////////////////////////////////////
;������� ���-�� ��� �������� ����, ������������� 
;�� ���� � �� �� �����
;�������� ���������� ����� ���� (����� ������,
;                      ������ ������������� "." � ����� ������ )
; ����������: AL - ���-�� ��� ��� -1 ���� ������ ��
;                                  ��������� "."     
;//////////////////////////////////////
count_same_title_character:
    push bp
    mov bp,sp
    push di
    push dx
    push bx
    push si
    
    xor cx,cx
    mov cx,[bp+6]
    mov di,[bp+4]
    
    xor bx,bx
    mov bx,cx
    cmp byte[di+bx-1],'.' ;�������� �� ������� �����
    mov ax,-1
    jne .EXIT
    
    mov byte[di+bx-1],' '
    push cx
    push di
    call remove_left_space ;��������� ������ ��������
    mov cl,al
    mov di,dx
    
    xor si,si   ;���-�� ���    
          
          
    mov al,' '
    repne scasb ;����� ������� �������                  
    jcxz .END_STR ;���� ����� �� ����� ������
    ;inc cx                 
        
    .main:
        mov bl,[di-2] ;��������� ����� ������� �����
        mov al,' '
        repne scasb ;����� ������� �������     
                
        jcxz .END_STR ;���� ����� �� ����� ������
       ; inc cx  
                        
        push cx
        push di
        call remove_left_space ;��������� �������� �� ����. �����
        mov cl,al
        mov di,dx
        cmp [di-2],bl ;���� ������ ����� �����
        jne .main       
        inc si  ;��������� ���-��
        jmp .main
        
    .END_STR:
    xor ax,ax
    mov ax,si
    
    .EXIT:     
    mov byte[di+bx-1],'.'
    pop si
    pop bx
    pop dx
    pop di
    pop bp
    ret 4
 
    
;//////////////////////////////////////
; ������ ������ � �������
; ������: � ���� ����� ������           
;//////////////////////////////////////
print_str:
    push bp
    mov bp,sp
    push ax
    
    mov ah,9
    xchg dx,[bp+4]
    int 21h
    xchg dx,[bp+4]
    
    pop ax    
    pop bp
    ret 2

;//////////////////////////////////////
; ������� �� ����� ������ � �������(������� �������)
;//////////////////////////////////////
print_endline:
    push endline 
    call print_str
    ret


;//////////////////////////////////////
; ��������� ����� ������ � �������
; AL - ������ ������
; DX - ������ ������          
;//////////////////////////////////////
input_str:    
    push cx
    push si
    
    mov cx,ax    
    mov ah,0Ah                       
    mov dx,str_buffer ;������ ������        
    int 21h
    mov ax,cx         
    xor si,si
    xor ax,ax
    mov al,[str_buffer+1]
    mov si,ax
    mov [str_buffer+si+2],'$'
    add dx,2
    
    pop si
    pop cx     
    ret

;//////////////////////////////////////
; ������ ������ �������
; �������� ���������� ����� ����
; ������: ������ (1 ����)      
;//////////////////////////////////////
write_char:
    push bp
    mov bp,sp
    push ax
    push dx
    
    mov dl,[bp+4]
    mov ah,2
    int 21h
    
    pop dx
    pop ax
    pop bp
    ret 2

;//////////////////////////////////////
;������ ������������ �����
;�������� ���������� ����� ����    
;������: ����� - �� ����� 2 ����     
;//////////////////////////////////////
write_uinteger:
    push bp
    mov bp,sp
    push ax
    push cx
    push bx
    push dx
    
    xor ax,ax
    mov ax,[bp+4]
    xor cx,cx
    mov bx,10
    .GET:
        xor dx,dx
        idiv bx
        push dx
        inc cx
        cmp ax,0
    jg .GET
    
    @@:
        pop ax
        add al,'0'
        
        push ax
        call write_char        
    loop @b
    
    pop dx
    pop bx
    pop cx
    pop ax
    pop bp
    ret 2