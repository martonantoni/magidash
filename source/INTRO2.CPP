#define ___NLAF
#define ___EXTNAMES
#define PCK_EXTNAMES
#include <gfx.h>
#include <alloc.h>
#include <iostream.h>
#include <process.h>
#include <stdlib.h>
#include <conio.h>
#include <io.h>
#include <fcntl.h>
#include <dos.h>
#include <stdio.h>

#include <packer.h>
#include <blockmov.h>

//#include <sound.h>
//#include <mod.h>

#define BL_OPEN 1
#define BL_CLOSE 0
#define BL_FROMPIC 0
#define BL_BLANK 2

extern "C"
{
	void starfield(char far *,int,char far *,int);
	void blockunlite(char far *,int,int,int,int);
	void recolorgfx(char far *,int);
	void	specline(char far *,int,int,int,int,int,void far *);
	void linefill(char far *,void far *,void far *,int);
	void specblockput(char far *,int,int,int,int);
	void textcopy(char far *,char far *,int,int);
	void textureput(char far *,char far *,int);
	void moveline(int,int,int);
	void linedel(int,int);
	void storeline(char far *,int,int);
	void reputline(char far *,int,int);
	void lineput(char far *,int,int,int,int);
	void riseline(char far *,int,int);
	int borderline(int,int,char far *);
	void inicprint(char far *);
	void pnumber(int,int,int,int,int);
	void ptext(int,int,char far *);
	int shadeprint(int,int,char far *,int,int);
	int *advshadeprint(int,char far *,char far *,int,char far *);
	void shade8print(int,int,char far *,int,int);
	void shade8numprint(int,int,int,int,int,int,int);
	int shadenumprint(int,int,int,int,int,int,int);
	void setprintdestination(char far *dest=NULL);
};

class space
{
	int *sd;
	int woy,wox,wx,wy,t1[320],t2[320],wttmr,nextdel,wex,comtmr,
		curcom,tmr,speed,sfl_open,sfl_close;
	unsigned curcol;
	char *gfx,*txtpic,*texture,*linesbuff,*sflines;
	long screen_z;
	void nem();
	void ferr(char *);
	void rmxerr(char *);
	void loadgfx();
	void writer();
	void inicwriter();
	void textcommand();
	void newline();
	void openlines();
	public:
	space();
	~space();
	void go();
	int closelines();
};

void space::nem()
{
	setgfxmode(2);
	cout << "Memory allocation error !\nIntro terminated !\n";
	exit(0);
}
void space::ferr(char *et)
{
	setgfxmode(2);
	cout << "Intro unable to open " << et << " !\n\n";
	exit(0);
}
void space::rmxerr(char *et)
{
	setgfxmode(2);
	cout << "Decrunching error ! " << et << " not found !\n\n";
	exit(0);
}

space::space()
{
	if((sd=(int *)farmalloc(2000*3))==NULL)
		nem();
	if((gfx=(char *)farmalloc(64768))==NULL)
		nem();
	if((txtpic=(char *)farmalloc(16*320*5))==NULL)
		nem();
	texture=txtpic+16*320;
	linesbuff=txtpic+16*320*3;
	sflines=txtpic+16*320*4;
	setgfxmode(19);
	for(int i=0;i<500;i++)
	{
		sd[i]=random(1280)-640;
		sd[i+500]=random(800)-400;
		sd[i+1000]=2500-i*5;
		sd[i+1500]=0;
	}
	screen_z=500; sd[491]=100; sd[492]=100;
	sfl_open=1; sfl_close=0;
	loadgfx();
	inicwriter();
}

space::~space()
{
	farfree(sd);
	farfree(gfx);
	farfree(txtpic);
//	setgfxmode(2);
 //	cout << "You have experienced an another intro for Magidash.\nCoded"
 //	" by Remetix\n\n";
}

char *gfx_name="magidash.gfx";

void space::loadgfx()
{
	int fl=open(gfx_name,O_RDONLY|O_BINARY);
	if(fl==-1)
		ferr(gfx_name);
	if(!loadrmx(fl,gfx,"intropalette"))
		rmxerr("I.P.");
	set256palette(0,256,gfx);
	if(!loadrmx(fl,gfx,"introtexture"))
		rmxerr("texture");
	bcopy(0,0,320,16,gfx,texture);
	if(!loadrmx(fl,gfx,"introlines"))
		rmxerr("sflines");
	bcopy(0,0,320,16,gfx,sflines);
	if(!loadrmx(fl,gfx,"graphics"))
		rmxerr("graphics");
	close(fl);
	inicprint(gfx+1600);

	recolorgfx(gfx,94);
}

#define AGAIN 0
#define WRITE 1
#define WAIT 2
#define DEL_LASER 3
#define DROPLINE 4
#define SCROLL_OUT 5
#define SCROLL_IN 6
#define RISELINE 7
#define DRAINER 8

#define I_TXTNUM 12
char *txt[I_TXTNUM+1];
int txt_x[]={ 52,95,65,50,
	80,130,115,127,112,130,110,110,100 };
int txt_y[]={ 40,65,90,140,
	65,100,100,100,100,100,100,100,100 };
int txt_com[]={ WAIT,200,WRITE,DEL_LASER,
	WAIT,90,WRITE,DEL_LASER,RISELINE,WAIT,100,WRITE,
	DEL_LASER,WAIT,100,
	SCROLL_OUT,65,SCROLL_OUT,90,SCROLL_OUT,40,SCROLL_OUT,140,
	WAIT,100,RISELINE,
	WRITE,DEL_LASER,WAIT,150,//SCROLL_OUT,100,
	WRITE,DEL_LASER,WAIT,150,//SCROLL_OUT,100,
	WRITE,DEL_LASER,WAIT,150,//SCROLL_OUT,100,
	WRITE,DEL_LASER,WAIT,150,//SCROLL_OUT,100,
	WRITE,DEL_LASER,WAIT,150,//SCROLL_OUT,100,
	WRITE,DEL_LASER,WAIT,150,//SCROLL_OUT,100,
	WRITE,DEL_LASER,WAIT,150,//SCROLL_OUT,100,
	WRITE,DEL_LASER,WAIT,150,SCROLL_OUT,100,
	SCROLL_OUT,65,WAIT,200,
	AGAIN };

void space::inicwriter()
{
	txt[0]="remetix presents";
	txt[1]="magidash";
	txt[2]="the new style";
	txt[3]="released in 1995.";
	txt[4]="greetings to";
	txt[5]="MAXX"; txt[6]="Miniman"; txt[7]="Klox"; txt[9]="Alex";
	txt[11]="ToBiaC"; txt[10]="CaQxar"; txt[12]="Gabulator"; txt[8]="Elijah";
//	txt[5]="code - remetix";
//	txt[6]="graphics - klox";
//	txt[7]="sfx/mod code - maxx";
//	txt[8]="music - unknown author";
	wttmr=0; comtmr=0; curcom=WAIT; tmr=20;
	wox=150; woy=170; wx=150; wy=170; wex=319; wx=0;
	setprintdestination(txtpic);
	blockfill(0,0,320,16,txtpic,0);
	shadeprint(txt_x[wttmr],0,txt[wttmr],0,0);
	nextdel=1;
	curcol=130<<8;
	set256palette(131,0,40,0);
	set256palette(130,0,40,0);
}

void space::newline()
{
	blockfill(0,0,320,16,txtpic,0);
	shadeprint(txt_x[wttmr],0,txt[wttmr],0,0);
	textureput(txtpic,texture,320*16);
	wy=txt_y[wttmr++];
	if(wttmr==I_TXTNUM+1)
	{
		wttmr=0;
	}
}

void space::openlines()
{
	sfl_open=borderline(BL_OPEN,150,NULL);
	if(sd[491])
	{
		sd[491]--;
		sd[492]++;
	}
}

int space::closelines()
{
	if(sd[491]!=160)
	{
		sd[491]++;
		sd[492]--;
	}
	starfield((char *)sd,490,NULL,screen_z);
	woff();
	return borderline(BL_CLOSE,150,NULL);
}

void space::textcommand()
{
	switch(curcom=txt_com[comtmr++])
	{
		case AGAIN:
			comtmr=0;
			textcommand();
			break;
		case WRITE:
			blockfill(0,0,320,16,txtpic,0);
			shadeprint(txt_x[wttmr],0,txt[wttmr],0,0);
			textureput(txtpic,texture,320*16);
			nextdel=1;
			break;
		case WAIT:
			tmr=txt_com[comtmr++];
			break;
		case DEL_LASER:
			break;
		case DROPLINE:
			tmr=txt_com[comtmr++];
			speed=1<<4;
			wy=320*16*2; woy=0; wox=0;
			storeline(txtpic,0,320*16);
			storeline(linesbuff,tmr,320*16);
			break;
		case SCROLL_OUT:
			wy=txt_com[comtmr++];
			wx=320; speed=1<<3; wox=320<<3;
			storeline(txtpic,wy,320*16);
			break;
		case SCROLL_IN:
			newline();
			wx=1;
			break;
		case RISELINE:
			wx=1;
			newline();
			break;
		defauld:
			textcommand();
			break;
	}
}

void space::writer()
{
	switch(curcom)
	{
		case WAIT:
			woff();
			starfield((char *)sd,490,NULL,screen_z);
			if(!--tmr)
			{
				textcommand();
			}
			return;
		case DEL_LASER:
			specline(NULL,160,199,wox,woy,curcol,t1);
			specline(NULL,160,199,wox,woy+16,curcol,t2);
			linefill(NULL,t1,t2,curcol);
			starfield((char *)sd,490,NULL,screen_z);
			textcommand();
			return;
		case DROPLINE:
		{
			woff();
			int ntmr=tmr+(speed>>4);
			if(ntmr>199-17)
			{
				ntmr=199-17;
				linedel(tmr,320*16);
				textcommand();
			}
			else
			{
				reputline(txtpic+woy,tmr,320*16);
				storeline(txtpic+wy,ntmr,320*16);
				reputline(linesbuff,ntmr,320*16);
				tmr=ntmr;
				ntmr=wy; wy=woy; woy=ntmr;
				speed++;
			}
			starfield((char *)sd,490,NULL,screen_z);
			return;
		}
		case SCROLL_OUT:
			woff();
			lineput(txtpic+320-wx,0,wy,wx,16);
			starfield((char *)sd,490,NULL,screen_z);
			wox-=speed;
			wx=wox>>3;
			speed++;
			if(wx<0)
				textcommand();
			return;
		case SCROLL_IN:
			woff();
			lineput(txtpic,320-wx,wy,wx,16);
			starfield((char *)sd,490,NULL,screen_z);
			if(wx++==320)
				textcommand();
			return;
		case RISELINE:
			woff();
			riseline(txtpic,wx,wy);
			starfield((char *)sd,490,NULL,screen_z);
			if(wx++==293)
				textcommand();
			return;
	}
	if(nextdel)
	{
		woff();
		nextdel=0;
		wx=0;
		wex=319;
		wy=txt_y[wttmr++];
		if(wttmr==I_TXTNUM+1)
		{
			wttmr=0;
		}
	}
	else
	{
		woff();
		specline(NULL,160,199,wx,wy,(curcol<<8)+1,t1);
		specline(NULL,160,199,wx,wy+16,(curcol<<8)+1,t2);
		linefill(NULL,t1,t2,(curcol<<8)+1);
		specline(NULL,160,199,wox,woy,curcol,t1);
		specline(NULL,160,199,wox,woy+16,curcol,t2);
		linefill(NULL,t1,t2,curcol);
		textcopy(txtpic,NULL,wx,wy);
		wox=wx++; woy=wy;
		curcol=(curcol==0x83?0x82:0x83);
	}
	starfield((char *)sd,490,NULL,screen_z);
	if(wx==wex)
	{
		textcommand();
	}
}

void space::go()
{
	if(sfl_open)
		openlines();
	writer();
}

void intro()
{
	space ff;
	while(!kbhit())
	{
		ff.go();
	}
	while(ff.closelines());
/*	getch();
	if(!DetectSB())
	{
		cout << "Sound Blaster not detected !!!";
		return;
	}
	Tmodule test("march.mod");
	unsigned bufsize=32000; char *mbuf,*buf1,*buf2;
	if((mbuf=(char *)farmalloc(bufsize*2+65536l))==NULL)
	{
		cout << "Not enough memory !\n";
		RemoveIrq();
		return;
	}
	SpeakerOn();
	buf1=mbuf;
	long l=FP_SEG(mbuf)*16l+FP_OFF(mbuf);
	long l2=l+2l*bufsize;
	unsigned p1=(l&0xf0000l)>>4,p2=(l2&0xf0000l)>>4;
	if(p1!=p2)
	{
		buf1=(char far *)MK_FP(p2,0);
	}
	else
	{
		buf1=mbuf;
	}
	buf2=buf1+bufsize;
	memset(buf2+bufsize,0x2e,200);
	InitBackgroundPlay(buf1,buf2,bufsize);
	SetupPlayerInterrupt();
	test.play();
*/
}
	/*
void main()
{
	if(!DetectSB())
	{
		cout << "Sound Blaster not detected !!!";
		return;
	}
	Tmodule test("march.mod");
	unsigned bufsize=32000; char *mbuf,*buf1,*buf2;
	if((mbuf=(char *)farmalloc(bufsize*2+65536l))==NULL)
	{
		cout << "Not enough memory !\n";
		RemoveIrq();
		return;
	}
	SpeakerOn();
	buf1=mbuf;
	long l=FP_SEG(mbuf)*16l+FP_OFF(mbuf);
	long l2=l+2l*bufsize;
	unsigned p1=(l&0xf0000l)>>4,p2=(l2&0xf0000l)>>4;
	if(p1!=p2)
	{
		buf1=(char far *)MK_FP(p2,0);
	}
	else
	{
		buf1=mbuf;
	}
	buf2=buf1+bufsize;
	memset(buf2+bufsize,0x2e,200);

	InitBackgroundPlay(buf1,buf2,bufsize);
	SetupPlayerInterrupt();
	test.play();

	getch();
	space ff;
	while(!kbhit())
	{
		ff.go();
	}
	while(ff.closelines());
	getch();

	RestorePlayerInterrupt();
	SpeakerOff();
	RemoveIrq();
	farfree(mbuf);
}      */