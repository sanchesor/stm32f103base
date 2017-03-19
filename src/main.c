#include "stm32f10x.h"
#include "libusart.h"

volatile uint32_t timer_ms = 0;

void SysTick_Handler()
{
	if(timer_ms)
	{
		timer_ms--;
	}
}

void delay_ms(int ms)
{
	timer_ms = ms;
	while(timer_ms) {};
}


int main(void)
{
	init_usart();
	SysTick_Config(64000);	
	
	for(;;)
	{
		char c = receive_char();
		switch(c)
		{
			case 'a':
				send_string("letter a\r\n");
				break;
			case 'b':
				send_string("letter b\r\n");
				break;
			default:
				send_string("other letter\r\n");
				break;
		}
	}
}
