;convert numbers to hexadecimal.
    .ORIG x3000
    LD R3,N48
    AND R1,R1,#0    ;SUM
    GETC
    OUT
    ADD R0,R0,R3    ;将ASCII转换为数字
    BRN OUTPUT1
;get decimal
;
;
GETDEC  AND R2,R2,#0
    ADD R2,R2,#9   ;R2存储循环次数
;
    AND R4,R4,#0
    ADD R4,R4,R0
    GETC
    OUT
    ADD R0,R0,R3    
    BRN GETHEX ;把r4加入就可以了
MULTTEN    AND R5,R5,#0
    ADD R5,R5,R1
LOOP0    ADD R1,R1,R5
    ADD R2,R2,#-1
    BRZ LOOP1
    BR LOOP0
LOOP1 AND R2,R2,#0
    ADD R2,R2,#10
LOOP2 ADD R1,R1,R4
    ADD R2,R2,#-1
    BRZ GETDEC
    BR LOOP2
;
;
;decimal to hexadecimal
GETHEX ADD R1,R1,R4
    STI R1,NUM
    LD R5,HEXNUM
    ADD R5,R5,#3   ;指向最后一位
    AND R6,R6,#0
    ADD R6,R6,#4
    LD R7,DIV
    AND R0,R0,#0
    ADD R0,R0,#1
    ADD R1,R1,R7
    BRZP LOP1
    ADD R1,R1,R7
    AND R0,R0,#0
LOP1   AND R2,R2,#0
    ADD R2,R2,#-16
    AND R3,R3,#0;商
    AND R4,R4,#0;余数
LOP2   ADD R1,R1,R2;R1=R1-8
    BRN STORE1
    ADD R3,R3,#1
    BR LOP2
STORE1  ADD R4,R4,R1;R4=R1
    AND R2,R2,#0
    ADD R2,R2,#15
    ADD R2,R2,#1
    ADD R4,R4,R2    ;得到余数
    STR R4,R5,#0    ;存储余数
    AND R1,R1,#0
    ADD R1,R1,R3    ;令被除数变为此次商
    ADD R5,R5,#-1
    ADD R6,R6,#-1
    BRZ OUTPUT2
    BR LOP1
; OUTPUT2 HALT
OUTPUT2 AND R1,R1,#0
    ADD R1,R1,#4
    AND R6,R6,#0
    ADD R6,R6,R0
    ;
    LD R2,HEXNUM
OUTPUTLOOP2    LDR R0,R2,#0
    ADD R6,R6,#0
    BRNZ SKIP;不用+8
    ADD R0,R0,#8
    AND R6,R6,#0
SKIP AND R5,R5,#0
    ADD R5,R5,R0
    ADD R5,R5,#-10
    BRN NEG;<10
    BR POS;>10
NEG AND R3,R3,#0
    LD R3,P48
    ADD R0,R0,R3
    OUT 
    ADD R2,R2,#1
    ADD R1,R1,#-1
    BRZ END
    BR OUTPUTLOOP2
POS AND R3,R3,#0
    LD R3,P55
    ADD R0,R0,R3
    OUT
    ADD R2,R2,#1
    ADD R1,R1,#-1
    BRZ END
    BR OUTPUTLOOP2
OUTPUT1     AND R1,R1,#0
    ADD R1,R1,#4
    LD R2,HEXNUM
    AND R3,R3,#0
    LD R3,P48
OUTPUTLOOP1 LDR R0,R2,#0
    ADD R0,R0,R3
    OUT
    ADD R2,R2,#1
    ADD R1,R1,#-1
    BRZ END
    BR OUTPUTLOOP1
END HALT
;
N48 .FILL X-30
NUM .FILL X308D
HEXNUM .FILL X309D;存储二进制数的地址
DIV .FILL X8000
P48 .FILL X30
P55 .FILL X37
.END