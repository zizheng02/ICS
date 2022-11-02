            .ORIG x3000
    AND R1, R1, #0     
    LD R2, HEAD        
    LD R3, RESULT      
INPUT       AND R0, R0, #0      
    GETC                
    OUT
    ADD R4, R0, #-10
    BRz POPANS
    LD R4, MINUS  
    NOT R4, R4
    ADD R4, R4, #1
    ADD R4, R4, R0     
    BRz LEFTPOP        
    LD R4, LARGER 
    NOT R4, R4
    ADD R4, R4, #1
    ADD R4, R4, R0     
    BRz RIGHTPOP      
    LD R4, LESS    
    NOT R4, R4
    ADD R4, R4, #1
    ADD R4, R4, R0     
    BRz RIGHTPUSH       
    LD R4, ADD_  
    NOT R4, R4
    ADD R4, R4, #1
    ADD R4, R4, R0      
    BRz LEFTPUSH        
LEFTPOP     ADD R1, R1, #0
    BRz EMPTY          
    LDR R0, R2, #0      
    STR R0, R3, #0    
    ADD R3, R3, #1      
    ADD R2, R2, #1     
    ADD R1, R1, #-1    
    BR INPUT
RIGHTPOP    ADD R1, R1, #0
    BRz EMPTY          
    ADD R0, R2, R1
    ADD R0, R0, #-1   
    LDR R0, R0, #0
    STR R0, R3, #0     
    ADD R3, R3, #1      
    ADD R1, R1, #-1     
    BR INPUT
EMPTY       LD R0, UNDERLINE    
    STR R0, R3, #0      
    ADD R3, R3, #1      
    BR INPUT
RIGHTPUSH   AND R0, R0, #0     
    GETC
    OUT
    ADD R4, R2, R1      
    STR R0, R4, #0      
    ADD R1, R1, #1      
    BR INPUT
LEFTPUSH    AND R0, R0, #0     
    GETC
    OUT
    STR R0, R2, #-1     
    ADD R2, R2, #-1     
    ADD R1, R1, #1     
    BR INPUT
POPANS      AND R1, R1, #0      
    LD R1, RESULT      
OUTPUT      NOT R2, R1
    ADD R2, R2, #1
    ADD R2, R2, R3     
    BRz END             
    LDR R0, R1, #0      
    OUT
    ADD R1, R1, #1      
    BR OUTPUT
END         HALT
HEAD        .FILL x3300     
RESULT      .FILL x3600
UNDERLINE   .FILL x005F         
MINUS .FILL x002D         
ADD_   .FILL x002B         
LARGER .FILL x005D         
LESS .FILL x005B       
.END