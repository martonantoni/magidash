.MODEL COMPACT
.386
.DATA
PUBLIC _ShootTmr1,_ShootTmr2,_ShootX1,_ShootX2,_ShootY1,_ShootY2
PUBLIC _ShootD1,_ShootD2,_ShootOK
_ShootTmr1 DW 0
_ShootTmr2 DW 0
_ShootX1 DW 0
_ShootX2 DW 0
_ShootY1 DW 0
_ShootY2 DW 0
_ShootD1 DW 0
_ShootD2 DW 0
_ShootOK DW 0
ENDS
.CODE

PUBLIC _initshoot,_shotdownshoot

oirq: DD 0
PROC irq
	push	ax
	push	ds
	mov	ax,seg DGROUP
	mov	ds,ax
	mov	ax,_ShootTmr1
	pop	ds
	pop	ax
	iret
irq ENDP
PROC _initshoot
	push	ds
	mov	ah,35h
	mov	al,1ch
	int	21h
	mov	word ptr oirq+2,es
	mov	word ptr oirq,bx
	push	cs
	pop	ds
	mov	ah,25h
	mov	al,1ch
	mov	dx,offset irq
	int	21h
	pop	ds
	ret
_initshoot ENDP
_shotdownshoot PROC
	push	ds
	mov	ax,word ptr oirq+2
	mov	ds,ax
	mov	dx,word ptr oirq
	mov	ah,25h
	mov	al,1ch
	int	21h
	pop	ds
	ret
_shotdownshoot ENDP
END
