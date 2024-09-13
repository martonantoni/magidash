.MODEL COMPACT
.386
.CODE

PUBLIC _mirror
_mirror PROC
ARG pic:dword
	push	bp
	mov	bp,sp
	push	si
	push	di
	push	ds
	lds	si,pic
	les	di,pic
;	mov	ax,0a000h
;	mov	es,ax
;	xor	di,di
	std
	add	di,320*140
	add	si,320*139
	mov	ax,140
	mov	bx,60
	mov	dx,cs:word ptr seed
c1:	mov  cx,160
c3:	lodsw
	add	ax,1010h
	stosw
	loop	c3
	mov	ax,140
	add	di,640
	cmp	di,64000-320
	ja	ex
	add	si,320
	add	dx,ax
c2:	sub  si,320
	sub	dx,bx
	cmp	dx,bx
	jae	c2
	jmp	c1
ex:	pop	ds
	pop	di
	pop	si
	pop	bp
	add	cs:word ptr tmr,1
	cmp	cs:word ptr tmr,1
	je	co
	ret
co:	mov	cs:word ptr tmr,0
	add	cs:word ptr seed,3
	cmp	cs:word ptr seed,139
	jae	ok
	ret
ok:	sub	cs:word ptr seed,140
	ret
seed: DW 0
tmr: DW 0
_mirror ENDP
END


