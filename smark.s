
! record selectors not yet implemented

	ldg	(heap_size_33,d0)

_fill_ones:	btst	3,d0
	beq	_end_fill_ones
	mov	-1,%o1

	stb	%o1,[%o4+d0]
	ba	_fill_ones
	inc	1,d0
_end_fill_ones:

	clr	d4
	ldg	(heap_size_33,d7)

	sethi	%hi 0x80000000,%g3
	
	sub	sp,2000,d3
	sll	d7,5,d7

	ldg	(caf_list,d0)
	
	st	a4,[sp-4]
	
	tst	d0
	be	_end_mark_cafs
	dec	4,sp

_mark_cafs_lp:
	ld	[d0-4],%g5
	add	d0,4,a2
	ld	[d0],d0
	sll	d0,2,d0
	add	a2,d0,a4

	dec	4,sp
	call	_mark_stack_nodes
	st	%o7,[sp]

	addcc	%g5,0,d0
	bne	_mark_cafs_lp
	nop

_end_mark_cafs:
	ldg	(stack_p,a2)

	ld	[sp],a4
	call	_mark_stack_nodes
	st	%o7,[sp]

#ifdef FINALIZERS
	set	finalizer_list,a0
	set	free_finalizer_list,a1

	ld	[a0],a2
determine_free_finalizers_after_mark:
	set	__Nil-8,%o0
	cmp	%o0,a2
	beq	end_finalizers_after_mark
	sub	a2,d6,d1

	srl	d1,2,d1

	srl	d1,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d1,%o3

	btst	%o3,%o1
	beq	finalizer_not_used_after_mark
	nop

	add	a2,4,a0
	ba	determine_free_finalizers_after_mark
	ld	[a2+4],a2

finalizer_not_used_after_mark:
	st	a2,[a1]
	add	a2,4,a1

	ld	[a2+4],a2
	ba	determine_free_finalizers_after_mark
	st	a2,[a0]

end_finalizers_after_mark:
	st	a2,[a1]
#endif

	dec	4,sp
	call	add_garbage_collect_time
	st	%o7,[sp]

	ldg	(heap_size_33,d5)
	inc	3,d5
	srl	d5,2,d5
	
	stg	(d5,bit_counter)
	stg	(%o4,bit_vector_p)

	sll	d4,2,d4

	ldg	(heap_size_33,d0)
	sll	d0,5,d0
	sub	d0,d4,d0

	stg	(d0,last_heap_free)

#ifdef COUNT_GARBAGE_COLLECTIONS
	sethi	%hi n_garbage_collections,%o1
	ld	[%o1+%lo n_garbage_collections],%o2
	inc	1,%o2
#endif
	ldg	(@flags,%o0)
	btst	2,%o0
	beq	_no_heap_use_message2
#ifdef COUNT_GARBAGE_COLLECTIONS
	st	%o2,[%o1+%lo n_garbage_collections]
#else
	nop
#endif

	st	%o4,[sp-4]

	seth	(marked_gc_string_1,%o0)
	call	@ew_print_string
	setl	(marked_gc_string_1,%o0)

	call	@ew_print_int
	mov	d4,%o0

	seth	(heap_use_after_gc_string_2,%o0)
	call	@ew_print_string
	setl	(heap_use_after_gc_string_2,%o0)

	ld	[sp-4],%o4

_no_heap_use_message2:
#ifdef FINALIZERS
	call	call_finalizers
	nop
	ldg	(heap_vector,%o4)
#endif

	ldg	(alloc_size,d2)
	mov	d5,d0
	mov	%o4,a0

	stg	(%g0,free_after_mark)

_scan_bits:
	ld	[a0],%o0	!
	inc	4,a0
	tst	%o0
	beq	_zero_bits
	deccc	d0
	clr	[a0-4]
	bne,a	_scan_bits+4
	ld	[a0],%o0

	b,a	_end_scan

_zero_bits:
	beq	_end_bits
	mov	a0,a1

_skip_zero_bits_lp:
	ld	[a0],d1	!
	inc	4,a0
	tst	d1
	bne	_end_zero_bits
	deccc	d0
	bne,a	_skip_zero_bits_lp+4
	ld	[a0],d1

	ba	_end_bits+4
	sub	a0,a1,d1	

_end_zero_bits:
	clr	[a0-4]	!

	sub	a0,a1,d1
	sll	d1,3,d1

	seth	(free_after_mark,%o0)
	ld	[%o0+%lo free_after_mark],%o1
	cmp	d1,d2
	add	%o1,d1,%o1
	blu	_scan_next
	st	%o1,[%o0+%lo free_after_mark]

_found_free_memory:
	stg	(d0,bit_counter)
	stg	(a0,bit_vector_p)

	sub	d1,d2,d7

	ldg	(heap_vector,%o1)
	sub	a1,4,d0
	sub	d0,%o1,d0
	ldg	(heap_p3,%o1)
	sll	d0,5,d0
	add	d0,%o1,d0
	mov	d0,a6

	sll	d1,2,d1
	add	d0,d1,d0
	stg	(d0,heap_end_after_gc)

	ld	[sp],d0
	ld	[sp+4],d1
	ld	[sp+8],d2
	ld	[sp+12],d3
	ld	[sp+16],d4
	ld	[sp+20],d5
	ld	[sp+24],d6

	ld	[sp+28],%o7
	retl
	inc	32,sp

_scan_next:
	tst	d0
	bne,a	_scan_bits+4
	ld	[a0],%o0

	b,a	_end_scan

_end_bits:
	sub	a0,a1,d1	!
	inc	4,d1
	sll	d1,3,d1

	seth	(free_after_mark,%o0)
	ld	[%o0+%lo free_after_mark],%o1
	cmp	d1,d2
	add	%o1,d1,%o1
	bgeu	_found_free_memory
	st	%o1,[%o0+%lo free_after_mark]

_end_scan:
	stg	(d0,bit_counter)
	b,a	compact_gc



_mark_record:
	deccc	258,d2
	be,a	_mark_record_2
	lduh	[d0-2+2],%g1

	blu,a	_mark_record_1
	lduh	[d0-2+2],%g1

_mark_record_3:
	cmp	%o3,4
	bgeu	fits_in_word_13
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_13:
	st	%o1,[%o4+%o0]

	lduh	[d0-2+2],d1
	deccc	1,d1
	blu	_mark_record_3_bb
	inc	3,d4

	ld	[a0+4],a1

	sub	a1,d6,d0
	srl	d0,2,d0

	srl	d0,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d0,%o3

	btst	%o3,%o1
	bne,a	_mark_node
	ld	[a0],a0

	inc	1,d2
	add	d4,d2,d4

	and	d0,31,%o2
	add	%o2,d2,%o2

	cmp	%o2,32
	bset	%o3,%o1
	bleu	_push_record_arguments
	st	%o1,[%o4+%o0]

	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
	st	%o1,[%o4+%o0]

_push_record_arguments:
	subcc	d1,1,d2

	sll	d1,2,d1
	bgeu	_push_hnf_args
	add	a1,d1,a1

	ba	_mark_node
	ld	[a0],a0

_mark_record_3_bb:
	ld	[a0+4],a1
	
	sub	a1,d6,d0
	srl	d0,2,d0

	srl	d0,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d0,%o3

	btst	%o3,%o1
	bne	_mark_next_node
	inc	1,d2

	add	d4,d2,d4

	and	d0,31,%o2
	add	%o2,d2,%o2

	cmp	%o2,32
	bset	%o3,%o1
	bleu	_mark_next_node
	st	%o1,[%o4+%o0]

	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
	ba	_mark_next_node
	st	%o1,[%o4+%o0]

_mark_record_2:
	cmp	%o3,4
	bgeu	fits_in_word_12
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_12:
	st	%o1,[%o4+%o0]
	inc	3,d4

	cmp	%g1,1
	bgu	_mark_record_2_c
	nop

	be,a	_mark_node
	ld	[a0],a0

	ba	_mark_next_node
	dec	4,a0

_mark_record_1:
	tst	%g1
	bne	_mark_hnf_1
	nop
	b,a	_mark_bool_or_small_string


_mark_stack_nodes:
	cmp	a2,a4
	be	_end_mark_nodes
	inc	4,a2

	ld	[a2-4],a0

	sub	a0,d6,d1
#ifdef SHARE_CHAR_INT
	cmp	d1,d7
	bcc	_mark_stack_nodes
#endif
	srl	d1,2,d1

	srl	d1,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d1,%o3

	btst	%o3,%o1
	bne	_mark_stack_nodes
	nop

	clr	[sp-4]
	dec	4,sp

_mark_arguments:
	ld	[a0],d0
	btst	2,d0
	be	_mark_lazy_node
	nop

	ldsh	[d0-2],d2
	tst	d2
	be	_mark_hnf_0
	cmp	d2,256
	bgeu	_mark_record
	inc	4,a0

	deccc	2,d2
	be	_mark_hnf_2
	nop
	bcs	_mark_hnf_1
	nop

_mark_hnf_3:
	cmp	%o3,4
	bgeu	fits_in_word_1
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_1:
	st	%o1,[%o4+%o0]

	ld	[a0+4],a1
	
	sub	a1,d6,d0
	srl	d0,2,d0

	srl	d0,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d0,%o3

	btst	%o3,%o1
	bne	_shared_argument_part
	inc	3,d4

_no_shared_argument_part:
	sll	d2,2,%o2
	add	a1,%o2,a1

	inc	1,d2
	add	d4,d2,d4

	and	d0,31,%o2
	add	%o2,d2,%o2
	cmp	%o2,32
	bleu	fits_in_word_2
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_2:
	st	%o1,[%o4+%o0]

	ld	[a1],%o0
	dec	2,d2
	st	%o0,[sp-4]
	dec	4,sp

_push_hnf_args:
	ld	[a1-4],%o0
	dec	4,a1
	st	%o0,[sp-4]
	deccc	d2
	bcc	_push_hnf_args
	dec	4,sp

	cmp	sp,d3
	bgeu,a	_mark_node
	ld	[a0],a0
	
	b,a	__mark_using_reversal

_mark_lazy_node_1:
	cmp	%o3,4
	bgeu	fits_in_word_3
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_3:
	st	%o1,[%o4+%o0]

	tst	d2
	bne	_mark_selector_node_1
	inc	3,d4

	ba	_mark_node
	ld	[a0],a0

_mark_hnf_1:
	cmp	%o3,2
	bgeu	fits_in_word_4
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_4:
	st	%o1,[%o4+%o0]
	inc	2,d4

_shared_argument_part:
	ba	_mark_node
	ld	[a0],a0

! selectors
_mark_indirection_node:
	ba	_mark_node
	mov	a1,a0

_mark_selector_node_1:
	cmp	d2,-2
	bne	_mark_indirection_node
	ld	[a0],a1

	sub	a1,d6,d1
	srl	d1,2,d1

	srl	d1,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d1,%o3

	btst	%o3,%o1
	bne,a	_mark_node
	mov	a1,a0

	ld	[a1],d2
	btst	2,d2
	be,a	_mark_node
	mov	a1,a0

	ldsh	[d2-2],%g1
	cmp	%g1,2
	bleu	_small_tuple
	nop
	
	ld	[a1+8],d1
	sub	d1,d6,d1
	srl	d1,2,d1

	srl	d1,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%g1
	srl	%g3,d1,%o3

	btst	%o3,%g1
	bne,a	_mark_node
	mov	a1,a0

_small_tuple:
	sub	a0,4,d2

	ld	[d0-8],%g1
	mov	a1,a0
	ld	[%g1+4],%g1

	dec	4,sp
	call	%g1
	st	%o7,[sp]

	set	__indirection,%g1
	st	%g1,[d2]
	ba	_mark_node
	st	a0,[d2+4]

_mark_hnf_2:
	cmp	%o3,4
	bgeu	fits_in_word_6
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_6:
	st	%o1,[%o4+%o0]
	inc	3,d4

_mark_record_2_c:
	ld	[a0+4],%o0
	dec	4,sp
	cmp	sp,d3
	blu	__mark_using_reversal
	st	%o0,[sp]
	
	ld	[a0],a0

_mark_node:
	sub	a0,d6,d1
#ifdef SHARE_CHAR_INT
	cmp	d1,d7
	bcc	_mark_next_node
#endif
	srl	d1,2,d1

	srl	d1,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d1,%o3

	btst	%o3,%o1
	be	_mark_arguments
	nop

_mark_next_node:
	ld	[sp],a0
	inc	4,sp
	tst	a0
	bne	_mark_node
	nop
	b,a	_mark_stack_nodes

_mark_lazy_node:
	ldsh	[d0-2],d2
	tst	d2
	be	_mark_real_or_file
	add	d0,-2,a1

	deccc	d2
	ble,a	_mark_lazy_node_1
	inc	4,a0

	inc	2,d2
	add	d4,d2,d4

	and	d1,31,%o2
	add	%o2,d2,%o2
	cmp	%o2,32
	bleu	fits_in_word_7
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_7:
	st	%o1,[%o4+%o0]

	sll	d2,2,%g2
	add	a0,%g2,a0

	dec	3,d2
_push_lazy_args:
	ld	[a0-4],%o0
	dec	4,a0
	st	%o0,[sp-4]
	deccc	d2
	bcc	_push_lazy_args
	dec	4,sp

	cmp	sp,d3
	bgeu,a	_mark_node
	ld	[a0-4],a0
	
	ba	__mark_using_reversal
	dec	4,a0

_mark_hnf_0:
	set	INT+2,%g1
	cmp	d0,%g1
	blu	_mark_real_file_or_string
	nop

	set	CHAR+2,%g1
	cmp	d0,%g1
	bgu	_mark_normal_hnf_0
	nop

_mark_bool_or_small_string:
	cmp	%o3,2
	bgeu	fits_in_word_8
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_8:
	st	%o1,[%o4+%o0]
	ba	_mark_next_node
	inc	2,d4

_mark_normal_hnf_0:
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	ba	_mark_next_node
	inc	1,d4

_mark_real_file_or_string:
	set	__ARRAY__+2,%g1
	cmp	d0,%g1
	bne	_no_mark_array
	nop

	ld	[a0+8],d0
	tst	d0
	be	_mark_lazy_array
	nop

	lduh	[d0-2+2],d1
	tst	d1
	be	_mark_b_record_array
	nop

	lduh	[d0-2],d0
	dec	256,d0
	cmp	d0,d1
	be	_mark_a_record_array
	nop

_mark_ab_record_array:
	mov	d2,%o2
	mov	d3,%o3
	mov	d4,%g2
	mov	d5,%o5
	mov	d6,%g3

	ld	[a0+4],d2
	inc	8,a0
	mov	a0,%g4

	sll	d2,2,d2
	sub	d0,2,d3
	mov	d2,a1
_mul_array_length_ab1:
	deccc	1,d3
	bcc	_mul_array_length_ab1
	add	a1,d2,a1

	sub	d0,d1,d0
	inc	4,a0
	call	reorder
	add	a1,a0,a1

	mov	%g4,a0
	ld	[a0-4],d2
	deccc	2,d1
	bcs	_skip_mul_array_length_a1_
	mov	d2,d0
_mul_array_length_a1_:
	deccc	1,d1
	bcc	_mul_array_length_a1_
	add	d0,d2,d0
_skip_mul_array_length_a1_:
	
	mov	%g3,d6
	mov	%o5,d5
	mov	%g2,d4
	mov	%o3,d3
	ba	_mark_lr_array
	mov	%o2,d2

_mark_b_record_array:
	sub	a0,d6,d0
	srl	d0,2,d0
	inc	1,d0
	setmbit	(%o4,d0,d1,%o0,%o1,%o2)
	b,a	_mark_next_node

_mark_a_record_array:
	ld	[a0+4],d0
	deccc	2,d1
	blu	_mark_lr_array
	inc	8,a0

	mov	d0,d2
_mul_array_length:
	deccc	1,d1
	bcc	_mul_array_length
	add	d0,d2,d0

	b,a	_mark_lr_array

_mark_lazy_array:
	ld	[a0+4],d0
	inc	8,a0
_mark_lr_array:
	sub	a0,d6,d1
	srl	d1,2,d1
	add	d1,d0,d1
	setmbit	(%o4,d1,d2,%o0,%o1,%o2)

	cmp	d0,1
	bleu	_mark_array_length_0_1
	nop

	mov	a0,a1
	sll	d0,2,d0
	add	a0,d0,a0

	ld	[a0],d2
	ld	[a1],%o0
	st	d2,[a1]
	st	%o0,[a0]
	
	ld	[a0-4],d2
	dec	4,a0
	inc	2,d2
	ld	[a1-4],%o0
	dec	4,a1
	st	%o0,[a0]
	st	d2,[a1]

	ld	[a0-4],d2
	dec	4,a0
	or	d3,d5,d3
	st	d3,[a0]
	mov	a0,d3
	mov	0,d5
	ba	_mark_node
	mov	d2,a0

_mark_array_length_0_1:
	blu	_mark_next_node
	nop
	
	ld	[a0+4],d1
	ld	[a0],%o0
	ld	[a0-4],%o1
	st	%o0,[a0+4]
	st	%o1,[a0]
	st	d1,[a0-4]
	ba	_mark_hnf_1
	dec	4,a0

_no_mark_array:
	set	STRING+2,%g1
	cmp	%g1,%l0
	beq	_mark_string
	nop

_mark_real_or_file:
	cmp	%o3,4
	bgeu	fits_in_word_9
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits_in_word_9:
	st	%o1,[%o4+%o0]
	ba	_mark_next_node
	inc	3,d4

_mark_string:
	sethi	%hi 0xc0000000,%o3
	srl	%o3,d1,%g1

	cmp	%g1,3
	bgeu	fits_in_word_10
	bset	%g1,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	neg	d1
	ld	[%o4+%o0],%o1
	sll	%o3,d1,%o3
	
	bset	%o3,%o1
fits_in_word_10:
	st	%o1,[%o4+%o0]
	inc	2,d4

	ld	[a0+4],a1

	sub	a1,d6,d0
	cmp	d0,d7
	bcc	_mark_next_node
	srl	d0,2,d0

	ld	[a1+4],d1
	inc	7,d1
	srl	d1,2,d1

	cmp	d1,32
	bcc	_mark_large_string	
	add	d4,d1,d4

	srl	d0,3,%o0
	andn	%o0,3,%o0
	mov	-1,%o3
	ld	[%o4+%o0],%o1
	srl	%o3,d1,%o3
	not	%o3

	srl	%o3,d0,%g1

	and	d0,31,%o2
	add	%o2,d1,%o2
	cmp	%o2,32
	bleu	fits_in_word_11
	bset	%g1,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	neg	d0
	ld	[%o4+%o0],%o1
	sll	%o3,d0,%o3
	
	bset	%o3,%o1
fits_in_word_11:
	ba	_mark_next_node
	st	%o1,[%o4+%o0]

_mark_large_string:
	b,a	_mark_large_string

_end_mark_nodes:
	ld	[sp],%o7
	retl
	inc	4,sp

__mark__record:
	deccc	258,d2
	be,a	__mark__record__2
	lduh	[d0-2+2],%g1

	blu,a	__mark__record__1
	lduh	[d0-2+2],%g1

__mark__record__3:
	lduh	[d0-2+2],d2
	deccc	1,d2
	blu,a	__mark__record__3__bb
	dec	4,a0

	be	__mark__record__3__ab
	nop

	deccc	1,d2
	be	__mark__record__3__aab
	nop

	b,a	__mark__hnf__3

__mark__record__3__bb:
	ld	[a0+8],a1

	sub	a1,d6,d0
	srl	d0,2,d0
	setmbit	(%o4,d0,d1,%o0,%o1,%o2)

	cmp	a1,a0
	bgu	__mark__next__node
	nop

	cmp	%o0,1
	bne	__not__next__byte__1
	srl	%o0,1,%o0

	inc	1,d1
	ldub	[%o4+d1],%o1
	mov	128,%o0
__not__next__byte__1:
	btst	%o0,%o1
	be	__not__yet__linked__bb
	bset	%o0,%o1
	
	sub	a0,d6,d0
	srl	d0,2,d0
	inc	2,d0
	setmbit	(%o4,d0,d1,%o0,%o1,%o2)

	ld	[a1],%o0
	add	a0,8+2+1,d0
	st	%o0,[a0+8]
	ba	__mark__next__node
	st	d0,[a1]	
	
__not__yet__linked__bb:
	stb	%o1,[%o4+d1]
	ld	[a1],%o0
	add	a0,8+2+1,d0
	st	%o0,[a0+8]
	ba	__mark__next__node
	st	d0,[a1]	

__mark__record__3__ab:
	ld	[a0+4],a1

	sub	a1,d6,d0
	srl	d0,2,d0
	setmbit	(%o4,d0,d1,%o0,%o1,%o2)

	cmp	a1,a0
	bgu	__mark__hnf__1
	nop

	cmp	%o0,1
	bne	__not__next__byte__2
	srl	%o0,1,%o0

	inc	1,d1
	ldub	[%o4+d1],%o1
	mov	128,%o0
__not__next__byte__2:
	btst	%o0,%o1
	be	__not__yet__linked__ab
	bset	%o0,%o1

	sub	a0,d6,d0
	srl	d0,2,d0
	inc	1,d0
	setmbit	(%o4,d0,d1,%o0,%o1,%o2)

	ld	[a1],%o0
	add	a0,4+2+1,d0
	st	%o0,[a0+4]
	ba	__mark__hnf__1
	st	d0,[a1]
	
__not__yet__linked__ab: 
	stb	%o1,[%o4+d1]
	ld	[a1],%o0
	add	a0,4+2+1,d0
	st	%o0,[a0+4]
	ba	__mark__hnf__1
	st	d0,[a1]

__mark__record__3__aab:
	ld	[a0+4],a1

	sub	a1,d6,d0
	srl	d0,2,d0

	tstmbit	(%o4,d0,d1,%o0,%o1,%o2)
	bne	__shared__argument__part
	bset	%o0,%o1

	stb	%o1,[%o4+d1]

	ld	[a0],%o0
	inc	4,a0
	or	%o0,2,%o0
	st	%o0,[a0-4]
	or	d3,d5,d3
	st	d3,[a0]
	
	ld	[a1],d2
	st	a0,[a1]
	mov	a1,d3
	mov	1,d5
	ba	__mark__node
	mov	d2,a0

__mark__record__2:
	cmp	%g1,1
	bgu	__mark__hnf__2
	nop
	be	__mark__hnf__1
	nop
	ba	__mark__next__node
	dec	4,a0

__mark__record__1:
	tst	%g1
	bne	__mark__hnf__1
	nop
	ba	__mark__next__node
	dec	4,a0

__end_mark_using_reversal:
	ld	[sp],d3
	ba	_mark_next_node
	inc	8,sp

__end_mark_using_reversal_after_static:
	ld	[sp+4],a1
	ld	[sp],d3
	st	a0,[a1]
	ba	_mark_next_node
	inc	8,sp

__mark_using_reversal:
	st	a0,[sp-4]
	st	d3,[sp-8]

	mov	0,d3
	mov	1,d5
	ld	[a0],a0
	ba	__mark__node
	dec	8,sp

__mark__arguments:
	ld	[a0],d0
	btst	2,d0
	be	__mark__lazy__node
	nop

	ldsh	[d0-2],d2
	tst	d2
	be	__mark__hnf__0
	cmp	d2,256
	bgeu	__mark__record
	inc	4,a0

	deccc	2,d2
	be	__mark__hnf__2
	nop
	bcs	__mark__hnf__1
	nop

__mark__hnf__3:
	cmp	%o3,4
	bgeu	fits__in__word__1
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__1:
	st	%o1,[%o4+%o0]

	ld	[a0+4],a1
	
	sub	a1,d6,d0
	srl	d0,2,d0

	srl	d0,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d0,%o3

	btst	%o3,%o1
	bne	__shared__argument__part
	inc	3,d4

__no__shared__argument__part:
#if XXX
	ld	[%i0],%g1
#endif
	bset	d5,d3
#if XXX
	bset	2,%g1
	st	%g1,[%i0]
#endif
	st	d3,[%i0+4]
	inc	4,%i0

	ld	[a1],%g1
	sll	d2,2,d2
	bset	1,%g1
	st	%g1,[a1]
	add	a1,d2,a1

	srl	d2,2,d2
	inc	1,d2
	add	d4,d2,d4

	and	d0,31,%o2
	add	%o2,d2,%o2
	cmp	%o2,32
	bleu	fits__in__word__2
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__2:
	st	%o1,[%o4+%o0]

	ld	[a1],d2
	st	a0,[a1]
	mov	a1,d3
	clr	d5
	ba	__mark__node
	mov	d2,a0

__mark__lazy__node__1:
! selectors:
	bne	__mark__selector__node__1
	nop

	cmp	%o3,4
	bgeu	fits__in__word__3
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__3:
	st	%o1,[%o4+%o0]
	ba	__shared__argument__part
	inc	3,d4

__mark__hnf__1:
	cmp	%o3,2
	bgeu	fits__in__word__4
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__4:
	st	%o1,[%o4+%o0]
	inc	2,d4

__shared__argument__part:
	ld	[%i0],%l2
	bset	%l5,%l3
	st	%l3,[%i0]
	mov	%i0,%l3
	mov	2,%l5
	ba	__mark__node
	mov	%l2,%i0

! selectors
__mark__indirection__node:
	ba	__mark__node
	mov	a1,a0

__mark__selector__1:
	cmp	%o3,4
	bgeu	fits__in__word__5
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__5:
	st	%o1,[%o4+%o0]
	ba	__shared__argument__part
	inc	3,d4

__mark__selector__node__1:
	cmp	d2,-2
	bne	__mark__indirection__node
	ld	[a0],a1

	sub	a1,d6,%o2
	srl	%o2,2,%o2

	srl	%o2,3,d2
	andn	d2,3,d2
	ld	[%o4+d2],%g1
	srl	%g3,%o2,%g2

	btst	%g2,%g1
	bne	__mark__selector__1
	nop

	ld	[a1],d2
	btst	2,d2
	be	__mark__selector__1
	nop

	ldsh	[d2-2],%g1
	cmp	%g1,2
	bleu	__small__tuple
	nop
	
	ld	[a1+8],%o2
	sub	%o2,d6,%o2
	srl	%o2,2,%o2

	srl	%o2,3,d2
	andn	d2,3,d2
	ld	[%o4+d2],%g1
	srl	%g3,%o2,%g2

	btst	%g2,%g1
	bne	__mark__selector__1
	nop

__small__tuple:
	sub	a0,4,d2

	ld	[d0-8],%g1
	mov	a1,a0
	ld	[%g1+4],%g1

	dec	4,sp
	call	%g1
	st	%o7,[sp]

	set	__indirection,%g1
	st	%g1,[d2]
	ba	__mark__node
	st	a0,[d2+4]

__mark__hnf__2:
	cmp	%o3,4
	bgeu	fits__in__word__6
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__6:
	st	%o1,[%o4+%o0]
	inc	3,d4

	ld	[%i0],%o0
	bset	2,%o0
	st	%o0,[%i0]
	inc	4,%i0
	ld	[%i0],%l2
	bset	%l5,%l3
	st	%l3,[%i0]
	mov	%i0,%l3
	clr	%l5
	mov	%l2,%i0

__mark__node:
	sub	a0,d6,d1
#ifdef SHARE_CHAR_INT
	cmp	d1,d7
	bcc	__mark__next__node__after__static
#endif
	srl	d1,2,d1

	srl	d1,3,%o0
	andn	%o0,3,%o0
	ld	[%o4+%o0],%o1
	srl	%g3,d1,%o3

	btst	%o3,%o1
	be	__mark__arguments
	nop

__mark__next__node:
	tst	d5
	bne	__mark__parent
	nop
__mark__next__node2:
	dec	4,%l3
	ld	[%l3],%l2
	ld	[%l3+4],%o0
	and	%l2,3,%l5

	st	%o0,[%l3]

	st	%i0,[%l3+4]
	ba	__mark__node
	andn	%l2,3,%i0

__mark__lazy__node:
	ldsh	[d0-2],d2
	tst	d2
	be	__mark__real__or__file
	add	d0,-2,a1

	deccc	d2
	ble	__mark__lazy__node__1
	inc	4,a0

	inc	2,d2
	add	d4,d2,d4

	and	d1,31,%o2
	add	%o2,d2,%o2
	cmp	%o2,32
	bleu	fits__in__word__7
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__7:
	st	%o1,[%o4+%o0]
	
	dec	2,d2

	ld	[%i0],%o0
	sll	d2,2,d2
	bset	2,%o0
	st	%o0,[%i0]
	add	%i0,d2,%i0

	ld	[%i0],%l2
	bset	%l5,%l3
	st	%l3,[%i0]
	mov	%i0,%l3
	clr	%l5
	ba	__mark__node
	mov	%l2,%i0	

__mark__hnf__0:
	set	INT+2,%g1
	cmp	d0,%g1
	bne	__no__int__3
	nop

	ld	[a0+4],d2
	cmp	d2,33
	bcs	____small____int
	sll	d2,3,d2

__mark__bool__or__small__string:
	cmp	%o3,2
	bgeu	fits__in__word__8
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__8:
	st	%o1,[%o4+%o0]
	ba	__mark__next__node
	inc	2,d4

____small____int:
	set	small_integers,a0
	ba	__mark__next__node__after__static
	add	a0,d2,a0

__no__int__3:
	blu	__mark__real__file__or__string	
	seth	((CHAR+2),%g1)

	setl	((CHAR+2),%g1)
 	cmp	d0,%g1
 	bne	__no__char__3
	nop

	ldub	[a0+7],d2
	set	static_characters,a0
	sll	d2,3,d2
	ba	__mark__next__node__after__static
	add	a0,d2,a0

__no__char__3:
	blu	__mark__bool__or__small__string
	nop

	ba	__mark__next__node__after__static
	sub	d0,12+2,a0
	
__mark__real__file__or__string:
	set	__ARRAY__+2,%g1
	cmp	d0,%g1
	bne	__no__mark__array
	nop

	ld	[a0+8],d0
	tst	d0
	be	__mark__lazy__array
	nop

	lduh	[d0-2+2],d1
	tst	d1
	be	__mark__b__record__array
	nop

	lduh	[d0-2],d0
	dec	256,d0
	cmp	d0,d1
	be	__mark__a__record__array
	nop

__mark__ab__record__array:
	mov	d2,%o2
	mov	d3,%o3
	mov	d4,%g2
	mov	d5,%o5
	mov	d6,%g3

	ld	[a0+4],d2
	inc	8,a0
	mov	a0,%g4

	sll	d2,2,d2
	sub	d0,2,d3
	mov	d2,a1
__mul__array__length__ab1:
	deccc	1,d3
	bcc	__mul__array__length__ab1
	add	a1,d2,a1

	sub	d0,d1,d0
	inc	4,a0
	call	reorder
	add	a1,a0,a1

	mov	%g4,a0
	ld	[a0-4],d2
	deccc	2,d1
	bcs	__skip_mul_array_length_a1_
	mov	d2,d0
__mul_array_length_a1_:
	deccc	1,d1
	bcc	__mul_array_length_a1_
	add	d0,d2,d0
__skip_mul_array_length_a1_:
	
	mov	%g3,d6
	mov	%o5,d5
	mov	%g2,d4
	mov	%o3,d3
	ba	__mark__lr__array
	mov	%o2,d2

__mark__b__record__array:
	sub	a0,d6,d0
	srl	d0,2,d0
	inc	1,d0
	setmbit	(%o4,d0,d1,%o0,%o1,%o2)
	b,a	__mark__next__node

__mark__a__record__array:
	ld	[a0+4],d0
	deccc	2,d1
	blu	__mark__lr__array
	inc	8,a0

	mov	d0,d2
__mul__array__length:
	deccc	1,d1
	bcc	__mul__array__length
	add	d0,d2,d0

	b,a	__mark__lr__array

__mark__lazy__array:
	ld	[a0+4],d0
	inc	8,a0
__mark__lr__array:
	sub	a0,d6,d1
	srl	d1,2,d1
	add	d1,d0,d1
	setmbit	(%o4,d1,d2,%o0,%o1,%o2)

	cmp	d0,1
	bleu	__mark__array__length__0__1
	nop

	mov	a0,a1
	sll	d0,2,d0
	add	a0,d0,a0

	ld	[a0],d2
	ld	[a1],%o0
	st	d2,[a1]
	st	%o0,[a0]
	
	ld	[a0-4],d2
	dec	4,a0
	inc	2,d2
	ld	[a1-4],%o0
	dec	4,a1
	st	%o0,[a0]
	st	d2,[a1]

	ld	[a0-4],d2
	dec	4,a0
	or	d3,d5,d3
	st	d3,[a0]
	mov	a0,d3
	mov	0,d5
	ba	__mark__node
	mov	d2,a0

__mark__array__length__0__1:
	blu	__mark__next__node
	nop
	
	ld	[a0+4],d1
	ld	[a0],%o0
	ld	[a0-4],%o1
	st	%o0,[a0+4]
	st	%o1,[a0]
	st	d1,[a0-4]
	ba	__mark__hnf__1
	dec	4,a0

__no__mark__array:
	set	STRING+2,%g1
	cmp	%g1,%l0
	beq	__mark__string
	nop

__mark__real__or__file:
	cmp	%o3,4
	bgeu	fits__in__word__9
	bset	%o3,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	neg	d1
	ld	[%o4+%o0],%o1
	bset	%g3,%o1
fits__in__word__9:
	st	%o1,[%o4+%o0]
	ba	__mark__next__node
	inc	3,d4

__mark__string:
	sethi	%hi 0xc0000000,%o3
	srl	%o3,d1,%g1

	cmp	%g1,3
	bgeu	fits__in__word__10
	bset	%g1,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	neg	d1
	ld	[%o4+%o0],%o1
	sll	%o3,d1,%o3
	
	bset	%o3,%o1
fits__in__word__10:
	st	%o1,[%o4+%o0]
	inc	2,d4

	ld	[a0+4],a1

	sub	a1,d6,d0
	cmp	d0,d7
	bcc	__mark__next__node
	srl	d0,2,d0

	ld	[a1+4],d1
	inc	7,d1
	srl	d1,2,d1

	cmp	d1,32
	bcc	__mark__large__string	
	add	d4,d1,d4

	srl	d0,3,%o0
	andn	%o0,3,%o0
	mov	-1,%o3
	ld	[%o4+%o0],%o1
	srl	%o3,d1,%o3
	not	%o3

	srl	%o3,d0,%g1

	and	d0,31,%o2
	add	%o2,d1,%o2
	cmp	%o2,32
	bleu	fits__in__word__11
	bset	%g1,%o1

	st	%o1,[%o4+%o0]
	inc	4,%o0

	neg	d0
	ld	[%o4+%o0],%o1
	sll	%o3,d0,%o3
	
	bset	%o3,%o1
fits__in__word__11:
	ba	__mark__next__node
	st	%o1,[%o4+%o0]

__mark__large__string:
	b,a	__mark__large__string

__mark__parent:
	tst	d3
	be	__end_mark_using_reversal

	deccc	d5
	be	__argument__part__parent
	ld	[d3],d2
	
	st	%i0,[%l3]
	sub	%l3,4,%i0
	and	%l2,3,%l5
	ba	__mark__next__node
	andn	%l2,3,%l3
	
__argument__part__parent:
	mov	d3,a1
	st	a0,[a1]

	andn	d2,3,d3
	dec	4,d3

	ld	[d3],a0
	ld	[d3+4],%o0
	mov	2,d5
	st	%o0,[d3]

	ba	__mark__node
	st	a1,[d3+4]

__mark__next__node__after__static:
	tst	d5
	beq	__mark__next__node2

	tst	d3
	be	__end_mark_using_reversal_after_static

	deccc	d5
	be	__argument__part__parent
	ld	[d3],d2

	st	%i0,[%l3]
	sub	%l3,4,%i0
	and	%l2,3,%l5
	ba	__mark__next__node
	andn	%l2,3,%l3
