## Application Binary Interface (ABI)

:::info
Specification: [A RISC-V ELF psABI Document](https://github.com/riscv-non-isa/riscv-elf-psabi-doc)
:::

### What is ABI?

ABI 全稱 Application Binary Interface，常常被拿來和 ABI 對比的是 API (Application Programming Interface)。就定義上來說，ABI 基本上最重要的部分就是規範了 Calling Convention，也就是函數呼叫的過程中，一系列需要遵守的規定，包含暫存器的使用、參數如何傳遞，還有 Caller-Callee Save 等等的議題。不過，確實你看完這些之後可以知道 ABI 是什麼東西還有 ABI 規範了哪些東西，但是**你知道為什麼需要 ABI 的存在嗎？**

### RISC-V Calling Convention

TBD

#### Register Convention

TBD

#### Procedure Calling Convention

TBD

#### Case Study - Calculation of Fibonacci Number

在講述 Calling Convention 的時候我們經常會提到這個經典的範例「Fibonacci Sequence」。

```asm linenums="1"
	.file	"fib.c"
	.option nopic
	.attribute arch, "rv64i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	fib
	.type	fib, @function
	# Ps: sext.w rd, rs -> addiw rd, rs, 0
fib:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	sd	s1,24(sp)
	addi	s0,sp,48
	mv	a5,a0
	sw	a5,-36(s0)
	lw	a5,-36(s0)
	sext.w	a4,a5
	li	a5,1
	bgtu	a4,a5,.L2
	lw	a5,-36(s0)
	j	.L3
.L2:
	lw	a5,-36(s0)
	addiw	a5,a5,-1
	sext.w	a5,a5
	mv	a0,a5
	call	fib
	mv	a5,a0
	sext.w	s1,a5
	lw	a5,-36(s0)
	addiw	a5,a5,-2
	sext.w	a5,a5
	mv	a0,a5
	call	fib
	mv	a5,a0
	sext.w	a5,a5
	addw	a5,s1,a5
	sext.w	a5,a5
.L3:
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	ld	s1,24(sp)
	addi	sp,sp,48
	jr	ra
```

## CPU and I/O Devices

TBD，通常有 Port-Mapped I/O 和 Memory-Mapped I/O，參考 NJU PA 和計算機體系結構基礎

## Bare-metal Runtime Environment

### Hardware-Dependent Core Library

TBD

### Hareware-Independent Library

#### I/O Library

TBD

#### Integer Multiplication and Division Emulation

TBD

#### Floating Point Emulation

TBD

#### Why Floating instead of Fixed?

TBD

#### Rouding Error

TBD, Guard, Round and Sticky Bit, units at the last bit (ulp)

#### IEEE 754 - IEEE Standard for Floating-Point Arithmetic

!!! info
  Full page: [754-2019 - IEEE Standard for Floating-Point Arithmetic](https://ieeexplore.ieee.org/document/8766229)

TBD

## How to Compile and Run

TBD

## Start to Do The Assignment

TBD
