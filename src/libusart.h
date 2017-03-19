#ifndef __LIBUSART
#define __LIBUSART

void init_usart();
void send_char(char c);
void send_string(char* str);
char receive_char();

#endif	// __LIBUSART
