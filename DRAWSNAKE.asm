INCLUDE ProtoTypes.inc

.CODE

DrawPlayer PROC	xPos:PTR BYTE,yPos:PTR BYTE, COUNT:DWORD,Snake:PTR BYTE	; draw player at (xPos,yPos)
PUSHAD
setcolor green
mov eax,0
mov esi, xPos
mov edi, yPos
mov ebx,snake
mov ecx, count

	

drawSnake:

	mov dl,[esi]
	mov dh,[edi]
	call Gotoxy
	inc esi
	inc edi

	mov al, [ebx]	
	call WriteChar
	inc ebx
		
	loop drawSnake
	POPAD
	setcolor white
	RET
DrawPlayer ENDP

UpdatePlayer PROC 	xPos:PTR BYTE,yPos:PTR BYTE		; erase player at (xPos,yPos)

   PUSHAD
    mov esi, xPos
    mov edi, yPos

	mov dl, [esi]
	mov dh,[edi]
	call Gotoxy
	
	mov al, " "
	call WriteChar
	POPAD
	ret
UpdatePlayer ENDP



END