
; ============================================================================
; Name:   Labyrinth
; Date:   2023-12-21
; email:  liqinglin0314@aliyun.com
; ============================================================================

assume cs:codeseg, ds:dataseg, ss:stackseg

dataseg segment

  ; 按键中断 int9 原偏移地址，段地址暂存
  addressInt9 dw 2 dup (0)
  ; 游戏状态 0 正常 1 退出 2 准备界面 3 游戏胜利
  gameStatus  db 2

  ; 准备界面
  startStr    db "                                                                                "
              db "                       Welcome to Labyrinth!                                    "
              db "                                                                                "
              db "                       Author: Allen                                            "
              db "                       Email : liqinglin0314@aliyun.com                         "
              db "                                                                                "
              db "                       Instruction:                                             "
              db "                                                                                "
              db "                                                                                "
              db "                                                                                "
              db "                           w                SPACE   start                       "
              db "                                            R       restart                     "
              db "                       A   S   D            ESC     exit                        "
              db "                                                                                ", 0

  ; 游戏结束提示
  gameoverStr db " You Win! ", 0
  ; 重玩提示
  restartStr  db "Press the R key to restart!", 0

  ; 地图宽度
  mapWidth    db 50 + 6
  ; 地图高度
  mapHeight   db 30 + 2
  ; 游戏地图(50 * 30)
  gameMap     db "                                                        "
              db "   **************************************************   "
              db "   *           * *         *     *        *    *    *   "
              db "   * **** ****** **** * ******** *** **** ** * * ** *   "
              db "   * *    * *       * * *   **   *   * *  *  *   *  *   "
              db "   * * **** * * * *     * *    * * *** **   ****   **   "
              db "   * * *    * * * *********** ** *   * *** ** *  *  *   "
              db "   *     **   * *       *   *  * *** *        * *** *   "
              db "   ************ ******* *** ** * *   * ******    *  *   "
              db "   *     *      *           *      * * *      *******   "
              db "   * ********** * **** **** **** * * * ******  *    *   "
              db "   *              *    *    *    *   *         * ** *   "
              db "   ****** ******* * **** **** * ** * ********* * *  *   "
              db "   *      *       *           * *  *             * **   "
              db "   * ****** ***** **********  *   ******* ****** *  *   "
              db "   * *      *       *         * ***           *     *   "
              db "   * * **** * ***** *********** *   * * * * * ***** *   "
              db "   *** *    * * * *       * *   * *** *** * * * *** *   "
              db "   *   * *      * * ***** * * *** *    *     **  *  *   "
              db "   * * * *** ****   *   * * *       ** * *** *  ** **   "
              db "   * * *  *  *    *   *   * ***** ***  * *       *  *   "
              db "   * * ** **** *  ***** ***       *   ** * **  * ** *   "
              db "   * *  *      **     *  *  * *****  **  * *  ** *  *   "
              db "   * **** **** *  *** ** * ** *  *  **  ** * *** * **   "
              db "   *         *     *       *  *     *  **        *  *   "
              db "   * ******* * *** * *** * * ****** * **  ********* *   "
              db "   * *       *   * * * * * * *        *         *   *   "
              db "   * * * ******* *     *   * * ** ** **  ******   * *   "
              db "   *   *   *   * ***** * *** * ** *   ** *   *   ** *   "
              db "   * *   *   *   *     *     *E   *   *  * *   * *  *   "
              db "   **************************************************   "
              db "                                                        "
  ; 显示自己的中心位置
  selfCenter  dw 0203h
  ; 当前位置
  nowLocation dw 0823h
  ; 初始化位置
  initSite    dw 0823h
  ; 墙体图案
  wall        db 0dbh
  ; 墙体颜色
  wallColor   db 07h
  ; 自己图案
  self        db 0dbh
  ; 自己颜色
  selfColor   db 04h
  ; 出口图案
  exit        db 0dbh
  ; 出口颜色
  exitColor   db 82h
  ; 准备界面颜色
  startColor  db 03h

dataseg ends

stackseg segment

  db 128 dup (0)

stackseg ends

codeseg segment

        start:  ; 初始化栈段顶指针
                mov ax, stackseg
                mov ss, ax
                mov sp, 128

                ; 初始化数据段
                mov ax, dataseg
                mov ds, ax

                ; 安装中断程序
                call installInt9

                ; 清屏
                call clearDis

                ; 准备界面
                call readly
 readlyShowS1:  cmp gameStatus[0], 2
                je readlyShowS1

                ; 显示初始位置
                call far ptr move

         main:  ; 游戏状态为 0（正常，循环）
                cmp gameStatus[0], 0
                je main

                ; 游戏状态为 3（胜利，循环）
          win:  cmp gameStatus[0], 3
                je win
                cmp gameStatus[0], 0
                je main

                ; 结束之前恢复int9之前中断向量表地址
                call uninstallInt9

                ; 清屏
                call clearDis

                ; 程序结束，返回DOS
                mov ax, 4c00h
                int 21h

; ============================================================================
; 游戏准备界面
; ============================================================================
       readly:  push es
                push di
                push ax
                push ds
                push cx
                push bx

                mov ax, dataseg
                mov ds, ax

                mov ax, 0b800h
                mov es, ax
                mov di, 7 * 160

                mov al, startColor[0]

                mov bx, 0
                mov ch, 0
        redS1:  mov cl, startStr[bx]
                jcxz redEnd
                mov byte ptr es:[di], cl

                mov byte ptr es:[di + 1], al
                inc bx
                add di, 2
                jmp redS1

       redEnd:  pop bx
                pop cx
                pop ds
                pop ax
                pop di
                pop es
                ret

; ============================================================================
; 重置游戏
; ============================================================================
      restart:  push ax
                push ds

                mov ax, dataseg
                mov ds, ax

                ; 清屏
                call clearDis

                ; 初始化位置
                mov ax, initSite[0]
                mov nowLocation[0], ax

                ; 移动（主要用于刷新地图）
                call far ptr move

                pop ds
                pop ax
                retf

; ============================================================================
; 显示基本方块子程序(一共7列 * 5行)
; @ 入参 dh 行
;        dl 列
;        ch 颜色
;        cl 显示内容
; ============================================================================
 displayBlock:  push ax
                push es
                push di
                push cx

                mov ax, 0b800h
                mov es, ax

                ; 计算方块显示坐标
                push cx
                push dx

                mov al, dh
                mov ah, 160
                mul ah
                mov cx, 5
                mul cx
                ; 这里不用担心溢出，只取出低 8 位即可
                mov di, ax

                pop dx
                pop cx

                mov al, dl
                mov ah, 20
                mul ah
                add di, ax

                ; 考虑居中问题，两边需要留白
                add di, 10

                ; 把显示内容暂存给 ax，cx 后续需要loop 循环用
                mov ax, cx

                mov cx, 5
   disBlockS1:  push cx
                mov cx, 10
   disBlockS2:  mov word ptr es:[di], ax
                add di, 2
                loop disBlockS2
                pop cx
                ; 加一行
                add di, 160 - 20
                loop disBlockS1

                pop cx
                pop di
                pop es
                pop ax
                ret

; ============================================================================
; 半块方块子程序(一共16列 * 5行)
; @ 入参 dh 行
;        dl 列
;        ch 颜色
;        cl 显示内容
; ============================================================================
 disblockhalf:  push ax
                push es
                push di
                push cx

                mov ax, 0b800h
                mov es, ax

                ; 计算方块显示坐标
                push cx
                push dx

                mov al, dh
                mov ah, 160
                mul ah
                mov cx, 5
                mul cx
                ; 这里不用担心溢出，只取出低 8 位即可
                mov di, ax

                pop dx
                pop cx

                mov al, dl
                mov ah, 10
                mul ah
                add di, ax

                ; 把显示内容暂存给 ax，cx 后续需要loop 循环用
                mov ax, cx

                mov cx, 5
disBlockHalfS1: push cx
                mov cx, 5
disBlockHalfS2: mov word ptr es:[di], ax
                add di, 2
                loop disBlockHalfS2
                pop cx
                ; 加一行
                add di, 160 - 10
                loop disBlockHalfS1

                pop cx
                pop di
                pop es
                pop ax
                ret

; ============================================================================
; 计算地图坐标
; @ 入参 bx 坐标地址
; @ 返回 si 计算后的地图对应位置
; ============================================================================
       calMap:  push ax
                push bx
                push ds

                mov ax, dataseg
                mov ds, ax

                mov al, bh
                mov ah, mapWidth[0]
                mul ah
                mov si, ax

                mov bh, 0
                add si, bx

                pop ds
                pop bx
                pop ax
                retf

; ============================================================================
; 当前区域显示程序
; ============================================================================
      display:  push ax
                push ds
                push dx
                push cx
                push si
                push bx

                mov ax, dataseg
                mov ds, ax

                ; 找到左上角位置(往上两行，往左三块)
                mov bx, nowLocation[0]
                sub bh, 2
                sub bl, 3
                mov dx, 0

                ; 暂存调用块显示子程序显示内容数据到 ax
                mov ah, wallColor[0]
                mov al, wall[0]

                ; 5 行
                mov cx, 5
    displayS1:  push cx
                ; 7 列
                mov cx, 7
    displayS2:  push cx
                mov cx, ax

                ; 计算地图坐标
                call far ptr calMap
                cmp gameMap[si], '*'
                je showBlock
                cmp gameMap[si], 'E'
                jne showNull
                mov ch, exitColor[0]
                mov cl, exit[0]
                jmp showBlock

     showNull:  mov cx, 0
    showBlock:  ; 判断是否是自己的位置，如果是自己显示自己的颜色
                cmp dh, 2
                jne callDisBlock
                cmp dl, 3
                jne callDisBlock
                mov ch, selfColor[0]
                mov cl, self[0]
 callDisBlock:  call displayBlock

                pop cx
                inc dl
                inc bl
                loop displayS2
                inc dh
                inc bh
                ; 第二行需要重置减少 7
                sub bl, 7
                mov dl, 0
                pop cx
                loop displayS1

                ; 左右两侧半块显示部分处理
                mov bx, nowLocation[0]
                sub bh, 2
                sub bl, 4         ; 需要比上面多移动一格
                mov dx, 0

                ; 5 行
                mov cx, 5
   halfplayS1:  push cx
                ; 2 列
                mov cx, 2
   halfplayS2:  push cx
                mov cx, ax

                ; 计算地图坐标
                call far ptr calMap
                cmp gameMap[si], '*'
                je halfshowBlock
                cmp gameMap[si], 'E'
                jne showNull2
                mov ch, exitColor[0]
                mov cl, exit[0]
                jmp halfshowBlock

    showNull2:  mov cx, 0
halfshowBlock:  call disBlockHalf

                pop cx
                add dl, 15
                add bl, 8
                loop halfplayS2
                inc dh
                inc bh
                ; 第二行需要重置减少 9
                sub bl, 16
                mov dl, 0
                pop cx
                loop halfplayS1

                pop bx
                pop si
                pop cx
                pop dx
                pop ds
                pop ax
                ret

; ============================================================================
; 游戏胜利
; ============================================================================
     checkWin:  push ax
                push ds
                push bx
                push si
                push es
                push di
                push cx
                push bx

                mov ax, dataseg
                mov ds, ax

                mov bx, nowLocation[0]
                call far ptr calMap
                cmp gameMap[si], 'E'
                jne winOver

                ; 显示游戏结束
                mov gameStatus[0], 3

                mov ax, 0b800h
                mov es, ax
                mov di, 10 * 160 + 70

                ; GAME OVER!
                mov bx, 0
                mov ch, 0
     disWinS1:  mov cl, gameoverStr[bx]
                jcxz disPress
                mov byte ptr es:[di], cl
                mov byte ptr es:[di + 1], 82h
                inc bx
                add di, 2
                jmp disWinS1

                ; Press the R key to restart
     disPress:  mov bx, 0
                mov ch, 0
       disS3:   mov cl, restartStr[bx]
                jcxz winOver
                mov byte ptr es:[di + 604], cl
                mov byte ptr es:[di + 605], 82h
                inc bx
                add di, 2
                jmp disS3

      winOver:  pop bx
                pop cx
                pop di
                pop es
                pop si
                pop bx
                pop ds
                pop ax
                ret

; ============================================================================
; 清屏
; ============================================================================
     clearDis:  push ax
                push es
                push di
                push cx

                mov ax, 0b800h
                mov es, ax
                mov di, 0

                mov cx, 4000
        clrS1:  mov word ptr es:[di], 0
                inc di
                loop clrS1

                pop cx
                pop di
                pop es
                pop ax
                ret


; ============================================================================
; 移动后执行操作
; ============================================================================
         move:  ; 当前区域显示
                call display

                ; 判断游戏是否胜利
                call checkWin

                retf

; ============================================================================
; 安装按键中断 int9 程序
; ============================================================================
  installInt9:  push ax
                push ds
                push es
                push di
                push si
                push cx

                mov ax, dataseg
                mov ds, ax

                mov ax, 0
                mov es, ax

                ; 保存原来 int9 的中断向量表内容
                push es:[9 * 4]
                pop addressInt9[0]
                push es:[9 * 4 + 2]
                pop addressInt9[2]

                ; 安装新的中断程序
                mov ax, seg funInt9
                mov ds, ax

                mov si, offset funInt9
                mov di, 200h

                mov cx, offset funInt9Over - offset funInt9
                cld
                rep movsb

                ; 中断向量表指向新的中断程序位置
                mov word ptr es:[9 * 4], 200h
                mov word ptr es:[9 * 4 + 2], 0

                pop cx
                pop si
                pop di
                pop es
                pop ds
                pop ax
                ret

; ============================================================================
; 卸载恢复原先按键中断 int9 程序
; ============================================================================
uninstallInt9:  push ax
                push ds
                push es

                mov ax, dataseg
                mov ds, ax

                mov ax, 0
                mov es, ax

                ; 恢复之前 int9 中断向量表地址
                push addressInt9[0]
                pop es:[9 * 4]
                push addressInt9[2]
                pop es:[9 * 4 + 2]

                pop es
                pop ds
                pop ax
                ret

; ============================================================================
; 重写按键中断 int9 程序主体
; ============================================================================
      funInt9:  push ax
                push ds
                push es
                push bx
                push si

                mov ax, dataseg
                mov ds, ax

                mov ax, 0
                mov es, ax

                ; 读取按键输入内容到 al
                in al, 60h

                ; 模拟原来 int9 程序调用
                ; 状态寄存器入栈
                pushf
                ; TF 和 IF 标志位设置为 0
                pushf
                pop bx
                and bh, 11111100b
                push bx
                popf
                ; 调用原int9 中断程序
                call dword ptr addressInt9[0]


                ; 判断游戏是不是准备状态，如果是只有 space 有效
                cmp gameStatus[0], 2
                jne statusS1
                jmp keySpace

                ; 判断游戏是不是胜利状态，如果是只有 R 有效
     statusS1:  cmp gameStatus[0], 3
                jne keyW
                jmp keyR

                ; 方向控制
                ; 键盘 W 按下
         keyW:  cmp al, 11h
                jne keyA
                ; 撞墙校验
                mov bx, nowLocation[0]
                dec bh
                call far ptr calMap
                cmp gameMap[si], '*'
                je KeyOverW
                mov nowLocation[0], bx
                call far ptr move
     keyOverW:  jmp funInt9End

                ; 键盘 A 按下
         keyA:  cmp al, 1Eh
                jne keyS
                ; 撞墙校验
                mov bx, nowLocation[0]
                dec bl
                call far ptr calMap
                cmp gameMap[si], '*'
                je keyOverA
                mov nowLocation[0], bx
                call far ptr move
     keyOverA:  jmp funInt9End

                ; 键盘 S 按下
         keyS:  cmp al, 1Fh
                jne keyD
                ; 撞墙校验
                mov bx, nowLocation[0]
                inc bh
                call far ptr calMap
                cmp gameMap[si], '*'
                je keyOverS
                mov nowLocation[0], bx
                call far ptr move
     keyOverS:  jmp funInt9End

                ; 键盘 D 按下
         keyD:  cmp al, 20h
                jne keyR
                ; 撞墙校验
                mov bx, nowLocation[0]
                inc bl
                call far ptr calMap
                cmp gameMap[si], '*'
                je keyOverD
                mov nowLocation[0], bx
                call far ptr move
     keyOverD:  jmp funInt9End

                ; 键盘 R 按下
         keyR:  cmp al, 13h
                jne keySpace
                ; 判断游戏是不是胜利状态，只有胜利状态这个按键才有效
                cmp gameStatus[0], 3
                jne keyOverR
                call far ptr restart
                mov gameStatus[0], 0
     keyOverR:  jmp funInt9End


                ; 键盘 space 按下
     keySpace:  cmp al, 39h
                jne keyEsc
                ; 判断游戏是不是准备状态，只有准备状态这个按键才有效
                cmp gameStatus[0], 2
                jne keyOverSpace
                call far ptr restart
                mov gameStatus[0], 0
 keyOverSpace:  jmp funInt9End

       keyEsc:  cmp al, 01h
                jne funInt9End
                ; 设置游戏状态为1(结束游戏)
                mov gameStatus[0], 1

   funInt9End:  pop si
                pop bx
                pop es
                pop ds
                pop ax
                iret

  funInt9Over:  nop

codeseg ends

end start

