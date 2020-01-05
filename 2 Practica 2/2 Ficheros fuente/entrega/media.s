.section .data
	.macro linea 
	#    	.int  0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff
	#		.int 2,2,2,2
	#		.int  0xF0000000, 0xE0000000, 0xE0000000, 0xD0000000
	#		.int 5,6,7,8
			.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	#	    .int 0x08000000, 0x08000000, 0x08000000, 0x08000000
	#		.int 0x10000000, 0x20000000, 0x40000000, 0x80000000
	.endm
lista: .irpc i,1234
				linea
		 .endr
longlista:	.int   (.-lista)/4
media:		.int 	-1
resto: 		.int 	-1
  formato: 	.ascii "media \t = %11d \t resto \t = %11d\n"
			.asciz "\t\t = 0x %08x \t\t = 0x %08x \n"


.section .text

main: .global  main

	mov     $lista, %ebx # direccion de array lista
	mov  longlista, %ecx # longitud de la lista
	call suma		# == suma(&lista, longlista);

    # media

    idiv %ecx    		# dividimos concantenando %eax y &edx
    mov  %eax,media		# guardamos la media
    mov  %edx,resto     # guardamos el resto

    # imprim
	mov   $formato, %rdi 
	mov   media,%esi
    mov   resto,%edx
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);

	# acabar
	mov  media, %eax
	call _exit		# ==  exit(resultado)
	
	

suma:
	
	mov  $0, %esi   # inicializamos indice
	mov  $0, %r8d # acum1
	mov  $0, %edi # acum2

	
bucle:

	mov  (%ebx,%esi,4), %eax # vamos moviendo en eax los datos (eax=Lista[i])

	cdq						 # extension de signo edx:eax
	add %eax,%r8d            # r8d += eax
	adc %edx,%edi			 # edi += edx

	inc %esi			# incrementamos indice


	cmp   %esi,%ecx		# compara que el indice es igual que la longitud
	jne    bucle

	mov %r8d,%eax		# guardamos los datos de nuevo en %eax y %edx
	mov %edi,%edx
    
	ret
