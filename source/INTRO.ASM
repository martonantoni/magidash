.MODEL COMPACT
.386
.CODE
szor: DW 320
sbx:	DW 0
ssi:	DW 0
sdi:	DW 0
scrwidth:	DW 0
endline:	DW 0
endpos:	DW 0
PUBLIC _zoomer
_zoomer PROC
ARG x1:word,y1:word,x2:word,y2:word,w:word,h:word,pw:word,ph:word,pic:dword,buff:dword,ofs:word
	push	bp
	mov	bp,sp
	push	si
	push ds
	push	di
	cld
	lds	si,pic
	les	di,buff
	mov	word ptr endpos,di
	mov	ax,y2
	mul	word ptr szor
	add	ax,x2
	add	word ptr endpos,ax
	mov	ax,y1
	mul	word ptr szor
	add	ax,x1
	add	di,ax
	mov	ax,x2
	sub	ax,x1
	mov	word ptr scrwidth,ax
	xor	bx,bx
	mov	cx,ph
	mov	dx,h
	mov	word ptr endline,di
	add	word ptr endline,ax
c5: 	mov	word ptr sbx,bx
	mov	cx,pw
	mov	dx,w
	mov	word ptr ssi,si
	mov	word ptr sdi,di
	xor	bx,bx
c2:	mov	al,ds:[si]
c3:	stosb
	add	bx,cx
	cmp	bx,dx
	jb	b1
c1:	sub	bx,dx
	inc	si
	cmp	bx,dx
	jae	c1
	cmp	di,word ptr endline
	jb	c2
co:	add	word ptr endline,320
	mov	si,word ptr ssi
	mov	di,word ptr sdi
	mov	bx,word ptr sbx
	mov	cx,ph
	mov	dx,h
	add	bx,cx
	add	di,320
	cmp	bx,dx
	jb	b2
c4:	sub	bx,dx
	add	si,ofs
	cmp	bx,dx
	jae	c4
	cmp	di,word ptr endpos
	jb	c5
ep:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
b1:	cmp	di,word ptr endline
	jb	c3
	jmp	co
b2:	cmp	di,word ptr endpos
	jae	ep
	push	ds
	push	es
	pop	ds
	mov	word ptr sdi,di
	mov	word ptr sbx,bx
	mov	si,di
	sub	si,320
	mov	cx,word ptr scrwidth
	rep	movsb
	pop	ds
	jmp	co
_zoomer ENDP
END