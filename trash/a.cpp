#include <bits/stdc++.h> 
#include <sys/mman.h>
#include <unistd.h>

extern "C" size_t strl(char* c);

const int SIZE = sysconf(_SC_PAGE_SIZE);

int main () {
	std::cout << SIZE <<std::endl;
    char * a = (char*)(mmap(nullptr, SIZE, PROT_WRITE | PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0));
    for (int i = 0; i < SIZE-1; i++) {
    	a[i] = (i+1)%255 + 1;
    }
    std::cout << strl(a + SIZE - 300) << " " << strlen(a + SIZE - 300) << std::endl;
}



	mov ebx, [esi+20]
	sub edi, 4
	mov ecx, [edi]
	cmp dl, 1
	jne n12
	cmp ecx, 1
	jne n12
	mov cl, '-'
	mov [ebx], cl
	inc ebx
	cmp eax, 0
	je n12
	dec eax
	n12:

	mov ecx, edi
	sub ecx, esp
	shr ecx, 2
	cmp eax, ecx
	mov esi, 0
	jnae loop8
	sub eax, ecx
	mov esi, eax
	mov ecx, 0
	cmp dh, 2
	jne loop8
	loop7:
		cmp ecx, eax
		je loop8
		dec esi
		push edx
		mov dl, '0'
		mov [ebx], dl
		inc ebx
		pop edx
		inc ecx
		jmp loop7
	


