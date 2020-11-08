# Homework 1

Do the following base conversions.

1. <img src="/tex/23c18ec5cbb36561821ba7875b3caf74.svg?invert_in_darkmode&sanitize=true" align=middle width=31.21017569999999pt height=21.18721440000001pt/> in base 10 = 458

1. <img src="/tex/3b2f08cfae118edca93226688dde4e3d.svg?invert_in_darkmode&sanitize=true" align=middle width=39.429385049999986pt height=21.18721440000001pt/> in base 10 = 393
1. <img src="/tex/13e3448bf82bdcca2c769775e1a3dadc.svg?invert_in_darkmode&sanitize=true" align=middle width=64.0870131pt height=21.18721440000001pt/> in base 10 = 1942
1. <img src="/tex/807b2f5caece0d376572c025be12d7b2.svg?invert_in_darkmode&sanitize=true" align=middle width=31.21017569999999pt height=21.18721440000001pt/> in base 10 = 183
1. <img src="/tex/bfb8714a1bbed760b6dcb545d9fe55fd.svg?invert_in_darkmode&sanitize=true" align=middle width=37.76272169999999pt height=21.18721440000001pt/> in base 10 = 1074
1. <img src="/tex/9a54736f2910af69a7cfa93a5277d9f3.svg?invert_in_darkmode&sanitize=true" align=middle width=64.0870131pt height=21.18721440000001pt/> in base 10 = 1915
1. <img src="/tex/78f3228b074acd9b63d97bf8ca2a7ed9.svg?invert_in_darkmode&sanitize=true" align=middle width=37.76272169999999pt height=21.18721440000001pt/> in base 11 = 25
1. <img src="/tex/4bb5bda1003d0b8cc77220a45c0fbce0.svg?invert_in_darkmode&sanitize=true" align=middle width=37.76272169999999pt height=21.18721440000001pt/> in base 9 = 1235
1. <img src="/tex/c3e5cde49326c5e4cab6aba5b4dbe898.svg?invert_in_darkmode&sanitize=true" align=middle width=37.76272169999999pt height=21.18721440000001pt/> in base 12 = 617
1. <img src="/tex/49e29fcd71eb88f345fbec36b544d1fd.svg?invert_in_darkmode&sanitize=true" align=middle width=37.76272169999999pt height=21.18721440000001pt/> in base 5 = 11300

### Transcript


#### Code:



```
#File: BaseConverter.py
#Author: Melchisedek (mdulc928)
#Class: CPS 230

letters = {"A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15, "G": 16}
def toBase10(num: str, base: int) -> int:
    iNum = list(num)
    iNum.reverse()
    nNum = 0
    
    for i in range(len(iNum)):
        temp = iNum[i]

        if temp.isdigit() != True:
            temp = letters[temp]

        nNum += int(temp) * (base ** i)
    return(nNum)

def fromBase10(num:int, base: int) -> str:
    dividend = num
    remainders = []
    while dividend != 0:
        dividend, remainder = dividend//base, dividend%base

        if remainder > 9:
            for k in letters.keys():
                if letters[k] == remainder:
                    remainder = k
        remainders.append(str(remainder))
        
    remainders.reverse()
    return "".join(remainders)

def fromBasetoBase(cNum: str, fbase: int, tbase: int) -> str:
    tempNum1 = toBase10(cNum, fbase)
    tempNum2 = fromBase10(tempNum1, tbase)
    return tempNum2

d = int(input())
for i in range(d):
    num, fbse, tbse  = str(input()).split(" ")
    n = fromBasetoBase(str(num), int(fbse), int(tbse))
    print(n)
```

#### Input:



```
10
558 9 10
1453 6 10
2122221 3 10
223 9 10
897 11 10
2121221 3 10
27 10 11
923 10 9
883 10 12
825 10 5
```