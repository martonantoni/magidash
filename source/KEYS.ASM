.MODEL COMPACT
.386
.CODE
PUBLIC _keyirq
_keyirq PROC
	jmp	setit
oldirq: DW 0
oldirq2: DW 0
sdi: DW 0
ses: DW 0
ls: DW 0
irq: sti
	pushf
	push	ax
	push	ds
	push	0a000h
	pop	ds
	inc	dword ptr ds:[0]
	in	al,61h
	mov	ah,al
	or	al,80h
	out	61h,al
	xchg	ah,al
	out	61h,al
	mov	al,20h
	out	20h,al
	pop	ds
	pop	ax
	popf
	iret
setit:
	push	bp
	mov	bp,sp
	push	si
	push ds
	les	si,[bp+4]
;	mov	word ptr ses,es
;	mov	word ptr sdi,si
	xor	al,al
	cmp	al,es:[si+500]
	jne	rei
	mov	ax,3509h
	int	21h
	mov	word ptr oldirq,bx
	mov	word ptr oldirq2,es
	push	cs
	pop	ds
	mov	dx,offset irq
	mov	ax,2509h
	int	21h
	lds	si,[bp+8]
	mov	word ptr ses,es
	mov	word ptr sdi,si
	pop	ds
	pop	si
	pop	bp
	ret
rei: mov	ds,word ptr oldirq2
	mov	dx,word ptr oldirq
	mov	ax,2509h
	int	21h
	pop	ds
	pop	si
	pop	bp
	ret
_keyirq ENDP
END