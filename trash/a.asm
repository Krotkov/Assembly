section .text

global amax
amax:
	mov ecx, [esp + 4]
	mov edx, [esp + 8]

	pxor mm0, mm0

	cmp edx, 8

	jb ending

	getmax:
		movq mm1, [ecx]
		add ecx, 8 
		pmaxub mm0, mm1
		sub edx, 8
		cmp edx, 8
		jnb getmax

	pshufw mm1, mm0, 0xEE

	pmaxub mm0, mm1

	pshufw mm1, mm0, 0x55

	pmaxub mm0, mm1

	movq mm1, mm0

	psrlw mm0, 8

	pmaxub mm0, mm1

ending:

	movd eax, mm0

	cmp edx, 0
	jz end	

	loop1:
		mov ah, [ecx]
		add ecx, 1 
		cmp al, ah
		ja hh
		mov al, ah
		hh:
		dec edx
		jnz loop1
	
end:
	ret
