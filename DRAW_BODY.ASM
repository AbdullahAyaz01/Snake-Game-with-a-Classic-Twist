INCLUDE ProtoTypes.inc


.CODE

DrawBody PROC	xPos:PTR BYTE,yPos:PTR BYTE	,score:DWORD ,Snake:PTR BYTE, TEMP: DWORD		;procedure to print body of the snake

	PUSHAD
	mov eax, TEMP
		mov esi, xPos
		mov edi, yPos
		mov ebx, Snake
		mov ecx, 4
		add ecx, score			
		printbodyloop:	
		inc esi				
		inc edi	
		inc ebx

		 push eax
		  INVOKE UpdatePlayer, ESI,EDI
          pop eax

		mov dl, [esi]
		mov dh, [edi]	;dl,dh temporarily stores the current pos of the unit 
		mov [edi], ah
		mov [esi], al	;assign new position to the unit
		mov al, dl
		mov ah,dh			;move the current position back into al,ah
		    push eax
			INVOKE DrawPlayer, ESI, EDI, 1, EBX
			pop eax
		loop printbodyloop
	POPAD
	RET
DrawBody ENDP


END