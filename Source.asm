.586P
;плоская модель памяти
.MODEL FLAT, stdcall
;------------------------------------------------
include C:\Users\aaa\Desktop\Assember\button_ex\macros.inc
includelib C:\Users\aaa\Desktop\Assember\button_ex\kernel32.lib
includelib C:\Users\aaa\Desktop\Assember\button_ex\user32.lib
;------------------------------------------------
;сегмент данных
_DATA SEGMENT
NEWHWND DWORD 0
MSG MSGSTRUCT <?>
WC WNDCLASS <?>
wc1 wndclassex <?>
PNT PAINTSTR <?>

pt point <?>

rc	RECT1		<?>
HINST DWORD 0


hRgnClip dd  ?
hRgn1	dd ?
hRgn2	dd ?
hRgn3	dd ?
hRgn4	dd ?

mash_Y      dd   1000000

WndName	db	'Button example',0
class_name	db	'Simple Window',0
_err1 db 'Error!',0

QuitButton	db	'Exit',0
ButtonClass	db	'Button',0
win_proc    db    "dd",0
edit_class  db    "Edit",0

HFieldA             dd      ?
HFieldB             dd      ?
HQuitButton		  dd	    ?
cont dd ?

_c_0		dd		?

_gg_0		dd		0

_cc_1		dd		0


_pol_1	dd   10 dup (?)
_pol_2	dd   10 dup (?)
_pol_3	dd   10 dup (?)

TITLENAME BYTE 'Графика в окне',0
NAM BYTE 'CLASS32',0
XT DWORD 30
YT DWORD 30
XM DWORD ?
YM DWORD ?
HDC DWORD ?
MEMDC DWORD ?
HPEN DWORD ?
HBRUSH DWORD ?	
HBRUSH1 DWORD ?

HBRUSH_1 DWORD ?
HBRUSH_2 DWORD ?
HBRUSH_3 DWORD ?


P DWORD 0 ; признак вывода
XP DWORD ?
YP DWORD ?

_DATA ENDS

_TEXT SEGMENT


START:
;получить дескриптор приложения
	PUSH 0
	CALL GetModuleHandle
	MOV HINST, EAX
	REG_CLASS:
;заполнить структуру окна
;стиль
	MOV WC.CLSSTYLE,stylcl
;процедура обработки сообщений
	MOV WC.CLSLPFNWNDPROC,OFFSET WNDPROC
	MOV WC.CLSCBCLSEXTRA,0
	MOV WC.CLSCBWNDEXTRA,0
	MOV EAX,HINST
	MOV WC.CLSHINSTANCE,EAX
;----------пиктограмма окна
	PUSH IDI_APPLICATION
	PUSH 0
	CALL LoadIcon
	MOV [WC.CLSHICON], EAX
;----------курсор окна
	PUSH IDC_CROSS
	PUSH 0
	CALL LoadCursor
	MOV WC.CLSHCURSOR, EAX
;----------
	PUSH 0ffffffh ;цвет кисти
	CALL CreateSolidBrush ;создать кисть
	MOV WC.CLSHBRBACKGROUND,EAX
	MOV DWORD PTR WC.MENNAME,0

	MOV DWORD PTR WC.CLSNAME,OFFSET NAM
	PUSH OFFSET WC
	CALL RegisterClass
;создать окно зарегистрированного класса
	PUSH 0
	PUSH [HINST]
	PUSH 0
	PUSH 0
	PUSH DY0 ; DY0 - высота окна
	PUSH DX0 ; DX0 - ширина окна
	PUSH 100 ; координата Y
	PUSH 100 ; координата X
	PUSH WS_OVERLAPPEDWINDOW
	PUSH OFFSET TITLENAME ; имя окна
	PUSH OFFSET NAM ; имя класса
	PUSH 0
	CALL CreateWindowEx
	;проверка на ошибку
	CMP EAX,0
	JZ _ERR
	MOV NEWHWND, EAX ; дескриптор окна
;----------------------------------
	PUSH SW_SHOWNORMAL
	PUSH NEWHWND
	CALL ShowWindow ; показать созданное окно
;----------------------------------
	PUSH NEWHWND
	CALL UpdateWindow ; перерисовать видимую часть окна
;цикл обработки сообщений
	MSG_LOOP:
	PUSH 0
	PUSH 0
	PUSH 0
	PUSH OFFSET MSG
	CALL GetMessage
	CMP AX, 0
	JE END_LOOP
	PUSH OFFSET MSG
	CALL TranslateMessage
	PUSH OFFSET MSG
	CALL DispatchMessage
	JMP MSG_LOOP
	END_LOOP:
;выход из программы (закрыть процесс)
	PUSH MSG.MSWPARAM
	CALL ExitProcess

_ERR:
	JMP END_LOOP





WNDPROC PROC

	wp_hWnd equ [EBP+8H]
	wp_lparam equ [EBP+014H]
	wp_wparam equ [EBP+10H]


	PUSH EBP
	MOV EBP,ESP
	PUSH EBX
	PUSH ESI
	PUSH EDI
	CMP DWORD PTR [EBP+0CH],WM_DESTROY
	JE WMDESTROY
	CMP DWORD PTR [EBP+0CH],WM_CREATE
	JE WMCREATE
	CMP DWORD PTR [EBP+0CH],WM_PAINT
	JE WMPAINT
	CMP DWORD PTR [EBP+0CH],WM_LBUTTONDOWN
	JE LBUTTON
	CMP DWORD PTR [EBP+0CH],WM_LBUTTONUP
	JE LBUTTONUP
	CMP DWORD PTR [EBP+0CH],WM_MOUSEMOVE
	JE MOUSEMOVE
	CMP DWORD PTR [EBP+0CH],WM_COMMAND
	JE WM_COM
	
	CMP DWORD PTR [EBP+0CH],WM_SIZE
	JE size_proc
	
	CMP DWORD PTR [EBP+0CH],WM_SIZING
	JE sizing_proc
	
	xor eax, eax
	
	
	JMP FINISH
	
size_proc:
	
	jmp finish




sizing_proc:

	

	JMP FINISH
	
LBUTTON:
	mov _c_0, 1
	mov _cc_1, 1
	
	JMP FINISH
	
LBUTTONUP:
	mov _c_0, 0
	mov _cc_1, 0
	
	PUSH 0
	PUSH OFFSET RECT
	PUSH DWORD PTR [EBP+08H]
	CALL InvalidateRect
	
	JMP FINISH
	
WMPAINT:

	cmp _gg_0, 0
	je _cc_01

	PUSH OFFSET PNT
	PUSH DWORD PTR [EBP+08H]
	CALL BeginPaint
	MOV CONT,EAX ; сохранить контекст (дескриптор)
	
	PUSH 0 
	CALL GetSystemMetrics
	MOV XM,EAX
	
	PUSH 1 
	CALL GetSystemMetrics
	MOV YM,EAX


	PUSH 000ffffh
	CALL CreateSolidBrush ;создать кисть желтого цвета
	MOV HBRUSH,EAX
	

	PUSH HBRUSH
	PUSH CONT
	CALL SelectObject
	
	PUSH 0ffffffh
	CALL CreateSolidBrush ;создать кисть белого цвета
	MOV HBRUSH1,EAX
	
    ; закрашиваем нарисованный ранее круг белым цветом

    invoke FillRgn, cont, hRgn2, hBrush1
    
    mov eax, pt.x
	mov ebx, pt.y
	
	add eax, 100
	add ebx, 100

; если ЛКМ нажата, то рисуем круг с координатами, совпадающими с координатами курсора мыши.

	cmp _cc_1, 0
	je _kk_pp_04

	push ebx
	push eax
	push pt.y
	push pt.x
	call CreateEllipticRgn
	mov hRgn2, eax
	
	jmp _kk_pp_05
	
_kk_pp_04:

; если ЛКМ не нажата, то рисуем круг с координатами 200, 700, 100, 600.

 
	push 200
	push 700
	push 100
	push 600
	call CreateEllipticRgn
	mov hRgn2, eax
 
_kk_pp_05:
	
	invoke FillRgn, cont, hRgn2, hBrush   ;invoke вызов функции аналогично call

; цвета
	
; 00000ffh  - красный
; 000ff00h  - зеленый
; 0ffff00h  - голубой
; 000ffffh  - желтый

	PUSH 00000ffh
	CALL CreateSolidBrush ;создать кисть
	MOV HBRUSH_1,EAX
	
	PUSH 0ffff00h
	CALL CreateSolidBrush ;создать кисть
	MOV HBRUSH_2,EAX
	
	PUSH 000ff00h
	CALL CreateSolidBrush ;создать кисть
	MOV HBRUSH_3,EAX

; 00000ffh  - красный
; 000ff00h  - зеленый
; 0ffff00h  - голубой
; 000ffffh  - желтый
	
	
	push hBrush
	push hRgn2
	push cont
	call FillRgn
	
		
	push 00000ffh
	push 2
	push 1
	call CreatePen
	mov hpen, eax
	
	PUSH HPEN
	PUSH CONT
	CALL SelectObject
	
	
	
	push hbrush_1
	push hRgn1
	push cont
	call FillRgn
	
	
	push hbrush_3
	push hRgn3
	push cont
	call FillRgn
	
	push hbrush_2
	push hRgn4
	push cont
	call FillRgn
	
	


;---------------- закрыть контекст
	PUSH OFFSET PNT
	PUSH DWORD PTR [EBP+08H]
	CALL EndPaint
	MOV EAX, 0


_cc_01:

	JMP FINISH

WMCREATE:

	push offset rc
	push [EBP+8]
	call GetClientRect
	
	PUSH 0 
	CALL GetSystemMetrics
	MOV XM,EAX
	
	PUSH 1 
	CALL GetSystemMetrics
	MOV YM,EAX


	mov eax,rc.bottom
	sub eax,rc.top
	shr eax,1
	sub eax,10
	mov rc.top,eax
	mov eax,20
	mov rc.bottom,eax

	mov eax,rc.right
	sub eax,rc.left
	shr eax,1
	sub eax,25
	mov rc.left,eax
	mov eax,50

	mov ebx, 0
	push ebx
	push wc1.hInstance
	push ID_BUTTON
	push [EBP+8]
	push rc.bottom
	push eax
	push rc.top
	push rc.left
	push WS_VISIBLE or WS_CHILD or WS_BORDER
	push offset QuitButton
	push offset ButtonClass
	push ebx
	call CreateWindowEx
	mov HQuitButton,eax


	
	
	mov ecx, 04h
	
	mov eax, 650
	mov [_pol_1], eax
	
	mov eax, 200
	mov [_pol_1+ecx], eax
	add ecx, 04h
	
	mov eax, 600
	mov [_pol_1+ecx], eax
	add ecx, 04h
	
	mov eax, 300
	mov [_pol_1+ecx], eax
	add ecx, 04h
	
	mov eax, 700
	mov [_pol_1+ecx], eax
	add ecx, 04h
	
	mov eax, 300
	mov [_pol_1+ecx], eax
	
	push 1
	push 3
	push offset _pol_1
	call CreatePolygonRgn
	mov hRgn1, eax
	
	
	mov ecx, 04h
	
	mov eax, 700
	mov [_pol_2], eax
	
	mov eax, 200
	mov [_pol_2+ecx], eax
	add ecx, 04h
	
	mov eax, 750
	mov [_pol_2+ecx], eax
	add ecx, 04h
	
	mov eax, 200
	mov [_pol_2+ecx], eax
	add ecx, 04h
	
	mov eax, 750
	mov [_pol_2+ecx], eax
	add ecx, 04h
	
	mov eax, 300
	mov [_pol_2+ecx], eax
	add ecx, 04h
	
	mov eax, 700
	mov [_pol_2+ecx], eax
	add ecx, 04h
	
	mov eax, 300
	mov [_pol_2+ecx], eax
	
	
	push 1
	push 4
	push offset _pol_2
	call CreatePolygonRgn
	mov hRgn3, eax
	
	mov ecx, 04h
	
	mov eax, 550
	mov [_pol_3], eax
	
	mov eax, 200
	mov [_pol_3+ecx], eax
	add ecx, 04h
	
	
	mov eax, 600
	mov [_pol_3+ecx], eax
	add ecx, 04h
	
	mov eax, 200
	mov [_pol_3+ecx], eax
	add ecx, 04h

	
	mov eax, 600
	mov [_pol_3+ecx], eax
	add ecx, 04h
	
	mov eax, 300
	mov [_pol_3+ecx], eax
	add ecx, 04h
	
	mov eax, 550
	mov [_pol_3+ecx], eax
	add ecx, 04h
	
	mov eax, 300
	mov [_pol_3+ecx], eax
	add ecx, 04h
	
	push 1
	push 4
	push offset _pol_3
	call CreatePolygonRgn
	mov hRgn4, eax
	

	JMP FINISH
	
WM_COM:

	mov eax, [EBP+014H]
	cmp eax, HQuitButton
	jne p1

	
	mov _gg_0, 1
	
	PUSH 0
	PUSH OFFSET RECT
	PUSH DWORD PTR [EBP+08H]
	CALL InvalidateRect
	

p1:


	

	JMP FINISH
	
MOUSEMOVE:

	cmp _c_0, 0
	je c__1

	PUSH OFFSET PT
    CALL GetCursorPos@4
    
	

    
    PUSH 0
	PUSH OFFSET RECT
	PUSH DWORD PTR [EBP+08H]
	CALL InvalidateRect
	
	
	

c__1:

	JMP FINISH
	
	
	
	
WMDESTROY:
;удалить перо
	PUSH HPEN
	CALL DeleteDC
;удалить кисть
	PUSH HBRUSH
	CALL DeleteDC
;удалить виртуальное окно
	PUSH MEMDC
	CALL DeleteDC
	
	PUSH 0
	CALL PostQuitMessage ;WM_QUIT
	MOV EAX, 0
	



FINISH:
	PUSH DWORD PTR [EBP+14H]
	PUSH DWORD PTR [EBP+10H]
	PUSH DWORD PTR [EBP+0CH]
	PUSH DWORD PTR [EBP+08H]
	CALL DefWindowProcA@16

	POP EDI
	POP ESI
	POP EBX
 
	POP EBP
	RET 16

WNDPROC ENDP
_TEXT ENDS
END START
