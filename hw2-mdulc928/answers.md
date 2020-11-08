# Homework 2



1. <img src="/tex/80ddd039ad15d5fff84af45474131a17.svg?invert_in_darkmode&sanitize=true" align=middle width=97.35178199999999pt height=21.18721440000001pt/>

**Solution:**

```
Convert:
    -(6)  => 00110 => 11001 => + 1 => 11010
  + -(22) => 10110 => 01001 => + 1 => 01010
  ---------------------------------------------------
                                     100100 - carry
Convert back:
    100100 => -(2^5) + 2^2 = -32 + 4 => -28 
```

1. <img src="/tex/9831ac5f71836aa7480215643c3ef4c5.svg?invert_in_darkmode&sanitize=true" align=middle width=113.79020069999999pt height=21.18721440000001pt/>

**Solution:**

```
Convert:
    -(109) => 1101101 => 0010010 => + 1 => 0010011
  + - (33) => 0100001 => 1011110 => + 1 => 1011111
  ---------------------------------------------------
                                           1110010 - neither
Convert back:
   1110010  => -(2^6) + 2^5 + 2^4 + 1 = -64 + 32 + 16 + 1 => -15
```

1. <img src="/tex/b6004a4551b4f8019b859e640e6ba948.svg?invert_in_darkmode&sanitize=true" align=middle width=88.21933394999999pt height=21.18721440000001pt/>

**Solution:**

```
Convert:
     56 => 0111000
  + 117 => 1110101
  -----------------
          10101101  - carry
Convert back:
    10101101 => 2^7 + 2^5 + 2^3 + 2^2 + 2 = 128 + 32 + 8 + 4 + 1 => 173 
```

1. <img src="/tex/d96586f98111dbe359e1f3e60a918edd.svg?invert_in_darkmode&sanitize=true" align=middle width=88.21933394999999pt height=21.18721440000001pt/>

**Solution:**

```
Convert:
    101 => 1100101 
  +  16 => 0010000
  -----------------
           1110101 - neither
Convert back:
    1110101 => 2^6 + 2^5 + 2^4 + 2^2 + 2 = 64 + 32 + 16 + 4 + 1 => 117 
```


1. <img src="/tex/0c54e552b8a9db7a04fa01e07e75f77f.svg?invert_in_darkmode&sanitize=true" align=middle width=101.00476649999999pt height=21.18721440000001pt/>

**Solution:**

```
Convert:
       70  =>                              1000110
  + -(105) => 1101001 => 0010110 => + 1 => 0010111
  ---------------------------------------------------
                                           1011101- neither
Convert back:
    1011101 => -(2^6) + 2^4 + 2^3 + 2^2 + 1 = -64 + 16 + 8 + 4 + 1 => -35 
```

