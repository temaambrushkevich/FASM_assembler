format PE CONSOLE
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'

entry start


section '.data?' data readable writeable
   arr dd 6 dup(?)       
   size_arr = $-arr
   len_arr = 6
   A  dd ?


section '.msg' data readable
   msg_s  db '%s ', 0Dh, 0Ah,0


section '.code' code readable executable

; функция макрос для печати массива 
; принимает три агрумета: arr, arr_size и word_size
macro print_array arr, arr_size, word_size
{
     mov ebx, 0
     @@:
       cinvoke printf,  ' %d ', [arr+ebx], 0
       add ebx, word_size
       cmp ebx, arr_size
       jne @b
}

; функция макрос для заполнения массива с клавиатуры
macro fill_array arr, size_arr, word_size
{
    mov ebx, 0
    @@:
      cinvoke scanf, ' %d', A   ; считываем введенное число в A
      mov eax, dword [A]        ; помещаем A в eax
      mov [arr+ebx], eax        ; записываем значение элемента в массив
      add ebx, word_size
      cmp ebx, size_arr
      jne @b
}

; сортировка пузырьком по возрастанию
macro sort_array arr, len_arr
{
    mov edi, arr   ; передаем в edi указатель на массив
    mov ecx, len_arr     ; передаем в ecx длину массива
     
    sort:       
        lea ebx, [edi+ecx*4]    ; вычисляем текущий адрес второго операнда и помещаем его в ebx
        mov eax, [edi]
    .cmploop:
        sub ebx, 4
        cmp eax, [ebx]
        jle .again
        xchg eax, [ebx]   ; xchg - меняет операнды местами
    .again:
        cmp ebx, edi
        jnz .cmploop
        stosd             ; сохраняет eax по адресу ES:(E)DI; d - double word
        loop sort
}

start:
     cinvoke printf,  msg_s, 'Enter six numbers via Enter, to fill the array: ', 0   ; Выводим приглашение к вводу

     ; вызываем макрос для заполнения массива
     fill_array arr, size_arr, 4

     ; вывод того, что ввел пользователь
     cinvoke printf,  msg_s, 'You entered: ', 0
     print_array arr, size_arr, 4

     cinvoke printf,  msg_s, '', 0 

     ; вызываем сортировку
     sort_array arr, len_arr 

     ; печатаем массив после сортировки
     cinvoke printf,  msg_s, 'Array after sorting: ', 0
     print_array arr, size_arr, 4


     ; пауза и далее выход
     invoke  sleep, 50000     ; 5 sec. delay
     invoke  exit, 0
     ret




section '.idata' import data readable
 
   library msvcrt,'MSVCRT.DLL',\
      kernel32,'KERNEL32.DLL'
 
   import kernel32,\
      sleep,'Sleep'
 
   import msvcrt,\
      scanf,'scanf',\
      printf,'printf',\
      exit,'exit'