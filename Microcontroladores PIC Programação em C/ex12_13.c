#include <16f877.h>
#use delay(clock=4000000)
#fuses HS,NOWDT,PUT,NOLVP

#int_timer1
void trata_t1 ()
{
	static boolean led;
	static int conta;
	// reinicia o timer 1 em 3036 mais a contagem que j� passou
	set_timer1(3036 + get_timer1());
	conta++;
	// se j� ocorreram 2 interrup��es
	if (conta == 2)
	{
		conta=0;
		led = !led;  // inverte o led
		output_bit (pin_c2,led);
	}
}

main()
{
	// configura o timer 1 para clock interno e prescaler dividindo por 8
	setup_timer_1 ( T1_INTERNAL | T1_DIV_BY_8 );
	// inicia o timer 1 em 3036
	set_timer1(3036);
	// habilita interrup��es
	enable_interrupts (global );
	enable_interrupts (int_timer1);
	while (true); // espera interrup��o
}
