
	.text

	.globl	ap_2
	.globl	ap_3
	.globl	ap_4
	.globl	ap_5
	.globl	ap_6
	.globl	ap_7
	.globl	ap_8
	.globl	ap_9
	.globl	ap_10
	.globl	ap_11
	.globl	ap_12
	.globl	ap_13
	.globl	ap_14
	.globl	ap_15
	.globl	ap_16
	.globl	ap_17
	.globl	ap_18
	.globl	ap_19
	.globl	ap_20
	.globl	ap_21
	.globl	ap_22
	.globl	ap_23
	.globl	ap_24
	.globl	ap_25
	.globl	ap_26
	.globl	ap_27
	.globl	ap_28
	.globl	ap_29
	.globl	ap_30
	.globl	ap_31
	.globl	ap_32

	.globl	add_empty_node_2
	.globl	add_empty_node_3
	.globl	add_empty_node_4
	.globl	add_empty_node_5
	.globl	add_empty_node_6
	.globl	add_empty_node_7
	.globl	add_empty_node_8
	.globl	add_empty_node_9
	.globl	add_empty_node_10
	.globl	add_empty_node_11
	.globl	add_empty_node_12
	.globl	add_empty_node_13
	.globl	add_empty_node_14
	.globl	add_empty_node_15
	.globl	add_empty_node_16
	.globl	add_empty_node_17
	.globl	add_empty_node_18
	.globl	add_empty_node_19
	.globl	add_empty_node_20
	.globl	add_empty_node_21
	.globl	add_empty_node_22
	.globl	add_empty_node_23
	.globl	add_empty_node_24
	.globl	add_empty_node_25
	.globl	add_empty_node_26
	.globl	add_empty_node_27
	.globl	add_empty_node_28
	.globl	add_empty_node_29
	.globl	add_empty_node_30
	.globl	add_empty_node_31
	.globl	add_empty_node_32

	.globl	yet_args_needed_5
	.globl	yet_args_needed_6
	.globl	yet_args_needed_7
	.globl	yet_args_needed_8
	.globl	yet_args_needed_9
	.globl	yet_args_needed_10
	.globl	yet_args_needed_11
	.globl	yet_args_needed_12
	.globl	yet_args_needed_13
	.globl	yet_args_needed_14
	.globl	yet_args_needed_15
	.globl	yet_args_needed_16
	.globl	yet_args_needed_17
	.globl	yet_args_needed_18
	.globl	yet_args_needed_19
	.globl	yet_args_needed_20
	.globl	yet_args_needed_21
	.globl	yet_args_needed_22
	.globl	yet_args_needed_23
	.globl	yet_args_needed_24
	.globl	yet_args_needed_25
	.globl	yet_args_needed_26
	.globl	yet_args_needed_27
	.globl	yet_args_needed_28
	.globl	yet_args_needed_29
	.globl	yet_args_needed_30
	.globl	yet_args_needed_31

ap_32:
	movl	(a1),a2
	movl	$32*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_31:
	movl	(a1),a2
	movl	$31*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_30:
	movl	(a1),a2
	movl	$30*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_29:
	movl	(a1),a2
	movl	$29*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_28:
	movl	(a1),a2
	movl	$28*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_27:
	movl	(a1),a2
	movl	$27*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_26:
	movl	(a1),a2
	movl	$26*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_25:
	movl	(a1),a2
	movl	$25*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_24:
	movl	(a1),a2
	movl	$24*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_23:
	movl	(a1),a2
	movl	$23*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_22:
	movl	(a1),a2
	movl	$22*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_21:
	movl	(a1),a2
	movl	$21*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_20:
	movl	(a1),a2
	movl	$20*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_19:
	movl	(a1),a2
	movl	$19*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_18:
	movl	(a1),a2
	movl	$18*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_17:
	movl	(a1),a2
	movl	$17*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_16:
	movl	(a1),a2
	movl	$16*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_15:
	movl	(a1),a2
	movl	$15*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_14:
	movl	(a1),a2
	movl	$14*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_13:
	movl	(a1),a2
	movl	$13*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_12:
	movl	(a1),a2
	movl	$12*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_11:
	movl	(a1),a2
	movl	$11*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_10:
	movl	(a1),a2
	movl	$10*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_9:
	movl	(a1),a2
	movl	$9*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_8:
	movl	(a1),a2
	movl	$8*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_7:
	movl	(a1),a2
	movl	$7*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_6:
	movl	(a1),a2
	movl	$6*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_5:
	movl	(a1),a2
	movl	$5*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_4:
	movl	(a1),a2
	movl	$4*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_3:
	movl	(a1),a2
	movl	$3*8,d1
	cmpw	d1w,(a2)
	je	fast_ap

	call	*2(a2)
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3

ap_2:
	movl	(a1),a2
	movl	$2*8,d1
	cmpw	d1w,(a2)
	jne	no_fast_ap2

fast_ap:
	addl	a2,d1
	movzwl	-2(a2),d0
	movl	-6(d1),a2
#ifdef PROFILE
	subl	$20,a2
#else
	subl	$12,a2
#endif
	cmpl	$1,d0
	jb	repl_args_0
	je	repl_args_1

	movl	a0,(a3)
	addl	$4,a3
	movl	8(a1),a0

	cmpl	$3,d0
	jb	repl_args_2

	movl	4(a1),a1
	je	repl_args_3

	cmpl	$5,d0
	jb	repl_args_4
	je	repl_args_5

	cmpl	$7,d0
	jb	repl_args_6

	push	d1

repl_args_7_:
	movl	-8(a0,d0,4),d1
	movl	d1,(a3)
	subl	$1,d0
	addl	$4,a3
	cmpl	$6,d0
	jne	repl_args_7_

	pop	d1

repl_args_6:
	movl	16(a0),d0
	movl	d0,(a3)
	movl	12(a0),d0
	movl	d0,4(a3)
	movl	8(a0),d0
	movl	d0,8(a3)
	movl	4(a0),d0
	movl	(a0),a0
	movl	d0,12(a3)
	addl	$16,a3
	jmp	*a2

repl_args_0:
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
	jmp	*a2

repl_args_1:
	movl	4(a1),a1
	jmp	*a2

repl_args_2:
	movl	4(a1),a1
	jmp	*a2

repl_args_3:
	movl	4(a0),d0
	movl	(a0),a0
	movl	d0,(a3)
	addl	$4,a3
	jmp	*a2

repl_args_4:
	movl	8(a0),d0
	movl	d0,(a3)
	movl	4(a0),d0
	movl	(a0),a0
	movl	d0,4(a3)
	addl	$8,a3
	jmp	*a2

repl_args_5:
	movl	12(a0),d0
	movl	d0,(a3)
	movl	8(a0),d0
	movl	d0,4(a3)
	movl	4(a0),d0
	movl	(a0),a0
	movl	d0,8(a3)
	addl	$12,a3
	jmp	*a2

no_fast_ap2:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
	jmp	*2(a2)


add_empty_node_2:
	cmpl	end_heap,a4
	jae	add_empty_node_2_gc
add_empty_node_2_gc_:
	movl	a4,(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_2_gc:
	call	collect_2
	jmp	add_empty_node_2_gc_

add_empty_node_3:
	cmpl	end_heap,a4
	jae	add_empty_node_3_gc
add_empty_node_3_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	a4,-4(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_3_gc:
	call	collect_2
	jmp	add_empty_node_3_gc_

add_empty_node_4:
	cmpl	end_heap,a4
	jae	add_empty_node_4_gc
add_empty_node_4_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	a4,-8(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_4_gc:
	call	collect_2
	jmp	add_empty_node_4_gc_

add_empty_node_5:
	cmpl	end_heap,a4
	jae	add_empty_node_5_gc
add_empty_node_5_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
	movl	a4,-12(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_5_gc:
	call	collect_2
	jmp	add_empty_node_5_gc_

add_empty_node_6:
	cmpl	end_heap,a4
	jae	add_empty_node_6_gc
add_empty_node_6_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
	movl	-16(a3),a2
	movl	a2,-12(a3)
	movl	a4,-16(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_6_gc:
	call	collect_2
	jmp	add_empty_node_6_gc_

add_empty_node_7:
	cmpl	end_heap,a4
	jae	add_empty_node_7_gc
add_empty_node_7_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
	movl	-16(a3),a2
	movl	a2,-12(a3)
	movl	-20(a3),a2
	movl	a2,-16(a3)
	movl	a4,-20(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_7_gc:
	call	collect_2
	jmp	add_empty_node_7_gc_

add_empty_node_8:
	cmpl	end_heap,a4
	jae	add_empty_node_8_gc
add_empty_node_8_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
	movl	-16(a3),a2
	movl	a2,-12(a3)
	movl	-20(a3),a2
	movl	a2,-16(a3)
	movl	-24(a3),a2
	movl	a2,-20(a3)
	movl	a4,-24(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_8_gc:
	call	collect_2
	jmp	add_empty_node_8_gc_

add_empty_node_9:
	cmpl	end_heap,a4
	jae	add_empty_node_9_gc
add_empty_node_9_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
	movl	-16(a3),a2
	movl	a2,-12(a3)
	movl	-20(a3),a2
	movl	a2,-16(a3)
	movl	-24(a3),a2
	movl	a2,-20(a3)
	movl	-28(a3),a2
	movl	a2,-24(a3)
	movl	a4,-28(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_9_gc:
	call	collect_2
	jmp	add_empty_node_9_gc_

add_empty_node_10:
	cmpl	end_heap,a4
	jae	add_empty_node_10_gc
add_empty_node_10_gc_:
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
	movl	-16(a3),a2
	movl	a2,-12(a3)
	movl	-20(a3),a2
	movl	a2,-16(a3)
	movl	-24(a3),a2
	movl	a2,-20(a3)
	movl	-28(a3),a2
	movl	a2,-24(a3)
	movl	-32(a3),a2
	movl	a2,-28(a3)
	movl	a4,-32(a3)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_10_gc:
	call	collect_2
	jmp	add_empty_node_10_gc_

add_empty_node_31:
	movl	$7,d1
	jmp	add_empty_node_11_
add_empty_node_27:
	movl	$6,d1
	jmp	add_empty_node_11_
add_empty_node_23:
	movl	$5,d1
	jmp	add_empty_node_11_
add_empty_node_19:
	movl	$4,d1
	jmp	add_empty_node_11_
add_empty_node_15:
	movl	$3,d1
	jmp	add_empty_node_11_
add_empty_node_11:
	movl	$2,d1
add_empty_node_11_:
	cmpl	end_heap,a4
	jae	add_empty_node_11_gc
add_empty_node_11_gc_:
	movl	a3,d0
	movl	-4(a3),a2
	movl	a2,(a3)
add_empty_node_11_lp:
	movl	-8(d0),a2
	movl	a2,-4(d0)
	movl	-12(d0),a2
	movl	a2,-8(d0)
	movl	-16(d0),a2
	movl	a2,-12(d0)
	movl	-20(d0),a2
	movl	a2,-16(d0)
	subl	$16,d0
	subl	$1,d1
	jne	add_empty_node_11_lp
	movl	a4,-4(d0)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_11_gc:
	call	collect_2
	jmp	add_empty_node_11_gc_

add_empty_node_32:
	movl	$7,d1
	jmp	add_empty_node_12_
add_empty_node_28:
	movl	$6,d1
	jmp	add_empty_node_12_
add_empty_node_24:
	movl	$5,d1
	jmp	add_empty_node_12_
add_empty_node_20:
	movl	$4,d1
	jmp	add_empty_node_12_
add_empty_node_16:
	movl	$3,d1
	jmp	add_empty_node_12_
add_empty_node_12:
	movl	$2,d1
add_empty_node_12_:
	cmpl	end_heap,a4
	jae	add_empty_node_12_gc
add_empty_node_12_gc_:
	movl	a3,d0
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
add_empty_node_12_lp:
	movl	-12(d0),a2
	movl	a2,-8(d0)
	movl	-16(d0),a2
	movl	a2,-12(d0)
	movl	-20(d0),a2
	movl	a2,-16(d0)
	movl	-24(d0),a2
	movl	a2,-20(d0)
	subl	$16,d0
	subl	$1,d1
	jne	add_empty_node_12_lp
	movl	a4,-8(d0)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_12_gc:
	call	collect_2
	jmp	add_empty_node_12_gc_

add_empty_node_29:
	movl	$6,d1
	jmp	add_empty_node_13_
add_empty_node_25:
	movl	$5,d1
	jmp	add_empty_node_13_
add_empty_node_21:
	movl	$4,d1
	jmp	add_empty_node_13_
add_empty_node_17:
	movl	$3,d1
	jmp	add_empty_node_13_
add_empty_node_13:
	movl	$2,d1
add_empty_node_13_:
	cmpl	end_heap,a4
	jae	add_empty_node_13_gc
add_empty_node_13_gc_:
	movl	a3,d0
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
add_empty_node_13_lp:
	movl	-16(d0),a2
	movl	a2,-12(d0)
	movl	-20(d0),a2
	movl	a2,-16(d0)
	movl	-24(d0),a2
	movl	a2,-20(d0)
	movl	-28(d0),a2
	movl	a2,-24(d0)
	subl	$16,d0
	subl	$1,d1
	jne	add_empty_node_13_lp
	movl	a4,-12(d0)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_13_gc:
	call	collect_2
	jmp	add_empty_node_13_gc_

add_empty_node_30:
	movl	$7,d1
	jmp	add_empty_node_14_
add_empty_node_26:
	movl	$6,d1
	jmp	add_empty_node_14_
add_empty_node_22:
	movl	$5,d1
	jmp	add_empty_node_14_
add_empty_node_18:
	movl	$4,d1
	jmp	add_empty_node_14_
add_empty_node_14:
	movl	$3,d1
	jmp	add_empty_node_14_
add_empty_node_14_:
	cmpl	end_heap,a4
	jae	add_empty_node_14_gc
add_empty_node_14_gc_:
	movl	a3,d0
add_empty_node_14_lp:
	movl	-4(d0),a2
	movl	a2,(d0)
	movl	-8(d0),a2
	movl	a2,-4(d0)
	movl	-12(d0),a2
	movl	a2,-8(d0)
	movl	-16(d0),a2
	movl	a2,-12(d0)
	subl	$16,d0
	subl	$1,d1
	jne	add_empty_node_14_lp
	movl	a4,(d0)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_14_gc:
	call	collect_2
	jmp	add_empty_node_14_gc_

yet_args_needed_0:
	cmpl	end_heap,a4
	jae	yet_args_needed_0_gc
yet_args_needed_0_gc_r:
	mov	a0,4(a4)
	mov	(a1),d0
	mov	a4,a0
	add	$8,d0
	mov	d0,(a4)
	add	$8,a4
	ret

yet_args_needed_0_gc:
	call	collect_2
	jmp	yet_args_needed_0_gc_r


	align	(2)
	cmpl	end_heap,a4
	jmp	build_node_2
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_1:
	cmpl	end_heap,a4
	jae	yet_args_needed_1_gc
yet_args_needed_1_gc_r:
	mov	a0,8(a4)
	mov	(a1),d0
	mov	a4,a0
	add	$8,d0
	mov	d0,(a4)
	mov	4(a1),d1
	mov	d1,4(a4)
	add	$12,a4
	ret

yet_args_needed_1_gc:
	call	collect_2
	jmp	yet_args_needed_1_gc_r

build_node_2:
	jae	build_node_2_gc
build_node_2_gc_r:
	movl	d1,(a4)
	movl	a1,4(a4)
	movl	a0,8(a4)
	movl	a4,a0
	addl	$12,a4
	ret

build_node_2_gc:
	call	collect_2
	jmp	build_node_2_gc_r


	align	(2)
	cmpl	end_heap,a4
	jmp	build_node_3
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_2:
	cmpl	end_heap,a4
	jae	gc_22
gc_r_22:
	mov	(a1),d0
	mov	a0,4(a4)
	add	$8,d0
	mov	4(a1),a2
	mov	d0,8(a4)
	lea	8(a4),a0
	mov	a2,12(a4)
	mov	8(a1),a2
	mov	a2,(a4)
	mov	a4,16(a4)
	add	$20,a4
	ret

gc_22:	call	collect_2
	jmp	gc_r_22

build_node_3:
	jae	build_node_3_gc
build_node_3_gc_r:
	movl	d1,(a4)
	lea	12(a4),a2
	movl	a1,4(a4)
	movl	a2,8(a4)
	movl	a0,12(a4)
	movl	a4,a0
	movl	-4(a3),a2
	subl	$4,a3
	movl	a2,16(a4)
	addl	$20,a4
	ret

build_node_3_gc:
	call	collect_2
	jmp	build_node_3_gc_r


	align	(2)
	cmpl	end_heap,a4
	jmp	build_node_4
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_3:
	cmpl	end_heap,a4
	jae	gc_23
gc_r_23:
	mov	(a1),d0
	mov	a0,8(a4)
	add	$8,d0
	mov	4(a1),a2
	mov	d0,12(a4)
	mov	8(a1),a1
	mov	a2,16(a4)
	mov	(a1),a2
	mov	a4,20(a4)
	mov	a2,(a4)
	mov	4(a1),a2
	lea	12(a4),a0
	mov	a2,4(a4)
	add	$24,a4
	ret

gc_23:	call	collect_2
	jmp	gc_r_23

build_node_4:
	jae	build_node_4_gc
build_node_4_gc_r:
	movl	d1,(a4)
	lea	12(a4),a2
	movl	a1,4(a4)
	movl	a2,8(a4)
	movl	a0,12(a4)
	movl	a4,a0
	movl	-4(a3),a2
	movl	a2,16(a4)
	movl	-8(a3),a2
	subl	$8,a3
	movl	a2,20(a4)
	addl	$24,a4
	ret

build_node_4_gc:
	call	collect_2
	jmp	build_node_4_gc_r


	align	(2)
	cmpl	end_heap,a4
	jmp	build_node_5
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_4:
	cmpl	end_heap,a4
	jae	gc_24
gc_r_24:
	mov	(a1),d0
	mov	a0,12(a4)
	add	$8,d0
	mov	4(a1),a2
	mov	d0,16(a4)
	mov	8(a1),a1
	mov	a2,20(a4)
	mov	(a1),a2
	mov	a4,24(a4)
	mov	a2,(a4)
	mov	4(a1),a2
	lea	16(a4),a0
	mov	a2,4(a4)
	mov	8(a1),a2
	mov	a2,8(a4)
	add	$28,a4
	ret

gc_24:	call	collect_2
	jmp	gc_r_24

build_node_5:
	jae	build_node_5_gc
build_node_5_gc_r:
	movl	d1,(a4)
	lea	12(a4),a2
	movl	a1,4(a4)
	movl	a2,8(a4)
	movl	a0,12(a4)
	movl	a4,a0
	movl	-4(a3),a2
	movl	a2,16(a4)
	movl	-8(a3),a2
	movl	a2,20(a4)
	movl	-12(a3),a2
	subl	$12,a3
	movl	a2,24(a4)
	addl	$28,a4
	ret

build_node_5_gc:
	call	collect_2
	jmp	build_node_5_gc_r


	align	(2)
	movl	$6,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_5:
	mov	(a1),d1
	movl	$8,d0
	jmp	yet_args_needed_


	align	(2)
	movl	$7,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_6:
	mov	(a1),d1
	movl	$9,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$8,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_7:
	mov	(a1),d1
	movl	$10,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$9,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_8:
	mov	(a1),d1
	movl	$11,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$10,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_9:
	mov	(a1),d1
	movl	$12,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$11,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_10:
	mov	(a1),d1
	movl	$13,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$12,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_11:
	mov	(a1),d1
	movl	$14,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$13,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_12:
	mov	(a1),d1
	movl	$15,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$14,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_13:
	mov	(a1),d1
	movl	$16,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$15,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_14:
	mov	(a1),d1
	movl	$17,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$16,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_15:
	mov	(a1),d1
	movl	$18,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$17,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_16:
	mov	(a1),d1
	movl	$19,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$18,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_17:
	mov	(a1),d1
	movl	$20,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$19,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_18:
	mov	(a1),d1
	movl	$21,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$20,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_19:
	mov	(a1),d1
	movl	$22,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$21,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_20:
	mov	(a1),d1
	movl	$23,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$22,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_21:
	mov	(a1),d1
	movl	$24,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$23,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_22:
	mov	(a1),d1
	movl	$25,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$24,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_23:
	mov	(a1),d1
	movl	$26,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$25,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_24:
	mov	(a1),d1
	movl	$27,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$26,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_25:
	mov	(a1),d1
	movl	$28,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$27,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_26:
	mov	(a1),d1
	movl	$29,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$28,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_27:
	mov	(a1),d1
	movl	$30,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$29,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_28:
	mov	(a1),d1
	movl	$31,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$30,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_29:
	mov	(a1),d1
	movl	$32,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$31,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_30:
	mov	(a1),d1
	movl	$33,d0
	jmp	yet_args_needed_

	align	(2)
	movl	$32,d0
	jmp	build_node_
	nop
	nop
	align	(2)	
#ifdef PROFILE
	nop
	nop
	nop
	nop	
	nop
	nop
	nop
	nop	
#endif
yet_args_needed_31:
	mov	(a1),d1
	movl	$34,d0
	jmp	yet_args_needed_

yet_args_needed:
/ for more than 4 arguments
	mov	(a1),d1
	movzwl	-2(d1),d0
	add	$3,d0
yet_args_needed_:
	lea	-32(a4,d0,4),a2
	cmpl	end_heap,a2
	jae	yet_args_needed_gc
yet_args_needed_gc_r:
	sub	$3+1+4,d0
	push	d1
	push	a0
	mov	4(a1),d1
	mov	8(a1),a1
	mov	a4,a2
	mov	(a1),a0
	mov	a0,(a4)
	mov	4(a1),a0
	mov	a0,4(a4)
	mov	8(a1),a0
	mov	a0,8(a4)
	add	$12,a1
	add	$12,a4

yet_args_needed_cp_a:
	mov	(a1),a0
	add	$4,a1
	mov	a0,(a4)
	add	$4,a4
	subl	$1,d0
	jge	yet_args_needed_cp_a

	pop	a0
	mov	a0,(a4)
	pop	d0
	add	$8,d0
	mov	d0,4(a4)
	lea	4(a4),a0
	mov	d1,8(a4)
	mov	a2,12(a4)
	add	$16,a4
	ret

yet_args_needed_gc:
	call	collect_2l
	jmp	yet_args_needed_gc_r

build_node_:
	lea	-32+8(a4,d0,4),a2
	cmpl	end_heap,a2
	jae	build_node_gc
build_node_gc_r:
	movl	d1,(a4)
	lea	12(a4),a2
	movl	a1,4(a4)
	movl	a2,8(a4)
	movl	a0,12(a4)
	movl	a4,a0
	movl	-4(a3),a2
	movl	a2,16(a4)
	movl	-8(a3),a2
	movl	a2,20(a4)
	movl	-12(a3),a2
	subl	$12,a3
	movl	a2,24(a4)
	addl	$28,a4

	subl	$5,d0
build_node_cp_a:
	movl	-4(a3),a2
	subl	$4,a3
	movl	a2,(a4)
	addl	$4,a4
	subl	$1,d0
	jne	build_node_cp_a

	ret

build_node_gc:
	call	collect_2l
	jmp	build_node_gc_r
