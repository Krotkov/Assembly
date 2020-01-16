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
	xor rbx, rbx
	loop_row:
		movaps xmm0, [rdi + rax*8]
		add rax, 2
		movaps xmm1, [rdi + rax*8]
		add rax, 2
		movaps xmm2, [rdi + rax*8]
		add rax, 2
		movaps xmm3, [rdi + rax*8]
		add rax, 2
		call fdct16
		movaps [rsi + rbx*8], xmm0
		add rbx, 2
		movaps [rsi + rbx*8], xmm1
		add rbx, 2
		movaps [rsi + rbx*8], xmm2
		add rbx, 2
		movaps [rsi + rbx*8], xmm3
		add rbx, 2
		cmp rax, 128
		jne loop_row

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

	call fdct8

	;mov first ans part to xmm2, xmm3
	movaps xmm2, xmm0
	movaps xmm3, xmm1

	movaps xmm0, xmm4
	movaps xmm1, xmm5

	call fdct8

	;merge answers 16
	
	;xmm4 (xmm0) ans
	xorps xmm9, xmm9
	movaps xmm4, xmm0
	unpcklps xmm4, xmm9

	movaps xmm9, xmm2
	movaps xmm10, xmm2
	shufps xmm10, xmm10, 00001001b
	addps xmm9, xmm10
	xorps xmm10, xmm10
	unpcklps xmm10, xmm9
	xorps xmm4, xmm10

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
	xorps xmm10, xmm10
	unpckhps xmm10, xmm8
	xorps xmm5, xmm10

	;xmm6 (xmm2) ans
	xorps xmm9, xmm9
	movaps xmm6, xmm1
	unpcklps xmm6, xmm9

	movaps xmm9, xmm3
	movaps xmm10, xmm3
	shufps xmm10, xmm10, 00001001b
	addps xmm9, xmm10
	xorps xmm10, xmm10
	unpcklps xmm10, xmm9
	xorps xmm6, xmm10	

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
	ret

;fdct for xmm0..xmm1 numbers (can't use xmm2, xmm3, xmm4, xmm5)
fdct8:
	shufps xmm1, xmm1, 00011011b
	movaps xmm6, xmm0
	movaps xmm7, xmm0

	addps xmm6, xmm1
	subps xmm7, xmm1
	divps xmm7, [matrix8]

	movaps xmm0, xmm7

	call fdct4

	movaps xmm1, xmm0
	movaps xmm0, xmm6

	call fdct4

	;merge answers 8
	
	;xmm6 (xmm0) ans
	xorps xmm9, xmm9
	movaps xmm6, xmm0
	unpcklps xmm6, xmm9

	movaps xmm9, xmm1
	movaps xmm10, xmm1
	shufps xmm10, xmm10, 00001001b
	addps xmm9, xmm10
	xorps xmm10, xmm10
	unpcklps xmm10, xmm9
	xorps xmm6, xmm10	

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

	ret

;fdct for xmm0 number (can't use xmm1, xmm2, xmm3, xmm4, xmm5, xmm6)
fdct4:
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
	ret

align 16 section .rdata
    matrix16: dd 1.99037, 1.91388, 1.76384, 1.54602, 1.26879, 0.942793, 0.580569, 0.196034 
    matrix8: dd 1.96157, 1.66294, 1.11114, 0.390181 
    matrix4: dd 1.0, 1.0, 1.84776, 0.765367  
    matrix2: dd 1.0, 1.41421, 1.0, 1.41421 
    mulmatrix: dd 1.0, 1.0, -1.0, -1.0
    mulmatrix2: dd 1.0, -1.0, 1.0, -1.0



