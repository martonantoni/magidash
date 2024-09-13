#define ___NLAF
#define ___EXTNAMES
#include <gfx.h>
#include <io.h>
#include <iostream.h>
#include <fcntl.h>
#include <conio.h>
#include <time.h>
#include <process.h>

#include "stats.h"


void stats::ferr(char *fn)
{
	cout << "Unable to open " << fn << " !!!";
	exit(0);
}

void stats::statsc()
{
	pnames[0]=new char[50];
	pnames[1]=pnames[0]+25;
	ls_filename="stats.lev";
	ps_filename="stats.pla";
	pd_filename="players.dat";
	p1=p2=-1; // unloaded
	stage=-1; // unset
}

void stats::statsd()
{
	delete(pnames[0]);
}

void stats::reset_cs()
{
	char *csp=(char *)&cs;
	for(int i=0;i<sizeof(currentstat);i++)
	{
		*(csp++)=0;
	}
	static time_t t;
	t=time(NULL);
	cs.cta_1=cs.cta_2=cs.time=t;
}

void stats::OK_cs(int wp,int wmode)
{
	pdie(1);	pdie(2); cs.killed_1--; cs.killed_2--;
	for(int i=0;i!=2;i++)
	{
		pstat[i].times++;
		pstat[i].time+=cs.time;
	}
	pstat[0].killed+=cs.killed_1;
	pstat[1].killed+=cs.killed_2;
	pstat[0].time_alive+=cs.ta_1;
	pstat[1].time_alive+=cs.ta_2;
	if(pstat[0].max_time_alive<cs.mta_1)
		pstat[0].max_time_alive=cs.mta_1;
	if(pstat[1].max_time_alive<cs.mta_2)
		pstat[1].max_time_alive=cs.mta_2;
	pstat[0].collected+=cs.collected_1;
	pstat[1].collected+=cs.collected_2;
	pstat[0].other_p_killed+=cs.killed_2;
	pstat[1].other_p_killed+=cs.killed_1;
	switch(wp)
	{
		case 1:
			switch(wmode)
			{
				case WON_EXIT:
					pstat[0].won_out++;
					pstat[1].lost_out++;
					break;
				case WON_OTHER_DIED:
					pstat[0].won_o_p_died++;
					break;
			}
			break;
		case 2:
			switch(wmode)
			{
				case WON_EXIT:
					pstat[1].won_out++;
					pstat[0].lost_out++;
					break;
				case WON_OTHER_DIED:
					pstat[1].won_o_p_died++;
					break;
			}
			break;
	}
	lstat.times++;
	lstat.time+=cs.time;
	lstat.collected+=cs.collected_1+cs.collected_2;
	lstat.killed_mons+=cs.killed_mons;
	lstat.time_alive+=cs.ta_1+cs.ta_2;
	if(cs.mta_1>lstat.max_time_alive)
	{
		lstat.max_time_alive=cs.mta_1; lstat.mta_player=p1;
	}
	if(cs.mta_2>lstat.max_time_alive)
	{
		lstat.max_time_alive=cs.mta_2; lstat.mta_player=p2;
	}
}

void stats::pstart(int p)
{
	static time_t t;
	t=time(NULL);
	if(p==1)
	{
		cs.cta_1=t;
	}
	else
	{
		cs.cta_2=t;
	}
}

void stats::pdie(int p)
{
	static time_t t;
	unsigned lta;
	t=time(NULL);
	if(p==1)
	{
		lta=cs.cta_1=t;
		cs.ta_1+=lta;
		cs.killed_1++;
		if(cs.mta_1<lta)
			cs.mta_1=lta;
	}
	else
	{
		lta=cs.cta_2=t;
		cs.ta_2+=lta;
		cs.killed_2++;
		if(cs.mta_2<lta)
			cs.mta_2=lta;
	}
}

void ferr(char *fn)
{
	setgfxmode(2);
	cout << "Unable to open " << fn << " !!!\nMagidash terminated !\n\n";
	exit(0);
}

#define FILE_OP O_RDONLY|O_BINARY

int stats::findlevstat()
{
	int fh=open(ls_filename,FILE_OP);
	if(fh==-1)
		ferr(ls_filename);
	lseek(fh,stage*sizeof(stagestat),SEEK_SET);
	return fh;
}
void stats::loadlevstat()
{
	int fh=findlevstat();
	read(fh,&lstat,sizeof(stagestat));
	close(fh);
}
void stats::savelevstat()
{
	int fh=findlevstat();
	write(fh,&lstat,sizeof(stagestat));
	close(fh);
}

int stats::findplevstat(int p)
{
	int fh=open(ps_filename,FILE_OP);
	if(fh==-1)
		ferr(ps_filename);
	lseek(fh,p*sizeof(playerstat),SEEK_SET);
	return fh;
}
void stats::loadplevstats()
{
	int fh=findplevstat(p1);
	read(fh,&pstat[0],sizeof(playerstat));
	close(fh);
	fh=findplevstat(p2);
	read(fh,&pstat[1],sizeof(playerstat));
	close(fh);
}
void stats::saveplevstats()
{
	int fh=findplevstat(p1);
	read(fh,&pstat[0],sizeof(playerstat));
	close(fh);
	fh=findplevstat(p2);
	read(fh,&pstat[1],sizeof(playerstat));
	close(fh);
}

void stats::reportlevel()
{
	cout << "Level : " << stage-50 << "\nPlayed on it " <<
	lstat.times << " times.\nThis means " << lstat.time << " seconds.\n"
	"Avarage time : " << lstat.time/lstat.times << " seconds.\nKilled mons"
	"ters : " << lstat.killed_mons << "\nAvarage killed monsters : " <<
	lstat.killed_mons/lstat.times << "\nAvarage alive time : " <<
	lstat.time_alive/(lstat.times<<2) << "\nMaximum time alive : " <<
	lstat.max_time_alive << " seconds by player " << lstat.mta_player <<
	"\n\nBye !";
}

#define S_N
#ifndef S_N

void main()
{
	cout << "\n\nLevel : ";
	int l;
	cin >> l;
	stats s;
	s.setstage(l);
	s.loadlevstat();
	s.reportlevel();
}

#endif