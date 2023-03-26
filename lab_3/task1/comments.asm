format PE CONSOLE
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'

entry start


section '.data?' data readable writeable
   x1 dd 6 dup(?)       ; dup - для инициализации массива одинаковыми значениями, эквивалентно ?,?,?,?,?,?.
   size_x1 = $-x1       ; вычисляем размер массива, $ - взять текущий адрес
   x2 dw 6 dup(?)
   size_x2 = $-x2
   A  dw ?


section '.data' data readable
   array1   dw 31,32,5,4,5,6
   size_a1 =  $ - array1

   array2   db 1,2,3,4,5,6
   size_a2 =  $ - array2

   array3   dw 7 dup(3)
   size_a3 =  $ - array3

   array4   dw 2 dup(71,10,11)
   size_a4 =  $ - array4

   size_of_dd = 4     ; размер двойного слова = 4


section '.msg' data readable
   msg_d  db ' %d ', 0Dh, 0Ah,0
   msg_s  db 0Dh, 0Ah, ' %s ', 0Dh, 0Ah,0


section '.code' code readable executable

; функция макрос для печати массива 
; принимает три агрумета: arr, arr_size и word_size
macro print_array arr, arr_size, word_size
{
     mov ebx, 0   ; обнуляем регистр ebx
     @@:     ; '@@' - безымянная метка
       cinvoke printf,  ' %d ', [arr+ebx], 0
       add ebx, word_size
       cmp ebx, arr_size
       jne @b
}

start:
     ; размер массива - в байтах
     cinvoke printf,  msg_s, '1 part', 0   ; Выводим сообщение "1 part"
     cinvoke printf,  msg_d, size_a1       ; Выводим размер массива array1

     cinvoke printf,  msg_d, size_a2, 0    ; Выводим размер массива array2
     cinvoke printf,  msg_d, size_x1, 0    ; Выводим размер массива x1

     cinvoke printf,  msg_d, [array1+0], 0 ; Выводим первый элемент массива array1
     cinvoke printf,  msg_d, [array1+2], 0 ; Выводим второй элемент массива array1
     cinvoke printf,  msg_d, [array1+4], 0 ; Выводим третий элемент массива array1
                                           ; + 2 так как элементы в массиве array1 имеют тип word(т.е. размер элемента 2 байта)

     cinvoke printf,  msg_s, '2 part', 0   ; Выводим сообщение "2 part"
     ;------------------ Выводим массив array3 -----------------------------
     ; пока ebx != size_a3 прибавлять к ebx по 2(т.к тип элементов: word)
     xor ebx, ebx        ; тоже самое что и  mov ebx,0  но быстрее
     @@:
       cinvoke printf,  ' %d ', [array3+ebx], 0  ; выводим элемент массива
       add ebx, 2
       cmp ebx, size_a3
       jne @b     ; '@b' - back, переход на предыдущую безымянную метку;
     ;----------------------------------------------------------------------
     print_array array4, size_a4, 2     ; выводим элементы массива array4 с помощью макроса print_array

     cinvoke printf, msg_s, '3 part', 0 ; Выводим сообщение "3 part"
     mov ax, [array1]    ; в ax помещаем содержимое array1[0]
     add ax, 2           ; к ax прибавляем 2.
     mov [x2], ax        ; записываем значение из ax в x2[0]
     print_array x2, size_x2, 2   ; печатаем массив x2

     cinvoke printf,  msg_s,'4 part', 0         ; Выводим сообщение "4 part"
     print_array x1, size_x1, size_of_dd        ; печатаем массив x1

     ;-------------------- Заполняем массив x1 ---------------
     xor ebx, ebx
     @@:
       mov [x1+ebx], ebx     ; записываем значение из ebx в элемент массива x1
       add ebx, size_of_dd   ; увеличиваем ebx на 4
       cmp ebx, size_x1
       jne @b
     ;--------------------------------------------------------

     cinvoke printf, msg_s, '', 0           ; Печатаем пустую строку
     print_array x1, size_x1, size_of_dd    ; печатаем массив x1

     cinvoke printf, msg_s, '5 part', 0            ; Выводим сообщение "5 part"
     cinvoke printf, msg_s, ' Enter number', 0     ; Выводим приглашение к вводу
     cinvoke scanf, ' %d', A        ; считываем введенное число в A
     mov eax, dword [A]             ; помещаем A в eax   dword - double word
     mov [x2+2], ax                 ; записать значение ax на место второго элемента массива x2 
     print_array x2, size_x2, 2     ; печатаем массив x2



     invoke  sleep, 5000     ; 5 sec. delay

     invoke  exit, 0
     ret




section '.idata' import data readable
 
   library msvcrt,'MSVCRT.DLL',\
      kernel32,'KERNEL32.DLL'
 
   import kernel32,\
      sleep,'Sleep'
 
   import msvcrt,\
      puts,'puts',\
      scanf,'scanf',\
      printf,'printf',\
      lstrlen,'lstrlenA',\
      exit,'exit'