format PE GUI 4.0
entry start
include 'H:\Programming\assembler\FASM\INCLUDE\win32a.inc'

section '.data' data readable writeable
  _class db 'Simple Window',0  ; Класс окна.
  _title db 'ОКНО',0   ; Заголовок окна.
  _error db 'Ошибка',0         ; Сообщение об ошибке.
  
  wc WNDCLASS 0,WindowProc,0,0,0,0,0,COLOR_BTNFACE+1,0,_class   ; Структура, описывающая класс окна.
    ; wc – указатель на первый байт структуры данных, созданной в соответствии с шаблоном WNDCLASS.
    ; Элементам структуры wc присваиваются соответствующие значения, разделенные запятыми.
    
  msg MSG     ; Структура, в которую сохраняются элементы сообщения.
              ; msg – указатель на первый байт структуры данных, созданной в соответствии с шаблоном MSG.
              ; Значения элементов структуры msg считаются неопределенными.
              
  _classb1 db 'BUTTON',0    ; Стандартный класс BUTTON не требует регистрации.
  _textb1 db 'КНОПКА А',0         ; Текст, написанный на кнопке.
  _classb2 db 'BUTTON',0   ; Стандартный класс BUTTON не требует регистрации.
  _textb2 db 'КНОПКА B',0       ; Текст, написанный на кнопке.
  _classb3 db 'BUTTON',0    ; Стандартный класс BUTTON не требует регистрации.
  _textb3 db 'КНОПКА C',0         ; Текст, написанный на кнопке.
  _classb4 db 'BUTTON',0   ; Стандартный класс BUTTON не требует регистрации.
  _textb4 db 'КНОПКА D',0       ; Текст, написанный на кнопке.
    
  _classl db 'STATIC',0    ; Стандартный класс STATIC (надпись)
  _textl db 'название',0   ; Текст, написанный на кнопке.

section '.code' code readable executable
; Главная функция.
start:
  invoke GetModuleHandle,0  ; Функция GetModuleHandle с параметром равным 0
  ; возвращает в eax идентификатор вызвавшего ее модуля.
  ; Заполнить элементы структуры wc необходимыми данными.
  mov [wc.hInstance],eax ; Идентификатор модуля поместить в wc.hInstance.
  ; Функция LoadIcon, загружает в класс окна иконку клоуна.
  invoke LoadIcon,[wc.hInstance],IDI_MAIN

  mov [wc.hIcon],eax ; Идентификатор иконки поместить в wc.hIcon.
  invoke LoadCursor,0,IDC_ARROW ; Функция LoadCursor с первым параметром равным 0
                                ; и вторым параметром, равным константе IDC_ARROW
  ; загружает в класс окна стандартный курсор в форме стрелки.
  mov [wc.hCursor],eax ; Идентификатор курсора поместить в wc.hCursor.

  ; Зарегистрировать класс.
  invoke RegisterClass,wc ; Вызвать функцию RegisterClass,
           ; передав в качестве параметра указатель на структуру wc,
           ; содержащую описание класса окна.
           ; Если возвращаемое значение отлично от 0,
           ; то класс успешно зарегистрирован.
  cmp eax,0   ; Сравнить eax и 0,
  je error    ; в случае равенства перейти на метку ошибки.
           
  ; Создать окно.
  invoke CreateWindowEx,0,_class,_title,\ ;
        WS_VISIBLE+WS_SYSMENU,\
        128,128,256,192,0,0,[wc.hInstance],0
  ; Если возвращаемое значение отлично от 0,
  ; то окно успешно создано.
  cmp eax,0  ; Сравнить eax и 0,
  je error   ; в случае равенства перейти на метку ошибки.
  
  ;Цикл обработки сообщений – проверка сообщений и выход по WM_QUIT.
  msg_loop:
    invoke GetMessage,msg,NULL,0,0 ; Получить сообщение.
    cmp eax,0 ; Если получено WM_QUIT,
    je end_loop ; завершить программу.
  invoke TranslateMessage,msg   ; Преобразовать сообщения типа WM_KEYUP
                                ; в сообщения типа WM_CHAR.
  invoke DispatchMessage,msg    ; Передать сообщение оконной процедуре.
  jmp msg_loop   ; Продолжить цикл.
  error:
    invoke MessageBox,0,_error,0,MB_ICONERROR+MB_OK ; Вывести сообщение об ошибке.
  end_loop:
    invoke ExitProcess,[msg.wParam] ; Завершить программу,
               ; возвратив операционной системе
               ; результат работы оконной процедуры.
               ; Оконная процедура WindowProc.
               ; Вызывается каждый раз при получении окном нового сообщения и передаче его через DispatchMessage.
               ; Процедура обработки сообщений WindowProc вызывается со следующими параметрами:
               ; hwnd – идентификатор окна-получателя сообщения,
               ; wmsg – код сообщения,
               ; wparam – первый параметр, определяющий дополнительные данные, связанные с сообщением.
               ; lparam – второй параметр, определяющий дополнительные данные, связанные с сообщением.
  proc WindowProc hwnd,wmsg,wparam,lparam
    push ebx esi edi
      ; При создании окно получает сообщение WM_CREATE.
    cmp [wmsg],WM_CREATE
    je .wmcreate
    ; При нажатии на кнопку окно получает сообщение WM_COMMAND.
    cmp [wmsg],WM_COMMAND
    je .wmcommand
    cmp [wmsg],WM_DESTROY
    je .wmdestroy
    .defwndproc:
      invoke DefWindowProc,[hwnd],[wmsg],[wparam],[lparam]
      jmp .finish
    .wmcreate:
      invoke CreateWindowEx,0,_classb1,_textb1,\  ; Создать на главном окне
              WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1001.
              10,10,80,50,[hwnd],1001,[wc.hInstance],NULL

      invoke CreateWindowEx,0,_classb2,_textb2,\ ; Создать на главном окне
              WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1002.
              90,10,80,50,[hwnd],1002,[wc.hInstance],NULL
               
      invoke CreateWindowEx,0,_classb3,_textb3,\ ; Создать на главном окне
              WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1003.
              10,60,80,50,[hwnd],1003,[wc.hInstance],NULL
               
      invoke CreateWindowEx,0,_classb4,_textb4,\ ; Создать на главном окне
              WS_VISIBLE+WS_CHILD+BS_PUSHBUTTON,\    ; кнопку с идентификатором 1004.
              90,60,80,50,[hwnd],1004,[wc.hInstance],NULL


  jmp .finish
                  ; Если получили WM_COMMAND от кнопки, то wparam содержит
                  ; в старших двух байтах константу BN_CLICKED=0 (кликнута кнопка)
                  ; и в младших двух байтах идентификатор кнопки 1001,
                  ; можно считать, что весь wparam содержит идентификатор кнопки.
    .wmcommand:
      ; Определить нажатие кнопки,
      ; сравнивая значение wparam с 1001.
      cmp [wparam],1001 ; Если кнопка 'КНОПКА A' нажата,
      jz .btn1          ; то обработать ее событие,
      cmp [wparam],1002 ; Если кнопка 'КНОПКА B' нажата,
      jz .btn2          ; то обработать ее событие,
      cmp [wparam],1003 ; Если кнопка 'КНОПКА C' нажата,
      jz .btn3          ; то обработать ее событие,
      cmp [wparam],1004 ; Если кнопка 'КНОПКА D' нажата,
      jz .btn4          ; то обработать ее событие,
      jne .finish       ; если ни одна кнопка не нажата, то выйти из процедуры
               
      ; Обработка нажатий на кнопки
      .btn1:            
        invoke MessageBox,[hwnd],_textb1,_title,0  ;  показать MessageBox.
        jmp .finish
      .btn2:            
        invoke MessageBox,[hwnd],_textb2,_title,0 
        jmp .finish
      .btn3:
        invoke MessageBox,[hwnd],_textb3,_title,0  ;  
        jmp .finish
      .btn4:
        invoke MessageBox,[hwnd],_textb4,_title,0  ;  
        jmp .finish    
               
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
    
section '.rsrc' resource data readable
IDI_MAIN=10
  ; Определение типа ресурсов
    ; Иконкам выделено два типа ресурсов: 
    ; RT_ICON - тип отдельной иконки
    ; RT_GROUP_ICON - тип ресурса, связанного с одним или несколькими ресурсами типа RT_ICON.
    directory RT_ICON, icons,\
              RT_GROUP_ICON, group_icons
  ; Объявление поддиректорий.
    resource group_icons,\        ; Группа иконок
              IDI_MAIN, LANG_NEUTRAL, main_icon
    resource icons,\              ; Отдельная иконка
              1, LANG_NEUTRAL, main_icon_data
  ; Объявление ресурсов.
  ; Группа иконок содержит единственную иконку,
  ; поэтому задаем только одну пару параметров.
    icon main_icon, main_icon_data, 'H:\Programming\assembler\FASM\INCLUDE\MACRO\клоун.ico'