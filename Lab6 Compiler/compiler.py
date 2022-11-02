import re
instructions = []  # 整理好后的的汇编指令
output = []  # 要输出的机器代码
insList = ['ADD', 'AND', 'NOT', 'LD',
           'LDR', 'LDI', 'LEA', 'ST',
           'STR', 'STI', 'TRAP',
           'JMP', 'RET', 'JSR', 'JSRR', 'RTI',
           '.FILL', '.BLKW', '.STRINGZ',
           'HALT', 'BR', 'BRn', 'BRz', 'BRp', 'BRnz', 'BRnp', 'BRzp', 'BRnzp',
           'GETC','OUT','PUTS','IN','PUTSP',]
resDict = {'R0': '000', 'R1': '001', 'R2': '010', 'R3': '011', 'R4': '100',
           'R5': '101', 'R6': '110', 'R7': '111'}
startFlag = 0
'''
    输入带前缀,输出机器指令
    输入字符串类型,返回字符串类型
    flag:off  imm  vect   n:几位    index:用于Label,传进来的ins所在的行号
'''


def convertBinary(flag, n, ins, pc=-1):
    negflag = 0
    # off*
    if flag == 1:
        if ins[0:1] == '#':
            if ins[1:2] == '-':
                negflag = 1
                res = bin(int(ins[2:], 10))[2:]
            else:
                res = bin(int(ins[1:], 10))[2:]
        else:
            # Label的时候
            return convertBinary(1, n, '#' + str(labelIndex[ins] - pc))
    # imm*
    elif flag == 2:
        if ins[0:1] == '#':
            if ins[1:2] == '-':
                negflag = 1
                res = bin(int(ins[2:], 10))[2:]
            else:
                res = bin(int(ins[1:], 10))[2:]
        elif ins[0:1] == 'x':
            if ins[1:2] == '-':
                negflag = 1
                res = bin(int(ins[2:], 16))[2:]
            else:
                res = bin(int(ins[1:], 16))[2:]
    # vect*
    elif flag == 3:
        res = bin(int(ins[1:],16))[2:]

    while (len(res) < n - 1):
        res = '0' + res
    if negflag == 1:
        return ('1' + res)
    else:
        return ('0' + res)


'''
    ***读取***
    (orig,end)存到instructions
    去除了前后的空格
'''
labelIndex = {}
inputPC = 1
while (True):
    curIns = input()
    curIns=curIns.strip()
    # 不要空行
    if curIns=='':
        continue
    if (startFlag):
        if curIns.find('.END') != -1:
            break
        else:
            #是否含字符串
            if curIns.find('.STRINGZ') != -1:
                noList = curIns.split(' ')
                if noList[0] not in insList:
                    labelIndex[noList[0]] = inputPC
                pat='"{1}[\s\S]*"{1}'
                matchObj = re.findall(pat, curIns)
                # print(matchObj)
                yesList=['','']
                yesList[0] = '.STRINGZ'
                yesList[1] = str(matchObj[0])
                frontIns = yesList
                # print('##########'+str(frontIns))
            else:
                frontIns = curIns.split(' ')
                while '' in frontIns:
                    frontIns.remove('')
            # 有label
            if (frontIns[0] not in insList):
                labelIndex[frontIns[0]] = inputPC
                # print("@@@@@@@@@"+str(frontIns))
                frontIns.pop(0)
                # print('%%%%%%%%%%'+str(frontIns[0]))
            if frontIns[0]=='.BLKW':
                inputPC=inputPC+int(frontIns[1][1:])
            elif frontIns[0]=='.STRINGZ':
                inputPC=inputPC+len(frontIns[1])-1
            else:
                inputPC = inputPC + 1
            instructions.append(frontIns)
    if curIns.find('.ORIG') != -1:
        startFlag = 1
        startList = curIns.split(' ')
        res = convertBinary(3, 16, startList[-1].strip())
        output.append(res)
'''
    先假设每条汇编指令只占一行字符串
    根据每行字符串,选取对应的函数去处理指令
'''


def handleIns(num, insList, pc=-1):
    # ADD
    if num == 0:
        if (insList[3].find('R') != -1):
            res = resDict[insList[1][0:2]] + resDict[insList[2][0:2]] + '000' + resDict[insList[3]]
            output.append('0001' + res)
        else:
            res = resDict[insList[1][0:2]] + resDict[insList[2][0:2]] + '1' + convertBinary(2, 5, insList[3],pc)
            output.append('0001' + res)
    elif num == 1:
        if (insList[3].find('R') != -1):
            res = resDict[insList[1][0:2]] + resDict[insList[2][0:2]] + '000' + resDict[insList[3]]
            output.append('0101' + res)
        else:
            res = resDict[insList[1][0:2]] + resDict[insList[2][0:2]] + '1' + convertBinary(2, 5, insList[3],pc)
            output.append('0101' + res)
    elif num == 2:
        res = resDict[insList[1][0:2]] + resDict[insList[2]]
        output.append('1001' + res + '111111')
    elif num == 3:
        res = resDict[insList[1][0:2]] + convertBinary(1, 9, insList[-1],pc)
        output.append('0010' + res)
    elif num == 4:
        res = resDict[insList[1][0:2]] + resDict[insList[2][0:2]] + convertBinary(2, 6, insList[-1],pc)
        output.append('0110' + res)
    elif num == 5:
        res = resDict[insList[1][0:2]] + convertBinary(1, 9, insList[-1],pc)
        output.append('1010' + res)
    elif num == 6:
        res = resDict[insList[1][0:2]] + convertBinary(1, 9, insList[-1],pc)
        output.append('1110' + res)
    elif num == 7:
        res = resDict[insList[1][0:2]] + convertBinary(1, 9, insList[-1],pc)
        output.append('0011' + res)
    elif num == 8:
        res = resDict[insList[1][0:2]] + resDict[insList[2][0:2]] + convertBinary(2, 6, insList[-1],pc)
        output.append('0111' + res)
    elif num == 9:
        res = resDict[insList[1][0:2]] + convertBinary(1, 9, insList[-1],pc)
        output.append('1011' + res)
    # 后面从Trap开始
    elif num == 10:
        output.append('11110000' + convertBinary(3, 8, insList[1],pc))
    elif num == 11:
        output.append('1100000' + resDict[insList[1]] + '000000')
    elif num == 12:
        output.append('1100000111000000')
    elif num == 13:
        output.append('01001' + convertBinary(1, 11, insList[1],pc))
    elif num == 14:
        output.append('0100000' + resDict[insList[1]] + '000000')
    elif num == 15:
        output.append('1000000000000000')
    elif num == 16:
        output.append(convertBinary(2, 16, insList[1],pc))
    elif num == 17:
        for i in range(0, int(insList[1][1:])):
            output.append('0000000000000000')
    elif num == 18:
        # 转换字符
        if len(insList[1])==2:
            output.append('0000000000000000')
        else:
            insList[1]=insList[1][1:-1]
            # print(insList[1])
            for i in insList[1]:
                # print(i)
                output.append(convertBinary(2,16,'#'+str(ord(i))))
            output.append('0000000000000000')
    elif num == 19:
        output.append('1111000000100101')
    elif num >=28:
        output.append(convertBinary(3,16,'x'+str(num-8)))
    else:
        if num ==20:
            brnumer='111'
        if num==21:
            brnumer = '100'
        if num==22:
            brnumer = '010'
        if num==23:
            brnumer = '001'
        if num==24:
            brnumer = '110'
        if num==25:
            brnumer = '101'
        if num==26:
            brnumer = '011'
        if num==27:
            brnumer = '111'
        output.append('0000'+brnumer+convertBinary(1,9,insList[1],pc))
        processPC=labelIndex[insList[1]]
        # print(processPC)

# print(labelIndex)
processPC=1
# print(instructions)
for ins in instructions:
    processPC=processPC+1
    insIndex = insList.index(ins[0])
    handleIns(insIndex, ins, processPC)

for i in range(0, len(output) - 1):
    print(output[i])
print(output[-1], end='')

