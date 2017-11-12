.386
.model flat, stdcall
option casemap:none

include			windows.inc
include 		gdi32.inc 
includelib		gdi32.lib
include 		user32.inc 
includelib		user32.lib
include 		kernel32.inc 
includelib 		kernel32.lib

.data?
hInstance 		dd		?
hWinMain 		dd  	?

.data



.code
_ProcWinMain 	proc	uses ebx edi esi, hWnd, uMsg,wParam,lParam
		local	@stPs:PAINTSTRUCT
		local	@stRect:RECT
		local	@hDc
		
		mov	eax,uMsg
		.if	eax == WM_PAINT
			invoke	BeginPaint, hWnd, addr @stPs
			mov	@hDc, eax

			invoke	GetClientRect, hWnd, addr @stRect
			invoke	DrawText, @hDc, addr szText,-1,\
				addr @stRect, \
				DT_SINGALLINE or DT_CENTER or DT_VCENTER
			invoke	EndPaint, hWnd, addr @stPs
		.elseif	eax == WM_CLOSE
			invoke	DestroyWindow, hWinMain
			invoke	PostQuitMessage, NULL
		.else
			invoke	DefWindowProc, hWnd, uMsg, wParam, lParam
		.endif
		
		xor	eax,eax
		ret
_ProcWinMain	endp

_WinMain	proc
		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG

		invoke	GetModuleHandle, NULL
		mov 	hInstance, eax
		invoke`	RtlZeroMemory, addr @stWndClass, sizeof @stWndClass
;------------------------
;注册窗口类
;------------------------
		invoke 	LoadCursor, 0, IDC_ARROW
		mov	@stWndClass.hCursor,eax
		push	hInstance
		pop	@stWndClass.hInstance
		mov 	@stWndClass.cbSize, sizeof WNDCLASSEX
		mov    	@stWndClass.style, CS_HREDRAW or CS_VREDRAW
		mov  	@stWndClass.lpfnWndProc, offset _ProcWinMain
		mov 	@stWndClass.hbrBackground, COLOR_WINDOW + 1
		mov 	@stWndClass.lpszClassName, offset szClassName
		invoke	RegisterClassEx, addr @stWndClass
;-----------------------
;建立并显示窗口
;-----------------------
		invoke	CreateWindowEx, WS_EX_CLIENTEDGE, offset szClassName, offset szCaptionMain, WS_OVERLAPPEDWINDOW, 100, 100, 600, 400, NULL, NULL, hInstance, NULL
		mov 	hWinMain, 












