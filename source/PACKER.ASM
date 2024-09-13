.MODEL COMPACT
.386
.CODE
PUBLIC _pack,_depack
_pack PROC
ARG source:dword,dest:dword,length:word,jb:word
	push	bp
	mov  bp,sp
	push	si
	push	ds
	push	di
	mov	ax,jb
	xchg al,ah
	cld
	les	di,dest
	lds	si,source
	mov	cx,length
c1:	lodsb
	cmp	al,ah
	je	oi1
	mov	bl,al
	loop	c2
	stosb
	jmp	fin
c2:	lodsb
	cmp	al,ah
	je	oi2
	cmp	al,bl
	jne	no1
	loop	n1
	stosb
	stosb
	jmp	fin
n1:	lodsb
	cmp	al,ah
	je	oi3
	cmp	al,bl
	jne	no2
	loop	n2
	stosb
	stosb
	stosb
	jmp	fin
n2:	lodsb
	cmp	al,ah
	je	oi4
	cmp	al,bl
	jne	no3
	mov	dx,3
	dec	si
c3:	inc	dx
	loop	n3
	xchg	al,ah
	stosb
	mov	al,ah
	stosb
	mov	ax,dx
	stosw
	jmp	fin
n3:  inc	si
	cmp	al,ds:[si]
	je	c3
	xchg	al,ah
	stosb
	xchg	al,ah
	stosb
	xchg	ax,dx
	stosw
	mov	ax,dx
;	mov	al,ds:[si]
	inc	cx
;	dec	si
	loop	c1
	jmp	fin
oi1:	stosb
	stosb
co1:	loop	cc1
	jmp	fin
cc1:	jmp	c1
oi2:	xchg	al,bl
	stosb
	mov	al,bl
	stosb
	stosb
co3:	loop	cc1
	jmp	fin
oi3:	xchg	al,bl
	stosb
	stosb
	mov	al,bl
	stosb
	stosb
co4:	loop	cc1
	jmp	fin
oi4: xchg	al,bl
	stosb
	stosb
	stosb
	mov	al,bl
	stosb
	stosb
	loop	cc1
	jmp	fin
cc2:	jmp	c2
no1:	xchg	al,bl
	stosb
co2:	loop	cc2
fin: mov	ax,di
	les	di,dest
	sub	ax,di
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
no2: xchg al,bl
	stosb
	stosb
co5:	loop	cc2
	jmp	fin
no3:	xchg	al,bl
	stosb
	stosb
	stosb
	loop	cc2
	jmp	fin
_pack ENDP
_depack PROC
ARG source:dword,dest:dword,length:word,jb:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	mov	ax,jb
	mov	cs:byte ptr jeb,al
	lds	si,source
	les	di,dest
	mov	dx,si
	add	dx,length
c4:	lodsb
	cmp	al,cs:byte ptr jeb
	je	nu
	stosb
	cmp	si,dx
	jb	c4
dpe:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
nu:	lodsb
	cmp	al,cs:byte ptr jeb
	je	nuc
	mov	cl,al
	lodsw
	xchg	ax,cx
	rep	stosb
	cmp	si,dx
	jb	c4
	jmp	dpe
nuc:	stosb
	cmp	si,dx
	jb	c4
	jmp	dpe
jeb: DB 0
_depack ENDP
END
