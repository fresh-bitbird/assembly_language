; test.asm - yang's test for assmebly language

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

include irvine32.inc

;####################################################################
;8.10.2-2

comment !
.data
val1 dword 10h
val2 dword 20h
val3 dword 30h

.code
AddThree proto,X:dword,Y:dword,W:dword            ;函数原型，使用已命名的形参
main proc
invoke AddThree,val1,val2,val3
main endp
AddThree proc,X:dword,Y:dword,W:dword             ;函数定义
mov eax,0                                         ;将eax置0
add eax,X                                         ;将X添加至eax
add eax,Y                                         ;将Y添加至eax
add eax,W                                         ;将W添加至eax
ret
AddThree endp
end main
!

;8.10.2-3
comment !

pArray equ [ebp-4]                       ;EQU文本
.data
array dword 10h,20h,30h                  ;需要指向的数组

.code
pointer proto                            ;函数原型
main proc
invoke pointer
main endp

pointer proc                             ;函数定义
enter 1,0
mov pArray,offset array                  ;获取array的地址
mov eax,pArray
leave
ret 4                                    ;stdcall的调用规范
pointer endp
end main
!

;8.11-1

comment !
.data
val1 dword 10,20,-30,40,-50

.code
FindLargest proto ,address:ptr dword,len:dword
main proc
invoke FindLargest,addr val1,dword ptr lengthof val1
invoke Exitprocess,0
main endp

FindLargest proc uses esi ecx,address:ptr dword,len:dword
            mov esi,[address]                   ;使用esi保存val1的地址
            mov eax,[esi]                       ;使用eax保存val1的第一个值
            mov ecx,len                         ;使用ecx保存数组的长度
            dec ecx
            L:
              add esi,4                         ;使esi指向下一个数组元素
              cmp eax,[esi]                     ;将当前最大的值与下一个值进行比较
              jg next
              mov eax,[esi]                     ;更换最大的值
            next:
              loop L
            ret
FindLargest endp

end main
!

;8.11-2
;首先进行调试SetTextColor

comment !
.code
main proc
mov eax,blue*16
call SetTextColor
invoke exitprocess,0
main endp
end main
!


.data
location_x byte 1                        ;横坐标
location_y byte 1                        ;纵坐标
max_x byte 8                    ;最大的行数
max_y byte 8                    ;最大的列数

.code
color_gray proto,x:ptr byte,y:ptr byte        ;显示灰色棋盘方格
color_white proto,x:ptr byte,y:ptr byte       ;显示白色棋盘方格
location proto,x:ptr byte,y:ptr byte    ;检查并更改棋盘方位，
                                        ;当每行满8个时换行，并保证方块颜色互相交替

main proc
invoke location,addr location_x,addr location_y
;######################################
P1:
invoke color_gray,addr location_x,addr location_y
invoke location,addr location_x,addr location_y
mov al,location_x
mov ah,location_y
cmp bh,0
jne stop
cmp bl,0
jne P1
jmp P2
;#######################################
P2:
invoke color_white,addr location_x,addr location_y
invoke location,addr location_x,addr location_y
cmp bh,0
jne stop
cmp bl,0
jne P2
jmp P1
;#######################################
stop:
invoke exitprocess,0

main endp

color_gray proc uses edx eax ,x:ptr byte,y:ptr byte
mov dl,byte ptr [x]
mov dh,byte ptr [y]
call gotoxy                             ;使光标到达指定的坐标
mov eax,gray * 16                       ;设置背景颜色
call SetTextColor                       ;改变背景颜色
mov al,'A'
call writechar
inc byte ptr [x]
ret
color_gray endp

color_white proc uses edx eax ,x:ptr byte,y:ptr byte
mov dl,byte ptr [x]
mov dh,byte ptr [y]
call gotoxy                             ;使光标到达指定的坐标
mov eax,white * 16                      ;设置背景颜色
call SetTextColor                       ;改变背景颜色
mov al,'A'
call writechar
inc byte ptr [x]
ret
color_white endp

location proc uses eax,x:ptr byte,y:ptr byte
mov al,max_x
mov ah,max_y
cmp byte ptr [x],al
jne check_y                             ;x!=8跳转
mov byte ptr [x],1
mov bl,1
check_y:
cmp byte ptr [y],ah
jne next                                ;y!=8跳转
mov bh,1
inc byte ptr [y]
next:
mov bh,0
mov bl,0
ret
location endp
end main

