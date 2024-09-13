#define ___NLAF
#define ___EXTNAMES
#include <gfx.h>
#include <stdlib.h>

class xmas
{
	int *x,*y,*op,*vx,*vy,db,*col,*heat,sx,sy;
	void rapp(int);
	void movestars();
	public:
	xmas(int,int);
	void delxmas();
	void yeah();
#define FP 4
};

xmas::xmas(int xs,int ys)
{
	sx=xs<<FP;
	sy=ys<<FP;
	x=new(int[200]);
	y=new(int[200]);
	vy=new(int[200]);
	vx=new(int[200]);
	col=new(int[200]);
	heat=new(int[200]);
	op=new(int[200]);
	for(int i=0;i<200;i++)
		x[i]=400<<FP;
	db=0;
	randomize();
}

void xmas::delxmas()
{
	delete(x,y,vy,vx,col,heat,op);
}

void xmas::rapp(int w)
{
	x[w]=sx;
	y[w]=sy;
	vx[w]=(random(100)-50);
	vy[w]=(random(100)-80);
	col[w]=17;
	heat[w]=0;
}

void xmas::movestars()
{
	for(int i=0;i<db;i++)
	{
		if(y[i]>>FP>200||x[i]<0||x[i]>>FP>320||col[i]==16)
			rapp(i);
		x[i]+=vx[i];
		y[i]+=vy[i];
		vy[i]+=2;
		heat[i]++;
		if(!(heat[i]%10))
			col[i]++;
	}
	woff();
	for(i=0;i<db;i++)
	{
		quick256delabs(op[i]);
		op[i]=quick256putb(x[i]>>FP,y[i]>>FP,col[i]);
	}
}

void xmas::yeah()
{
	movestars();
	if(db<160)
		db++;
}

void pause(int w)
{
	static xmas stars(160,100);
	if(w)
	{
		stars.yeah();
	}
	else
	{
		quick256cls(0);
	}
}
