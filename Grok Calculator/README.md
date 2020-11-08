# Program 2

[Check Submission](https://protect.bju.edu/cps/checker/cps230/prog2)

## The Great Grok Calculator

Groks are curious beings that came to earth many years ago.  You've probably heard of the Roswell, New Mexico incidient.  That was an unfortunate mistake caused by one lone Grok who forgot to turn left at Saturn while traveling at light speed.  Fortunately, Grok spaceships are very safe and when it detected earth, the ship slowed down such that no one was injured.  Unfortunately all the Grok calculators were destroyed, and they need your to help them build a new one.

## Grok Notation

It turns out that the mathematician Jan Łukasiewicz was actually a Grok who retired to earth many years ago.  His notation, Polish notation, was just Grok math with an Earth base.  Yes, unfortunately, Grok's use the dreaded base 19.  Grok's have said they like our hexadecimal base so the calculator can use (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F, G, H, I) for digits.

Polish notation is unique in that it does not require parenthesis. Consider the infix expression:

```
3 + 5 * 7
```

In order to evaluate this expression, you must know the order of operations!  Multiply first and then add.  Polish notation would write this statement in prefix notation or:

```
+ * 5 7 3
```

Evaluating a Polish notation statement is very straightforward.

```
for item in reverse(expression):
    if item is number:
        push to stack
    else:
        pop number of items required for operator
        perform operation
        push result on stack
pop result off stack
```

So for example, reversing `+ * 5 7 3` would yield `3 7 5 * +`. The first item is a number so it is pushed to the stack giving us a stack of `<bottom> 3`.  The second item is a number so it is pushed to the stack giving us a stack of `<bottom> 3 7`.  The third item is a number so it is pushed to the stack giving us a stack of `<bottom> 3 7 5`.  The next item is an operand requiring two values.  We pop 7 and 5 off, multiply them to get 35 and push 35 onto the stack yielding `<bottom> 3 35`.  The next item is an operand that requires to values.  We pop 35 and 3 off, add them to get 38 and push 38 onto the stack yielding `<bottom> 38`.  The result is now at the top of the stack.

## Hints

1. While we do have direct stack manipulation instructions, `push` and `pop`.  It might be more beneficial to write your own stack using an array with wrapper `push` and `pop` values.  This will free up the real stack for operations and recursion if you need them.
1. `scanf` is a beautiful lie for this assignment since spacing can vary wildly.  For example, you are guaranteed a space between numbers.  You are not guaranteed a space between operators.  Use `gets` instead.  Lines are capped at 80 characters so no need to prevent a buffer overflow.
1. The `neg` instruction is your friend for `~`.

## Maximum 80%

For this level, you are guaranteed valid inputs and each number will consist of only a single digit.  You only have to support 3 operators: `+`, `-` and `~`.  Remember that Groks use base 19 so you will need helper methods to convert to / from base 19 so that you can perform that math operations correctly.

1. Users will enter a line of input.  Process the input, in reverse, character by character.

    1. If the character is a base 19 digit, convert it to decimal and push.
    1. If the character is an operator, perform the operation popping items off the stack and pushing the result back on.
    1. Ignore any other character.
    1. Print the result after the line has been evaluated.

1. The program should terminate when the user enters a blank line.

_Sample Run_
```
> +2 3
5
> +~-2 3 4
5
>
Thank you for visiting Earth.  We hope you make it home safely.
```

## Maximum 90%

For this level, you are not guaranteed valid inputs and you must support multi-digit numbers. For example, a user could input `+23` which will result in an error because there are not enough operators for the operand (called a stack underflow).  You must also add support for multiplication `*` and division `/`.

1. Users will still enter input line by line.

    1. If the character is a base 19 digit, add it to a holder for the current number.
    1. If the character is a space or an operator, push the current number (if there is one).
    1. If the character is an operator, perform the operation after pushing.
    1. Print the result after the line has been evaluated (unless there was an error).

1. If the stack underflows, print an error message stating that an underflow occurred.  The underflow will require you to write your own stack with custom push and pop functions.

_Sample Run_
```
> +23 51
74
> +23
STACK UNDERFLOW!!
>
Thank you for visiting Earth.  We hope you make it home safely.
```

## Maximum 100%

For the 100%, we will add 26 variables to the grok calculator (lowercase a - z).  To assign a variable, enter `=<letter>` on a line by itself and the previous result will be placed into the variable.  All variables have a default value of 0.

To use a variable simply place it into a calculation as usual.

```
> ++a b 2
2
> =a
> ++a b 2
4
>
Thank you for visiting Earth.  We hope you make it home safely.
```

Note: like operators, spacing between variables is not required since we know they will be one character only.

## Extra Credit (+10%)

For the truely brave (or bored), explore the world of floating point operations in the Intel manual.  Then rework your calculator so that all numbers are stored as 64-bit floating point numbers and all operations occur as floating point operations.  For simplicity, keep your calculator input as integers only.

## Submission

Turn in your `grok.asm` file as well as a copy of your report (fill out the [template](report.md)).

## Validating Submission

[Check Submission](https://protect.bju.edu/cps/checker/cps230/prog2)
