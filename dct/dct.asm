section .text

global fdct

fdct:
	sub rsp, 8

	push rbx
	push rbp
	push rsi
	push rdi
	push r12
	push r13
	push r14
	push r15

	sub rsp, 16*10
	movaps [rsp + 16*0], xmm6
	movaps [rsp + 16*1], xmm7
	movaps [rsp + 16*2], xmm8
	movaps [rsp + 16*3], xmm9
	movaps [rsp + 16*4], xmm10
	movaps [rsp + 16*5], xmm11
	movaps [rsp + 16*6], xmm12
	movaps [rsp + 16*7], xmm13
	movaps [rsp + 16*8], xmm14
	movaps [rsp + 16*9], xmm15
	;---------------------------------------------------------------------------------------------------------------------------------

	;input registers
	mov rdi, rdi
	mov rsi, rsi



	;идем по строкам
	xor rax, rax
	loop_row:
		movaps xmm0, [rdi + rax + 4*4*0]
		movaps xmm1, [rdi + rax + 4*4*1]
		movaps xmm2, [rdi + rax + 4*4*2]
		movaps xmm3, [rdi + rax + 4*4*3]
		call fdct16
		movaps [rsi + rax + 4*4*0], xmm0
		movaps [rsi + rax + 4*4*1], xmm1
		movaps [rsi + rax + 4*4*2], xmm2
		movaps [rsi + rax + 4*4*3], xmm3
		add rax, 16*4
		cmp rax, 256*4
		jne loop_row

	xor rax, rax
	xor rdi, rdi
	loop_column:
		movaps xmm10,   [rsi + rax + 16*4*0]
		movaps xmm11,   [rsi + rax + 16*4*1]
		movaps xmm12,   [rsi + rax + 16*4*2]
		movaps xmm13,   [rsi + rax + 16*4*3]
		movaps xmm14,   [rsi + rax + 16*4*4]
		movaps xmm15,   [rsi + rax + 16*4*5]
		mov   r10,  [rsi + rax + 16*4*6]
		mov   r11,  [rsi + rax + 16*4*7]
		mov   r12,  [rsi + rax + 16*4*8]
		mov   r13,  [rsi + rax + 16*4*9]
		mov   r14,  [rsi + rax + 16*4*10]
		mov   r15,  [rsi + rax + 16*4*11]
		mov   rdx,  [rsi + rax + 16*4*12]
		mov   rbp,  [rsi + rax + 16*4*13]
		mov   rbx,  [rsi + rax + 16*4*14]
		mov   rcx,  [rsi + rax + 16*4*15]

		insertps	xmm0, xmm10, 00000000b
		insertps	xmm0, xmm11, 00010000b
		insertps	xmm0, xmm12, 00100000b
		insertps	xmm0, xmm13, 00110000b

		insertps    xmm1, xmm14, 00000000b
		insertps    xmm1, xmm15, 00010000b
		pinsrd		xmm1, r10d, 00000010b
		pinsrd		xmm1, r11d, 00000011b

		pinsrd		xmm2, r12d, 00000000b
		pinsrd		xmm2, r13d, 00000001b
		pinsrd		xmm2, r14d, 00000010b
		pinsrd		xmm2, r15d, 00000011b		

		pinsrd		xmm3, edx, 00000000b
		pinsrd		xmm3, ebp, 00000001b
		pinsrd		xmm3, ebx, 00000010b
		pinsrd		xmm3, ecx, 00000011b

		call fdct16

		insertps xmm10, xmm0, 00000000b
		insertps xmm11, xmm0, 01000000b
		insertps xmm12, xmm0, 10000000b
		insertps xmm13, xmm0, 11000000b

		insertps xmm0, xmm10, 01000000b
		insertps xmm0, xmm11, 01010000b
		insertps xmm0, xmm12, 01100000b
		insertps xmm0, xmm13, 01110000b

		insertps xmm14, xmm1, 00000000b
		insertps xmm15, xmm1, 01000000b

		insertps xmm1, xmm14, 01000000b
		insertps xmm1, xmm15, 01010000b


		shr r10, 32
		mov r8, r10
		extractps r10d, xmm1, 00000010b
		pinsrd xmm1, r8d, 00000010b

		shr r11, 32
		mov r8, r11
		extractps r11d, xmm1, 00000011b
		pinsrd xmm1, r8d, 00000011b

		shr r12, 32
		mov r8, r12
		extractps r12d, xmm2, 00000000b
		pinsrd xmm2, r8d, 00000000b

		shr r13, 32
		mov r8, r13
		extractps r13d, xmm2, 00000001b
		pinsrd xmm2, r8d, 00000001b

		shr r14, 32
		mov r8, r14
		extractps r14d, xmm2, 00000010b
		pinsrd xmm2, r8d, 00000010b

		shr r15, 32
		mov r8, r15
		extractps r15d, xmm2, 00000011b
		pinsrd xmm2, r8d, 00000011b


		shr rdx, 32
		mov r8, rdx
		extractps edx, xmm3, 00000000b
		pinsrd xmm3, r8d, 00000000b

		shr rbp, 32
		mov r8, rbp
		extractps ebp, xmm3, 00000001b
		pinsrd xmm3, r8d, 00000001b

		shr rbx, 32
		mov r8, rbx
		extractps ebx, xmm3, 00000010b
		pinsrd xmm3, r8d, 00000010b

		shr rcx, 32
		mov r8, rcx
		extractps ecx, xmm3, 00000011b
		pinsrd xmm3, r8d, 00000011b

		call fdct16

		insertps xmm10, xmm0, 00010000b
		insertps xmm11, xmm0, 01010000b
		insertps xmm12, xmm0, 10010000b
		insertps xmm13, xmm0, 11010000b

		insertps xmm0, xmm10, 10000000b
		insertps xmm0, xmm11, 10010000b
		insertps xmm0, xmm12, 10100000b
		insertps xmm0, xmm13, 10110000b

		insertps xmm14, xmm1, 00010000b
		insertps xmm15, xmm1, 01010000b

		insertps xmm1, xmm14, 10000000b
		insertps xmm1, xmm15, 10010000b

		xor r8, r8
		extractps r8d, xmm1, 00000010b
		shl r8, 32
		xor r10, r8

		xor r8, r8
		extractps r8d, xmm1, 00000011b
		shl r8, 32
		xor r11, r8

		xor r8, r8
		extractps r8d, xmm2, 00000000b
		shl r8, 32
		xor r12, r8

		xor r8, r8
		extractps r8d, xmm2, 00000001b
		shl r8, 32
		xor r13, r8

		xor r8, r8
		extractps r8d, xmm2, 00000010b
		shl r8, 32
		xor r14, r8

		xor r8, r8
		extractps r8d, xmm2, 00000011b
		shl r8, 32
		xor r15, r8

		xor r8, r8
		extractps r8d, xmm3, 00000000b
		shl r8, 32
		xor rdx, r8

		xor r8, r8
		extractps r8d, xmm3, 00000001b
		shl r8, 32
		xor rbp, r8

		xor r8, r8
		extractps r8d, xmm3, 00000010b
		shl r8, 32
		xor rbx, r8

		xor r8, r8
		extractps r8d, xmm3, 00000011b
		shl r8, 32
		xor rcx, r8

		mov [rsi + rax + 16 * 4 * 6], r10
		mov [rsi + rax + 16 * 4 * 7], r11
		mov [rsi + rax + 16 * 4 * 8], r12
		mov [rsi + rax + 16 * 4 * 9], r13
		mov [rsi + rax + 16 * 4 * 10], r14
		mov [rsi + rax + 16 * 4 * 11], r15
		mov [rsi + rax + 16 * 4 * 12], rdx
		mov [rsi + rax + 16 * 4 * 13], rbp
		mov [rsi + rax + 16 * 4 * 14], rbx
		mov [rsi + rax + 16 * 4 * 15], rcx

		add rax, 8

		mov r10, [rsi + rax + 16 * 4 * 6]
		mov r11, [rsi + rax + 16 * 4 * 7]
		mov r12, [rsi + rax + 16 * 4 * 8]
		mov r13, [rsi + rax + 16 * 4 * 9]
		mov r14, [rsi + rax + 16 * 4 * 10]
		mov r15, [rsi + rax + 16 * 4 * 11]
		mov rdx, [rsi + rax + 16 * 4 * 12]
		mov rbp, [rsi + rax + 16 * 4 * 13]
		mov rbx, [rsi + rax + 16 * 4 * 14]
		mov rcx, [rsi + rax + 16 * 4 * 15]

		pinsrd		xmm1, r10d, 00000010b
		pinsrd		xmm1, r11d, 00000011b

		pinsrd		xmm2, r12d, 00000000b
		pinsrd		xmm2, r13d, 00000001b
		pinsrd		xmm2, r14d, 00000010b
		pinsrd		xmm2, r15d, 00000011b		

		pinsrd		xmm3, edx, 00000000b
		pinsrd		xmm3, ebp, 00000001b
		pinsrd		xmm3, ebx, 00000010b
		pinsrd		xmm3, ecx, 00000011b

		call fdct16

		insertps xmm10, xmm0, 00100000b
		insertps xmm11, xmm0, 01100000b
		insertps xmm12, xmm0, 10100000b
		insertps xmm13, xmm0, 11100000b

		insertps xmm0, xmm10, 11000000b
		insertps xmm0, xmm11, 11010000b
		insertps xmm0, xmm12, 11100000b
		insertps xmm0, xmm13, 11110000b

		insertps xmm14, xmm1, 00100000b
		insertps xmm15, xmm1, 01100000b

		insertps xmm1, xmm14, 11000000b
		insertps xmm1, xmm15, 11010000b


		shr r10, 32
		mov r8, r10
		extractps r10d, xmm1, 00000010b
		pinsrd xmm1, r8d, 00000010b

		shr r11, 32
		mov r8, r11
		extractps r11d, xmm1, 00000011b
		pinsrd xmm1, r8d, 00000011b

		shr r12, 32
		mov r8, r12
		extractps r12d, xmm2, 00000000b
		pinsrd xmm2, r8d, 00000000b

		shr r13, 32
		mov r8, r13
		extractps r13d, xmm2, 00000001b
		pinsrd xmm2, r8d, 00000001b

		shr r14, 32
		mov r8, r14
		extractps r14d, xmm2, 00000010b
		pinsrd xmm2, r8d, 00000010b

		shr r15, 32
		mov r8, r15
		extractps r15d, xmm2, 00000011b
		pinsrd xmm2, r8d, 00000011b


		shr rdx, 32
		mov r8, rdx
		extractps edx, xmm3, 00000000b
		pinsrd xmm3, r8d, 00000000b

		shr rbp, 32
		mov r8, rbp
		extractps ebp, xmm3, 00000001b
		pinsrd xmm3, r8d, 00000001b

		shr rbx, 32
		mov r8, rbx
		extractps ebx, xmm3, 00000010b
		pinsrd xmm3, r8d, 00000010b

		shr rcx, 32
		mov r8, rcx
		extractps ecx, xmm3, 00000011b
		pinsrd xmm3, r8d, 00000011b

		call fdct16

		insertps xmm10, xmm0, 00110000b
		insertps xmm11, xmm0, 01110000b
		insertps xmm12, xmm0, 10110000b
		insertps xmm13, xmm0, 11110000b

		insertps xmm14, xmm1, 00110000b
		insertps xmm15, xmm1, 01110000b

		xor r8, r8
		extractps r8d, xmm1, 00000010b
		shl r8, 32
		xor r10, r8

		xor r8, r8
		extractps r8d, xmm1, 00000011b
		shl r8, 32
		xor r11, r8

		xor r8, r8
		extractps r8d, xmm2, 00000000b
		shl r8, 32
		xor r12, r8

		xor r8, r8
		extractps r8d, xmm2, 00000001b
		shl r8, 32
		xor r13, r8

		xor r8, r8
		extractps r8d, xmm2, 00000010b
		shl r8, 32
		xor r14, r8

		xor r8, r8
		extractps r8d, xmm2, 00000011b
		shl r8, 32
		xor r15, r8

		xor r8, r8
		extractps r8d, xmm3, 00000000b
		shl r8, 32
		xor rdx, r8

		xor r8, r8
		extractps r8d, xmm3, 00000001b
		shl r8, 32
		xor rbp, r8

		xor r8, r8
		extractps r8d, xmm3, 00000010b
		shl r8, 32
		xor rbx, r8

		xor r8, r8
		extractps r8d, xmm3, 00000011b
		shl r8, 32
		xor rcx, r8

		mov [rsi + rax + 16 * 4 * 6], r10
		mov [rsi + rax + 16 * 4 * 7], r11
		mov [rsi + rax + 16 * 4 * 8], r12
		mov [rsi + rax + 16 * 4 * 9], r13
		mov [rsi + rax + 16 * 4 * 10], r14
		mov [rsi + rax + 16 * 4 * 11], r15
		mov [rsi + rax + 16 * 4 * 12], rdx
		mov [rsi + rax + 16 * 4 * 13], rbp
		mov [rsi + rax + 16 * 4 * 14], rbx
		mov [rsi + rax + 16 * 4 * 15], rcx

		sub rax, 8

		movaps [rsi + rax + 16 * 4 * 0], xmm10
		movaps [rsi + rax + 16 * 4 * 1], xmm11
		movaps [rsi + rax + 16 * 4 * 2], xmm12
		movaps [rsi + rax + 16 * 4 * 3], xmm13
		movaps [rsi + rax + 16 * 4 * 4], xmm14
		movaps [rsi + rax + 16 * 4 * 5], xmm15

		add rax, 16

		cmp rax, 16*4
		jne loop_column


	;---------------------------------------------------------------------------------------------------------------------------------
	movaps xmm6, [rsp + 16*0]
	movaps xmm7, [rsp + 16*1]
	movaps xmm8, [rsp + 16*2]
	movaps xmm9, [rsp + 16*3]
	movaps xmm10, [rsp + 16*4]
	movaps xmm11, [rsp + 16*5]
	movaps xmm12, [rsp + 16*6]
	movaps xmm13, [rsp + 16*7]
	movaps xmm14, [rsp + 16*8]
	movaps xmm15, [rsp + 16*9]
	add rsp, 16*10

	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rsi
	pop rbp
	pop rbx

	add rsp, 8

	ret


;fdct for xmm0..xmm3 numbers (ans in xmm0..xmm3)
fdct16:
	shufps xmm2, xmm2, 00011011b
	shufps xmm3, xmm3, 00011011b
	movaps xmm4, xmm0
	movaps xmm5, xmm1
	movaps xmm6, xmm0
	movaps xmm7, xmm1
	
	addps xmm4, xmm3
	addps xmm5, xmm2
	subps xmm6, xmm3
	subps xmm7, xmm2

	divps xmm6, [matrix16]
	divps xmm7, [matrix16 + 16]

	movaps xmm0, xmm6
	movaps xmm1, xmm7

	jmp fdct8_1
	fdct8_1_end:

	;mov first ans part to xmm2, xmm3
	movaps xmm2, xmm0
	movaps xmm3, xmm1

	movaps xmm0, xmm4
	movaps xmm1, xmm5

	jmp fdct8_2
	fdct8_2_end:

	;merge answers 16
	
	;xmm4 (xmm0) ans
	xorps xmm9, xmm9
	movaps xmm4, xmm0
	unpcklps xmm4, xmm9

	movaps xmm9, xmm2
	movaps xmm8, xmm2
	shufps xmm8, xmm8, 00001001b
	addps xmm9, xmm8
	xorps xmm8, xmm8
	unpcklps xmm8, xmm9
	xorps xmm4, xmm8

	;xmm5 (xmm1) ans
	xorps xmm8, xmm8
	movaps xmm5, xmm0
	unpckhps xmm5, xmm8

	movaps xmm8, xmm2
	movaps xmm9, xmm3
	shufps xmm9, xmm8, 11100100b
	movaps xmm8, xmm9
	shufps xmm8, xmm8, 00110000b
	addps xmm8, xmm9
	xorps xmm6, xmm6
	unpckhps xmm6, xmm8
	xorps xmm5, xmm6

	;xmm6 (xmm2) ans
	xorps xmm9, xmm9
	movaps xmm6, xmm1
	unpcklps xmm6, xmm9

	movaps xmm9, xmm3
	movaps xmm7, xmm3
	shufps xmm7, xmm7, 00001001b
	addps xmm9, xmm7
	xorps xmm7, xmm7
	unpcklps xmm7, xmm9
	xorps xmm6, xmm7	

	;xmm7 (xmm3) ans
	xorps xmm8, xmm8
	movaps xmm7, xmm1
	unpckhps xmm7, xmm8

	xorps xmm8, xmm8
	unpckhps xmm8, xmm3
	movaps xmm9, xmm8
	shufps xmm9, xmm9, 00101100b
	addps xmm8, xmm9
	xorps xmm7, xmm8

	;final ans
	movaps xmm0, xmm4
	movaps xmm1, xmm5
	movaps xmm2, xmm6
	movaps xmm3, xmm7

	divps xmm0, [divmatrix]
	divps xmm1, [divmatrix]
	divps xmm2, [divmatrix]
	divps xmm3, [divmatrix]

	ret

;fdct for xmm0..xmm1 numbers (can't use xmm2, xmm3, xmm4, xmm5)
fdct8_1:
	shufps xmm1, xmm1, 00011011b
	movaps xmm6, xmm0
	movaps xmm7, xmm0

	addps xmm6, xmm1
	subps xmm7, xmm1
	divps xmm7, [matrix8]

	movaps xmm0, xmm7

	jmp fdct4_1
	fdct4_1_end:

	movaps xmm1, xmm0
	movaps xmm0, xmm6

	jmp fdct4_2
	fdct4_2_end:

	;merge answers 8
	
	;xmm6 (xmm0) ans
	xorps xmm9, xmm9
	movaps xmm6, xmm0
	unpcklps xmm6, xmm9

	movaps xmm9, xmm1
	movaps xmm7, xmm1
	shufps xmm7, xmm7, 00001001b
	addps xmm9, xmm7
	xorps xmm7, xmm7
	unpcklps xmm7, xmm9
	xorps xmm6, xmm7	

	;xmm7 (xmm1) ans
	xorps xmm8, xmm8
	movaps xmm7, xmm0
	unpckhps xmm7, xmm8

	xorps xmm8, xmm8
	unpckhps xmm8, xmm1
	movaps xmm9, xmm8
	shufps xmm9, xmm9, 00101100b
	addps xmm8, xmm9
	xorps xmm7, xmm8

	;final ans
	movaps xmm0, xmm6
	movaps xmm1, xmm7

	jmp fdct8_1_end
fdct8_2:
	shufps xmm1, xmm1, 00011011b
	movaps xmm6, xmm0
	movaps xmm7, xmm0

	addps xmm6, xmm1
	subps xmm7, xmm1
	divps xmm7, [matrix8]

	movaps xmm0, xmm7

	jmp fdct4_3
	fdct4_3_end:

	movaps xmm1, xmm0
	movaps xmm0, xmm6

	jmp fdct4_4
	fdct4_4_end:

	;merge answers 8
	
	;xmm6 (xmm0) ans
	xorps xmm9, xmm9
	movaps xmm6, xmm0
	unpcklps xmm6, xmm9

	movaps xmm9, xmm1
	movaps xmm7, xmm1
	shufps xmm7, xmm7, 00001001b
	addps xmm9, xmm7
	xorps xmm7, xmm7
	unpcklps xmm7, xmm9
	xorps xmm6, xmm7	

	;xmm7 (xmm1) ans
	xorps xmm8, xmm8
	movaps xmm7, xmm0
	unpckhps xmm7, xmm8

	xorps xmm8, xmm8
	unpckhps xmm8, xmm1
	movaps xmm9, xmm8
	shufps xmm9, xmm9, 00101100b
	addps xmm8, xmm9
	xorps xmm7, xmm8

	;final ans
	movaps xmm0, xmm6
	movaps xmm1, xmm7

	jmp fdct8_2_end


;fdct for xmm0 number (can't use xmm1, xmm2, xmm3, xmm4, xmm5, xmm6)
fdct4_1:
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 01000100b
	shufps xmm7, xmm7, 10111011b
	mulps xmm7, [mulmatrix]
	addps xmm0, xmm7
	divps xmm0, [matrix4]

	;fdct2-------------
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 10100000b
	shufps xmm7, xmm7, 11110101b
	mulps xmm7, [mulmatrix2]
	addps xmm0, xmm7
	divps xmm0, [matrix2]
	;------------------

	xorps xmm7, xmm7
	unpckhps xmm7, xmm0
	shufps xmm7, xmm7, 00110000b
	addps xmm0, xmm7
	shufps xmm0, xmm0, 11011000b
	jmp fdct4_1_end
fdct4_2:
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 01000100b
	shufps xmm7, xmm7, 10111011b
	mulps xmm7, [mulmatrix]
	addps xmm0, xmm7
	divps xmm0, [matrix4]

	;fdct2-------------
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 10100000b
	shufps xmm7, xmm7, 11110101b
	mulps xmm7, [mulmatrix2]
	addps xmm0, xmm7
	divps xmm0, [matrix2]
	;------------------

	xorps xmm7, xmm7
	unpckhps xmm7, xmm0
	shufps xmm7, xmm7, 00110000b
	addps xmm0, xmm7
	shufps xmm0, xmm0, 11011000b
	jmp fdct4_2_end
fdct4_3:
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 01000100b
	shufps xmm7, xmm7, 10111011b
	mulps xmm7, [mulmatrix]
	addps xmm0, xmm7
	divps xmm0, [matrix4]

	;fdct2-------------
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 10100000b
	shufps xmm7, xmm7, 11110101b
	mulps xmm7, [mulmatrix2]
	addps xmm0, xmm7
	divps xmm0, [matrix2]
	;------------------

	xorps xmm7, xmm7
	unpckhps xmm7, xmm0
	shufps xmm7, xmm7, 00110000b
	addps xmm0, xmm7
	shufps xmm0, xmm0, 11011000b
	jmp fdct4_3_end
fdct4_4:
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 01000100b
	shufps xmm7, xmm7, 10111011b
	mulps xmm7, [mulmatrix]
	addps xmm0, xmm7
	divps xmm0, [matrix4]

	;fdct2-------------
	movaps xmm7, xmm0
	shufps xmm0, xmm0, 10100000b
	shufps xmm7, xmm7, 11110101b
	mulps xmm7, [mulmatrix2]
	addps xmm0, xmm7
	divps xmm0, [matrix2]
	;------------------

	xorps xmm7, xmm7
	unpckhps xmm7, xmm0
	shufps xmm7, xmm7, 00110000b
	addps xmm0, xmm7
	shufps xmm0, xmm0, 11011000b
	jmp fdct4_4_end

align 16 section .rdata
    matrix16: dd 1.99037, 1.91388, 1.76384, 1.54602, 1.26879, 0.942793, 0.580569, 0.196034 
    matrix8: dd 1.96157, 1.66294, 1.11114, 0.390181 
    matrix4: dd 1.0, 1.0, 1.84776, 0.765367  
    matrix2: dd 1.0, 1.41421, 1.0, 1.41421 
    mulmatrix: dd 1.0, 1.0, -1.0, -1.0
    mulmatrix2: dd 1.0, -1.0, 1.0, -1.0
    divmatrix: dd 16.0, 16.0, 16.0, 16.0

