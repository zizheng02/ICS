
        .ORIG x800
        ; (1) Initialize interrupt vector table.
        LD  R0, VEC
        LD  R1, ISR
        STR R1, R0, #0

        ; (2) Set bit 14 of KBSR.
        LDI R0, KBSR
        LD  R1, MASK
        NOT R1, R1
        AND R0, R0, R1
        NOT R1, R1
        ADD R0, R0, R1
        STI R0, KBSR

        ; (3) Set up system stack to enter user space.
        LD  R0, PSR
        ADD R6, R6, #-1
        STR R0, R6, #0
        LD  R0, PC
        ADD R6, R6, #-1
        STR R0, R6, #0
        ; Enter user space.
        RTI
        
VEC     .FILL x0180
ISR     .FILL x2000
KBSR    .FILL xFE00
MASK    .FILL x4000
PSR     .FILL x8002
PC      .FILL x3000
        .END

; user stack, infinity loop to output
                .ORIG x3000
                AND R2,R2,#0
                ADD R2,R2,#5
                AND R1,R1,#0
                LD R1,LETTERa
MAIN            JSR LINE
                JSR DELAY
                BR MAIN

LINE            ADD R2,R2,#0
                BRz BOTTOM
                ADD R2,R2,#-1
BOTTOM          LD R3,INDEX
                ADD R3,R3,R2
                STR R1,R3,#1
                STR R1,R3,#2
                STR R1,R3,#3;change the string
                
                LD R0,INDEX
                PUTS        ;output

                LD R0,POINT
                LD R3,INDEX
                ADD R3,R3,R2
                STR R0,R3,#1
                STR R0,R3,#2
                STR R0,R3,#3 ;recover the string
                
                RET
                
DELAY           LD  R4, COUNT
REP             ADD R4, R4, #-1
                BRp REP
                RET    
                

COUNT   .FILL x7FFF    
SaveR0  .FILL x0000
SaveR2  .FILL x0000
SaveR1  .BLKW #1
LETTERa .FILL #97
POINT   .FILL #46   ;ascii code of '.'
INDEX   .FILL X3100
.END

; interrupt subroutine, change appearance or add blocks
                .ORIG X3100
                AIR .STRINGZ "\n...................."
                .END
                
                
.ORIG X2000
        ST  R3, Save_R3
        ST  R0, Save_R0
        GETC
        LD R3,P10
        ADD R3,R0,R3
        BRn MOVE
        BR APPEARANCE
        
MOVE    LD R3,P48
    LD R5,P17
    ADD R3,R3,R0
    ADD R2,R2,R3
    ADD R3,R2,R5
    BRnz finish
    ld r2,n17
finish    ld r0,Save_R0
    LD  R3, Save_R3
    RTI
APPEARANCE  AND R1,R1,#0
    ADD R1,R1,R0
    ld r0,Save_R0
    LD  R3, Save_R3
    RTI    
Save_R3 .FILL   x0000
Save_R0 .FILL   x0000
P10 .FILL XFFC6  
P48 .FILL XFFD0
P17 .FILL #-18
n17 .fill #18
.END