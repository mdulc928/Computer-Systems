# Lab 2

[Check Submission](https://protect.bju.edu/cps/checker/cps230/lab2)

## Goals

* Learn how to use `printf` and `scanf`, two workhorse functions in the standard C library

* Learn basic C control structures like `if/else`, `while` loops, and `for` loops

* Become aware of the behavior that is possible in a "low level" language like C

# Instructions

## Starting Code
```
#include <stdio.h>
#include <stdlib.h>

int main() {
    int max = -1, i;

    while (max < 1) {
        printf("What number should I count up to? ");
        if (scanf("%d", &max) != 1) {
            printf("Whoops! You need to give me an integer!\n");
            exit(1);
        } else if (max < 1) {
            printf("I can't count UP to %d!\n", max);
        }
    }

    for (i = 1; i <= max; ++i) {
        printf("%5d!\n", i);
    }
    printf("ALL DONE!\n");

    return 0;
}
```

## Steps

1. Compile/run the starting code (name it anything you like) and try several inputs:

    * A "reasonable" input (like "10")

    * An "unreasonable" input (like "-3")

    * A pathological input (like "ten")

2. Do some experiments (after each experiment, restore the original starting code):

    * Change the `%5d` on **line 18** to `%05d` and re-test; what changes?  Now try `%-5d` for comparison.

    * Remove the `, max` from **line 13** and re-test the program; what happens?
    
    * Change the `%d` on **line 13** to `%c` and re-test; what happens if you enter -1?  -1001?
    
    * Remove the `, &max` from **line 9** and re-test; what happens now?  

3. Write a *new* program (from scratch) named `lab2.c` that:

    * Prompts the user for exactly 2 ASCII characters (use `char` type variables and format code `%c` to scan each)

    * Aborts if anything goes wrong with `scanf()`

    * Prints out all characters between the two characters entered, inclusive (e.g., input "AC" means to process and output "A", "B", and "C")

    * Using the following format "&lt;character&gt;: &lt;ASCII code in decimal&gt; (0x&lt;ASCII in hex&gt;)"

    * Use padding to make all the columns line up perfectly


## Report

Turn in the standard report formatted in markdown.  Remember, the report should include:

1. How many hours did you worked on the lab?
1. Did you encounter any problems and what were they?
1. If yes to the previous question, did you need help to resolve these problems?
1. What did you learn?

## Submission

Turn in:

* `report.md`
* `lab2.c`

## Validating Submission

[Check Submission](https://protect.bju.edu/cps/checker/cps230/lab2)

## Grading

* 5 points for a well-formed submission (and report)
* 5 points for the functionality of your ASCII printing program