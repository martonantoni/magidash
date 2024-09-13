#define ___NLAF
#include <gfx.h>
#include <blockmov.h>
#include <alloc.h>
#include <conio.h>
#include <io.h>
#include <fcntl.h>
#include <iostream.h>
#include <process.h>

char *logo_name="logo.raw";

extern "C"
{
	void zoomer(char far*,int,int,int,char far *,int,int,int,int,char far *);
};

class water
{
	char *logo,*scrbuff;
	int y,end;
	void nem();
	public:
	water();
	~water();
	int go();
	void down() { end=1; };
};

void water::nem()
{
	cout << "Memory allocation error !\nIntro terminated.\n\n";
	exit(0);
}

water::water()
{
	if((logo=(char *)farmalloc(64768))==NULL)
		nem();
	if((scrbuff=(char *)farmalloc(64000))==NULL)
		nem();
	int fh=open(logo_name,O_BINARY|O_RDONLY);
	if(fh==-1)
	{
		cout << logo_name << " not found !\n\n";
		exit(0);
	}
	read(fh,logo,64768);
	close(fh);
	setgfxmode(19);
	set256palette(0,255,logo+64000);
//	farfree(scrbuff);
//	scrbuff=logo;
	clearscrbuff(scrbuff,0);
//	bcopy(0,0,320,140,logo,scrbuff);
	y=140;
	end=0;
	char *buff=new char[1000];
	zoomer(logo,20,20,320,scrbuff,0,0,300,170,buff);
	screenrestore(0,0,320,190,scrbuff);
	delete(buff);
}

water::~water()
{
	farfree(logo);
	farfree(scrbuff);
	setgfxmode(2);
	cout << "You have experienced Remetix's Intro Preview for Magidash.\n\n";
}

extern "C"
{
	void mirror(char far *);
};

int water::go()
{
	if(y>0&&!end)
	{
		bcopy(0,0,320,60,logo,scrbuff+320*y);
		y--;
	}
	if(end)
	{
		bcopy(0,0,320,60,logo,scrbuff+320*y);
		y++;
		if(y==141)
			return 0;
	}
	borcopy(0,60,70,80,logo,scrbuff);
	mirror(scrbuff);
	char *pic=scrbuff;
	asm {
		push	ds
		lds	si,pic
		mov	ax,0xa000
		mov	es,ax
		xor	di,di
		mov	cx,32000
		cld }
//	waitoff
	asm {
		rep	movsw
		pop	ds
	}
	return 1;
}

void main()
{
	water lake;
	while(!kbhit())
	{
//		lake.go();
	}
	lake.down();
	while(lake.go());
	getch();
}
