section .text
default rel
extern printf

global main
main:
	sub rsp, 8
	mov rax, 0
	lea rdi, [input]
	call printf
	add rsp, 8
	ret

section .rdata
	input: db "Hello world!", 0
