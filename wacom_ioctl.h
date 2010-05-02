#ifndef __WACOM_IOCTL_H
#define __WACOM_IOCTL_H

/**** 
 * wacom_ioctl.h
 *
 * Provides common system calls for interacting with wacom tablets via usbfs
 */


/****
 * ioctl data for setting led 
 *
 *    The image buffer passed to the wacom device is 64*32 bytes for an Intuos4
 *    Medium and Large. The size for the Smalls is probably the same, but I 
 *    haven't verified this yet.
 */
struct wacom_led_img {
	char buf[2048];
	int btn;
};

struct wacom_handedness {
	int left_handed;
};

struct wacom_led_mode {
	char led_sel;
	char led_llv;
	char led_hlv;
	char oled_lum;
};

/* consider changing the group to something USB specific */
#define WACOM_SET_LED_IMG _IOW(0x00, 0x00, struct wacom_led_img)
#define WACOM_SET_LEFT_HANDED _IOW(0x00, 0x01, struct wacom_handedness)
#define WACOM_SET_LED_MODE _IOW(0x00, 0x02, struct wacom_led_mode)

#endif
