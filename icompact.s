/ mark used nodes and pointers in argument parts and link backward pointers

	movl	heap_size_33,d0
	shl	$5,d0
	movl	d0,heap_size_32_33

	movl	caf_list,d0
	test	d0,d0
	je	end_mark_cafs

mark_cafs_lp:
	pushl	-4(d0)
	lea	4(d0),a2
	movl	(d0),d0
	lea	(a2,d0,4),a0
	movl	a0,end_vector
	
	call	mark_stack_nodes
	
	popl	d0
	test	d0,d0
	jne	mark_cafs_lp

end_mark_cafs:
	movl	stack_p,a2

	movl	stack_top,a0
	movl	a0,end_vector
	call	mark_stack_nodes
	
#ifdef MEASURE_GC
	call	add_mark_compact_garbage_collect_time
#endif
	
	jmp	compact_heap

mark_record:	
	subl	$258,a2
	je	mark_record_2
	jb	mark_record_1

mark_record_3:
	movzwl	-2+2(d0),a2
	subl	$1,a2
	jb	mark_record_3_bb
	je	mark_record_3_ab
	dec	a2
	je	mark_record_3_aab
	jmp	mark_hnf_3

mark_record_3_bb:
	movl	8-4(a0),a1
	subl	$4,a0

	movl	neg_heap_p3,d0
	addl	a1,d0

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,a2
	andl	$31*4,d0
	shrl	$7,a2
	movl	bit_set_table(d0),d0
	orl	d0,(a4,a2,4)
#else
	shrl	$2,d0
	bts	d0,(a4)
#endif

	cmpl	a0,a1
	ja	mark_next_node

#ifdef NO_BIT_INSTRUCTIONS
	add	d0,d0
	jne	bit_in_same_word1
	inc	a2
	mov	$1,d0
bit_in_same_word1:
	testl	(a4,a2,4),d0
	je	not_yet_linked_bb
#else
	inc	d0
	bts	d0,(a4)
	jnc	not_yet_linked_bb
#endif
	movl	neg_heap_p3,d0
	addl	a0,d0

#ifdef NO_BIT_INSTRUCTIONS
	addl	$2*4,d0
	movl	d0,a2
	andl	$31*4,d0
	shrl	$7,a2
	movl	bit_set_table(d0),d0
	orl	d0,(a4,a2,4)
#else
	shrl	$2,d0
	addl	$2,d0
	bts	d0,(a4)	
not_yet_linked_bb:
#endif
	movl	(a1),a2
	lea	8+2+1(a0),d0
	movl	a2,8(a0)
	movl	d0,(a1)
	jmp	mark_next_node

#ifdef NO_BIT_INSTRUCTIONS
not_yet_linked_bb:
	orl	d0,(a4,a2,4)
	movl	(a1),a2
	lea	8+2+1(a0),d0
	movl	a2,8(a0)
	movl	d0,(a1)
	jmp	mark_next_node
#endif

mark_record_3_ab:
	movl	4(a0),a1

	movl	neg_heap_p3,d0
	addl	a1,d0

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,a2
	andl	$31*4,d0
	shrl	$7,a2
	movl	bit_set_table(d0),d0
	orl	d0,(a4,a2,4)
#else
	shr	$2,d0
	bts	d0,(a4)
#endif
	cmpl	a0,a1
	ja	mark_hnf_1

#ifdef NO_BIT_INSTRUCTIONS
	add	d0,d0
	jne	bit_in_same_word2
	inc	a2
	mov	$1,d0
bit_in_same_word2:
	testl	(a4,a2,4),d0
	je	not_yet_linked_ab
#else
	inc	d0
	bts	d0,(a4)
	jnc	not_yet_linked_ab
#endif

	movl	neg_heap_p3,d0
	addl	a0,d0

#ifdef NO_BIT_INSTRUCTIONS
	addl	$4,d0
	movl	d0,a2
	andl	$31*4,d0
	shrl	$7,a2
	movl	bit_set_table(d0),d0
	orl	d0,(a4,a2,4)
#else
	shr	$2,d0
	inc	d0
	bts	d0,(a4)
not_yet_linked_ab: 
#endif

	movl	(a1),a2
	lea	4+2+1(a0),d0
	movl	a2,4(a0)
	movl	d0,(a1)
	jmp	mark_hnf_1

#ifdef NO_BIT_INSTRUCTIONS
not_yet_linked_ab: 
	orl	d0,(a4,a2,4)
	movl	(a1),a2
	lea	4+2+1(a0),d0
	movl	a2,4(a0)
	movl	d0,(a1)
	jmp	mark_hnf_1
#endif

mark_record_3_aab:
	movl	4(a0),a1

	movl	neg_heap_p3,d0
	addl	a1,d0

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,a2
	andl	$31*4,d0
	shrl	$7,a2
	movl	bit_set_table(d0),d0
	testl	(a4,a2,4),d0
	jne	shared_argument_part
	orl	d0,(a4,a2,4)
#else
	shr	$2,d0
	bts	d0,(a4)
	jc	shared_argument_part
#endif
	addl	$2,(a0)
	movl	a3,4(a0)
	addl	$4,a0
	
	movl	(a1),a3
	movl	a0,(a1)
	movl	a3,a0
	lea	1(a1),a3
	jmp	mark_node

mark_record_2:
/	movzwl	-2+2(d0),a2
/	cmp	$1,a2
	cmpw	$1,-2+2(d0)
	ja	mark_hnf_2
	je	mark_hnf_1
	subl	$4,a0
	jmp	mark_next_node

mark_record_1:
/	movzwl	-2+2(d0),a2
/	test	a2,a2
	cmpw	$0,-2+2(d0)
	jne	mark_hnf_1
	subl	$4,a0
	jmp	mark_next_node

mark_stack_nodes3:
	pop	a2

	movl	a0,-4(a2)
	jmp	mark_stack_nodes

mark_stack_nodes2:
	pop	a2

mark_stack_nodes1:
	movl	(a0),d1
	leal	1-4(a2),d0
	movl	d1,-4(a2)
	movl	d0,(a0)

mark_stack_nodes:
	cmpl	end_vector,a2
	je	end_mark_nodes

	movl	(a2),a0
	addl	$4,a2

	movl	neg_heap_p3,d0
	addl	a0,d0
#ifdef SHARE_CHAR_INT
	cmpl	heap_size_32_33,d0
	jnc	mark_stack_nodes
#endif

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,d1
	andl	$31*4,d0
	
	shrl	$7,d1

	movl	bit_set_table(d0),d0
	
	movl	(a4,d1,4),a3
	
	test	d0,a3
	jne	mark_stack_nodes1
	
	orl	d0,a3
	push	a2

	movl	a3,(a4,d1,4)
#else
	shrl	$2,d0
	bts	d0,(a4)
	jc	mark_stack_nodes1
	push	a2
#endif

	movl	$1,a3

mark_arguments:
	movl	(a0),d0
	testb	$2,d0b
	je	mark_lazy_node

	movzwl	-2(d0),a2
	test	a2,a2
	je	mark_hnf_0

	addl	$4,a0

	cmp	$256,a2
	jae	mark_record

	subl	$2,a2
	je	mark_hnf_2

	jc	mark_hnf_1

mark_hnf_3:
	movl	4(a0),a1

	movl	neg_heap_p3,d0
	addl	a1,d0

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,d1
	andl	$31*4,d0
	
	shrl	$7,d1

	movl	bit_set_table(d0),d0
		
	test	(a4,d1,4),d0
	jne	shared_argument_part

	orl	d0,(a4,d1,4)	
#else
	shrl	$2,d0
	bts	d0,(a4)
	jc	shared_argument_part
#endif

no_shared_argument_part:
	orl	$2,(a0)
	movl	a3,4(a0)
	addl	$4,a0

	orl	$1,(a1)
	leal	(a1,a2,4),a1

	movl	(a1),a2
	movl	a0,(a1)
	movl	a1,a3
	movl	a2,a0
	jmp	mark_node

shared_argument_part:
	cmpl	a0,a1
	ja	mark_hnf_1

	movl	(a1),d1
	leal	4+2+1(a0),d0
	movl	d0,(a1)
	movl	d1,4(a0)
	jmp	mark_hnf_1

mark_lazy_node_1:
/ selectors:
	jne	mark_selector_node_1

mark_hnf_1:
	movl	(a0),a2
	movl	a3,(a0)

	leal	2(a0),a3
	movl	a2,a0
	jmp	mark_node

/ selectors
mark_indirection_node:
	movl	neg_heap_p3,d1
	leal	-4(a0,d1),d1

#ifdef NO_BIT_INSTRUCTIONS
	movl	d1,d0
	andl	$31*4,d0
	shrl	$7,d1
	movl	bit_clear_table(d0),d0
	andl	d0,(a4,d1,4)
#else
	shrl	$2,d1
	btr	d1,(a4)
#endif
	movl	(a0),a0
	jmp	mark_node

mark_selector_node_1:
	addl	$3,a2
	je	mark_indirection_node

	movl	(a0),a1

	movl	neg_heap_p3,d1
	addl	a1,d1
	shrl	$2,d1

	addl	$1,a2
	jle	mark_record_selector_node_1

#ifdef NO_BIT_INSTRUCTIONS
	push	d0
	movl	d1,d0

	shrl	$5,d1
	andl	$31,d0

	movl	bit_set_table(,d0,4),d0
	movl	(a4,d1,4),d1

	andl	d0,d1

	pop	d0
	jne	mark_hnf_1
#else
	bt	d1,(a4)
	jc	mark_hnf_1
#endif
	movl	(a1),d1
	testb	$2,d1b
	je	mark_hnf_1

	cmpw	$2,-2(d1)
	jbe	small_tuple_or_record

large_tuple_or_record:
	movl	8(a1),d1
	addl	neg_heap_p3,d1
	shrl	$2,d1

#ifdef NO_BIT_INSTRUCTIONS
	push	d0
	movl	d1,d0

	shrl	$5,d1
	andl	$31,d0

	movl	bit_set_table(,d0,4),d0
	movl	(a4,d1,4),d1
	
	andl	d0,d1

	pop	d0
	jne	mark_hnf_1
#else
	bt	d1,(a4)
	jc	mark_hnf_1
#endif
small_tuple_or_record:
	movl	neg_heap_p3,d1

	lea	-4(a0,d1),d1

	push	a0

#ifdef NO_BIT_INSTRUCTIONS
	movl	d1,a0
	andl	$31*4,a0
	shrl	$7,d1
	movl	bit_clear_table(a0),a0
	andl	a0,(a4,d1,4)
#else
	shrl	$2,d1
	btr	d1,(a4)
#endif

	movl	-8(d0),d0

	movl	a1,a0
	push	a2
	call	*4(d0)
	pop	a2
	pop	a1

	movl	$__indirection,-4(a1)
	movl	a0,(a1)
	
	jmp	mark_node

mark_record_selector_node_1:
	je	mark_strict_record_selector_node_1

#ifdef NO_BIT_INSTRUCTIONS
	push	d0
	movl	d1,d0

	shrl	$5,d1
	andl	$31,d0

	movl	bit_set_table(,d0,4),d0
	movl	(a4,d1,4),d1

	andl	d0,d1

	pop	d0
	jne	mark_hnf_1
#else
	bt	d1,(a4)
	jc	mark_hnf_1
#endif
	movl	(a1),d1
	testb	$2,d1b
	je	mark_hnf_1

	cmpw	$258,-2(d1)
	jbe	small_tuple_or_record
	jmp	large_tuple_or_record

mark_strict_record_selector_node_1:
#ifdef NO_BIT_INSTRUCTIONS
	push	d0
	movl	d1,d0

	shrl	$5,d1
	andl	$31,d0

	movl	bit_set_table(,d0,4),d0
	movl	(a4,d1,4),d1

	andl	d0,d1
	
	pop	d0
	jne	mark_hnf_1
#else
	bt	d1,(a4)
	jc	mark_hnf_1
#endif
	movl	(a1),d1
	testb	$2,d1b
	je	mark_hnf_1

	cmpw	$258,-2(d1)
	jbe	select_from_small_record

	movl	8(a1),d1
	addl	neg_heap_p3,d1
#ifdef NO_BIT_INSTRUCTIONS
	push	d0
	movl	d1,d0

	shrl	$7,d1
	andl	$31*4,d0

	movl	bit_set_table(d0),d0
	movl	(a4,d1,4),d1

	andl	d0,d1

	pop	d0
	jne	mark_hnf_1
#else
	shrl	$2,d1
	bt	d1,(a4)
	jc	mark_hnf_1
#endif

select_from_small_record:
/ changed 24-1-97
	movl	-8(d0),d0
	subl	$4,a0
	
	call	*4(d0)

	jmp	mark_next_node

mark_hnf_2:
	orl	$2,(a0)
	movl	4(a0),a2
	movl	a3,4(a0)
	leal	4(a0),a3
	movl	a2,a0

mark_node:
	movl	neg_heap_p3,d0

	addl	a0,d0

#ifdef SHARE_CHAR_INT
	cmpl	heap_size_32_33,d0
	jnc	mark_next_node_after_static
#endif

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,d1
	andl	$31*4,d0
	
	shrl	$7,d1

	movl	bit_set_table(d0),d0
	
	movl	(a4,d1,4),a2
	
	test	d0,a2
	jne	mark_next_node
	
	orl	d0,a2
	movl	a2,(a4,d1,4)
	jmp	mark_arguments
#else
	shrl	$2,d0
	bts	d0,(a4)
	jnc	mark_arguments
#endif

/ a2,d1: free

mark_next_node:
	test	$3,a3
	jne	mark_parent

	movl	-4(a3),a2
	movl	$3,d1
	
	andl	a2,d1
	subl	$4,a3

	cmpl	$3,d1
	je	argument_part_cycle1

	movl	4(a3),a1
	movl	a1,K6_0(a3)

c_argument_part_cycle1:
	cmpl	a3,a0
	ja	no_reverse_1

	movl	(a0),a1
	leal	4+1(a3),d0
	movl	a1,4(a3)
	movl	d0,(a0)
	
	orl	d1,a3
	movl	a2,a0
	xorl	d1,a0
	jmp	mark_node

no_reverse_1:
	movl	a0,4(a3)
	movl	a2,a0
	orl	d1,a3
	xorl	d1,a0
	jmp	mark_node

mark_lazy_node:
	movl	-4(d0),a2
	test	a2,a2
	je	mark_next_node

	addl	$4,a0

	subl	$1,a2
	jle	mark_lazy_node_1

	cmpl	$255,a2
	jge	mark_closure_with_unboxed_arguments

mark_closure_with_unboxed_arguments_:
	orl	$2,(a0)
	leal	(a0,a2,4),a0

	movl	(a0),a2
	movl	a3,(a0)
	movl	a0,a3
	movl	a2,a0
	jmp	mark_node

mark_closure_with_unboxed_arguments:
/ (a_size+b_size)+(b_size<<8)
/	addl	$1,a2
	movl	a2,d0
	andl	$255,a2
	shrl	$8,d0
	subl	d0,a2
/	subl	$1,a2
	jg	mark_closure_with_unboxed_arguments_
	je	mark_hnf_1
	subl	$4,a0
	jmp	mark_next_node

mark_hnf_0:
#ifdef SHARE_CHAR_INT
	cmpl	$INT+2,d0
	je	mark_int_3

	cmpl	$CHAR+2,d0
 	je	mark_char_3

	jb	no_normal_hnf_0

	movl	neg_heap_p3,d1
	addl	a0,d1
#ifdef NO_BIT_INSTRUCTIONS
	movl	d1,a0
	andl	$31*4,a0
	shrl	$7,d1
	movl	bit_clear_table(a0),a0
	andl	a0,(a4,d1,4)
#else
	shrl	$2,d1
	btr	d1,(a4)
#endif
	lea	ZERO_ARITY_DESCRIPTOR_OFFSET-2(d0),a0
	jmp	mark_next_node_after_static

mark_int_3:
	movl	4(a0),a2
	cmpl	$33,a2
	jnc	mark_next_node

	movl	neg_heap_p3,d1
	addl	a0,d1

#ifdef NO_BIT_INSTRUCTIONS
	movl	d1,a0
	andl	$31*4,a0
	shrl	$7,d1
	movl	bit_clear_table(a0),a0
	andl	a0,(a4,d1,4)
#else
	shrl	$2,d1
	btr	d1,(a4)
#endif
	lea	small_integers(,a2,8),a0
	jmp	mark_next_node_after_static

mark_char_3:
	movl	neg_heap_p3,d1

	movzbl	4(a0),d0
	addl	a0,d1

#ifdef NO_BIT_INSTRUCTIONS
	movl	d1,a2
	andl	$31*4,a2
	shrl	$7,d1
	movl	bit_clear_table(a2),a2
	andl	a2,(a4,d1,4)
#else
	shrl	$2,d1
	btr	d1,(a4)
#endif

	lea	static_characters(,d0,8),a0
	jmp	mark_next_node_after_static
	
no_normal_hnf_0:
#endif

	cmpl	$__ARRAY__+2,d0
	jne	mark_next_node

	movl	8(a0),d0
	test	d0,d0
	je	mark_lazy_array

	movzwl	-2+2(d0),d1
	test	d1,d1
	je	mark_b_record_array

	movzwl	-2(d0),d0
	test	d0,d0
	je	mark_b_record_array

	subl	$256,d0
	cmpl	d0,d1
	je	mark_a_record_array

mark_ab_record_array:
	movl	4(a0),a1
	addl	$8,a0
	pushl	a0

	imull	d0,a1
	shl	$2,a1

	subl	d1,d0
	addl	$4,a0
	addl	a0,a1
	call	reorder
	
	popl	a0
	movl	d1,d0
	imull	-4(a0),d0	
	jmp	mark_lr_array

mark_b_record_array:
	movl	neg_heap_p3,d0
	addl	a0,d0
#ifdef NO_BIT_INSTRUCTIONS
	addl	$4,d0
	movl	d0,a2
	andl	$31*4,d0
	shrl	$7,a2
	movl	bit_set_table(d0),d0
	orl	d0,(a4,a2,4)
#else
	shrl	$2,d0
	inc	d0
	bts	d0,(a4)
#endif
	jmp	mark_next_node

mark_a_record_array:
	movl	4(a0),d0
	addl	$8,a0
	cmpl	$2,d1
	jb	mark_lr_array

	imull	d1,d0
	jmp	mark_lr_array

mark_lazy_array:
	movl	4(a0),d0
	addl	$8,a0

mark_lr_array:
	movl	neg_heap_p3,d1
	addl	a0,d1
	shrl	$2,d1
	addl	d0,d1

#ifdef NO_BIT_INSTRUCTIONS
	movl	d1,a1
	andl	$31,d1
	shrl	$5,a1
	movl	bit_set_table(,d1,4),d1
	orl	d1,(a4,a1,4)
#else
	bts	d1,(a4)
#endif
	cmpl	$1,d0
	jbe	mark_array_length_0_1

	movl	a0,a1
	lea	(a0,d0,4),a0

	movl	(a0),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,(a0)
	
	movl	-4(a0),d0
	subl	$4,a0
	addl	$2,d0
	movl	-4(a1),d1
	subl	$4,a1
	movl	d1,(a0)
	movl	d0,(a1)

	movl	-4(a0),d0
	subl	$4,a0
	movl	a3,(a0)
	movl	a0,a3
	movl	d0,a0
	jmp	mark_node

mark_array_length_0_1:
	lea	-8(a0),a0
	jb	mark_next_node

	movl	12(a0),d1
	movl	8(a0),a2
	movl	a2,12(a0)
	movl	4(a0),a2
	movl	a2,8(a0)
	movl	d1,4(a0)
	addl	$4,a0
	jmp	mark_hnf_1

/ a2: free

mark_parent:
	movl	a3,d1
	andl	$3,d1

	andl	$-4,a3
	je	mark_stack_nodes2

	subl	$1,d1
	je	argument_part_parent

	movl	K6_0(a3),a2
	
	cmpl	a3,a0
	ja	no_reverse_2

	movl	a0,a1
	leal	1(a3),d0
	movl	(a1),a0
	movl	d0,(a1)

no_reverse_2:
	movl	a0,K6_0(a3)
	leal	-4(a3),a0
	movl	a2,a3
	jmp	mark_next_node
	

argument_part_parent:
	movl	K6_0(a3),a2

	movl	a3,a1
	movl	a0,a3
	movl	a1,a0

skip_upward_pointers:
	movl	a2,d0
	andl	$3,d0
	cmpl	$3,d0
	jne	no_upward_pointer

	leal	-3(a2),a1
	movl	-3(a2),a2
	jmp	skip_upward_pointers

no_upward_pointer:
	cmpl	a0,a3
	ja	no_reverse_3

	movl	a3,d1
	movl	K6_0(a3),a3
	leal	1(a0),d0
	movl	d0,(d1)
	
no_reverse_3:
	movl	a3,(a1)
	lea	-4(a2),a3

	andl	$-4,a3

	movl	a3,a1
	movl	$3,d1

	movl	K6_0(a3),a2

	andl	a2,d1
	movl	4(a1),d0

	orl	d1,a3
	movl	d0,(a1)

	cmpl	a1,a0
	ja	no_reverse_4

	movl	(a0),d0
	movl	d0,4(a1)
	leal	4+2+1(a1),d0
	movl	d0,(a0)
	movl	a2,a0
	andl	$-4,a0
	jmp	mark_node

no_reverse_4:
	movl	a0,4(a1)
	movl	a2,a0
	andl	$-4,a0
	jmp	mark_node

argument_part_cycle1:
	movl	4(a3),d0
	push	a1

skip_pointer_list1:
	movl	a2,a1
	andl	$-4,a1
	movl	(a1),a2
	movl	$3,d1
	andl	a2,d1
	cmpl	$3,d1
	je	skip_pointer_list1

	movl	d0,(a1)
	pop	a1
	jmp	c_argument_part_cycle1

#ifdef SHARE_CHAR_INT
mark_next_node_after_static:
	test	$3,a3
	jne	mark_parent_after_static

	movl	-4(a3),a2
	movl	$3,d1
	
	andl	a2,d1
	subl	$4,a3

	cmpl	$3,d1
	je	argument_part_cycle2
	
	movl	4(a3),d0
	movl	d0,K6_0(a3)

c_argument_part_cycle2:
	movl	a0,4(a3)
	movl	a2,a0
	orl	d1,a3
	xorl	d1,a0
	jmp	mark_node

mark_parent_after_static:
	movl	a3,d1
	andl	$3,d1

/	xorl	d1,a3
/	test	a3,a3

	andl	$-4,a3
	je	mark_stack_nodes3

	subl	$1,d1
	je	argument_part_parent_after_static

	movl	K6_0(a3),a2
	movl	a0,K6_0(a3)
	leal	-4(a3),a0
	movl	a2,a3
	jmp	mark_next_node
	
argument_part_parent_after_static:
	movl	K6_0(a3),a2

	movl	a3,a1
	movl	a0,a3
	movl	a1,a0

/	movl	(a1),a2
skip_upward_pointers_2:
	movl	a2,d0
	andl	$3,d0
	cmpl	$3,d0
	jne	no_reverse_3

/	movl	a2,a1
/	andl	$-4,a1
/	movl	(a1),a2
	lea	-3(a2),a1
	movl	-3(a2),a2
	jmp	skip_upward_pointers_2

argument_part_cycle2:
	movl	4(a3),d0
	push	a1

skip_pointer_list2:
	movl	a2,a1
	andl	$-4,a1
	movl	(a1),a2
	movl	$3,d1
	andl	a2,d1
	cmpl	$3,d1
	je	skip_pointer_list2

	movl	d0,(a1)
	pop	a1
	jmp	c_argument_part_cycle2
#endif

end_mark_nodes:
	ret

/ compact the heap

compact_heap:

#ifdef FINALIZERS
	movl	$finalizer_list,a0
	movl	$free_finalizer_list,a1

	movl	(a0),a2
determine_free_finalizers_after_compact1:
	cmpl	$__Nil-8,a2
	je	end_finalizers_after_compact1

	movl	neg_heap_p3,d0
	addl	a2,d0
	movl	d0,d1
	andl	$31*4,d0
	shrl	$7,d1
	movl	bit_set_table(d0),a3
	testl	(a4,d1,4),a3
	je	finalizer_not_used_after_compact1

	movl	(a2),d0
	movl	a2,a3
	jmp	finalizer_find_descriptor

finalizer_find_descriptor_lp:
	andl	$-4,d0
	movl	d0,a3
	movl	(d0),d0
finalizer_find_descriptor:
	test	$1,d0
	jne	finalizer_find_descriptor_lp

	movl	$e____system__kFinalizerGCTemp+2,(a3)

	cmpl	a0,a2
	ja	finalizer_no_reverse

	movl	(a2),d0
	leal	1(a0),a3
	movl	a3,(a2)
	movl	d0,(a0)

finalizer_no_reverse:
	lea	4(a2),a0
	movl	4(a2),a2
	jmp	determine_free_finalizers_after_compact1

finalizer_not_used_after_compact1:
	movl	$e____system__kFinalizerGCTemp+2,(a2)

	movl	a2,(a1)
	lea	4(a2),a1

	movl	4(a2),a2
	movl	a2,(a0)

	jmp	determine_free_finalizers_after_compact1

end_finalizers_after_compact1:
	movl	a2,(a1)	

	movl	finalizer_list,a0
	cmpl	$__Nil-8,a0
	je	finalizer_list_empty
	testl	$3,a0
	jne	finalizer_list_already_reversed
	movl	(a0),d0
	movl	$finalizer_list+1,(a0)
	movl	d0,finalizer_list
finalizer_list_already_reversed:
finalizer_list_empty:

	movl	$free_finalizer_list,a2
	cmpl	$__Nil-8,(a2)
	je	free_finalizer_list_empty

	movl	$free_finalizer_list+4,end_vector
	call	mark_stack_nodes

free_finalizer_list_empty:
#endif

	movl	heap_size_33,d0
	movl	d0,d1
	shl	$5,d1
#ifdef SHARE_CHAR_INT
	addl	heap_p3,d1
#endif
	movl	d1,end_heap_p3

	addl	$3,d0
	shr	$2,d0
	
	movl	heap_vector,a0

	lea	4(a0),d1
	negl	d1
	movl	d1,neg_heap_vector_plus_4

	movl	heap_p3,a4
	xorl	a3,a3
	jmp	skip_zeros

move_record:
	subl	$258,d1
	jb	move_record_1
	je	move_record_2

move_record_3:
	movzwl	-2+2(d0),d1
	subl	$1,d1
	ja	move_hnf_3

	movl	(a0),a1
	lea	4(a0),a0
	jb	move_record_3_1b

move_record_3_1a:
	cmpl	a0,a1
	jb	move_record_3_1b
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jae	move_record_3_1b
#endif
	lea	1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_record_3_1b:
	movl	a1,(a4)
	addl	$4,a4

	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jb	move_record_3_2
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jae	move_record_3_2
#endif
	movl	neg_heap_p3,d0
#ifdef NO_BIT_INSTRUCTIONS
	pushl	a2
#endif
	addl	a1,d0

#ifdef NO_BIT_INSTRUCTIONS
	movl	heap_vector,d1
	addl	$4,d0
	movl	d0,a2
	andl	$31*4,a2
	shrl	$7,d0
	movl	bit_set_table(a2),a2
	testl	(d1,d0,4),a2
	je	not_linked_record_argument_part_3_b
#else
	shr	$2,d0
	inc	d0

	movl	heap_vector,d1
	bts	d0,(d1)
	jnc	not_linked_record_argument_part_3_b
#endif

	movl	neg_heap_p3,d0
	addl	a4,d0

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,a2
	andl	$31*4,a2
	shrl	$7,d0
	movl	bit_set_table(a2),a2
	orl	a2,(d1,d0,4)
	popl	a2
#else
	shr	$2,d0
	bts	d0,(d1)
#endif
	jmp	linked_record_argument_part_3_b

not_linked_record_argument_part_3_b:
#ifdef NO_BIT_INSTRUCTIONS
	orl	a2,(d1,d0,4)
#endif
	movl	neg_heap_p3,d0
	addl	a4,d0

#ifdef NO_BIT_INSTRUCTIONS
	movl	d0,a2
	andl	$31*4,a2
	shrl	$7,d0
	movl	bit_clear_table(a2),a2
	andl	a2,(d1,d0,4)
	popl	a2
#else
	shr	$2,d0
	btr	d0,(d1)
#endif

linked_record_argument_part_3_b:
	movl	(a1),d1
	lea	2+1(a4),d0
	movl	d0,(a1)
	movl	d1,a1
move_record_3_2:
	movl	a1,(a4)
	addl	$4,a4

	movl	neg_heap_p3,d1
	addl	a0,d1
	shr	$2,d1
	dec	d1
	andl	$31,d1
	cmp	$2,d1
	jb	bit_in_next_word
	
#ifdef NO_BIT_INSTRUCTIONS
	andl	bit_clear_table(,d1,4),a3
#else
	btr	d1,a3
#endif

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long
	
bit_in_next_word:
	movl	vector_counter,d0
	movl	vector_p,a0
	dec	d0
	movl	(a0),a3
	addl	$4,a0

#ifdef NO_BIT_INSTRUCTIONS
	andl	bit_clear_table(,d1,4),a3
#else
	btr	d1,a3
#endif
	testl	a3,a3
	je	skip_zeros
	jmp	end_skip_zeros

move_record_2:
	cmpw	$1,-2+2(d0)
	ja	move_hnf_2
	jb	move_real_or_file

move_record_2_ab:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jb	move_record_2_1
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jae	move_record_2_1
#endif
	lea	1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_record_2_1:
	movl	a1,(a4)
	movl	(a0),d1
	addl	$4,a0
	movl	d1,4(a4)
	addl	$8,a4

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_record_1:
	movzwl	-2+2(d0),d1
	test	d1,d1
	jne	move_hnf_1
	jmp	move_int_bool_or_char

/ d0,a0,a2: free
find_non_zero_long:
	movl	vector_counter,d0
	movl	vector_p,a0
skip_zeros:
	subl	$1,d0
	jc	end_copy
	movl	(a0),a3
	addl	$4,a0
	testl	a3,a3
	je	skip_zeros
/ a2: free
end_skip_zeros:
	movl	neg_heap_vector_plus_4,a2
	movl	d0,vector_counter

	addl	a0,a2
	movl	a0,vector_p

	shl	$5,a2
	addl	heap_p3,a2

#ifdef NO_BIT_INSTRUCTIONS
bsf_and_copy_nodes:
	movl	a3,d0
	movl	a3,a0
	andl	$0xff,d0
	jne	found_bit1
	andl	$0xff00,a0
	jne	found_bit2
	movl	a3,d0
	movl	a3,a0
	andl	$0xff0000,d0
	jne	found_bit3
	shrl	$24,a0
	movzbl	first_one_bit_table(,a0,1),d1
	addl	$24,d1
	jmp	copy_nodes

found_bit3:
	shrl	$16,d0
	movzbl	first_one_bit_table(,d0,1),d1
	addl	$16,d1
	jmp	copy_nodes

found_bit2:
	shrl	$8,a0
	movzbl	first_one_bit_table(,a0,1),d1
	addl	$8,d1
	jmp	copy_nodes

found_bit1:	
	movzbl	first_one_bit_table(,d0,1),d1
#else
	bsf	a3,d1
#endif

copy_nodes:
	movl	(a2,d1,4),d0
#ifdef NO_BIT_INSTRUCTIONS
	andl	bit_clear_table(,d1,4),a3
#else
	btr	d1,a3
#endif
	leal	4(a2,d1,4),a0
	dec	d0

	test	$2,d0
	je	begin_update_list_2

	movl	-10(d0),d1
	subl	$2,d0

	test	$1,d1
	je	end_list_2
find_descriptor_2:
	andl	$-4,d1
	movl	(d1),d1
	test	$1,d1
	jne	find_descriptor_2

end_list_2:
	movl	d1,a1
	movzwl	-2(d1),d1
	cmpl	$256,d1
	jb	no_record_arguments

	movzwl	-2+2(a1),a1
	subl	$2,a1
	jae	copy_record_arguments_aa

	subl	$256+3,d1

copy_record_arguments_all_b:
	pushl	d1
	movl	heap_vector,d1

update_up_list_1r:
	movl	d0,a1
	addl	neg_heap_p3,d0

#ifdef NO_BIT_INSTRUCTIONS
	push	a0
	movl	d0,a0

	shrl	$7,d0
	andl	$31*4,a0

	movl	bit_set_table(,a0,1),a0
	movl	(d1,d0,4),d0

	andl	a0,d0

	pop	a0
	je	copy_argument_part_1r
#else
	shrl	$2,d0
	bt	d0,(d1)
	jnc	copy_argument_part_1r
#endif
	movl	(a1),d0
	movl	a4,(a1)
	subl	$3,d0
	jmp	update_up_list_1r

copy_argument_part_1r:
	movl	(a1),d0
	movl	a4,(a1)
	movl	d0,(a4)
	addl	$4,a4

	movl	neg_heap_p3,d0
	addl	a0,d0
	shr	$2,d0
	
	mov	d0,d1
	andl	$31,d1
	cmp	$1,d1
	jae	bit_in_this_word

	movl	vector_counter,d0
	movl	vector_p,a1
	dec	d0
	movl	(a1),a3
	addl	$4,a1

	movl	neg_heap_vector_plus_4,a2
	addl	a1,a2
	shl	$5,a2
	addl	heap_p3,a2

	movl	a1,vector_p
	movl	d0,vector_counter

bit_in_this_word:
#ifdef NO_BIT_INSTRUCTIONS
	andl	bit_clear_table(,d1,4),a3
#else
	btr	d1,a3
#endif
	popl	d1

copy_b_record_argument_part_arguments:
	movl	(a0),d0
	addl	$4,a0
	movl	d0,(a4)
	addl	$4,a4
	subl	$1,d1
	jnc	copy_b_record_argument_part_arguments

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

copy_record_arguments_aa:
	subl	$256+2,d1
	subl	a1,d1
	
	pushl	d1
	pushl	a1

update_up_list_2r:
	movl	d0,a1
	movl	(a1),d0
	movl	$3,d1
	andl	d0,d1
	subl	$3,d1
	jne	copy_argument_part_2r

	movl	a4,(a1)
	subl	$3,d0
	jmp	update_up_list_2r

copy_argument_part_2r:
	movl	a4,(a1)
	cmpl	a0,d0
	jb	copy_record_argument_2
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,d0
	jae	copy_record_argument_2
#endif
	movl	d0,a1
	movl	(a1),d0
	lea	1(a4),d1
	movl	d1,(a1)
copy_record_argument_2:
	movl	d0,(a4)
	addl	$4,a4

	popl	d1
	subl	$1,d1
	jc	no_pointers_in_record

copy_record_pointers:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jb	copy_record_pointers_2
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jae	copy_record_pointers_2
#endif
	movl	(a1),d0
	inc	a4
	movl	a4,(a1)
	dec	a4
	movl	d0,a1
copy_record_pointers_2:
	movl	a1,(a4)
	addl	$4,a4
	subl	$1,d1
	jnc	copy_record_pointers

no_pointers_in_record:
	popl	d1
	
	subl	$1,d1
	jc	no_non_pointers_in_record

copy_non_pointers_in_record:
	movl	(a0),d0
	addl	$4,a0
	movl	d0,(a4)
	addl	$4,a4
	subl	$1,d1
	jnc	copy_non_pointers_in_record

no_non_pointers_in_record:
#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

no_record_arguments:
	subl	$3,d1
update_up_list_2:
	movl	d0,a1
	movl	(d0),d0
	inc	d0
	movl	a4,(a1)
	testb	$3,d0b
	jne	copy_argument_part_2

	subl	$4,d0
	jmp	update_up_list_2

copy_argument_part_2:
	dec	d0
	cmpl	a0,d0
	jc	copy_arguments_1
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,d0
	jnc	copy_arguments_1
#endif
	movl	d0,a1
	movl	(d0),d0
	inc	a4
	movl	a4,(a1)
	dec	a4
copy_arguments_1:
	movl	d0,(a4)
	addl	$4,a4

copy_argument_part_arguments:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	copy_arguments_2
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	copy_arguments_2
#endif
	movl	(a1),d0
	inc	a4
	movl	a4,(a1)
	dec	a4
	movl	d0,a1
copy_arguments_2:
	movl	a1,(a4)
	addl	$4,a4
	subl	$1,d1
	jnc	copy_argument_part_arguments

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

update_list_2_:
	dec	d0
update_list_2:
	movl	a4,(a1)
begin_update_list_2:
	movl	d0,a1
	movl	(d0),d0
update_list__2:
	test	$1,d0
	jz	end_update_list_2
	test	$2,d0
	jz	update_list_2_
	lea	-3(d0),a1
	movl	-3(d0),d0
	jmp	update_list__2

end_update_list_2:
	movl	a4,(a1)

	movl	d0,(a4)
	addl	$4,a4

	testb	$2,d0b
	je	move_lazy_node

	movzwl	-2(d0),d1
	testl	d1,d1
	je	move_hnf_0

	cmp	$256,d1
	jae	move_record

	subl	$2,d1
	jc	move_hnf_1
	je	move_hnf_2

move_hnf_3:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_hnf_3_1
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_hnf_3_1
#endif
	lea	1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_hnf_3_1:
	movl	a1,(a4)
	
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_hnf_3_2
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_hnf_3_2
#endif
	lea	4+2+1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_hnf_3_2:
	movl	a1,4(a4)
	addl	$8,a4

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_hnf_2:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_hnf_2_1
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_hnf_2_1
#endif
	lea	1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_hnf_2_1:
	movl	a1,(a4)
	
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_hnf_2_2
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_hnf_2_2
#endif
	lea	4+1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_hnf_2_2:
	movl	a1,4(a4)
	addl	$8,a4

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_hnf_1:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_hnf_1_
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_hnf_1_
#endif
	lea	1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_hnf_1_:
	movl	a1,(a4)
	addl	$4,a4

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_real_or_file:
	movl	(a0),d0
	addl	$4,a0
	movl	d0,(a4)
	addl	$4,a4
move_int_bool_or_char:
	movl	(a0),d0
	addl	$4,a0
	movl	d0,(a4)
	addl	$4,a4
copy_normal_hnf_0:
#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_hnf_0:
	cmpl	$INT+2,d0
	jb	move_real_file_string_or_array
	cmpl	$CHAR+2,d0
	jbe	move_int_bool_or_char
#ifdef DLL
move_normal_hnf_0:
#endif

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_real_file_string_or_array:
	cmpl	$__STRING__+2,d0
	ja	move_real_or_file
	jne	move_array

	movl	(a0),d0
	addl	$3,d0
	shr	$2,d0

cp_s_arg_lp3:
	movl	(a0),d1
	addl	$4,a0
	movl	d1,(a4)
	addl	$4,a4
	subl	$1,d0
	jnc	cp_s_arg_lp3

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_array:
#ifdef DLL
	cmpl	$__ARRAY__+2,d0
	jb	move_normal_hnf_0
#endif
#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_end_array_bit
#else
	bsf	a3,d1
	jne	end_array_bit
#endif
	pushl	a0

	movl	vector_counter,d0
	movl	vector_p,a0

skip_zeros_a:
	subl	$1,d0
	movl	(a0),a3
	addl	$4,a0
	testl	a3,a3
	je	skip_zeros_a

	movl	neg_heap_vector_plus_4,a2
	addl	a0,a2
	movl	d0,vector_counter

	shl	$5,a2
	movl	a0,vector_p

	addl	heap_p3,a2
	popl	a0

#ifdef NO_BIT_INSTRUCTIONS
bsf_and_end_array_bit:
	movl	a3,d0
	movl	a3,a1
	andl	$0xff,d0
	jne	a_found_bit1
	andl	$0xff00,a1
	jne	a_found_bit2
	movl	a3,d0
	movl	a3,a1
	andl	$0xff0000,d0
	jne	a_found_bit3
	shrl	$24,a1
	movzbl	first_one_bit_table(,a1,1),d1
	addl	$24,d1
	jmp	end_array_bit
a_found_bit3:
	shrl	$16,d0
	movzbl	first_one_bit_table(,d0,1),d1
	addl	$16,d1
	jmp	end_array_bit
a_found_bit2:
	shrl	$8,a1
	movzbl	first_one_bit_table(,a1,1),d1
	addl	$8,d1
	jmp	end_array_bit
a_found_bit1:
	movzbl	first_one_bit_table(,d0,1),d1

#else
	bsf	a3,d1
#endif

end_array_bit:
#ifdef NO_BIT_INSTRUCTIONS
	andl	bit_clear_table(,d1,4),a3
#else
	btr	d1,a3
#endif
	leal	(a2,d1,4),d1

	cmpl	d1,a0
	jne	move_a_array

move_b_array:
	movl	(a0),a1
	movl	a1,(a4)
	movl	4(a0),d1
	addl	$4,a0
	movzwl	-2(d1),d0
	addl	$4,a4
	test	d0,d0
	je	move_strict_basic_array

	subl	$256,d0
	imull	d0,a1
	movl	a1,d0
	jmp	cp_s_arg_lp3

move_strict_basic_array:
	movl	a1,d0
	cmpl	$INT+2,d1
	je	cp_s_arg_lp3

	cmpl	$BOOL+2,d1
	je	move_bool_array

	addl	d0,d0
	jmp	cp_s_arg_lp3

move_bool_array:
	addl	$3,d0
	shr	$2,d0
	jmp	cp_s_arg_lp3

move_a_array:
	movl	d1,a1
	subl	a0,d1
	shr	$2,d1

	pushl	a3

	subl	$1,d1
	jb	end_array

	movl	(a0),a3
	movl	-4(a1),d0
	movl	a3,-4(a1)
	movl	d0,(a4)
	movl	(a1),d0
	movl	4(a0),a3
	addl	$8,a0
	movl	a3,(a1)
	movl	d0,4(a4)
	addl	$8,a4
	test	d0,d0
	je	st_move_array_lp

	movzwl	-2+2(d0),a3
	movzwl	-2(d0),d0
	subl	$256,d0
	cmpl	a3,d0
	je	st_move_array_lp

move_array_ab:
	pushl	a0

	movl	-8(a4),a1
	movl	a3,d1
	imull	d0,a1
	shl	$2,a1

	subl	d1,d0
	addl	a0,a1
	call	reorder

	popl	a0
	subl	$1,d1
	subl	$1,d0

	pushl	d1
	pushl	d0
	pushl	-8(a4)
	jmp	st_move_array_lp_ab

move_array_ab_lp1:
	movl	8(sp),d0
move_array_ab_a_elements:
	movl	(a0),d1
	addl	$4,a0
	cmpl	a0,d1
	jb	move_array_element_ab
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,d1
	jnc	move_array_element_ab
#endif
	movl	d1,a1
	movl	(a1),d1
	inc	a4
	movl	a4,(a1)
	dec	a4
move_array_element_ab:
	movl	d1,(a4)
	addl	$4,a4
	subl	$1,d0
	jnc	move_array_ab_a_elements

	movl	4(sp),d0
move_array_ab_b_elements:
	movl	(a0),d1
	addl	$4,a0
	movl	d1,(a4)
	addl	$4,a4
	subl	$1,d0
	jnc	move_array_ab_b_elements

st_move_array_lp_ab:
	subl	$1,(sp)
	jnc	move_array_ab_lp1

	addl	$12,sp
	jmp	end_array	

move_array_lp1:
	movl	(a0),d0
	addl	$4,a0
	addl	$4,a4
	cmpl	a0,d0
	jb	move_array_element
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,d0
	jnc	move_array_element
#endif
	movl	(d0),a3
	movl	d0,a1
	movl	a3,-4(a4)
	leal	-4+1(a4),d0
	movl	d0,(a1)

	subl	$1,d1
	jnc	move_array_lp1

	jmp	end_array

move_array_element:
	movl	d0,-4(a4)
st_move_array_lp:
	subl	$1,d1
	jnc	move_array_lp1

end_array:
	popl	a3

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_lazy_node:
	movl	d0,a1
	movl	-4(a1),d1
	test	d1,d1
	je	move_lazy_node_0

	subl	$1,d1
	jle	move_lazy_node_1

	cmpl	$256,d1
	jge	move_closure_with_unboxed_arguments

move_lazy_node_arguments:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_lazy_node_arguments_
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_lazy_node_arguments_
#endif
	movl	(a1),d0
	movl	d0,(a4)
	lea	1(a4),d0
	addl	$4,a4
	movl	d0,(a1)
	subl	$1,d1
	jnc	move_lazy_node_arguments

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_lazy_node_arguments_:
	movl	a1,(a4)
	addl	$4,a4
	subl	$1,d1
	jnc	move_lazy_node_arguments
	
#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_lazy_node_1:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_lazy_node_1_
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_lazy_node_1_
#endif
	lea	1(a4),d0
	movl	(a1),d1
	movl	d0,(a1)
	movl	d1,a1
move_lazy_node_1_:
	movl	a1,(a4)
	addl	$8,a4

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_lazy_node_0:
	addl	$8,a4

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_closure_with_unboxed_arguments:
	je	move_closure_with_unboxed_arguments_1
	addl	$1,d1
	movl	d1,d0
	andl	$255,d1
	shrl	$8,d0
	subl	d0,d1
	je	move_non_pointers_of_closure

	pushl	d0

move_closure_with_unboxed_arguments_lp:
	movl	(a0),a1
	addl	$4,a0
	cmpl	a0,a1
	jc	move_closure_with_unboxed_arguments_
#ifdef SHARE_CHAR_INT
	cmpl	end_heap_p3,a1
	jnc	move_closure_with_unboxed_arguments_
#endif
	movl	(a1),d0
	movl	d0,(a4)
	lea	1(a4),d0
	addl	$4,a4
	movl	d0,(a1)
	subl	$1,d1
	jne	move_closure_with_unboxed_arguments_lp

	popl	d0
	jmp	move_non_pointers_of_closure

move_closure_with_unboxed_arguments_:
	movl	a1,(a4)
	addl	$4,a4
	subl	$1,d1
	jne	move_closure_with_unboxed_arguments_lp

	popl	d0

move_non_pointers_of_closure:
	movl	(a0),d1
	addl	$4,a0
	movl	d1,(a4)
	addl	$4,a4
	subl	$1,d0
	jne	move_non_pointers_of_closure

#ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
#else
	bsf	a3,d1
	jne	copy_nodes
#endif
	jmp	find_non_zero_long

move_closure_with_unboxed_arguments_1:
	movl	(a0),d0
	movl	d0,(a4)
	addl	$8,a4
# ifdef NO_BIT_INSTRUCTIONS
	test	a3,a3
	jne	bsf_and_copy_nodes
# else
	bsf	a3,d1
	jne	copy_nodes
# endif
	jmp	find_non_zero_long	

end_copy:

#ifdef FINALIZERS
	movl	finalizer_list,a0

restore_finalizer_descriptors:
	cmpl	$__Nil-8,a0
	je	end_restore_finalizer_descriptors

	movl	$e____system__kFinalizer+2,(a0)
	movl	4(a0),a0
	jmp	restore_finalizer_descriptors

end_restore_finalizer_descriptors:
#endif
