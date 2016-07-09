#include <p18f4520.h>
#include <stdio.h>

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = ON, LVP = OFF, PWRT = ON, BOREN = OFF

const rom char teste[5]={10,20,30,40,50};
const rom char string[]={"Esta � uma string"};
volatile char temp;

#define TBLRD {_asm TBLRDPOSTINC _endasm}

void main(void)
{	
	TBLPTRU = 0x3F;	
	TBLPTRH = 0xFF;
	TBLPTRL = 0xFE;	// TBLPTR = 0x3FFFFE (DEVID1)
	TBLRD;		// l� a mem�ria flash
	temp = TABLAT;	// o resultado est� em temp
	while(1);	// loop
}
