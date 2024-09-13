class morph
{
	int ispix1(unsigned pos);
	public:
	morph();
	~morph();
};

int morph::ispix1(unsigned pos)
{
	int a;
	asm {
		push	es
		push	si
		push	ax
		mov	ax,0xa000
		mov	es,ax
		mov	si,pos
		mov	al,es:[si]
		xor	ah,ah
		mov	word ptr a,ax
		pop	ax
		pop	si
		pop	es
	}
	return a;
}

morph::morph(int sx,int sy,int w,int h,int ddb)
{
	unsigned pos=sy*320+sx;
	for(int i=sy;i<sy+h;i++)
	{
		for(int j=sx;j<sx+w;j++)
		{
			if(ispix1(pos))
			{
				x[k]=j;
				y[k++]=i;
