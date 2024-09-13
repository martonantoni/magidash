.MODEL COMPACT
.386
.CODE
PUBLIC _showring,_ringcolor
pos: DW 0
sbx: DW 0
_showring PROC
ARG ringtab:dword,gfx:dword,pic:dword,w:word,h:word
	push	bp
	mov  bp,sp
	push	si
	push	ds
	push	di
	cld
	mov	word ptr sbx,0
	les	di,pic
	mov	ax,es
	test	ax,0ffffh
	jnz	nnu
	mov	ax,0a000h
	mov	es,ax
	xor	di,di
	mov	di,320*18
nnu:	mov	word ptr pos,0
	mov	dx,h
c2:	mov	cx,w
c1:	mov	bx,word ptr sbx
	lds	si,ringtab
	mov  bx,ds:[si+bx]
	lds	si,gfx
	add	si,word ptr pos
	lodsb
	mov	es:[di+bx],al
	add  word ptr sbx,2
	inc	word ptr pos
	loop	c1
	mov	ax,word ptr pos
	add	ax,320
	sub	ax,w
	mov	word ptr pos,ax
	dec	dx
	jnz	c2
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_showring ENDP
_ringcolor PROC
ARG pic:dword
	push	bp
	mov	bp,sp
	push	di
	cld
	les	di,pic
	mov 	ax,1a00h
c4:	mov	bl,4
c3:	mov	cx,160
c8:	scasb
	je	rc1
	mov	es:[di-1],ah
rc1: loop	c8
	add  di,160
	dec	bl
	jnz  c3
	dec	ah
	cmp	ah,16
	jne	c4
	mov	bl,8
c5:	mov	cx,160
c9:	scasb
	je	rc2
	mov	es:[di-1],ah
rc2: loop	c9
	add	di,160
	dec	bl
	jnz	c5
c7:	mov	bl,4
c6:	mov	cx,160
c10:	scasb
	je	rc3
	mov	es:[di-1],ah
rc3: loop	c10
	add	di,160
	dec	bl
	jnz	c6
	inc	ah
	cmp	ah,1bh
	jne	c7
	pop	di
	pop	bp
	ret
_ringcolor ENDP
END