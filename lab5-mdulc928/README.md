# Lab 5

[Check Submission](https://protect.bju.edu/cps/checker/cps230/lab5)

## Overview

In this lab you will write a simple "guess the number I'm thinking of" game in x64 assembly!

This lab is worth **15 points**.

## Goal

Your job is to "port" the following C program to x64 assembly code (NASM syntax rules):

```c
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

long long int magic_number = 42;  // TODO: change this
long long int your_guess = 0;

int main() {
    while (your_guess != magic_number) {
        printf("I'm thinking of a number between 1 and 100; what is it? ");
        scanf("%lld", &your_guess);
        
        if (your_guess == magic_number) {
            printf("You guessed it! Thanks for playing...\n");
        } else if (your_guess < magic_number) {
            printf("Too low!\n");
        } else {
            printf("Too high!\n");
        }
    }
    
    return 0;
}
```

You should, of course, pick your own "magic" number rather than leaving it at 42.

## Getting Started

Take the "hello world" assembly program from Lab 4 as your starting template: strip out the logic that was specific to Lab 4,
leaving only the basic "skeleton" of an assembly program (text/data section directives, external/global symbol declarations,
`main` function prologue/epilogue, etc.)

## Core Logic (10 Points)

The heart of the game is the logic that decides if the player's guess is too high, too low, or just right.

There is no `if` statement in assembly (well, not in *real* assembly--some "macro" assemblers will pretend
to give you `if` statements, but we're going to be real men/women and do it the right way).

In x86 assembly, you have 2 basic tools:

* Arithmetic/logic instructions that update the *flags*
    * Most if not all operations do have some effect on the flags
    * But `CMP A, B` is the really important one (it performs an implicit `A - B` operation, setting the flags accordingly)
* Conditional jump instructions that *branch* to a particular code label based on flag settings (particularly, the flags as set by `CMP A, B`)
    * `je` ("jump-if-equal") if `A` was equal to `B`
    * `jg` ("jump-if-greater") if `A` was greater than `B` (signed comparison)
    * `jl` ("jump-if-less") if `A` was less than `B` (signed comparison)
    * `ja` ("jump-if-above") if `A` was greater than `B` (**unsigned** comparison)
    * `jb` ("jump-if-below") if `A` was less than `B` (**unsigned** comparison)

The basic pattern for converting a C-style `if` statement into assembly is as follows (in pseudo-assembly):

        perform comparison/test operation (setting flags)
        jump-on-condition-false to LABEL_ELSE:

        (perform "true" branch of if statement)
        
        unconditional-jump to LABEL_END:
        LABEL_ELSE:

        (perform "false" branch of if statement)

        LABEL_END:

        (continue with the program)

That is the most generic form, of course, and is what a rather brain-dead compiler would always generate.  Usually, when working by hand, you can "optimize" away unneeded jumps etc.  Just don't be *too* clever, or you may have trouble understanding your own code. :-)

## Tips

* Instead of trying to create a proper `while` loop in assembly, just make an *infinite* loop that you *break out of* when you detect the winning condition
* Use `cmp`, `je`, `jg`, and/or `jl`
* Put the code to print the victory message *outside* (i.e., after) the main loop so that simply jumping to its label both breaks you out of the loop and prints the message
* Tackle this in stages
    * First, get user prompting working working (using `printf` and `scanf`)
    * Then, get it looping, prompting the user repeatedly
    * First, get the exact-equality-to-win test working
    * Then, add the test and logic for "too low"
    * Finally, add the other side ("too high")

## Counting the Number of Guesses (2 Points)

Add a variable and logic to count how many guesses it takes the user to guess the magic number.  After the user "wins", print a message telling them how many guesses it took them.

## Random Numbers (3 pts)

Let's be honest--playing a "guess the random number" game where the "random number" is the same every time is **boring**...

Look up the [rand_s function](https://msdn.microsoft.com/en-us/library/sxtz2fa8.aspx) in the Microsoft Visual C/C++ runtime library. Call it at the beginning of your program (before the main loop) to initialize your `magic_number` variable to something, well, *random*.

Note that
* You need an `extern` for `rand_s`.
* You need to pass the *address* of your variable to `rand_s` (just like when using `scanf`!)
* You want the random number *modulo 100, plus 1* (to give you a random number in the range 1 .. 100), so you will have to look up how `div` (the unsigned division instruction) works; it's *weird*, but quite doable
* **Pro Tip**: get this working in C first before even thinking about doing it in assembly

## Report

Turn in the standard report formatted in markdown.  Remember, the report should include:

1. How many hours did you work on the lab?
1. Did you encounter any problems and what were they?
1. If yes to the previous question, did you need help to resolve these problems?
1. What did you learn?

## Submission

Turn in:

* `report.md`
* `lab5.asm`

## Validating Submission

[Check Submission](https://protect.bju.edu/cps/checker/cps230/lab5)
