.MODEL COMPACT
.386
.CODE
;ASSUME CS:_TEXT
_pscene : DD 0
_pgfx : DD 0
_pwin : DD 0
_pw : DD 0
_pbm: DD 0
_onep : DW 0
tsi: DW 0
szor: DW 5120
;PUBLIC _pscene,_pgfx,_pwin,_pw,_onep,_pbm

; This all must be done becouse one person : MAXX !  Grrrr !!!

PUBLIC _ShowScape,_ShowBottomMarble,_StoreBottomMarble
PUBLIC _RestoreMarble,_ShowMarble,_DashASM,_ScrollerASM
PUBLIC _SetVars,_Logo2Pic,_OldStyleStarfield,_MarbleCut,_CorrectSFX
PUBLIC _Buf2Pic,_PutOne,_PutBullet
_SetVars PROC
ARG p1:dword,p2:dword,p3:dword,p4:dword,p5:dword,i1:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	lds	si,p1
	mov	word ptr _pscene+2,ds
	mov	word ptr _pscene,si
	lds	si,p2
	mov	word ptr _pgfx+2,ds
	mov	word ptr _pgfx,si
	lds	si,p3
	mov	word ptr _pwin+2,ds
	mov	word ptr _pwin,si
	lds	si,p4
	mov	word ptr _pw+2,ds
	mov	word ptr _pw,si
	lds	si,p5
	mov	word ptr _pbm+2,ds
	mov	word ptr _pbm,si
	mov	ax,i1
	mov	word ptr _onep,ax
	pop	ds
	pop	si
	pop	bp
	ret
_SetVars ENDP
_ShowScape PROC
ARG pos:word,pos2:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	test word ptr _onep,0ffffh
	jz	ss1
		  ;	push	ds
			lds	si,dword ptr _pscene
			add	si,pos
			mov	bl,11
			cld
			les	di,dword ptr _pwin
		cikl1:
			mov	cx,5
			rep	movsd
			add	si,30
			dec	bl
			jnz	cikl1
		 ;	pop	ds
			jmp	ss2

ss1:		;	push	ds
			lds	si,dword ptr _pscene
			add	si,pos2
			mov	bl,11
			mov	ax,91+(92*256)     ;// koztes tartomany
			cld
			les	di,dword ptr _pwin
		cikl5:
			movsd
			movsd
			movsb
			stosw
			add	si,41
			add	di,9
			dec	bl
			jnz	cikl5
			lds	si,dword ptr _pscene
			add	si,pos
			les	di,dword ptr _pwin
			add	di,11
			mov	bl,11
		cikl6:
			movsd
			movsd
			movsb
			add	si,41
			add	di,11
			dec	bl
			jnz	cikl6
    ;			pop	ds



ss2:	 ;	push	ds
		les	di,dword ptr _pw
		lgs	bx,dword ptr _pwin
		lds	si,dword ptr _pgfx
		mov	word ptr tsi,si
		mov	dh,11
	cikl4: mov	dl,20
	cikl3:
		mov	al,gs:[bx]
		inc	bx
		xor	ah,ah
		sal	ax,4
		add	si,ax
		mov	cx,16
	cikl2:
		movsd
		movsd
		movsd
		movsd
		add	si,3840-16
		add	di,304
		loop	cikl2
		mov	si,word ptr tsi
		sub	di,5424-320 ;  // -320 ?
		dec	dl
		jnz	cikl3
		add	di,4800  ;; // +- 320 ?
		dec	dh
		jnz	cikl4
		pop	ds


		push	ds
		mov	ax,0a000h
		mov	es,ax
		xor	di,di
		lds	si,dword ptr _pw
		mov	cx,28160
		cld

   mov dx,3dah
waitoffcikl: in al,dx
   test al,8
   jz waitoffcikl
waitoffcikl2: in al,dx
	test al,8
	jnz waitoffcikl2


		rep	movsw
		pop	di
		pop	ds
		pop	si
		pop	bp
	ret

_ShowScape ENDP
ssi: DW 0
sds: DW 0
ssi2: DW 0
sds2: DW 0
_ShowBottomMarble PROC
ARG btab:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di

		lds	si,dword ptr _pgfx
		mov	ax,0a000h
		mov	es,ax
		xor	bx,bx
		mov	di,56320 ;// -320
		mov	word ptr ssi,si
		cld
		mov	dl,20
	cikl12:
		mov	word ptr sds2,ds
		mov	word ptr ssi2,si
		lds	si,btab
		mov	al,ds:[si+bx]
		inc	bx
		xor	ah,ah
		sal	ax,4
		mov	ds,word ptr sds2
		mov	si,word ptr ssi2
		add	si,ax
		mov	al,16
	cikl32:
		mov	cx,4
		rep	movsd
		add	si,3840-16
		add	di,304
		dec	al
		jnz	cikl32
		mov	si,word ptr ssi
		sub	di,5424-320 ;  // -320 ?
		dec	dl
		jnz	cikl12
		add  di,15*320
		mov	dl,20
	cikl52:
		mov	word ptr sds2,ds
		mov	word ptr ssi2,si
		lds	si,btab
		mov	al,ds:[si+bx]
		inc	bx
		xor	ah,ah
		sal	ax,4
		mov	ds,word ptr sds2
		mov	si,word ptr ssi2
		add	si,ax
		mov	al,8
	cikl42:
		mov	cx,4
		rep	movsd
		add	si,3840-16
		add	di,304
		dec	al
		jnz	cikl42
		mov	si,word ptr ssi
		sub	di,5424-2880
		dec	dl
		jnz	cikl52

	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_ShowBottomMarble ENDP
_StoreBottomMarble PROC
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di

		mov	ax,0a000h
		mov	ds,ax
		mov	si,56320
		les	di,dword ptr _pbm
		cld
		mov	cx,3840
		rep	movsw

	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_StoreBottomMarble ENDP
_RestoreMarble PROC
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di

		mov	ax,0a000h
		mov 	es,ax
		lds	si,dword ptr _pbm
		mov  cx,3840
		mov	di,56320
		cld
		rep	movsw

	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_RestoreMarble ENDP
_ShowMarble PROC
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di

		lds	si,dword ptr _pgfx
		mov	ax,0a000h
		mov	es,ax
		xor	di,di
		add	si,89*16
		mov	word ptr ssi,si
		cld
		mov	dh,12
	cikl23:
		mov	dl,20
	cikl13:
		mov	al,16
	cikl33:
		mov	cx,4
		rep	movsd
		add	si,3840-16
		add	di,304
		dec	al
		jnz	cikl33
		mov	si,word ptr ssi
		sub	di,5424-320 ;  // -320 ?
		dec	dl
		jnz	cikl13
		add  di,15*320
		dec	dh
		jnz	cikl23
		mov	dl,20
	cikl53:
		mov	al,8
	cikl43:
		mov	cx,4
		rep	movsd
		add	si,3840-16
		add	di,304
		dec	al
		jnz	cikl43
		mov	si,word ptr ssi
		sub	di,5424-2880
		dec	dl
		jnz	cikl53
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_ShowMarble ENDP
_DashASM PROC
ARG pt2:dword

	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di

		les	di,pt2
		add	di,500
		lds	si,pt2
		mov	cx,124
		xor	eax,eax
		cld
		rep	movsd
		les	di,pt2
		mov	cx,124
		rep	stosd

	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_DashASM ENDP
_ScrollerASM PROC

	push	ds
	push	si
	push	di

		lds	si,dword ptr _pbm
		les	di,dword ptr _pbm
		add	di,7680
		cld
		mov	cx,1920
		rep	movsd

	pop	di
	pop	si
	pop	ds
	ret
_ScrollerASM ENDP
_Logo2Pic PROC
ARG src:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lds	si,src
	mov	ax,0a000h
	mov	es,ax
	mov	di,320*0
	cld
	mov	cx,160*58
	rep	movsw
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_Logo2Pic ENDP
_OldStyleStarfield PROC
ARG dat:dword,pic:dword,sc:word,tmr:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lds	si,pic
	les	di,dat
	mov	ax,0a000h
	mov	gs,ax
	mov	cx,21
os1:	mov	bx,es:[di]
	mov	al,ds:[si+bx]
	mov	gs:[bx+320*159],al
	inc	bx
	cmp	bx,sc
	je	os2
os3:	;mov	byte ptr gs:[bx+320*159],19    ; White
	mov	es:[di],bx
	add	di,2
	loop	os1
;	test	tmr,1
;	jz	ose
	mov	cx,21
os4:	mov	bx,es:[di]
	mov	al,ds:[si+bx]
	mov	gs:[bx+320*159],al
 ;	inc	bx
 ;	cmp	bx,sc
 ;	je	os6
	dec	bx
	js	os6
os5:	;mov	byte ptr gs:[bx+320*159],23    ; Gray
	mov	es:[di],bx
	add	di,2
	loop	os4
ose:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
os2:	mov	bx,0
	jmp	os3
os6:	mov	bx,sc
	jmp	os5
_OldStyleStarfield ENDP
_MarbleCut PROC
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	mov	ax,0a000h
	mov	es,ax
	mov	di,320*177
	mov	cx,160*5
	xor	ax,ax
	cld
	rep	stosw
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_MarbleCut ENDP
_CorrectSFX PROC
ARG sfx:dword,l:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	lds	si,sfx
	les	di,sfx
	mov	cx,l
csc:	lodsb
	add	al,128
	stosb
	loop	csc
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_CorrectSFX ENDP
_Buf2Pic PROC
ARG buf:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	mov	cx,64000
	lds	si,buf
	mov	ax,0a000h
	mov	es,ax
	xor	di,di
b2c:	lodsb
	cmp	al,0
	je	b21
	stosb
	loop	b2c
b2e:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
b21:	inc	di
	loop	b2c
	jmp	b2e
_Buf2Pic ENDP
_PutOne proc
ARG x:word,y:word,item:word
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	cld
	sal	x,4
	mov	ax,y
	mul	word ptr szor
	add	ax,x
	mov	di,ax
	mov	ax,0a000h
	mov	es,ax
	lds	si,dword ptr _pgfx
	sal	item,4
	add	si,item
	mov	al,16
poc:	mov	cx,8
	rep	movsw
	add	si,3840-16
	add	di,320-16
	dec	al
	jnz  poc
	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
_PutOne endp
szor320: DW 320
_PutBullet proc
ARG x:word,y:word,gfx:dword
	push	bp
	mov	bp,sp
	push	si
	push	ds
	push	di
	lds	si,gfx
	cld
	mov	ax,0a000h
	mov	es,ax
	mov	ax,y
	mul	word ptr szor320
	add	ax,x
	mov	di,ax
	mov	cx,4
pbc:	cmp	es:[di],word ptr 0
	jne	pb1
	movsw
pb3:	cmp	es:[di],word ptr 0
	jne	pb2
	movsw
	add	di,316
	loop	pbc
pbe:	pop	di
	pop	ds
	pop	si
	pop	bp
	ret
pb1:	add	di,2
	add	si,2
	jmp	pb3
pb2:	add	si,2
	add	di,318
	loop	pbc
	jmp	pbe
_PutBullet endp



END