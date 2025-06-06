INCLUDE ProtoTypes.inc

.DATA

PROMPT BYTE "Your score is: ",0

.CODE

DrawScoreboard PROC 			
	mov dl,2
	mov dh,1
	call Gotoxy
	mov edx,OFFSET PROMPT		
	call WriteString
	mov eax,"0"
	call WriteChar				
	RET
DrawScoreboard ENDP

END