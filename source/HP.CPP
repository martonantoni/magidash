#include <io.h>
#include <fcntl.h>
#include <sys\stat.h>
#include <alloc.h>
#include <iostream.h>

#include <hufpack.h>

void main()
{
	int fh=open("huf.pck",O_RDONLY|O_BINARY);
	if(fh==-1)
	{
		cout << "Unable to open hufpro.out !";
		return;
	}
	char *dest;
	if((dest=(char *)farmalloc(64000))==NULL)
	{
		cout << "Not enough memory !";
		close(fh);
		return;
	}
	if(!loadrhx(fh,dest,"ring"))
	{
		cout << "Unable to depack !";
		farfree(dest);
		close(fh);
		return;
	}
	close(fh);
	fh=open("hp.dep",O_BINARY|O_WRONLY|O_CREAT|O_TRUNC,S_IREAD|S_IWRITE);
	write(fh,dest,26600);
	close(fh);
	farfree(dest);
}
