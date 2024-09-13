struct playerstat
{
	unsigned times;
	unsigned long time;
	unsigned killed,killed_mons // this isn't in (???;-)
		,other_p_killed,won_out,won_o_p_died,lost_out,
		max_time_alive;
	unsigned long time_alive,collected;
};

struct stagestat
{
	unsigned long time;
	unsigned times;
	unsigned long killed_mons,collected,time_alive;
	unsigned max_time_alive,mta_player;
};

struct currentstat
{
	unsigned long time,killed_mons;
	unsigned killed_1,killed_2,ta_1,ta_2,mta_1,mta_2,cta_1,cta_2;
	unsigned long collected_1,collected_2;
};

struct playerdat
{
	char name[20];
//	time_t created,last_played;
};


#define WON_EXIT 0
#define WON_OTHER_DIED 1

class stats
{
	int p1,p2;
	playerdat pdat[2];
	playerstat pstat[2];
	char *pnames[2],*ls_filename,*ps_filename,*pd_filename;
	stagestat lstat;
	int stage;
	int findlevstat();
	int findplevstat(int);
	void ferr(char *);
	public:
	currentstat cs;
	void statsc();
	void statsd();
	int operator !() { return !(p1==-1||p2==-1||stage==-1); };
	void setstage(int s) { stage=s; };
	void reset_cs();
	void OK_cs(int,int);
	void pstart(int);
	void pdie(int);
	void loadlevstat();
	void savelevstat();
	void loadplevstats();
	void saveplevstats();
	void newdeads(unsigned dm) { cs.killed_mons+=dm; };
	void scoreplus1(int sp) { cs.collected_1+=sp; };
	void scoreplus2(int sp) { cs.collected_2+=sp; };
	void reportlevel();
};
