.MODEL COMPACT
.386
.CODE

PUBLIC _borderline

l1s: DW 99*320
l2s:	DW 32000

_borderline PROC
ARG mode:word,col:word,pic:dword
; mode bit 0 : close lines [0] / open lines
;      bit 1 : from pic [0] / zeros
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	mov	ax,0a000h
	mov	es,ax
	cld
	test	mode,1
	jnz	blo
	mov	cx,160
	mov	ax,col
	mov	ah,al
	mov	di,word ptr l1s
	rep	stosw
	mov	di,word ptr l2s
	mov	cx,160
	rep	stosw
	test	word ptr l1s,0ffffh
	jz   bl1
	xor	ax,ax
	mov	cx,160
	mov	di,word ptr l1s
	sub	di,320
	rep	stosw
	mov	di,word ptr l2s
	add	di,320
	mov	cx,160
	rep	stosw
bl1:	cmp	word ptr l2s,32000
	je	c_f
	sub	word ptr l2s,320
	add	word ptr l1s,320
c_m:	pop	di
	pop	ds
	pop	si
	pop	bp
	mov	ax,1
	xor	dx,dx
	ret
c_f:	pop	di
	pop	ds
	pop	si
	pop	bp
	xor	ax,ax
	ret
blo: mov	ax,col
	mov	ah,al
	mov	cx,160
	mov  di,word ptr l1s
	rep	stosw
	mov	di,word ptr l2s
	mov	cx,160
	rep	stosw
	cmp	word ptr l2s,32000
	je	bl2
	test	mode,2
;	jnz	blp
	xor	ax,ax
	mov	di,word ptr l1s
	add	di,320
	mov	cx,160
	rep	stosw
	mov	di,word ptr l2s
	sub	di,320
	mov	cx,160
	rep	stosw
bl3:	cmp	word ptr l1s,0
	je	bll
bl2: add	word ptr l2s,320
	sub	word ptr l1s,320
	jmp	c_m
bll: mov	cx,160
	xor	di,di
	rep	stosw
	mov	cx,160
	mov	di,word ptr l2s
	rep	stosw
	jmp	c_f
blp:	lds	si,pic
	mov	di,word ptr l1s
	add	di,320
	add	si,di
	mov	cx,160
	rep	movsw
	mov	di,word ptr l2s
	sub	di,320
	lds	si,pic
	add	si,di
	mov	cx,160
	rep	movsw
	cmp	word ptr l1s,0
	jne	bl2
	mov	cx,160
	lds	si,pic
	xor	di,di
	rep	movsw
	add	si,64000-640
	add	di,64000-640
	mov	cx,160
	rep	movsw
	jmp	c_f
_borderline ENDP
END

