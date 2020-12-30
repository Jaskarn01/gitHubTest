#include <stdio.h>

int main() {
	printf("Enter a number: ");
	int n;scanf("%d", &n);
	for (int i=0;i<=n;i += 1) 
		printf("Currently at: %d", i);
	return 0;
}
