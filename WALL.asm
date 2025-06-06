INCLUDE ProtoTypes.inc

.data
Wall BYTE 60 DUP("#"),0

.CODE

DrawWall PROC xWall:PTR BYTE , yWall:PTR BYTE

  setcolor red
   mov esi,xwall  ; move addres to index registers
   mov edi,ywall
 
	mov dl,[esi]
	mov dh,[edi]
	call Gotoxy	
	mov edx,OFFSET Wall
	call WriteString			;draw upper wall

	mov dl,[esi+1]
	mov dh,[edi+1]
	call Gotoxy	
	mov edx,OFFSET Wall		
	call WriteString			;draw lower wall

	mov dl, [esi+2]
	mov dh, [edi+2]
	mov al,"#"	
	inc dh
	L11: 
	call Gotoxy	
	call WriteChar	
	inc dh
	cmp dh, [edi+3]			;draw right wall	
	jl L11

	mov dl, [esi+0]
	mov dh, [edi+0]
	mov al,"#"
	inc dh
	L12: 
	call Gotoxy	
	call WriteChar	
	inc dh
	cmp dh, [edi+3]			;draw left wall
	jl L12
	setcolor white
	ret
DrawWall ENDP

END