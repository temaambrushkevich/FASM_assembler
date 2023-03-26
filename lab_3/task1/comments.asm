format PE CONSOLE
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'

entry start


section '.data?' data readable writeable
   x1 dd 6 dup(?)       ; dup - ��� ������������� ������� ����������� ����������, ������������ ?,?,?,?,?,?.
   size_x1 = $-x1       ; ��������� ������ �������, $ - ����� ������� �����
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

   size_of_dd = 4     ; ������ �������� ����� = 4


section '.msg' data readable
   msg_d  db ' %d ', 0Dh, 0Ah,0
   msg_s  db 0Dh, 0Ah, ' %s ', 0Dh, 0Ah,0


section '.code' code readable executable

; ������� ������ ��� ������ ������� 
; ��������� ��� ��������: arr, arr_size � word_size
macro print_array arr, arr_size, word_size
{
     mov ebx, 0   ; �������� ������� ebx
     @@:     ; '@@' - ���������� �����
       cinvoke printf,  ' %d ', [arr+ebx], 0
       add ebx, word_size
       cmp ebx, arr_size
       jne @b
}

start:
     ; ������ ������� - � ������
     cinvoke printf,  msg_s, '1 part', 0   ; ������� ��������� "1 part"
     cinvoke printf,  msg_d, size_a1       ; ������� ������ ������� array1

     cinvoke printf,  msg_d, size_a2, 0    ; ������� ������ ������� array2
     cinvoke printf,  msg_d, size_x1, 0    ; ������� ������ ������� x1

     cinvoke printf,  msg_d, [array1+0], 0 ; ������� ������ ������� ������� array1
     cinvoke printf,  msg_d, [array1+2], 0 ; ������� ������ ������� ������� array1
     cinvoke printf,  msg_d, [array1+4], 0 ; ������� ������ ������� ������� array1
                                           ; + 2 ��� ��� �������� � ������� array1 ����� ��� word(�.�. ������ �������� 2 �����)

     cinvoke printf,  msg_s, '2 part', 0   ; ������� ��������� "2 part"
     ;------------------ ������� ������ array3 -----------------------------
     ; ���� ebx != size_a3 ���������� � ebx �� 2(�.� ��� ���������: word)
     xor ebx, ebx        ; ���� ����� ��� �  mov ebx,0  �� �������
     @@:
       cinvoke printf,  ' %d ', [array3+ebx], 0  ; ������� ������� �������
       add ebx, 2
       cmp ebx, size_a3
       jne @b     ; '@b' - back, ������� �� ���������� ���������� �����;
     ;----------------------------------------------------------------------
     print_array array4, size_a4, 2     ; ������� �������� ������� array4 � ������� ������� print_array

     cinvoke printf, msg_s, '3 part', 0 ; ������� ��������� "3 part"
     mov ax, [array1]    ; � ax �������� ���������� array1[0]
     add ax, 2           ; � ax ���������� 2.
     mov [x2], ax        ; ���������� �������� �� ax � x2[0]
     print_array x2, size_x2, 2   ; �������� ������ x2

     cinvoke printf,  msg_s,'4 part', 0         ; ������� ��������� "4 part"
     print_array x1, size_x1, size_of_dd        ; �������� ������ x1

     ;-------------------- ��������� ������ x1 ---------------
     xor ebx, ebx
     @@:
       mov [x1+ebx], ebx     ; ���������� �������� �� ebx � ������� ������� x1
       add ebx, size_of_dd   ; ����������� ebx �� 4
       cmp ebx, size_x1
       jne @b
     ;--------------------------------------------------------

     cinvoke printf, msg_s, '', 0           ; �������� ������ ������
     print_array x1, size_x1, size_of_dd    ; �������� ������ x1

     cinvoke printf, msg_s, '5 part', 0            ; ������� ��������� "5 part"
     cinvoke printf, msg_s, ' Enter number', 0     ; ������� ����������� � �����
     cinvoke scanf, ' %d', A        ; ��������� ��������� ����� � A
     mov eax, dword [A]             ; �������� A � eax   dword - double word
     mov [x2+2], ax                 ; �������� �������� ax �� ����� ������� �������� ������� x2 
     print_array x2, size_x2, 2     ; �������� ������ x2



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