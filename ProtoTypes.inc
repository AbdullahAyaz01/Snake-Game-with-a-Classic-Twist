INCLUDE Irvine32.inc

DrawWall PROTO xWall:PTR BYTE , yWall:PTR BYTE  
DrawScoreboard PROTO  		
ChooseSpeed PROTO 			

DrawPlayer PROTO xPos:PTR BYTE,yPos:PTR BYTE, COUNT:DWORD,Snake:PTR BYTE
UpdatePlayer PROTO 	xPos:PTR BYTE,yPos:PTR BYTE
DrawBody PROTO	xPos:PTR BYTE,yPos:PTR BYTE	,score:DWORD ,Snake:PTR BYTE, TEMP: DWORD

CreateRandomCoin PROTO  xPos:PTR BYTE ,  yPos:PTR BYTE, xCoinPos:PTR BYTE, yCoinPos:PTR BYTE, score: DWORD
DrawCoin PROTO xCoinPos:BYTE, yCoinPos:BYTE 

CheckSnake PROTO	xPos:PTR BYTE,yPos:PTR BYTE	,score:DWORD

EatingCoin PROTO xPos: PTR BYTE , yPos:PTR BYTE , xCoinPos:PTR BYTE , yCoinPos:PTR BYTE, Score:DWORD,Snake:PTR BYTE

;for creating random snake
RandomSnake PROTO xPos: PTR BYTE , yPos:PTR BYTE , xCoinPos:BYTE , yCoinPos:BYTE, randomChar:ptr BYTE

CheckSnake2 PROTO xPos:PTR BYTE, yPos:PTR BYTE	, xPos2:PTR BYTE, yPos2:PTR BYTE , score:DWORD

;???????????????????????????????????????????????????????????????????????????/
moveto macro x,y
push edx
    mov dl,x
	mov dh,y
	call Gotoxy	
	pop edx
endm

setcolor macro color
push eax
mov ax,color
call SetTextColor
pop eax
endm

write macro str3
push edx
mov edx,offset str3
call writestring
pop edx
endm

change_color macro x,y,str1,str2,x2,y2
push edx
    mov ecx,5

l0:  
     setcolor lightblue
     
    moveto x,y
    write str1
    moveto x2,y2
    write str2

    mov eax,249
    call delay
    setcolor cyan   

     moveto x,y
    write str1
    moveto x2,y2
    write str2

     mov eax,500
     call delay

      setcolor lightcyan

      moveto x,y
    write str1
    moveto x2,y2
    write str2

    mov eax,500
    call delay

     dec ecx
     cmp ecx,0
    je lef
    jmp l0
    lef:
     setcolor white
     Call ClrScr
     pop edx
endm
;???????????????????????????????????????????????????????????????????????????