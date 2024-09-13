#define ___EXTNAMES
#include <gfx.h>
#include <blockmov.h>
#include <iostream.h>
#include <io.h>
#include <fcntl.h>
#include <alloc.h>
#include <process.h>
#include <conio.h>

extern "C"
{
	void zoomer(int,int,int,int,int,int,int,int,char far *,char far *,int);
}

void error(char *etxt)
{
	setgfxmode(2);
	cout << etxt << "\n\nBye !";
	exit(0);
}

int pcx[]={ 50,42,64,42,39,16,38 };
int pcy[]={ 52,52,52,52,52,52,52 };
int pcp[]={ 320*5+10,320*5+60,320*5+102,320*5+144,320*5+205,
	320*5+244,320*5+260 };
int cw[]={ 50,42,64,42,39,16,38 };

class zoomchar
{
	char *buff,*pic,*scr,*scrbuff;
	int x1,x2,y1,y2,ox1,ox2,oy1,oy2,rx1,rx2,ry1,ry2,vx1,vx2,vy1,vy2,
	    dx1,dx2,dy1,dy2,px,py,cpos,tmr;
	public:
	zoomchar();
	~zoomchar();
	int startchar(int,int,int,int);
	int go(int = 1);
	char *getgfx() { return scr; };
	char *getpic() { return buff; };
#define FP 5
};

zoomchar::zoomchar()
{
	char *mer_txt="Memory allocation error !";
	if((buff=(char *)farmalloc(64000))==NULL)
		error(mer_txt);
	if((scr=(char *)farmalloc(64000))==NULL)
		error(mer_txt);
	if((scrbuff=(char *)farmalloc(64000))==NULL)
		error(mer_txt);
	if((pic=(char *)farmalloc(64768))==NULL)
		error(mer_txt);
	int fh=open("logo.raw",O_BINARY|O_RDONLY);
	if(fh==-1)
		error("Unable to open gfx file !");
	lseek(fh,0,SEEK_SET);
	read(fh,pic,64768);
	close(fh);
	setgfxmode(19);
	set256palette(0,256,pic+64000);
	clearscrbuff(buff,0);
}

zoomchar::~zoomchar()
{
	farfree(buff);
	farfree(pic);
	farfree(scr);
	farfree(scrbuff);
}

int zoomchar::startchar(int c,int ex,int ey,int speed)
{
	ry1=50<<FP;
	ry2=150<<FP;
	px=pcx[c];
	py=pcy[c];
	cpos=pcp[c];
	int width=cw[c];
	rx1=(160-width)<<FP;
	rx2=(160+width)<<FP;
	vx1=(((dx1=ex)<<FP)-rx1)/speed;
	vx2=(((dx2=ex+px)<<FP)-rx2)/speed;
	vy1=(((dy1=ey)<<FP)-ry1)/speed;
	vy2=(((dy2=ey+py)<<FP)-ry2)/speed;
	x1=rx1>>FP;
	x2=rx2>>FP;
	y1=ry1>>FP;
	y2=ry2>>FP;
	ox1=x1; ox2=x2; oy1=y1; oy2=y2;
	tmr=speed;
	screenstore(scr);
	screenstore(scrbuff);
	return width;
}

int zoomchar::go(int iswoff)
{
	int w=x2-x1,h=y2-y1;
	zoomer(x1,y1,x2,y2,w,h,px,py,pic+cpos,buff,320);
	borcopy(x1,y1,w,h,buff,scrbuff);
	int sx=(x1<ox1 ? x1 : ox1),sy=(y1<oy1 ? y1 : oy1);
	int sw=(x2>ox2 ? x2-sx : ox2-sx),sh=(y2>oy2 ? y2-sy : oy2-sy);
	if(iswoff)
		woff();
	screenrestore(sx,sy,sw,sh,scrbuff);
	bcopy(x1,y1,w,h,scr,scrbuff);
	rx1+=vx1;
	rx2+=vx2;
	ry1+=vy1;
	ry2+=vy2;
	ox1=x1; ox2=x2; oy1=y1; oy2=y2;
	x1=rx1>>FP;
	x2=rx2>>FP;
	y1=ry1>>FP;
	y2=ry2>>FP;
	tmr--;
	if(!tmr)
	{
		x1=dx1; x2=dx2; y1=dy1; y2=dy2;
	}
	if(tmr==-1)
		return 0;
	return 1;
}

void opening()
{
	zoomchar zoom;
	int pos=0;
	pos+=zoom.startchar(0,0,0,50);
	while(zoom.go(0));
	pos+=zoom.startchar(1,pos,0,50);
	while(zoom.go(0));
	pos+=zoom.startchar(2,pos,0,50);
	while(zoom.go(0));
	pos+=zoom.startchar(1,pos,0,50);
	while(zoom.go(0));
	pos+=zoom.startchar(4,pos,0,50);
	while(zoom.go(0));
	pos+=zoom.startchar(5,pos,0,50);
	while(zoom.go(0));
	pos+=zoom.startchar(6,pos,0,50);
	while(zoom.go(0));
	getch();
	quick256cls();
/*	char *coords=(char *)farmalloc(28160);
	int fh=open("ring.tab",O_RDONLY|O_BINARY);
	read(fh,coords,28160);
	close(fh);
	char *pp;
	pp=zoom.getpic();
	clearscrbuff(pp,0);
	showring(coords,zoom.getgfx(),pp,144,88);
	asm {
		push	ds
		mov	ax,0xa000
		mov	es,ax
		xor	di,di
		lds	si,pp
		mov	cx,32000
		cld
		rep	movsw
		pop	ds
	}
	getch();    */
}