#include <stdio.h>
#include <stdlib.h>

int main() {
	char fChar = 1, sChar = -1;
	do {
		printf("Enter two characters: ");
		if (scanf("%c%c", &fChar, &sChar) == 1)
		{
			printf("Well, I guess, next time...\n");
			exit(1);
		};
	} while (sChar < 1);

	int sAscii = sChar;
	int fAscii = fAscii;

	if (fAscii > sAscii) {
		for (int i = fChar; i <= sAscii; i++) {
			printf("%2c: %3d %#x\n", i, i, i);
		}
	}
	else {
		for (int i = fChar; i >= sAscii; i--) {
			printf("%2c: %3d %#x\n", i, i, i);
		}
	}
	
}