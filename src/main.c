
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

void init_pin13() 
{
	GPIO_InitTypeDef gpio;

	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

	GPIO_StructInit(&gpio); 
	gpio.GPIO_Pin = GPIO_Pin_13;
	gpio.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC, &gpio);
}

void blink13(int delay)
{
	GPIO_SetBits(GPIOC, GPIO_Pin_13);
	delay_ms(delay);
	GPIO_ResetBits(GPIOC, GPIO_Pin_13);
	delay_ms(delay);
}

void blink_sos()
{
	blink13(500);
	blink13(500);
	blink13(500);
	
	blink13(200);
	blink13(200);
	blink13(200);	
}

int main(void)
{
	init_pin13();
	SysTick_Config(64000);

	for(;;)
	{
		/*
		for(int i=300; i>10; i-=30)
			blink13(i);
		for(int i=10; i<300; i+=30)
			blink13(i);
		*/
		
		blink_sos();

	}
}
