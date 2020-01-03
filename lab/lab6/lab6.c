#define _CRT_SECURE_NO_WARNINGS 
#include <stdio.h>

void hanoi(long long int disk, long long int src, long long int dst, long long int tmp) {
    if (disk == 1) {
        printf("Move disk 1 from %d to %lld\n", src, dst);
    } else {
        hanoi(disk - 1, src, tmp, dst);
        printf("Move disk %lld from %lld to %lld\n", disk, src, dst);
        hanoi(disk - 1, tmp, dst, src);
    }
}

int main() {
    long long int num_disks;

    printf("How many disks do you want to play with? ");
    if (scanf("%lld", &num_disks) != 1) {
        printf("Uh-oh, I couldn't understand that...  No towers of Hanoi for you!\n");
        return 1;
    }
	
	printf("%lld %lld\n", 2, 3);

    hanoi(num_disks, 1, 2, 3);

    return 0;
} 