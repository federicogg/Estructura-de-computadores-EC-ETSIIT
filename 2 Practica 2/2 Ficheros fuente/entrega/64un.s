.section .data
	.macro linea 
	#    	.int 1,1,1,1
	#		.int 2,2,2,2
	#		.int 1,2,3,4
	#		.int -1,-1,-1,-1
	#		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
			.int 0x08000000, 0x08000000, 0x08000000, 0x08000000
	#		.int 0x10000000, 0x20000000, 0x40000000, 0x80000000
	.endm
lista: .irpc i,1234
				linea
		 .endr

longlista:	.int   (.-lista)/4
resultado:	.quad   -1
  formato: 	.asciz	"suma = %llu = 0x%llx hex\n"

.section .text

main: .global  main

	mov     $lista, %rbx # direccion de array lista
	mov  longlista, %rcx # longitud de la lista
	call suma		# == suma(&lista, longlista);
	mov  %eax, resultado # salvamos el resultado
    mov  %edx, resultado+4 # salvamos el resultado

    # llamada a la función printf en c
	mov   $formato, %rdi 	# metemos los parametros de la funcion printf en sus corrrespondientes registros
	mov   resultado,%rsi
	mov   resultado,%rdx
	mov   resultado,%ecx
	mov   resultado,%r8d
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);

	# acabar
	mov  resultado, %edi
	call _exit		# ==  exit(resultado)

suma:

	mov  $0, %eax # ponemos los valores a 0 antes del bucle
	mov  $0, %rsi
	mov  $0, %edx

bucle:

	add  (%rbx,%rsi,4), %eax # vamos acumulando en eax las sumas
	inc %rsi			# incrementamos indice
	jnc salto			# salta si CF=0
	inc   %edx			# incrementamos edx si hay acarreo
	ret			

salto:

	cmp   %rsi,%rcx		# compara que el indice es diferente que la longitud
	jne    bucle		# si la comparacion es diferente salta de nuevo al bucle

	ret


	


