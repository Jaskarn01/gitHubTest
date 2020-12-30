	.file	"main.c"
	.text
	.globl	_fact
	.def	_fact;	.scl	2;	.type	32;	.endef
_fact:
LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	cmpl	$0, 8(%ebp)
	js	L2
	cmpl	$0, 8(%ebp)
	jne	L3
L2:
	movl	$0, %eax
	movl	$0, %edx
	jmp	L4
L3:
	movl	$1, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	L5
L6:
	movl	8(%ebp), %eax
	cltd
	movl	-12(%ebp), %ecx
	movl	%ecx, %ebx
	imull	%eax, %ebx
	movl	-16(%ebp), %ecx
	imull	%edx, %ecx
	addl	%ebx, %ecx
	mull	-16(%ebp)
	addl	%edx, %ecx
	movl	%ecx, %edx
	movl	%eax, -16(%ebp)
	movl	%edx, -12(%ebp)
	movl	%eax, -16(%ebp)
	movl	%edx, -12(%ebp)
	subl	$1, 8(%ebp)
L5:
	cmpl	$1, 8(%ebp)
	jne	L6
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
L4:
	addl	$20, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE13:
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC0:
	.ascii "%d\0"
LC1:
	.ascii "%llu\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	leal	20(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC0, (%esp)
	call	_scanf
	movl	20(%esp), %eax
	movl	%eax, (%esp)
	call	_fact
	movl	%eax, 24(%esp)
	movl	%edx, 28(%esp)
	movl	24(%esp), %eax
	movl	28(%esp), %edx
	movl	%eax, 4(%esp)
	movl	%edx, 8(%esp)
	movl	$LC1, (%esp)
	call	_printf
	movl	$0, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.ident	"GCC: (MinGW.org GCC Build-2) 9.2.0"
	.def	_scanf;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef
