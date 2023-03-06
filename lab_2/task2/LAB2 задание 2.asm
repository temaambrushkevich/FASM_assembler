format PE CONSOLE
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'


entry start             ; Говорим windows в каком месте стартовать,
                        ; start - это метка
                        
; секция данных с неинициализированными переменными(не содержат никаких значений)
section '.data?' data readable writeable
   year    dd ?      ; dd - двойное слово
   ostatok dd ?
   
; Объявляются и определяются инициализируемые данные
section '.data' data readable
   msg1    db  'Enter year: ',0           ; db - байт
   msg2    db  "You entered: %d",10,0

; макрос(создание собственной инструкции), 
; препроцессор заменит встретившееся имя макроса на тело(между { и }) макроса
; Один аргумент - val
macro is_leap_year val {
   mov eax, [val]        ; Записываем в eax значение val
   
   mov ebx, 400         ; Записываем в ebx делитель
   mov edx, 0           ; Обнуляем регистр edx, в нем будет лежать остаток
   div ebx              ; Делим на 400
   mov [ostatok], edx   ; остаток от деления записываем в значение переменной ostatok
   mov eax, [ostatok]   ; в eax записываем остаток
   cmp eax, 0           ; сравниваем остаток с нулем
   je its_true          ; если остаток = 0 => переходим к метке its_true
    
   mov ebx, 100
   mov edx, 0       
   div ebx
   mov [ostatok], edx
   mov eax, [ostatok]
   cmp eax, 0
   je its_false         ; Если остаток = 0 => переходим к метке its_false
    
   mov ebx, 4
   mov edx, 0       
   div ebx
   mov [ostatok], edx
   mov eax, [ostatok]
   cmp eax, 0
   je its_true

   jne its_false        ; Если все условия проверились и не было переходов по меткам => год не високосный
}

; Процедура для ввода года.
; Принимает два аргумента: начальную фразу(приглашение) и фразу,
; которая будет подтверждать то, что ввел пользователь.
proc enter_year, msg1, msg2
   cinvoke printf, [msg1], 0        ; Вывод приглашения к вводу
   cinvoke scanf, '%d', year        ; ввод year
   mov   eax, [year]                ; Помещаем в регистр eax значение year
   cinvoke printf, [msg2], [year]   ; вывод введенного года
   ret
endp

; Секция, в которой происходят все действия
section '.code' code readable executable

start:
   ; stdcall - вызов процедуры с соглашениями вызова stdcall
   stdcall enter_year, msg1, msg2

   jmp .check_year                  ; безусловный переход к метке check_year

   .check_year:
      is_leap_year year

      its_true:
         cinvoke printf, "%d is a leap year", [year], 0   
         jmp exit_prog
      its_false:
         cinvoke printf, "%d it's NOT a leap year", [year], 0
         jmp exit_prog

   ; выход из программы     
   exit_prog:
      invoke  sleep, 10000       ; 10 sec. delay
      invoke  exit, 0            ; выход из программы
      ret



; Секция импорта
section '.idata' import data readable
 
   library msvcrt,'MSVCRT.DLL',\
         kernel32,'KERNEL32.DLL'
 
   import kernel32,\
         sleep,'Sleep'
 
 ; импорт Cи-шных функций
   import msvcrt,\
      scanf,'scanf',\
      printf,'printf',\
      exit,'exit'