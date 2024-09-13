#include <fstream.h>
#include <io.h>
#include <fcntl.h>
#include <sys\stat.h>
#include <alloc.h>
#include <conio.h>
#include <ERRNO.H>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define PCK_NODEP
#include <packer.h>

char *norm_msg="";
char *end_msg="\n\nProcess terminated  -  Bye !\n\n";
char *title_msg="Remetix's multi-file byte-run packer V1.1\n\n";

void usage(char *txt=norm_msg)
{
	cout << "\n" << txt << title_msg <<
	"Usage : rmx <project file>\n\n";
}

void main(int db,char *arg[])
{
	if(db!=2)
	{
		usage();
		return;
	}
	ifstream in(arg[1]);
	if(!in)
	{
		usage("File not found !\n\n");
		return;
	}
	char *srcp,*destp;
	if((srcp=(char *)farmalloc(65000))==NULL||(destp=(char *)
		farmalloc(65000))==NULL)
	{
		cout << "Memory allocation error !\n200 kb conventional "
		"memory needed !" << end_msg;
		return;
	}
	cout << "\n\n" << title_msg;
	int pk=in.peek(),d=0;
	long *pos=new long[50],*le=new long[100];
	char **names=new char *[50],*btab=new char[50];
	for(int i=0;i<50;i++)
		names[i]=new char[50];
	while(pk!='\n'&&pk!=-1&&pk!=0)
	{
		char *dest=new char[20],*src=new char[20],*name=new char[25],
			*jb=new char[5];
		in >> dest;
		int fh=open(dest,O_WRONLY|O_BINARY|O_CREAT|O_TRUNC,S_IREAD|S_IWRITE);
		if(fh==-1)
		{
			cout << "Unable to open destination file #" << d << " !" <<
				end_msg;
			farfree(srcp);
			farfree(destp);
			return;
		}
		cout << "Destination file #" << d << " : " << dest << "\n";
		long p=0;
		int s=0;
		in >> src;
		while(strcmp(src,"END"))
		{
			if(*src==';')
			{
				in >> name >> jb >> src;
				continue;
			}
			int sfh=open(src,O_RDONLY|O_BINARY);
			cout << "    Source file #" << s << " : " << src;
			if(sfh==-1)
			{
				cout << "      NOT FOUND\n";
				in >> name >> jb;
				in >> src;
				continue;
			}
			long l=filelength(sfh);
			if(read(sfh,srcp,l)==-1)
			{
				if(errno==EACCES)
				{
					cout << "      ACCESS DENIED\n";
					in >> name >> jb >> src;
					continue;
				}
				cout << "      READ ERROR\n";
				in >> name >> jb >> src;
				continue;
			}
			close(sfh);
			cout << "\n        Original length : " << l;
			in >> name >> jb;
			long nl=pack(srcp,destp,l,atoi(jb));
			cout << "\n        Packed length : " << nl;
			cout << "\n        Ratio : " << (nl*100)/l << "%";
			cout << "\n        New name : " << name;
			cout << "\n        Position : " << p << "\n";
			if(write(fh,destp,nl)==-1)
			{
				cout << "Write error !" << end_msg;
				return;
			}
			strcpy(names[s],name);
			pos[s]=p;
			p+=(long)nl;
			le[s]=l;
			le[s+50]=nl;
			btab[s++]=atoi(jb);
			in >> src;
		}
		for(int i=0;i<s;i++)
		{
			write(fh,names[i],16);
			write(fh,((char *)pos)+i*4,4);
			write(fh,((char *)le)+i*4+200,4);
			write(fh,((char *)btab)+i,1);
			write(fh,((char *)le)+i*4,4);
		}
		write(fh,&s,2);
		close(fh);
		in.get();
		pk=in.peek();
	}
	cout << "Task finished.  -  Bye !";
}