# Team Project: Kernel

## Overview

The team project for this semester is the creation of a multi-tasking "kernel" that
can demonstrate running at least 4 independent threads of execution and a bootloader
that can load the kernel from a bootdisk.

You **must** keep an ongoing journal of your time using [Clockify](https://clockify.me).  You should have received an invite allowing you access to the department's account.  On that account, you should have access to Kernel project with tasks for the Alpha, Beta and Final phases.  Please keep a running journal of what you did each day and how long you spent doing it. 

See the overall project grading rubric [here](team_project_rubric.xlsx).

## Milestones

The project will be broken into 3 milestones: 2 "checkpoints" and the final deliverable.

### Alpha

Your "kernel" should be packaged in a simple DOS executable (a `.COM` file).  It should
demonstrate the cooperative multitasking of at least 2 independent tasks.  By "cooperative,"
we mean that each task must explicitly "yield" to the next task by calling a `yield` function.

Each "task" should do something *observable* and *distinguishable* on-screen;
i.e., each task should give a visible indication that it is running, and these indications
should be immediately/obviously distinct.  The most bare-bones (and boring, and unlikely to
result in a thrilling final grade) demo would be to have task A print "`I am task A`" and task B
print "`I am task B`" to console using DOS system calls. 

While the priority for the Alpha is the cooperative task switching, you should be giving thought to
later milestones, and planning ahead for:

* More visually exciting demos (not necessarily graphics, but having text animated in different parts of the screen)

* More than 2 tasks at once (should be only a small generalization once you have 2 tasks working)

* Any "elective" features you want to complete (e.g., timer-preemption)

**Submission**: Submit 2 files

* `kernel.asm`: the code for your Alpha-stage demo (I will assemble it with the command `nasm -fbin -okernel.com kernel.asm`)
* `README.txt`: a terse report including a list of any known bugs/issues and how many hours each team member has spent so far

### Beta

In this stage, you will write a bootloader that will load your kernel from sectors on the bootdisk into memory and start it running.

The bootloader will consist of a *first stage* bootloader residing in the first sector of a disk image.
It must include the **Master Boot Record** signature and take up *no more than 512* bytes.

It will load the kernel from sectors 2 through N (however many sectors your kernel ends up taking)
from the simulated disk and then execute it.
The kernel will be loaded into memory at address `0800:0000`.

The bootloader needs to *print your team members' names* and *prompt for a keypress* before running the kernel.

Note that since you are loading your own "operating system" from scratch here, you *cannot use DOS* (i.e., `int 0x21`) for anything.
At this point, *there is no DOS!*
(Well, that's not strictly true on DOSBox since DOSBox fakes everything.  But it would be true on a real vintage PC, so that's how
we're going to roll...)

**Much of this is already provided to you in incomplete form in Lab 9**.  So the Beta stage should not take much time in an of itself.

*Plan ahead!*

Use any extra time in this stage to get a jump start on any elective features you plan to do for the final stage.

**Submission**: Submit 4 files

* `boot.asm`: the code for your bootloader itself
* `kernel.asm`: the code for your kernel demo code
* `bootdisk.img`: the complete floppy-disk image containing your bootloader/kernel combination
* `README.txt`: a terse report including a list of any known bugs/issues and how many hours each team member has spent so far

### Final

This is it!  At this point you should already have:

* A kernel capable of multi-tasking at least 2 or more independent "threads" of execution (i.e., 2 or more different demo "programs")

* A bootloader capable of loading this kernel from disk and kicking it off without any help from DOS or user intervention

For this final stage you will:

* Extend your multi-tasking to support at least 4 tasks (if you have not already), and have your demos incorporate all of them

* Make sure each task has at least **256 bytes** of dedicated stack space

* Fix any outstanding bugs

* Finish any elective features you wish to do (and you almost certainly will)

* Polish up your code (comments, etc.)

* Produce a succinct, informative, neatly-formatted team project report in markdown

    * Class name/number, project name, team members, and date
    * Overview (brief abstract of the project goals, for readers unfamiliar with the project)
    * Results (list of required and elective features completed, along with any known bugs)
    * Details (brief overviews of your multi-tasking and bootloading logic, along with descriptions of your demo tasks)
    * Contributions (description of each team member's contributions, including total number of hours worked)

If you are not printing a physical copy, make sure to list in the report any help you received as well as a statement that all work is your own.  Help received from the professor does not need to be listed.

If you are printing out your report, staple one of the department honesty sheets to the top listing the help received on the sheet.  Turn this report in at the beginning of the class period after the due date.

**Submission**: Submit the following files

* `boot.asm`
* `kernel.asm`
* `bootdisk.img`

along with a copy of your report.

## Teamwork

You must divide the work between yourselves as evenly as is possible/practical.  Communication is key (and is a component of your grade!).

In addition to a single team report, you will each individually *email* the instructor with a *personal*
report in which you will "grade" yourself and your teammate on

* communication (how well each member communicated intent/ideas to the other member)

* equity (how well each member pulled his/her own weight)

* unity (how well the members were able to work together, especially in the face of disagreement [which is inevitable])

## Basic Electives

Assuming no mistakes/bugs/omissions/errors of any kind at any point along the project,
completing the baseline/required features will earn your team **200** points out of **250**.

*Many* more points are available in the form of *elective* features from which you may pick and choose.  See below...

### Timer Preemption (25 pts)

Hook the timer interrupt (`INT 8`) vector and use this hook to *preemptively* switch tasks.

This will require several changes to your kernel:

* You will have to implement the interrupt hook itself (see Lab 10)

* You will have to modify how you switch tasks (because we are now "yielding" by way of interrupt rather than by way of normal function call)

* You will have to save/restore the segment registers (if you weren't already), since our "yield" may happen *while we are executing BIOS code that
    had temporarily changed the segment registers* (and we will need to restore that when we come back to the interrupted task)

* You will have to modify how you set up your "kickstart" stacks (because see above)

In particular, debugging will get harder once interrupts are involved.  But it's pretty cool to be able to remove all calls to `yield` from
your task code and watch the multi-tasking still work!

### PN Calculator Demo (25 pts)

Adapt/port your PN caluclator (Program 2, remember?) to run as a 16-bit demo task inside your kernel.  Obviously, you will need
to change how you get input (no more `_getchar`) and write output (no more `_putchar` or `_printf`).

Input should be relatively easy: `int 0x16/ah=0x00` is basically the BIOS equivalent of `_getchar`.

Output will be trickier, because you don't have `_printf` and will need to write code to print grok integers.  Even character by character output might be tricky: remember that this will be *one* of several demos--you'll have to write your output in a way that
"shares" the screen with other demos!

If you are also implementing **timer preemption**, you can use "blocking" input
(like `int 0x16/ah=0x00`) without hanging everything.
But if you are sticking with *cooperative* multitasking, you will need to
modify your calculator to *check* for keyboard input (`int 0x16/ah=0x01`) without *waiting* for keyboard input; if no input is available,
you can immediately *yield* to the next task.

### Graphics Demo (25 pts)

Have at least one of your demo tasks do something graphical (with either pixels or ASCII art).

* ASCII ideas:
    * Random maze generation (and/or solving)
    * Conway's Game of Life (played out using "block" characters to represent live cells)
    * Bouncing "ball" (block character)
* Pixel ideas:
    * Loading images from disk sectors (i.e., a slide show)
    * Random falling "snow" piling up on some "obstacles" left in its way
    * Fractal generation (e.g., [Mandelbrot](https://en.wikipedia.org/wiki/Mandelbrot_set#Computer_drawings))
    

Note that several of these rely on "random" numbers, which you will have to generate for yourself.
[This](https://en.wikipedia.org/wiki/Linear_congruential_generator) might be useful...

You are free to come up with your own variations/ideas, but whatever you do should be at least as "impressive" as the above sound.
Consult with the instructor to be safe.

### Music Demo (25 pts)

Use either the [PC speaker](Use either the [PC speaker](http://muruganad.com/8086/8086-assembly-language-program-to-play-sound-using-pc-speaker.html) to play a melody in the background.) to play the melody of the BJU alma mater in the background of your demos.

If you are *not* doing timer-preempted task switching, you will probably want to hook `INT 8` to provide smooth/lag-free music updates.  If you go this route, you may even find that you need to [reprogram counter 0 on the PIT](http://stanislavs.org/helppc/8253.html) to give you a faster interrupt frequency (so you can update notes more quickly).

If you *are* doing timer-preemption, this will be very challenging (you might have to have your timer interrupt hook doing double-duty; both
switching tasks *and* updating the current music notes).

## Challenge Electives

These are very challenging "stretch" goals for highly motivated teams that aren't afraid to research topics and solve problems for themselves.

For full credit, these ideas must be beyond the "proof of concept" phase and fully integrated with your bootloader/kernel/demos.

There is partial credit available for *bona fide* efforts along these lines that do not make it beyond the "proof of concept" phase.

### Real-Mode C (50 pts)

Figure out how to use a 16-bit, real-mode-compatible C compiler (like TurboC) to write at least some of your demo code in C. See [this tutorial](https://ethantmcgee.com/bju/cps230/info/realmodec) to get started.  Note: If you complete this option, you do NOT need to create a bootable version of the project.  You will deliver an exe version instead.

### Protected Mode (50 pts)

Figure out how to switch the x86 into *protected mode* (full 32-bit addressing!)
before running your demos.  You won't be able to access the BIOS anymore (for all practical purposes), and interrupts will work very differently,
so you would have to change your preemptive task switching code substantially (or drop it all together).
