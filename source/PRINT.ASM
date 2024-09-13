.MODEL COMPACT
.386
.CODE
PUBLIC _inicprint,_pnumber,_ptext,_shadeprint,_advshadeprint,_shade8print
PUBLIC _shade8numprint,_shadenumprint
PUBLIC _setprintdestination
_inicprint PROC
;void inicprint(char far *charset)
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	jmp	c
sdi:	DW 0
ses:	DW 0
c:	les	di,[bp+4]
	mov	word ptr ses,es
	mov	word ptr sdi,di
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_inicprint ENDP
numtxt: DW 0,0,0,0
oszto: DW 10
even
_pnumber PROC
; void pnumber(int x,int y,int number,int length,int is0)
; is0 : if TRUE => length hosszan fel lessz a szam eleje 0-val toltve
; length <= 6
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	std
	mov	cx,6
	push cs
	pop	es
	mov	di,offset numtxt+5
	mov	ax,[bp+8]
;	mov	ax,200
	xor	dx,dx
c3:	div	word ptr oszto
	xchg	ax,dx
	add	al,30h
	stosb
	xchg	ax,dx
	xor	dx,dx
	loop	c3
	xor	ax,ax
	cmp	ax,[bp+12]
	jne   f0
	mov	di,offset numtxt
	mov	cx,5
	mov	al,30h
	cld
c4:	scasb
	jne	f0
	mov	es:[di-1],byte ptr 32
	loop	c4
f0:	mov	ax,[bp+10]
	mov	bx,offset numtxt+6
	sub	bx,ax
	mov	[bp+8],bx
	mov	[bp+10],es
	jmp	pt
_pnumber ENDP
szor: DW 320
_ptext PROC
; void ptext(int x,int y,char far *text)
; x : 16-os osztas, y : normal ---> 20*180
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
pt:	mov  ax,[bp+6]
	mul	word ptr szor
	mov	dx,[bp+4]
	sal	dx,4
	add	ax,dx
	mov	di,ax
	mov	ax,0a000h
	mov	es,ax
	xor	bx,bx
	cld
ckl:	lds	si,[bp+8]
	mov  al,ds:[si+bx]
	cmp	al,0
	je	ept
	xor	ah,ah
	sal	ax,4
	lds	si,dword ptr sdi
	add	si,ax
	mov	dl,16
	push	di
c2:	mov	cx,4
	rep	movsd
	add	si,3824
	add	di,304
	dec	dl
	jnz	c2
	pop	di
	add	di,16
	inc	bx
	jmp  ckl
ept: pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_ptext ENDP
xend: DW 0
_shadeprint PROC
;void shadeprint(int x,int y,char far *text,int times,int dir)
;dir : FALSE - down  ,  TRUE - up
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
spr:	mov  ax,[bp+6]
	mul	word ptr szor
	mov	dx,[bp+4]
;	sal	dx,4
	add	ax,dx
	mov	di,ax
	add	di,cs:word ptr destoffs
	mov	ax,cs:word ptr destseg
	mov	es,ax
	xor	bx,bx
	mov	word ptr xend,0
	cld
c5:	lds	si,[bp+8]
	mov  al,ds:[si+bx]
	cmp	al,0
	je	ep2
	cmp	al,97
	jb	nl1
	sub	al,32
nl1:	xor	ah,ah
	sal	ax,1
	push	bx
	mov	bx,ax
	mov	ax,cs:word ptr propwtab[bx]
	add	word ptr xend,ax
	mov	cs:word ptr s26+1,ax
	mov	cs:byte ptr s24+2,al
;	mov	cs:byte ptr s25+2,al
	mov	cs:word ptr s27+2,word ptr 3840
	sub	cs:word ptr s27+2,ax
	mov	cs:word ptr s25+2,word ptr 320
	sub	cs:word ptr s25+2,ax
	mov	ax,cs:word ptr proptab[bx]
;	mov	si,word ptr sdi
	pop	bx
	lds	si,dword ptr sdi
	add	si,ax
	mov	dl,16
	push	di
s26:
c6:	mov	cx,8
c7:  mov	dh,[bp+12]
	lodsb
	test	dh,255
	jz	t01
	cmp	[bp+14],word ptr 0
	jne	d
c8:	add	es:[di],al
	sub	es:[di+322],al
	dec	dh
	jnz	c8    ; a times
;	add	di,2
t0b:	inc	di
	loop	c7
	jmp	ad
d:	sub	es:[di],al
	add	es:[di+322],al
	dec  dh
	jnz	d     ; a times
;	add	di,2
	inc	di
	loop	c7    ; a rep helyett
ad:
s27:	add	si,3824
s25:	add	di,304
	dec	dl
	jnz	c6
	pop	di
s24:	add	di,16
	inc	bx
	jmp  c5
ep2: pop	di
	pop	ds
	pop	si
	pop	bp
	mov	ax,word ptr xend
	ret
t01:	mov	es:[di],al
	jmp	t0b
_shadeprint ENDP
sbx: DW 0
sxbx: DW 0
tofin: DB 0
proptab:
	DW 32 DUP (0)
	DW 394
	DW 761,819,0,829,841,870,813,893,900,884,945,786,857,792,779
	DW 640,653,664,676,687,700,712,724,736,748
	DW 806,799,0,933,0,767,0
	DW 0,17,31,46,60,74,86,102,116,120,134,149,161,178,192
	DW 208,221,238,252,266,278,320,333,355,368,381
propwtab:
	DW 32 DUP (2)
	DW 14
	DW 767-761,10,2,841-829,16,14,6,7,7,9,13,6,13,7,7
	DW 13,11,12,11,13,12,12,12,12,13
	DW 7,7,2,12,2,12,3
	DW 17,31-17,46-31,60-46,74-60,86-74,102-86
	DW 116-102,120-116,134-120,149-134,161-149,178-161,192-178
	DW 208-192,221-208,238-221,252-238,266-252,278-266,14
	DW 333-320,355-333,368-355,381-368,394-381
	DW 32 DUP (3)
_advshadeprint PROC
;void advshadeprint(int x,char far *text,char far *times,
;	int length,char far *background)
; x : in pixels
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lfs	bx,[bp+16]
	mov	cs:word ptr sm2+3,bx
	add	bx,322
	mov	cs:word ptr sm3+3,bx
	mov	ax,[bp+14]
	mov	byte ptr tofin,al
	lgs	bx,[bp+10]
	mov	cs:byte ptr sm1+3,bl
	les	di,[bp+6]
	mov	bx,[bp+4]
	lds	si,dword ptr sdi
	cld
c9:	mov	al,es:[di]
	cmp	al,97
	jb	nl2
	sub	al,32
nl2:	inc	di
	xor	ah,ah
	sal	ax,1
	push	bx
	mov	bx,ax
	mov	ax,word ptr propwtab[bx]
	mov	cs:word ptr sm6+1,ax
	mov	cs:byte ptr sm4+2,al
	mov	cs:byte ptr sm5+2,al
	mov	cs:word ptr sm7+2,word ptr 3840
	sub	cs:word ptr sm7+2,ax
	mov	ax,word ptr proptab[bx]
	mov	si,word ptr sdi
	pop	bx
	add	si,ax
	mov	dl,16
sm6:
c10:	mov	cx,16
c11:	lodsb
sm1:	mov	dh,gs:[bx+94]
	or	dh,dh
	jz	naa
c12:
sm2:	sub	fs:[bx+1994],al
sm3:	add	fs:[bx+1994],al
	dec	dh
	jnz	c12
naa: inc	bx
	cmp	bx,316
	ja  	c11s
	loop	c11
c11b:
sm7:	add	si,3824
	add	word ptr sm2+3,word ptr 320
	add	word ptr sm3+3,word ptr 320
sm4:	sub	bx,16
	dec	dl
	jnz	c10
sm5:	add	bx,16
	cmp	bx,315
	ja	ep3
	sub	word ptr sm2+3,word ptr 5120
	sub	word ptr sm3+3,word ptr 5120
	dec	byte ptr tofin
	jnz	c9
ep3: mov	dx,cs
	mov	ax,offset propwtab
	pop	di
	pop	ds
	pop	si
	pop	bp
;	mov	ax,bx
	ret
c11s:loop	naa
	jmp	c11b
_advshadeprint ENDP
_setprintdestination PROC
;void setprintdestination(char far *dest=NULL);
ARG destination:dword
	push	bp
	mov	bp,sp
	push	si
	les	si,destination
	mov	ax,es
	test	ax,0ffffh
	jnz	nnl
	mov	ax,0a000h
	xor	si,si
nnl:	mov	cs:word ptr destoffs,si
	mov	cs:word ptr destseg,ax
	pop	si
	pop	bp
	ret
_setprintdestination ENDP
destoffs: DW 0
destseg: DW 0a000h
_shade8print PROC
;void shade8print(int x,int y,char far *text,int times,int dir)
;x : pixelenkent
;dir : FALSE - down  ,  TRUE - up
;times = 0 ==> Normal print
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
s8p:	add	word ptr sdi,1600
	mov  ax,[bp+6]
	mul	word ptr szor
	mov	dx,[bp+4]
;	sal	dx,4
	add	ax,dx
	mov	di,word ptr destoffs
	add	di,ax
	mov	ax,word ptr destseg
	mov	es,ax
	xor	bx,bx
	cld
c58:	lds	si,[bp+8]
	mov  al,ds:[si+bx]
	cmp	al,0
	je	ep8
	sub	al,32
;	xor	ah,ah

;	sal	ax,4
	mov	ah,al
	and	al,3
	jz	e80
	cmp	al,2
	jb	e81
	je	e82
	mov	dx,30728
e8b: mov	al,ah
	xor	ah,ah
	sal	ax,2
	and	al,not 15
	add	ax,dx
;	mov	ax,16

	lds	si,dword ptr sdi
	add	si,ax
	mov	dl,8
	push	di
c68:	mov	cx,4
c78: mov	dh,[bp+12]
	lodsw
	test	dh,255
	jz	np2
	cmp	[bp+14],word ptr 0
	jne	d8
c88:	add	es:[di],ax
	sub	es:[di+321],ax
	dec	dh
	jnz	c88    ; a times
npb:	add	di,2
	loop	c78
	jmp	ad8
d8:	sub	es:[di],ax
	add	es:[di+321],ax
	dec  dh
	jnz	d8     ; a times
	add	di,2
	loop	c78    ; a rep helyett
ad8:	add	si,3824+8
	add	di,304+8
	dec	dl
	jnz	c68
	pop	di
	add	di,8
	inc	bx
	jmp  c58
ep8: sub  word ptr sdi,1600
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
np2: mov	es:[di],ax
	jmp	npb
e80:	xor	dx,dx
	jmp	e8b
e81:	mov	dx,8
	jmp	e8b
e82:	mov	dx,30720
	jmp	e8b
_shade8print ENDP
sh8ntxt: DW 0,0,0,0,0
_shade8numprint PROC
;void shade8numprint(int x,int y,int num,int is0,int times,int dir,int length)
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	std
	mov	cx,6
	push cs
	pop	es
	mov	di,offset sh8ntxt+5
	mov	ax,[bp+8]
	xor	dx,dx
c3n:	div	word ptr oszto
	xchg	ax,dx
	add	al,30h
	stosb
	xchg	ax,dx
	xor	dx,dx
	loop	c3n
	xor	ax,ax
	cmp	ax,[bp+10]
	jne   f0n
	mov	di,offset sh8ntxt
	mov	cx,5
	mov	al,30h
	cld
c4n:	scasb
	jne	f0n
	mov	es:[di-1],byte ptr 32
	loop	c4n
f0n:	mov	ax,[bp+16]
	mov	bx,offset sh8ntxt+6
	sub	bx,ax
	mov	[bp+8],bx
	mov	[bp+10],es
	jmp  s8p
_shade8numprint ENDP
_shadenumprint PROC
;void shadenumprint(int x,int y,int num,int is0,int times,int dir,int length)
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	std
	mov	cx,6
	push cs
	pop	es
	mov	di,offset sh8ntxt+5
	mov	ax,[bp+8]
	xor	dx,dx
c36:	div	word ptr oszto
	xchg	ax,dx
	add	al,30h
	stosb
	xchg	ax,dx
	xor	dx,dx
	loop	c36
	xor	ax,ax
	cmp	ax,[bp+10]
	jne   f06
	mov	di,offset sh8ntxt
	mov	cx,5
	mov	al,30h
	cld
c46:	scasb
	jne	f06
	mov	es:[di-1],byte ptr 32
	loop	c46
f06:	mov	ax,[bp+16]
	mov	bx,offset sh8ntxt+6
	sub	bx,ax
	mov	[bp+8],bx
	mov	[bp+10],es
	jmp  spr
_shadenumprint ENDP

END