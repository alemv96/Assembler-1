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
	entry_Data DWORD ?
	tamMemoriaPrincipal DWORD ?
	tamMemCache DWORD ?
	tamBloque DWORD ?
	promptBad BYTE "Invalid input, please enter again"
	ExitProcess PROTO , dwExitCode: DWORD
 .code 
 
	;***************** MAIN **********************
	;		    Procedimiento principal          *
	;***************** MAIN **********************

    main proc 
	inicio:	
		CALL printMenu
		CALL inDataUser


		cmp al, 1
		je opcion1
		cmp al, 2
		je opcion2
		cmp al, 3
		exit


	opcion1:
		CALL Clrscr
		CALL memPrincipal
		CALL memCache
		CALL bloque

		mov EAX, tamMemoriaPrincipal
		CALL WriteInt; imprime lo que se encuentre en el registro EDX
		JMP inicio
	opcion2:
		je inicio
	opcion3:
		je inicio

	
	error:
		mov EDX, OFFSET promptBad
		CALL WriteString
		je inicio

		invoke ExitProcess, 0
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
	;*         PRECONDICION: no recibe nada.                                          *
	;*         POSTCONDICION: recibe los datos de entrada de usuario                  *
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
	
	memCache PROC near
		CALL inDataUser
		cmp EAX, 1
			mov tamMemCache, 6
		cmp EAX, 2
			mov tamMemCache, 7
		cmp EAX, 3
			mov tamMemCache, 8
		cmp EAX, 4
			mov tamMemCache, 9
		cmp EAX, 5
			mov tamMemCache, 10
	ret
	memCache ENDP

	bloque PROC near
		CALL inDataUser
		cmp EAX, 1
			mov tamBloque, 1
		cmp EAX, 2
			mov tamBloque, 2
		cmp EAX, 3
			mov tamBloque, 3
		cmp EAX, 4
			mov tamBloque, 4
		cmp EAX, 5
			mov tamBloque, 5
		ret
	bloque ENDP

	getSizes PROC near
	ret
	getSizes ENDP
END main
