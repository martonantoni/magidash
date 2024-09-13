#include <io.h>
#include <fcntl.h>
#include <sys\stat.h>
//#include <iostream.h>
#include <fstream.h>
#include <alloc.h>
#include <process.h>
#include <string.h>
#include <conio.h>  // For testing  -  getch();

extern "C"
{
	int CountBytes(char far *,void far *,int);
	void MakeTree(void far *,int);
	void MakeChangeTab(void far *,void far *);
	unsigned HufPack(void far *,char far *,char far *,unsigned);
	void HufDePack(void far *,char far *,char far *,int,int);
	int MakeDelta(char far *,unsigned);
	void Filter(void far *,char far *,unsigned,int);
};


class huf
{
	char *src,*dest,*ct,*bytedb;
	int *tree;
	unsigned size,nl;
	public:
	huf();
	~huf();
	int load(char *);
	void pack();
     void go(char *);
};

huf::huf()
{
	if((tree=(int *)farmalloc(sizeof(int)*2400))==NULL||(src=(char *)
		farmalloc(64000))==NULL||(dest=(char *)farmalloc(64000))==NULL
		||(ct=(char *)farmalloc(2400*2))==NULL||(bytedb=(char *)
		farmalloc(1000))==NULL)
	{
		cout << "Not enough memory !\nYou must have at least "
			"200Kb free conventional memory.\n";
		exit(0);
	}
}

huf::~huf()
{
		farfree(src);
		farfree(dest);
		farfree(tree);
		farfree(bytedb);
		farfree(ct);
	cout << "\n\nBye !";
}

int huf::load(char *fn)
{
	int fh=open(fn,O_BINARY|O_RDONLY);
	if(fh==-1)
		return 1;
	size=filelength(fh);
	read(fh,src,size);
	close(fh);
	return 0;
}

void huf::pack()
{
	for(int i=0;i<511;i++)
	{
		tree[i<<2]=-1;
		tree[(i<<2)+2]=-1;
		tree[(i<<2)+1]=-1;
		if(i<256)
			tree[(i<<2)+3]=0;
		else
			tree[(i<<2)+3]=-1;
	}
	int r=CountBytes(src,((char *)tree)+6,size);
//	Filter(tree,src,size,200);
	for(i=0;i<256;i++)
		((int *)bytedb)[i]=tree[(i<<2)+3];
	MakeTree(tree,r*8+2040);
	MakeChangeTab(tree,ct);
	nl=HufPack(ct,src,dest,size);
}

void huf::go(char *lfn)
{
	ifstream in(lfn);
	int pk=in.peek();
	int modes[42];
	unsigned pl[42];
	long pos[42],sz[42];
	char dfn[42],*afn[42],m[42],sfn[42];
	for(int i=0;i<42;i++)
		afn[i]=new char[42];      // The end of the program will deallocate
	while(pk!=0&&pk!=-1&&pk!=13&&pk!=EOF)
	{
		in >> dfn;
		int fh=open(dfn,O_BINARY|O_WRONLY|O_CREAT|O_TRUNC,
			S_IREAD|S_IWRITE);
		if(fh==-1)
		{
			cout << "Unable to open " << dfn << " !";
			return;
		}
		cout << "Destination file : " << dfn << "\n";
		in >> sfn;
		int sfdb=0;
		while(strcmp(sfn,"END"))
		{
			in >> afn[sfdb] >> m;
			cout << "Source file #" << sfdb << " : " << sfn;
			int sfh=open(sfn,O_BINARY|O_RDONLY);
			if(sfh==-1)
			{
				cout << " - NOT FOUND !";
				in >> sfn;
				continue;
			}
			cout << "       Size : " << filelength(sfh);
			cout << "\nPacked name : " << afn[sfdb];
			switch(*m)
			{
				case 'N':
				{
					modes[sfdb]=0;
					read(sfh,src,size=sz[sfdb]=filelength(sfh));
//					MakeDelta(src,size);
					pack();
					pos[sfdb]=tell(fh);
					write(fh,bytedb,512);
					write(fh,dest,nl);
					pl[sfdb]=nl;
					cout << "	  Size : " << nl << " + 512 = " << nl+512
						<< "\n";
				}
				break;
				case 'D':
				{
					read(sfh,src,size=sz[sfdb]=filelength(sfh));
					modes[sfdb]=(MakeDelta(src,size)<<8)+1;
					pack();
					pos[sfdb]=tell(fh);
					write(fh,bytedb,512);
					write(fh,dest,nl);
					pl[sfdb]=nl;
					cout << "	  Size : " << nl << " + 512 = " << nl+512
						<< "\n";
				}
				break;
			}
			sfdb++;
			close(sfh);
			in >> sfn;
		}
		for(int i=0;i<sfdb;i++)
		{
			write(fh,afn[i],16);
			write(fh,&(pos[i]),4);
			write(fh,&(sz[i]),2);
			write(fh,&(modes[i]),2);
			write(fh,&(pl[i]),2);
		}
		write(fh,&sfdb,2);
		in.get();
		pk=in.peek();
		close(fh);
	}
}

void usage()
{
	cout << "\n\nRemetix's multi-file packer with Huffman V1.0"
		"\nUsage : huf <project file>\n\n";
}

void main(int adb,char **arg)
{
	if(adb!=2)
	{
		usage();
		return;
	}
	huf Packer;
	Packer.go(arg[1]);
}