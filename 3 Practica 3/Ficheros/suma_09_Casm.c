// gcc popcount.c -o popcount -Og -g -D TEST=1
/*
=== TESTS === ____________________________________
for i in 0 g 1 2; do
    printf "__OPTIM%1c__%48s\n" $i "" | tr " " "="
  for j in $(seq 1 4); do
    printf "__TEST%02d__%48s\n" $j "" | tr " " "-"
    rm popcount
    gcc popcount.c -o popcount -O$i -D TEST=$j -g
    ./popcount
    done
done
=== CRONOS === ____________________________________
for i in 0 g 1 2; do
    printf "__OPTIM%1c__%48s\n" $i "" | tr " " "="
    rm popcount
    gcc popcount.c -o popcount -O$i -D TEST=0
  for j in $(seq 0 10); do
    echo $j; ./popcount
  done | pr -11 -l 22 -w 80
done
___________________________________________________
*/


#include <stdio.h>		// para printf()
#include <stdlib.h>		// para exit()
#include <sys/time.h>		// para gettimeofday(), struct timeval

int  resultado=0;

#ifndef TEST
#define TEST 5
#endif
/* -------------------------------------------------------------------- */
#if TEST==1
/* -------------------------------------------------------------------- */
#define SIZE 4
unsigned lista[SIZE]={0x80000000, 0x00400000, 0x00000200, 0x00000001};
#define RESULT 4
/* -------------------------------------------------------------------- */
#elif TEST==2
/* -------------------------------------------------------------------- */
unsigned lista[SIZE]={0x7fffffff, 0xffbfffff,0xfffffdff,0xfffffffe,0x01000023, 0x00456700,0x8900ab00,0x00cd00ef};
/* -------------------------------------------------------------------- */
#elif TEST==4 || TEST==0
/* -------------------------------------------------------------------- */
#define NBITS 20
#define SIZE (1<<NBITS)
 // tamaño suficiente para tiempo apreciable
unsigned lista[SIZE];
 // unsigned para desplazamiento derecha lógico
#define RESULT ( ? * ( ? << ?-1 ) )
 // pistas para deducir fórmula
/* -------------------------------------------------------------------- */
#else
#error "Definir TEST entre 0..4"
#endif
/* -------------------------------------------------------------------- */



int popcount1(unsigned* array, size_t len)
{
    resultado = 0;
    size_t i =0;
    for ( i=0; i < len; i++){
        contador += array[i] & 0x1;
        array[i] >>= 1;
    }

    return resultado; 
}


/*int suma1(int* array, int len)
{
    int  i,   res=0;
    for (i=0; i<len; i++)
	 res += array[i];
    return res;
}

int suma2(int* array, int len)
{
    int  i,   res=0;
    for (i=0; i<len; i++)
//	 res += array[i]; 		// traducir sólo esta línea a ASM
    asm("add (%[a],%[i],4),%[r]"
     :	[r] "+r"     (res)		// output-input
     :	[i]  "r" ((long)i),		// input
	[a]  "r"   (array)
//   : "cc"				// clobber
    );
    return res;
}

int suma3(int* array, int len)
{
  asm(" mov  $0, %%eax		\n"	// EAX – gcc salva-invocante
"	    mov  $0, %%rdx		\n"	    // RDX – gcc salva-invocante
"bucle:				\n"
"	add  (%%rdi,%%rdx,4), %%eax\n"
"	inc   %%rdx		\n"
"	cmp   %%rdx,%%rsi	\n"
"	jne    bucle		  "
     : 					// output
     : 					// input
     : "cc",				// clobber – como usamos sintaxis extendida
       "rax","rdx"			// hay que referirse a los registros con %%
    );
}*/

void crono(int (*func)(), char* msg){
    struct timeval tv1,tv2; 			// gettimeofday() secs-usecs
    long           tv_usecs;			// y sus cuentas

    gettimeofday(&tv1,NULL);
    resultado = func(lista, SIZE);
    gettimeofday(&tv2,NULL);

    tv_usecs=(tv2.tv_sec -tv1.tv_sec )*1E6+
             (tv2.tv_usec-tv1.tv_usec);
    printf("resultado = %d\t", resultado);
    printf("%s:%9ld us\n", msg, tv_usecs);
}

#if TEST==0
    printf("%ld" "\n", tv_usecs);
#else
    printf("resultado = %d\t", resultado);
    printf("%s:%9ld us\n", msg, tv_usecs);
#endif


int main()
{
#if TEST==0 || TEST==4
    size_t i;
    for (i=0; i<SIZE; i++)
        lista[i]=i;
#endif

    crono(popcount1 ,"popcount1 (lenguaje C - for)");

#if TEST != 0
    printf("calculado = %d\n", RESULT);
#endif


    exit(0);
}
