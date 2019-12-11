section .text

global strl
strl:
	mov eax, [esp + 4]
	vpxor ymm1, ymm1, ymm1 
	mov ecx , eax
	shr eax, 5
	shl eax, 5
	cmp eax, ecx
	jz loop1

	vpcmpeqb ymm0, ymm1, [eax]
	vpmovmskb edx, ymm0

	sub ecx, eax

	shr edx, cl
	shl edx, cl

	push eax
	mov eax, ecx

	bsf ecx, ecx


    mov edx, 32
    sub edx, ecx
    mov ecx, edx

    bsf eax, eax
    pop eax
	jnz end

int3

	loop1:
		vpcmpeqb ymm0, ymm1, [eax]
		add eax, 32
		vptest ymm0, ymm0
		jz loop1
	vpmovmskb ecx, ymm0
	sub eax ,32
	bsf ecx, ecx
	end:
	add eax, ecx	
	sub eax, [esp + 4]
	ret
