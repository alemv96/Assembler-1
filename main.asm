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
	ingMemPrincipal BYTE "Ingrese tamaño de la memoria Principal", 0dh, 0ah, 0
	ingMemCache BYTE "Ingrese tamaño de la memoria Cache", 0dh, 0ah, 0
	ingBloque BYTE "Ingrese tamaño del Bloque", 0dh, 0ah, 0
	ingConjunto BYTE "Ingrese el tamaño del conjunto en bloques", 0dh, 0ah, 0
	entry_Data DWORD ?
	tamMemoriaPrincipal DWORD ?
	tamMemCache DWORD ?
	tamBloque DWORD ?
	tamConjunto DWORD ?
	tagValue DWORD ?
	lineValue DWORD ? 
	byteValue DWORD ?
	promptBad BYTE "Invalid input, please enter again", 0
	Ttag BYTE " Tag = ", 0
	Tline BYTE "Line = ", 0
	TamByte BYTE " Byte = ", 0
	buffer BYTE "5"
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
		je opcion1
		cmp al, 2
		je opcion2
		cmp al, 3
		exit


	opcion1:
		CALL Clrscr

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

	ret
	memCache ENDP

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


toBinary PROC near USES ebx ecx edx esi
LOCAL saveDigit : DWORD
;
			; Converts(parses) a string containing an unsigned decimal
				; integer, and converts it to binary.All valid digits occurring
				; before a non - numeric character are converted.
				; Leading spaces are ignored.

				; Receives: EDX = offset of string, ECX = length
				; Returns:
			;  If the integer is blank, EAX = 0 and CF = 1
				;  If the integer contains only spaces, EAX = 0 and CF = 1
				;  If the integer is larger than 2 ^ 32 - 1, EAX = 0 and CF = 1
				;  Otherwise, EAX = converted integer, and CF = 0
				;
			; Created 7 / 15 / 05 (from the old ReadDec procedure)
				; --------------------------------------------------------

				mov   esi, edx; save offset in ESI

				cmp   ecx, 0; length greater than zero ?
				jne   L1; yes: continue
				mov   eax, 0; no: set return value
				jmp   L5; and exit with CF = 1

				; Skip over leading spaces, tabs

			L1 : mov   al, [esi]; get a character from buffer
				 cmp   al, ' '; space character found ?
				 je	L1A; yes: skip it
				 cmp	al, TAB; TAB found ?
				 je	L1A; yes: skip it
				 jmp   L2; no: goto next step

			 L1A :
			inc   esi; yes: point to next char
				loop  L1; continue searching until end of string
				jmp   L5; exit with CF = 1 if all spaces

				; Replaced code(7 / 19 / 05)-------------------------------------------- -
				; L1:mov   al, [esi]; get a character from buffer
				;	cmp   al, ' '; space character found ?
				;	jne   L2; no: goto next step
				;	inc   esi; yes: point to next char
				;	loop  L1; all spaces ?
				;	jmp   L5; yes: exit with CF = 1
				; -------------------------------------------------------------------- -

				; Start to convert the number.

			L2:	mov  eax, 0; clear accumulator
				mov  ebx, 10; EBX is the divisor

				; Repeat loop for each digit.

			L3:	mov  dl, [esi]; get character from buffer
				cmp  dl, '0'; character < '0' ?
				jb   L4
				cmp  dl, '9'; character > '9' ?
				ja   L4
				and  edx, 0Fh; no: convert to binary

				mov  saveDigit, edx
				mul  ebx; EDX:EAX = EAX * EBX
				jc   L5; quit if Carry(EDX > 0)
				mov  edx, saveDigit
				add  eax, edx; add new digit to sum
				jc   L5; quit if Carry generated
				inc  esi; point to next digit
				jmp  L3; get next digit

			L4 : clc; succesful completion(CF = 0)
				 jmp  L6

			 L5 : mov  eax, 0; clear result to zero
				  stc; signal an error(CF = 1)

			  L6:	ret
					toBinary ENDP
		saltoLinea PROC near
		mov EDX, OFFSET salto
		CALL WriteString
		ret
		saltoLinea ENDP
		
END main
