format PE GUI 4.0
entry start
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'

section '.data' data readable writeable
    _class db 'Simple Window',0          ; ����� ����
    _title db '������ ���������',0       ; ��������� ����
    _error db '������',0                 ; ��������� �� ������

    ; ���������, ����������� ����� ����
    wc WNDCLASS 0,WindowProc,0,0,0,0,0,COLOR_BTNFACE+1,0,_class
    ; ���������, � ������� ����������� �������� ���������.
    msg MSG

    _classb db 'BUTTON',0                ; ����������� ����� BUTTON �� ������� �����������
    _textb db '��',0                     ; �����, ���������� �� ������1
    _textb2 db '���',0                   ; �����, ���������� �� ������2
    _classl db 'STATIC',0                ; ����������� ����� BUTTON �� ������� �����������.
    _textl db '������� ��',0             ; ����� � ����

section '.code' code readable executable
; ������� �������
start:
        invoke GetModuleHandle,0              ; ������� GetModule c ���������� ������ 0
                                              ; ���������� � EAX ������������� ���������� �� ������.
        ; ��������� �������� ��������� wc ������������ �������
        mov [wc.hInstance], eax               ; ������������� ������ ��������� � wc.hInstance
        invoke LoadIcon,0,IDI_APPLICATION     ; ������� LoadIcon � ������ ���������, ������ 0
                                              ; � ������ ����������, ������ ��������� IDI_APPLICATION
                                              ; ��������� � ����� ���� ����������� ������ ����������.
        mov [wc.hIcon],eax                    ; ������������� ������ ��������� � wc.hlcon
        invoke LoadCursor,0,IDC_ARROW         ; ��������� � ����� ���� ����������� ������ � ����� �������.
        mov [wc.hCursor],eax                  ; ������������� ������� ��������� � wc.hCursor.
        ; ���������������� �����
        invoke RegisterClass, wc              ; ������� ������� RegisterClass, �������
                                              ; � �������� ��������� ��������� �� ��������� wc,
                                              ; ���������� �������� ������ ����.
                                              ; ���� ������������ �������� ������� �� 0,
                                              ; �� ����� ������� ���������������.
        cmp eax,0                             ; �������� eax � 0,
        je  error                             ; � ������ ��������� ������� �� ����� ������.
        ; ������� ����
        invoke CreateWindowEx,0,_class,_title,\ ;
               WS_VISIBLE+WS_SYSMENU,\
               128,128,200,100,0,0,[wc.hInstance],0
        ; ���� ������������ �������� ������� �� 0,
        ; �� ���� ������� �������.
        cmp eax,0                             ; �������� eax � 0,
        je error                              ; � ������ ��������� ������� �� ����� ������.

        ; ���� ��������� ��������� - �������� ��������� � ����� �� WM_QUIT.
        msg_loop:
                invoke GetMessage,msg,NULL,0,0  ; �������� ���������.
                cmp eax,0                       ; ���� �������� WM_QUIT,
                je end_loop                     ; ��������� ���������.
        invoke TranslateMessage, msg                  ; ������������� ��������� ���� WM_KEYUP
                                                      ; � ��������� ���� WM_CHAR.
        invoke DispatchMessage, msg                   ; �������� ��������� ������� ���������.
        jmp msg_loop                                  ; ���������� ����.

        error:
                invoke MessageBox,0,_error,0,MB_ICONERROR+MB_OK       ; ������� ��������� �� ������

        end_loop:
                invoke ExitProcess,[msg.wParam]       ; ��������� ���������, ��������� ��
                                                      ; ��������� ������ ������� ���������

   proc WindowProc hwnd,wmsg,wparam,lparam
        push ebx esi edi                      ; ��������� �������� ��������� ebx esi edi � ����

        ; ��� �������� ���� �������� ��������� WM_CREATE
        cmp [wmsg],WM_CREATE
        je  .wmcreate           ; ���� ���������: ������� ���� -> ������� ����
                                ; ��� ������� �� ������ ���� �������� ��������� WM_COMMAND
        cmp [wmsg],WM_COMMAND
        je .wmcommand

        ; ���� �������� ��������� WM_DESTROY, ������� ��������, ��� ���� ������� � ������, ����� Alt+F4 ��� ������(�������)
        ; �� ��������� �� ����� .wmdestroy, ��� ����� ������� ������� PostQuitMessage.
        ; ���������� ������� PostQuitMessage �������� ��� ����������,
        ; ���� - ��������, ��� ��������� �������������� ��������� ������.
        cmp [wmsg],WM_DESTROY
        je  .wmdestroy

        .defwndproc:
            ; ���� �������� ������ ���������, ������� ��� ���������� �� ��������� � �����������,
            ; ������� ������������ WindowProc.
            invoke DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
            jmp .finish
        .wmcreate:
            invoke CreateWindowEx,0,_classb,_textb,\  ; ������� �� ������� ����
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; ������ � ��������������� 1001.
               10,40,60,20,[hwnd],1001,[wc.hInstance],NULL

            invoke CreateWindowEx,0,_classb,_textb2,\
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\
               80,40,60,20,[hwnd],1002,[wc.hInstance],NULL


            invoke CreateWindowEx,0,_classl,_textl,\
               WS_VISIBLE+WS_CHILD+SS_CENTER,\
               10,10,100,20,[hwnd],1003,[wc.hInstance],NULL
            jmp .finish

         .wmcommand:
               .wmdestroy:
                  invoke PostQuitMessage,0
                  mov eax,0
               .finish:
                  pop edi esi ebx
                  ret
    endp


section '.idata' import data readable writeable
        library kernel32, 'KERNEL32.DLL',\
                user32,   'USER32.DLL'
        include 'H:\Programming\assembler\FASM\INCLUDE\API\kernel32.inc'
        include 'H:\Programming\assembler\FASM\INCLUDE\API\user32.inc'