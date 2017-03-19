#include "stm32f10x.h"

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


void init_usart()
{
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
	
	GPIO_InitTypeDef gpio_conf;
	GPIO_StructInit(&gpio_conf);
	
	// TX
	gpio_conf.GPIO_Pin = GPIO_Pin_9;
	gpio_conf.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(GPIOA, &gpio_conf);
	
	// RX
	gpio_conf.GPIO_Pin = GPIO_Pin_10;
	gpio_conf.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA, &gpio_conf);
	
	USART_InitTypeDef usart_conf;
	USART_StructInit(&usart_conf);
	usart_conf.USART_BaudRate = 115200;
	USART_Init(USART1, &usart_conf);
	USART_Cmd(USART1, ENABLE);
}

void send_char(char c)
{
	while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
	
	USART_SendData(USART1, c);
}

void send_string(char* str)
{
	while(*str)
		send_char(*str++);		
}

char receive_char()
{
	while(USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET);
	
	return USART_ReceiveData(USART1);		
}

int main(void)
{
	init_usart();
	SysTick_Config(64000);	
	
	for(;;)
	{
		send_string("napis z arma\r\n");
		delay_ms(200);
	}
}
