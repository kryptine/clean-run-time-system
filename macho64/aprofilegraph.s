	.text

	.globl	profile_t
	.globl	profile_r
	.globl	profile_l
	.globl	profile_l2
	.globl	profile_n
	.globl	profile_n2
	.globl	profile_s
	.globl	profile_s2
	.globl	write_profile_stack
	.globl	write_profile_information
	.globl	init_profiler
	.globl	_get_time_stamp_counter
	.globl	_measure_profile_overhead

	.extern	_profile_data_stack_ptr:near
	.extern	_profile_last_tail_call:near
	.extern	_ab_stack_size:near

ticks	= 8
allocated_words	= 16
tail_and_return_calls = 24

profile_t:
	push	rax
	push	rdx

	rdtsc
	shl	rdx,32
	add	rdx,rax
	sub	rdx,qword ptr [rip+tick_count]

	mov	rax,qword ptr [rip+_profile_data_stack_ptr]
	mov	rax,[rax]
	mov	qword ptr [rip+_profile_last_tail_call],rax

	jmp	profile_r_

profile_r:
	push	rax
	push	rdx

	rdtsc
	shl	rdx,32
	add	rdx,rax
	sub	rdx,qword ptr [rip+tick_count]

	mov	rax,qword ptr [rip+_profile_data_stack_ptr]
	mov	rax,[rax]
	mov	qword ptr [rip+_profile_last_tail_call],0
profile_r_:
	add	qword ptr ticks[rax],rdx

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15
	add	qword ptr allocated_words[rax],rdx

	inc	dword ptr tail_and_return_calls[rax]

	sub	qword ptr [rip+_profile_data_stack_ptr],8
	mov	rdx,qword ptr [rip+_profile_data_stack_ptr]
	mov	rdx,[rdx]
	mov	qword ptr [rip+_profile_current_cost_centre],rdx

	rdtsc
	shl	rdx,32
	add	rdx,rax
	mov	qword ptr [rip+tick_count],rdx

	pop	rdx
	pop	rax
	ret

profile_l:
	push	rax
	push	rdx
	push	rcx
	rdtsc
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	rbp

	mov	rdi,rbp

	mov	rsi,rdx
	shl	rsi,32
	add	rsi,rax
	sub	rsi,qword ptr [rip+tick_count]

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_profile_l
	jmp	end_profile_call

profile_l2:
	push	rax
	push	rdx
	push	rcx
	rdtsc
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	rbp

	mov	rdi,rbp

	mov	rsi,rdx
	shl	rsi,32
	add	rsi,rax
	sub	rsi,qword ptr [rip+tick_count]

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_profile_l
	jmp	end_profile_call_2

profile_n:
	push	rax
	push	rdx
	push	rcx
	rdtsc
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	rbp

	mov	rdi,rbp

	mov	rsi,rdx
	shl	rsi,32
	add	rsi,rax
	sub	rsi,qword ptr [rip+tick_count]

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_profile_n
	jmp	end_profile_call

profile_n2:
	push	rax
	push	rdx
	push	rcx
	rdtsc
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	rbp

	mov	rdi,rbp

	mov	rsi,rdx
	shl	rsi,32
	add	rsi,rax
	sub	rsi,qword ptr [rip+tick_count]

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_profile_n
	jmp	end_profile_call_2

profile_eval_upd:
	push	rax
	push	rdx
	push	rcx
	mov	rcx,rdx
	rdtsc
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	rbp

	mov	rdi,rbp

	mov	rsi,rdx
	shl	rsi,32
	add	rsi,rax
	sub	rsi,qword ptr [rip+tick_count]

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_profile_n
	jmp	end_profile_call

profile_s:
	push	rax
	push	rdx
	push	rcx
	rdtsc
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	rbp

	mov	rdi,rbp

	mov	rsi,rdx
	shl	rsi,32
	add	rsi,rax
	sub	rsi,qword ptr [rip+tick_count]

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_profile_s
	jmp	end_profile_call

profile_s2:
	push	rax
	push	rdx
	push	rcx
	rdtsc
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	rbp

	mov	rdi,rbp

	mov	rsi,rdx
	shl	rsi,32
	add	rsi,rax
	sub	rsi,qword ptr [rip+tick_count]

	mov	rdx,qword ptr [rip+words_free]
	mov	qword ptr [rip+words_free],r15
	sub	rdx,r15

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_profile_s

end_profile_call_2:
	mov	rax,qword ptr [rip+_profile_data_stack_ptr]
	mov	rdx,[rax]
	add	rax,8
	mov	qword ptr [rip+_profile_data_stack_ptr],rax
	mov	[rax],rdx
	jmp	end_profile_call_

end_profile_call:
	mov	rax,qword ptr [rip+_profile_data_stack_ptr]
	mov	rdx,[rax]
end_profile_call_:
	mov	qword ptr [rip+_profile_current_cost_centre],rdx
	mov	rsp,rbp

	pop	rbp
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	rdi
	pop	rsi
	pop	rcx

	rdtsc
	shl	rdx,32
	add	rdx,rax
	mov	qword ptr [rip+tick_count],rdx

	pop	rdx
	pop	rax
	ret

write_profile_stack:
	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_write_profile_stack
	mov	rsp,rbp
	ret

write_profile_information:
	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	call	_c_write_profile_information
	mov	rsp,rbp
	ret

init_profiler:
	mov	dword ptr [rip+_profile_type],2

	push	rax
	push	rdx
	push	rsi
	push	rdi
	push	r8
	push	rcx

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
	mov	rdi,qword ptr [rip+_ab_stack_size]
	call	_c_init_profiler
	mov	rsp,rbp

	pop	rcx
	pop	r8
	pop	rdi
	pop	rsi

	rdtsc
	shl	rdx,32
	add	rdx,rax
	mov	qword ptr [rip+tick_count],rdx

	mov	qword ptr [rip+words_free],r15

	pop	rdx
	pop	rax
	ret

_get_time_stamp_counter:
	rdtsc
	shl	rdx,32
	add	rax,rdx
	ret

_measure_profile_overhead:
	push	rbp
	lea	rbp,[rip+measure_profile_overhead_dummy]

	rdtsc
	shl	rdx,32
	add	rdx,rax
	mov	qword ptr [rip+tick_count],rdx

	call	profile_s
	mov	rax,99999
measure_profile_overhead_lp1:
	call	profile_s
	add	rcx,rcx
	add	rdx,rdx
	call	profile_r
	add	rcx,rcx
	add	rdx,rdx
	sub	rax,1
	jne	measure_profile_overhead_lp1
	call	profile_r

	mov	rax,100000
measure_profile_overhead_lp2:
	add	rcx,rcx
	add	rdx,rdx
	add	r8,r8
	add	r9,r9
	sub	rax,1
	jne	measure_profile_overhead_lp2

	rdtsc
	shl	rdx,32
	add	rax,rdx
	sub	rax,qword ptr [rip+tick_count]

	pop	rbp
	ret

	.data

tick_count:
	.quad	0
words_free:
	.quad	0

	.align	8
	.long	m_system-.
measure_profile_overhead_dummy:
	.byte	0

	.align	8
