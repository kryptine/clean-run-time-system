
  .text

  .globl init_profiler
  .globl profile_r
  .globl profile_l
  .globl profile_l2
  .globl profile_n
  .globl profile_n2
  .globl profile_s
  .globl profile_s2
  .globl profile_t
  .globl write_profile_information
  .globl write_profile_stack
  .globl stack_trace_depth

 .if ! LINUX
   .globl allocate_memory
 .endif
   .globl __STRING__
   .globl openF
   .globl closeF
   .globl writeFC
   .globl writeFI
   .globl ab_stack_size
   .globl ew_print_string
   .globl ew_print_char
   .globl ew_print_text
   .globl create_profile_file_name
/* extrn print_error */
/* extrn profile_stack_pointer */

next		= 0
time		= 8
n_profiler_calls = 16
n_strict_calls	= 24
n_lazy_calls	= 32
n_curried_calls	= 40
n_words_allocated = 48
name_		= 56
FunctionProfile	= 64

profile_t:
	push	rax
	push	rdx
	rdtsc

	push	rcx
	mov	rcx,qword ptr profile_stack_pointer[rip]

	sub	edx,dword ptr global_time_hi[rip]
	push	rbx
	mov	ebx,dword ptr global_time_lo[rip]
	mov	eax,eax

	shl	rdx,32
	sub	rax,rbx
	mov	rbx,qword ptr (-8)[rcx]

	add	rax,rdx
	
	sub	rcx,8
	mov	qword ptr global_last_tail_call[rip],rbx

	mov	qword ptr profile_stack_pointer[rip],rcx

	inc	qword ptr n_profiler_calls[rbx]
	add	qword ptr time[rbx],rax

	mov	rax,qword ptr global_n_words_free[rip]
	mov	qword ptr global_n_words_free[rip],r15
	sub	rax,r15
	add	qword ptr n_words_allocated[rbx],rax

	pop	rbx
	pop	rcx

	rdtsc
	mov	dword ptr global_time_hi[rip],edx
	pop	rdx
	mov	dword ptr global_time_lo[rip],eax
	pop	rax
	ret

profile_r:
	push	rax
	push	rdx
	rdtsc

	push	rcx
	mov	rcx,qword ptr profile_stack_pointer[rip]

	sub	edx,dword ptr global_time_hi[rip]
	push	rbx
	mov	ebx,dword ptr global_time_lo[rip]
	mov	eax,eax

	shl	rdx,32
	sub	rax,rbx
	mov	rbx,qword ptr (-8)[rcx]

	add	rax,rdx

	sub	rcx,8
	mov	qword ptr global_last_tail_call[rip],0

	mov	qword ptr profile_stack_pointer[rip],rcx

	inc	qword ptr n_profiler_calls[rbx]
	add	qword ptr time[rbx],rax

	mov	rax,qword ptr global_n_words_free[rip]
	mov	qword ptr global_n_words_free[rip],r15
	sub	rax,r15
	add	qword ptr n_words_allocated[rbx],rax

	pop	rbx
	pop	rcx

	rdtsc
	mov	dword ptr global_time_hi[rip],edx
	pop	rdx
	mov	dword ptr global_time_lo[rip],eax
	pop	rax
	ret

profile_l:
	push	rax
	push	rdx
	rdtsc

	push	rbx
	mov	rbx,qword ptr [rbp]

	test	rbx,rbx
	je	allocate_function_profile_record_l
allocate_function_profile_record_lr:
	push	rcx
	
	mov	rbp,qword ptr global_last_tail_call[rip]
	mov	rcx,qword ptr profile_stack_pointer[rip]

	test	rbp,rbp
	jne	use_tail_calling_function_l

	mov	rbp,qword ptr (-8)[rcx]
use_tail_calling_function_lr:

	mov	qword ptr [rcx],rbx
	add	rcx,8
	
	inc	qword ptr n_curried_calls[rbx]
	att_jmp profile_n_

allocate_function_profile_record_l:
	att_call allocate_function_profile_record
	att_jmp allocate_function_profile_record_lr

use_tail_calling_function_l:
	mov	qword ptr global_last_tail_call[rip],0
	att_jmp use_tail_calling_function_lr

profile_l2:
	push	rax
	push	rdx
	rdtsc

	push	rbx
	mov	rbx,qword ptr [rbp]

	test	rbx,rbx
	je	allocate_function_profile_record_l2
allocate_function_profile_record_l2r:
	push	rcx
	
	mov	rbp,qword ptr global_last_tail_call[rip]
	mov	rcx,qword ptr profile_stack_pointer[rip]
	
	test	rbp,rbp
	jne	use_tail_calling_function_l2

	mov	rbp,qword ptr (-8)[rcx]
use_tail_calling_function_l2r:

	mov	qword ptr [rcx],rbx
	mov	qword ptr 8[rcx],rbx
	add	rcx,16

	inc	qword ptr n_curried_calls[rbx]
	att_jmp profile_n_

allocate_function_profile_record_l2:
	att_call allocate_function_profile_record
	att_jmp allocate_function_profile_record_l2r

use_tail_calling_function_l2:
	mov	qword ptr global_last_tail_call[rip],0
	att_jmp use_tail_calling_function_l2r

profile_n:
	push	rax
	push	rdx
	rdtsc
		
	push	rbx
	mov	rbx,qword ptr [rbp]
	
	test	rbx,rbx
	je	allocate_function_profile_record_n
allocate_function_profile_record_nr:
	push	rcx
	
	mov	rbp,qword ptr global_last_tail_call[rip]
	mov	rcx,qword ptr profile_stack_pointer[rip]

	test	rbp,rbp
	jne	use_tail_calling_function_n

	mov	rbp,qword ptr (-8)[rcx]
use_tail_calling_function_nr:

	mov	qword ptr [rcx],rbx
	add	rcx,8

	inc	qword ptr n_lazy_calls[rbx]
	att_jmp profile_n_

allocate_function_profile_record_n:
	att_call allocate_function_profile_record
	att_jmp allocate_function_profile_record_nr

use_tail_calling_function_n:
	mov	qword ptr global_last_tail_call[rip],0
	att_jmp use_tail_calling_function_nr

profile_n2:
	push	rax
	push	rdx
	rdtsc

	push	rbx
	mov	rbx,qword ptr [rbp]

	test	rbx,rbx
	je	allocate_function_profile_record_n2
allocate_function_profile_record_n2r:
	push	rcx
	
	mov	rbp,qword ptr global_last_tail_call[rip]
	mov	rcx,qword ptr profile_stack_pointer[rip]

	test	rbp,rbp
	jne	use_tail_calling_function_n2

	mov	rbp,qword ptr (-8)[rcx]
use_tail_calling_function_n2r:

	mov	qword ptr [rcx],rbx
	mov	qword ptr 8[rcx],rbx
	add	rcx,16

	inc	qword ptr n_lazy_calls[rbx]
	att_jmp profile_n_

allocate_function_profile_record_n2:
	att_call allocate_function_profile_record
	att_jmp allocate_function_profile_record_n2r

use_tail_calling_function_n2:
	mov	qword ptr global_last_tail_call[rip],0
	att_jmp use_tail_calling_function_n2r

profile_s2:
	push	rax
	push	rdx
	rdtsc
		
	push	rbx
	mov	rbx,qword ptr [rbp]
	
	test	rbx,rbx
	je	allocate_function_profile_record_s2
allocate_function_profile_record_s2r:
	push	rcx

	mov	rbp,qword ptr global_last_tail_call[rip]
	mov	rcx,qword ptr profile_stack_pointer[rip]
	
	test	rbp,rbp
	jne	use_tail_calling_function_s2

	mov	rbp,qword ptr (-8)[rcx]
use_tail_calling_function_s2r:

	mov	qword ptr [rcx],rbx
	mov	qword ptr 8[rcx],rbx
	add	rcx,16
	att_jmp profile_s_

allocate_function_profile_record_s2:
	att_call allocate_function_profile_record
	att_jmp allocate_function_profile_record_s2r

use_tail_calling_function_s2:
	mov	qword ptr global_last_tail_call[rip],0
	att_jmp use_tail_calling_function_s2r

profile_s:
	push	rax
	push	rdx
	rdtsc
	
	push	rbx
	mov	rbx,qword ptr [rbp]
	
	test	rbx,rbx
	je	allocate_function_profile_record_s
allocate_function_profile_record_sr:
	push	rcx

	mov	rbp,qword ptr global_last_tail_call[rip]
	mov	rcx,qword ptr profile_stack_pointer[rip]
	
	test	rbp,rbp
	jne	use_tail_calling_function_s

	mov	rbp,qword ptr (-8)[rcx]
use_tail_calling_function_sr:

	mov	qword ptr [rcx],rbx
	add	rcx,8

profile_s_:
	inc	qword ptr n_strict_calls[rbx]

profile_n_:
	mov	qword ptr profile_stack_pointer[rip],rcx

	sub	edx,dword ptr global_time_hi[rip]
	mov	ebx,dword ptr global_time_lo[rip]
	mov	eax,eax

	shl	rdx,32
	sub	rax,rbx

	add	rax,rdx

	inc	qword ptr n_profiler_calls[rbp]
	add	qword ptr time[rbp],rax

	mov	rax,qword ptr global_n_words_free[rip]
	mov	qword ptr global_n_words_free[rip],r15
	sub	rax,r15
	add	qword ptr n_words_allocated[rbp],rax

	pop	rcx
	pop	rbx

	rdtsc
	mov	dword ptr global_time_hi[rip],edx
	pop	rdx
	mov	dword ptr global_time_lo[rip],eax
	pop	rax
	ret

allocate_function_profile_record_s:
	att_call allocate_function_profile_record
	att_jmp allocate_function_profile_record_sr

use_tail_calling_function_s:
	mov	qword ptr global_last_tail_call[rip],0
	att_jmp use_tail_calling_function_sr


/* argument: rbp: function name adress-4 */
/* result:   rbx: function profile record adress */

allocate_function_profile_record:
	push	rax
	mov	rax,qword ptr global_n_free_records_in_block[rip]
	mov	rbx,qword ptr global_last_allocated_block[rip]

	test	rax,rax
	jne	no_alloc

	push	rcx
	push	rdx
	push	rbp

 .if LINUX
	sub	rsp,104
	mov	qword ptr [rsp],rsi
	mov	qword ptr 8[rsp],rdi
	mov	qword ptr 16[rsp],r8
	mov	qword ptr 24[rsp],r10
	mov	qword ptr 32[rsp],r11
	movsd	qword ptr 40[rsp],xmm0
	movsd	qword ptr 48[rsp],xmm1
	movsd	qword ptr 56[rsp],xmm2
	movsd	qword ptr 64[rsp],xmm3
	movsd	qword ptr 72[rsp],xmm4
	movsd	qword ptr 80[rsp],xmm5
	movsd	qword ptr 88[rsp],xmm6
	movsd	qword ptr 96[rsp],xmm7
 .else
	sub	rsp,72
	mov	qword ptr [rsp],r8
	mov	qword ptr 8[rsp],r10
	mov	qword ptr 16[rsp],r11
	movsd	qword ptr 24[rsp],xmm0
	movsd	qword ptr 32[rsp],xmm1
	movsd	qword ptr 40[rsp],xmm2
	movsd	qword ptr 48[rsp],xmm3
	movsd	qword ptr 56[rsp],xmm4
	movsd	qword ptr 64[rsp],xmm5
 .endif

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
 .if LINUX
	mov	rdi,8192
			/* 128*FunctionProfile */
	att_call _malloc
 .else
	mov	rcx,128*FunctionProfile
	att_call allocate_memory
 .endif
	mov	rsp,rbp

 .if LINUX
	mov	rsi,qword ptr [rsp]
	mov	rdi,qword ptr 8[rsp]
	mov	r8,qword ptr 16[rsp]
	mov	r10,qword ptr 24[rsp]
	mov	r11,qword ptr 32[rsp]
	movlpd	xmm0,qword ptr 40[rsp]
	movlpd	xmm1,qword ptr 48[rsp]
	movlpd	xmm2,qword ptr 56[rsp]
	movlpd	xmm3,qword ptr 64[rsp]
	movlpd	xmm4,qword ptr 72[rsp]
	movlpd	xmm5,qword ptr 80[rsp]
	movlpd	xmm6,qword ptr 88[rsp]
	movlpd	xmm7,qword ptr 96[rsp]
	add	rsp,104
 .else
	mov	r8,qword ptr [rsp]
	mov	r10,qword ptr 8[rsp]
	mov	r11,qword ptr 16[rsp]
	movlpd	xmm0,qword ptr 24[rsp]
	movlpd	xmm1,qword ptr 32[rsp]
	movlpd	xmm2,qword ptr 40[rsp]
	movlpd	xmm3,qword ptr 48[rsp]
	movlpd	xmm4,qword ptr 56[rsp]
	movlpd	xmm5,qword ptr 64[rsp]
	add	rsp,72
 .endif

	test	rax,rax

	pop	rbp
	pop	rdx
	pop	rcx

	je	no_memory

	mov	rbx,rax
	mov	rax,128
	mov	qword ptr global_last_allocated_block[rip],rbx

no_alloc:	
	dec	rax
	mov	qword ptr global_n_free_records_in_block[rip],rax
	lea	rax,FunctionProfile[rbx]
	mov	qword ptr global_last_allocated_block[rip],rax

	xor	rax,rax
	mov	qword ptr time[rbx],rax
	mov	qword ptr n_profiler_calls[rbx],rax
	mov	qword ptr n_strict_calls[rbx],rax
	mov	qword ptr n_lazy_calls[rbx],rax
	mov	qword ptr n_curried_calls[rbx],rax
	mov	qword ptr n_words_allocated[rbx],rax

	mov	rax,qword ptr global_profile_records[rip]
	mov	qword ptr name_[rbx],rbp

	mov	qword ptr next[rbx],rax
	mov	qword ptr global_profile_records[rip],rbx

	mov	qword ptr [rbp],rbx
	pop	rax
	ret

no_memory:
	lea	rbp,not_enough_memory_for_profiler[rip]
	pop	rax
	att_jmp print_error

write_profile_information:
	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
 .if LINUX
	mov	r13,rsi
	mov	r14,rdi
	lea	rdi,profile_file_name[rip]
 .else
	lea	rcx,profile_file_name[rip]
 .endif
	att_call create_profile_file_name
 .if LINUX
	mov	rsi,r13
	mov	rdi,r14
 .endif
	mov	rsp,rbp

	mov	rax,1
	lea	rcx,profile_file_name[rip]
	att_call openF

	test	r10,r10
	je	cannot_open
	
	mov	rbp,qword ptr global_profile_records[rip]

write_profile_lp:	
	test	rbp,rbp
	je	end_list

	mov	rdx,qword ptr name_[rbp]

	push	rbp

	push	rdx

	mov	edx,dword ptr (-4)[rdx]
	mov	eax,dword ptr [rdx]
	add	rdx,4

write_module_name_lp:
	sub	rax,1
	jc	end_module_name

	push	rax
	push	rdx

	movzx	r10,byte ptr [rdx]
	att_call writeFC

	pop	rdx
	pop	rax

	add	rdx,1
	att_jmp write_module_name_lp

end_module_name:
	mov	r10,' 
	att_call writeFC

	pop	rdx

	add	rdx,7
	
write_function_name_lp:
	movzx	r10,byte ptr 1[rdx]
	add	rdx,1

	test	r10,r10
	je	end_function_name

	push	rdx

	att_call writeFC

	pop	rdx

	att_jmp write_function_name_lp

end_function_name:
	mov	r10,' 
	att_call writeFC

	mov	rbp,qword ptr [rsp]
	mov	r10,qword ptr n_strict_calls[rbp]
	att_call writeFI_space

	mov	rbp,qword ptr [rsp]
	mov	r10,qword ptr n_lazy_calls[rbp]
	att_call writeFI_space

	mov	rbp,qword ptr [rsp]
	mov	r10,qword ptr n_curried_calls[rbp]
	att_call writeFI_space

	mov	rbp,qword ptr [rsp]
	mov	r10,qword ptr n_profiler_calls[rbp]
	att_call writeFI_space

	mov	rbp,qword ptr [rsp]
	mov	r10,qword ptr n_words_allocated[rbp]
	att_call writeFI_space

	mov	rbp,qword ptr [rsp]
	mov	r10,qword ptr time[rbp]
	att_call writeFI

	mov	r10,10
	att_call writeFC

	pop	rbp
	mov	rbp,qword ptr next[rbp]
	att_jmp write_profile_lp

writeFI_space:
	att_call writeFI

	mov	r10,' 
	att_jmp writeFC

end_list:
	att_call closeF

cannot_open:
	ret

write_profile_stack:
	mov	rax,qword ptr profile_stack_pointer[rip]

	test	rax,rax
	je	stack_not_initialised

	push	rax

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
 .if LINUX
	mov	r13,rsi
	mov	r14,rdi
	lea	rdi,stack_trace_string[rip]
 .else
	lea	rcx,stack_trace_string[rip]
 .endif
	att_call ew_print_string
 .if LINUX
	mov	rsi,r13
	mov	rdi,r14
 .endif
	mov	rsp,rbp

	pop	rax

/*	mov	rbp,12 */
	mov	rbp,qword ptr stack_trace_depth[rip]
write_functions_on_stack:
	mov	rbx,qword ptr (-8)[rax]
	sub	rax,8

	test	rbx,rbx
	je	end_profile_stack

	push	rax
	mov	rcx,qword ptr name_[rbx]

	push	rbp

	mov	edx,dword ptr (-4)[rcx]
	add	rcx,8

	mov	r12d,dword ptr [rdx]
	lea	r13,4[rdx]

	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
 .if LINUX
	mov	r11,rsi
	mov	r14,rdi
	mov	rdi,rcx
 .endif
	att_call ew_print_string

 .if LINUX
	lea	rdi,module_string[rip]
 .else
	lea	rcx,module_string[rip]
 .endif
	att_call ew_print_string

 .if LINUX
	mov	rsi,r12
	mov	rdi,r13
 .else
	mov	rdx,r12
	mov	rcx,r13
 .endif
	att_call ew_print_text

 .if LINUX
	mov	rdi,']
 .else
	mov	rcx,']
 .endif
	att_call ew_print_char

 .if LINUX
	mov	rdi,10
 .else
	mov	rcx,10
 .endif
	att_call ew_print_char
 
.if LINUX
	mov	rsi,r11
	mov	rdi,r14
 .endif
	mov	rsp,rbp

	pop	rbp
	pop	rax

	sub	rbp,1
	att_jne	write_functions_on_stack
	
end_profile_stack:
stack_not_initialised:
	ret

init_profiler:
	mov	rbp,rsp
	sub	rsp,40
	and	rsp,-16
 .if LINUX
	mov	r13,rsi
	mov	r14,rdi
	mov	rdi,qword ptr ab_stack_size[rip]
	att_call _malloc
	mov	rsi,r13
	mov	rdi,r14
 .else
	mov	rcx,qword ptr ab_stack_size[rip]
	att_call allocate_memory
 .endif
	mov	rsp,rbp
	
	test	rax,rax
	je	init_profiler_error

	push	rax

	lea	rbp,start_string[rip]
	att_call allocate_function_profile_record

	pop	rdx

	mov	qword ptr 8[rdx],rbx
	mov	qword ptr [rdx],0
	add	rdx,16
	mov	qword ptr profile_stack_pointer[rip],rdx
	mov	qword ptr global_last_tail_call[rip],0

	mov	qword ptr global_n_words_free[rip],r15

	rdtsc
	mov	dword ptr global_time_hi[rip],edx
	mov	dword ptr global_time_lo[rip],eax
	ret

init_profiler_error:
	mov	qword ptr profile_stack_pointer[rip],0
	lea	rbp,not_enough_memory_for_profile_stack[rip]
	att_jmp print_error

	.data

	.align 8

global_n_free_records_in_block:
	.quad 0
/* 0 n free records in block */
global_last_allocated_block:
	.quad 0
/* 8 latest allocated block */
global_profile_records:
	.quad 0
/* 16 profile record list */
global_time_hi:
	.long 0
/* 24 clock */
global_time_lo:
	.long 0
global_last_tail_call:
	.quad 0
/* last tail calling function */
global_n_words_free:
	.quad 0

profile_file_name:
	.quad __STRING__+2
	.quad 0
	.quad 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.quad 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.quad 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.quad 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.quad 0
stack_trace_depth:
	.quad 12
	.align 8

/* m_system also defined in istartup.s */
/* m_system:*/
/*	.quad 6*/
/*	.ascii "System"*/
/*	.byte 0*/
/*	.byte 0*/

	.long	m_system
start_string:
	.quad 0
	.ascii "start"
	.byte 0
	.align	8
not_enough_memory_for_profile_stack:
	.ascii "not enough memory for profile stack"
	.byte 10
	.byte 0
not_enough_memory_for_profiler:
	.ascii "not enough memory for profiler"
	.byte 10
	.byte 0
stack_trace_string:
	.ascii "Stack trace:"
	.byte 10
	.byte 0
module_string:
	.ascii " [module: "
	.byte 0
	.align	8

/*	end*/

