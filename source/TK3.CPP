#include <iostream.h>
#define K_LOOP 0x4000
#include <key.h>

void main()
{
	char *t=pushedkeytab();
	while(!t[K_ESC])
	{
		if(t[K_CRSRUP])
		{
			cout << "up\n";
		}
		else
		{
			cout << "no up\n";
		}
		t=pushedkeytab();
	}
}