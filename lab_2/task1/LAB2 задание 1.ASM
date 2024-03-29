format PE CONSOLE
include 'H:\Programming\assembler\FASM\INCLUDE\win32ax.inc'


entry start             ; ������� windows � ����� ����� ����������, 
                        ; start - ��� �����

; ������ ������ � ��������������������� �����������(�� �������� ������� ��������)
section '.data?' data readable writeable
   ; dd - double word (������� �����)
   A    dd ?
   B    dd ?
   C    dd ?
   D    dd ?

; ����������� � ������������ ���������������� ������
section '.data' data readable
   answ    db  'A+B+1 = %d',0

; ������, � ������� ���������� ��� ��������
section '.code' code readable executable

; ������(�������� ����������� ����������), 
; ������������ ������� ������������� ��� ������� �� ����(����� { � }) �������
macro mov_zero op1 {
    mov op1,0
}

; ��������� � ����� �����������
proc add2val, val1, val2
    mov eax,[val1]   ; ���������� � eax �������� val1
    add eax,[val2]   ; ���������� � eax �������� val2
                     ; �.�. �� ����� ���������� val1 � val2
    ret       ; ����� �� ���������
endp

start:
     ; cinvoke - ������������ ������� ������� � ���������� ���-��� ����������
     cinvoke puts,    'Enter A ', 0   ; ����� �� ����� ������      
     cinvoke scanf,   '%d', A    ;  ���� A
     cinvoke printf,  'Enter B ', 0   ; ����� �� ����� ������
     cinvoke scanf,   '%d', B    ;  ���� B

     mov eax,[A]    ; �������� � eax A
     add eax,[B]    ; ���������� � eax B
     lea ebx,[eax]  ; lea ��������� �����������(�������) ����� eax � �������� ��� � ebx
     xchg ecx,ebx   ; ������ ������� �������� ��������� ecx � ebx
     inc  ecx       ; ���������(���������� �� 1) �������� ecx

     mov [C],ecx    ; ������ � C ������ �������� ecx
     cinvoke printf, answ, [C], 0    ; ����� ������� ������� printf (������ � ���������������)
                                     ; � �������� ���� ����������
                                     ; (����� ���������� ��������� A+B+1)

     mov eax,[A]     ; �������� � eax �������� A
     mov ebx,[B]     ; �������� � ebx �������� B
     imul ebx, eax   ; ������������ A � B � ������ �����
     cinvoke printf, '  mull = %d   ', ebx,0    ; ����� ���������� ���������

     mov edx, [C]    ; �������� � ������� edx �������� C
     mov_zero ecx    ; �������� 0 � ecx

     ; ����� � �������� ������
     .repeat         ; ��������� ��� �� ��� ���, ���� ������� �� ������ ��������
        add edx,10   ; ���������� � edx 10
        inc ecx      ; ��������� ecx
     .until edx>130  ; �� ������ ������� ��������� (�.�. ������� ������ �� �����)

     mov [D],ecx     ; �������� � D �������� �������� ecx

     cinvoke printf, ' D  %d  ' , [D],0    ; ����� �������� D

     mov_zero ebx    ; � ebx ���������� 0
     cinvoke printf, 'mov_zero   %d  ' , ebx,0  ; ����� �������� �������� ebx

     stdcall add2val, 10, 2      ; ����� ��������� add2val, ��������� ������������ � ������� eax
                                 ; (�������� ���� �����, 10 � 2)
     cinvoke printf, ' add2reg  %d  ' , eax,0     ; ����� ���������� ������ ��������� add2val



     invoke  sleep, 50000     ; 50 sec. delay

     invoke  exit, 0          ; ����� �� ���������
     ret


; ������ �������
section '.idata' import data readable
 
 library msvcrt,'MSVCRT.DLL',\
    kernel32,'KERNEL32.DLL'
 
 import kernel32,\
    sleep,'Sleep'
 
 ; ������ C�-���� �������
 import msvcrt,\
    puts,'puts',\
    scanf,'scanf',\
    printf,'printf',\
    exit,'exit'
