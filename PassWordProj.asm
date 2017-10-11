;Eion Simonelli - Strings Assignment 07.25.17
.model small
.stack 500h
              
			.data
  enterString db 13, 10, 'Please enter a string: $'
  enterChar   db 13, 10, 'Please enter a character: $'
  beginPrompt db 13, 10, 'Please choose from the choices above: $'
  menuPrompt  db 13, 10, '1.) Determine the position of the first occurance of char '
  menuPrompt2 db 13, 10, '2.) Find number of occurrences of a certain letter in strings '
  menuPrompt3 db 13, 10, '3.) Length of string '
  menuPrompt4 db 13, 10, '4.) Number of alpha numeric in string '
  menuPrompt5 db 13, 10, '5.) Character replace '
  menuPrompt6 db 13, 10, '6.) Capitalize the letters in strings'
  menuPrompt7 db 13, 10, '7.) Make each letter lower case '
  menuPrompt8 db 13, 10, '8.) Toggle case '
  menuPrompt9 db 13, 10, '9.) Undo previous function '
  menuPrompt10 db 13, 10, '10.) Enter new string function '
  menuPrompt0 db 13, 10,  '0.) Output Menu Again '
  menuPrompt999 db 13, 10, '999.) Exit Program $'

  displayMenuAgain db 13, 10, 'The function has completed.', 10, 13, 'Display the menu again? (Y/y for yes, all else for No) $'

  occurPrompt db         'Enter a character to determine the first occurance of: $'
  recurrPrompt db        'Enter a character to determine the number of occurrences of: $'
  helper      db         '$'
  occurPrompt1 db 13,10, 'The first $'
  occurPrompt2 db        ' is at position $'
  occurrencesInString db ' time(s) in the strings $'
  inTheString db         ' in the string $'
  inTheStringClose db    '$'
  recurrPrompt1 db 13, 10, 'The letter $'
  recurrPrompt2 db 13, 10, ' occurs $'
  lengthPrompt  db 13, 10, 'There are $'
  lengthPrompt1 db         ' characters in the string $'

  replacePrompt db 13,10, 'Replacing all of the $'
  replacePrompt2 db       's in the string $'
  replacePrompt3 db 13, 10, 'With $'

  numError db            'Error! The number entered is not in the specified group, try again $'
  occurError db 13, 10,  'No occurances of the character were found $'
  posPrompt db 13, 10,   'The characters first occurance was at position $'
 
  alphaPrompt db 13, 10,  'There were a total of $'
  alphaPrompt2 db         ' alpha numeric characters in the string $'
  charReplace1 db 13, 10, 'Enter a character to replace: $'
  charReplace2 db 13, 10, 'Enter replacement character: $'
  capitalPrompt db 13, 10,'Capitalizing each letter in the string $'
  yieldsPrompt db 13, 10, ' yields $'
  lowerPrompt  db 13, 10, 'Converting each letter in the string $'
  lowerPrompt2 db 13, 10, ' to lower case yields $'
  togglePrompt db 13, 10, 'Toggling each letter of the string $'
  undoPrompt   db 13, 10, 'Reverts back to $'
  goodBye      db 13, 10, 'Goodbye! $'

  newStringPrompt db 13, 10, 'The new string is: $'
  menuVar dw 0
  newLine db 10, 13, '$'
  userChar db ?
  occurCount dw 0
  charPos dw 0
  alphaTotal dw 0
  charToReplace db ?
  replacementChar db ?

  inputString1 label byte
  max1 db 51
  userLength db ?
  str1 db 51 dup('$')

  inputString2 label byte
  max2 db 51
  userLength2 db ?
  str2 db 51 dup('$')



 PROMPT MACRO MESSAGE
        mov ah, 9h
        lea dx, message
        int 21h
 ENDM

                .code
EXTRN GETDEC : NEAR, PUTDEC : NEAR

start:   mov ax, @data
         mov ds, ax


         PROMPT enterString

         lea dx, inputString1
         mov ah, 0ah
         int 21h

      jmp menuCall
         
   menuStart:
         cmp ax, 0
         je menuCall
         PROMPT newLine
         PROMPT displayMenuAgain
         

         mov ah, 01
         int 21h
         mov  userChar, al
         AND al, 11011111b
         cmp al, 059h
         jnz finish


   menuCall:
        call menu

   opt999: cmp ax, 999
          je finish

   opt0: cmp ax, 0
         jg opt1
         jmp menuStart
         
   opt1: cmp ax, 10
         jg num_too_big
         cmp ax, 1
         jnz opt2
         call firstPos


   opt2: cmp ax, 2
         jnz opt3
         call numRecur

   opt3: cmp ax, 3
         jnz opt4
         call stringLength

   opt4: cmp ax, 4
         jnz opt5
         call alphaNumeric

   opt5: cmp ax, 5
         jnz opt6
         call charReplace

   opt6: cmp ax, 6
         jnz opt7
         call toUpper

   opt7: cmp ax, 7
         jnz opt8
         call toLower

   opt8: cmp ax, 8
         jnz opt9
         call toToggle

   opt9: cmp ax, 9
         jnz opt10
         call undoProc

   opt10: cmp ax, 10
   	      jnz num_too_big
          jmp inputString

finish:  
         PROMPT goodbye
         mov ah, 04ch
         int 21h



num_too_big:  PROMPT numError
              call GetDec
              cmp ax, 10
              jg num_too_big
              jmp opt999


copyProc PROC NEAR

    
    lea si, str1
    lea di, str2
    


copy: mov bl, [si]
      mov [di], bl
        inc si
        inc di

        loop copy

   RET

copyProc ENDP

menu PROC NEAR

         PROMPT newLine
         PROMPT menuPrompt
         PROMPT newLine
         mov cl, userLength
         mov ch, 0

         PROMPT beginPrompt
         call GetDec
         jmp opt999


menu endp

numRecur  PROC NEAR

           mov occurCount, 0
           PROMPT recurrPrompt
           
           mov ah, 01
           int 21h
           mov  userChar, al

           lea si, str1     ; loading string for walk thru

  compare:  mov al, [si]
           cmp al, userChar
           jne nextChar
           inc occurCount

  nextChar:  inc si
            loop compare


            PROMPT newLine
            je noOccur


            PROMPT recurrPrompt1
            mov dl, userChar
            mov ah, 2
            int 21h

            PROMPT recurrPrompt2

            mov ax, occurCount
            cmp ax, 0
            call PutDec

            PROMPT occurrencesInString
           
            PROMPT str1
            PROMPT inTheStringClose

            PROMPT newLine
            jmp menuStart

  noOccur:
        PROMPT occurError
        jmp finish
       RET
numRecur ENDP

firstPos PROC NEAR

        mov charPos, 0
        PROMPT occurPrompt

        mov ah, 01
        int 21h
        mov  userChar, al
        lea si, str1

 posCompare: mov al, [si]
        cmp al, userChar
        jne posNextChar
        
        jmp firstPosFound

 posNextChar:
           inc charPos
           inc si
           loop posCompare
           PROMPT occurError
           jmp menuStart

 firstPosFound: 
            PROMPT helper
            PROMPT occurPrompt1
            mov dl, userChar
            mov ah, 2
            int 21h

            PROMPT occurPrompt2
            mov ax, charPos
            call PutDec

            
            PROMPT inTheString
           
            PROMPT str1
            PROMPT inTheStringClose

            jmp menuStart

firstPos ENDP

stringLength PROC NEAR
           PROMPT lengthPrompt

          mov al, userLength
          mov ah, 0
          call PutDec

           PROMPT lengthPrompt1
           PROMPT str1
           jmp menuStart

stringLength ENDP

alphaNumeric PROC NEAR
          mov alphaTotal, 0
          lea si, str1

 alphaCompare: mov al, [si]
               cmp al, 7Ah
               jg moveOn
               cmp al, 61h
               jge alphaInc
               cmp al, 5Bh
               jge moveOn
               cmp al, 41h
               jge alphaInc
               cmp al, 3Ah
               jge moveOn
               cmp al, 30h
               jge alphaInc

 moveOn:   inc si
           loop alphaCompare

           PROMPT alphaPrompt
           mov ax, alphaTotal
           call PutDec
           PROMPT alphaPrompt2
           PROMPT newLine
           PROMPT str1
           jmp menuStart

 alphaInc: inc alphaTotal
           jmp moveOn

alphaNumeric ENDP



charReplace PROC NEAR

  call copyProc
  mov cl, userLength
  mov ch, 0

  PROMPT charReplace1

   mov ah, 01
   int 21h
   mov charToReplace, al

  PROMPT charReplace2

   mov ah, 01
   int 21h
   mov replacementChar, al

   PROMPT newLine
   PROMPT replacePrompt
   mov dl, charToReplace
   mov ah, 2
   int 21h

   PROMPT replacePrompt2
   PROMPT str1
   PROMPT replacePrompt3
   mov dl, replacementChar
   mov ah, 2
   int 21h
   PROMPT yieldsPrompt
   

   mov ah, 0
   lea si, str1

  replaceCompare:
           mov al, [si]
           cmp al, charToReplace
           jne replaceNextChar
           mov bl, replacementChar
           mov [si], bl

  replaceNextChar:
            inc si
            loop replaceCompare

             
            PROMPT str1

            jmp menuStart

    RET
charReplace ENDP

toUpper PROC NEAR

   call copyProc

   mov cl, userLength
   mov ch, 0
   PROMPT capitalPrompt
   PROMPT str1

  
   ; lea si, str1 
    mov si, offset str1
   mov bl, 11011111b

upperLoop:
            mov al, [si]
            cmp al, 41h
            jl upperNextChar
            and [si], bl
        
upperNextChar:
            inc si
            loop upperLoop

        PROMPT yieldsPrompt
        PROMPT str1
        PROMPT newLine
        jmp menuStart




   RET
toUpper   ENDP

toLower PROC NEAR

    call copyProc
   mov cl, userLength
   mov ch, 0

   PROMPT lowerPrompt
   PROMPT str1
   lea si, str1

   mov bl, 00100000b
lowerLoop:
            mov al, [si]
            cmp al, 41h
            jl lowerNextChar
            or [si], bl
        
lowerNextChar:
            inc si
            loop lowerLoop

        PROMPT lowerPrompt2
        PROMPT str1
        PROMPT newLine
        jmp menuStart




   RET
toLower   ENDP

toToggle PROC NEAR


   call copyProc

   mov cl, userLength
   mov ch, 0

   PROMPT togglePrompt
   PROMPT str1
   lea si, str1

   mov bl, 00100000b

toggleLoop:
            mov al, [si]
            cmp al, 41h
            jl toggleNextChar
            xor [si], bl
        
toggleNextChar:
            inc si
            loop toggleLoop

        PROMPT yieldsPrompt
        PROMPT str1
        PROMPT newLine
        jmp menuStart




   RET
toToggle   ENDP

undoProc PROC NEAR

   PROMPT newLine
   PROMPT str1

   PROMPT undoPrompt
   
    lea si, str2
    lea di, str1
    


undoCopy: mov bl, [si]
      mov [di], bl
        inc si
        inc di

    loop undoCopy

   PROMPT newLine
   PROMPT str1

   jmp menuStart

   RET
undoProc ENDP


inputString PROC NEAR

    mov cl, userLength
    mov ch, 0
    lea si, str1
    mov bl, '$'

 inputClear:
        mov [si], bl
        inc si
        loop inputClear

        PROMPT enterString

        lea dx, inputString1
        mov ah, 0ah
        int 21h

        PROMPT newLine
        PROMPT newStringPrompt
        PROMPT str1
        jmp menuStart


RET
inputString ENDP


end



