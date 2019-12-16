org 00h
mov dptr,#lcd
lcdbegin:
	clr a
	movc a,@a+dptr
	inc dptr
	acall comnwrt
	jnz lcdbegin
	ljmp again5
round1:
	mov a,#80h
	acall comnwrt
	mov a,#01h
	acall comnwrt
	mov b,#15
	again3:
		clr a
		movc a,@a+dptr
		inc dptr
		acall datawrt
		djnz b,again3
		acall delay
		acall delay
		acall delay
		acall delay
		mov a,#80h
		acall comnwrt
		acall delay
	again5:
	mov dptr,#lcddata1
	mov b,#15
	again4:
		clr a
		movc a,@a+dptr
		inc dptr
		acall datawrt
		djnz b,again4

keypad2:
	mov a,#0c7h
	acall comnwrt
	acall delaymov r7,#01h
	mov r5,#00h
	mov b,#04h
	again2:
	     mov p3,#0FFh
	k1: mov p0,#00H
	      mov a,p3
	      anl a,#00001111b
	      cjne a,#00001111b,k1
	k2: acall delay
	      mov a,p3
	      anl a,#00001111b
	      cjne a,#00001111b,over
	      sjmp k2
	over:    acall delay
		 mov a,p3
		 anl a,#00001111b
		 cjne a,#00001111b,over1
		 sjmp k2
	over1:   mov p0,#11111110b
		  mov a,p3
		  anl a,#00001111b
		  cjne a,#00001111b,row_0
		  mov p0,#11111101b
		  mov a,p3
		  anl a,#00001111b
		  cjne a,#00001111b,row_1
		  mov p0,#11111011b
		  mov a,p3
		  anl a,#00001111b
		  cjne a,#00001111b,row_2
		  mov p0,#11110111b
		  mov a,p3
		  anl a,#00001111b
		  cjne a,#00001111b,row_3
		  ljmp k2
	row_0: mov dptr,#kcode0
		  sjmp find
	row_1:  mov dptr,#kcode1
		  sjmp find
	row_2:  mov dptr,#kcode2
		  sjmp find
	row_3:mov dptr,#kcode3
	find:
		 rrc a
		 jnc match
		 inc dptr
		 sjmp find
	match:
		  clr a
		  movc a,@a+dptr
		  mov r4,a
		  mov a,#'*'
		  acall datawrt
		  acall delay
		  mov 6,7
		  mov dptr,#pwd
		  find1:
		  inc dptr
		  djnz r7,find1
		  clr a
		  movc a,@a+dptr
		  mov 7,6
		  inc r7
		  subb a,4
		  jz count
		  cont:
		  djnz b,againc
		  mov a,#04h
		  subb a,r5
		  jz againo
		  mov dptr,#nmatched
		  acall round1
count:
	inc r5
	sjmp cont
againc:
	ljmp again2
againo:
	mov a,#80h
	acall comnwrt
	acall delay
	mov a,#01h
	acall comnwrt
	acall delay
	mov a,#02h
	acall comnwrt
	acall delay
	mov b,#15
	mov dptr,#matched
	again6:
	clr a
	movc a,@a+dptr
	inc dptr
	acall datawrt
	acall delay
	djnz b,again6
	ljmp over2
comnwrt:
mov p1,a
	clr p2.0
	clr p2.1
	setb p2.2
	acall delay
	clr p2.2
	ret
datawrt:
	mov p1,a
	setb p2.0
	clr p2.1
	setb p2.2
	acall delay
	clr p2.2
	ret
delay:
	mov TMOD,#01h
	mov TL0,#00h
	mov TH0,#00h
	setb TR0
 here: 
	jnb TF0,here
	clr TF0
	setb TR0
	ret  
over2:
here4:
sjmp here4
org 300h
pwd:db '0','5','6','7','8'
lcddata1:db " ENTER PASSWORD"
nmatched:db " WRONG PASSWORD"
matched:db " RIGHT PASSWORD"
lcd:db 38h,0eh,01h,80h,0ch,00h
kcode0:db '1','2','3'
kcode1:db '4','5','6'
kcode2:db '7','8','9'
kcode3:db '*','0','#'
end
