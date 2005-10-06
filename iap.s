
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

ap_32:
	movl	(a1),a2
	movl	$32*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap32

ap_31:
	movl	(a1),a2
	movl	$31*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap31

ap_30:
	movl	(a1),a2
	movl	$30*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap30

ap_29:
	movl	(a1),a2
	movl	$29*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap29

ap_28:
	movl	(a1),a2
	movl	$28*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap28

ap_27:
	movl	(a1),a2
	movl	$27*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap27

ap_26:
	movl	(a1),a2
	movl	$26*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap26

ap_25:
	movl	(a1),a2
	movl	$25*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap25

ap_24:
	movl	(a1),a2
	movl	$24*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap24

ap_23:
	movl	(a1),a2
	movl	$23*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap23

ap_22:
	movl	(a1),a2
	movl	$22*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap22

ap_21:
	movl	(a1),a2
	movl	$21*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap21

ap_20:
	movl	(a1),a2
	movl	$20*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap20

ap_19:
	movl	(a1),a2
	movl	$19*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap19

ap_18:
	movl	(a1),a2
	movl	$18*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap18

ap_17:
	movl	(a1),a2
	movl	$17*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap17

ap_16:
	movl	(a1),a2
	movl	$16*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap16

ap_15:
	movl	(a1),a2
	movl	$15*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap15

ap_14:
	movl	(a1),a2
	movl	$14*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap14

ap_13:
	movl	(a1),a2
	movl	$13*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap13

ap_12:
	movl	(a1),a2
	movl	$12*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap12

ap_11:
	movl	(a1),a2
	movl	$11*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap11

ap_10:
	movl	(a1),a2
	movl	$10*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap10

ap_9:
	movl	(a1),a2
	movl	$9*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap9

ap_8:
	movl	(a1),a2
	movl	$8*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap8

ap_7:
	movl	(a1),a2
	movl	$7*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap7

ap_6:
	movl	(a1),a2
	movl	$6*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap6

ap_5:
	movl	(a1),a2
	movl	$5*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap5

ap_4:
	movl	(a1),a2
	movl	$4*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap4

ap_3:
	movl	(a1),a2
	movl	$3*8,d1
	cmpw	d1w,(a2)
	je	fast_ap
	jmp	no_fast_ap3

ap_2:
	movl	(a1),a2
	movl	$2*8,d1
	cmpw	d1w,(a2)
	jne	no_fast_ap2

fast_ap:
	movzwl	-2(a2),d0
	movl	-6(a2,d1),d1
#ifdef PROFILE
	subl	$20,d1
#else
	subl	$12,d1
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

repl_args_7_:
	movl	-8(a0,d0,4),a2
	movl	a2,(a3)
	subl	$1,d0
	addl	$4,a3
	cmpl	$6,d0
	jne	repl_args_7_

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
	jmp	*d1

repl_args_0:
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
	jmp	*d1

repl_args_1:
	movl	4(a1),a1
	jmp	*d1

repl_args_2:
	movl	4(a1),a1
	jmp	*d1

repl_args_3:
	movl	4(a0),d0
	movl	(a0),a0
	movl	d0,(a3)
	addl	$4,a3
	jmp	*d1

repl_args_4:
	movl	8(a0),d0
	movl	d0,(a3)
	movl	4(a0),d0
	movl	(a0),a0
	movl	d0,4(a3)
	addl	$8,a3
	jmp	*d1

repl_args_5:
	movl	12(a0),d0
	movl	d0,(a3)
	movl	8(a0),d0
	movl	d0,4(a3)
	movl	4(a0),d0
	movl	(a0),a0
	movl	d0,8(a3)
	addl	$12,a3
	jmp	*d1

no_fast_ap32:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap31:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap30:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap29:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap28:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap27:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap26:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap25:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap24:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap23:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap22:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap21:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap20:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap19:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap18:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap17:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap16:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap15:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap14:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap13:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap12:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap11:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap10:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap9:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap8:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap7:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap6:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap5:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap4:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
no_fast_ap3:
	call	*2(a2)
	movl	(a0),a2
	movl	a0,a1
	movl	-4(a3),a0
	subl	$4,a3
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
add_empty_node_11_lp:
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
	jne	add_empty_node_11_lp
	movl	a4,(d0)
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
add_empty_node_12_lp:
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
	jne	add_empty_node_12_lp
	movl	a4,-4(d0)
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
add_empty_node_13_lp:
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
	jne	add_empty_node_13_lp
	movl	a4,-8(d0)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_13_gc:
	call	collect_2
	jmp	add_empty_node_13_gc_

add_empty_node_30:
	movl	$6,d1
	jmp	add_empty_node_14_
add_empty_node_26:
	movl	$5,d1
	jmp	add_empty_node_14_
add_empty_node_22:
	movl	$4,d1
	jmp	add_empty_node_14_
add_empty_node_18:
	movl	$3,d1
	jmp	add_empty_node_14_
add_empty_node_14:
	movl	$2,d1
add_empty_node_14_:
	cmpl	end_heap,a4
	jae	add_empty_node_14_gc
add_empty_node_14_gc_:
	movl	a3,d0
	movl	-4(a3),a2
	movl	a2,(a3)
	movl	-8(a3),a2
	movl	a2,-4(a3)
	movl	-12(a3),a2
	movl	a2,-8(a3)
add_empty_node_14_lp:
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
	jne	add_empty_node_14_lp
	movl	a4,-12(d0)
	movl	$__cycle__in__spine,(a4)
	addl	$12,a4
	addl	$4,a3
	ret
add_empty_node_14_gc:
	call	collect_2
	jmp	add_empty_node_14_gc_
