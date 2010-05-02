#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include <sys/ioctl.h>
#include <fcntl.h>
#include <inttypes.h>
#include <linux/types.h>
#include <errno.h>
#include <linux/usb/ch9.h>
#include <linux/usbdevice_fs.h>

#include "wacom_ioctl.h"

#define ROWS 32
#define COLS 64

#define WACOM_SET_HANDEDNESS _IOW(0x00, 0x01, struct wacom_handedness)

int set_ring_led(char *usb_file, int btn)
{
        struct wacom_led_mode led_mode;
        struct usbdevfs_ioctl wrapper;
        int usb_fd;
        int r;

        usb_fd = open(usb_file, O_RDWR);
        if (usb_fd < 0)
                return -1;

        /* setup led data */
        led_mode.led_sel = 0x04+btn;
        led_mode.led_llv = 0x7f;
        led_mode.led_hlv = 0x7f;
        led_mode.oled_lum = 0x00;

        /* make syscall */
        wrapper.ifno = 0;
        wrapper.ioctl_code = WACOM_SET_LED_MODE;
        wrapper.data = &led_mode;

        r = ioctl(usb_fd, USBDEVFS_IOCTL, &wrapper);
        close(usb_fd);
        if (r < 0)
                return r;

        return EXIT_SUCCESS;
}

int set_image_led(char *usb_file, char *img, int btn)
{
        struct wacom_led_img led_img;
        struct usbdevfs_ioctl wrapper;
        int usb_fd;
        int r;

        usb_fd = open(usb_file, O_RDWR);
        if (usb_fd < 0)
                return -1;

        /* setup led data */
        memcpy(led_img.buf, img, ROWS*COLS);
        led_img.btn = btn;

        /* make syscall */
        wrapper.ifno = 0;
        wrapper.ioctl_code = WACOM_SET_LED_IMG;
        wrapper.data = &led_img;

        r = ioctl(usb_fd, USBDEVFS_IOCTL, &wrapper);
        close(usb_fd);
        if (r < 0)
                return r;

        return EXIT_SUCCESS;
}

int set_left_handed(char *usb_file, int left_handed)
{
        struct wacom_handedness handedness;
        struct usbdevfs_ioctl wrapper;
        int usb_fd;
        int r;

        usb_fd = open(usb_file, O_RDWR);
        if (usb_fd < 0)
                return -1;

        /* setup led data */
        handedness.left_handed = left_handed;

        /* make syscall */
        wrapper.ifno = 0;
        wrapper.ioctl_code = WACOM_SET_HANDEDNESS;
        wrapper.data = &handedness;

        r = ioctl(usb_fd, USBDEVFS_IOCTL, &wrapper);
        close(usb_fd);
        if (r < 0)
                return r;

        return EXIT_SUCCESS;
}

MODULE = Wacom::Helper		PACKAGE = Wacom::Helper		

int
set_ring_led(usb_file, btn)
    char* usb_file
    int btn

int
set_image_led(usb_file, img, btn)
    char* usb_file
    char* img
    int btn

int
set_left_handed(usb_file, left_handed)
    char* usb_file
    int left_handed
