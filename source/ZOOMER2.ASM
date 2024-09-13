.MODEL COMPACT
.386
.CODE
rw:	DW 0
rh:	DW 0
pw:	DW 0
t:	DW 0
t2:	DW 0
szor:DW 320
PUBLIC _zoomer
_zoomer PROC
ARG source:dword,w:word,h:word,spw:word,dest:dword,x1:word,y1:word,x2:word,y2:word,buff:dword
;void zoomer(char far*,int,int,int,char far *,int,int,int,int,char far *);
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld

; For all :

	mov	ax,x2
	sub	ax,x1
	mov	word ptr rw,ax
	mov	word ptr pw,320
	sub	word ptr pw,ax
	mov	ax,y2
	sub	ax,y1
	mov	word ptr rh,ax

; Generate zoomtab for ZOOMING only !

	les	di,buff
	xor	dx,ax
	xor	cx,cx
	xor	ax,ax
c1:	inc	dx
	inc	ax
	cmp	dx,word ptr rw
	je	l1
	add	cx,w
	cmp	cx,word ptr rw
	jb   c1
	stosw
	xor	ax,ax
	sub	cx,word ptr rw
	jmp	c1
l1:	stosw
	xor	ax,ax
	stosw

; ZOOMING with a zoomtab :

	lgs	bx,buff
	mov	word ptr t,bx
	les	di,dest
	lds	si,source
	mov	ax,y1
	mul	word ptr szor
	add	ax,x1
	add	di,ax
	xor	ax,ax
	mov	dx,word ptr rh
	mov	word ptr t2,si
c2:	mov	cx,gs:[bx]
	test	cx,0ffffh
	jz	l2
	add	bx,2
	lodsb
	rep	stosb
	jmp	c2
l2:  dec	dx
	jz	ex
	add	di,word ptr pw
	mov	si,word ptr t2
	add	si,spw
	mov	word ptr t2,si
	add  ax,h
	cmp	ax,word ptr rh
	jb	l3
	sub	ax,word ptr rh
	mov	bx,word ptr t
	jmp	c2
	jmp	ex
l3:	mov	cx,word ptr rw
	push	ds
	mov	cx,es
	mov	ds,cx
	mov	si,di
	sub	si,320
	rep	movsb        ; Here is a place for optimize
	pop	ds
	jmp	l2

ex:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_zoomer ENDP
END