INCLUDE ProtoTypes.inc

.CODE
CreateRandomCoin PROC xPos: PTR BYTE , yPos:PTR BYTE , xCoinPos:PTR BYTE , yCoinPos:PTR BYTE, Score:DWORD				;procedure to create a random coin
	pushad
	MOV ESI,xPos
	MOV EDI,yPos
	mov eax,57
	call RandomRange	;0-57
	add eax, 22			;2-79
	mov ebx, xCoinPos
	mov [ebx],al
	mov eax,17
	call RandomRange	;0-17
	add eax, 6			;6-23
	mov ebx, yCoinPos
	mov [ebx],al

	mov ecx, 5					; 5 is a initiale size of snake
	add ecx, Score				;increase loop number by adding score
	
checkCoinXPos:
   mov ebx, xCoinPos
   mov eax,0
	mov eax, [ebx]
	cmp al, [esi]		
	je checkCoinYPos			
	continueloop:
	inc esi
	inc edi
loop checkCoinXPos
	popad
	RET					; return when coin is not on snake
	checkCoinYPos:
	mov ebx, yCoinPos
	mov eax,0
	mov eax, [ebx]			
	cmp al,[edi]
	jne continueloop		
	INVOKE CreateRandomCoin, xPos, yPos, xCoinPos, yCoinPos, Score		; coin generated on snake, calling function again to create another set of coordinates
CreateRandomCoin ENDP



DrawCoin PROC xCoinPos:BYTE , yCoinPos:BYTE  			;procedure to draw coin
	pushad
	mov eax,blue (blue * 16)
	call SetTextColor				;set color to yellow for coin
	mov dl,xCoinPos
	mov dh,yCoinPos
	call Gotoxy
	mov al,"C"
	call WriteChar
	mov eax,white (black * 16)		;reset color to black and white
	call SetTextColor
	popad
	RET
DrawCoin ENDP


RandomSnake PROC xPos: PTR BYTE , yPos:PTR BYTE , xCoinPos:BYTE , yCoinPos:BYTE,  randomChar:ptr BYTE
pushad
	MOV ESI,xPos
	MOV EDI,yPos
	mov eax, 49
	movzx ebx, xCoinPos
	cmp eax, EBX
	JA SecondScreen
	mov ecx,5
	mov ebx,27
	FirstScreen:
	mov [esi],bl

	movzx eax, yCoinPos

	mov [edi],  al
	dec EBX
	inc EDI
	inc ESI
	loop FirstScreen
	MOV ESI,randomChar
	mov al,"d"
	mov [esi],al
	popad
	ret

	SecondScreen:
	mov ecx,5
	mov ebx,74
	start:
	mov [esi],bl

	movzx eax, yCoinPos

	mov [edi], al
	inc EBX
	inc EDI
	inc ESI
	loop start
	MOV ESI,randomChar
	mov al,"a"
	mov [esi],al
		popad
	RET		
RandomSnake ENDP

END