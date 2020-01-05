.section .data
	.macro linea 
	# .int ­1,­1,­1,­1
	# .int 1,-2,1,-2
	# .int 1,2,-3,-4
    # .int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff
    # .int 0x80000000, 0x80000000, 0x80000000, 0x80000000
    # .int 0xFC000000, 0xFC000000, 0xFC000000, 0xFC000000
    # .int 0xF8000000, 0xF8000000, 0xF8000000, 0xF8000000
    .endm
lista: .irpc i,1234
				linea
		 .endr
longlista:	.int   (.-lista)/4
resultado:	.quad   0
  formato: 	.asciz	"suma = %lld = 0x%llx hex\n"


.section .text

main: .global  main


	mov     $lista, %rbx # direccion de array lista
	mov  longlista, %rcx # longitud de la lista
	call suma		# == suma(&lista, longlista);
	mov  %eax, resultado # salvamos el resultado
    mov  %edx, resultado+4 # salvamos el resultado

    # llamada a printf
	mov   $formato, %rdi # pasamos los parámetros a printf
	mov   resultado,%rsi
	mov   resultado,%rdx
    mov   resultado,%r8d
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);

	# acabar
	mov  resultado, %eax
	call _exit		# ==  exit(resultado)
	
	

suma:
	
	mov  $0, %rsi   # inicializamos indice
	mov  $0, %r8d # acum1
	mov  $0, %edi # acum2

	
bucle:

	mov  (%rbx,%rsi,4), %eax # vamos movien en eax los datos (eax=Lista[i])

	cdq						 # extension de signo edx:eax
	add %eax,%r8d            # r8d += eax
	adc %edx,%edi			 # edi += edx

	inc %rsi			# incrementamos indice


	cmp   %rsi,%rcx		# compara que el indice es igual que la longitud
	jne    bucle

	mov %r8d,%eax		# una vez acabado el bucle retornamos los acumuladores a %eax y %edx
	mov %edi,%edx		
    
	ret  				# retornamos estos valores %eax y %edx

	