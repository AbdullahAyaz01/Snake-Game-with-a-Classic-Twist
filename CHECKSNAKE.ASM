INCLUDE ProtoTypes.inc

.CODE

CheckSnake2 PROC xPos:PTR BYTE, yPos:PTR BYTE, xPos2:PTR BYTE, yPos2:PTR BYTE ,score:DWORD	 
	
	PUSHAD

	; for snake of the player
	MOV ESI, xPos
	MOV EDI, yPos
	MOV EBX, xPos2
	mov al, [EBX]  ; xposition

	MOV EBX, yPos2
	MOV ah, [EBX]  ; ypositi0n
	mov ECX,5
	add ECX, score
	; original snake head with random snake body
	checkWithsnake:
	cmp [ESI], al
	je XposSame
	contloop:
	inc ESI
	inc EDI
	LOOP checkWithsnake
	jmp secondCondition
	XposSame:
	  cmp [edi], ah
	  je died					;if collides, snake dies
	jmp contloop

	secondCondition:
	;for random snake
	MOV ESI, xPos2
	MOV EDI, yPos2
	MOV EBX, xPos
	mov al, [EBX]  ; xposition

	MOV EBX, yPos
	MOV ah, [EBX]  ; ypositi0n
	mov ECX,5
	add ECX, score
	checkWithsnake2:
	cmp [ESI], al
	je XposSame2
	contloop2:
	inc ESI
	inc EDI
	LOOP checkWithsnake2
	jmp died
	XposSame2:
	  cmp [edi], ah
	  je died					;if collides, snake dies
	jmp contloop2
	died:

	POPAD
	RET
CheckSnake2 ENDP



CheckSnake PROC	xPos:PTR BYTE,yPos:PTR BYTE	,score:DWORD			 
	
	PUSHAD
	MOV ESI, xPos
	MOV EDI, yPos

	mov al, [esi]
	mov ah, [edi]

	add esi,4		;logically it is not possible to collide              Ox
	add edi,4		; with less than 3 units (down dead  scenario)       xxx
	mov ecx,1
	add ecx,score
checkXposition:
	cmp [esi], al		;check if xpos same or not
	je XposSame
	contloop:
	inc esi
	inc edi
loop checkXposition
	POPAD
	RET
	XposSame:				; if xpos same, check for ypos
	cmp [edi], ah
	je died					;if collides, snake dies
	jmp contloop
	died:
	POPAD
	RET
CheckSnake ENDP
END