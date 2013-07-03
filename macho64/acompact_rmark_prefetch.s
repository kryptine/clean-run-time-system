

	.data
rmarkp_n_queue_items_16:
	.quad	0
rmarkp_queue_first:
	.quad	0
rmarkp_queue:
	.quad	0,0,0,0,0,0,0,0
	.quad	0,0,0,0,0,0,0,0
	.quad	0,0,0,0,0,0,0,0
	.quad	0,0,0,0,0,0,0,0

	.text

rmarkp_stack_nodes1:
	mov	rbx,qword ptr [rcx]
	lea	rax,1[rsi]
	mov	qword ptr [rsi],rbx
	mov	qword ptr [rcx],rax

rmarkp_next_stack_node:
	add	rsi,8
rmarkp_stack_nodes:
	cmp	rsi,qword ptr end_vector[rip]
	je	end_rmarkp_nodes

rmarkp_more_stack_nodes:
	mov	rcx,qword ptr [rsi]

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx 

	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_next_stack_node

	mov	rbx,rax 
	and	rax,31*8
	shr	rbx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	mov	ebp,dword ptr [rdi+rbx*4]
	test	rbp,rax 
	att_jne	rmarkp_stack_nodes1

	or	rbp,rax
	mov	dword ptr [rdi+rbx*4],ebp 

	mov	rax,qword ptr [rcx]
	call	rmarkp_stack_node

	add	rsi,8
	cmp	rsi,qword ptr end_vector[rip]
	att_jne	rmarkp_more_stack_nodes
	ret

rmarkp_stack_node:
	sub	rsp,16
	mov	qword ptr [rsi],rax 
	lea	rbp,1[rsi]
	mov	qword ptr 8[rsp],rsi 
	mov	rbx,-1
	mov	qword ptr [rsp],0
	mov	qword ptr [rcx],rbp 
	jmp	rmarkp_no_reverse

rmarkp_node_d1:
	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx 

	cmp	rax,qword ptr heap_size_64_65[rip]
	jnc	rmarkp_next_node

	jmp	rmarkp_node_

rmarkp_hnf_2:
	lea	rbx,8[rcx]
	mov	rax,qword ptr 8[rcx]
	sub	rsp,16

	mov	rsi,rcx 
	mov	rcx,qword ptr [rcx]

	mov	qword ptr 8[rsp],rbx 
	mov	qword ptr [rsp],rax 

	cmp	rsp,qword ptr end_stack[rip]
	att_jb	rmark_using_reversal

rmarkp_node:
	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx 

	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_next_node

	mov	rbx,rsi 

rmarkp_node_:



	mov	rdx,rax 
	and	rax,31*8
	shr	rdx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	test	eax,dword ptr [rdi+rdx*4]
	jne	rmarkp_reverse_and_mark_next_node

	mov	rbp,qword ptr rmarkp_queue_first[rip]
	mov	rdx,qword ptr rmarkp_n_queue_items_16[rip]

	prefetch	[rcx]
	lea	r9,rmarkp_queue[rip]
	mov	qword ptr [r9+rbp],rcx
	mov	qword ptr 8[r9+rbp],rsi
	mov	qword ptr 16[r9+rbp],rbx
	lea	rbx,[rbp+rdx]
	add	rbp,32

	and	rbp,7*32
	and	rbx,7*32

	mov	qword ptr rmarkp_queue_first[rip],rbp

	cmp	rdx,-4*32
	je	rmarkp_last_item_in_queue

rmarkp_add_items:
	mov	rcx,[rsp]
	cmp	rcx,1
	jbe	rmarkp_add_stacked_item

	mov	rsi,8[rsp]
	add	rsp,16

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx
	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_add_items

	mov	rdx,rax
	and	rax,31*8
	shr	rdx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	mov	ebp,dword ptr [rdi+rdx*4]
	test	rbp,rax
	je	rmarkp_add_item

	cmp	rcx,rsi
	att_ja	rmarkp_add_items

	mov	rax,[rcx]
	mov	[rsi],rax
	add	rsi,1
	mov	[rcx],rsi
	att_jmp	rmarkp_add_items

rmarkp_add_stacked_item:
	att_je	rmarkp_last_item_in_queue
rmarkp_add_items2:
	mov	rsi,8[rsp]
	add	rsi,8
	cmp	rsi,qword ptr end_vector[rip]
	att_je	rmarkp_last_item_in_queue

	mov	rcx,[rsi]
	mov	8[rsp],rsi

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx
	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_add_items2

	mov	rdx,rax
	and	rax,31*8
	shr	rdx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	mov	ebp,dword ptr [rdi+rdx*4]
	test	rbp,rax
	je	rmarkp_add_item2

	mov	rax,[rcx]
	mov	[rsi],rax
	add	rsi,1
	mov	[rcx],rsi
	att_jmp	rmarkp_add_items2

rmarkp_add_item2:
	prefetch	[rcx]
	mov	rbp,qword ptr rmarkp_queue_first[rip]
	mov	rdx,qword ptr rmarkp_n_queue_items_16[rip]

	lea	r9,rmarkp_queue[rip]
	mov	qword ptr [r9+rbp],rcx
	mov	qword ptr 8[r9+rbp],rsi
	mov	qword ptr 16[r9+rbp],-1
	add	rbp,32
	and	rbp,7*32

	sub	rdx,32

	mov	qword ptr rmarkp_queue_first[rip],rbp
	mov	qword ptr rmarkp_n_queue_items_16[rip],rdx

	cmp	rdx,-4*32
	att_jne	rmarkp_add_items2
	att_jmp	rmarkp_last_item_in_queue

rmarkp_add_items3:
	mov	rsi,8[rsp]
	add	rsi,8
	cmp	rsi,24[rsp]
	att_je	rmarkp_last_item_in_queue

	mov	rcx,[rsi]
	mov	8[rsp],rsi

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx
	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_add_items3

	mov	rdx,rax
	and	rax,31*8
	shr	rdx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	mov	ebp,[rdi+rdx*4]
	test	rbp,rax
	je	rmarkp_add_item3

	cmp	rcx,rsi
	att_ja	rmarkp_add_items3

	mov	rax,[rcx]
	mov	[rsi],rax
	add	rsi,1
	mov	[rcx],rsi
	att_jmp	rmarkp_add_items3

rmarkp_add_item3:
	prefetch	[rcx]
	mov	rbp,qword ptr rmarkp_queue_first[rip]
	mov	rdx,qword ptr rmarkp_n_queue_items_16[rip]

	lea	r9,rmarkp_queue[rip]
	mov	qword ptr 8[r9+rbp],rsi
	mov	qword ptr 16[r9+rbp],rsi
	add	rbp,32
	and	rbp,7*32

	sub	rdx,32

	mov	qword ptr rmarkp_queue_first[rip],rbp
	mov	qword ptr rmarkp_n_queue_items_16[rip],rdx

	cmp	rdx,-4*32
	att_jne	rmarkp_add_items3
	att_jmp	rmarkp_last_item_in_queue

rmarkp_add_item:
	prefetch	[rcx]
	mov	rbp,qword ptr rmarkp_queue_first[rip]
	mov	rdx,qword ptr rmarkp_n_queue_items_16[rip]

	lea	r9,rmarkp_queue[rip]
	mov	qword ptr [r9+rbp],rcx
	mov	qword ptr 8[r9+rbp],rsi
	mov	qword ptr 16[r9+rbp],rsi
	add	rbp,32
	and	rbp,7*32

	sub	rdx,32

	mov	qword ptr rmarkp_queue_first[rip],rbp
	mov	qword ptr rmarkp_n_queue_items_16[rip],rdx

	cmp	rdx,-4*32
	att_jne	rmarkp_add_items

rmarkp_last_item_in_queue:
	lea	r9,rmarkp_queue[rip]
	mov	rcx,qword ptr [r9+rbx]

	mov	rax,qword ptr neg_heap_p3[rip]

	mov	rsi,qword ptr 8[r9+rbx]
	mov	rbx,qword ptr 16[r9+rbx]

	add	rax,rcx

rmarkp_node_no_prefetch:



	mov	rdx,rax 
	and	rax,31*8
	shr	rdx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	mov	ebp,dword ptr [rdi+rdx*4]
	test	rbp,rax 
	att_jne	rmarkp_reverse_and_mark_next_node
	
	or	rbp,rax 
	mov	dword ptr [rdi+rdx*4],ebp 

	mov	rax,qword ptr [rcx]
rmarkp_arguments:
	cmp	rcx,rbx 
	att_ja	rmarkp_no_reverse

	lea	rbp,1[rsi]
	mov	qword ptr [rsi],rax 
	mov	qword ptr [rcx],rbp 

rmarkp_no_reverse:
	test	al,2
	je	rmarkp_lazy_node

	movzx	rbp,word ptr (-2)[rax]
	test	rbp,rbp 
	je	rmarkp_hnf_0

	add	rcx,8

	cmp	rbp,256
	jae	rmarkp_record

	sub	rbp,2
	att_je	rmarkp_hnf_2
	jc	rmarkp_hnf_1

rmarkp_hnf_3:
	mov	rdx,qword ptr 8[rcx]
rmarkp_hnf_3_:
	cmp	rsp,qword ptr end_stack[rip]
	att_jb	rmark_using_reversal_

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rdx 

	mov	rbx,rax 
	and	rax,31*8
	shr	rbx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	test	eax,[rdi+rbx*4]
	jne	rmarkp_shared_argument_part

	or	dword ptr [rdi+rbx*4],eax 

rmarkp_no_shared_argument_part:
	sub	rsp,16
	mov	qword ptr 8[rsp],rcx 
	lea	rsi,8[rcx]
	mov	rcx,qword ptr [rcx]
	lea	rdx,[rdx+rbp*8]
	mov	qword ptr [rsp],rcx 

rmarkp_push_hnf_args:
	mov	rbx,qword ptr [rdx]
	sub	rsp,16
	mov	qword ptr 8[rsp],rdx 
	sub	rdx,8
	mov	qword ptr [rsp],rbx 

	sub	rbp,1
	att_jg	rmarkp_push_hnf_args

	mov	rcx,qword ptr [rdx]

	cmp	rdx,rsi 
	ja	rmarkp_no_reverse_argument_pointer

	lea	rbp,3[rsi]
	mov	qword ptr [rsi],rcx 
	mov	qword ptr [rdx],rbp 

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx 

	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_next_node

	mov	rbx,rdx 
	att_jmp	rmarkp_node_

rmarkp_no_reverse_argument_pointer:
	mov	rsi,rdx 

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx
	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_next_node
	mov	rbx,rsi
	att_jmp	rmarkp_node_no_prefetch

rmarkp_shared_argument_part:
	cmp	rdx,rcx 
	att_ja	rmarkp_hnf_1

	mov	rbx,qword ptr [rdx]
	lea	rax,(8+2+1)[rcx]
	mov	qword ptr [rdx],rax 
	mov	qword ptr 8[rcx],rbx 
	att_jmp	rmarkp_hnf_1

rmarkp_record:
	sub	rbp,258
	je	rmarkp_record_2
	jb	rmarkp_record_1

rmarkp_record_3:
	movzx	rbp,word ptr (-2+2)[rax]
	mov	rdx,qword ptr (16-8)[rcx]
	sub	rbp,1
	jb	rmarkp_record_3_bb
	je	rmarkp_record_3_ab
	sub	rbp,1
	je	rmarkp_record_3_aab
	att_jmp	rmarkp_hnf_3_

rmarkp_record_3_bb:
	sub	rcx,8

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rdx 

	mov	rbp,rax 
	and	rax,31*8
	shr	rbp,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	or	dword ptr [rdi+rbp*4],eax 
	
	cmp	rdx,rcx 
	att_ja	rmarkp_next_node

	add	eax,eax 
	jne	rmarkp_bit_in_same_word1
	inc	rbp
	mov	rax,1
rmarkp_bit_in_same_word1:
	test	eax,dword ptr [rdi+rbp*4]
	je	rmarkp_not_yet_linked_bb

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx 

	add	rax,16

	mov	rbp,rax 
	and	rax,31*8
	shr	rbp,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	or	dword ptr [rdi+rbp*4],eax 

	mov	rbp,qword ptr [rdx]
	lea	rax,(16+2+1)[rcx]
	mov	qword ptr 16[rcx],rbp 
	mov	qword ptr [rdx],rax 
	att_jmp	rmarkp_next_node

rmarkp_not_yet_linked_bb:
	or	dword ptr [rdi+rbp*4],eax 
	mov	rbp,qword ptr [rdx]
	lea	rax,(16+2+1)[rcx]
	mov	qword ptr 16[rcx],rbp 
	mov	qword ptr [rdx],rax 
	att_jmp	rmarkp_next_node

rmarkp_record_3_ab:
	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rdx 

	mov	rbp,rax 
	and	rax,31*8
	shr	rbp,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	or	dword ptr [rdi+rbp*4],eax 

	cmp	rdx,rcx 
	att_ja	rmarkp_hnf_1

	add	eax,eax 
	jne	rmarkp_bit_in_same_word2
	inc	rbp
	mov	rax,1
rmarkp_bit_in_same_word2:
	test	eax,dword ptr [rdi+rbp*4]
	je	rmarkp_not_yet_linked_ab

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx
	add	rax,8

	mov	rbp,rax 
	and	rax,31*8
	shr	rbp,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	or	dword ptr [rdi+rbp*4],eax 

	mov	rbp,qword ptr [rdx]
	lea	rax,(8+2+1)[rcx]
	mov	qword ptr 8[rcx],rbp 
	mov	qword ptr [rdx],rax 
	att_jmp	rmarkp_hnf_1

rmarkp_not_yet_linked_ab:
	or	dword ptr [rdi+rbp*4],eax 
	mov	rbp,qword ptr [rdx]
	lea	rax,(8+2+1)[rcx]
	mov	qword ptr 8[rcx],rbp 
	mov	qword ptr [rdx],rax 
	att_jmp	rmarkp_hnf_1

rmarkp_record_3_aab:
	cmp	rsp,qword ptr end_stack[rip]
	att_jb	rmark_using_reversal_

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rdx 

	mov	rbp,rax 
	and	rax,31*8
	shr	rbp,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	test	eax,dword ptr [rdi+rbp*4]
	att_jne	rmarkp_shared_argument_part
	or	dword ptr [rdi+rbp*4],eax 

	sub	rsp,16
	mov	qword ptr 8[rsp],rcx 
	lea	rsi,8[rcx]
	mov	rcx,qword ptr [rcx]
	mov	qword ptr [rsp],rcx 

	mov	rcx,qword ptr [rdx]

	cmp	rdx,rsi 
	att_ja	rmarkp_no_reverse_argument_pointer

	lea	rbp,3[rsi]
	mov	qword ptr [rsi],rcx 
	mov	qword ptr [rdx],rbp 

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx 

	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_next_node

	mov	rbx,rdx 
	att_jmp	rmarkp_node_

rmarkp_record_2:
	cmp	word ptr (-2+2)[rax],1
	att_ja	rmarkp_hnf_2
	att_je	rmarkp_hnf_1
	att_jmp	rmarkp_next_node

rmarkp_record_1:
	cmp	word ptr (-2+2)[rax],0
	att_jne	rmarkp_hnf_1
	att_jmp	rmarkp_next_node

rmarkp_lazy_node_1:
/* selectors: */
	jne	rmarkp_selector_node_1

rmarkp_hnf_1:
	mov	rsi,rcx 
	mov	rcx,qword ptr [rcx]
	att_jmp	rmarkp_node

/* selectors */
rmarkp_indirection_node:
	mov	rdx,qword ptr neg_heap_p3[rip]
	sub	rcx,8
	add	rdx,rcx 

	mov	rbp,rdx 
	and	rbp,31*8
	shr	rdx,8
	lea	r9,bit_clear_table2[rip]
	mov	ebp,dword ptr [r9+rbp]
	and	dword ptr [rdi+rdx*4],ebp 

	mov	rdx,rcx
	cmp	rcx,rbx 
	mov	rcx,qword ptr 8[rcx]
	mov	qword ptr [rsi],rcx 
	att_ja	rmarkp_node_d1
	mov	qword ptr [rdx],rax 
	att_jmp	rmarkp_node_d1

rmarkp_selector_node_1:
	add	rbp,3
	att_je	rmarkp_indirection_node

	mov	rdx,qword ptr [rcx]
	mov	qword ptr pointer_compare_address[rip],rbx

	mov	rbx,qword ptr neg_heap_p3[rip]
	add	rbx,rdx 
	shr	rbx,3

	add	rbp,1
	jle	rmarkp_record_selector_node_1

	mov	rbp,rbx 
	shr	rbx,5
	and	rbp,31
	lea	r9,bit_set_table[rip]
	mov	ebp,dword ptr [r9+rbp*4]
	mov	ebx,dword ptr [rdi+rbx*4]
	and	rbx,rbp 
	att_jne	rmarkp_hnf_1

	mov	rbx,qword ptr [rdx]
	test	bl,2
	att_je	rmarkp_hnf_1

	cmp	word ptr (-2)[rbx],2
	jbe	rmarkp_small_tuple_or_record

rmarkp_large_tuple_or_record:
	mov	r10,qword ptr 16[rdx]

	mov	rbx,qword ptr neg_heap_p3[rip]
	add	rbx,r10
	shr	rbx,3

	mov	rbp,rbx 
	shr	rbx,5
	and	rbp,31
	lea	r9,bit_set_table[rip]
	mov	ebp,dword ptr [r9+rbp*4]
	mov	ebx,dword ptr [rdi+rbx*4]
	and	rbx,rbp 
	att_jne	rmarkp_hnf_1

	mov	rbx,qword ptr neg_heap_p3[rip]
	lea	rbx,(-8)[rcx+rbx]

	movsxd	r11,dword ptr(-8)[rax]
	add	rax,r11

	mov	r11,rbx 
	and	r11,31*8
	shr	rbx,8
	lea	r9,bit_clear_table2[rip]
	mov	r11d,dword ptr [r9+r11]
	and	dword ptr [rdi+rbx*4],r11d

	movzx	eax,word ptr (4-8)[rax]
	mov	rbx,qword ptr pointer_compare_address[rip]

	lea	r9,__indirection[rip]
	mov	qword ptr (-8)[rcx],r9

	cmp	rax,16
	jl	rmarkp_tuple_or_record_selector_node_2

	mov	rdx,rcx
	je	rmarkp_tuple_selector_node_2

	mov	rcx,qword ptr (-24)[r10+rax]
	mov	qword ptr [rsi],rcx
	mov	qword ptr [rdx],rcx
	att_jmp	rmarkp_node_d1

rmarkp_tuple_selector_node_2:
	mov	rcx,qword ptr [r10]
	mov	qword ptr [rsi],rcx
	mov	qword ptr [rdx],rcx
	att_jmp	rmarkp_node_d1

rmarkp_record_selector_node_1:
	je	rmarkp_strict_record_selector_node_1

	mov	rbp,rbx
	shr	rbx,5
	and	rbp,31
	lea	r9,bit_set_table[rip]
	mov	ebp,dword ptr [r9+rbp*4]
	mov	ebx,dword ptr [rdi+rbx*4]
	and	rbx,rbp
	att_jne	rmarkp_hnf_1

	mov	rbx,qword ptr [rdx]
	test	bl,2
	att_je	rmarkp_hnf_1

	cmp	word ptr (-2)[rbx],258
	att_jbe	rmarkp_small_tuple_or_record

	mov	r10,qword ptr 16[rdx]

	mov	rbx,qword ptr neg_heap_p3[rip]
	add	rbx,r10
	shr	rbx,3

	mov	rbp,rbx 
	shr	rbx,5
	and	rbp,31
	lea	r9,bit_set_table[rip]
	mov	ebp,dword ptr [r9+rbp*4]
	mov	ebx,dword ptr [rdi+rbx*4]
	and	rbx,rbp 
	att_jne	rmarkp_hnf_1

rmarkp_small_tuple_or_record:
	mov	rbx,qword ptr neg_heap_p3[rip]
	lea	rbx,(-8)[rcx+rbx]

	movsxd	r11,dword ptr(-8)[rax]
	add	rax,r11

	mov	r11,rbx
	and	r11,31*8
	shr	rbx,8
	lea	r9,bit_clear_table2[rip]
	mov	r11d,dword ptr [r9+r11]
	and	dword ptr [rdi+rbx*4],r11d 

	movzx	eax,word ptr (4-8)[rax]
	mov	rbx,qword ptr pointer_compare_address[rip]

	lea	r9,__indirection[rip]
	mov	qword ptr (-8)[rcx],r9

	cmp	rax,16
	att_jle	rmarkp_tuple_or_record_selector_node_2
	mov	rdx,r10
	sub	rax,24
rmarkp_tuple_or_record_selector_node_2:
	mov	rbp,rcx
	mov	rcx,qword ptr [rdx+rax]
	mov	qword ptr [rsi],rcx
	mov	qword ptr [rbp],rcx
	mov	rdx,rbp
	att_jmp	rmarkp_node_d1

rmarkp_strict_record_selector_node_1:
	mov	rbp,rbx 
	shr	rbx,5
	and	rbp,31
	lea	r9,bit_set_table[rip]
	mov	ebp,dword ptr [r9+rbp*4]
	mov	ebx,dword ptr [rdi+rbx*4]
	and	rbx,rbp 
	att_jne	rmarkp_hnf_1

	mov	rbx,qword ptr [rdx]
	test	bl,2
	att_je	rmarkp_hnf_1

	cmp	word ptr (-2)[rbx],258
	jbe	rmarkp_select_from_small_record

	mov	r10,qword ptr 16[rdx]

	mov	rbx,qword ptr neg_heap_p3[rip]
	add	rbx,r10
	mov	rbp,rbx 

	shr	rbx,8
	and	rbp,31*8
	lea	r9,bit_set_table2[rip]
	mov	ebp,dword ptr [r9+rbp]
	mov	ebx,dword ptr [rdi+rbx*4]
	and	rbx,rbp
	att_jne	rmarkp_hnf_1

rmarkp_select_from_small_record:
	movsxd	rbx,dword ptr(-8)[rax]
	add	rbx,rax
	sub	rcx,8

	cmp	rcx,qword ptr pointer_compare_address[rip]
	ja	rmarkp_selector_pointer_not_reversed

	movzx	eax,word ptr (4-8)[rbx]
	cmp	rax,16
	jle	rmarkp_strict_record_selector_node_2
	mov	rax,qword ptr (-24)[r10+rax]
	jmp	rmarkp_strict_record_selector_node_3
rmarkp_strict_record_selector_node_2:
	mov	rax,qword ptr [rdx+rax]
rmarkp_strict_record_selector_node_3:
	mov	qword ptr 8[rcx],rax

	movzx	eax,word ptr (6-8)[rbx]
	test	rax,rax
	je	rmarkp_strict_record_selector_node_5
	cmp	rax,16
	jle	rmarkp_strict_record_selector_node_4
	mov	rdx,r10
	sub	rax,24
rmarkp_strict_record_selector_node_4:
	mov	rax,qword ptr [rdx+rax]
	mov	qword ptr 16[rcx],rax
rmarkp_strict_record_selector_node_5:

	mov	rax,qword ptr ((-8)-8)[rbx]
	add	rsi,1
	mov	qword ptr [rcx],rsi 
	mov	qword ptr (-1)[rsi],rax 
	att_jmp	rmarkp_next_node

rmarkp_selector_pointer_not_reversed:
	movzx	eax,word ptr (4-8)[rbx]
	cmp	rax,16
	jle	rmarkp_strict_record_selector_node_6
	mov	rax,qword ptr (-24)[r10+rax]
	jmp	rmarkp_strict_record_selector_node_7
rmarkp_strict_record_selector_node_6:
	mov	rax,qword ptr [rdx+rax]
rmarkp_strict_record_selector_node_7:
	mov	qword ptr 8[rcx],rax

	movzx	eax,word ptr (6-8)[rbx]
	test	rax,rax
	je	rmarkp_strict_record_selector_node_9
	cmp	rax,16
	jle	rmarkp_strict_record_selector_node_8
	mov	rdx,r10
	sub	rax,24
rmarkp_strict_record_selector_node_8:
	mov	rax,qword ptr [rdx+rax]
	mov	qword ptr 16[rcx],rax
rmarkp_strict_record_selector_node_9:

	mov	rax,qword ptr ((-8)-8)[rbx]
	mov	qword ptr [rcx],rax
	att_jmp	rmarkp_next_node

rmarkp_reverse_and_mark_next_node:
	cmp	rcx,rbx 
	att_ja	rmarkp_next_node

	mov	rax,qword ptr [rcx]
	mov	qword ptr [rsi],rax 
	add	rsi,1
	mov	qword ptr [rcx],rsi 

/* %rbp ,%rbx : free */

rmarkp_next_node:
	mov	rcx,qword ptr [rsp]
	mov	rsi,qword ptr 8[rsp]
	add	rsp,16

	cmp	rcx,1
	att_ja	rmarkp_node

rmarkp_next_node_:
	mov	rdx,qword ptr rmarkp_n_queue_items_16[rip]
	test	rdx,rdx
	att_je	end_rmarkp_nodes

	sub	rsp,16

	mov	rbp,qword ptr rmarkp_queue_first[rip]

	lea	rbx,[rbp+rdx]
	add	rdx,32

	and	rbx,7*32

	mov	qword ptr rmarkp_n_queue_items_16[rip],rdx
	att_jmp	rmarkp_last_item_in_queue

end_rmarkp_nodes:
	ret

rmarkp_lazy_node:
	movsxd	rbp,dword ptr (-4)[rax]
	test	rbp,rbp
	att_je	rmarkp_next_node

	add	rcx,8

	sub	rbp,1
	att_jle	rmarkp_lazy_node_1

	cmp	rbp,255
	jge	rmarkp_closure_with_unboxed_arguments

rmarkp_closure_with_unboxed_arguments_:
	lea	rcx,[rcx+rbp*8]

rmarkp_push_lazy_args:
	mov	rbx,qword ptr [rcx]
	sub	rsp,16
	mov	qword ptr 8[rsp],rcx 
	sub	rcx,8
	mov	qword ptr [rsp],rbx 
	sub	rbp,1
	att_jg	rmarkp_push_lazy_args

	mov	rsi,rcx 
	mov	rcx,qword ptr [rcx]

	cmp	rsp,qword ptr end_stack[rip]
	att_jae	rmarkp_node

	att_jmp	rmark_using_reversal

rmarkp_closure_with_unboxed_arguments:
/* (a_size+b_size)+(b_size<<8) */
/*	addl	$1,%rbp  */
	mov	rax,rbp 
	and	rbp,255
	shr	rax,8
	sub	rbp,rax 
/*	subl	$1,%rbp  */
	att_jg	rmarkp_closure_with_unboxed_arguments_
	att_je	rmarkp_hnf_1
	att_jmp	rmarkp_next_node

rmarkp_hnf_0:
	lea	r9,dINT+2[rip]
	cmp	rax,r9
	je	rmarkp_int_3

	lea	r9,CHAR+2[rip]
	cmp	rax,r9
 	je	rmarkp_char_3

	jb	rmarkp_no_normal_hnf_0

	mov	rbp,qword ptr neg_heap_p3[rip]
	add	rbp,rcx 

	mov	rdx,rbp 
	and	rdx,31*8
	shr	rbp,8
	lea	r9,bit_clear_table2[rip]
	mov	edx,dword ptr [r9+rdx]
	and	dword ptr [rdi+rbp*4],edx 

	lea	rdx,((-8)-2)[rax]
	mov	qword ptr [rsi],rdx 
	cmp	rcx,rbx 
	att_ja	rmarkp_next_node
	mov	qword ptr [rcx],rax 
	att_jmp	rmarkp_next_node

rmarkp_int_3:
	mov	rbp,qword ptr 8[rcx]
	cmp	rbp,33
	att_jnc	rmarkp_next_node

	shl	rbp,4
	lea	rdx,small_integers[rip]
	add	rdx,rbp
	mov	rbp,qword ptr neg_heap_p3[rip]
	mov	qword ptr [rsi],rdx 
	add	rbp,rcx 

	mov	rdx,rbp 
	and	rdx,31*8
	shr	rbp,8
	lea	r9,bit_clear_table2[rip]
	mov	edx,dword ptr [r9+rdx]
	and	dword ptr [rdi+rbp*4],edx 

	cmp	rcx,rbx
	att_ja	rmarkp_next_node
	mov	qword ptr [rcx],rax 
	att_jmp	rmarkp_next_node

rmarkp_char_3:
	movzx	rdx,byte ptr 8[rcx]
	mov	rbp,qword ptr neg_heap_p3[rip]

	shl	rdx,4
	add	rbp,rcx 
	lea	r9,static_characters[rip]
	add	rdx,r9
	mov	qword ptr [rsi],rdx 

	mov	rdx,rbp 
	and	rdx,31*8
	shr	rbp,8
	lea	r9,bit_clear_table2[rip]
	mov	edx,dword ptr [r9+rdx]
	and	dword ptr [rdi+rbp*4],edx

	cmp	rcx,rbx
	att_ja	rmarkp_next_node
	mov	qword ptr [rcx],rax 
	att_jmp	rmarkp_next_node

rmarkp_no_normal_hnf_0:
	lea	r9,__ARRAY__+2[rip]
	cmp	rax,r9
	att_jne	rmarkp_next_node

	mov	rax,qword ptr 16[rcx]
	test	rax,rax 
	je	rmarkp_lazy_array

	movzx	rdx,word ptr (-2+2)[rax]
	test	rdx,rdx
	je	rmarkp_b_array

	movzx	rax,word ptr (-2)[rax]
	test	rax,rax 
	att_je	rmarkp_b_array

	cmp	rsp,qword ptr end_stack[rip]
	att_jb	rmark_array_using_reversal

	sub	rax,256
	cmp	rdx,rax 
	mov	rbx,rdx
	je	rmarkp_a_record_array

rmarkp_ab_record_array:
	mov	rdx,qword ptr 8[rcx]
	add	rcx,16
	push	rcx

	imul	rdx,rax 
	shl	rdx,3

	sub	rax,rbx 
	add	rcx,8
	add	rdx,rcx 
	att_call	reorder
	
	pop	rcx 
	mov	rax,rbx
	imul	rax,qword ptr (-8)[rcx]
	jmp	rmarkp_lr_array

rmarkp_b_array:
	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx
	add	rax,8
	mov	rbp,rax
	and	rax,31*8
	shr	rbp,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	or	dword ptr [rdi+rbp*4],eax

	att_jmp	rmarkp_next_node

rmarkp_a_record_array:
	mov	rax,qword ptr 8[rcx]
	add	rcx,16
	cmp	rbx,2
	att_jb	rmarkp_lr_array

	imul	rax,rbx 
	att_jmp	rmarkp_lr_array

rmarkp_lazy_array:
	cmp	rsp,qword ptr end_stack[rip]
	att_jb	rmark_array_using_reversal

	mov	rax,qword ptr 8[rcx]
	add	rcx,16

rmarkp_lr_array:
	mov	rbx,qword ptr neg_heap_p3[rip]
	add	rbx,rcx 
	shr	rbx,3
	add	rbx,rax 

	mov	rdx,rbx 
	and	rbx,31
	shr	rdx,5
	lea	r9,bit_set_table[rip]
	mov	ebx,dword ptr [r9+rbx*4]
	or	dword ptr [rdi+rdx*4],ebx 

	cmp	rax,1
	jbe	rmarkp_array_length_0_1

	mov	rdx,rcx 
	lea	rcx,[rcx+rax*8]

	mov	rax,qword ptr [rcx]

	mov	rbx,qword ptr [rdx]
	mov	qword ptr [rdx],rax 

	mov	qword ptr [rcx],rbx 

	mov	rax,qword ptr (-8)[rcx]
	sub	rcx,8

	mov	rbx,qword ptr (-8)[rdx]

	sub	rdx,8
	mov	qword ptr [rcx],rbx 

	mov	qword ptr [rdx],rax 

	push	rcx
	mov	rsi,rdx 
	jmp	rmarkp_array_nodes

rmarkp_array_nodes1:
	cmp	rcx,rsi 
	ja	rmarkp_next_array_node

	mov	rbx,qword ptr [rcx]
	lea	rax,1[rsi]
	mov	qword ptr [rsi],rbx 
	mov	qword ptr [rcx],rax 

rmarkp_next_array_node:
	add	rsi,8
	cmp	rsi,qword ptr [rsp]
	je	end_rmarkp_array_node

rmarkp_array_nodes:
	mov	rcx,qword ptr [rsi]

	mov	rax,qword ptr neg_heap_p3[rip]
	add	rax,rcx 

	cmp	rax,qword ptr heap_size_64_65[rip]
	att_jnc	rmarkp_next_array_node

	mov	rbx,rax 
	and	rax,31*8
	shr	rbx,8
	lea	r9,bit_set_table2[rip]
	mov	eax,dword ptr [r9+rax]
	mov	ebp,dword ptr [rdi+rbx*4]
	test	rbp,rax 
	att_jne	rmarkp_array_nodes1
	
	or	rbp,rax 
	mov	dword ptr [rdi+rbx*4],ebp 

	mov	rax,qword ptr [rcx]
	call	rmarkp_array_node

	add	rsi,8
	cmp	rsi,qword ptr [rsp]
	att_jne	rmarkp_array_nodes

end_rmarkp_array_node:
	add	rsp,8
	att_jmp	rmarkp_next_node

rmarkp_array_node:
	sub	rsp,16
	mov	qword ptr 8[rsp],rsi 
	mov	rbx,rsi
	mov	qword ptr [rsp],1
	att_jmp	rmarkp_arguments

rmarkp_array_length_0_1:
	lea	rcx,-16[rcx]
	att_jb	rmarkp_next_node

	mov	rbx,qword ptr 24[rcx]
	mov	rbp,qword ptr 16[rcx]
	mov	qword ptr 24[rcx],rbp
	mov	rbp,qword ptr 8[rcx] 
	mov	qword ptr 16[rcx],rbp
	mov	qword ptr 8[rcx],rbx
	add	rcx,8
	att_jmp	rmarkp_hnf_1
