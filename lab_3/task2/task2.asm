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

; ������� ������ ��� ������ ������� 
; ��������� ��� ��������: arr, arr_size � word_size
macro print_array arr, arr_size, word_size
{
     mov ebx, 0
     @@:
       cinvoke printf,  ' %d ', [arr+ebx], 0
       add ebx, word_size
       cmp ebx, arr_size
       jne @b
}

; ������� ������ ��� ���������� ������� � ����������
macro fill_array arr, size_arr, word_size
{
    mov ebx, 0
    @@:
      cinvoke scanf, ' %d', A   ; ��������� ��������� ����� � A
      mov eax, dword [A]        ; �������� A � eax
      mov [arr+ebx], eax        ; ���������� �������� �������� � ������
      add ebx, word_size
      cmp ebx, size_arr
      jne @b
}

; ���������� ��������� �� �����������
macro sort_array arr, len_arr
{
    mov edi, arr   ; �������� � edi ��������� �� ������
    mov ecx, len_arr     ; �������� � ecx ����� �������
     
    sort:       
        lea ebx, [edi+ecx*4]    ; ��������� ������� ����� ������� �������� � �������� ��� � ebx
        mov eax, [edi]
    .cmploop:
        sub ebx, 4
        cmp eax, [ebx]
        jle .again
        xchg eax, [ebx]   ; xchg - ������ �������� �������
    .again:
        cmp ebx, edi
        jnz .cmploop
        stosd             ; ��������� eax �� ������ ES:(E)DI; d - double word
        loop sort
}

start:
     cinvoke printf,  msg_s, 'Enter six numbers via Enter, to fill the array: ', 0   ; ������� ����������� � �����

     ; �������� ������ ��� ���������� �������
     fill_array arr, size_arr, 4

     ; ����� ����, ��� ���� ������������
     cinvoke printf,  msg_s, 'You entered: ', 0
     print_array arr, size_arr, 4

     cinvoke printf,  msg_s, '', 0 

     ; �������� ����������
     sort_array arr, len_arr 

     ; �������� ������ ����� ����������
     cinvoke printf,  msg_s, 'Array after sorting: ', 0
     print_array arr, size_arr, 4


     ; ����� � ����� �����
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