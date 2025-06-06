INCLUDE ProtoTypes.inc

.CODE
EatingCoin PROC,
xPos: PTR BYTE , yPos:PTR BYTE , xCoinPos:PTR BYTE , yCoinPos:PTR BYTE, Score:DWORD,Snake:PTR BYTE

PUSHAD
     MOV ESI, xPos
	 MOV EDI, yPos
	; snake is eating coin
	inc score  
	mov ebx,4
	add ebx, score
	add esi, ebx
	add edi, ebx
	mov ah, [EDI-1]
	mov al, [ESI-1]

	mov [esi], al		;add one unit to the snake
	mov [edi], ah		;pos of new tail = pos of old tail

	cmp [esi-2], al		;check if the old tail and the unit before is on the yAxis
	jne checky				;jump if not on the yAxis

	cmp [edi-2], ah		;check if the new tail should be above or below of the old tail 
	jl incy			
	jg decy
	incy:					;inc if below
	mov bl,[edi]
	inc bl
	mov [edi],bl
	jmp continue
	decy:					;dec if above
	mov bl,[edi]
	dec bl
	mov [edi],bl
	jmp continue

	checky:					;old tail and the unit before is on the xAxis
	cmp [edi-2], ah		;check if the new tail should be right or left of the old tail
	jl incx
	jg decx
	incx:					;inc if right
	mov bl,[esi]
	inc bl
	mov [esi],bl			
	jmp continue
	decx:					;dec if left
	mov bl,[esi]
	dec bl
	mov [esi],bl
	continue:				;add snake tail and update new coin
	
	mov ebx, snake
		INVOKE DrawPlayer, ESI,EDI, 1,  EBX
	
		
	 INVOKE CreateRandomCoin, xPos, yPos, xCoinPos, yCoinPos, score

	 MOV ESI, xCoinPos
	 MOV EDI, YCoinPos
	INVOKE DrawCoin, [ESI], [EDI]			

	mov dl,17				; write updated score
	mov dh,1
	call Gotoxy
	
	mov eax,score
	call Writedec
	POPAD
	RET
EatingCoin ENDP
END