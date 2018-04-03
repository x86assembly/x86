INCLUDE link.inc				; Last update: 4.3.2018
include macros.inc

; All source code starting with chapter 9 must include link.inc
; and x86lib.asm in project

; link.inc   contains a prototype for each procedure
; x86lib.asm   contains defined procedures and includes irvine32.inc


; INSTRUCTIONS



; 1. save link.inc to your project folder & import x86lib.asm to your project

;    	click "View" in visual studios
;		click "Solution Explorer"
;		right-click "Project" in solution explorer
;		click "Add"
;		click "Existing item"
;       click "x86lib.asm"

;		x86lib.asm should be displayed in solution explorer
;       add include link.inc directive in asm file








; Procedures defined

; 1. displayString
; 2. getArray
; 3. displayResult
; 4. get3Values
; 5. primeArray
; 6. multiplyArrayByte
; 7. getString
; 8. displayFileContents
; 9. dumpascii
; 10. displayascii
; 11. displayAsciiMatrix		currently not functional
; 12. drawrow
; 13. writesquares
; 14. writesquare
; 15. drawcheckers
; 16. loadFile
; 17. asciiMatrix				currently not functional
; 18. randomArray
; 19. randomchar
; 20. goto00
; 21. bubbleSort
; 22. binarySearch				 currently not functional
; 23. rollingtext
; 24. displayAsciiLine
; 25. rollingTextBackwards
; 26. xorbuffer
; 27. compareArraysd
; 28. findCharInW
; 29. showIndexOfCharInW
; 30. displayLargerString
; 31. str_lcase
; 32. display2DElementDword
; 33. str_copyN
; 34. str_concat

.code



; 1

displayString proc uses edx ptrmsg:ptr dword
	
	mov edx, ptrmsg
	call writeString
	;call crlf
ret
displayString endp





; 2
getArray proc uses edx eax ecx esi, pa:ptr dword,   la1:dword
	.data
	msg byte " integer array: ", 0
	string byte 21 dup (0)

	.code
	mov esi, 0 ; for string

	mov edi, pa
	mov eax, la1
	call writeDec

	mov edx, offset msg
	call writeString

	mov ecx, la1
	mov esi, 0
	mov eax, 0

comment !
	; This commented out code is simpler, but will not display
	; the array on the same line, readDec automatically prints
    ; a cr line feed after each value, which would be less appealing to the user.
	; The code after this code is all there in order to display 
	; the array on the same line

l1: call readDec
	mov [edi], eax
	add edi, 4
	loop l1
	
		!  ; end of comment block

l1: call readchar
	cmp al, 0dh
	je nx
	mov string[esi], al
	call writechar
	inc esi
	jmp l1
nx:
	mov al, ','
	cmp ecx, 1
	je ov
	call writechar
ov: mov edx, offset string
	push ecx
	mov ecx, lengthof string
	pop ecx
	call parsedecimal32
	mov [edi], eax
	add edi, 4

	; reset string
	push ecx
	mov esi, 0
	mov ecx, lengthof string
l2: mov string[esi], 0
	inc esi
	loop l2

	mov esi, 0
	pop ecx
	loop l1
	
call crlf
ret
getArray endp







; 3

displayResult proc private uses edx val1:dword
	
	.data
	msg1 byte "Result: ",0
	
	.code
	
	mov edx, offset msg1
	call writeString

	mov eax, val1
	call writeDec
	call crlf

ret
displayResult endp















; 4


 get3Values proc private v111:ptr dword, v222:ptr dword, v333:ptr dword

	.data

	msg11 byte "Val 1: ", 0
	msg21 byte "Val 2: ", 0
	msg31 byte "Val 3: ", 0

	.code
	
	call crlf
	
	mov edx, offset msg11
	call writeString
		
	call readInt
	mov esi, v111
	mov [esi], eax

	mov edx, offset msg21
	call writeString
	
	call readInt
	mov esi, v222
	mov [esi], eax


	mov edx, offset msg31
	call writeString
	
	call readInt
	mov esi, v333
	mov [esi], eax
		
ret
get3Values endp





; 5


primeArray proc uses ecx edi eax ptrarray:ptr dword, lengtha:dword, val:byte

	mov edi, ptrarray
	mov ecx, lengtha
	mov al, val
	cld
	rep stosb
ret
primeArray endp






; 6



multiplyArrayByte proc uses eax esi edi ptrarray:ptr byte, lengtha:dword, mult:byte
	
	mov esi, ptrarray
	mov edi, esi
	mov ecx, lengtha
	cld
	mov eax, 0

l1: lodsb
	mul mult
	stosb
	loop l1

ret
multiplyArrayByte endp
	







; 7



getstring proc uses  eax ecx  ptrstr1:ptr dword

	.data
	msg112 byte "enter string: ", 0

	.code
	mov edx, offset msg112
	call writestring
	mov edx, ptrstr1
	invoke str_length, ptrstr1
	;mov ecx, eax
	mov ecx, 0ffh
	mov edx, ptrstr1
	call readstring

mov edx, ptrstr1
ret
getstring endp













; 8

displayFileContents proc 
	pushad

.data
lengthfirst = 0ffffh

filename byte 129d dup ('#')

data byte lengthfirst dup ('#')
datalength dword lengthfirst

.code
	l1: invoke primeArray, addr data, 0ffffh, '#'
		invoke primeArray, addr filename, 129d, '#'
		mov datalength, 0ffffh
		invoke getString, addr filename
		mov edx, offset filename
		call openinputFile
		mov edi, eax
		mov edx, offset data
		mov ecx, datalength
		cmp al, 0ffh
		je l1
		call readfromfile
		mov datalength, eax
		mov eax, edi
		call closefile
		
		invoke displayascii, addr data, datalength
		
		mov edx, offset data
		;call writestring
		call crlf

popad
ret
displayFileContents endp







; 9

dumpascii proc   uses ecx ebx esi eax ptraddress1:ptr dword, le1:dword, t1:dword

		mov ecx, le1
		mov esi, ptraddress1
		mov ebx, t1

l1:     mov al, [esi]
		call writechar
		add esi, t1
		loop l1

ret
dumpascii endp




geteax proc uses edx
	.data

	msg75 byte "Enter eaxl: "

	.code
	mov edx, offset msg75
	call writeString
	call readint
ret
geteax endp









; 10

displayascii proc uses esi eax edx	ptrdata2:ptr DWORD, length2:dword

	call crlf
	mov ecx, length2
	mov esi, ptrdata2
	
l1: mov al, byte ptr [esi]
	call writechar
	inc esi
	loop l1

ret
displayascii endp






;  11



; currently not functional
displayasciiMatrix proc uses esi ecx eax ptrbuff:ptr byte, length4:dword

	


writesquares proto color1:byte, color2:byte, char2:ptr dword, size2:byte, numsquares:dword
writesquare proto  ptrarr:ptr dword, size1:byte
setcolor proto color1:byte, color2:byte
nextrow proto size2:byte
drawrow proto ptrarr:ptr dword, row1:byte, col1:byte
drawcheckers proto ptrarr:ptr dword, color6:byte



.data
character byte 0dbh
size3 byte 10
numsquares dword 8
color1 byte 0
color2 byte 3

.code

	
	mov ecx, 0
	mov bl, 3
l1:
	mov dx, 0
	call gotoxy

	push eax
	mov eax, 1000
	;call delay
	pop eax
	invoke drawcheckers,ptrbuff, bl
	inc bl
	push eax
	mov eax, 100
	call delay
	pop eax
	;loop l1
	
	call crlf
	call crlf
	call crlf
	call crlf
	call crlf
	call waitmsg

ret  
displayasciimatrix endp






; 12


drawrow proc uses ecx eax ebx edx esi ptrarray4:ptr dword, row2:byte, col2:byte

	
	mov dh, row2
	mov dl, col2
	mov ecx, 4
l1: call gotoxy
	invoke writesquare, ptrarray4, 10
	add dl, 20
	sub dh, 10
	loop l1

ret
drawrow endp 







; 13

writesquares proc color3:byte, color4:byte, ptrarr12:ptr dword, size2:byte, numsquares1:dword
	
	mov edx, 0


	mov ecx, numsquares1
l2: push ecx
	mov ecx, numsquares1
l1: push ecx
	call gotoxy
	invoke writesquare,ptrarr12, size2
	add dh, 3d
	pop ecx
	loop l1
	pop ecx
	call crlf
	add dl, 10d

	loop l2

ret
writesquares endp







; 14

writesquare proc uses ecx esi ptrarray3:ptr DWORD, size1:byte

	mov esi, ptrarray3
	mov ecx, 0
	mov cl, size1
l2: push ecx
	movzx ecx, size1
l1:	mov al, byte ptr[esi]
	call writeChar
	inc esi
	loop l1
	add dh, 1
	call gotoxy
	pop ecx
	loop l2

ret
writesquare endp







;  15

drawcheckers proc uses ebx ptrarr21:ptr dword, color4:byte
	
	mov al, color4
	shl al, 4
	;or al, 0fh
	;call settextcolor
	
	mov dl, 0
	mov bl, 0
	mov ecx, 7
l1: invoke drawrow, ptrarr21, bl, dl
	add bl, 5
	xor dl, 10d
	loop l1
	

COMMENT !
	invoke drawrow, 0, 0
	invoke drawrow, 5, 10
	invoke drawrow, 10, 0
	invoke drawrow, 15, 10
	invoke drawrow, 20, 0
	invoke drawrow, 25, 10
	invoke drawrow, 30, 0
	invoke drawrow, 35, 10
	invoke drawrow, 40, 0

	!
	

ret
drawcheckers endp





; 16

loadfile proc uses edx ECX esi eax ebx edi ptrbuff22:ptr dword, ptrlength22:PTR DWORD, PTRFILENAME:ptr dword

	mov esi, ptrfilename
	mov edi, ptrlength22
	mov edx,esi
	call openinputfile
	mov ebx, eax
	mov edx, ptrbuff22
	mov ecx, [edi]
	call readfromfile
	mov [edi], eax
	mov eax, ebx
	call closefile
	
ret
loadfile endp



















; 17

; currently not functional
asciimatrix proc uses esi eax  ptrbufff:ptr dword, leng:DWORD

	mov esi, ptrbufff
	mov ecx, leng
	shr ecx, 2
	mov ebx, 8
	
 l1: invoke writesquare, esi, bl
	  add esi, ebx
	  loop l1

ret
asciimatrix endp 












; 18

randomarray proc  uses ecx esi ptrbuff5:Ptr dword, leng:dword
		
		call randomize
		mov ecx, leng
		mov esi, ptrbuff5
l1:		jmp getRandom
l2:		mov [esi], al
		inc esi
		loop l1
		jmp ext

getRandom:
 		mov eax, 0fh
		;call randomRange
		call randomchar
		jmp l2


ext:
ret
randomarray endp







; 19

randomchar proc
	
	mov eax, 7ah
	sub eax, 41h
	call randomrange
	add eax, 41h
ret
randomchar endp





; 20

goto00 proc

	mov dx, 0
	call gotoxy
ret 
goto00 endp





; 21


bubblesortByte proc uses eax ecx esi pa43:ptr dword, len3:dword

		mov ecx, len3
		dec ecx

l1: push ecx
	mov esi, pa43

l2: mov al, byte ptr [esi]
	cmp byte ptr[esi+1], al
	jg l3
	xchg al,byte ptr [esi+1]
	mov byte ptr[esi], al

l3: add esi, 1
	loop l2

	pop ecx
	loop l1
l4:

ret

bubblesortByte endp







; 22

binarysearch proc  uses ebx edx esi edi   ptra81:ptr dword, leng42:dword, searchval:dword

local first:dword, last:dword, mid:dword


	mov first, 0
	mov eax, leng42
	dec eax
	mov last, eax
	mov edi, 0
	mov edi, searchVal
	mov ebx, ptra81 

l1: mov eax, first
	cmp eax,last
	jg l5
	
	mov eax, last
	add eax, first
	shr eax, 1
	mov mid,eax
	
	mov esi, mid
	shl esi, 2
	mov edx, [ebx+esi]

	cmp edx, edi
	jge l2
	
	mov eax, mid
	inc eax
	mov first, eax
	jmp l4

	l2: cmp edx, edi
		jle l3

		mov eax, mid
		dec eax
		mov last, eax
		jmp l4
	
	l3: mov eax, mid
		jmp l9
		
	l4: jmp l1

	l5: mov eax, -1
	l9: ret
binarysearch endp

		



	




;23

rollingtext proc ptra13:ptr dword, lengtt:dword, width3:dword
pushad
	
		mov esi, ptra13
		mov ebx, 0
		mov ecx, lengtt
	    sub ecx, width3
	l1: invoke displayasciiLine,ptra13 , width3
		mov eax, 100
		call delay
		call goto00
		
		INC ptra13
		LOOP l1
		
		
	
		call waitmsg

popad
ret
rollingtext endp





; 24

displayasciiLine proc uses esi eax edx	ptrdata2:ptr DWORD, length2:dword

	call crlf
	mov ecx, length2
	mov esi, ptrdata2
	
l1: mov al, byte ptr [esi]
	cmp al, 20h
	jl no
	cmp al, 7ah
	ja no
b: call writechar
	inc esi
	loop l1
	jmp ext
no:
	mov al, 20h
	jmp b

ext:
ret
displayasciiLine endp





; 25

rollingtextbackwards proc ptra13:ptr dword, lengtt:dword, width3:dword
pushad
	
		mov esi, ptra13
		mov ebx, 0
		mov ecx, lengtt
	    sub ecx, width3

		add ptra13, ecx
	l1: invoke displayasciiLine,ptra13 , width3
		mov eax, 100
		call delay
		call goto00
		
		dec ptra13
		LOOP l1
		
		
	
		call waitmsg

popad
ret
rollingtextbackwards endp





; 26

xorbuffer proc ptra6:ptr dword, leng54:dword, key4:byte
pushad
	mov esi, ptra6
	mov ecx, leng54
	mov al, key4
l1: xor [esi], al
	inc esi
	loop l1
popad
ret
xorbuffer endp




; 27


compareArraysd proc uses ebx ecx esi edi  ptr19:ptr dword, ptr18:ptr dword, leng78:dword
;ret flags
	
	mov esi, ptr19
	mov edi, ptr18
	mov ecx, leng78
	cld

	repe cmpsd



comment !

l1: mov eax, [esi]
	mov ebx, [edi]
	cmp eax, ebx
	jne done
	add esi, 4
	add edi, 4
	loop l1

done:
		!


ret
compareArraysd endp





; 28


findCharInW proc  uses ebx esi ptra41:ptr word, leng09:dword, char01:byte
; ret eax = index of char
; if not found, eax = -1 and cf=1
	mov ecx, leng09
	mov edi, ptra41
	movzx ax, char01
	cld
	repne scasw
	jecxz notfound

	sub edi, 2   ; point to previous
	

	mov eax, edi		; move address of char found to eax
	comment !
		if you want to return the memory address of the char and not the index,
		uncomment the follow jump
			!
	;jmp extf:
			
	sub eax, ptra41     ; subtract table address from char address to get byte offset from beginning of array
	shr eax, 1			; divide by type to get array index (word = 2)
	clc
	jmp ext		
notfound:
	stc
	mov eax, -1
	jmp ext

extf:
clc
ext:
ret
findCharInW endp
	





; 29


showIndexOfCharInW proc		ptarray:ptr word, leng08:dword, char04:byte


	mov al, char04
	call writechar
	invoke findCharInW, ptarray, leng08, char04
	jc notfound
	mwrite " found at index: "
	call writeDec
	jmp ext

notfound: 
	mwrite "Not found"
ext:
ret
showIndexOfCharInW endp






; 30

displayLargerString proc st12:ptr dword, st22:ptr dword
	pushad
	invoke str_compare, st12, st22
	jg firstgreater
	je even1
	mov edx, st22
	call writeString
	jmp ext

firstgreater:
	mov edx, st12
	call writeString
	jmp ext

even1:
	mwrite "Both Strings the same"
	
ext:
popad
ret
displayLargerString endp






; 31

str_lcase proc		ptrstri2:ptr byte
pushad 
	invoke str_length, ptrstri2
	mov ecx, eax
	mov esi, ptrstri2
l1: cmp byte ptr [esi], 41h
	jl ext
	cmp byte ptr [esi], 5ah
	jg ext
	or al, 00100000b
	inc esi
	loop l1
ext:
popad
ret
str_lcase endp






; 32

display2DElementDword proc	ptrarr323:ptr dword, rowsize8:dword, row53:dword, col51:dword
pushad

		mov esi, ptrarr323
		mov eax, rowsize8
		mov ecx, row53
		mul ecx
		mov ebx, col51
		shl ebx, 2
		add esi, ebx
		mov eax, [eax + esi]
		call writeHex
popad
ret
display2DElementDword endp






; 33

str_copyN proc ptrsource:ptr dword, ptrtarget:ptr dword, lengt09:dword
pushad

	mov ecx, lengt09
	jecxz ext
	mov esi, ptrsource
	mov edi, ptrtarget
	
	invoke str_length, ptrsource
	cmp eax, ecx
	jl strLessThanLimit

l1:
	rep movsb
	jmp ext

strLessThanLimit:
	mov ecx, eax
	jmp l1
ext:
ret
str_copyN endp










; 34

str_concat proc ptrtarg3:ptr dword, ptrso3:ptr dword
	local targetLength:dword, sourceLength:dword
pushad
		
	invoke str_length, ptrtarg3	; get length of target and source
	mov targetLength, eax
	invoke str_length, ptrso3
	mov sourceLength, eax
					
	mov edi, ptrtarg3
	add edi, targetLength		; edi points to end of target
	mov esi, ptrso3				; esi points to beginning of source
	
	mov ecx, sourceLength
	cld
	rep movsb		; mov [edi], [esi]         until ecx=0
	mov byte ptr [esi], 0    ; add null terminator

popad
ret
str_concat endp


	








end