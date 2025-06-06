INCLUDE ProtoTypes.inc



.DATA
   ;for macro
 SNAKEHUNYAAR byte"                                   ",0ah,0dh
              byte"                           ____    ",0ah,0dh
			  byte"                   _______| * *|   ",0ah,0dh
			  byte"   *****\\        / ------|    \~~~",0ah,0dh
			  byte"        \ \      / /       ----    ",0ah,0dh
			  byte"         \ \____/ /                ",0ah,0dh
			  byte"          \______/                 ",0

SNAKEandSONS db "\\      /\      //  ===== ||       ====   ====    |\      /|   =====    ",0ah,0dh
             db"  \\    //\\    //  ||     ||      =      =    =   ||\    //| ||        ",0ah,0dh
             db"   \\  //  \\  //   ||===  ||     =      =      =  ||\\  //|| ||===    ",0ah,0dh
             db"    \\//    \\//    ||     ||      =      =    =   || \\// || ||        ",0ah,0dh
             db"     \/      \/      =====  ======  ====   ====    ||  \/  ||   =====    ",0
  ;for call MSGBOXASK
caption BYTE "    DEATH NOTE....",0
question BYTE "MAAR GAYA HUN SUKOON HI",0ah,0dh,0ah,0dh
        byte"KIA BOLTA HY AIK OR HOJAYEE",0


score BYTE 0
strPoints BYTE " YOUR SCORE IS : ",0

;original snake
snake BYTE "O", 104 DUP("x")
;RANDOM SNAKE
snake2 BYTE "Z", 4 DUP("z")
blank BYTE 5 DUP(" ")


;original snake position
xPos BYTE 32,31,30,29,28, 105 DUP(?)
yPos BYTE 15,15,15,15,15, 105 DUP(?)

;RANDOM SNAKE POSITIONS
xPos2 BYTE 32,31,30,29,28, 105 DUP(?)
yPos2 BYTE 11,11,11,11,11, 105 DUP(?)

;structure of wall in the form of rectangle in xy plane
;       21,5--------80,5
;        |           |     
;       |           | 
;      21,24-------80,24
xPosWall BYTE 21,21,80,80			 
yPosWall BYTE 5,24,5,24

;variable stores coin coorinates
xCoinPos BYTE ?
yCoinPos BYTE ?

; variable that decide random snake should move left or right
randomSnakeChar BYTE ?

; variables use to move original snake 
inputChar BYTE "+"		
lastInputChar BYTE ?				

; variable to store speed to slow the game so that we able enjoy it
; more but the snake and it son both have same speed
speed	DWORD 120

.code
;===========================================================================================
;                                                                                           
;          l      l    ----  l       ______    ____   l\    /l   ____                                                
;          l      l   l      l      l         l    l  l \ /  l  l                                          
;          l  / \ l   l---   l      l         l    l  l      l  l---                                              
;          l/    \l   l____  l____  l______   l____l  l      l  l____                                                          
;                                                                                           
;                                                                                           
;===========================================================================================

main PROC

      ; macro 
     ; change_color 1,1,SNAKEHUNYAAR,SNAKEandSONS,1,11 

	  reagaingame::
    ;for start the game with right side movement
	mov bl,"d"
	;=========================================================================
	;                    wall.asm
	;  this procedure use to draw a boarder of (#) by using
	;   xposwall and yposwall position
	;
	;=========================================================================
	INVOKE DrawWall,ADDR xPosWall ,ADDR yPosWall
	;=========================================================================
	;                          scoreboard.asm
	;   this procedure use to draw scoreboard without passing anything
	;     
	;
	;=========================================================================
	INVOKE DrawScoreboard		
   
	mov dl,77				
	mov dh,1
	call Gotoxy	  ; move the cursor to the x,y position
	call waitmsg  ; to pause screen

	;=========================================================================
	;                         drawsnake.asm
	;  this procedure use to draw a snake
	;   using x & y coordinates , counter, and array of body
	;                                 FOR S
	;=========================================================================
	
	INVOKE DrawPlayer, ADDR xPos, ADDR yPos, 5, ADDR snake			
	


	; for random position of coin
	call Randomize
	
	;=========================================================================
	;                         coin.asm
	;  this procedure use to generates random x&Y coordinates
	;  	of coin with in the wall
	;
	;=========================================================================
	 INVOKE CreateRandomCoin, ADDR xPos, ADDR yPos, ADDR xCoinPos, ADDR yCoinPos, score
	;=========================================================================
	;                         coin.asm
	;  this procedure use to generates the coin with in the wall
	;
	;=========================================================================
	INVOKE DrawCoin,	xCoinPos, YCoinPos	

	;=========================================================================
	;                         coin.asm
	;  this procedure is used to intialize random snake coordinates
	;  	and this function also initialize randomsnakechar
	;
	;=========================================================================
	INVOKE	RandomSnake, ADDR xPos2, ADDR yPos2, xCoinPos, yCoinPos ,ADDR randomSnakeChar
;=========================================================================
	;                         drawsnake.asm
	;  this procedure use to draw a snake
	;   using x & y coordinates , counter, and array of body
	;                         FOR RS
	;=========================================================================
	
	INVOKE DrawPlayer, ADDR xPos2, ADDR yPos2, 5, ADDR snake2	
	
	;set up finish
	
	gameLoop::
		mov dl,106						
		mov dh,1
		call Gotoxy
		
		; get user key input
		call ReadKey             ;ah = key scan code and al= key ascii code
        
		;jump if no key is entered
		jz noKey				
		processInput:
		mov bl, inputChar
		mov lastInputChar, bl
		mov inputChar,al				

		noKey:
		cmp inputChar,"x"	
		je exitgame						;emergency game exit

		cmp inputChar,"w"
		je checkTop

		cmp inputChar,"s"
		je checkBottom

		cmp inputChar,"a"
		je checkLeft

		cmp inputChar,"d"
		je checkRight
		jne dontChgDirection	
		
		mov eax,0
		; check whether can continue moving
		checkBottom:	
		cmp lastInputChar, "w"
		je dontChgDirection		;can not go down
		mov cl, yPosWall[1]
		dec cl					;check weather player might hit the wall
		cmp yPos[0],cl
		jl moveDown
		je died					

		checkLeft:		
		cmp lastInputChar, "+"	;in start player only move right
		je dontGoLeft
		cmp lastInputChar, "d"    
		je dontChgDirection           ;can not go left
		mov cl, xPosWall[0]
		inc cl                          ;check weather player might hit the wall
		cmp xPos[0],cl
		jg moveLeft
		je died					

		checkRight:		
		cmp lastInputChar, "a"
		je dontChgDirection            ;can not go right
		mov cl, xPosWall[2]
		dec cl
		cmp xPos[0],cl               ;check weather player might hit the wall
		jl moveRight
		je died						

		checkTop:		
		cmp lastInputChar, "s"
		je dontChgDirection             ;can not go up
		mov cl, yPosWall[0]
		inc cl
		cmp yPos,cl                       ;check weather player might hit the wall
		jg moveUp
		je died	
		
		mov eax,0

		moveUp:		
		mov eax, speed
		add eax, speed
		call delay		;slow down the moving

		mov esi, 0			;index 0
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR RS
		;=========================================================================
	    push eax			
		INVOKE UpdatePlayer, ADDR xPos[ESI], ADDR yPos[ESI]
		pop eax 
	
	     ;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR RS
		;=========================================================================
	     push eax ;
		INVOKE UpdatePlayer, ADDR xPos2[ESI], ADDR yPos2[ESI]		
		 pop eax 

		mov ah, yPos[esi]	
		mov al, xPos[esi]	;alah stores the pos of the snake's next unit 

		mov dh, yPos2[esi]	
		mov dl, xPos2[esi]	;alah stores the pos of the snake's next unit 
		cmp randomSnakechar,"d"
		jz Rightmove1
		dec xPos2[esi]
		jmp leftmove1
		Rightmove1:
		inc xPos2[esi]
		leftmove1:

		dec yPos[esi]		;move the head up

		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                                 FOR S
        ;========================================================================= 
		push eax
		INVOKE DrawPlayer, ADDR xPos[ESI], ADDR yPos[ESI], 1, ADDR snake[ESI]
		pop eax
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                                 FOR RS
		;=========================================================================
		push eax
		INVOKE DrawPlayer, ADDR xPos2[ESI], ADDR yPos2[ESI], 1, ADDR snake2[ESI]
		pop eax

		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR S
		;=========================================================================
		INVOKE DrawBody, ADDR xPos, ADDR yPos, score,ADDR snake, EAX
		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR RS
		;=========================================================================
		INVOKE DrawBody, ADDR xPos2, ADDR yPos2,0,ADDR snake2, EDX
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with its own body or not
        ;                           FOR S
		;=========================================================================
		INVOKE CheckSnake, ADDR xPos, ADDR yPos, score
		jz died
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with random snake or not
        ;                           
		;=========================================================================
		INVOKE CheckSnake2, ADDR xPos, ADDR yPos, ADDR xPos2,ADDR yPos2, score
		jz died
		JNZ checkcoin

		
		moveDown:			;move down
		mov eax, speed
		add eax, speed
		call delay
		mov esi, 0
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR S
		;=========================================================================
	    push eax  
		INVOKE UpdatePlayer, ADDR xPos[ESI], ADDR yPos[ESI]		
		pop eax 
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR RS
		;=========================================================================
		 push eax 
		INVOKE UpdatePlayer, ADDR xPos2[ESI], ADDR yPos2[ESI]		
		pop eax 

		mov ah, yPos[esi]	
		mov al, xPos[esi]	;alah stores the pos of the snake's next unit 

		mov dh, yPos2[esi]	
		mov dl, xPos2[esi]	;alah stores the pos of the snake's next unit 
		cmp randomSnakechar,"d"
		jz Rightmove2
		dec xPos2[esi]
		jmp leftmove2
		Rightmove2:
		inc xPos2[esi]
		leftmove2:
		    
		inc yPos[esi]

		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                                 FOR S
		;=========================================================================
		push eax
		INVOKE DrawPlayer, ADDR xPos[ESI], ADDR yPos[ESI], 1, ADDR snake[ESI]
		pop eax
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                                 FOR RS
		;=========================================================================
		push eax
		INVOKE DrawPlayer, ADDR xPos2[ESI], ADDR yPos2[ESI], 1, ADDR snake2[ESI]
		pop eax
		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR S
		;=========================================================================
		INVOKE DrawBody, ADDR xPos, ADDR yPos, score,ADDR snake, EAX
		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR RS
		;=========================================================================
		INVOKE DrawBody, ADDR xPos2, ADDR yPos2,0,ADDR snake2, EDX
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with its own body or not
        ;                           FOR S
		;=========================================================================
		INVOKE CheckSnake, ADDR xPos, ADDR yPos, score
		jz died
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with random snake or not
        ;                           
		;=========================================================================
		INVOKE CheckSnake2, ADDR xPos, ADDR yPos, ADDR xPos2,ADDR yPos2, score
		jz died
		JNZ checkcoin


		moveLeft:			;move left
		mov eax, speed
		call delay
		mov esi, 0
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR S
		;=========================================================================
	    push eax 
		INVOKE UpdatePlayer, ADDR xPos[ESI], ADDR yPos[ESI]
		pop eax 

		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR RS
		;=========================================================================
		 push eax 
		INVOKE UpdatePlayer, ADDR xPos2[ESI], ADDR yPos2[ESI]		
		pop eax 

	    mov ah, yPos[esi]	
		mov al, xPos[esi]	;alah stores the pos of the snake's next unit 

		mov dh, yPos2[esi]	
		mov dl, xPos2[esi]	;alah stores the pos of the snake's next unit 
		cmp randomSnakechar,"d"
		jz Rightmove3
		dec xPos2[esi]
		jmp leftmove3
		Rightmove3:
		inc xPos2[esi]
		leftmove3:

		dec xPos[esi]
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                                 FOR S
		;=========================================================================
		push eax
		INVOKE DrawPlayer, ADDR xPos[ESI], ADDR yPos[ESI], 1, ADDR snake[ESI]
		pop eax
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                                 FOR RS
		;=========================================================================
		push eax
		INVOKE DrawPlayer, ADDR xPos2[ESI], ADDR yPos2[ESI], 1, ADDR snake2[ESI]
		pop eax
		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR S
		;=========================================================================
		INVOKE DrawBody, ADDR xPos, ADDR yPos, score,ADDR snake, EAX
		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR RS
		;=========================================================================
		INVOKE DrawBody, ADDR xPos2, ADDR yPos2, 0,ADDR snake2, EDX
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with its own body or not
        ;                           FOR S
		;=========================================================================
		INVOKE CheckSnake, ADDR xPos, ADDR yPos, score
		jz died
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with random snake or not
        ;                           
		;=========================================================================
		INVOKE CheckSnake2, ADDR xPos, ADDR yPos, ADDR xPos2,ADDR yPos2, score
		jz died
		JNZ checkcoin


		moveRight:			;move right
		mov eax, speed
		call delay
		mov esi, 0

		push eax 
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR S
		;=========================================================================
		INVOKE UpdatePlayer, ADDR xPos[ESI], ADDR yPos[ESI]
		pop eax 

		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a update snake single position with space
        ;   
        ;                           FOR RS
		;=========================================================================
		 push eax 
		INVOKE UpdatePlayer, ADDR xPos2[ESI], ADDR yPos2[ESI]		
		pop eax 


		mov ah, yPos[esi]	
		mov al, xPos[esi]	;al,ah stores the pos of the snake's next unit 

		mov dh, yPos2[esi]	
		mov dl, xPos2[esi]	;dl,dh stores the pos of the random snake's next unit 
		cmp randomSnakechar,"d"
		jz Rightmove4
		dec xPos2[esi]
		jmp leftmove4
		Rightmove4:
		inc xPos2[esi]
		leftmove4:
		inc xPos[esi]
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                             FOR S
		;=========================================================================
		push eax
		INVOKE DrawPlayer, ADDR xPos[ESI], ADDR yPos[ESI], 1, ADDR snake[ESI]
		pop eax
		;=========================================================================
        ;                         drawsnake.asm
        ;  this procedure use to draw a snake
        ;   using x & y coordinates , counter, and array of body
        ;                                FOR RS
		;=========================================================================
		push eax
		INVOKE DrawPlayer, ADDR xPos2[ESI], ADDR yPos2[ESI], 1, ADDR snake2[ESI]
		pop eax
		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR S
		;=========================================================================
		INVOKE DrawBody, ADDR xPos, ADDR yPos, score,ADDR snake, EAX
		;=========================================================================
        ;                         draw_body.asm
        ;  this procedure use to update (swap) the coordinates of snake
        ;   
        ;                           FOR RS
		;=========================================================================
		INVOKE DrawBody, ADDR xPos2, ADDR yPos2, 0,ADDR snake2, EdX
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with its own body or not
        ;                           FOR S
		;=========================================================================
		INVOKE CheckSnake, ADDR xPos, ADDR yPos, score
		jz died
		;=========================================================================
        ;                         checksnake.asm
        ;  this procedure check that, is the snake is collide
        ;   with random snake or not
        ;                           
		;=========================================================================
		INVOKE CheckSnake2, ADDR xPos, ADDR yPos, ADDR xPos2,ADDR yPos2, score
		jz died
		JNZ checkcoin

	; getting points
		checkcoin::
		mov esi,0

		mov bl,xPos2[0]
		cmp bl,xCoinPos
		jne checkOriginalSnake 
		;=========================================================================
       ;                         drawsnake.asm
	   ;  this procedure use to draw a snake
	   ;   using x & y coordinates , counter, and array of body
	   ;                            FOR RS
       ;=========================================================================
	   INVOKE DrawPlayer, ADDR xPos2, ADDR yPos2, 5, ADDR blank
		INVOKE CreateRandomCoin, ADDR xPos, ADDR yPos, ADDR xCoinPos, ADDR yCoinPos, score
	    INVOKE DrawCoin,	xCoinPos, YCoinPos	

	   ;second random snake
	   INVOKE	RandomSnake, ADDR xPos2, ADDR yPos2, xCoinPos, yCoinPos ,ADDR randomSnakeChar
	   ;=========================================================================
       ;                         drawsnake.asm
	   ;  this procedure use to draw a snake
	   ;   using x & y coordinates , counter, and array of body
	   ;                            FOR RS
       ;=========================================================================
	   INVOKE DrawPlayer, ADDR xPos2, ADDR yPos2, 5, ADDR snake2
		jmp gameloop

		
		checkOriginalSnake:
		mov bl,xPos[0]
		cmp bl,xCoinPos
		jne gameloop			;reloop if snake is not intersecting with coin
		mov bl,yPos[0]
		cmp bl,yCoinPos
		jne gameloop			;reloop if snake is not intersecting with coin
		;=========================================================================
       ;                         eatingcoin.asm
	   ;  this procedure is used when snake ate a coin it increase in unit in tail
	   ;   
	   ;                            FOR RS
       ;=========================================================================
		INVOKE EatingCoin, ADDR xPos, ADDR yPos, ADDR xCoinPos, ADDR yCoinPos,score, ADDR snake			;call to update score, append snake and generate new coin	
		INC score
		INVOKE DrawPlayer, ADDR xPos2, ADDR yPos2, 5, ADDR blank
		  INVOKE RandomSnake, ADDR xPos2, ADDR yPos2, xCoinPos, yCoinPos ,ADDR randomSnakeChar
	   INVOKE DrawPlayer, ADDR xPos2, ADDR yPos2, 5, ADDR snake2
jmp gameLoop					


	dontChgDirection:		;dont allow user to change direction
	mov inputChar, bl		;set current inputChar as previous
	jmp noKey				

	dontGoLeft:				;stop the snake to go left at the begining of the game
	mov	inputChar, "+"		;set current inputChar as "+"
	jmp gameLoop			

	died::
	call YouDied
	 
	playagn::			
	call ReinitializeGame			
	
	exitgame::
	exit
INVOKE ExitProcess,0
main ENDP



YouDied PROC
	mov eax, 1000
	call delay
	Call ClrScr	

	mov dl,	56
	mov dh, 5
	call Gotoxy
	mov edx, OFFSET strPoints	;display score
	call WriteString
	movzx eax, score
	call Writedec

	call crlf
	call crlf

	mov eax,0
	mov ebx,OFFSET caption
    mov edx,OFFSET question
    call MsgBoxask

	cmp eax,IDYES
	je playagn
	jne exitgame

							
YouDied ENDP

ReinitializeGame PROC		
	
	;reinitialize snake position
	mov xPos[0], 32
	mov xPos[1], 31
	mov xPos[2], 30
	mov xPos[3], 29
	mov xPos[4], 28
	mov yPos[0], 15
	mov yPos[1], 15
	mov yPos[2], 15
	mov yPos[3], 15
	mov yPos[4], 15			

				

	mov score,0				;reinitialize score
	


	mov lastInputChar, 0
	mov	inputChar, "+"			;reinitialize inputChar and lastInputChar

	
	

	Call ClrScr
	jmp reagaingame				;start over the game
ReinitializeGame ENDP

END main