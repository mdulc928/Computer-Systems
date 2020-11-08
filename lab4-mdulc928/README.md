# Lab 4

[Check Submission](https://protect.bju.edu/cps/checker/cps230/lab4)

## Overview

Welcome to assembly programming!  In this lab, you will experiment with and [slightly] modify a provided assembly program.

## Procedure

Before starting, make sure you have the required tools:

* NASM 2.x
* Build Tools for VS 2019 installed

## Orientation
 
Download and familiarize yourself the [starting code](lab4.asm).  Go ahead and change the comments at the top to reflect your identity.

Compare the starting ASM program to its equivalent version in C:

``` c
#include <stdio.h>

unsigned long long int the_integer = 0;

int main() {
	printf("Please enter an integer: ");
	scanf("%lld", &the_integer);
	
	the_integer += the_integer;
	
	printf("Your number added to itself is: %d\n", the_integer);
	
	return 0;
}
```

Try to identify (without the aid of any compilers/tools) which lines of C correspond to which lines of ASM.  Are there ASM lines that don't seem to correspond to anything in the C program?  What about vice-versa?


## Assembling

Just like C code has to be *compiled* in order to run, so assembly code must be *assembled* in order to run.  We'll be using an assembler called NASM (the Net-wide Assembler).

* Open a NASM command prompt (search for `nasm-shell` in the Start menu)

* Navigate to the folder where you saved `lab4.asm` using the `cd` command (`C> cd C:\Users\emcgee\Downloads\lab4\`)

* Run the following command (again, don't type the `C> ` part):

        C> nasm -g -fwin64 lab4.asm
        
        C>

* You shouldn't see any output at all (other than the command prompt reappearing); **if you do, seek experienced help immediately**

* The line you just typed breaks down into several components:

    * `nasm`: we're running NASM, of course
    * `-g`: option/flag telling NASM to include debugging information in the output *object file*
    * `-fwin64`: option/flag telling NASM to generate an *object file* compatible with 64-bit Windows tools (like Visual Studio)
    * `lab4.asm`: the file to assemble (NASM will generate an output *object file* named `lab4.obj`)

* Run the `dir` command; you should now see a `lab4.obj` file in addition to `lab4.asm`; congratulations, you've assembled the program into an *object file*

## Linking

Your *object file* is not actually executable yet--it needs to be *linked* with some other stuff before it can run.  We'll use the Visual Studio command-line tools for this part.

Either

* Open a Visual Studio 2019 **x64** native tools command prompt (as you've done before) and navigate to your Lab 4 folder, *OR*
* Run the following command in your already-open NASM command prompt window (this has the effect of turning your NASM command prompt into a hybrid NASM/Visual Studio command prompt; cool, huh?)

        C> "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"

Now that you can run `cl` (remember: `cee-ell`, not `cee-one`!), do this

        C> cl /Zi lab4.obj msvcrt.lib legacy_stdio_definitions.lib

Let's break down that line into its components:

* `cl`: run the Visual Studio C/C++ *compiler driver* (normally used to compile C/C++ code, but here just being used to trigger linking)
* `/Zi`: an option flag telling `cl` to include debugging metadata in the resulting EXE file
* `lab4.obj`: the object file containing our code/data
* `msvcrt.lib`: the Micrsoft Visual C/C++ Run-Time library (containing all the extra "stuff" needed to get a runnable program)
* `legacy_stdio_definitions.lib`: a compatibility library needed when calling `printf` and `scanf` from assembly code

## Running

Run the program in your console window (just type `lab4` and hit `Enter`), experimenting with different inputs.

What happens if you enter `fred` instead of a number?

## Debugging

Remember WinDBG from lab 1? He's back!!

WinDBG is pretty much the only way to debug native assembly files right now (unless you have Visual Studio 2015 or earlier installed in which case Visual Studio should work).  But anyway, WinDBG is what I'll be using in class, so its a good idea to get familiar with it.  

Open WinDBG from the start menu (the x64 version). From here, click File > Open Executable, and select the exe you generated.  Ignore the windows that open, and click File > Open Source File, and select your .asm file.  (Note: You'll need to select Assembly Files from the Files of Type dropdown at the bottom of the open window).

Now put your cursor on the first line under `main:` and press F9.  The line should turn red, and at this point you can click Debug > Go.

F11 allows you to step into function calls, and F10 allows you to step over.

Under view, you'll find several other windows that allow you to open a memory viewer, or a view of the registers. 

## Personalizing

Pay close attention to how the program calls `printf`.  Notice several things:

* The format string must be defined elsewhere (e.g., in the `.data` section) and must have a label so we can refer to it
* Arguments are put into registers!  The first argument goes into rcx and the second goes into rdx. (Third goes into r8 and fourth r9.  What happens after that?)

Now, **add the necessary code/data to print your name/etc.** *before* the prompt asking for an integer is printed.  The output should now look like this (prior to any user input):

        CpS 230 Lab 4: Alice B. College-Student (acoll555)

        Please enter an integer: 

With, of course, the appropriate modifications to the name/login. :-)

## Report

Turn in the standard report formatted in markdown.  Remember, the report should include:

1. How many hours did you worked on the lab?
1. Did you encounter any problems and what were they?
1. If yes to the previous question, did you need help to resolve these problems?
1. What did you learn?

## Submission

Turn in:

* `report.md`
* `lab4.asm`

## Validating Submission

[Check Submission](https://protect.bju.edu/cps/checker/cps230/lab4)

## Grading

* 6 points for a well-formed submission (including report)
* 4 points for a working `lab4.asm` 

