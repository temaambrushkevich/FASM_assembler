format PE CONSOLE
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'


entry start             ; Говорим windows в каком месте стартовать, 
                        ; start - это метка

; секция данных с неинициализированными переменными(не содержат никаких значений)
section '.data?' data readable writeable
   ; dd - double word (двойное слово)
   A    dd ?
   B    dd ?
   C    dd ?
   D    dd ?

; Объявляются и определяются инициализируемые данные
section '.data' data readable
   answ    db  'A+B+1 = %d',0

; Секция, в которой происходят все действия
section '.code' code readable executable

; макрос(создание собственной инструкции), 
; препроцессор заменит встретившееся имя макроса на тело(между { и }) макроса
macro mov_zero op1 {
    mov op1,0
}

; процедура с двумя параметрами
proc add2val, val1, val2
    mov eax,[val1]   ; Записываем в eax значение val1
    add eax,[val2]   ; Прибавляем к eax значение val2
                     ; Т.е. по факту складываем val1 и val2
    ret       ; выход из процедуры
endp

start:
     ; cinvoke - использовать внешнюю функцию с переменным кол-вом параметров
     cinvoke puts,    'Enter A ', 0   ; Вывод на экран текста      
     cinvoke scanf,   '%d', A    ;  ввод A
     cinvoke printf,  'Enter B ', 0   ; Вывод на экран текста
     cinvoke scanf,   '%d', B    ;  ввод B

     mov eax,[A]    ; помещаем в eax A
     add eax,[B]    ; Прибавляем к eax B
     lea ebx,[eax]  ; lea вычисляет эффективный(текущий) адрес eax и помещает его в ebx
     xchg ecx,ebx   ; меняем местами значение операндов ecx и ebx
     inc  ecx       ; инкремент(увеличение на 1) регистра ecx

     mov [C],ecx    ; Запись в C адреса регистра ecx
     cinvoke printf, answ, [C], 0    ; вызов внешней функции printf (строка с форматированием)
                                     ; и передача трех аргументов
                                     ; (Вывод результата выражения A+B+1)

     mov eax,[A]     ; Помещаем в eax значение A
     mov ebx,[B]     ; Помещаем в ebx значение B
     imul ebx, eax   ; перемножение A и B с учетом знака
     cinvoke printf, '  mull = %d   ', ebx,0    ; вывод результата умножения

     mov edx, [C]    ; Помещаем в регистр edx значение C
     mov_zero ecx    ; помещаем 0 в ecx

     ; цикла с условием выхода
     .repeat         ; выполняем код до тех пор, пока условие не станет истинным
        add edx,10   ; прибавляем к edx 10
        inc ecx      ; инкремент ecx
     .until edx>130  ; до какого момента повторять (т.е. условие выхода из цикла)

     mov [D],ecx     ; помещаем в D значение регистра ecx

     cinvoke printf, ' D  %d  ' , [D],0    ; вывод значения D

     mov_zero ebx    ; в ebx записываем 0
     cinvoke printf, 'mov_zero   %d  ' , ebx,0  ; вывод значения регистра ebx

     stdcall add2val, 10, 2      ; вызов процедуры add2val, результат записывается в регистр eax
                                 ; (сложение двух чисел, 10 и 2)
     cinvoke printf, ' add2reg  %d  ' , eax,0     ; вывод результата работы процедуры add2val



     invoke  sleep, 50000     ; 50 sec. delay

     invoke  exit, 0          ; выход из программы
     ret


; Секция импорта
section '.idata' import data readable
 
 library msvcrt,'MSVCRT.DLL',\
    kernel32,'KERNEL32.DLL'
 
 import kernel32,\
    sleep,'Sleep'
 
 ; импорт Cи-шных функций
 import msvcrt,\
    puts,'puts',\
    scanf,'scanf',\
    printf,'printf',\
    exit,'exit'
