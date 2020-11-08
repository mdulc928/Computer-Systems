# Project Kernel

**Class Name:** CPS 230 Computer Systems

**Team Members:**

- Stone Champion
- Melchisedek Dulcio

## Abstract:



Project Kernel demonstrates the ability to run different tasks, not necessarily simultaneously, but rather with the preservation of the stack for each thread of execution, we make it seem as though it were running simultaneously.Thus we implemented a timer interrupt to fire to switch between the different tasks for us. One demo is playing the first line of Mary had a little lamb while doing. We also semi-implemented a bouncy ball that moves with accordance to the input from the user.  
## Known Bugs

- The music will freeze at certain points.
 * The bouncy ball does not necessarily move the length of the string input.
 * The other graphic demos will go over the previous input and so it will not look very good.

## Implementation Details & Results

- Music : Plays the tune of Mary had a little lamb.
    * Freezes at certain points
- Bouncy : Moves on the screen the length of the input string.
    * overwrites other displays on the screen.
- Timer : completely implemented replacement timer for our int 8.
    * Done
- MBR : Boots the kernel from disks
    * Done 
- Tasks:
    1. Music
        * see above
    2. Bouncy
        * see above
    3. Text Display of Tasks
        * Done.

## Contributions

**Stone Champion**

- Contributions:

    * Brainstorming
    * Alpha Stage
    * Beta Stage
    * Task system
    * Music implementation
    * Booting

- Hours: 20.7

**Melchisedek Dulcio:**

- My contributions
    * Cooperative task switching for Alpha
    * Updated MBR and kernel during Beta
    * Pre-emptive task switching.
    * The ball that was suppose to bounce
    * Ensuring that the code would run.
- Hours: 32 hrs
