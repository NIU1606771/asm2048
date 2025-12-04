section .note.GNU-stack noalloc noexec nowrite progbits
section .data               
;Canviar Identificador_Grup per l'identificador del vostre grup.
developer db "Identificador_Grup",0

;Constants que també estan definides en C.
DimMatrix    equ 4
SizeMatrix   equ DimMatrix*DimMatrix ;=16

section .text        
;Variables definides en Assemblador.
global developer                        

;Subrutines d'assemblador que es criden des de C.
global showCursor, showNumber, showMatrix, copyMatrix, shiftNumbers, addPairs
global rotateMatrix, onePlay, playGame

;Variables definides en C.
extern rowScreen, colScreen, charac, number, row, col, rowInsert
extern m, mAux, score, state

;Funcions de C que es criden des de assemblador
extern gotoxy_C, getch_C, printch_C

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓ: Recordeu que en assemblador les variables i els paràmetres 
;;   de tipus 'char' s'han d'assignar a registres de tipus  
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   les de tipus 'short' s'han d'assignar a registres de tipus 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   les de tipus 'int' s'han d'assignar a registres de tipus 
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   les de tipus 'long' s'han d'assignar a registres de tipus 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Les subrutines en assemblador que heu d'implementar són:
;;   showCursor, showNumber, showMatrix, shiftNumbers, addPairs
;;   copyMatrix, rotateMatrix, onePlay, playGame.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor a la fila indicada per la variable (rowScreen) i a 
; la columna indicada per la variable (colScreen) de la pantalla,
; cridant la funció gotoxy_C.
; 
; Variables globals utilitzades:   
; (rowScreen): Fila de la pantalla on posicionem el cursor.
; (colScreen): Columna de la pantalla on posicionem el cursor.
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi


   call gotoxy_C
 
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla i guarda el caràcter associat a la variable (charac)
; sense mostrar-la per pantalla, cridant la funció getch_C. 
; 
; Variables globals utilitzades:   
; (charac): Caràcter que llegim de teclat.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi

   call getch_C
 
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un caràcter guardat a la variable (charac) a la pantalla, 
; en la posició on està el cursor, cridant la funció printch_C
; 
; Variables globals utilitzades:   
; (charac): Caràcter que volem mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi

   call printch_C
 
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A partir de la posició de la matriu row i col
; calcular la posició que ha d'ocupar aquesta component a la pantalla
; i posicionar el cursor a la posició corresponent
; posant els valors adequats a rowScreen i colScreen,
; i després cridant a la subrutina gotoxy.
; La posició a la pantalla (rowScreen, colScreen)
; corresponent a la component (row, col) de la matriu
; ve determinada per les equacions:
; 
; 		rowScreen = row*2 + 10
; 		colScreen = col*9 + 13
;
; HEU DE TENIR EN COMPTE EL TIPUS DE LES VARIABLES 
; PER A DETERMINAR ELS REGISTRES QUE HEU DE FER SERVIR
;
; Variables globals utilitzades:   
; (row)   		: Fila de la matriu.
; (col)			: Columna de la matriu.
; (rowScreen)	: Fila de la pantalla on posicionem el cursor.
; (colScreen)	: Columna de la pantalla on posicionem el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showCursor:
   push rbp
   mov  rbp, rsp
   
      
   ;Guardem el registres
   PUSH rax
   PUSH rbx
   push rcx
   push rdx
   
   
   ;RowScreen
   MOV eax, DWORD[row]
   SHL eax, 1
   ADD eax,10
   MOV DWORD[rowScreen], eax


;  colScreen
   MOV eax,DWORD[col]
   MOV ebx, 9
   MUL ebx
   ADD eax,13
   MOV DWORD[colScreen],eax


   CALL gotoxy
   
   POP rdx
   POP rcx
   POP rbx
   POP rax 



   
   mov rsp, rbp
   pop rbp
   ret

   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar per pantalla, a la posició del tauler corresponent
; un valor sencer emmagatzemat a la variable number de tipus int (DWORD) 
; de 4 dígits (number <= 9999). Si (number) és més gran que 9999 canviarem el valor a 9999.
; Per a poder treure per pantalla un valor numèric cal convertir-lo
; al conjunt de caràcters ASCII que representen aquest valor. 
; Si el número és 1234 s'ha de mostrar per pantalla els caràcters '1', '2', '3' i '4'.
; Si el número no té 4 dígits, els dígits de més a l'esquerra no s'han de mostrar.
; Per exemple, 23 ha de ser ' ', ' ', '2' i '3'
; Fins i tot, si el número és 0, ha de ser ' ', ' ', ' ' i ' '.
; Hi ha diverses formes de fer aquest procés.
; Però totes necessiten dividions per 10 (o potències de 10).
; S'han de mostrar els dígits (caràcter ASCII) a partir de la posició 
; corresponent a row i col.
; Per a mostrar els caràcters cal cridar a la subrutina printch.
; Quan es crida a la subrutina printch es treu un caràcter per pantalla
; i el cursor ja avança de forma automàtica a la posició següent
; de forma que no cal tornar a posicionar el cursor
;
; Variables globals utilitzades:   
; (number)   	: Número que volem mostrar.
; (row)			: Fila de la matriu on volem posicionar el cursor.
; (col)			: Columna de la matriu on volem posicionar el cursor.
; (rowScreen)	: Fila de la pantalla on posicionem el cursor.
; (colScreen)	: Columna de la pantalla on posicionem el cursor.
; (charac)   	: Caràcter a escriure a pantalla.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showNumber:
   push rbp
   mov  rbp, rsp
  push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi

   ; Clamp number a [0, 9999]
   mov  eax, DWORD [number]
   cmp  eax, 9999
   jle  .num_ok
   mov  eax, 9999
   .num_ok:
   mov  DWORD [number], eax    ; Guardar el valor ajustado

   ; Resto del código permanece igual...
   ; Col·loquem el cursor a (row,col)
   call showCursor

   mov  edi, DWORD [number]    ; Usar el valor ajustado
   mov  ecx, 0
   mov  esi, 1
bucle:
  cmp ecx, 4
  je fi


  cmp ecx, 0
  je div1000
  cmp ecx, 1
  je div100
  cmp ecx, 2
  je div10
  mov ebx, 1
  jmp divisio

div1000:
   mov ebx, 1000
   jmp divisio
div100:
   mov ebx, 100
   jmp divisio
div10:
   mov ebx, 10
divisio:
   mov eax, edi
   mov edx, 0
   div ebx
   mov edi, edx

   cmp eax, 0
   jne nozero
   cmp esi, 1
   jne zeroposat
   mov al, ' '
   jmp printa
zeroposat:
   mov al, '0'
   jmp printa
nozero:
   mov esi, 0
   add al, '0'
printa:
   ;and eax, 00FFh
   mov BYTE[charac], al
   call printch

   inc ecx
   jmp bucle


fi:
    pop rdi
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
	 
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar el contingut de la matriu (m) al Tauler de Joc 
; S'ha de recórrer tota la matriu (m), i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar el número d'aquella 
; posició de la matriu.
; Per a posicionar el cursor heu de recorrer totes les files i columnes de la matriu de 1 en 1
; Alhora, heu d'anar passant d'element en element incrementant l'índex d'accés a la matriu
; de dos en dos perquè les dades son de tipus short (WORD).
; Un cop que teniu la fila (row) i columna (col) i el valor posat a (number)
; heu de cridar a showCursor i showNumber.
;
; Variables globals utilitzades:   
; (number)   	: Número que volem mostrar.
; (row)			: Fila de la matriu on volem posicionar el cursor.
; (col)			: Columna de la matriu on volem posicionar el cursor.
; (rowScreen)	: Fila de la pantalla on posicionem el cursor.
; (colScreen)	: Columna de la pantalla on posicionem el cursor.
; (m)        	: Matriu on guardem els nombres del joc.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showMatrix:
   push rbp
   mov  rbp, rsp
   
   
   push rax
   push rbx
   push rcx; fila
   push rdx; columna
   
   
   mov  ecx, 0
fila:
   cmp ecx, 4 ;DimMatrix
   jge fiSM
   
   mov edx,0
   
columna:
   cmp edx, 4 ;DimMatrix: comparem la columna
   jge seguentf
   
   ;actualitzem les variables
   mov dword [row], ecx
   mov dword [col], edx
   
   
   
   mov eax, ecx
   shl eax, 2
   add eax, edx
   shl eax, 1
   
   mov bx, word [m + eax]
   mov eax, ebx
   mov dword [number], eax
   
   call showCursor
   call showNumber
   
   inc edx
   jmp columna
   
seguentf:
   inc ecx
   jmp fila
   
fiSM:
   pop rdx
   pop rcx
   pop rbx
   pop rax
   





   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copiar els valors de la matriu (mAux) a la matriu (m).
; La matriu (mAux) no s'ha de modificar, 
; els canvis s'han de fer a la matriu (m).
; Per recórrer la matriu en assemblador l'índex va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de 
; tipus short(WORD) 2 bytes.
; No cal mostrar la matriu.
;
; Variables globals utilitzades:   
; (m)       : Matriu on guardem els nombres del joc.
; (mAux): Matriu amb els nombres rotats a la dreta.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
copyMatrix:
   push rbp
   mov  rbp, rsp
   
   
   push rax

   mov rax, 0

bucleC:
   cmp rax, 32 ;16*2
   jge fiC

   mov bx, [mAux + rax]
   mov [m + rax], bx

   add rax, 2
   jmp bucleC

fiC:
   pop rax
   

   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Desplaça a la dreta els números de cada fila de la matriu (m),
; mantenint l'ordre dels números i posant els zeros a l'esquerra.
; Recórrer la matriu per files de dreta a esquerra i de baix a dalt.
; Per recórrer la matriu en assemblador, en aquest cas, l'índex va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb decrements de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Si es desplaça un número (NO ELS ZEROS), posarem la variable 
; (state) a '2'.
; A cada fila, si troba un 0, mira si hi ha un número diferent de zero,
; a la mateixa fila per a posar-lo en aquella posició.
; Si una fila de la matriu és: [2,0,4,0] i state = '1', quedarà [0,0,2,4] 
; i state = '2'.
;
; Variables globals utilitzades:   
; (m)    : Matriu on guardem els nombres del joc.
; (state): Estat del joc. ('2': S'han fet moviments).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
shiftNumbers:
   push rbp
   mov  rbp, rsp
   
   
   push rax ;row
   push rbx ;col
   push rcx ;diferencia
   push rdx
   push rdi
   push rsi ;nova col
   
   mov eax, 0 ;fila = 0
SNbuclerow:
   cmp eax, 4
   jge SNfi
   mov ecx, 0 ;dif = 0
   mov ebx, 3 ;col = 3
   
SNbuclecol:
   cmp ebx, 0 
   jl SNbucleaf
   
   mov edi, eax ;edi serà la posició de les dades
   shl edi, 2 ;multipliquem per DimMatrix*row
   add edi, ebx ;afegim la col
   shl edi, 1 ;multipliquem per la mida de les dades (short=2B)
   
   cmp word [m + edi], 0 ;mirem si a la posició hi ha un 0
   je SNseguent ;si és 0, passem al següent
   
   
   cmp ebx, 3 ;si estem a la ultima columna saltem
   je SNcont
   
   
   mov esi, 3 ;esi serà la columna on haurem de moure el num
   sub esi, ecx ; restem la diferencia a les columnes per saber on ho hem de col·locar
   
   
   cmp esi, ebx ;si les col i nova col son iguals no hem de fer res
   je SNcont
   
   
   mov dx, word [m + edi] ;guardem el valor que hem de moure
   ;trobem la nova posició
   mov edi, eax
   shl edi, 2
   add edi, esi
   shl edi, 1
   
   mov word [m + edi], dx ;guradem el num a la nova posició
   
   ;tornem a la pos inicial per continuar amb el bucle i hi posem un 0
   mov edi, eax
   shl edi, 2
   add edi, ebx
   shl edi, 1
   mov word [m + edi], 0 ;posem el 0
   mov byte [state], 2 ;indiquem que hem fet modificacions
SNcont:
   inc ecx ;diferencia +1
SNseguent:
   dec ebx ;col -1
   jmp SNbuclecol

SNbucleaf:
   inc eax ;row +1
   jmp SNbuclerow

SNfi:
   pop rsi
   pop rdi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   

   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aparellar nombres iguals des de la dreta de la matriu (m).
; Recórrer la matriu per files de dreta a esquerra i de baix a dalt. 
; Quan es trobi una parella, dos caselles consecutives amb el mateix 
; número, ajuntem la parella posant la suma de la parella a la casella 
; de la dreta, un 0 a la casella de l'esquerra.
; Si una fila de la matriu és: [8,4,4,2] i state = 1'', 
; quedarà [8,0,8,2] i state = '2'.
; Per recórrer la matriu en assemblador, en aquest cas, l'índex va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb increments de 
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; No s'ha de mostrar la matriu.
;
; Variables globals utilitzades:   
; (m)    : Matriu on guardem els nombres del joc.
; (state): Estat del joc. ('2': S'han fet moviments).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
addPairs:
   push rbp
   mov  rbp, rsp
   
   
   
   push rax ;row
   push rbx ;col
   push rcx ;val esq
   push rdx ;val dret
   push rdi ;pos dreta
   push rsi ;pos esq
   
   mov eax, 0                    
APbuclerow: 
   cmp eax, 4
   jge APfi
   mov ebx, 3                    
   
APbuclecol:
   cmp ebx, 0
   jle APnextf           
   
   ;calculem la posicio m[eax][ebx] = edi
   mov edi, eax
   shl edi, 2
   add edi, ebx
   shl edi, 1                    
   
   ;calculem la posicio m[eax][ebx-1] = esi
   mov esi, eax
   shl esi, 2
   add esi, ebx
   dec esi                       
   shl esi, 1                   
   
   ;guardem el valor de la posicio edi 
   mov dx, word [m + edi]         
   cmp dx, 0 ;si es 0 no caldrà fer cap suma
   je APnextc            
   
   ;guardem el valor de la posicio esi
   mov cx, word [m + esi]        
   cmp cx, 0 ;si és 0 no cal fer suma
   je APnextc             
   
   cmp dx, cx                   
   jne APnextc            
   
   ;dx i cx son iguals, els hem de sumar
   add dx, cx     ;dx=suma dels 2              
   mov word [m + edi], dx        
   mov word [m + esi], 0; posem el 0 a l'esquerra         
   
   mov byte [state], 2 ;indiquem que hem editat
   
APnextc:
   dec ebx ;col -1
   jmp APbuclecol

APnextf:
   inc eax ;row +1
   jmp APbuclerow

APfi:
   pop rsi
   pop rdi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   





   mov rsp, rbp
   pop rbp
   ret
   



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
; Rotar a la dreta la matriu (m), sobre la matriu (mAux). 
; La primera fila passa a ser la quarta columna, la segona fila passa 
; a ser la tercera columna, la tercera fila passa a ser la segona 
; columna i la quarta fila passa a ser la primer columna.
; A l'enunciat s'explica en més detall com fer la rotació.
; NOTA: NO és el mateix que fer la matriu transposada.
; La matriu (m) no s'ha de modificar, 
; els canvis s'han de fer a la matriu (mAux).
; Per recórrer la matriu en assemblador l'índex va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de 
; tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador 
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; L'element [i][j] de la matriu original va a la posició
; índex = (columna*DimMatrix+DimMatrix-1-fila)*2
; Un cop s'ha fet la rotació, copiar la matriu (mAux) a la matriu (m)
; cridant la subrutina copyMatrix.
; No s'ha de mostrar la matriu.
; 
; Variables globals utilitzades:   
; (m)       : Matriu on guardem els nombres del joc.
; (mAux): Matriu amb els nombres rotats a la dreta.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rotateMatrix:
   push rbp
   mov  rbp, rsp
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   
   mov  esi, 0           ; i = fila (0..3)
   
filas:
   cmp  esi, 4
   jge  fin_filas
   
   mov  edi, 0           ; j = columna (0..3)
   
columnas:
   cmp  edi, 4
   jge  fin_columnas
   
   ; Calcular índice ORIGINAL en m: (i*4 + j)*2
   mov  eax, esi         ; eax = i
   shl  eax, 2           ; eax = i * 4
   add  eax, edi         ; eax = i*4 + j
   shl  eax, 1           ; eax = (i*4 + j)*2
   
   ; Obtener valor de m[i][j] - CORREGIR: usar eax, NO rax
   mov  bx, WORD [m + eax]  ; CORRECCIÓN: eax en lugar de rax
   
   ; Calcular índice DESTINO en mAux
   ; Según fórmula: índice = (j*4 + 3 - i)*2
   mov  eax, edi         ; eax = j (nueva fila)
   shl  eax, 2           ; eax = j * 4
   mov  ecx, 3
   sub  ecx, esi         ; ecx = 3 - i (nueva columna)
   add  eax, ecx         ; eax = j*4 + (3-i)
   shl  eax, 1           ; eax = (j*4 + (3-i))*2
   
   ; Guardar en mAux[j][3-i] - CORREGIR: usar eax, NO rax
   mov  WORD [mAux + eax], bx  ; CORRECCIÓN: eax en lugar de rax
   
   inc  edi
   jmp  columnas
   
fin_columnas:
   inc  esi
   jmp  filas
   
fin_filas:
   ; Copiar mAux a m
   call copyMatrix
   
   ; Restaurar registros
   pop  rdi
   pop  rsi
   pop  rdx
   pop  rcx
   pop  rbx
   
   mov rsp, rbp
   pop rbp
ret
     


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; En aquesta subrutina s'insereix un nou element a la columna de més a l'esquerra
; de la matriu. L'element a inserir és sempre un valor 2.
; La fila en la que s'insereix l'element es va variant de forma
; rotativa, començant per la fila 0 al començament del programa.
; La següent vegada a la fila 1, i així successivament.
; Si la posició corresponent està plena es passa a la fila següent.
; Si no es pot inserir perquè estan les 4 posicions plenes
; es posa la variable (state) a 4.
;
; Variables globals utilitzades:   
; (m)       	: Matriu on guardem els nombres del joc.
; (rowInsert)	: Fila de la matriu en la que volem inserir un nou valor 2.
; (state)		: Estat del joc. ('4': S'ha pogut inserir.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
insertTile:
   push rbp
   mov  rbp, rsp
   ; Preservar registres
   push rbx
   push rcx
   push rdx
   
   mov ecx, 0           ; contador d'intents (0..3)
   mov ebx, DWORD[rowInsert] ; fila actual a provar
   
intentar:
   ; Calcular índex: (fila*DimMatrix + 0) * 2 = fila * 8
   mov eax, ebx         ; eax = fila
   shl eax, 3           ; eax = fila * 8
   
   ; Verificar si la posició [fila][0] està buida - CORREGIR: usar eax, NO rax
   cmp WORD [m + eax], 0  ; CORRECCIÓ: eax en lloc de rax
   je inserir
   
   ; Si està plena, provar següent fila
   inc ebx
   and ebx, 3
   inc ecx
   cmp ecx, 4
   jl intentar
   
   ; Tot ple
   mov BYTE [state], 4
   jmp ITfi

inserir:
   ; Inserir valor 2 - CORREGIR: usar eax, NO rax
   mov WORD [m + eax], 2  ; CORRECCIÓ: eax en lloc de rax
   
   ; Actualitzar rowInsert
   inc ebx
   and ebx, 3
   mov DWORD [rowInsert], ebx
   
   mov BYTE [state], 2

ITfi:
   pop rdx
   pop rcx
   pop rbx

   
  
   mov rsp, rbp
   pop rbp
   ret
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; En aquesta subrutina es comprova si s'ha aconseguit un 2048
; en fer un moviment.
; Si s'ha assolit un valor 2048, la variable (state) es posa a 3. 
;
; Variables globals utilitzades:   
; (m)       	: Matriu on guardem els nombres del joc.
; (state)		: Estat del joc. ('4': S'ha pogut inserir.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
gameWin:
   push rbp
   mov  rbp, rsp

   push rcx  ; Preservar rcx
   
   mov ecx, 0  ; Usar ecx (32-bit), NO rcx (64-bit)
   
comprovar:
   cmp ecx, 16
   jge GWfi
   
   ; CORREGIR: usar ecx*2, NO rcx*2
   cmp WORD [m + ecx*2], 2048
   je eti
   
   inc ecx
   jmp comprovar

eti:
   mov BYTE [state], 3

GWfi:
   pop rcx  ; Restaurar rcx


   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; En primer lloc cal mostrar la matriu al tauler cridant a showMatrix.
; Llegir una tecla cridant la subrutina getch 
; i quedarà guarda a la variable (charac).
; Segons la tecla llegida cridarem a les subrutines corresponents.
;    ['i' (amunt),'j'(esquerra),'k' (avall) o 'l'(dreta)] 
; Desplaçar els números i fer les parelles segons la direcció triada.
; Segons la tecla premuda, rotar la matriu cridant (rotateMatrix), per
; a poder fer els desplaçaments dels números cap a la dreta 
; (shiftNumbers), fer les parelles cap a la dreta (addPairs) i 
; tornar a desplaçar els nombres cap a la dreta (shiftNumbers) 
; amb les parelles fetes, després seguir rotant cridant (rotateMatrix) 
; fins deixar la matriu en la posició inicial. 
; Per a la tecla 'l' (dreta) no cal fer rotacions, per a la resta 
; s'han de fer 4 rotacions.
;    '<ESC>' (ASCII 27)  posar (state = '0') per a sortir del joc.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la 
; pantalla, per tant, caldrà actualitzar després el tauler cridant la 
; subrutina showMatrix.
;
; Variables globals utilitzades:
; (charac)   : Caràcter llegit de teclat.
; (state)    : Indica l'estat del joc. '0':sortir (ESC premut), '1':jugar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
onePlay:
   push rbp
   mov  rbp, rsp
   ; Mostrar matriu
   call showMatrix

   ; Llegir tecla
   call getch

   ; Comprovar tecla
   cmp BYTE [charac], 27  ; ESC
   je esc

   cmp BYTE [charac], 'i'  ; amunt
   je amunt
   cmp BYTE [charac], 'j'  ; esquerra
   je esquerra
   cmp BYTE [charac], 'k'  ; avall
   je avall
   cmp BYTE [charac], 'l'  ; dreta
   je dreta
   jmp OPfi

esc:
   mov BYTE [state], 0
   jmp OPfi

amunt:                 ; amunt: 1 rotació
   call rotateMatrix
   jmp fer_desplacaments

esquerra:              ; esquerra: 3 rotacions
   call rotateMatrix
   call rotateMatrix
   call rotateMatrix
   jmp fer_desplacaments

avall:                 ; avall: 2 rotacions
   call rotateMatrix
   call rotateMatrix
   jmp fer_desplacaments

dreta:                 ; dreta: 0 rotacions
   jmp fer_desplacaments

fer_desplacaments:
   ; Estat inicial
   mov BYTE [state], 1
   
   ; Desplaçar
   call shiftNumbers
   call addPairs
   call shiftNumbers
   
   ; Restaurar rotació
   cmp BYTE [charac], 'i'
   je restaurar_amunt
   cmp BYTE [charac], 'j'
   je restaurar_esquerra
   cmp BYTE [charac], 'k'
   je restaurar_avall
   jmp despres_restauracio

restaurar_amunt:      ; amunt: +3 rotacions (total 4)
   call rotateMatrix
   call rotateMatrix
   call rotateMatrix
   jmp despres_restauracio

restaurar_esquerra:   ; esquerra: +1 rotació (total 4)
   call rotateMatrix
   jmp despres_restauracio

restaurar_avall:      ; avall: +2 rotacions (total 4)
   call rotateMatrix
   call rotateMatrix
   jmp despres_restauracio

despres_restauracio:
   ; Guanyar?
   call gameWin
   cmp BYTE [state], 3
   je OPfi
   
   ; Inserir si hi ha hagut moviment
   cmp BYTE [state], 2
   jne OPfi
   call insertTile

OPfi:
   ; Mostrar matriu
   call showMatrix
   

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Joc del 2048
; Subrutina principal del joc
; Permet jugar al joc del 2048 cridant totes les funcionalitats.
;
; Pseudo codi:
; Inicialitzar estat del joc, (state='1')
; 
; Mentre (state) <> '0' i (state <> '3' 
;   Llegir una tecla (cridar la subrutina getch) i cridar a onePlay.
; Fi mentre.
; Mostra un missatge a sota del tauler segons el valor de la variable 
; (state). (cridar la funció printMessage_C).
; Sortir: 
; S'acabat el joc.
;
; Variables globals utilitzades:
; (state)    : Estat del joc.
;              '0': Sortir, hem premut la tecla 'ESC').
;              '1': Continuem jugant.
;              '2': Continuem jugant però s'han fet canvis a la matriu.
;			   '3': 2048
;			   '4': Taulell ple - Has perdut
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playGame:
   push rbp
   mov  rbp, rsp

 mov byte [state], 1

    PGbucle:
        call onePlay
        cmp byte [state], 0  ; ESC
        je PGfi
        cmp byte [state], 3  ; 2048
        je PGfi
        cmp byte [state], 4  ; tablero lleno
        je PGfi
        jmp PGbucle

    PGfi:
    ; printMessage_C se llama desde C



   
   
   mov rsp, rbp
   pop rbp
   ret
