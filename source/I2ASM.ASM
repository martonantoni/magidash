.MODEL COMPACT
.386
.CODE
PUBLIC _starfield,_blockunlite,_recolorgfx,_specline,_linefill
PUBLIC _specblockput,_textcopy,_textureput,_moveline,_linedel
PUBLIC _storeline,_reputline,_lineput,_riseline
x:	DW 0
szor: DW 320
t:	DW 0
_starfield PROC
ARG sd:dword,star:word,pic:dword,scr_z:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	mov	bx,star
	sal	bx,1
	lds	si,sd
	les	di,pic
	mov	ax,es
	cmp	ax,0
	jne	nn
	mov	ax,0a000h
	xor	di,di
	mov	es,ax
nn:  mov	ax,ds:[si+bx]
	imul	word ptr scr_z
	mov	cx,ds:[si+bx+2000]
	idiv	cx
	add	ax,160
	mov	word ptr x,ax
	mov	ax,ds:[si+bx+1000]
	imul	word ptr scr_z
	idiv	cx
	sub	cx,30
	cmp	cx,50
	ja	nw
	mov	cx,3000
nw:	mov	ds:[si+bx+2000],cx
	add	ax,100
	mov	word ptr t,bx
	mov  bx,ds:[si+bx+3000]
	cmp	es:[di+bx],byte ptr 32
	ja	sf1
	mov	cl,0
	mov	es:[di+bx],cl
sf1:	mov	bx,word ptr t
	cmp	ax,ds:[si+492*2]
	jae	out
	cmp	ax,ds:[si+491*2]
	jb	out
	cmp	word ptr x,320
	jae	out
	mul	word ptr szor
	add	ax,word ptr x
	mov	cx,ds:[si+bx+2000]
	mov	ds:[si+bx+3000],ax
	mov	cl,16
	add	cl,ch
	mov  bx,ax
	cmp	es:[di+bx],byte ptr 32
	ja	out2
	mov	es:[di+bx],cl
	mov	bx,word ptr t
ouc:	sub	bx,2
	jnz	nn
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
out:	mov	ax,0
	mov	ds:[si+bx+3000],ax
	jmp	ouc
out2:mov	bx,word ptr t
	jmp	out
_starfield ENDP
_blockunlite PROC
ARG src:dword,cox:word,coy:word,w:word,h:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,src
	mov	ax,ds
	test	ax,0ffffh
	jnz   snn
	mov	ax,0a000h
	xor	si,si
	mov	ds,ax
snn:	mov	es,ax
	mov	ax,coy
	mul	word ptr szor
	add	ax,cox
	add	si,ax
	mov	di,si
	mov	word ptr x,320
	mov	ax,w
	sub	word ptr x,ax
	mov	al,128
c1:	mov	cx,w
c2:	scasb
	je	tob
	ja	cl1
	dec  byte ptr es:[di-1]
cl1:	loop	c2
	add	di,word ptr x
	dec	h
	jnz	c1
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
tob:	mov	byte ptr es:[di-1],0
	jmp	cl1
_blockunlite ENDP
_recolorgfx PROC
ARG	gfx:dword,nc:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lds	si,gfx
	les	di,gfx
	mov	bx,nc
	mov	cx,64000
	cld
c3:	lodsb
	test	al,0ffh
	jz	cc3
	add	al,bl
cc3:	stosb
	loop	c3
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_recolorgfx ENDP
_specline PROC
ARG pic:dword,x1:word,y1:word,x2:word,y2:word,col:word,tab:dword
;col=(current_color<<8)+protected_color
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lgs	bx,tab
	push	bx
	les	di,pic
	mov	ax,es
	test	ax,0ffffh
	jnz	sl4
	mov	ax,0a000h
	mov	es,ax
	xor	di,di	;-)
sl4:	mov	si,di
	mov	ax,y1
	cmp	ax,y2
	jne	sl7
	mov	ax,x1
	cmp	ax,x2
	jna	sl7
	mov	bx,x2
	mov	x1,bx
	mov	x2,ax
sl7: mov	ax,y1
	mul	word ptr szor
	add	ax,x1
	add	di,ax
	mov	ax,y2
	mul	word ptr szor
	add	ax,x2
	add	si,ax
	cmp	di,si
	ja	sl5
	xchg	si,di
	mov	ax,x1
	mov	bx,x2
	mov	x1,bx
	mov	x2,ax
	mov	ax,y1
	mov	bx,y2
	mov	y1,bx
	mov	y2,ax
sl5:	mov	ax,y2
	sub	y1,ax
	inc	word ptr y1
	mov	ax,x2
	sub	ax,x1
	js	sla
	inc	ax
	mov	x1,ax
	cmp	ax,y1
	jb	sl1
	cld
	mov	ax,col
	pop	bx
c4:	mov	word ptr gs:[bx],di
	add	bx,2
	scasb
	je   sl8
	cmp	byte ptr es:[di-1],1
	jge	sl8
	mov	es:[di-1],ah
sl8:	cmp	di,si
	je	slx
	add	dx,y1
	cmp	dx,x1
	jb   c4
	sub	di,320
	sub	dx,x1
	cmp	di,si
	je	slx
	jmp	c4
sl1:	cld
	mov	ax,col
	pop	bx
c5:  scasb
	je	sl9
	cmp	byte ptr es:[di-1],1
	jge	sl9
	mov	es:[di-1],ah
sl9:	sub	di,321
	cmp	di,si
	je	slx
	add	dx,x1
	cmp	dx,y1
	jb	c5
	mov	word ptr gs:[bx],di
	add	bx,2
	inc	di
	sub	dx,y1
	cmp	di,si
	je	slx
	jmp	c5
sla: neg	ax
	inc	ax
	mov	x1,ax
	cmp	ax,y1
	ja	sl3
	std
	mov	ax,col
	pop	bx
c6:  scasb
	je	sld
	cmp	byte ptr es:[di+1],1
	jge	sld
	mov	es:[di+1],ah
sld:	sub	di,319
	cmp	di,si
	je	slx
	add	dx,x1
	cmp	dx,y1
	jb	c6
	mov	word ptr gs:[bx],di
	add	bx,2
	dec	di
	sub	dx,y1
	cmp	di,si
	je	slx
	jmp	c6
sl3:	std
	mov	ax,col
	pop	bx
c7:	mov	word ptr gs:[bx],di
	add	bx,2
	scasb
	je	slb
	cmp	byte ptr es:[di+1],1
	jge	slb
	mov	es:[di+1],ah
slb:	cmp	di,si
	je	slx
	add	dx,y1
	cmp	dx,x1
	jb	c7
	sub	di,320
	sub	dx,x1
	cmp	di,si
	jne	c7
slx: cmp	es:[di],al
	je	slc
	cmp	es:[di],byte ptr 1
	jge	slc
	mov	es:[di],ah
slc:	mov	word ptr gs:[bx],di
	mov	word ptr gs:[bx+2],-1
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_specline ENDP
_linefill PROC
ARG pic:dword,tab1:dword,tab2:dword,col:word
	push	bp
	mov	bp,sp
	push si
	push	ds
	push	di
	mov	cx,col
	les	di,pic
	mov	ax,es
	test	ax,0ffffh
	jnz	lf1
	mov	ax,0a000h
	mov	es,ax
	xor	di,di
lf1:	lds	si,tab1
	lgs	bx,tab2
	cld
c8:	lodsw
	cmp	ax,-1
	je	lfx
	mov	dx,gs:[bx]
	add	bx,2
	mov	di,dx        ;-)
	cmp	ax,di
	je	lf2
	jb	lf3
c9:  cmp	es:[di],cl
	je	lf4
	cmp	byte ptr es:[di],1
	jge  lf4
	mov	es:[di],ch
lf4:	add	di,320
	cmp	ax,di
	jne	c9
lf2: cmp	es:[di],cl
	je	lf5
	cmp	byte ptr es:[di],1
	jge  lf5
	mov	es:[di],ch
lf5:	jmp	c8
lf3: cmp	es:[di],cl
	je	lf6
	cmp	byte ptr es:[di],1
	jge  lf6
	mov	es:[di],ch
lf6:	sub	di,320
	cmp	ax,di
	jne	lf3
	jmp	lf2
lfx:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_linefill ENDP
_specblockput PROC
ARG buff:dword,x1:word,y1:word,w:word,h:word
	push	bp
	mov	bp,sp
	push si
	push	ds
	push	di
	cld
	mov	ax,0a000h
	mov	es,ax
	mov	ax,y1
	mul	word ptr szor
	add	ax,x1
	mov	di,ax
	lds	si,buff
	add	si,ax
	mov	dx,320
	sub	dx,w
	mov	bx,h
c12:	mov	cx,w
c10:	lodsb
	test	al,0ffh
	jz	sb1
	cmp	byte ptr es:[di],32
	ja	sb2
	stosb
sb3:	loop c10
	add	si,dx
	add	di,dx
	dec	bl
	jnz	c12
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
sb2:	inc	di
	jmp	sb3
sb1:	cmp	byte ptr es:[di],64
	jb	sb2
	mov	byte ptr es:[di],0
	inc	di
	jmp	sb3
_specblockput ENDP
_textcopy PROC
ARG txtpic:dword,pic:dword,x1:word,y:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lds	si,txtpic
	les	di,pic
	mov	ax,es
	test	ax,0ffffh
	jnz	tc1
	mov	ax,0a000h
	mov	es,ax
	xor	di,di
tc1:	add	si,x1
	add	di,x1
	mov	ax,y
	mul	word ptr szor
	add	di,ax
	mov	cx,16
c11:	mov	al,ds:[si]
	add	si,320
;	test	al,0ffh
;	jz	tc2
	mov	es:[di],al
tc2:	add	di,320
	loop	c11
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_textcopy ENDP
_textureput PROC
ARG pic:dword,texture:dword,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,texture
	les	di,pic
	mov	cx,l
c13:	test	es:[di],byte ptr 255
	jz	tp1
	movsb
	loop	c13
tpx:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
tp1:	inc	si
	inc	di
	loop	c13
	jmp	tpx
_textureput ENDP
_moveline PROC
ARG y1:word,y2:word,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	mov	ax,0a000h
	mov	es,ax
	mov	ds,ax
	mov	ax,y1
	mul	word ptr szor
	mov	si,ax
	mov	ax,y2
	mul	word ptr szor
	mov	di,ax
	mov	cx,l
c14:	cmp	ds:[si],byte ptr 32
	jb	ml1
	movsb
	mov	ds:[si-1],byte ptr 0
	loop	c14
mlx:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
ml1:	inc	di
	inc	si
	loop	c14
	jmp	mlx
_moveline ENDP
_linedel PROC
ARG y:word,l:word
	push	bp
	mov	bp,sp
	push	di
	cld
	mov	ax,0a000h
	mov	es,ax
	mov	ax,y
	mul	word ptr szor
	mov	di,ax
	mov	cx,l
	xor	al,al
c15:	cmp	es:[di],byte ptr 32
	jb	dl1
	stosb
	loop	c15
dlx:	pop	di
	pop	bp
	ret
dl1:	inc	di
	loop	c15
	jmp	dlx
_linedel ENDP
_storeline PROC
ARG buff:dword,y:word,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	mov	ax,0a000h
	mov	ds,ax
	mov	ax,y
	mul	word ptr szor
	mov	si,ax
	les	di,buff
	mov	cx,l
c16:	cmp  ds:[si],byte ptr 32
	jb   ls1
	movsb
	loop	c16
lsx:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
ls1:	mov	es:[di],byte ptr 0
	inc	di
	inc	si
	loop	c16
	jmp	lsx
_storeline ENDP
_reputline PROC
ARG buff:dword,y:word,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	mov	ax,0a000h
	mov	es,ax
	mov	ax,y
	mul	word ptr szor
	mov	di,ax
	lds	si,buff
	mov	cx,l
c17:	cmp	ds:[si],byte ptr 32
	jb   rl1
	movsb
	loop	c17
rlx:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
rl1:	inc	si
	inc	di
	loop	c17
	jmp	rlx
_reputline ENDP
_lineput PROC
ARG lbuff:dword,x1:word,y:word,w:word,h:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,lbuff
	mov	ax,0a000h
	mov	es,ax
	mov	ax,y
	mul	word ptr szor
	mov	di,ax
	add	di,x1
	mov	dx,320
	sub	dx,w
	mov	bx,h
c18:	mov	cx,w
	rep	movsb
	add	di,dx
	add	si,dx
	dec	bl
	jnz	c18
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_lineput ENDP
_riseline PROC
ARG txtpic:dword,x1:word,y:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	mov	ax,0a000h
	mov	es,ax
	mov	ax,y
	mul	word ptr szor
	mov	di,ax
	lds	si,txtpic
	add	si,x1
	add	di,x1
	mov	bx,16
c20:	mov	cx,bx
	push	di
	push	si
c19:	movsw
	add	si,318
	add	di,318
	loop	c19
	pop	si
	pop	di
	add	si,2
	add	di,322
	dec	bl
	jnz	c20
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_riseline ENDP
END
