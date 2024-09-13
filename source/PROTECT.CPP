int protpos[]={ 45,78,134,167,235,278,322,395,448,452 };

void protect(char *scene)
{
	unsigned summ=0;
	for(int i=0;i<10;i++)
		summ+=scene[protpos[i]]+scene[protpos[i]+501]+scene[protpos[i]+1250]+scene[protpos[i]+1980];
	*(unsigned *)(scene+2540)=summ;
	asm {
		push	ds
		lds	si,scene
		les	di,scene
		mov	bx,word ptr summ
		mov	cx,1250 }
	cikl: asm {
		lodsw
		sub	ax,bx
		stosw
		loop	cikl
		pop	ds
	}
}

void decode(char *scene)
{
	unsigned summ=*(unsigned *)(scene+2540);
	asm {
		push	ds
		lds	si,scene
		les	di,scene
		mov	bx,word ptr summ
		mov	cx,1250 }
	cikl: asm {
		lodsw
		add	ax,bx
		stosw
		loop	cikl
		pop	ds
	}
}
