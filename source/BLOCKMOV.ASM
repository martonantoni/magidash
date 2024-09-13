.MODEL COMPACT
.386
.CODE
PUBLIC _blockstore,_blockrestore,_blockput,_screenstore,_screenrestore,_bcopy
PUBLIC _borcopy,_blockfill,_blockscroll
szor: DW	320
_blockstore PROC
ARG x:word,y:word,w:word,h:word,buff:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	mov	ax,y
	mul	word ptr szor
	add	ax,x
	mov	bx,320
	sub	bx,w
	mov	dx,h
	mov	si,ax
	mov	ax,0a000h
	mov	ds,ax
	les	di,buff
	cld
c1:     mov	cx,w
	rep	movsb
	add	si,bx
	dec	dl
	jnz	c1
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_blockstore ENDP
_blockrestore PROC
ARG x:word,y:word,w:word,h:word,buff:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	mov	ax,y
	mul	word ptr szor
	add	ax,x
	mov	bx,320
	sub	bx,w
	mov	dx,h
	mov	di,ax
	mov	ax,0a000h
	mov	es,ax
	lds	si,buff
	cld
c2:	mov	cx,w
	rep	movsb
	add	di,bx
	dec	dl
	jnz	c2
	pop	di
	pop	ds
	pop     si
	pop	bp
	ret
_blockrestore ENDP
_blockput PROC
; void blockput(int x,int y,int w,int h,char *pic)
;	           4     6     8     10    12
	push	bp
	mov	bp,sp
	push	si
	push ds
	push	di
	cld
	lds	si,[bp+12]
	mov	ax,0a000h
	mov	es,ax
	mov	ax,[bp+6]
	mul	word ptr szor
	add	ax,[bp+4]
	mov	di,ax
	mov	ax,[bp+8]
;	mov	cs:word ptr sm3+2,320
;	mov	cs:word ptr sm4+2,320
;	sub	cs:word ptr sm3+2,ax
;	sub	cs:word ptr sm4+2,ax
	mov	bx,320
	sub	bx,ax
	mov	ax,[bp+10]
c3:	mov	cx,[bp+8]
	rep	movsb
	add	si,bx
	add	di,bx
	dec	ax
	jnz	c3
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_blockput ENDP
_screenstore PROC
	push	bp
	mov	bp,sp
	push	si
	push ds
	push	di
	cld
	les	di,[bp+4]
	mov	cx,32000
	mov	ax,0a000h
	mov	ds,ax
	xor	si,si
	rep	movsw
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_screenstore ENDP
_screenrestore PROC
	ARG x:word,y:word,w:word,h:word,buff:dword
	push	bp
	mov	bp,sp
	push	si
	push ds
	push	di
	cld
	mov	ax,0a000h
	mov	es,ax
	mov	ax,y
	nop
	mul	word ptr szor
	add	ax,x
	lds	si,buff
	mov	di,ax
	add	si,ax
;	cmp	ax,0
;	nop
;	jnz  err
	mov	ax,w
;	mov	cs:word ptr sm5+2,320
;	sub	cs:word ptr sm5+2,ax
;	mov	cs:word ptr sm6+2,320
;	sub	cs:word ptr sm6+2,ax
	mov	bx,320
	sub	bx,ax
	mov	ax,h
c4:	mov	cx,w
	rep	movsb
	add	si,bx
	add	di,bx
	dec	ax
	jnz	c4
erc:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
err:	xor	di,di
	mov	ax,101h
	mov	cx,32000
	rep	stosw
	jmp	erc
_screenrestore ENDP
_bcopy PROC
	ARG x:word,y:word,w:word,h:word,src:dword,dest:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,src
	les	di,dest
	mov	ax,y
	mul	word ptr szor
	add	ax,x
	add	si,ax
	add	di,ax
	mov	ax,w
;	mov	cs:word ptr sm7+2,320
;	sub	cs:word ptr sm7+2,ax
;	mov	cs:word ptr sm8+2,320
;	sub	cs:word ptr sm8+2,ax
	mov	bx,320
	sub	bx,ax
	mov	ax,h
c5:	mov	cx,w
	rep	movsb
	add	si,bx
	add	di,bx
	dec	ax
	jnz	c5
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_bcopy ENDP
_borcopy PROC
	ARG x:word,y:word,w:word,h:word,src:dword,dest:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,src
	les	di,dest
	mov	ax,y
	mul	word ptr szor
	add	ax,x
	add	si,ax
	add	di,ax
	mov	ax,w
	mov	dx,320
	sub	dx,ax
	mov	bx,h
c6:	mov	cx,w
c7:	test	es:[di],byte ptr 255
	jz	ok
	inc	si
	inc	di
	loop	c7
okb:	add	si,dx
	add	di,dx
	dec	bx
	jnz	c6
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
ok:	movsb
	loop	c7
	jmp	okb
_borcopy ENDP
_blockfill PROC
ARG x:word,y:word,w:word,h:word,buff:dword,col:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	mov	ax,y
	les	di,buff
	mul	word ptr szor
	add	ax,x
	add	di,ax
	mov	ax,w
;	mov	cs:word ptr smb+2,320
;	sub	cs:word ptr smb+2,ax
	mov	dx,320
	sub	dx,ax
	cld
	mov	ax,col
	mov	bx,h
c8:	mov	cx,w
	rep	stosb
	add	di,dx
	dec	bx
	jnz	c8
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_blockfill ENDP
_blockscroll PROC
ARG x:word,y:word,w:word,height:word,buff:dword,dir:word,pix:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	mov	ax,pix
	mul	word ptr szor
	mov	cx,ax
	lds	si,buff
	mov	ax,ds
	test	ax,0ffffh
	jnz	bs1
	mov	ax,0a000h
	mov	ds,ax
	xor	si,si	;-)
bs1:	mov	es,ax
	mov	di,si
	mov	bx,height
	cmp	dir,1
	jb	bsd
	mov	ax,y
	mul	word ptr szor
	add	ax,x
	mov	dx,320
	sub	dx,w
	add	si,ax
	add	di,ax
	sub	di,cx
	cld
bs2:	mov	cx,w
	rep	movsb
	add	si,dx
	add	di,dx
	dec	bl
	jnz	bs2
bsx:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
bsd:	mov	ax,y
	add	ax,height
	mul	word ptr szor
	add	ax,x
	add	ax,w
	add	si,ax
	add	di,ax
	sub	si,cx
	mov	dx,320
	sub	dx,w
	std
bs3:	mov	cx,w
	rep	movsb
	sub	si,dx
	sub	di,dx
	dec	bl
	jnz	bs3
	jmp	bsx
_blockscroll ENDP
END