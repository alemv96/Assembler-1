;Date: 19/01/2017
;By : Alejandro Martinez , Ricardo Cefalo.

TITLE Cache memory project
.386
.model flat , stdcall
.stack 4096

include \Irvine\Irvine32.inc
includelib \Irvine\Irvine32.lib
include \Irvine\Macros.inc
includelib \Irvine\Kernel32.lib
includelib \Irvine\User32.lib


.data
	;Defino el menu de mi programa
    menuProgram BYTE "SElECCIONE UNA OPCION", 0dh, 0ah , 0dh , 0ah,
    "1. Modulo 1: Ubicacion de bloques",  0dh, 0ah ,
    "2. Modulo 2: Simulador de reemplazo de bloques",  0dh, 0ah ,
	"3. SALIR" , 0dh, 0ah , 0
	salto BYTE".", 0dh, 0ah, 0
	ingMemPrincipal BYTE "Ingrese tamaño de la memoria Principal", 0dh, 0ah , "1. 32KB" , 0dh, 0ah ,"2. 64KB " , 0dh, 0ah ,"3. 128KB " ,0dh, 0ah ,"4. 256KB" , 0dh, 0ah , "5. 512KB", 0dh, 0ah ,"6. 1MB",  0dh, 0ah , "7. 2MB" , 0dh, 0ah ,"8. 4MB",  0dh, 0ah ,"9.  8MB" , 0dh, 0ah ,"10. 16MB ", 0dh, 0ah ,"11. 32MB", 0dh, 0ah , 0
	ingMemCache BYTE "Ingrese tamaño de la memoria Cache", 0dh, 0ah  , "1. 64B ",  0dh, 0ah , "2. 128B " ,  0dh, 0ah , "3. 256B", 0dh, 0ah , "4. 512B", 0dh, 0ah , 0
	ingBloque BYTE "Ingrese tamaño del Bloque", 0dh, 0ah,"1. 2B" ,  0dh, 0ah , "2. 4B", 0dh, 0ah , "3. 8B", 0dh, 0ah , "4. 16B", 0dh, 0ah ,"5. 32B" , 0dh, 0ah , 0
	ingConjunto BYTE "Ingrese el tamaño del conjunto en bloques", 0dh, 0ah,"1. 2 Bloques", 0dh, 0ah , "2. 4 Bloques" , 0dh, 0ah , "3. 8 Bloques " , 0dh, 0ah , 0
	ingDireccion BYTE "Ingrese Direccion", 0dh, 0ah, 0
	inModule BYTE "1. Mapeo directo", 0dh, 0ah , "2. Mapeo asociativo", 0dh, 0ah  , 0
	modulo2Issue BYTE "no se logro implementar" , 0
	entry_Data DWORD ?
	tamMemoriaPrincipal DWORD ?
	tamMemCache DWORD ?
	tamBloque DWORD ?
	tamConjunto DWORD ?
	tagValue DWORD ?
	lineValue DWORD ? 
	byteValue DWORD ?
	promptBad BYTE "Invalid input, please enter again", 0 ; mensaje de error.
	Ttag BYTE " Tag = ", 0
	Tline BYTE "Line = ", 0
	TamByte BYTE " Byte = ", 0
	MAX = 5
	buffer BYTE MAX + 1 DUP(?)
	buffer2 BYTE "10"
	bufsize = ($ - buffer)
	decval DWORD ?
	
	ExitProcess PROTO , dwExitCode: DWORD
 
.code 
 
;***************** MAIN **********************
;		    Procedimiento principal          *
;***************** MAIN **********************
main proc 		
	inicio:			
		CALL saltoLinea
		CALL printMenu
		CALL inDataUser
		
		cmp al, 1
		je Mapping
		cmp al, 2
		je Warning
		cmp eax , 0 ; comparo si el valor es menor a 0 mando un error 
		jb error 
		cmp eax , 3  ; ahora si el numero es mayor que 3 mando un error
		ja error
		cmp al, 3

		exit

	
	Mapping :CALL Clrscr
			 CALL saltoLinea
			 mov EDX, OFFSET inModule
			 CALL WriteString
			 CALL ReadDec
			 cmp al, 1
			 Je opcion1
			 cmp al , 2
			 je opcion2

	Warning:CALL Clrscr
			mov EDX, OFFSET modulo2Issue
			CALL WriteString 
			jmp inicio
			
	opcion1:		
		CALL Clrscr
		CALL saltoLinea
		mov EDX, OFFSET ingDireccion
		CALL WriteString
		mov  edx, OFFSET buffer
		mov  ecx, MAX  ; buffer size - 1
		call ReadString
		CALL saltoLinea
		mov EDX, OFFSET ingMemPrincipal
		CALL WriteString
		CALL memPrincipal
		mov EDX, OFFSET ingMemCache
		CALL WriteString 
		CALL memCache
		mov EDX, OFFSET ingBloque 
		CALL WriteString
		CALL bloque

		;guarda tamaños 
		mov EAX, tamMemoriaPrincipal
		sub EAX, tamMemCache
		mov tagValue, EAX

		mov EAX, tamMemCache
		sub EAX, tamBloque
		mov lineValue, EAX

		mov EAX, tamBloque
		mov byteValue, EAX
			
		;imprime tamaños
		mov EDX, OFFSET Ttag
		CALL WriteString
		mov EAX, tagValue
		CALL WriteInt;
		mov EDX, OFFSET Tline
		CALL WriteString
		mov EAX, lineValue
		CALL WriteInt;
		mov EDX, OFFSET TamByte
		CALL WriteString
		mov EAX, byteValue
		CALL WriteInt;
		CALL saltoLinea
		
		mov   edx, OFFSET buffer
		mov   ecx, bufsize
		CALL  toBinary
		mov   decval, EAX
		CALL WriteBin
		CALL saltoLinea
		CALL ReadDec
		CALL Clrscr
		JMP inicio
	
	opcion2:
		CALL Clrscr
		CALL saltoLinea
		mov EDX, OFFSET ingDireccion
		CALL WriteString
		mov  edx, OFFSET buffer
		mov  ecx, MAX   ; buffer size - 1
		call ReadString
		CALL saltoLinea
		mov EDX, OFFSET ingMemPrincipal
		CALL WriteString
		CALL memPrincipal
		mov EDX, OFFSET ingMemCache
		CALL WriteString
		CALL memCache
		mov EDX, OFFSET ingBloque
		CALL WriteString
		CALL bloque
		mov EDX, OFFSET ingConjunto
		CALL WriteString
		CALL conjunto
		
		; guarda tamaños
		mov EAX, tamMemCache
		sub EAX, tamBloque
		sub EAX, tamConjunto
		mov lineValue, EAX
		mov EAX, tamBloque
		mov byteValue, EAX
		mov EAX, tamMemoriaPrincipal
		sub EAX, lineValue
		sub EAX, byteValue
		mov tagValue, EAX

		; imprime tamaños
		mov EDX, OFFSET Ttag
		CALL WriteString
		mov EAX, tagValue
		CALL WriteInt;
		mov EDX, OFFSET Tline
		CALL WriteString
		mov EAX, lineValue
		CALL WriteInt;
		mov EDX, OFFSET TamByte
		CALL WriteString
		mov EAX, byteValue
		
		CALL WriteInt
		CALL saltoLinea
		mov   edx, OFFSET buffer
		mov   ecx, bufsize
		CALL  toBinary
		mov   decval, EAX
		CALL WriteBin
		CALL saltoLinea
		CALL ReadDec
		CALL Clrscr
		JMP inicio
	
	opcion3:
		je inicio

	
	error:	
		mov EDX, OFFSET promptBad
		CALL WriteString
		JMP inicio
		;invoke ExitProcess, 0

    main ENDP

	;**********************PRINTMENU***************************************************
	;*         PRECONDICION: no recibe nada.                                          *
	;*         POSTCONDICION: muestra el menu de usuario.                             *
	;**********************PRINTMENU***************************************************
	printMenu PROC near
		mov EDX, OFFSET menuProgram
		CALL WriteString; imprime lo que se encuentre en el registro EDX
		ret
	printMenu ENDP

	;**********************INDATAUSER**************************************************
	;*          PRECONDICION: no recibe nada.                                          *
	;*          POSTCONDICION: recibe los datos de entrada de usuario                  *
	;**********************INDATAUSER**************************************************
	inDataUser PROC near
		CALL ReadDec
		mov entry_Data, EAX
		ret
	InDataUser ENDP

	; **********************MEMPRINCIPAL************************************************
	; *			PRECONDICION: no recibe nada.                                          *
	; *			POSTCONDICION: recibe los datos de entrada de usuario                  *
	; **********************INDATAUSER**************************************************
	memPrincipal PROC near
		   
		CALL ReadDec
	    mov entry_Data, EAX
		cmp EAX, 1
		JE _15
		cmp EAX, 2
		JE _16
		cmp EAX, 3
		JE _17
		cmp EAX, 4
		JE _18
		cmp EAX, 5
		JE _19
		cmp EAX, 6
		JE _20
		cmp EAX, 7
		JE _21
		cmp EAX, 8
		JE _22
		cmp EAX, 9
		JE _23
		cmp EAX, 10
		JE _24
		cmp EAX, 11
		JE _25	
	
		_15:
			mov tamMemoriaPrincipal, 15
			ret
	
		_16:
			mov tamMemoriaPrincipal, 16
			ret
	
		_17 :
			mov tamMemoriaPrincipal, 17
			ret
	
		_18 :
			mov tamMemoriaPrincipal, 18
			ret
	
		_19 :
			mov tamMemoriaPrincipal, 19
			ret
	
		_20 :
			mov tamMemoriaPrincipal, 20
			ret
	
		_21 :
			mov tamMemoriaPrincipal, 21
			ret
	
		_22 :
			mov tamMemoriaPrincipal, 22
			ret
	
		_23 :
			mov tamMemoriaPrincipal, 23
			ret
	
		_24 :
			mov tamMemoriaPrincipal, 24
			ret
	
		_25 :
			mov tamMemoriaPrincipal, 25
			ret
	
	memPrincipal ENDP

	; **********************MEMCACHE********************************************
	; *			PRECONDICION: RECIBE EL REGISTRO EAX                           *
	; *			POSTCONDICION: ASIGNA EL TAMAñO A LA MEMORIA CACHE             *
	; **********************MEMCACHE********************************************
	memCache PROC near	
		CALL inDataUser
		cmp EAX, 1
		JE _6
		cmp EAX, 2
		JE _7
		cmp EAX, 3
		JE _8
		cmp EAX, 4
		JE _9
		cmp EAX, 5
		JE _10
	
		_6 :
			mov tamMemCache, 6
			ret
	
		_7 :
			mov tamMemCache, 7
			ret
	
		_8 :
			mov tamMemCache, 8
			ret
	
		_9 :
			mov tamMemCache, 9
			ret
	
		_10 :
			mov tamMemCache, 10
			ret

	;ret
	
	memCache ENDP

	; **********************BLOQUE***********************************************
	; *			PRECONDICION: RECIBE EL REGISTRO EAX                            *
	; *			POSTCONDICION: ASIGNA EL TAMAÑO DEL BLOQUE DE LA MEMORIA        *
	; **********************BLOQUE***********************************************
	bloque PROC near
		CALL inDataUser
		cmp EAX, 1
		JE _1
		cmp EAX, 2
		JE _2
		cmp EAX, 3
		JE _3 
		cmp EAX, 4
		JE _4 
		cmp EAX, 5
		JE _5 
	
		_1:
			mov tamBloque, 1
			ret 
	
		_2:
			mov tamBloque, 2
			ret 
	
		_3:
			mov tamBloque, 3
			ret 
	
		_4:
			mov tamBloque, 4
			ret
	
		_5:
			mov tamBloque, 5
			ret
	
	bloque ENDP

	; **********************CONJUNTO*******************************************************
	; *			PRECONDICION: RECIBE EL REGISTRO EAX                                      *
	; *			POSTCONDICION: ASIGNA EL TAMAÑO DEL CONJUNTO DE LA MENMORIA CACHE         *
	; **********************CONJUNTO*******************************************************
	conjunto PROC near
		CALL inDataUser
		cmp EAX, 1
		JE _1
		cmp EAX, 2
		JE _2
		cmp EAX, 3
		JE _3
	
	_1 :
		mov tamConjunto, 1
		ret
	
	_2 :
		mov tamConjunto, 2
		ret
	
	_3 :
		mov tamConjunto, 3
		ret
	
  conjunto ENDP

;*************************************************TOBINARY***********************************************************
;*	PRECONDICION: recibe ebx , ecx , edx , esi																		*
;*  POSTCONDICION: Transforma el valor que se encuentra en ecx a binario.											*
;*************************************************TOBINARY***********************************************************

  toBinary PROC near USES ebx ecx edx esi
	LOCAL saveValue: DWORD

			mov esi, edx; guarda el offset en ESI
			cmp ecx, 0
			jne L1
			mov eax, 0
			jmp L5
								
		L1 : 
			 mov al, [esi]
			 cmp al, ' '
			 je	L1A
			 cmp al, TAB
			 je	L1A
			 jmp L2

		L1A :
	     	inc esi
			loop L1
			jmp L5
								
		L2:	
			mov  eax, 0
			mov  ebx, 10
		
		L3:	
			mov  dl, [esi]
			cmp  dl, '0'
			jb   L4
			cmp  dl, '9'
			ja   L4
			and  edx, 0Fh

			mov  saveValue, edx
			mul  ebx
			jc   L5
			mov  edx, saveValue
			add  eax, edx
			jc   L5
			inc  esi
			jmp  L3
	   
	    L4 :
			 clc
		     jmp  L6

	    L5 :
			 mov  eax, 0
		     stc
		
		L6:	ret ; se retorna a la instruccion siguiente de quien lo llamo.
		 
	toBinary ENDP

	; **********************SALTODELINEA************************************************
	; *			PRECONDICION: RECIBE LA VARIABLE SALTO                                 *
	; *			POSTCONDICION: IMPRIME EL VALOR QUE SE ENCUENTRA EN EDX                *
	; **********************SALTODELINEA************************************************
	 saltoLinea PROC near
		mov EDX, OFFSET salto
		CALL WriteString
		ret
	 saltoLinea ENDP

END main