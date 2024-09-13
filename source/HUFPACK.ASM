.MODEL COMPACT
.386
.CODE

PUBLIC _CountBytes,_MakeTree,_MakeChangeTab,_HufPack,_HufDePack
PUBLIC _PlantTree,_MakeDelta,_Filter,_DeltaBack

_CountBytes PROC
ARG src:dword,tab:dword,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	les	di,tab
	lds	si,src
	mov	cx,l
c1:  mov	bl,ds:[si]
	xor	bh,bh
	sal	bx,3
	inc	word ptr es:[di+bx]
	inc	si
	loop	c1
	mov	cx,256
	xor	bx,bx
	mov	ax,256
c1b:	test	word ptr es:[di+bx],0ffffh
	jnz	cb1
	mov	word ptr es:[di+bx],-1
	dec	ax
cb1:	add	bx,8
	loop	c1b
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_CountBytes ENDP
_PlantTree PROC
ARG buf:dword,tree:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lds	si,buf
	les	di,tree
	cld
;	add	di,6
	mov	cx,256
	mov	dx,256
	mov	eax,-1
	stosd
	stosw
ptc: cmp	word ptr ds:[si],-1
	jne	pt1
	dec	dx
pt1:	movsw
	stosd
	stosw
	loop	ptc
	mov	cx,255*2
	rep	stosd
	mov	ax,dx
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_PlantTree ENDP

pos: DW 0
_MakeTree PROC
ARG tree:dword,epos:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lds	si,tree
	mov	word ptr pos,256*8
c3:	xor	bx,bx
	mov	ax,-1   ; -> cx
	mov	dx,-1   ; -> di
c2:	cmp	word ptr ds:[si+bx+6],-1
	je	mt1
	cmp	dx,ds:[si+bx+6]
	ja	mt2
mt1:	add	bx,8
	cmp	bx,511*8
	jne	c2
	mov	bx,word ptr pos
	add	ax,dx
	mov	word ptr ds:[si+bx+6],ax
	mov	word ptr ds:[si+bx],cx
	mov	word ptr ds:[si+bx+2],di
	mov	ax,bx
	mov	bx,cx
	mov	word ptr ds:[si+bx+4],ax
	mov	word ptr ds:[si+bx+6],-1
	mov	bx,di
	mov	word ptr ds:[si+bx+4],ax
	mov	word ptr ds:[si+bx+6],-1
	add	ax,8
	mov	word ptr pos,ax
	cmp	ax,epos
	jne	c3
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
mt2:	cmp	ax,ds:[si+bx+6]
	ja	mt3
	mov	dx,ds:[si+bx+6]
	mov	di,bx
	jmp	mt1
mt3:	mov	dx,ax
	mov	di,cx
	mov	ax,ds:[si+bx+6]
	mov	cx,bx
	jmp	mt1
_MakeTree ENDP
_MakeChangeTab PROC
ARG tree:dword,ctab:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di

	lds	si,tree
	les	di,ctab
	xor	cx,cx

c5:	mov	bx,cx
	mov	word ptr pos,cx
	xor	ecx,ecx
	sal  bx,3
c4:	cmp	word ptr ds:[si+bx+4],-1
	je	mc1
	mov	ax,bx
	mov	bx,ds:[si+bx+4]
	cmp	ax,ds:[si+bx]
	je	mc2
	bts	edx,ecx
mc3:	inc	cx
	jmp	c4
mc2:	btr	edx,ecx
	jmp	mc3
mc1:	mov	ax,32
	mov	byte ptr es:[di+7],cl
	sub	ax,cx
	mov	cl,al
	sal	edx,cl
	mov	dword ptr es:[di],edx
	add	di,8

	mov	cx,word ptr pos
	inc	cx
	cmp	cx,256
	jne	c5

	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_MakeChangeTab ENDP
_HufPack PROC
ARG ctab:dword,src:dword,dest:dword,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld

	lds	si,src
	les	di,dest
	lgs	dx,ctab
	mov	cx,l
	mov	word ptr pos,cx
	push	bp
	mov	bp,dx     ;   !!!
	mov	dx,15
	xor	ch,ch

c7:	lodsb
	xchg	si,bp
	mov	bl,al
	xor	bh,bh
	sal	bx,3
	mov	cl,gs:[si+bx+7]
	mov	eax,gs:[si+bx]
	xchg	si,bp

c6:	bt	eax,31
	jc	hp1
	btr	word ptr es:[di],dx
hp2: sal	eax,1
	dec	dx
	jns	hp3
	mov	dx,15
	add	di,2
hp3:	loop	c6

	dec	word ptr pos
	jnz	c7
	pop	bp
	mov	ax,di
	add	ax,2   ; !!! - The depacked file will be longer !!!
	les	di,dest
	sub	ax,di

	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
hp1:	bts	word ptr es:[di],dx
	jmp	hp2
_HufPack ENDP
_HufDePack PROC
ARG tree:dword,src:dword,dest:dword,l:word,root:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld

	lds	si,src
	les	di,dest
	lgs	bx,tree
	mov	word ptr pos,bx
	mov	dx,15
	mov	cx,l

c9:	xchg	word ptr pos,di
	mov	bx,root
c8:	bt	word ptr ds:[si],dx
	jc	hd1
	dec	dx
	jns	hd2
	mov	dx,15
	add	si,2
hd2:	mov	bx,word ptr gs:[di+bx]
hd3:	cmp	word ptr gs:[di+bx],-1
	je	hdg
	jmp	c8

hd1:	dec	dx
	jns	hd4
	mov	dx,15
	add	si,2
hd4:	mov	bx,word ptr gs:[di+bx+2]
	jmp	hd3
hdg:	sar	bx,3
	xchg	di,word ptr pos
	mov	al,bl
	stosb
	loop	c9
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret

_HufDePack ENDP
_MakeDelta PROC
ARG src:dword,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,src
	les	di,src
	mov	cx,l
	mov	bl,ds:[si]
c10:	lodsb
	sub	al,ds:[si]
	cmp	al,0
	je	mdw
	neg	al
mdw:	stosb
	loop c10
	mov	al,bl
	xor	ah,ah
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_MakeDelta ENDP
_DeltaBack PROC
ARG src:dword,l:word,first:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,src
	mov	bx,1
	mov	ax,first
	mov	ah,ds:[si]
	mov	byte ptr ds:[si],al
	mov	cx,l
dbc:	mov	al,ds:[si+bx]
	mov	dl,ds:[si+bx-1]
	add	dl,ah
	mov	byte ptr ds:[si+bx],dl
	mov	ah,al
	inc	bx
	loop	dbc
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_DeltaBack ENDP
_Filter PROC
ARG tree:dword,src:dword,l:word,f:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,tree
	add	si,6
	xor	bx,bx
	mov	dx,f
c11:	cmp  word ptr ds:[si+bx],dx
	jb	f1
f1b:	add	bx,8
	cmp	bx,256*8
	jne	c11
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
f1:	mov	cx,256*8
	sub	cx,bx
	mov	ax,bx
	mov	word ptr pos,si
	add	si,bx
	mov	bx,8
c12:	cmp	bx,cx
	jae	f2		; Maybe ja better
	cmp	word ptr ds:[si+bx],-1
	je	f2
	cmp	word ptr ds:[si+bx],dx
	ja	fg1
f2:	cmp	bx,ax
	jae	f3
	cmp	word ptr ds:[si-bx],-1
	je   f3
	cmp	word ptr ds:[si-bx],dx
	ja	fg2
f3:	add	bx,8
	jmp	c12
fg1: add	bx,ax
fga:	sar	bx,3
	xchg	bl,al
	mov	bh,ah
	mov	dx,bx			; The filter must be reloaded !
	sar	dx,3
	mov	si,word ptr pos
	les	di,src
	mov	cx,l
c13:	cmp  es:[di],dl
	je	f4
	inc	di
	loop	c13
	mov	dx,f
	jmp	f1b
f4:	stosb
	loop	c13
	mov	dx,f
	jmp	f1b
fg2: sub	bx,ax
	neg	bx
	jmp	fga
_Filter ENDP

END