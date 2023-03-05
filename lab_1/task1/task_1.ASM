format PE GUI 4.0
entry start
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'

section '.data' data readable writeable
    _class db 'Simple Window',0          ; Класс окна
    _title db 'Первая программа',0       ; Заголовок окна
    _error db 'Ошибка',0                 ; Сообщение об ошибке

    ; Стурктура, описывающая класс окна
    wc WNDCLASS 0,WindowProc,0,0,0,0,0,COLOR_BTNFACE+1,0,_class
    ; Структура, в которую сохраняются элементы сообщения.
    msg MSG

    _classb db 'BUTTON',0                ; Стандартный класс BUTTON не требует регистрации
    _textb db 'ДА',0                     ; Текст, написанный на кнопке1
    _textb2 db 'НЕТ',0                   ; Текст, написанный на кнопке2
    _classl db 'STATIC',0                ; Стандартный класс BUTTON не требует регистрации.
    _textl db 'Нажмите Да',0             ; текст в окне

section '.code' code readable executable
; Главная функция
start:
        invoke GetModuleHandle,0              ; Функция GetModule c параметром равным 0
                                              ; возвращает в EAX идентификатор вызвавшего ее модуля.
        ; Заполнить элементы структуры wc необходимыми данными
        mov [wc.hInstance], eax               ; Идентификатор модуля поместить в wc.hInstance
        invoke LoadIcon,0,IDI_APPLICATION     ; Функция LoadIcon с первым параметро, равным 0
                                              ; и вторым параметром, равным константе IDI_APPLICATION
                                              ; загружает в класс окна стандартную иконку приложения.
        mov [wc.hIcon],eax                    ; Идентификатор иконки поместить в wc.hlcon
        invoke LoadCursor,0,IDC_ARROW         ; Загружает в класс окна стандартный курсор в форме стрелки.
        mov [wc.hCursor],eax                  ; Идентификатор курсора поместить в wc.hCursor.
        ; Зарегистрировать класс
        invoke RegisterClass, wc              ; Вызвать функцию RegisterClass, передав
                                              ; в качестве параметра указатель на структуру wc,
                                              ; содержащую описание класса окна.
                                              ; Если возвращаемое значение отлично от 0,
                                              ; то класс успешно зарегистрирован.
        cmp eax,0                             ; сравнить eax и 0,
        je  error                             ; в случае равенства перейти на метку ошибки.
        ; Создать окно
        invoke CreateWindowEx,0,_class,_title,\ ;
               WS_VISIBLE+WS_SYSMENU,\
               128,128,200,100,0,0,[wc.hInstance],0
        ; Если возвращаемое значение отлично от 0,
        ; то окно успешно создано.
        cmp eax,0                             ; Сравнить eax и 0,
        je error                              ; в случае равенства перейти на метку ошибки.

        ; Цикл обработки сообщений - проверка сообщений и выход по WM_QUIT.
        msg_loop:
                invoke GetMessage,msg,NULL,0,0  ; Получить сообщение.
                cmp eax,0                       ; Если получено WM_QUIT,
                je end_loop                     ; Завершить программу.
        invoke TranslateMessage, msg                  ; Преобразовать сообщения типа WM_KEYUP
                                                      ; в сообщения типа WM_CHAR.
        invoke DispatchMessage, msg                   ; Передать сообщение оконной процедуре.
        jmp msg_loop                                  ; Продолжить цикл.

        error:
                invoke MessageBox,0,_error,0,MB_ICONERROR+MB_OK       ; Вывести сообщение об ошибке

        end_loop:
                invoke ExitProcess,[msg.wParam]       ; Завершить программу, возвратив ОС
                                                      ; результат работы оконной процедуры

   proc WindowProc hwnd,wmsg,wparam,lparam
        push ebx esi edi                      ; Поместить значения регистров ebx esi edi в стек

        ; При создании окно получает сообщение WM_CREATE
        cmp [wmsg],WM_CREATE
        je  .wmcreate           ; если сообщение: создать окно -> создаем окно
                                ; При нажатии на кнопку окно получает сообщение WM_COMMAND
        cmp [wmsg],WM_COMMAND
        je .wmcommand

        ; Если получили сообщение WM_DESTROY, которое означает, что окно удалили с экрана, нажав Alt+F4 или кнопку(крестик)
        ; то переходим на метку .wmdestroy, где будет вызвана функция PostQuitMessage.
        ; Параметром функции PostQuitMessage является код завершения,
        ; ноль - означает, что программа самостоятельно завершает работу.
        cmp [wmsg],WM_DESTROY
        je  .wmdestroy

        .defwndproc:
            ; Если получено другое сообщение, вызвать его обработчик по умолчанию с параметрами,
            ; которые передавались WindowProc.
            invoke DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
            jmp .finish
        .wmcreate:
            invoke CreateWindowEx,0,_classb,_textb,\  ; Создать на главном окне
               WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1001.
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