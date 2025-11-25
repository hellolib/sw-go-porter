#include <stdio.h>
#include <syscall.h>
#include <linux/sockios.h>
#include <asm/ioctls.h>

void main(){
     printf("SYS_GETSOCKOPT=0x%x\n", SYS_getsockopt);
     printf("SIOCINQ=0x%x\n", SIOCINQ);
     printf("SIOCOUTQ=0x%x\n", SIOCOUTQ);
}
