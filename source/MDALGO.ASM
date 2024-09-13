.MODEL COMPACT
.386
.CODE
PUBLIC _guenwhyvar
sfx_2: DB 0
_guenwhyvar PROC
	mov	byte ptr sfx_2,0
	jmp	gg
smoke:
	dec	al
	cmp	al,55
	je	s1
	cmp	al,61
	je	s2
	cmp	al,67
	je	s3
	cmp	al,73
	je	s4
	cmp	al,79
	je	s5
	mov	es:[di],al
	jmp	cont
s1:	mov	al,6
	mov	es:[di],al
	jmp	cont
s2:	xor	al,al
	mov	es:[di],al
	jmp	cont
s3:	mov	al,32
	mov	es:[di],al
	jmp	cont
s4:	mov	al,12
	mov	es:[di],al
	jmp	cont
s5:	mov	es:[di],byte ptr 5
	jmp	cont
ses: DW 0
sdi: DW 0
gg:	push bp
	mov bp,sp
	push si
	push ds
	les di,[bp+4]
	mov	dh,0
	mov	es:[di+2580],byte ptr 0
	mov	es:[di+2582],byte ptr 0
	mov	es:[di+2585],byte ptr 0
	mov	es:[di+2587],byte ptr 0
	cmp	es:[di+2550],byte ptr 0
	mov	al,79
	jne	g2p
	mov	al,85
g2p:	mov	ah,al
	mov	dx,es
	mov	word ptr ses,dx
	mov	word ptr sdi,di
	push	cs
	pop	es
	mov	di,offset b_tab+48-13
	stosw
	stosw
	stosw
	stosw
	mov	es,word ptr ses
	mov	di,word ptr sdi
	jmp	wqpl
wqpb:jmp	mspl
mspb:cld
	mov cx,2500
	xor bl,bl
	mov bh,128
cikl:
	mov al,es:[di]
	cmp al,5
	jb cont
	cmp al,128
	jae com
	cmp al,19
	jb fall
	cmp al,32
	jb wall
	cmp al,48
	jb monster
	cmp al,56
	jb players
	cmp al,92
;	je water
	jne smoke
cont:
	inc di
	loop cikl
ce:  lds	si,[bp+4]
	mov	al,byte ptr sfx_2
	mov	ds:[si+2552],al
	pop ds
	pop si
	pop bp
	ret
monster:jmp mons
players:jmp plr
;water:jmp wtr
com:	xor es:[di],bh
	inc di
	loop cikl
	jmp ce
fall:
	mov	dl,es:[di+50]
	cmp	dl,23
	je	wab
	cmp	dl,29
	je	wm1
	cmp	dl,30
	je	wm2
	cmp 	al,13
	jae	frfa
frc:	cmp 	bl,es:[di+50]
	je	okf1
;	mov	byte ptr sfx_2,1
	cmp 	dl,5
	jb 	cont
	cmp 	dl,13
	jb 	okf2
	cmp 	dl,19
	jb 	okf2     ; Vagy okf3, ha a ko robbanora esve robbant
	cmp 	dl,21
	jb 	okf2
	cmp 	dl,32
	jb 	cont
	cmp	dl,56
	jae	cont
	jmp	okf3
okf1:mov 	es:[di],bl
	mov 	es:[di+50],al
	or 	es:[di+50],bh
	jmp 	cont
okf2:cmp 	bl,es:[di-1]
	je 	fsl
fnl:	cmp 	bl,es:[di+1]
	je 	fsr
fc:	jmp 	cont
fsl: cmp 	bl,es:[di+49]
	jne 	fnl
	mov 	es:[di],bl
	mov 	es:[di-1],al
	jmp 	cont
fsr: cmp 	bl,es:[di+51]
	jne 	fc
	mov 	es:[di],bl
	mov 	es:[di+1],al
	or 	es:[di+1],bh
	jmp 	cont
frfa:test al,1
	jz	fti
	inc	al
	jmp	frc
fti:	cmp	es:[di+50],bl
	je	okf1
	mov	si,di
	cmp	al,18
	je	beg
	jmp	boom
okf3:cmp	dl,48
	jae	f3h
	cmp	al,18
	je	f3r
f3b:	mov 	es:[di],bl
	mov	al,es:[di+50]
f3r:	mov	si,di
	add	si,50
	jmp	boom
f3h:	mov	ds,word ptr ses
	mov	si,word ptr sdi
	cmp	dl,51
	jbe	fhc
	add	si,5
fhc:	cmp	bl,ds:[si+2581]
	je	f3b
	jne	cont
wq_tmr: DW 0
wq_tmrlist: DB 1,0,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,0
wq_list: DB 133,134,135,128+11,128+14
wall:cmp	al,23
	jb	wac
	cmp	al,29
	jb	wqu
wac:	jmp	cont
wmt:	DB 0,0,0,0,0,6,7,8,5,10,11,12,18
wmt2:DB 0,0,0,0,0,10,1,5,7,10,6,12,11
even
wm1:	cmp	bl,es:[di+100]
	jne	cont
	mov	es:[di],bl
	cmp	al,13
	jae	wmb
	push	bx
	mov	bl,al
	xor	bh,bh
	mov	si,offset wmt
	mov	dl,cs:[si+bx]
	or	dl,128
	mov	es:[di+100],dl
	pop	bx
	jmp	cont
wm2:	cmp	bl,es:[di+100]
	jne	cont
	mov	es:[di],bl
	cmp	al,13
	jae	wmb
	push	bx
	mov	bl,al
	xor	bh,bh
	mov	si,offset wmt2
	mov	dl,cs:[si+bx]
	or	dl,128
	mov	es:[di+100],dl
	pop	bx
	jmp	cont
wmb:	mov	si,di
	add	si,50
	jmp	boom
wab:	mov 	es:[di],bl
	jmp 	cont
wqu:	mov	si,word ptr wq_tmr
	add	si,offset wq_tmrlist
	mov	dl,1
	test	cs:[si],dl
	jz	wqc
	xor	ah,ah
	mov	si,ax
	add	si,offset wq_list ;-24
	sub	si,24             ;
	mov	dl,cs:[si]
	cmp	bl,es:[di+50]
	jne	wjm
	mov	es:[di+50],dl
wqc:	jmp	cont
wjm:	jmp	cont
wqpl:mov	ax,word ptr wq_tmr
	inc	ax
	cmp	ax,23
	jne	wqp1
	xor	ax,ax
wqp1:mov	word ptr wq_tmr,ax
	jmp	wqpb
boom:xchg	di,word ptr sdi
	mov	es:[di+2551],byte ptr 1
	xchg	di,word ptr sdi
	push	bx
	push	cx
	mov 	bl,al
	xor	bh,bh
	mov  al,cs:byte ptr b_tab[bx-13]
	mov	cx,9
bc:	mov	bx,cx
	sal	bx,1
	mov	bx,cs:word ptr b_ofs[bx]
	mov	dl,es:[si+bx]
	cmp	dl,20
	je	nob
	cmp	dl,21
	je	nob
	cmp	dl,22
	je	nob
	mov	es:[si+bx],al
nob:	loop bc
	pop	cx
	pop	bx
	jmp	cont
beg:	push	bx
	push	cx
	mov 	bl,al
	xor	bh,bh
	mov  al,cs:byte ptr b_tab[bx-13]
	mov	cx,9
bc2:	mov	bx,cx
	sal	bx,1
	mov	bx,cs:word ptr b_ofs[bx]
	mov	dl,es:[si+bx]
	cmp	dl,20
	je	nob2
	cmp	dl,21
	je	nob2
	cmp	dl,29
	je	nob2
	cmp	dl,44
	jae	be1
	mov	es:[si+bx],al
nob2:loop bc2
	pop	cx
	pop	bx
	jmp	cont
be1:	cmp	dl,48
	jb	nob2
	mov	es:[si+bx],al
	jmp	nob2
b_ofs: DW 0,-51,-50,-49,-1,0,1,49,50,51
b_tab: DB 61,61,67,67,73,73
	  DB 13 DUP (67)
	  DB 61,61,61,61,67,67,67,67,85,85,85,85,73,73,73,73,79,79,79,79,79,79,79,79,79,79
ms1:	DB 0
ms50:DB 0
ms_1:DB 0
ms_50:DB 0
ms_tmr:DW 0
ms_tmrlist:DB 0,0,0,0,2,0,0,0,1,0,2,0,0,0,0,1,0,0,0,2,0,0,0,0,0
mons:cmp	es:[di-50],byte ptr 5
	jb	moc
	cmp	es:[di-50],byte ptr 19
	jae	moc
	cmp	es:[di-50],byte ptr 17
	jb	mbc
	mov	al,18
mbc:	mov	si,di
	jmp	boom
moc: cmp	al,40
	jae	msp
msc:	mov	dl,48
	mov	dh,es:[di+1]
	mov	byte ptr ms1,dh
	and	dh,127
	mov	es:[di+1],dh
	mov	dh,es:[di+50]
	mov	byte ptr ms50,dh
	and	dh,127
	mov	es:[di+50],dh
	mov	dh,es:[di-50]
	mov	byte ptr ms_50,dh
	mov	dh,es:[di-1]
	mov	byte ptr ms_1,dh
	cmp	es:[di-50],byte ptr 56
	jb	mm1
	mov	es:[di-50],byte ptr 19
mm1: cmp	es:[di-1],byte ptr 56
	jb	mm2
	mov	es:[di-1],byte ptr 19
mm2:	cmp	es:[di+1],byte ptr 56
	jb	mm3
	mov	es:[di+1],byte ptr 19
mm3:	cmp	es:[di+50],byte ptr 56
	jb	mm4
	mov	es:[di+50],byte ptr 19
mm4:	mov	ah,al
	and	ah,3
	test	ah,3
	jz	mo0
	cmp	ah,2
	jb	mo1
	je	mo2
	cmp	bl,es:[di+50]
	je	mhd
	cmp	dl,es:[di+50]
	jbe	mhd
	cmp	bl,es:[di-1]
	je	mhl
	cmp	dl,es:[di-1]
	jbe	mhl
	cmp	bl,es:[di-50]
	je	mhu
	cmp	dl,es:[di-50]
	jbe	mhu
	cmp	bl,es:[di+1]
	je	mhr
	cmp	dl,es:[di+1]
	jbe	mhr
mrc:	mov	dh,byte ptr ms_50
	mov	es:[di-50],dh
	mov	dh,byte ptr ms_1
	mov	es:[di-1],dh
	mov	dh,byte ptr ms50
	mov	es:[di+50],dh
	mov	dh,byte ptr ms1
	mov	es:[di+1],dh
	jmp	cont
mo0:	cmp	bl,es:[di-1]
	je	mhl
	cmp	dl,es:[di-1]
	jbe	mhl
	cmp	bl,es:[di-50]
	je	mhu
	cmp	dl,es:[di-50]
	jbe	mhu
	cmp	bl,es:[di+1]
	je	mhr
	cmp	dl,es:[di+1]
	jbe	mhr
	cmp	bl,es:[di+50]
	je	mhd
	cmp	dl,es:[di+50]
	jbe	mhd
	ja	mrc
mo1:	cmp	bl,es:[di-50]
	je	mhu
	cmp	dl,es:[di-50]
	jbe	mhu
	cmp	bl,es:[di+1]
	je	mhr
	cmp	dl,es:[di+1]
	jbe	mhr
	cmp	bl,es:[di+50]
	je	mhd
	cmp	dl,es:[di+50]
	jbe	mhd
	cmp	bl,es:[di-1]
	je	mhl
	cmp	dl,es:[di-1]
	jbe	mhl
	ja	mrc
mo2:	cmp	bl,es:[di+1]
	je	mhr
	cmp	dl,es:[di+1]
	jbe	mhr
	cmp	bl,es:[di+50]
	je	mhd
	cmp	dl,es:[di+50]
	jbe	mhd
	cmp	bl,es:[di-1]
	je	mhl
	cmp	dl,es:[di-1]
	jbe	mhl
	cmp	bl,es:[di-50]
	je	mhu
	cmp	dl,es:[di-50]
	jbe	mhu
	ja	mrc
mhd:	mov	dh,byte ptr ms1
	mov	es:[di+1],dh
	mov	dh,byte ptr ms_50
	mov	es:[di-50],dh
	mov	dh,byte ptr ms_1
	mov	es:[di-1],dh
	and	al,not 3
	or	al,82h
	mov	es:[di+50],al
	jmp	mc
mhu: mov	dh,byte ptr ms50
	mov	es:[di+50],dh
	mov	dh,byte ptr ms1
	mov	es:[di+1],dh
	mov	dh,byte ptr ms_50
	mov	es:[di-50],dh
	mov	dh,byte ptr ms_1
	mov	es:[di-1],dh
	and	al,not 3
	mov	es:[di-50],al
	jmp	mc
mhl: mov	dh,byte ptr ms50
	mov	es:[di+50],dh
	mov	dh,byte ptr ms1
	mov	es:[di+1],dh
	mov	dh,byte ptr ms_50
	mov	es:[di-50],dh
	mov	dh,byte ptr ms_1
	mov	es:[di-1],dh
	or	al,3
	mov	es:[di-1],al
	jmp	mc
mhr: mov	dh,byte ptr ms50
	mov	es:[di+50],dh
	mov	dh,byte ptr ms_50
	mov	es:[di-50],dh
	mov	dh,byte ptr ms_1
	mov	es:[di-1],dh
	and	al,not 3
	or	al,81h
	mov	es:[di+1],al
mc:	mov	es:[di],bl
	jmp	cont
msp:	cmp	al,44
	jb	ms2
	cmp	bl,es:[di+50]
	jne	msc
	mov	si,word ptr ms_tmr
	add	si,offset ms_tmrlist
	test	cs:[si],byte ptr 1
	jz	msc
	mov	es:[di+50],byte ptr 17+128
	jmp	msc
ms2:	mov	si,word ptr ms_tmr
	add	si,offset ms_tmrlist
	test	cs:[si],byte ptr 2
	jz	msc
	cmp	al,41
	jb	msd
	je	msl
	cmp	al,43
	jb	msu
	cmp	bl,es:[di+1]
	jne	msc
	mov	es:[di+1],byte ptr 33+128
	jmp	msc
msd:	cmp	bl,es:[di+50]
	jne	msc
	mov	es:[di+50],byte ptr 34+128
	jmp	msc
msl:	cmp	bl,es:[di-1]
	jne	msc
	mov	es:[di-1],byte	ptr 35
	jmp	msc
msu:	cmp	bl,es:[di-50]
	jne	msc
	mov	es:[di-50],byte ptr 32
	jmp	msc
mspl:mov	ax,word ptr ms_tmr
	inc	ax
	cmp	ax,25
	jne	msp1
	xor	ax,ax
msp1:mov	word ptr ms_tmr,ax
	jmp	mspb
p1:	DB	0
p50:	DB	0
plr:
	mov	dl,es:[di+1]
	mov	byte ptr p1,dl
	and	dl,127
	mov	es:[di+1],dl
	mov	dl,es:[di+50]
	mov	byte ptr p50,dl
	and	dl,127
	mov	es:[di+50],dl
	mov	dx,word ptr ses
	mov	ds,dx
	mov	si,word ptr sdi
	mov	ah,48
	cmp	al,52
	jb	pl1
	mov	ah,52
	add 	si,5
pl1:
	mov	ds:[si+2550],byte ptr 0
	cmp	es:[di-50],byte ptr 5
	jne	sf1
	cmp	ds:[si+2581],byte ptr 0
	je	sf1
	mov	ds:[si+2550],byte ptr 1


sf1:	mov	ds:[si+2582],byte ptr 1
	cmp	bl,ds:[si+2594]
	jne	pfi
	cmp	bl,ds:[si+2590]
	jne	pu
	cmp	bl,ds:[si+2591]
	jne	pr
	cmp	bl,ds:[si+2593]
	jne	pl
	cmp	bl,ds:[si+2592]
	jne	pd
plpo:mov	dl,byte ptr p50
	mov	es:[di+50],dl
	mov	dl,byte ptr p1
	mov	es:[di+1],dl
	jmp	cont
pu:	mov	dl,es:[di-50]
	cmp	dl,5
	jb	pgu
	je	pun
	cmp	dl,13
	jb	ptu
	cmp	dl,22
	jb	pun
	je	pdu
	cmp	dl,31
	jb	pun
	je	pldu
	cmp	dl,48
	jb	pdie
pun:	mov  es:[di],ah
	jmp	plpo
pdu:	mov	es:[di],ah
	jmp	pdr
pldu:mov	es:[di],ah
	jmp	pldr
pgu: cmp	bl,es:[di-100]
	je	pn5
	mov	ds:[si+2581],dl
pb5:	mov	es:[di],bl
	mov	es:[di-50],ah
	mov	ah,1
	mov	ds:[si+2580],ah
	jmp	plpo
ptu: cmp	bl,es:[di-100]
	je	pn6
pb6:	mov	es:[di],bl
	mov	al,es:[di-50]
	mov  es:[di-50],ah
	mov	ah,1
	mov	ds:[si+2580],ah
pta:	cmp	al,7
	jb	pt6
	je	pt7
	cmp	al,9
	jb	pt8
	je	pt9
	cmp	al,11
	jb	pt10
	je	pt11
	mov	dl,100
ptp:	xor	dh,dh
	add	ds:[si+2570],dx
	jmp	plpo
pt6:	mov	dl,1
	xor	dh,dh
	sub	ds:[si+2572],dx
	jns	ptc
	mov	ds:[si+2572],bl
	mov	ds:[si+2573],bl
ptc:	add	ds:[si+2570],dx
	jmp  plpo
pt7:	mov	dl,3
	jmp	ptp
pt8:	mov	dl,5
	jmp	ptp
pt9:	mov	dl,10
	jmp	ptp
pt10:mov	dl,25
	jmp	ptp
pt11:mov	dl,42
	jmp	ptp
pdr:	cmp	bl,ds:[si+2572]
	jne	plpo
	cmp	bl,ds:[si+2573]
	jne	plpo
	mov	dl,5
	mov	ds:[si+2580],dl
	jmp	plpo
pldr:mov	dl,1
	cmp	dl,ds:[si+2550]
	jne	plpo
	mov	dl,6
	mov	ds:[si+2580],dl
	jmp	plpo
pdie:jmp	plpo
	mov 	ah,7
	mov	ds:[si+2580],ah
	mov	si,di
	mov	dl,byte ptr p50
	mov	es:[di+50],dl
	mov	dl,byte ptr p1
	mov	es:[di+1],dl
	jmp	boom
pd:  mov	dl,es:[di+50]
	add	ah,2
	cmp	dl,5
	jb	pgd
	je	pdn
	cmp	dl,13
	jb	ptd
	cmp	dl,22
	jb	pdn
	je	pdd
	cmp	dl,31
	jb	pdn
	je	pldd
	cmp	dl,48
	jb	pdie
pdn:	mov  es:[di],ah
	jmp	plpo
pdd:	mov	es:[di],ah
	jmp	pdr
pldd:mov	es:[di],ah
	jmp	pldr
pgd: mov	ds:[si+2581],bl
	mov	es:[di],bl
	or	ah,128
	mov	byte ptr p50,ah
	mov	dh,3
	mov	ds:[si+2580],dh
	jmp	plpo
ptd: mov	ds:[si+2581],bl
	mov	es:[di],bl
	mov	al,es:[di+50]
	or	ah,128
	mov	byte ptr p50,ah
	mov	dh,3
	mov	ds:[si+2580],dh
	jmp	pta
pr:  mov	dl,es:[di+1]
	add	ah,1
	cmp	dl,5
	jb	pgr
	je	pur
	cmp	dl,13
	jb	ptr_
	cmp	dl,19
	jb	pur
	cmp	dl,22
	jb	prn
	je	prd
	cmp	dl,31
	jb	prn
	je	plrd
	cmp	dl,48
	jb	pdie
prn:	mov  es:[di],ah
	jmp	plpo
pur:	cmp	bl,es:[di+2]
	jne	prn
	cmp	bl,es:[di+51]
	je	prn
	or	dl,128
	mov	es:[di+2],dl
	jmp	pgr
prd:	mov	es:[di],ah
	jmp	pdr
plrd:mov	es:[di],ah
	jmp	pldr
pgr: cmp	bl,es:[di-49]
	je	pn2
	mov	ds:[si+2581],dl
pb2:	mov	es:[di],bl
	or	ah,128
	mov	byte ptr p1,ah
	mov	dh,2
	mov	ds:[si+2580],dh
	jmp	plpo
ptr_:cmp	bl,es:[di-49]
	je	pn1
	mov  dl,es:[di+51]
	mov	ds:[si+2581],dl
pb1:	mov	es:[di],bl
	mov	al,es:[di+1]
	or	ah,128
	mov	byte ptr p1,ah
	mov	dh,2
	mov	ds:[si+2580],dh
	jmp	pta
pl:  mov	dl,es:[di-1]
	add	ah,3
	cmp	dl,5
	jb	pgl
	je	pul
	cmp	dl,13
	jb	ptl
	cmp	dl,19
	jb	pul
	cmp	dl,22
	jb	pln
	je	pld
	cmp	dl,31
	jb	pln
	je	plld
	cmp	dl,48
	jb	pdie
pln:	mov  es:[di],ah
	jmp	plpo
pul:	cmp	bl,es:[di-2]
	jne	pln
	mov	es:[di-2],dl
	jmp	pgl
pld:	mov	es:[di],ah
	jmp	pdr
plld:mov	es:[di],ah
	jmp	pldr
pgl: cmp	bl,es:[di-51]
	je	pn3
	mov	ds:[si+2581],dl
pb3:	mov	es:[di],bl
	mov	es:[di-1],ah
	mov	dh,4
	mov	ds:[si+2580],dh
	jmp	plpo
ptl: cmp	bl,es:[di-51]
	je	pn4
	mov	dl,es:[di+49]
	mov	ds:[si+2581],dl
pb4:	mov	es:[di],bl
	mov	al,es:[di-1]
	mov	es:[di-1],ah
	mov	dh,4
	mov	ds:[si+2580],dh
	jmp	pta
pn1:	mov	ds:[si+2581],bl
	jmp	pb1
pn2:	mov	ds:[si+2581],bl
	jmp	pb2
pn3:	mov	ds:[si+2581],bl
	jmp	pb3
pn4:	mov	ds:[si+2581],bl
	jmp	pb4
pn5:	mov	ds:[si+2581],bl
	jmp	pb5
pn6:	mov	ds:[si+2581],bl
	jmp	pb6
pfi: mov	dl,5
	mov	dh,13
	cmp	bl,ds:[si+2590]
	jne	pfu
	cmp	bl,ds:[si+2591]
	jne	pfr
	cmp	bl,ds:[si+2592]
	jne	pfd
	cmp	bl,ds:[si+2593]
	jne	pfl
	je	plpo
pfu:	cmp  es:[di-50],byte ptr 13
	jb	puc
	jmp	pun
puc:	cmp	dl,es:[di-50]
	je	pun
	mov	al,es:[di-50]
	mov	es:[di-50],bl
	mov	ds:[si+2581],bl
	cmp	al,5
	jb	pun
	jmp	pta
pud: cmp	es:[di+50],byte ptr 5
	je	pdn
	cmp	dh,es:[di+50]
	jbe	pdn
	mov	al,es:[di+50]
	mov	byte ptr p50,bl
	jmp	pta
pur_:cmp	dh,es:[di+1]
	jbe	prn
	mov	al,es:[di+1]
	mov	byte ptr p1,bl
	jmp	pta
pul_:cmp	dh,es:[di-1]
	jbe	pln
	mov	al,es:[di-1]
	mov	es:[di-1],bl
	jmp	pta
pfd:	cmp	dl,es:[di+50]
	jbe	pud
	mov	byte ptr p50,bl
	jmp	pdn
pfr: cmp	es:[di+1],byte ptr 13
	jae	pfxr
	cmp	dl,es:[di+1]
	jb	pur_
	je	pfrk
	mov  byte ptr p1,bl
	jmp	prn
pfxr:cmp	es:[di+1],byte ptr 19
	jae	prn
	cmp	es:[di+2],byte ptr 0
	jne	prn
	mov	byte ptr p1,0
	mov	dl,es:[di+1]
	add	dl,128
	mov	es:[di+2],dl
	jmp	prn
pfrk:cmp	bl,es:[di+2]
	jne	prn
	mov	byte ptr p1,bl
	mov	es:[di+2],byte ptr 5+128
	jmp	prn
pfl: cmp	byte ptr es:[di-1],13
	jae	pfxl
	cmp	dl,es:[di-1]
	jb	pul_
	je	pflk
	mov  es:[di-1],bl
	jmp	pln
pfxl:cmp	es:[di-1],byte ptr 19
	jae	prn
	cmp	es:[di-2],byte ptr 0
	jne	prn
	mov	dl,es:[di-1]
	mov	es:[di-2],dl
	mov	es:[di-1],byte ptr 0
	jmp	prn
pflk:cmp	bl,es:[di-2]
	jne	pln
	mov	es:[di-1],bl
	mov	es:[di-2],byte ptr 5
	jmp	pln

_guenwhyvar ENDP
END