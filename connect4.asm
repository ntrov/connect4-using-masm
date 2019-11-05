include irvine16.inc

.data
	string1 byte '-'
	Board byte 7 dup('-')
	      byte 7 dup('-')
	      byte 7 dup('-')
	      byte 7 dup('-')
	      byte 7 dup('-')
	      byte 7 dup('-')
	      byte ?
	GameFinished byte 0
	player byte ' '
	space byte ' '
	Connect4 byte "Connect 4", "$"
	ColumnNumber byte 0
	valid byte 0
	row byte 0
	ValidColumn byte 0
	ValidRow byte 0
	WinnerFound byte 0
	BlankFound byte 0
	RowNUmber byte 0
	Numbercolumn byte 0
	NumberRow byte 0
	drawFlag byte 0
	outfile BYTE "my_input_output_file.txt",0
	inHandle WORD ?
	outHandle WORD ?
	new1 byte "N = New Game", "$"
	load1 byte "L = Load Game", "$"
	cPlayer byte 0
	colNumbers byte "0  1  2  3  4  5  6", "$"
	saveAndQuit byte "Q = Save And Quit", "$"
	yellowTurn byte "Yellow Player Turn", "$"
	redTurn byte "Red Player Turn", "$"
	yellowWinner byte "Yellow Player Wins", "$"
	redWinner byte "Red Player Wins", "$"
	Draw byte "Game is Draw","$"
	restart byte "R = Restart Game", "$"
	Quit1 byte "Q = Quit", "$"
	invalidInput byte "Invalid Input!!", "$"
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;graphics;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	currentX word 150
	currentY word 40
	color byte 1
	LineLength word 140
	colPixel word 151, 175, 199, 223, 247, 271, 295
	rowPixel word 41, 65, 89, 113, 137, 161


.code
	SetUpgame proc
		
		mov al, cplayer
		cmp al, 1
		jnz next
		mov bl, Board[42]
		mov player, bl 
		jmp next1
		next:
		mov player , 'T'
		next1:
		mov GameFinished , 0
		ret
	SetUpgame endp
	
	grid proc
	
			;;;;;;;;;;;;;;;;;;SETS POS for Cursor;;;;;;;;;;;;;;;;;
		mov ah, 2
		mov dh, 1
		mov dl, 15
		mov bh, 0
		int 10h
		
		mov ah, 09h  ;;;;;;;;;;;;;;;; Prints Connect 4;;;;;;;;;;;
		mov dx, offset Connect4
		int 21h
		
		mov ah, 2
		mov dh, 4
		mov dl, 20
		mov bh, 0
		int 10h
		
		mov ah, 09h ;;;;;;;;;;;;;;;;Prints Column numbers
		mov dx, offset colNumbers
		int 21h
		
		mov ah, 2
		mov dh, 6
		mov dl, 0
		mov bh, 0
		int 10h
		.if gameFinished == 0
			mov ah, 09h
			mov dx, offset saveAndQuit
			int 21h
		.else
			mov ah, 09h
			mov dx, offset Quit1
			int 21h
		.endif
		mov color, 100
		
		mov ax, 40
		mov currentY, ax
		mov ax, 150
		mov currentX, ax
		mov ax, 168
		mov LineLength, ax

		mov cx, 7
		L2:
	      		push cx
	       		mov cx, LineLength
			L1:
				push cx
	       			mov dx, currentY
	       			mov ah, 0ch ;;;;;;;;write Pixel
	       			mov al, color
	       			mov bh, 0
	       			mov cx, currentX
	       			int 10h
	       			inc currentX
	       			pop cx
	       		loop L1
	       		
	       		add currentY, 24
	       		mov ax, 150
	       		mov currentX, ax
	       	
	       		pop cx
	    	loop L2
	       	
	       	
	    mov ax, 40
		mov currentY, ax
		mov ax, 150
		mov currentX, ax
		mov ax, 145
		mov LineLength, ax
	    
	    mov cx, 8
		L3:
		  	push cx
		   	mov cx, LineLength
			L4:
				push cx
				mov dx, currentY
				mov ah, 0ch
				mov al, color
				mov bh, 0
				mov cx, currentX
				int 10h
				inc currentY
				pop cx
			loop L4
		      		
			add currentX, 24
			mov ax, 40
			mov currentY, ax
		       		
			pop cx
	    	loop L3   	
	    ret
	grid endp
	
	drawCross proc
		xor eax,eax
		xor ebx,ebx
		xor ecx,ecx
		xor edx,edx
		
		mov ax, rowPixel[esi]
		mov currentY, ax
		mov ax, colPixel[edi]
		mov currentX, ax
		
		mov cx, 23
		xor eax,eax
		L5:
			push cx
			mov ah, 0ch
			mov al, color
			mov bh, 0
			mov cx, currentX
			mov dx, currentY
			int 10h
			inc currentX
			inc currentY
			pop cx
		loop L5
	
		mov ax, rowPixel[esi]
		mov currentY, ax
		mov ax, colPixel[edi]
		mov currentX, ax
		add currentX, 22

		mov cx, 23
		xor eax,eax
		L6:
			push cx
			mov ah, 0ch
			mov al, color
			mov bh, 0
			mov cx, currentX
			mov dx, currentY
			int 10h
			dec currentX
			inc currentY
			pop cx
		loop L6
	
		ret
	drawCross endp
	
	status proc
		mov ah, 2
		mov dh, 15
		mov dl, 0
		mov bh, 0
		int 10h
		.if drawFlag == 1			
			mov ah, 09h
			mov dx, offset draw
			int 21h
			jmp last
		.endif
		
		.if player == 'T'
			.if gameFinished == 1
				mov ah, 09h
				mov dx, offset yellowWinner
				int 21h
			.else
				mov ah, 09h
				mov dx, offset yellowTurn
				int 21h
				
			.endif
			jmp last	
		.endif
		
		.if player == 'M'
			.if gameFinished == 1
				mov ah, 09h
				mov dx, offset RedWinner
				int 21h
			.else
				mov ah, 09h
				mov dx, offset redTurn
				int 21h
				
			.endif
			jmp last	
		.endif
		last:
		ret
	status endp
	Outputboard proc
		mov ah, 0  ;;set video mode
		mov al, 13h
    	int 10h
    	
    	mov ax, 004Fh  ;;enable mouse
		int 33h

	    mov ax, 0001h  ;;show mouse
		int 33h
    	
    	call grid
    	call status
		xor eax,eax
		xor edi , edi
		xor esi,esi
		xor ecx,ecx
		mov esi, 35
		mov edi, 0
		mov ecx, 6
		.while ecx != 0
			push ecx
			xor edi,edi
			mov ecx, 7
			.while ecx != 0
				xor eax,eax
				mov al, Board[esi+edi]
				.if al == 'T'
					pushad
					
					mov al, 14
					mov color, al
					
					;;;;;;;;;;;;;;;SET ROW
					.if esi == 0
						mov esi, 10
						jmp last
					.endif
					.if esi == 7
						mov esi, 8
						jmp last
					.endif
					.if esi == 14
						mov esi, 6
						jmp last
					.endif
					.if esi == 21
						mov esi, 4
						jmp last
					.endif
					.if esi == 28
						mov esi, 2
						jmp last
					.endif
					.if esi == 35
						mov esi, 0
						jmp last
					.endif
					
					last:
					;;;;;;;;;;;;;;;;SET COL
					
					.if edi == 0
						mov edi, 0
						jmp last1
					.endif
					.if edi == 1
						mov edi, 2
						jmp last1
					.endif
					.if edi == 2
						mov edi, 4
						jmp last1
					.endif
					.if edi == 3
						mov edi, 6
						jmp last1
					.endif
					.if edi == 4
						mov edi, 8
						jmp last1
					.endif
					.if edi == 5
						mov edi, 10
						jmp last1
					.endif
					.if edi == 6
						mov edi, 12
						jmp last1
					.endif
					
					last1:
					call drawCross
					popad
				.endif
				
				xor eax,eax
				mov al, Board[esi+edi]
				.if al == 'M'
					pushad
					
					mov al, 4
					mov color, al
					
					;;;;;;;;;;;;;;;SET ROW						
					.if esi == 0
						mov esi, 10
						jmp last2
					.endif
					
					.if esi == 7
						mov esi, 8
						jmp last2
					.endif
					
					.if esi == 14
						mov esi, 6
						jmp last2
					.endif
					.if esi == 21
						mov esi, 4
						jmp last2
					.endif
					.if esi == 28
						mov esi, 2
						jmp last2
					.endif
					.if esi == 35
						mov esi, 0
						jmp last2
					.endif					
					
					last2:
					;;;;;;;;;;;;;;;;SET COL
										
					.if edi == 0
						mov edi, 0
						jmp last3
					.endif
					.if edi == 1
						mov edi, 2
						jmp last3
					.endif
					.if edi == 2
						mov edi, 4
						jmp last3
					.endif
					.if edi == 3
						mov edi, 6
						jmp last3
					.endif
					.if edi == 4
						mov edi, 8
						jmp last3
					.endif
					.if edi == 5
						mov edi, 10
						jmp last3
					.endif
					.if edi == 6
						mov edi, 12
						jmp last3
					.endif	
					last3:
				
					call drawCross					
					popad	
				.endif
				inc edi
				dec ecx
			.endW
			call crlf
			sub esi, 7
			pop ecx
			dec ecx
		.endw
		ret
	Outputboard endp
	
	
	playerMakesmove proc
		xor eax,eax
		call PlayerChoosesColumn
		mov al,ColumnNumber
		mov ValidColumn, al
		call NextFreePositionInColumn
		mov al, row
		mov ValidRow, al
		xor eax,eax
		xor ebx,ebx
		xor ecx,ecx
		mov al, 7
		mov cl,ColumnNumber
		mul ValidRow
		mov bl,player
		mov Board[eax+ecx], bl
		ret
	playerMakesmove endp
	
	
	CheckPlayerHasWon proc
		xor esi,esi
		movzx esi, WinnerFound
		.if esi == 0
			call CheckDiagonalRowAndColumn
		.endif
		xor esi,esi
		movzx esi, WinnerFound
		.if esi == 0
			call CheckHorizontalLineValidRow
		.endif
		xor esi,esi
		movzx esi, WinnerFound
		.if esi == 0
			call CheckVerticalLineValidColumn
		.endif
		xor esi,esi
		movzx esi, WinnerFound
		.if esi == 1
			xor eax,eax
			mov al, player
			call writechar
			mov GameFinished, 1
		.else
			call CheckFullBoard
		
		.endif
		ret
	CheckPlayerHasWon endp
	
	
	CheckFullBoard proc
		mov BlankFound, 0
		xor esi,esi
		xor edi,edi
		xor eax, eax
		.while esi != 42
			.if Board[esi] == '-'
				mov BlankFound, 1
			.endif
			inc esi
		.endw
		
		.if BlankFound == 0
			mov drawFlag, 1
			mov GameFinished, 1
		.endif
		ret
	CheckFullBoard endp
	
	CheckHorizontalLineValidRow proc
		xor eax,eax
		xor edi,edi
		xor esi,esi
		xor ebx,ebx
		mov esi, 7
		mov al, ValidRow
		mul esi
		
		.while edi != 4
			mov bl, player
			.if Board[eax+edi] == bl  && Board[eax+edi+1] == bl && Board[eax+edi+2] == bl && Board[eax+edi+3] == bl
				mov WinnerFound, 1
			.endif
			inc edi
		.endw
		ret
	CheckHorizontalLineValidRow endp
	
	CheckVerticalLineValidColumn proc
		xor eax,eax
		mov esi, 7
		mov al, ValidRow
		mul esi
		xor esi,esi
		movzx esi,ValidColumn
		.if eax >= 21 && eax <= 41
			xor ebx,ebx
			mov bl, player
			.if Board[eax+esi] == bl && Board[(eax-7)+esi] == bl && Board[(eax-14)+esi] == bl && Board[(eax-21)+esi] == bl
				mov winnerFound, 1			
			.endif			
		.endif
		ret		
	CheckVerticalLineValidColumn endp
	
	
	SwapPlayer PROC
		xor eax, eax
		mov al , player
		cmp al , 'T'
		jne next
		xor eax,eax
		mov al , 'M'
		mov Player,al
		jmp next1
		next:
		xor eax,eax
		mov al , 'T'
		mov Player , al
		next1:
		ret
	SwapPlayer ENDP
	
	PlayerChoosesColumn proc
		xor eax,eax
		mov al, Player
		xor ecx,ecx
		xor eax,eax
		dowhile:
			mov ah, 0
    		int 16h
    		.if al == 'q' || al == 'Q'
    			call saveFunction
    			
    			mov ah, 4ch ;;; Terminate program
				int 21h
    		.endif
    		and al, 11001111b ;;; convert asci to numbers
			mov ColumnNumber, al
			call columnNumberValid
			xor eax,eax
			mov al, Valid
			cmp al, 1
			jz next
		Loop dowhile
		next:
		ret
	PlayerChoosesColumn endp

	ColumnNumberValid proc
		xor eax,eax
		xor esi,esi
		mov esi, 35
		mov al, ColumnNumber
		mov valid, 0
		xor ebx,ebx
		mov bl, valid
		.if ColumnNumber >= 0 && ColumnNumber <= 6
			.if Board[esi+eax] == '-'
			  mov valid, 1
			.endif
			
		.else
			.if valid == 0
				mov ah, 2
				mov dh, 18
				mov dl, 0
				mov bh, 0
				int 10h	
				mov ah, 09h
				mov dx, offset invalidInput
				int 21h
			.endif
		.endif
		ret
	ColumnNumberValid endp



	NextFreePositionInColumn proc
		mov row , 0
		xor eax,eax
		xor esi,esi
		xor edi,edi
		movzx esi, row
		movzx edi, ValidColumn
		.While Board[esi + edi] != '-'
			mov al, Board[esi + edi]
			cmp al, '-'
			jz next
			inc row
			add esi, 7
		.ENDW
		next:
		ret
	NextFreePositionInColumn endp


CheckDiagonalRowAndColumn proc
	xor esi , esi
	xor edi , edi
	xor ebx, ebx
	mov ecx , 4
	L1:
		push ecx
		mov edi, esi
		mov bl, player
		mov ecx, 3
		l2:
			.if (Board[edi] == bl) && (Board[edi+8] == bl) && (Board[edi+16] == bl) && (Board[edi+24] == bl)
				mov winnerfound, 1
			.ENDIF
			add edi, 7
		loop l2
		inc esi
		pop ecx
	loop L1
	
	xor esi , esi
	xor edi , edi
	xor ebx, ebx
	mov esi, 21
	mov ecx , 4
	L3:
		push ecx
		mov edi, esi
		mov bl, player
		mov ecx, 3
		l4:
			.if (Board[edi] == bl) && (Board[edi-6] == bl) && (Board[edi-12] == bl) && (Board[edi-18] == bl)
				mov winnerfound, 1
			.ENDIF
			add edi, 7
		loop l4
		inc esi
		pop ecx
	loop L3
	ret
CheckDiagonalRowAndColumn endp

resetFuncton proc
	mov ValidColumn, 0
	mov ValidRow, 0
	mov WinnerFound, 0
	mov BlankFound, 0
	mov RowNUmber, 0
	mov Numbercolumn, 0
	mov NumberRow , 0
	mov gameFinished ,0
	mov drawFlag, 0
	mov ecx, 42
	clean:
		mov board[esi], '-'
		inc esi
	loop clean
	xor esi,esi
	ret
resetFuncton endp

saveFunction proc
	xor ebx, ebx
	mov bl, player
	mov Board[42], bl
	mov ax,716Ch ; extended create or open
	mov bx,1 ; mode = write-only
	mov cx,0 ; normal attribute
	mov dx,12h ; action: create/truncate
	mov si,OFFSET outfile
	int 21h ; call MS-DOS
	jc quit ; quit if error
	mov outHandle,ax ; save handle
	; Write buffer to new file
	mov ah,40h ; write file or device
	mov bx,outHandle ; output file handle
	mov cx,43 ; number of bytes
	mov dx,OFFSET Board ; buffer pointer
	int 21h
	jc quit ; quit if error
	; Close the file
	mov ah,3Eh ; function: close file
	mov bx,outHandle ; output file handle
	int 21h ; call MS-DOS
	quit:
	call Crlf		
	ret
saveFunction endp

loadFunction proc
	mov ax,716Ch  ;extended create or open
	mov bx,0  ;mode = read-only
	mov cx,0  ;normal attribute
	mov dx,1  ;action: open
	mov si,OFFSET outfile
	int 21h  ;call MS-DOS
	jc quit  ;quit if error
		
	mov inHandle,ax 
	; Read the input file
	mov ah,3Fh ; read file or device
	mov bx,inHandle ; file handle
	mov cx,43 ; max bytes to read
	mov dx,OFFSET board ; buffer pointer
	int 21h
	jc quit ; quit if error
	; Close the file
	mov ah,3Eh ; function: close file
	mov bx,inHandle ; input file handle
	int 21h ; call MS-DOS
	
	jc quit ; quit if error
	quit:
	call crlf
	ret
loadFunction endp

main proc
	mov ax, @data
	mov ds, ax
	
	mov ah, 0
	mov al, 13h ;;; sets video mode
    int 10h
    
    mov ax, 004Fh ;;; enable mouse
	int 33h
	
    mov ax, 0001h ;;; shows mouse
	int 33h
    
    mov ah, 2
	mov dh, 5
	mov dl, 15
	mov bh, 0
	int 10h

	mov ah, 09h
	mov dx, offset new1 ;;; print string
	int 21h
	
	mov ah, 2
	mov dh, 10
	mov dl, 15
	mov bh, 0
	int 10h
				
	mov ah, 09h
	mov dx, offset load1
	int 21h
    
    
    redo:
    
    mov ah, 0 ;;;; take input
    int 16h
    	
	.if al == 'l' || al == 'L'
		call loadFunction
		mov cplayer, 1
		jmp next1
	.endif
	.if al == 'n' || al == 'N'
		jmp start1
	.endif
	
	mov ah, 2
	mov dh, 18
	mov dl, 0
	mov bh, 0
	int 10h
	
	mov ah, 09h
	mov dx, offset invalidInput
	int 21h

	jmp redo
	
	start1:
	xor eax , eax
	xor ebx , ebx
	xor ecx , ecx
	xor edx , edx
	xor esi , esi
	xor edi , edi
	call resetFuncton
	next1:
	call SetUPGame
	call Outputboard
	.while gameFinished == 0
		call PlayerMakesMove
		call CheckPlayerHasWon
		.if gamefinished == 0
		call SwapPlayer
		.endif
		call Outputboard
	.endW
	call Outputboard
	mov ah, 2
	mov dh, 10
	mov dl, 0
	mov bh, 0
	int 10h
					
	mov ah, 09h
	mov dx, offset restart
	int 21h
	
	
	re_enter:
	mov ah, 0
    int 16h
	.if al == 'r' || al == 'R'
		jmp start1
	.endif
	.if al == 'q' || al == 'Q'
		mov ah, 4ch
		int 21h
	.endif
	
	mov ah, 2
	mov dh, 18
	mov dl, 0
	mov bh, 0
	int 10h
	
	mov ah, 09h
	mov dx, offset invalidInput
	int 21h
	
	jmp re_enter
	
main endp
end main