#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/sysmacros.h>
#include <linux/parport.h>
#include <sys/ioctl.h>
#include <linux/ppdev.h>

#include "parport.h"

MODULE = Device::ParallelPort::drv::parport		PACKAGE = Device::ParallelPort::drv::parport		

int
parport_opendev(dev)
	char *dev
	CODE:
		int fd;

		fd = open(dev, O_RDWR|O_NONBLOCK);
		if(fd < 0) {
			RETVAL = -1;
		} else {
			RETVAL = fd;
		}
	OUTPUT:
		RETVAL

void
parport_closedev(base)
	int base
	CODE:
		close(base);

char
parport_rd_data(base)
	int base
	CODE:
		int d;
		unsigned char byte;
		ioctl(base, PPCLAIM, 0);
		ioctl(base, PPRDATA, &byte);
		ioctl(base, PPRELEASE, 0);
		RETVAL = byte;
	OUTPUT:
		RETVAL

void
parport_wr_data(base, val)
	int base
	char val
	CODE:
		unsigned char byte;
		byte = val & 0xff;
		ioctl(base, PPCLAIM, 0);
		ioctl(base, PPWDATA, &byte);
		ioctl(base, PPRELEASE, 0);

char
parport_rd_ctrl(base)
	int base
	CODE:
		unsigned char byte;
		ioctl(base, PPCLAIM, 0);
		ioctl(base, PPRCONTROL, &byte);
		ioctl(base, PPRELEASE, 0);
		RETVAL = byte;
	OUTPUT:
		RETVAL

void
parport_wr_ctrl(base, val)
	int base
	char val
	CODE:
		unsigned char byte;
		byte = val & 0xff;
		ioctl(base, PPCLAIM, 0);
		ioctl(base, PPWCONTROL, &byte);
		ioctl(base, PPRELEASE, 0);

char
parport_rd_status(base)
	int base
	CODE:
		unsigned char byte;
		ioctl(base, PPCLAIM, 0);
		ioctl(base, PPRSTATUS, &byte);
		ioctl(base, PPRELEASE, 0);
		RETVAL = byte;
	OUTPUT:
		RETVAL

