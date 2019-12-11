section .text

global atatan
atatan:
	movss xmm0, [esp + 4]
	mov eax, [esp + 8]

	shufps xmm0, xmm0, 0x0

	movaps xmm1, xmm0

	mulps xmm1, xmm1
	movss xmm4, xmm1
	mulps xmm1, xmm1

	movaps xmm5, xmm1
	mulss xmm5, xmm5	
	mulss xmm5, xmm5

	movss xmm2, [trueonefloat]
	shufps xmm1, xmm2, 0x0

	shufps xmm1, xmm1, 0x2A

	mulps xmm0, xmm1
	shufps xmm1, xmm1, 0xF9
	mulps xmm0, xmm1
	shufps xmm1, xmm1, 0xF9
	mulps xmm0, xmm1

	movaps xmm7, xmm0
	shufps xmm4, xmm4, 0x0
	mulps xmm7, xmm4
	movaps xmm4, [truemonefloat]
	mulps xmm7, xmm4

	movaps xmm2, [onefloat]
	movaps xmm3, [twofloat]
	movaps xmm1, [seqfloat]

	loop1:
		movaps xmm4, xmm0
		divps xmm4, xmm2

		addps xmm6, xmm4
		mulps xmm0, xmm5
		addps xmm2, xmm3

		movaps xmm4, xmm7
		divps xmm4, xmm1

		addps xmm6, xmm4

		mulps xmm7, xmm5
		addps xmm1, xmm3

		dec eax
		jnz loop1

	movaps xmm0, xmm6
	shufps xmm0, xmm0, 0xEE
	addps xmm6, xmm0
    movaps xmm0, xmm6
	shufps xmm0, xmm0, 0x01
	addps xmm6, xmm0	
	movss [esp + 4], xmm6
	fld dword [esp+4]
	ret


section .rdata
	trueonefloat: dd 1.0
	align 16
	onefloat: dd 1.0, 5.0, 9.0, 13.0
	seqfloat: dd 3.0, 7.0, 11.0, 15.0
	twofloat: dd 16.0, 16.0, 16.0, 16.0
	truemonefloat: dd -1.0, -1.0, -1.0, -1.0
	monefloat: dd -1.0
