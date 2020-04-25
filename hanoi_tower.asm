.686

.model flat, stdcall

option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib 
include \masm32\macros\macros.asm
.data
array DWORD 128 dup(0)
count1 DWORD -1

count2 DWORD 127

teste DWORD 0

write_count DWORD 0 ;Variavel para armazenar caracteres escritos na console
handle_out DWORD ?
handle_in DWORD ?


count DWORD -1
output db ?
entrada DWORD ?
tam_string DWORD ?
str_read DWORD 0

cont DWORD -1

de_str db "Write the number of discs: ",0h
para_str db " para ",0h
pula_str db ", ",0h
value dd 0
valor dd 0
string DWORD 0


;============================================================================================================================================================================

.code

hanoi_func:

push ebp
mov ebp, esp

cmp DWORD PTR[ebp+8], 1;quantidade de discos
je dIgual

mov eax,DWORD PTR[ebp+8]
dec eax ;decrementa o numero de discos para poder fazer o movimento
;mov DWORD PTR[ebp+8], eax ;move o numero de discos do registrador para a pilha


push DWORD PTR[ebp+20] ;origem
push DWORD PTR[ebp+12] ;destino->auxiliar
push DWORD PTR[ebp+16] ;auxiliar->destino
push eax ;atualiza o numero de discos na pilha

call hanoi_func


inc count1 ;incrementa o contador

mov eax,DWORD PTR[ebp+20] ;move a origem para o registrador
mov ebx,DWORD PTR[ebp+16] ;move o destino para o registrador 
mov ecx, count1 ;move o valor do contador para o registrador

push eax
push ebx
push ecx



mov array[ecx*4], eax ;move o conteudo do registrador para uma posicao no array
inc count1  ;incrementa o contador1
mov ecx, count1 ;move o valor do contador para o registrador
mov array[ecx*4], ebx ;move o conteudo do registrador para uma posicao no array

pop ecx
pop ebx
pop eax


mov eax,DWORD PTR[ebp+8]
dec eax ;decrementa o numero de discos para poder fazer o movimento
;mov DWORD PTR[ebp+8], eax ;move o numero de discos do registrador para a pilha

push DWORD PTR[ebp+12] ;origem->auxiliar
push DWORD PTR[ebp+16] ;destino
push DWORD PTR[ebp+20] ;auxiliar->origem
push eax;atualiza o numero de discos da pilha

call hanoi_func

mov esp, ebp
pop ebp
ret


dIgual:

inc count1 ;incrementa o contador

mov eax, DWORD PTR[ebp+20]
mov ebx, DWORD PTR[ebp+16]
mov ecx, count1

push eax
push ebx
push ecx

mov array[ecx*4], eax
inc count1
mov ecx, count1
mov array[ecx*4], ebx

pop ecx
pop ebx
pop eax






mov esp, ebp
pop ebp
ret
;============================================================================================================================================================================
igualZero:
printf(" The function doesnt work with 0 discs.")
jmp acabar
ret

;============================================================================================================================================================================
maiorQ6:
printf("The function doesnt work above 6 discs.")
jmp acabar
ret

start:


push STD_INPUT_HANDLE
call GetStdHandle
mov handle_in, eax

printf("Write the number of discs: ")

invoke ReadConsole, handle_in, addr entrada,1, addr str_read, NULL
sub entrada,48; transforma de uma forma bem bruta para o valor desejado


push STD_OUTPUT_HANDLE
call GetStdHandle
mov handle_out, eax

cmp entrada,0
jbe igualZero

cmp entrada,6
ja maiorQ6



push 1;origem
push 3;destino
push 2;aux
;push 6
push entrada



call hanoi_func


add esp, 16
pular:
push -1



percorrer:
dec count2
mov ecx, count2
cmp array[ecx*4],0
je pular
push array[ecx*4]
mov teste, eax
cmp teste, 0
je percorrer
cmp count2,0
jne percorrer



printar:
pop eax
mov value,eax
invoke dwtoa, value, addr output
invoke StrLen, addr output
mov tam_string, eax
cmp value,-1
je acabar
invoke WriteConsole, handle_out, addr output,tam_string, addr write_count, NULL
invoke WriteConsole, handle_out, addr pula_str,sizeof pula_str, addr write_count, NULL
inc cont
cmp cont,127
jne printar


acabar:
invoke ExitProcess, 0

end start