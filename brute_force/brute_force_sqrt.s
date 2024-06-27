	.file	"brute_force_sqrt.c"
	.text
	.globl	brute_force_sqrt
	.type	brute_force_sqrt, @function
brute_force_sqrt:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jns	.L2
	movl	$-1, %eax
	jmp	.L3
.L2:
	movl	$0, -4(%rbp)
	jmp	.L4
.L5:
	addl	$1, -4(%rbp)
.L4:
	movl	-4(%rbp), %eax
	imull	%eax, %eax
	cmpl	%eax, -20(%rbp)
	jge	.L5
	movl	-4(%rbp), %eax
	subl	$1, %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	brute_force_sqrt, .-brute_force_sqrt
	.section	.rodata
	.align 8
.LC0:
	.string	"Kvadratni koren broja %d je %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$16, -48(%rbp)
	movl	$15, -44(%rbp)
	movl	$0, -40(%rbp)
	movl	$-32, -36(%rbp)
	movl	$1073741824, -32(%rbp)
	movl	$99, -28(%rbp)
	movl	$225, -24(%rbp)
	movl	$2, -20(%rbp)
	movl	$70707, -16(%rbp)
	movl	$9, -56(%rbp)
	movl	$0, -60(%rbp)
	jmp	.L7
.L8:
	movl	-60(%rbp), %eax
	cltq
	movl	-48(%rbp,%rax,4), %eax
	movl	%eax, %edi
	call	brute_force_sqrt
	movl	%eax, -52(%rbp)
	movl	-60(%rbp), %eax
	cltq
	movl	-48(%rbp,%rax,4), %eax
	movl	-52(%rbp), %edx
	movl	%eax, %esi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -60(%rbp)
.L7:
	movl	-60(%rbp), %eax
	cmpl	-56(%rbp), %eax
	jl	.L8
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
