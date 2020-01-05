.section .data
	.macro linea 
	#    	.int 1,1,1,1
	#		.int 2,2,2,2
			.int 1,2,3,4
	#		.int -1,-1,-1,-1
	#		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	#		.int 0x08000000, 0x08000000, 0x08000000, 0x08000000
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


	mov     $lista, %ebx # direccion de array lista
	mov  longlista, %ecx # longitud de la lista
	call suma		# == suma(&lista, longlista);

    # media

    idiv %ecx
    mov  %eax,media
    mov  %edx,resto

    # imprim_C
	mov   $formato, %rdi 
	mov   media,%esi
    mov   resto,%edx
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);

	# acabar_C
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

	mov %r8d,%eax
	mov %edi,%edx
    
	ret
