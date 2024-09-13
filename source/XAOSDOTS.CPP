#define ___NLAF
#define ___EXTNAMES
#include <gfx.h>
#include <alloc.h>
#include <stdlib.h>
#include <process.h>
#include <iostream.h>

class xdots
{
	unsigned *x,*y,*dx,*dy,*op,col,db,tmr,endtmr;
	int *vx,*vy;
	char *oc;
	void nem();
	int ispix1(unsigned);
	public:
	xdots(unsigned,unsigned,unsigned,unsigned,int,int);
	~xdots();
	int go();
	int getdb()	{ return db; };
#define FP 5
};

void xdots::nem()
{
	setgfxmode(2);
	cout << "Not enough memory for temporaly data"
	"\nTry to make more available conventional memory !"
	"\nOr type your code as an argument of the game !";
	exit(0);
}

xdots::xdots(unsigned sx,unsigned sy,unsigned w,unsigned h,int c,int t)
{
	db=h*w;
	tmr=t;
	endtmr=1;
	col=c;
	if((x=(unsigned *)farmalloc(db*sizeof(unsigned)))==NULL)
		nem();
	if((vx=(int *)farmalloc(db*sizeof(int)))==NULL)
		nem();
	if((dx=(unsigned *)farmalloc(db*sizeof(unsigned)))==NULL)
		nem();
	if((y=(unsigned *)farmalloc(db*sizeof(unsigned)))==NULL)
		nem();
	if((vy=(int *)farmalloc(db*sizeof(int)))==NULL)
		nem();
	if((dy=(unsigned *)farmalloc(db*sizeof(unsigned)))==NULL)
		nem();
	if((op=(unsigned *)farmalloc(db*sizeof(unsigned)))==NULL)
		nem();
	if((oc=(char *)farmalloc(db*sizeof(char)))==NULL)
		nem();
	unsigned pos=sy*320+sx,k=0,opos;
	randomize();
	for(int i=0;i<w;i++,pos++)
	{
		opos=pos;
		for(int j=0;j<h;j++,pos+=320)
		{
			if(ispix1(pos))
			{
				dx[k]=(i+sx)<<FP;
				dy[k]=(j+sy)<<FP;
				x[k]=random(320)<<FP;
				y[k]=random(170)<<FP;
				vx[k]=((int)dx[k]-(int)x[k])/t;
				vy[k]=((int)dy[k]-(int)y[k])/t;
				op[k]=pos;
				oc[k]=0;
				k++;
			}
		}
		pos=opos;
	}
	db=k;
}

xdots::~xdots()
{
	farfree(x);
	farfree(vx);
	farfree(dx);
	farfree(y);
	farfree(vy);
	farfree(dy);
	farfree(op);
}
int xdots::ispix1(unsigned pos)
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

int xdots::go()
{
	woff();
	for(unsigned i=0;i<db;i++)
	{
		quick256delabs(op[i],oc[i]);
		if(quick256read(x[i]>>FP,y[i]>>FP)==16)
			oc[i]=16;
		else
			oc[i]=0;
		op[i]=quick256putb(x[i]>>FP,y[i]>>FP,col);
	}
	tmr--;
	if(tmr)
	{
		for(i=0;i<db;i++)
		{
			x[i]+=vx[i];
			y[i]+=vy[i];
		}
//		if(tmr%2)
//			col--;
	}
	else
	{
		if(endtmr)
		{
			endtmr=0;
			tmr=1;
			for(i=0;i<db;i++)
			{
				x[i]=dx[i];
				y[i]=dy[i];
			}
			col=16;  // this turned the endcolors to white
		}
		else
		{
			for(i=0;i<db;i++)
			{
				quick256put(x[i]>>FP,y[i]>>FP,col);
			}
			return 0;
		}
	}
	return 1;
}

int xaosdots(int x,int y,int w,int h,int col)
{
	xdots yes(x,y,w,h,col,35);
	while(yes.go());
	return yes.getdb();
}