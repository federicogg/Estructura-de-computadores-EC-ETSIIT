.section .data
lista:		.int 0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000,0x10000000
longlista:	.int   (.-lista)/4
resultado:	.quad   -1
  formato: 	.asciz	"suma = %llu = 0x%llx hex\n"

# opción: 1) no usar printf, 2)3) usar printf/fmt/exit, 4) usar tb main
# 1) as  suma.s -o suma.o
#    ld  suma.o -o suma					1232 B
# 2) as  suma.s -o suma.o				6520 B
#    ld  suma.o -o suma -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
# 3) gcc suma.s -o suma -no-pie –nostartfiles		6544 B
# 4) gcc suma.s -o suma	-no-pie				8664 B

.section .text
 # _start: .global _start
main: .global  main

	# call trabajar	# subrutina de usuario
	# call imprim_C	# printf()  de libC
	# call acabar_L	# exit()   del kernel Linux
	# call acabar_C	# exit()    de libC
	# ret


	mov     $lista, %rbx # direccion de array lista
	mov  longlista, %rcx # longitud de la lista
	call suma		# == suma(&lista, longlista);
	mov  %eax, resultado # salvamos el resultado
    mov  %edx, resultado+4 # salvamos el resultado

    # imprim_C
	mov   $formato, %rdi 
	mov   resultado,%rsi
	mov   resultado,%rdx
	mov   resultado,%ecx
	mov   resultado,%r8d
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);

	# acabar_C
	mov  resultado, %edi
	call _exit		# ==  exit(resultado)
	
	

suma:

	mov  $0, %eax # ponemos los valores a 0 antes del bucle
	mov  $0, %rsi
	mov  $0, %edx

	
bucle:

	add  (%rbx,%rsi,4), %eax # vamos acumulando en eax las sumas

	inc %rsi			# incrementamos indice

	adc $0,%edx

	ret			

salto:

	cmp   %rsi,%rcx		# compara que el indice es igual que la longitud
	jne    bucle

    
	ret


	


