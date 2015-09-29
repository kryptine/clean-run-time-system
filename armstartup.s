@
@	File:	 armstartup.s
@	Author:	 John van Groningen
@	Machine: ARM

@ B stack registers:     r4 r3 r2 r1 r0
@ A stack registers:     r6 r7 r8 r11 (fp)
@ n free heap words:     r5
@ A stack pointer:       r9 (sb)
@ heap pointer:          r10 (sl)
@ scratch register:      r12 (ip)
@ B stack pointer:       r13 (sp)
@ link/scratch register: r14 (lr)

	.fpu vfp3

USE_CLIB = 1

SHARE_CHAR_INT = 1
MY_ITOS = 1
FINALIZERS = 1
STACK_OVERFLOW_EXCEPTION_HANDLER = 0
WRITE_HEAP = 0

@ DEBUG = 0
PREFETCH2 = 0

NO_BIT_INSTRUCTIONS = 1
ADJUST_HEAP_SIZE = 1
MARK_GC = 1
MARK_AND_COPY_GC = 1

NEW_DESCRIPTORS = 1

@ #define PROFILE
MODULE_NAMES_IN_TIME_PROFILER = 1

COMPACT_GC_ONLY = 0

MINIMUM_HEAP_SIZE = 8000
MINIMUM_HEAP_SIZE_2 = 4000

.ifdef LINUX
# define section(n) .section    .text.n,"ax"
.else
# define section(n) .text
.endif

DESCRIPTOR_ARITY_OFFSET	= (-2)
ZERO_ARITY_DESCRIPTOR_OFFSET = (-4)

	.comm	semi_space_size,4

	.comm	heap_mbp,4
	.comm	stack_mbp,4
	.comm	heap_p,4
	.comm	heap_p1,4
	.comm	heap_p2,4
	.comm	heap_p3,4
	.comm	end_heap_p3,4
	.comm	heap_size_33,4
	.comm	vector_p,4
	.comm	vector_counter,4
	.comm	neg_heap_vector_plus_4,4

	.comm	heap_size_32_33,4
	.comm	heap_vector,4
	.comm	stack_top,4
	.comm	end_vector,4

	.comm	heap_size_129,4
	.comm	heap_copied_vector,4
	.comm	heap_copied_vector_size,4
	.comm	heap_end_after_copy_gc,4

	.comm	heap_end_after_gc,4
	.comm	extra_heap,4
	.comm	extra_heap_size,4
	.comm	stack_p,4
	.comm	halt_sp,4

	.comm	n_allocated_words,4
	.comm	basic_only,4

	.comm	last_time,4
	.comm	execute_time,4
	.comm	garbage_collect_time,4
	.comm	IO_time,4

	.globl	saved_heap_p
	.comm	saved_heap_p,4

	.globl	saved_a_stack_p
	.comm	saved_a_stack_p,4

	.globl	end_a_stack
	.comm	end_a_stack,4

	.globl	end_b_stack
	.comm	end_b_stack,4

	.comm	dll_initisialised,4

.if WRITE_HEAP
	.comm	heap_end_write_heap,4
	.comm	d3_flag_write_heap,4
	.comm	heap2_begin_and_end,8
.endif

.if STACK_OVERFLOW_EXCEPTION_HANDLER
	.comm	a_stack_guard_page,4
.endif

	.globl	profile_stack_pointer
	.comm	profile_stack_pointer,4

	.data
	.p2align	2

.if MARK_GC
bit_counter:
	.long	0
bit_vector_p:
	.long	0
zero_bits_before_mark:
	.long	1
n_free_words_after_mark:
	.long	1000
n_last_heap_free_bytes:
	.long	0
lazy_array_list:
	.long	0
n_marked_words:
	.long	0
end_stack:
	.long	0
 .if ADJUST_HEAP_SIZE
bit_vector_size:
	.long	0
 .endif
.endif

caf_list:
	.long	0
	.globl	caf_listp
caf_listp:
	.long	0

zero_length_string:
	.long	__STRING__+2
	.long	0
true_string:
	.long	__STRING__+2
	.long	4
true_c_string:
	.ascii	"True"
	.byte	0,0,0,0
false_string:
	.long	__STRING__+2
	.long	5
false_c_string:
	.ascii	"False"
	.byte	0,0,0
file_c_string:
	.ascii	"File"
	.byte	0,0,0,0
garbage_collect_flag:
	.byte	0
	.byte	0,0,0

	.comm	sprintf_buffer,32

out_of_memory_string_1:
	.ascii	"Not enough memory to allocate heap and stack"
	.byte	10,0
printf_int_string:
	.ascii	"%d"
	.byte	0
printf_real_string:
	.ascii	"%.15g"
	.byte	0
printf_string_string:
	.ascii	"%s"
	.byte	0
printf_char_string:
	.ascii	"%c"
	.byte	0
garbage_collect_string_1:
	.asciz	"A stack: "
garbage_collect_string_2:
	.asciz	" bytes. BC stack: "
garbage_collect_string_3:
	.ascii	" bytes."
	.byte	10,0
heap_use_after_gc_string_1:
	.ascii	"Heap use after garbage collection: "
	.byte	0
heap_use_after_gc_string_2:
	.ascii	" Bytes."
	.byte	10,0
stack_overflow_string:
	.ascii	"Stack overflow."
	.byte	10,0
out_of_memory_string_4:
	.ascii	"Heap full."
	.byte	10,0
time_string_1:
	.ascii	"Execution: "
	.byte	0
time_string_2:
	.ascii	"  Garbage collection: "
	.byte	0
time_string_4:
	.ascii	"  Total: "
	.byte	0
high_index_string:
	.ascii	"Index too high in UPDATE string."
	.byte	10,0
low_index_string:
	.ascii	"Index negative in UPDATE string."
	.byte	10,0
IO_error_string:
	.ascii	"IO error: "
	.byte	0
new_line_string:
	.byte	10,0

sprintf_time_string:
	.ascii	"%d.%02d"
	.byte	0

.if MARK_GC
marked_gc_string_1:
	.ascii	"Marked: "
	.byte	0
.endif
.ifdef PROFILE
	.p2align	2
 .if MODULE_NAMES_IN_TIME_PROFILER
  .ifdef LINUX
	.globl	m_system
  .endif
m_system:
	.long	6
	.ascii	"System"
	.byte	0
	.byte	0
	.long	m_system

 .endif
garbage_collector_name:
	.long	0
	.asciz	"garbage_collector"
	.p2align	2
.endif

.ifdef DLL
start_address:
	.long	0
.endif
	.p2align	2
	.comm	sprintf_time_buffer,20

	.p2align	2
.if SHARE_CHAR_INT
	.globl	small_integers
	.comm	small_integers,33*8
	.globl	static_characters
	.comm	static_characters,256*8
.endif

	.text

	.globl	abc_main
	.globl	print
	.globl	print_char
	.globl	print_int
	.globl	print_real
	.globl	print__string__
	.globl	print__chars__sc
	.globl	print_sc
	.globl	print_symbol
	.globl	print_symbol_sc
	.globl	printD
	.globl	DtoAC
	.globl	push_t_r_args
	.globl	push_a_r_args
	.globl	halt
	.globl	dump

	.globl	catAC
	.globl	sliceAC
	.globl	updateAC
	.globl	eqAC
	.globl	cmpAC

	.globl	string_to_string_node
	.globl	int_array_to_node
	.globl	real_array_to_node

	.globl	_create_arrayB
	.globl	_create_arrayC
	.globl	_create_arrayI
	.globl	_create_arrayR
	.globl	_create_r_array
	.globl	create_array
	.globl	create_arrayB
	.globl	create_arrayC
	.globl	create_arrayI
	.globl	create_arrayR
	.globl	create_R_array

	.globl	BtoAC
	.globl	ItoAC
	.globl	RtoAC
	.globl	eqD

	.globl	collect_0
	.globl	collect_1
	.globl	collect_2
	.globl	collect_3
 
	.globl	_c3,_c4,_c5,_c6,_c7,_c8,_c9,_c10,_c11,_c12
	.globl	_c13,_c14,_c15,_c16,_c17,_c18,_c19,_c20,_c21,_c22
	.globl	_c23,_c24,_c25,_c26,_c27,_c28,_c29,_c30,_c31,_c32

	.globl	e__system__nind
	.globl	e__system__eaind
@ old names of the previous two labels for compatibility, remove later
	.globl	__indirection,__eaind
	.globl	e__system__dind
	.globl	eval_fill

	.globl	eval_upd_0,eval_upd_1,eval_upd_2,eval_upd_3,eval_upd_4
	.globl	eval_upd_5,eval_upd_6,eval_upd_7,eval_upd_8,eval_upd_9
	.globl	eval_upd_10,eval_upd_11,eval_upd_12,eval_upd_13,eval_upd_14
	.globl	eval_upd_15,eval_upd_16,eval_upd_17,eval_upd_18,eval_upd_19
	.globl	eval_upd_20,eval_upd_21,eval_upd_22,eval_upd_23,eval_upd_24
	.globl	eval_upd_25,eval_upd_26,eval_upd_27,eval_upd_28,eval_upd_29
	.globl	eval_upd_30,eval_upd_31,eval_upd_32

	.globl	repl_args_b
	.globl	push_arg_b
	.globl	del_args
.if 0
	.globl	o__S_P2
	.globl	ea__S_P2
.endif
	.globl	add_IO_time
	.globl	add_execute_time
	.globl	IO_error
	.globl	stack_overflow

	.globl	out_of_memory_4
	.globl	print_error
.ifndef DLL
	.global	_start
.endif
	.globl	sin_real
	.globl	cos_real
	.globl	tan_real
	.globl	asin_real
	.globl	acos_real
	.globl	atan_real
	.globl	ln_real
	.globl	log10_real
	.globl	exp_real
	.globl	pow_real
	.globl	r_to_i_real
	.globl	truncate_real
	.globl	entier_real
	.globl	ceiling_real
	.globl	round__real64
	.globl	truncate__real64
	.globl	entier__real64
	.globl	ceiling__real64
	.globl	int64a__to__real

.ifdef PROFILE
	.globl	init_profiler
	.globl	profile_s,profile_n,profile_r,profile_t
	.globl	write_profile_information,write_profile_stack
.endif
	.globl	__driver

@ from system.abc:	
	.globl	INT
	.globl	CHAR
	.globl	BOOL
	.globl	REAL
	.globl	FILE
	.globl	__STRING__
	.globl	__ARRAY__
	.globl	__cycle__in__spine
	.globl	__print__graph
	.globl	__eval__to__nf

@ from wcon.c:
	.globl	w_print_char
	.globl	w_print_string
	.globl	w_print_text
	.globl	w_print_int
	.globl	w_print_real

	.globl	ew_print_char
	.globl	ew_print_text
	.globl	ew_print_string
	.globl	ew_print_int

	.globl	ab_stack_size
	.globl	heap_size
	.globl	flags

@ from standard c library:
	.globl	malloc
	.globl	free
	.globl	sprintf
	.globl	strlen

.if STACK_OVERFLOW_EXCEPTION_HANDLER
	.globl	allocate_memory_with_guard_page_at_end
.endif
.if ADJUST_HEAP_SIZE
	.global	heap_size_multiple
	.global	initial_heap_size
.endif
.if WRITE_HEAP
	.global	min_write_heap_size
.endif
.if FINALIZERS
	.global	__Nil
	.globl	finalizer_list
	.comm	finalizer_list,4
	.globl	free_finalizer_list
	.comm	free_finalizer_list,4
.endif

abc_main:
	str	lr,[sp,#-4]!

	stmdb	sp!,{r4-r11}

.ifdef DLL
	ldr	r4,[sp,#28]
	ldr	r12,=start_address
	str	r4,[r12]
.endif
	str	pc,[sp,#-4]!
	bl	init_clean
	tst	r4,r4
	bne	init_error

	str	pc,[sp,#-4]!
	bl	init_timer

	ldr	r12,=halt_sp
	str	sp,[r12]

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	init_profiler
.endif

.ifdef DLL
	ldr	r12,=start_address
	ldr	r4,[r12]
	str	pc,[sp,#-4]!
	blx	r4
.else
	str	pc,[sp,#-4]!
	bl	__start
.endif

exit:
	str	pc,[sp,#-4]!
	bl	exit_clean

init_error:
	ldmia	sp!,{r4-r11,pc}
	
	.globl	clean_init
clean_init:
	stmdb	sp!,{r4-r11}

	ldr	r12,=dll_initisialised
	mov	r0,#1
	str	r0,[r12]

	str	pc,[sp,#-4]!
	bl	init_clean
	tst	r4,r4
	bne	init_dll_error

	str	pc,[sp,#-4]!
	bl	init_timer

	ldr	r12,=halt_sp
	str	sp,[r12]

 .ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	init_profiler
 .endif

	ldr	r12,=saved_heap_p
	str	r10,[r12]
	ldr	r12,=saved_a_stack_p
	str	r9,[r12]

	mov	r4,#1
	b	exit_dll_init

init_dll_error:
	mov	r4,#0
	b	exit_dll_init

	.globl	clean_fini
clean_fini:
	stmdb	sp!,{r4-r11}

	ldr	r12,=saved_heap_p
	ldr	r10,[r12]
	ldr	r12,=saved_a_stack_p
	ldr	r9,[r12]

	str	pc,[sp,#-4]!
	bl	exit_clean

exit_dll_init:
	ldmia	sp!,{r4-r11,pc}

init_clean:
	add	r4,sp,#128
	ldr	r12,=ab_stack_size
	ldr	r12,[r12]
	sub	r4,r4,r12
	ldr	r12,=end_b_stack
	str	r4,[r12]

	ldr	r12,=flags
	ldr	r4,[r12]
	and	r4,r4,#1
	ldr	r12,=basic_only
	str	r4,[r12]

	ldr	r12,=heap_size
	ldr	r4,[r12]
.if PREFETCH2
	subs	r4,r4,#63
.else
	subs	r4,r4,#3
.endif
@	divide by 33
	ldr	r12,=1041204193
	umull	r11,r4,r12,r4
	lsr	r4,r4,#3
	ldr	r12,=heap_size_33
	str	r4,[r12]

	ldr	r12,=heap_size
	ldr	r4,[r12]
	subs	r4,r4,#3
@	divide by 129
	ldr	r12,=266354561
	umull	r11,r4,r12,r4
	lsr	r4,r4,#3
	ldr	r12,=heap_size_129
	str	r4,[r12]
	add	r4,r4,#3
	and	r4,r4,#-4
	ldr	r12,=heap_copied_vector_size
	str	r4,[r12]
	ldr	r12,=heap_end_after_copy_gc
	mov	r11,#0
	str	r11,[r12]

	ldr	r12,=heap_size
	ldr	r4,[r12]
	add	r4,r4,#7
	and	r4,r4,#-8
	str	r4,[r12]
	add	r4,r4,#7

	mov	r0,r4
	bl	malloc

	movs	r4,r0
	beq	no_memory_2

	ldr	r12,=heap_mbp
	str	r4,[r12]
	add	r10,r4,#3
	and	r10,r10,#-4
	ldr	r12,=heap_p
	str	r10,[r12]

	ldr	r8,=ab_stack_size
	ldr	r8,[r8]
	add	r8,r8,#3

	mov	r0,r8
.if STACK_OVERFLOW_EXCEPTION_HANDLER
	bl	allocate_memory_with_guard_page_at_end
.else
	bl	malloc
.endif

	movs	r4,r0
	beq	no_memory_3

	ldr	r12,=stack_mbp
	str	r4,[r12]
.if STACK_OVERFLOW_EXCEPTION_HANDLER
	ldr	r12,=ab_stack_size
	ldr	r12,[r12]
	add	r4,r4,r12
	ldr	r12,=a_stack_guard_page
	add	r4,r4,#4096
	add	r4,r4,#(3+4095)-4096
	bic	r4,r4,#255
	bic	r4,r4,#4095-255
	str	r4,[r12]
	ldr	r12,=ab_stack_size
	ldr	r12,[r12]
	sub	r4,r4,r12
.endif
	add	r4,r4,#3
	and	r4,r4,#-4

	mov	r9,r4
	ldr	r12,=stack_p
	str	r4,[r12]

	ldr	r12,=ab_stack_size
	ldr	r12,[r12]
	add	r4,r4,r12
	subs	r4,r4,#64
	ldr	r12,=end_a_stack
	str	r4,[r12]

.if SHARE_CHAR_INT
	ldr	r6,=small_integers
	mov	r4,#0
	ldr	r3,=INT+2

make_small_integers_lp:
	str	r3,[r6]
	str	r4,[r6,#4]
	add	r4,r4,#1
	add	r6,r6,#8
	cmp	r4,#33
	bne	make_small_integers_lp

	ldr	r6,=static_characters
	mov	r4,#0
	ldr	r3,=CHAR+2

make_static_characters_lp:
	str	r3,[r6]
	str	r4,[r6,#4]
	add	r4,r4,#1
	add	r6,r6,#8
	cmp	r4,#256
	bne	make_static_characters_lp
.endif

	ldr	r6,=caf_list+4
	ldr	r12,=caf_listp
	str	r6,[r12]

.if FINALIZERS
	ldr	r12,=finalizer_list
	ldr	r11,=__Nil-4
	str	r11,[r12]
	ldr	r12,=free_finalizer_list
	str	r11,[r12]
.endif

	ldr	r12,=heap_p1
	str	r10,[r12]

	ldr	r12,=heap_size_129
	ldr	r8,[r12]
	lsl	r8,r8,#4
	add	r4,r10,r8,lsl #2
	ldr	r12,=heap_copied_vector
	str	r4,[r12]
	ldr	r12,=heap_copied_vector_size
	ldr	r12,[r12]
	add	r4,r12
	ldr	r12,=heap_p2
	str	r4,[r12]

	ldr	r12,=garbage_collect_flag
	mov	r11,#0
	strb	r11,[r12]

 .if MARK_AND_COPY_GC
 	ldr	r12,=flags
 	ldrb	r12,[r12]
 	tst	r12,#64
	beq	no_mark1
 .endif

 .if MARK_GC || COMPACT_GC_ONLY
	ldr	r12,=heap_size_33
	ldr	r4,[r12]
	ldr	r12,=heap_vector
	str	r10,[r12]
	add	r10,r10,r4
  .if PREFETCH2
	add	r10,r10,#63
	and	r10,r10,#-64
  .else
	add	r10,r10,#3
	and	r10,r10,#-4
  .endif
	ldr	r12,=heap_p3
	str	r10,[r12]
	lsl	r8,r4,#3
	ldr	r12,=garbage_collect_flag
	mov	r11,#-1
	strb	r11,[r12]
 .endif

 .if MARK_AND_COPY_GC
no_mark1:
 .endif

 .if ADJUST_HEAP_SIZE
 	ldr	r4,=initial_heap_size
 	ldr	r4,[r4]
  .if MARK_AND_COPY_GC
	mov	r3,#MINIMUM_HEAP_SIZE_2
	ldr	r12,=flags
	ldrb	r12,[r12]
	tst	r12,#64
	bne	no_mark9
	add	r3,r3,r3
no_mark9:
  .else
   .if MARK_GC || COMPACT_GC_ONLY
	mov	r3,#MINIMUM_HEAP_SIZE
   .else
	mov	r3,#MINIMUM_HEAP_SIZE_2
   .endif
  .endif

	cmp	r4,r3
	ble	too_large_or_too_small
	lsr	r4,r4,#2
	cmp	r4,r8
	bge	too_large_or_too_small
	mov	r8,r4
too_large_or_too_small:
 .endif

	add	r4,r10,r8,lsl #2
	ldr	r12,=heap_end_after_gc
	str	r4,[r12]

	mov	r5,r8

 .if MARK_AND_COPY_GC
 	ldr	r12,=flags
 	ldrb	r12,[r12]
 	tst	r12,#64
	beq	no_mark2
 .endif

 .if MARK_GC && ADJUST_HEAP_SIZE
	ldr	r12,=bit_vector_size
	str	r8,[r12]
 .endif

 .if MARK_AND_COPY_GC
no_mark2:
 .endif

	mov	r4,#0
	ldr	pc,[sp],#4

no_memory_2:
	ldr	r0,=out_of_memory_string_1
	bl	ew_print_string
.ifdef _WINDOWS_
?	movl	$1,@execution_aborted
.endif
	mov	r0,#1
	ldr	pc,[sp],#4

no_memory_3:
	ldr	r0,=out_of_memory_string_1
	bl	ew_print_string
.ifdef _WINDOWS_
?	movl	$1,@execution_aborted
.endif

	ldr	r0,=heap_mbp
	ldr	r0,[r0]
	bl	free

	mov	r0,#1
	ldr	pc,[sp],#4

exit_clean:
	str	pc,[sp,#-4]!
	bl	add_execute_time

	ldr	r4,=flags
	ldr	r4,[r4]
	tst	r4,#8
	beq	no_print_execution_time

	ldr	r0,=time_string_1
	bl	ew_print_string

	ldr	r12,=execute_time
	ldr	r4,[r12]

	str	pc,[sp,#-4]!
	bl	print_time

	ldr	r0,=time_string_2
	bl	ew_print_string

	ldr	r12,=garbage_collect_time
	ldr	r4,[r12]

	str	pc,[sp,#-4]!
	bl	print_time

	ldr	r0,=time_string_4
	bl	ew_print_string

	ldr	r12,=execute_time
	ldr	r4,[r12]
	ldr	r12,=garbage_collect_time
	ldr	r12,[r12]
	add	r4,r12
	ldr	r12,=IO_time
	ldr	r12,[r12]
	add	r4,r12

	str	pc,[sp,#-4]!
	bl	print_time

	mov	r0,#10
	bl	ew_print_char

no_print_execution_time:
	ldr	r0,=stack_mbp
	ldr	r0,[r0]
	bl	free

	ldr	r0,=heap_mbp
	ldr	r0,[r0]
	bl	free

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	write_profile_information
.endif

	ldr	pc,[sp],#4

__driver:
	ldr	r8,=flags
	ldr	r8,[r8]
	tst	r8,#16
	beq	__print__graph
	b	__eval__to__nf

	.ltorg

print_time:
@	divide by 1000
	ldr	r12,=274877907
	umull	r11,r6,r12,r4
	lsr	r6,r6,#6

	mov	r11,#-1025
	add	r11,r11,#-1000-(-1025)
	mla	r4,r6,r11,r4

@	divide by 10
	ldr	r12,=-858993459
	umull	r11,r4,r12,r4
	lsr	r4,r4,#3

.if USE_CLIB
	mov	r3,r4
	mov	r2,r6
	ldr	r1,=sprintf_time_string
	ldr	r0,=sprintf_time_buffer
	bl	sprintf

	ldr	r0,=sprintf_time_buffer
	bl	ew_print_string
.else
	mov	r0,r6
	bl	ew_print_int

	ldr	r6,=sprintf_time_buffer

	eor	r7,r7,r7
	mov	r3,#10

	mov	r12,#46
	strb	r12,[r6]

@	divide by 10
	ldr	r12,=-858993459
	umull	r11,r0,r12,r4
	lsr	r0,r0,#3

	sub	r4,r4,r0,lsl #1
	sub	r4,r4,r0,lsl #3

	add	r4,r4,#48
	add	r7,r7,#48
	strb	r0,[r6,#1]
	strb	r4,[r6,#2]

	mov	r1,#3
	mov	r0,r6
	bl	ew_print_text
.endif
	ldr	pc,[sp],#4

print_sc:
	ldr	r12,=basic_only
	ldr	r8,[r12]
	cmp	r8,#0
	bne	end_print

print:
	mov	r0,r4
	bl	w_print_string

end_print:
	ldr	pc,[sp],#4

dump:
	str	pc,[sp,#-4]!
	bl	print
	b	halt

printD:	tst	r4,#2
	bne	printD_

	mov	r8,r4
	b	print_string_a2

DtoAC_record:
	ldr	r8,[r4,#-6]
	b	DtoAC_string_a2

DtoAC:	tst	r4,#2
	bne	DtoAC_

	mov	r8,r4
	b	DtoAC_string_a2

DtoAC_:
	ldrh	r12,[r4,#-2]
	cmp	r12,#256
	bhs	DtoAC_record

  	ldrh	r3,[r4]
  	add	r12,r4,#10
  	add	r8,r12,r3

DtoAC_string_a2:
	ldr	r4,[r8]
	add	r6,r8,#4
	b	build_string

print_symbol:
	mov	r3,#0
	b	print_symbol_2

print_symbol_sc:
	ldr	r12,=basic_only
	ldr	r3,[r12]
print_symbol_2:
	ldr	r4,[r6]

	ldr	r12,=INT+2
	cmp	r4,r12
	beq	print_int_node

	ldr	r12,=CHAR+2
	cmp	r4,r12
	beq	print_char_denotation

	ldr	r12,=BOOL+2
	cmp	r4,r12
	beq	print_bool

	ldr	r12,=REAL+2
	cmp	r4,r12
	beq	print_real_node

	cmp	r3,#0
	bne	end_print_symbol

printD_:
	ldrh	r12,[r4,#-2]
	cmp	r12,#256
	bhs	print_record

  	ldrh	r3,[r4]
  	add	r12,r4,#10
  	add	r8,r12,r3
	b	print_string_a2

print_record:
	ldr	r8,[r4,#-6]
	b	print_string_a2

end_print_symbol:
	ldr	pc,[sp],#4

print_int_node:
	ldr	r0,[r6,#4]
	bl	w_print_int
	ldr	pc,[sp],#4

print_int:
	mov	r0,r4
	bl	w_print_int
	ldr	pc,[sp],#4

print_char_denotation:
	tst	r3,r3
	bne	print_char_node

	ldr	r12,[r6,#4]
	str	r12,[sp,#-4]!

	mov	r0,#0x27
	bl	w_print_char

	ldr	r0,[sp],#4
	bl	w_print_char

	mov	r0,#0x27
	bl	w_print_char

	ldr	pc,[sp],#4

print_char_node:
	ldr	r0,[r6,#4]
	bl	w_print_char
	ldr	pc,[sp],#4

print_char:
	str	r4,[sp,#-4]!
	bl	w_print_char
	add	sp,sp,#4
	ldr	pc,[sp],#4

print_bool:
	ldsb	r6,[r6,#4]
	tst	r6,r6
	beq	print_false

print_true:
	ldr	r0,=true_c_string
	bl	w_print_string
	ldr	pc,[sp],#4

print_false:
	ldr	r0,=false_c_string
	bl	w_print_string
	ldr	pc,[sp],#4

print_real:
	b	print_real_
print_real_node:
	vldr.f64 d0,[r6,#4]
print_real_:
	mov	r11,sp
	bic	sp,sp,#7
	bl	w_print_real
	mov	sp,r11
	ldr	pc,[sp],#4

print_string_a2:
	ldr	r1,[r8]
	add	r0,r8,#4
	bl	w_print_text
	ldr	pc,[sp],#4

print__chars__sc:
	ldr	r12,=basic_only
	ldr	r8,[r12]
	cmp	r8,#0
	bne	no_print_chars

print__string__:
	ldr	r1,[r6,#4]
	add	r0,r6,#8
	bl	w_print_text
no_print_chars:
	ldr	pc,[sp],#4

push_a_r_args:
	str	r10,[sp,#-4]!

	ldr	r7,[r6,#8]
	subs	r7,r7,#2
	ldrh	r10,[r7]
	subs	r10,r10,#256
	ldrh	r3,[r7,#2]
	add	r7,r7,#4
	str	r7,[sp,#-4]!

	mov	r7,r10
	subs	r7,r7,r3

	lsl	r4,r4,#2
	add	r12,r6,#12
	add	r6,r12,r3,lsl #2
	subs	r10,r10,#1
mul_array_size_lp:
	add	r6,r6,r4
	subs	r10,r10,#1
	bcs	mul_array_size_lp

	add	r10,r6,r7,lsl #2
	b	push_a_elements
push_a_elements_lp:
	ldr	r4,[r6,#-4]!
	str	r4,[r9],#4
push_a_elements:
	subs	r3,r3,#1
	bcs	push_a_elements_lp

	mov	r6,r10
	ldr	r4,[sp],#4
	ldr	r10,[sp],#4

	ldr	r8,[sp],#4
	b	push_b_elements
push_b_elements_lp:
	ldr	r12,[r6,#-4]!
	str	r12,[sp,#-4]!
push_b_elements:
	subs	r7,r7,#1
	bcs	push_b_elements_lp

	mov	pc,r8

push_t_r_args:
	ldr	r8,[sp],#4

	ldr	r7,[r6]
	add	r6,r6,#4
	subs	r7,r7,#2
	ldrh	r4,[r7]
	subs	r4,r4,#256
	ldrh	r3,[r7,#2]
	add	r7,r7,#4

	str	r7,[r9]
	str	r3,[r9,#4]

	sub	r3,r4,r3

	add	r7,r6,r4,lsl #2
	cmp	r4,#2
	bls	small_record
	ldr	r7,[r6,#4]
	add	r12,r7,#-4
	add	r7,r12,r4,lsl #2
small_record:
	b	push_r_b_elements

push_r_b_elements_lp:
	subs	r4,r4,#1
	bne	not_first_arg_b

	ldr	r12,[r6]
	str	r12,[sp,#-4]!
	b	push_r_b_elements
not_first_arg_b:
	ldr	r12,[r7,#-4]!
	str	r12,[sp,#-4]!
push_r_b_elements:
	subs	r3,r3,#1
	bcs	push_r_b_elements_lp

	ldr	r3,[r9,#4]
	str	r8,[sp,#-4]!
	ldr	r12,[r9]
	str	r12,[sp,#-4]!
	b	push_r_a_elements

push_r_a_elements_lp:
	subs	r4,r4,#1
	bne	not_first_arg_a

	ldr	r8,[r6]
	str	r8,[r9],#4
	b	push_r_a_elements
not_first_arg_a:
	ldr	r8,[r7,#-4]!
	str	r8,[r9],#4
push_r_a_elements:
	subs	r3,r3,#1
	bcs	push_r_a_elements_lp

	ldr	r4,[sp],#4
	ldr	pc,[sp],#4

BtoAC:
	tst	r4,r4
	beq	BtoAC_false
BtoAC_true:
	ldr	r6,=true_string
	ldr	pc,[sp],#4
BtoAC_false:
	ldr	r6,=false_string
	ldr	pc,[sp],#4

RtoAC:
.if USE_CLIB
	vmov	r2,r3,d0
	ldr	r1,=printf_real_string
	ldr	r0,=sprintf_buffer	
	bl	sprintf
.else
	ldr	r0,=sprintf_buffer	
	bl	convert_real_to_string
.endif
	b	return_sprintf_buffer

ItoAC:
.if MY_ITOS
	ldr	r6,=sprintf_buffer
	str	pc,[sp,#-4]!
	bl	int_to_string

	ldr	r12,=sprintf_buffer
	sub	r4,r6,r12
	b	sprintf_buffer_to_string

int_to_string:
	tst	r4,r4
	bpl	no_minus
	mov	r12,#45
	strb	r12,[r6],#1
	neg	r4,r4
no_minus:
	add	r8,r6,#12

	beq	zero_digit

	ldr	r2,=0xcccccccd 

calculate_digits:
	cmp	r4,#10
	blo	last_digit

	umull	r12,r7,r2,r4
	add	r3,r4,#48

	lsr	r4,r7,#3

	and	r7,r7,#-8
	sub	r3,r3,r7
	sub	r3,r3,r7,lsr #2
	strb	r3,[r8],#1
	b	calculate_digits

last_digit:
	tst	r4,r4
	beq	no_zero
zero_digit:
	add	r4,r4,#48
	strb	r4,[r8],#1
no_zero:
	add	r7,r6,#12

reverse_digits:
	ldrb	r3,[r8,#-1]!
	strb	r3,[r6],#1
	cmp	r7,r8
	bne	reverse_digits

	mov	r12,#0
	strb	r12,[r6]
	ldr	pc,[sp],#4
.else
	mov	r2,r4
	ldr	r1,=printf_int_string
	ldr	r0,=sprintf_buffer
	bl	sprintf
.endif

return_sprintf_buffer:
.if USE_CLIB
	ldr	r0,=sprintf_buffer
	bl	strlen
	mov	r4,r0
.else
	ldr	r4,=sprintf_buffer-1
skip_characters:
	ldrb	r12,[r4,#1]!
	tst	r12,r12
	bne	skip_characters

	ldr	r12,=sprintf_buffer
	sub	r4,r4,r12
.endif

.if MY_ITOS
sprintf_buffer_to_string:
	ldr	r6,=sprintf_buffer
build_string:
.endif
	add	r3,r4,#3
	lsr	r3,r3,#2
	add	r3,r3,#2

	subs	r5,r5,r3
	bhs	D_to_S_no_gc

	str	r6,[sp,#-4]!
	bl	collect_0
	ldr	r6,[sp],#4

D_to_S_no_gc:
	subs	r3,r3,#2
	mov	r8,r10
	ldr	r12,=__STRING__+2
	str	r4,[r10,#4]
	str	r12,[r10],#8
	b	D_to_S_cp_str_2

D_to_S_cp_str_1:
	ldr	r4,[r6],#4
	str	r4,[r10],#4
D_to_S_cp_str_2:
	subs	r3,r3,#1
	bcs	D_to_S_cp_str_1

	mov	r6,r8
	ldr	pc,[sp],#4

eqD:	ldr	r4,[r6]
	ldr	r12,[r7]
	cmp	r4,r12
	bne	eqD_false

	ldr	r12,=INT+2
	cmp	r4,r12
	beq	eqD_INT
	ldr	r12,=CHAR+2
	cmp	r4,r12
	beq	eqD_CHAR
	ldr	r12,=BOOL+2
	cmp	r4,r12
	beq	eqD_BOOL
	ldr	r12,=REAL+2
	cmp	r4,r12
	beq	eqD_REAL

	mov	r4,#1
	ldr	pc,[sp],#4

eqD_CHAR:
eqD_INT:
	ldr	r3,[r6,#4]
	mov	r4,#0
	ldr	r12,[r7,#4]
	cmp	r3,r12
	moveq	r4,#1
	ldr	pc,[sp],#4

eqD_BOOL:
	ldrb	r3,[r6,#4]
	mov	r4,#0
	ldrb	r12,[r7,#4]
	cmp	r3,r12
	moveq	r4,#1
	ldr	pc,[sp],#4

eqD_REAL:
	vldr.f64 d0,[r6,#4]
	vldr.f64 d1,[r7,#4]
	mov	r4,#0
	vcmp.f64 d1,d0
	vmrs	APSR_nzcv,fpscr
	moveq	r4,#1
	ldr	pc,[sp],#4

eqD_false:
	mov	r4,#0
	ldr	pc,[sp],#4
@
@	the timer
@

init_timer:
	sub	sp,sp,#20
	mov	r0,sp
	bl	times
	ldr	r4,[sp]
	add	r4,r4,r4
	add	r4,r4,r4,lsl #2
	add	sp,sp,#20

	ldr	r12,=last_time
	str	r4,[r12]
	eor	r4,r4,r4
	ldr	r12,=execute_time
	str	r4,[r12]
	ldr	r12,=garbage_collect_time
	str	r4,[r12]
	ldr	r12,=IO_time
	str	r4,[r12]

	ldr	pc,[sp],#4

get_time_diff:
	sub	sp,sp,#20
	mov	r0,sp
	bl	times
	ldr	r4,[sp]
	add	r4,r4,r4
	add	r4,r4,r4,lsl #2
	add	sp,sp,#20

	ldr	r6,=last_time
	ldr	r7,[r6]
	str	r4,[r6]
	subs	r4,r4,r7
	ldr	pc,[sp],#4

add_execute_time:
	str	pc,[sp,#-4]!
	bl	get_time_diff
	ldr	r6,=execute_time

add_time:
	ldr	r12,[r6]
	add	r4,r4,r12
	str	r4,[r6]
	ldr	pc,[sp],#4

add_garbage_collect_time:
	str	pc,[sp,#-4]!
	bl	get_time_diff
	ldr	r6,=garbage_collect_time
	b	add_time

add_IO_time:
	str	pc,[sp,#-4]!
	bl	get_time_diff
	ldr	r6,=IO_time
	b	add_time

	.ltorg

@
@	the garbage collector
@

collect_3:
	str	lr,[sp,#-4]!
.ifdef PROFILE
	ldr	r8,=garbage_collector_name
	str	pc,[sp,#-4]!
	bl	profile_s
.endif
	str	r6,[r9]
	str	r7,[r9,#4]
	str	r8,[r9,#8]
	add	r9,r9,#12
	bl	collect_0_
	ldr	r8,[r9,#-4]
	ldr	r7,[r9,#-8]
	ldr	r6,[r9,#-12]!
.ifdef PROFILE
	b	profile_r
.else
	ldr	pc,[sp],#4
.endif

collect_2:
	str	lr,[sp,#-4]!
.ifdef PROFILE
	ldr	r8,=garbage_collector_name
	str	pc,[sp,#-4]!
	bl	profile_s
.endif
	str	r6,[r9]
	str	r7,[r9,#4]
	add	r9,r9,#8
	bl	collect_0_
	ldr	r7,[r9,#-4]
	ldr	r6,[r9,#-8]!
.ifdef PROFILE
	b	profile_r
.else
	ldr	pc,[sp],#4
.endif

collect_1:
	str	lr,[sp,#-4]!
.ifdef PROFILE
	ldr	r8,=garbage_collector_name
	str	pc,[sp,#-4]!
	bl	profile_s
.endif
	str	r6,[r9],#4
	bl	collect_0_
	ldr	r6,[r9,#-4]!
.ifdef PROFILE
	b	profile_r
.else
	ldr	pc,[sp],#4
.endif

.ifdef PROFILE
collect_0:
	str	lr,[sp,#-4]!
	ldr	r8,=garbage_collector_name
	str	pc,[sp,#-4]!
	bl	profile_s
	bl	collect_0_
	b	profile_r
.endif

.ifndef PROFILE
collect_0:
.endif
collect_0_:
	stmdb	sp!,{r0-r4,lr}

	ldr	r12,=heap_end_after_gc
	ldr	r12,[r12]
	sub	r8,r12,r10
	lsr	r8,r8,#2
	sub	r8,r8,r5
	ldr	r12,=n_allocated_words
	str	r8,[r12]

.if MARK_AND_COPY_GC
	ldr	r12,=flags
	ldrb	r12,[r12]
	tst	r12,#64
	beq	no_mark3
.endif

.if MARK_GC
	ldr	r12,=bit_counter
	ldr	r8,[r12]
	cmp	r8,#0
	beq	no_scan

	mov	r3,#0
	str	r9,[sp,#-4]!

	ldr	r12,=n_allocated_words
	ldr	r9,[r12]
	ldr	r12,=bit_vector_p
	ldr	r6,[r12]
	ldr	r12,=n_free_words_after_mark
	ldr	r2,[r12]

scan_bits:
	ldr	r12,[r6]
	cmp	r3,r12
	beq	zero_bits
	str	r3,[r6],#4
	subs	r8,r8,#1
	bne	scan_bits

	b	end_scan

zero_bits:
	add	r7,r6,#4
	add	r6,r6,#4
	subs	r8,r8,#1
	bne	skip_zero_bits_lp1
	b	end_bits

skip_zero_bits_lp:
	cmp	r4,#0
	bne	end_zero_bits
skip_zero_bits_lp1:
	ldr	r4,[r6],#4
	subs	r8,r8,#1
	bne	skip_zero_bits_lp

	cmp	r4,#0
	beq	end_bits
	str	r3,[r6,#-4]
	subs	r4,r6,r7
	b	end_bits2

end_zero_bits:
	sub	r4,r6,r7
	lsl	r4,r4,#3
	str	r3,[r6,#-4]
	add	r2,r2,r4

	cmp	r4,r9
	blo	scan_bits

found_free_memory:
	ldr	r12,=bit_counter
	str	r8,[r12]
	ldr	r12,=bit_vector_p
	str	r6,[r12]
	ldr	r12,=n_free_words_after_mark
	str	r2,[r12]

	sub	r5,r4,r9

	add	r8,r7,#-4
	ldr	r12,=heap_vector
	ldr	r12,[r12]
	subs	r8,r8,r12
	lsl	r8,r8,#5
	ldr	r12,=heap_p3
	ldr	r10,[r12]
	add	r10,r10,r8

	add	r8,r10,r4,lsl #2
	ldr	r12,=heap_end_after_gc
	str	r8,[r12]

	ldr	r9,[sp],#4

	ldmia	sp!,{r0-r4,pc}

end_bits:
	sub	r4,r6,r7
	add	r4,r4,#4
end_bits2:
	lsl	r4,r4,#3
	add	r2,r2,r4
	cmp	r4,r9
	bhs	found_free_memory

end_scan:
	ldr	r9,[sp],#4
	ldr	r12,=bit_counter
	str	r8,[r12]
	ldr	r12,=n_free_words_after_mark
	str	r2,[r12]

no_scan:
.endif

@ to do: check value in r8

.if MARK_AND_COPY_GC
no_mark3:
.endif

	ldr	r12,=garbage_collect_flag
	ldrsb	r4,[r12]
	cmp	r4,#0
	ble	collect

	sub	r4,r4,#2
	strb	r4,[r12]

	ldr	r12,=extra_heap_size
	ldr	r3,[r12]
	cmp	r8,r3
	bhi	collect

	sub	r5,r3,r8

	ldr	r12,=extra_heap
	ldr	r10,[r12]
	add	r3,r10,r3,lsl #2
	ldr	r12,=heap_end_after_gc
	str	r3,[r12]

	ldmia	sp!,{r0-r4,pc}

collect:
	str	pc,[sp,#-4]!
	bl	add_execute_time

	ldr	r12,=flags
	ldr	r12,[r12]
	tst	r12,#4
	beq	no_print_stack_sizes

	ldr	r0,=garbage_collect_string_1
	bl	ew_print_string

	mov	r4,r9
	ldr	r12,=stack_p
	ldr	r12,[r12]
	sub	r0,r4,r12
	bl	ew_print_int

	ldr	r0,=garbage_collect_string_2
	bl	ew_print_string

	ldr	r12,=halt_sp
	ldr	r4,[r12]
	sub	r0,r4,sp
	bl	ew_print_int

	ldr	r0,=garbage_collect_string_3
	bl	ew_print_string

no_print_stack_sizes:
	ldr	r12,=stack_p
	ldr	r4,[r12]
	ldr	r12,=ab_stack_size
	ldr	r12,[r12]
	add	r4,r4,r12
	cmp	r9,r4
	bhi	stack_overflow

.if MARK_AND_COPY_GC
	ldr	r12,=flags
	ldr	r12,[r12]
	tst	r12,#64
	bne	compacting_collector
.else
 .if MARK_GC
	b	compacting_collector
 .endif
.endif

.if MARK_AND_COPY_GC || !MARK_GC
	ldr	r12,=garbage_collect_flag
	ldrb	r12,[r12]
	cmp	r12,#0
	bne	compacting_collector

	ldr	r12,=heap_copied_vector
	ldr	r8,[r12]

	ldr	r12,=heap_end_after_copy_gc
	ldr	r12,[r12]
	cmp	r12,#0
	beq	zero_all

	mov	r4,r10
	ldr	r12,=heap_p1
	ldr	r12,[r12]
	subs	r4,r4,r12
	add	r4,r4,#63*4
	lsr	r4,r4,#8
	str	pc,[sp,#-4]!
	bl	zero_bit_vector

	ldr	r12,=heap_end_after_copy_gc
	ldr	r7,[r12]
	ldr	r12,=heap_p1
	ldr	r12,[r12]
	subs	r7,r7,r12
	lsr	r7,r7,#6
	and	r7,r7,#-4

	ldr	r12,=heap_copied_vector
	ldr	r8,[r12]
	ldr	r12,=heap_copied_vector_size
	ldr	r4,[r12]
	add	r8,r8,r7
	subs	r4,r4,r7
	lsr	r4,r4,#2

	ldr	r12,=heap_end_after_copy_gc
	mov	r14,#0
	str	r14,[r12]

	str	pc,[sp,#-4]!
	bl	zero_bit_vector
	b	end_zero_bit_vector

zero_all:
	ldr	r12,=heap_copied_vector_size
	ldr	r4,[r12]
	lsr	r4,r4,#2
	str	pc,[sp,#-4]!
	bl	zero_bit_vector

end_zero_bit_vector:

	.include "armcopy.s"

.if WRITE_HEAP
	ldr	r12,=heap2_begin_and_end
	str	r9,[r12]
.endif

	sub	r8,r9,r10
	lsr	r8,r8,#2

	ldr	r9,[sp],#4

	str	pc,[sp,#-4]!
	bl	add_garbage_collect_time

	ldr	r12,=n_allocated_words
	ldr	r12,[r12]
	subs	r8,r8,r12
	mov	r5,r8
	bls	switch_to_mark_scan

	add	r4,r8,r8,lsl #2
	lsl	r4,r4,#5
	ldr	r3,=heap_size
	ldr	r3,[r3]
	mov	r6,r3
	lsl	r3,r3,#2
	add	r3,r3,r6
	add	r3,r3,r3
	add	r3,r3,r6
	cmp	r4,r3
	bhs	no_mark_scan
@	b	no_mark_scan

switch_to_mark_scan:
	ldr	r12,=heap_size_33
	ldr	r4,[r12]
	lsl	r4,r4,#5
	ldr	r12,=heap_p
	ldr	r3,[r12]

	ldr	r12,=heap_p1
	ldr	r6,[r12]
	ldr	r12,=heap_p2
	ldr	r12,[r12]
	cmp	r6,r12
	bcc	vector_at_begin

vector_at_end:
	ldr	r12,=heap_p3
	str	r3,[r12]
	add	r3,r3,r4
	ldr	r12,=heap_vector
	str	r3,[r12]

	ldr	r12,=heap_p1
	ldr	r4,[r12]
	ldr	r12,=extra_heap
	str	r4,[r12]
	subs	r3,r3,r4
	lsr	r3,r3,#2
	ldr	r12,=extra_heap_size
	str	r3,[r12]
	b	switch_to_mark_scan_2

vector_at_begin:
	ldr	r12,=heap_vector
	str	r3,[r12]
	ldr	r12,=heap_size
	ldr	r12,[r12]
	add	r3,r3,r12
	subs	r3,r3,r4
	ldr	r12,=heap_p3
	str	r3,[r12]

	ldr	r12,=extra_heap
	str	r3,[r12]
	ldr	r12,=heap_p2
	ldr	r6,[r12]
	subs	r6,r6,r3
	lsr	r6,r6,#2
	ldr	r12,=extra_heap_size
	str	r6,[r12]

switch_to_mark_scan_2:
	ldr	r4,=heap_size
	ldr	r4,[r4]
	lsr	r4,r4,#3
	sub	r4,r4,r8
	lsl	r4,r4,#2

	ldr	r12,=garbage_collect_flag
	mov	r11,#1
	strb	r11,[r12]

	cmp	r8,#0
	bpl	end_garbage_collect

	mov	r11,#-1
	strb	r11,[r12]

	ldr	r12,=extra_heap_size
	ldr	r3,[r12]
	mov	r4,r3
	ldr	r12,=n_allocated_words
	ldr	r12,[r12]
	subs	r4,r4,r12
	bmi	out_of_memory_4

	ldr	r12,=extra_heap
	ldr	r10,[r12]
	lsl	r3,r3,#2
	add	r3,r3,r10
	ldr	r12,=heap_end_after_gc
	str	r3,[r12]
.if WRITE_HEAP
	ldr	r12,=heap_end_write_heap
	str	r10,[r12]
	ldr	r12,=d3_flag_write_heap
	mov	r11,#1
	str	r11,[r12]
	b	end_garbage_collect_
.else
	b	end_garbage_collect
.endif
no_mark_scan:
@ exchange the semi_spaces
	ldr	r12,=heap_p1
	ldr	r4,[r12]
	ldr	r12,=heap_p2
	ldr	r3,[r12]
	ldr	r12,=heap_p2
	str	r4,[r12]
	ldr	r12,=heap_p1
	str	r3,[r12]

	ldr	r12,=heap_size_129
	ldr	r4,[r12]
	lsl	r4,r4,#6-2

 .ifdef MUNMAP
	ldr	r12,=heap_p2
	ldr	r3,[r12]
	add	r6,r3,r4,lsl #2
	add	r3,r3,#4095
	and	r3,r3,#-4096
	and	r6,r6,#-4096
	subs	r6,r6,r3
	bls	no_pages
	str	r4,[sp,#-4]!

	str	r6,[sp,#-4]!
	str	r3,[sp,#-4]!
	str	pc,[sp,#-4]!
	bl	_munmap
	add	sp,sp,#8

	ldr	r4,[sp],#4
no_pages:
 .endif

 .if ADJUST_HEAP_SIZE
	mov	r3,r4
 .endif
	subs	r4,r4,r8

 .if ADJUST_HEAP_SIZE
	mov	r6,r4
	ldr	r12,=heap_size_multiple
	ldr	r12,[r12]
	umull	r4,r7,r12,r4
	lsr	r4,r4,#9
	orr	r4,r4,r7,lsl #32-9
	lsrs	r7,r7,#9
	bne	no_small_heap1

	cmp	r4,#MINIMUM_HEAP_SIZE_2
	bhs	not_too_small1
	mov	r4,#MINIMUM_HEAP_SIZE_2
not_too_small1:
	subs	r3,r3,r4
	blo	no_small_heap1

	sub	r5,r5,r3
	lsl	r3,r3,#2
	ldr	r12,=heap_end_after_gc
	ldr	r8,[r12]
	ldr	r12,=heap_end_after_copy_gc
	str	r8,[r12]
	sub	r8,r8,r3
	ldr	r12,=heap_end_after_gc
	str	r8,[r12]

no_small_heap1:
	mov	r4,r6
 .endif

	lsl	r4,r4,#2
.endif

end_garbage_collect:
.if WRITE_HEAP
	ldr	r12,=heap_end_write_heap
	str	r10,[r12]
	ldr	r12,=d3_flag_write_heap
	mov	r11,#0
	str	r11,[r12]
end_garbage_collect_:
.endif

	str	r4,[sp,#-4]!

	ldr	r12,=flags
	ldr	r12,[r12]
	tst	r12,#2
	beq	no_heap_use_message

	str	r4,[sp,#-4]!

	ldr	r0,=heap_use_after_gc_string_1
	bl	ew_print_string

	ldr	r0,[sp],#4
	bl	ew_print_int

	ldr	r0,=heap_use_after_gc_string_2
	bl	ew_print_string

no_heap_use_message:

.if FINALIZERS
	str	pc,[sp,#-4]!
	bl	call_finalizers
.endif

	ldr	r4,[sp],#4

.if WRITE_HEAP
	@ Check whether memory profiling is on or off
	ldr	r12,=flags
	ldrb	r12,[r12]
	tst	r12,#32
	beq	no_write_heap

	ldr	r12,=min_write_heap_size
	ldr	r12,[r12]
	cmp	r4,r12
	blo	no_write_heap

	str	r6,[sp,#-4]!
	str 	r7,[sp,#-4]!
	str	r8,[sp,#-4]!
	str	r9,[sp,#-4]!
	str	r10,[sp,#-4]!

	subs	sp,sp,#64

	ldr	r12,=d3_flag_write_heap
	ldr	r4,[r12]
	tst	r4,r4
	bne	copy_to_compact_with_alloc_in_extra_heap	

	ldr	r4,=garbage_collect_flag
	ldrsb	r4,[r4]

	ldr	r12,=heap2_begin_and_end
	ldr	r6,[r12]
	ldr	r12,=heap2_begin_and_end+4
	ldr	r7,[r12]

	ldr	r3,=heap_p1

	tst	r4,r4
	beq	gc0

	ldr	r3,=heap_p2
	bgt	gc1

	ldr	r3,=heap_p3
	mov	r6,#0
	mov	r7,#0

gc0:
gc1:
	ldr	r3,[r3]

?	/* fill record */

	mov	r4,sp

	str	r3,[r4,#0]
?	movl	a4,4(d0)			// klop dit?

?	movl	a0,8(d0)			// heap2_begin
?	movl	a1,12(d0)			// heap2_end

	ldr	r12,=stack_p
	ldr	r3,[r12]
?	movl	d1,16(d0)			// stack_begin

?	movl	a3,20(d0)			// stack_end
?	movl	$0,24(d0)			// text_begin
?	movl	$0,28(d0)			// data_begin

?	movl	$small_integers,32(d0)	// small_integers
?	movl	$static_characters,36(d0)	// small_characters

?	movl	$INT+2,40(d0)		// INT-descP
?	movl	$CHAR+2,44(d0)		// CHAR-descP
?	movl	$REAL+2,48(d0)		// REAL-descP
?	movl	$BOOL+2,52(d0)		// BOOL-descP
?	movl	$__STRING__+2,56(d0)	// STRING-descP
?	movl	$__ARRAY__+2,60(d0)		// ARRAY-descP

	str	r4,[sp,#-4]!
	bl	write_heap

	add	sp,sp,#68

	ldr	r10,[sp],#4
	ldr	r9,[sp],#4
	ldr	r8,[sp],#4
	ldr	r7,[sp],#4
	ldr	r6,[sp],#4
no_write_heap:

.endif

	ldmia	sp!,{r0-r4,pc}

	.ltorg

.if FINALIZERS
call_finalizers:
	ldr	r12,=free_finalizer_list
	ldr	r4,[r12]

call_finalizers_lp:
	ldr	r12,=__Nil-4
	cmp	r4,r12
	beq	end_call_finalizers
	ldr	r12,[r4,#4]
	str	r12,[sp,#-4]!
	ldr	r3,[r4,#8]
	ldr	r12,[r3,#4]
	str	r12,[sp,#-4]!
	ldr	r12,[r3]
	blx	r12
	add	sp,sp,#4
	ldr	r4,[sp],#4
	b	call_finalizers_lp
end_call_finalizers:
	ldr	r12,=free_finalizer_list
	ldr	r11,=__Nil-4
	str	r11,[r12]
	ldr	pc,[sp],#4
.endif

.if WRITE_HEAP
copy_to_compact_with_alloc_in_extra_heap:
	ldr	r12,=heap2_begin_and_end
	ldr	r6,[r12]
	ldr	r12,=heap2_begin_and_end+4
	ldr	r7,[r12]
	ldr	r3,=heap_p2
	b	gc1
.endif

out_of_memory_4:
	str	pc,[sp,#-4]!
	bl	add_garbage_collect_time

	ldr	r8,=out_of_memory_string_4
	b	print_error

zero_bit_vector:
	eor	r7,r7,r7
	tst	r4,#1
	beq	zero_bits1_1
	str	r7,[r8]
	add	r8,r8,#4
zero_bits1_1:
	lsr	r4,r4,#1

	mov	r3,r4
	lsr	r4,r4,#1
	tst	r3,#1
	beq	zero_bits1_5

	subs	r8,r8,#8
	b	zero_bits1_2

zero_bits1_4:
	str	r7,[r8]
	str	r7,[r8,#4]
zero_bits1_2:
	str	r7,[r8,#8]
	str	r7,[r8,#12]
	add	r8,r8,#16
zero_bits1_5:
	subs	r4,r4,#1
	bhs	zero_bits1_4
	ldr	pc,[sp],#4

reorder:
	str	r9,[sp,#-4]!
	str	r8,[sp,#-4]!

	mov	r8,r4
	lsl	r8,r8,#2
	mov	r9,r3
	lsl	r9,r9,#2
	add	r6,r6,r9
	subs	r7,r7,r8

	str	r9,[sp,#-4]!
	str	r8,[sp,#-4]!
	str	r3,[sp,#-4]!
	str	r4,[sp,#-4]!
	b	st_reorder_lp

reorder_lp:
	ldr	r8,[r6]
	ldr	r9,[r7,#-4]
	str	r8,[r7,#-4]
	subs	r7,r7,#4
	str	r9,[r6]
	add	r6,r6,#4

	subs	r4,r4,#1
	bne	next_b_in_element
	ldr	r4,[sp]
	ldr	r12,[sp,#12]
	add	r6,r6,r12
next_b_in_element:
	subs	r3,r3,#1
	bne	next_a_in_element
	ldr	r3,[sp,#4]
	ldr	r12,[sp,#8]
	subs	r7,r7,r12
next_a_in_element:
st_reorder_lp:
	cmp	r7,r6
	bhi	reorder_lp

	ldr	r4,[sp],#4
	ldr	r3,[sp],#4
	add	sp,sp,#8
	ldr	r8,[sp],#4
	ldr	r9,[sp],#4
	ldr	pc,[sp],#4

@
@	the sliding compacting garbage collector
@

compacting_collector:
@ zero all mark bits

	ldr	r12,=stack_top
	str	r9,[r12]

	ldr	r12,=heap_vector
	ldr	r10,[r12]

.if MARK_GC
 .if MARK_AND_COPY_GC
 	ldr	r12,=flags
 	ldrb	r12,[r12]
	tst	r12,#64
	beq	no_mark4
 .endif
 	ldr	r12,=zero_bits_before_mark
 	ldr	r11,[r12]
 	cmp	r11,#0
	beq	no_zero_bits

	mov	r11,#0
	str	r11,[r12]

 .if MARK_AND_COPY_GC
no_mark4:
 .endif
.endif

	mov	r8,r10
	ldr	r12,=heap_size_33
	ldr	r4,[r12]
	add	r4,r4,#3
	lsr	r4,r4,#2

	mov	r3,#0

	tst	r4,#1
	beq	zero_bits_1
	str	r3,[r8],#4
zero_bits_1:
	mov	r6,r4
	lsr	r4,r4,#2

	tst	r6,#2
	beq	zero_bits_5

	subs	r8,r8,#8
	b	zero_bits_2

zero_bits_4:
	str	r3,[r8]
	str	r3,[r8,#4]
zero_bits_2:
	str	r3,[r8,#8]
	str	r3,[r8,#12]
	add	r8,r8,#16
zero_bits_5:
	subs	r4,r4,#1
	bcs	zero_bits_4

.if MARK_GC
 .if MARK_AND_COPY_GC
 	ldr	r12,=flags
 	ldrb	r12,[r12]
 	tst	r12,#64
	beq	no_mark5
 .endif
no_zero_bits:
	ldr	r12,=n_last_heap_free_bytes
	ldr	r4,[r12]
	ldr	r12,=n_free_words_after_mark
	ldr	r3,[r12]

.if 1
	lsr	r4,r4,#2
.else
	lsl	r3,r3,#2
.endif

	add	r8,r3,r3,lsl #3
	lsr	r8,r8,#2

	cmp	r4,r8
	bgt	compact_gc

 .if ADJUST_HEAP_SIZE
	ldr	r12,=bit_vector_size
	ldr	r3,[r12]
	lsl	r3,r3,#2

	sub	r4,r3,r4

	ldr	r12,=heap_size_multiple
	ldr	r12,[r12]
	umull	r4,r7,r12,r4
	lsr	r4,r4,#7
	orr	r4,r4,r7,lsl #32-7
	lsrs	r7,r7,#7
	bne	no_smaller_heap

	cmp	r4,r3
	bhs	no_smaller_heap

	cmp	r3,#MINIMUM_HEAP_SIZE
	bls	no_smaller_heap

	b	compact_gc
no_smaller_heap:
 .endif

	.include "armmark.s"

compact_gc:
	ldr	r12,=zero_bits_before_mark
	mov	r11,#1
	str	r11,[r12]
	ldr	r12,=n_last_heap_free_bytes
	mov	r11,#0
	str	r11,[r12]
	ldr	r12,=n_free_words_after_mark
	mov	r11,#1000
	str	r11,[r12]
 .if MARK_AND_COPY_GC
no_mark5:
 .endif
.endif

	.include "armcompact.s"

	ldr	r12,=stack_top
	ldr	r9,[r12]

	ldr	r12,=heap_size_33
	ldr	r3,[r12]
	lsl	r3,r3,#5
	ldr	r12,=heap_p3
	ldr	r12,[r12]
	add	r3,r3,r12

	ldr	r12,=heap_end_after_gc
	str	r3,[r12]

	subs	r3,r3,r10
	lsr	r3,r3,#2

	ldr	r12,=n_allocated_words
	ldr	r12,[r12]
	subs	r3,r3,r12
	mov	r5,r3
	bcc	out_of_memory_4

	ldr	r12,=107374182
	cmp	r3,r12
	bhs	not_out_of_memory
	add	r4,r3,r3,lsl #2
	lsl	r4,r4,#3
	ldr	r12,=heap_size
	ldr	r12,[r12]
	cmp	r4,r12
	bcc	out_of_memory_4
not_out_of_memory:

.if MARK_GC || COMPACT_GC_ONLY
 .if MARK_GC && ADJUST_HEAP_SIZE
  .if MARK_AND_COPY_GC
  	ldr	r12,=flags
  	ldrb	r12,[r12]
  	tst	r12,#64
	beq	no_mark_6
  .endif

	ldr	r12,=heap_p3
	ldr	r4,[r12]
	sub	r4,r10,r4
	ldr	r12,=n_allocated_words
	ldr	r3,[r12]
	add	r4,r4,r3,lsl #2

	ldr	r12,=heap_size_33
	ldr	r3,[r12]
	lsl	r3,r3,#5

	ldr	r12,=heap_size_multiple
	ldr	r12,[r12]
	umull	r4,r7,r12,r4
	lsr	r4,r4,#8
	orr	r4,r4,r7,lsl #32-8
	lsrs	r7,r7,#8
	bne	no_small_heap2

	and	r4,r4,#-4

	cmp	r4,#MINIMUM_HEAP_SIZE
	bhs	not_too_small2
	mov	r4,#MINIMUM_HEAP_SIZE
not_too_small2:
	mov	r6,r3
	subs	r6,r6,r4
	blo	no_small_heap2

	ldr	r12,=heap_end_after_gc
	ldr	r11,[r12]
	sub	r11,r11,r6
	str	r11,[r12]

	sub	r5,r5,r6,lsr #2

	mov	r3,r4

no_small_heap2:
	lsr	r3,r3,#2
	ldr	r12,=bit_vector_size
	str	r3,[r12]

  .if MARK_AND_COPY_GC
no_mark_6:
  .endif
 .endif
	b	no_copy_garbage_collection
.else
@ to do prevent overflow
	lsl	r4,r4,#2
	ldr	r12,=heap_size
	ldr	r12,[r12]
	lsl	r6,r12,#5
	sub	r6,r6,r12
	cmp	r4,r6
	ble	no_copy_garbage_collection

	ldr	r12,=heap_p
	ldr	r4,[r12]
	ldr	r12,=heap_p1
	str	r4,[r12]

	ldr	r12,=heap_size_129
	ldr	r3,[r12]
	lsl	r3,r3,#6
	add	r4,r4,r3
	ldr	r12,=heap_copied_vector
	str	r4,[r12]
	ldr	r12,=heap_end_after_gc
	str	r4,[r12]
	ldr	r12,=heap_copied_vector_size
	ldr	r3,[r12]
	add	r3,r3,r4
	ldr	r12,=heap_p2
	str	r3,[r12]

	ldr	r12,=heap_p3
	ldr	r4,[r12]
	ldr	r12,=heap_vector
	ldr	r12,[r12]
	cmp	r4,r12
	ble	vector_at_end_2

	ldr	r12,=heap_vector
	ldr	r3,[r12]
	ldr	r12,=extra_heap
	str	r3,[r12]
	subs	r4,r4,r3
	lsr	r4,r4,#2
	ldr	r12,=extra_heap_size
	str	r4,[r12]

	ldr	r12,=garbage_collect_flag
	mov	r11,#2
	strb	r11,[r12]
	b	no_copy_garbage_collection

vector_at_end_2:
	ldr	r12,=garbage_collect_flag
	mov	r11,#0
	strb	r11,[r12]
.endif

no_copy_garbage_collection:
	str	pc,[sp,#-4]!
	bl	add_garbage_collect_time

	mov	r4,r10
	ldr	r12,=heap_p3
	ldr	r12,[r12]
	subs	r4,r4,r12
	ldr	r12,=n_allocated_words
	ldr	r3,[r12]
	add	r4,r4,r3,lsl #2
	b	end_garbage_collect

stack_overflow:
	str	pc,[sp,#-4]!
	bl	add_execute_time

	ldr	r8,=stack_overflow_string
	b	print_error

IO_error:
	str	r0,[sp]

	ldr	r0,=IO_error_string
	bl	ew_print_string

	ldr	r0,[sp],#4
	bl	ew_print_string

	ldr	r0,=new_line_string
	bl	ew_print_string

	b	halt

print_error:
	mov	r0,r8
	bl	ew_print_string

halt:
	ldr	r12,=halt_sp
	ldr	sp,[r12]

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	write_profile_stack
.endif

	b	exit

	.ltorg

e__system__eaind:
__eaind:
eval_fill:
	str	r6,[r9],#4
	mov	r6,r7
	ldr	r12,[r7]
	str	pc,[sp,#-4]!
	blx	r12
	mov	r7,r6
	ldr	r6,[r9,#-4]!

	ldr	r8,[r7]
	str	r8,[r6]
	ldr	r8,[r7,#4]
	str	r8,[r6,#4]
	ldr	r8,[r7,#8]
	str	r8,[r6,#8]
	ldr	pc,[sp],#4

	.p2align	2
	b	e__system__eaind
	nop
	nop
	.long	e__system__dind
	.long	-2
e__system__nind:
__indirection:
	ldr	r7,[r6,#4]
	ldr	r4,[r7]
	tst	r4,#2
.if MARK_GC
	beq	eval_fill2
.else
	beq	__cycle__in__spine
.endif
	str	r4,[r6]
	ldr	r8,[r7,#4]
	str	r8,[r6,#4]
	ldr	r8,[r7,#8]
	str	r8,[r6,#8]
	ldr	pc,[sp],#4

.if MARK_GC
eval_fill2:
	ldr	r12,=__cycle__in__spine
	str	r12,[r6]
	str	r6,[r9]
 .if MARK_AND_COPY_GC
 	ldr	r12,=flags
 	ldrb	r12,[r12]
 	tst	r12,#64
	beq	__cycle__in__spine	
 .endif
	add	r9,r9,#4
	mov	r6,r7
	
	str	pc,[sp,#-4]!
	blx	r4
	mov	r7,r6
	ldr	r6,[r9,#-4]!

	ldr	r8,[r7]
	str	r8,[r6]
	ldr	r8,[r7,#4]
	str	r8,[r6,#4]
	ldr	r8,[r7,#8]
	str	r8,[r6,#8]
	ldr	pc,[sp],#4
.endif

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_0:
	ldr	r12,=__indirection
	str	r12,[r7]
	str	r6,[r7,#4]
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_1:
	ldr	r12,=__indirection
	str	r12,[r7]
	ldr	r4,[r7,#4]
	str	r6,[r7,#4]
	mov	r7,r4
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_2:
	ldr	r12,=__indirection
	str	r12,[r7]
	ldr	r8,[r7,#4]
	str	r6,[r7,#4]
	ldr	r7,[r7,#8]
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_3:
	ldr	r12,=__indirection
	str	r12,[r7]
	ldr	r8,[r7,#4]
	str	r6,[r7,#4]
	str	r6,[r9],#4
	ldr	r6,[r7,#12]
	ldr	r7,[r7,#8]
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_4:
	ldr	r12,=__indirection
	str	r12,[r7]
	ldr	r8,[r7,#4]
	str	r6,[r7,#4]
	str	r6,[r9]
	ldr	r3,[r7,#16]
	str	r3,[r9,#4]
	add	r9,r9,#8
	ldr	r6,[r7,#12]
	ldr	r7,[r7,#8]
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_5:
	ldr	r12,=__indirection
	str	r12,[r7]
	ldr	r8,[r7,#4]
	str	r6,[r9]
	str	r6,[r7,#4]
	ldr	r3,[r7,#20]
	str	r3,[r9,#4]
	ldr	r3,[r7,#16]
	str	r3,[r9,#8]
	add	r9,r9,#12
	ldr	r6,[r7,#12]
	ldr	r7,[r7,#8]
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_6:
	ldr	r12,=__indirection
	str	r12,[r7]
	ldr	r8,[r7,#4]
	str	r6,[r9]
	str	r6,[r7,#4]
	ldr	r3,[r7,#24]
	str	r3,[r9,#4]
	ldr	r3,[r7,#20]
	str	r3,[r9,#8]
	ldr	r3,[r7,#16]
	str	r3,[r9,#12]
	add	r9,r9,#16
	ldr	r6,[r7,#12]
	ldr	r7,[r7,#8]
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_7:
	mov	r4,#0
	mov	r3,#20
eval_upd_n:
	ldr	r12,=__indirection
	add	r2,r7,r3
	str	r12,[r7]
	ldr	r8,[r7,#4]
	str	r6,[r9]
	str	r6,[r7,#4]
	ldr	r3,[r2,#8]
	str	r3,[r9,#4]
	ldr	r3,[r2,#4]
	str	r3,[r9,#8]
	ldr	r3,[r2]
	str	r3,[r9,#12]
	add	r9,r9,#16

eval_upd_n_lp:
	ldr	r3,[r2,#-4]!
	str	r3,[r9],#4
	subs	r4,r4,#1
	bcs	eval_upd_n_lp

	ldr	r6,[r7,#12]
	ldr	r7,[r7,#8]
	mov	pc,r11

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_8:
	mov	r4,#1
	mov	r3,#24
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_9:
	mov	r4,#2
	mov	r3,#28
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_10:
	mov	r4,#3
	mov	r3,#32
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_11:
	mov	r4,#4
	mov	r3,#36
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_12:
	mov	r4,#5
	mov	r3,#40
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_13:
	mov	r4,#6
	mov	r3,#44
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_14:
	mov	r4,#7
	mov	r3,#48
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_15:
	mov	r4,#8
	mov	r3,#52
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_16:
	mov	r4,#9
	mov	r3,#56
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_17:
	mov	r4,#10
	mov	r3,#60
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_18:
	mov	r4,#11
	mov	r3,#64
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_19:
	mov	r4,#12
	mov	r3,#68
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_20:
	mov	r4,#13
	mov	r3,#72
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_21:
	mov	r4,#14
	mov	r3,#76
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_22:
	mov	r4,#15
	mov	r3,#80
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_23:
	mov	r4,#16
	mov	r3,#84
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_24:
	mov	r4,#17
	mov	r3,#88
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_25:
	mov	r4,#18
	mov	r3,#92
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_26:
	mov	r4,#19
	mov	r3,#96
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_27:
	mov	r4,#20
	mov	r3,#100
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_28:
	mov	r4,#21
	mov	r3,#104
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_29:
	mov	r4,#22
	mov	r3,#108
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_30:
	mov	r4,#23
	mov	r3,#112
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_31:
	mov	r4,#24
	mov	r3,#116
	b	eval_upd_n

.ifdef PROFILE
	str	pc,[sp,#-4]!
	bl	profile_n
	mov	r8,r4
.endif
eval_upd_32:
	mov	r4,#25
	mov	r3,#120
	b	eval_upd_n

@
@	STRINGS
@

	.section .text.	(catAC)
catAC:
	ldr	r4,[r6,#4]
	ldr	r3,[r7,#4]
	add	r8,r4,r3
	add	r8,r8,#8+3
	lsr	r8,r8,#2

	subs	r5,r5,r8
	blo	gc_3
gc_r_3:
	add	r6,r6,#8
	add	r7,r7,#8

@ fill_node

	str	r10,[sp,#-4]!
	ldr	r12,=__STRING__+2
	str	r12,[r10]

@ store length

	add	r8,r4,r3
	str	r8,[r10,#4]
	add	r10,r10,#8

@ copy string 1

	add	r8,r3,#3
	add	r3,r3,r10
	lsrs	r8,r8,#2
	beq	catAC_after_copy_lp1

catAC_copy_lp1:
	ldr	r12,[r7],#4
	str	r12,[r10],#4
	subs	r8,r8,#1
	bne	catAC_copy_lp1

catAC_after_copy_lp1:
	mov	r10,r3

@ copy_string 2

cat_string_6:
	lsrs	r8,r4,#2
	beq	cat_string_9

cat_string_7:
	ldr	r3,[r6],#4
@ store not aligned
	str	r3,[r10],#4
	subs	r8,r8,#1
	bne	cat_string_7

cat_string_9:
	tst	r4,#2
	beq	cat_string_10
	ldrh	r3,[r6],#2
	strh	r3,[r10],#2
cat_string_10:
	tst	r4,#1
	beq	cat_string_11
	ldrb	r3,[r6]
	strb	r3,[r10],#1
cat_string_11:

	ldr	r6,[sp],#4
@ align heap pointer
	add	r10,r10,#3
	and	r10,r10,#-4
	ldr	pc,[sp],#4

gc_3:	bl	collect_2
	b	gc_r_3

empty_string:
	ldr	r6,=zero_length_string
	ldr	pc,[sp],#4

	.section .text.sliceAC,"ax"
sliceAC:
	ldr	r8,[r6,#4]
	tst	r3,r3
	bpl	slice_string_1
	mov	r3,#0
slice_string_1:
	cmp	r3,r8
	bge	empty_string
	cmp	r4,r3
	blt	empty_string
	add	r4,r4,#1
	cmp	r4,r8
	ble	slice_string_2
	mov	r4,r8
slice_string_2:
	subs	r4,r4,r3

	add	r8,r4,#8+3
	lsr	r8,r8,#2

	subs	r5,r5,r8	
	blo	gc_4
r_gc_4:
	subs	r8,r8,#2
	add	r12,r6,#8
	add	r7,r12,r3

	ldr	r12,=__STRING__+2
	str	r12,[r10]
	str	r4,[r10,#4]

@ copy part of string
	mov	r6,r10
	add	r10,r10,#8

	cmp	r8,#0
	beq	sliceAC_after_copy_lp
	
sliceAC_copy_lp:
@ load not aligned
	ldr	r12,[r7],#4
	str	r12,[r10],#4
	subs	r8,r8,#1
	bne	sliceAC_copy_lp
		
sliceAC_after_copy_lp:
	ldr	pc,[sp],#4

gc_4:
	bl	collect_1
	add	r8,r4,#8+3
	lsr	r8,r8,#2
	b	r_gc_4

	.section .text.updateAC,"ax"
updateAC:
	ldr	r8,[r6,#4]
	cmp	r3,r8
	bhs	update_string_error

	add	r8,r8,#8+3
	lsr	r8,r8,#2

	subs	r5,r5,r8
	blo	gc_5
r_gc_5:
	ldr	r8,[r6,#4]
	add	r8,r8,#3
	lsr	r8,r8,#2

	mov	r7,r6
	mov	r6,r10

	ldr	r12,=__STRING__+2
	str	r12,[r10]
	ldr	r12,[r7,#4]
	add	r7,r7,#8
	str	r12,[r10,#4]
	add	r10,r10,#8

	add	r3,r3,r10

	cmp	r8,#0
	beq	updateAC_after_copy_lp

updateAC_copy_lp:
	ldr	r12,[r7],#4
	str	r12,[r10],#4
	subs	r8,r8,#1
	bne	updateAC_copy_lp

updateAC_after_copy_lp:
	strb	r4,[r3]

	ldr	pc,[sp],#4

gc_5:	bl	collect_1
	b	r_gc_5

update_string_error:
	ldr	r8,=high_index_string
	tst	r4,r4
	bpl	update_string_error_2
	ldr	r8,=low_index_string
update_string_error_2:
	b	print_error

	.section .text.eqAC,"ax"
eqAC:
	ldr	r4,[r6,#4]
	ldr	r12,[r7,#4]
	cmp	r4,r12
	bne	equal_string_ne
	add	r6,r6,#8
	add	r7,r7,#8
	and	r3,r4,#3
	lsrs	r4,r4,#2
	beq	equal_string_b
equal_string_1:
	ldr	r8,[r6]
	ldr	r12,[r7]
	cmp	r8,r12
	bne	equal_string_ne
	add	r6,r6,#4
	add	r7,r7,#4
	subs	r4,r4,#1
	bne	equal_string_1
equal_string_b:
	tst	r3,#2
	beq	equal_string_2
	ldrh	r4,[r6]
	ldrh	r12,[r7]
	cmp	r4,r12
	bne	equal_string_ne
	add	r6,r6,#2
	add	r7,r7,#2
equal_string_2:
	tst	r3,#1
	beq	equal_string_eq
	ldrb	r3,[r6]
	ldrb	r12,[r7]
	cmp	r3,r12
	bne	equal_string_ne
equal_string_eq:
	mov	r4,#1
	ldr	pc,[sp],#4
equal_string_ne:
	mov	r4,#0
	ldr	pc,[sp],#4

	.section .text.cmpAC,"ax"
cmpAC:
	ldr	r3,[r6,#4]
	ldr	r8,[r7,#4]
	add	r6,r6,#8
	add	r7,r7,#8
	cmp	r8,r3
	blo	cmp_string_less
	bhi	cmp_string_more
	mov	r4,#0
	b	cmp_string_chars
cmp_string_more:
	mov	r4,#1
	b	cmp_string_chars
cmp_string_less:
	mov	r4,#-1
	mov	r3,r8
	b	cmp_string_chars

cmp_string_1:
	ldr	r8,[r7]
	ldr	r12,[r6]
	cmp	r8,r12
	bne	cmp_string_ne4
	add	r7,r7,#4
	add	r6,r6,#4
cmp_string_chars:
	subs	r3,r3,#4
	bcs	cmp_string_1
cmp_string_b:
@ to do compare bytes using and instead of ldrb
	tst	r3,#2
	beq	cmp_string_2
	ldrb	r8,[r7]
	ldrb	r12,[r6]
	cmp	r8,r12
	bne	cmp_string_ne
	ldrb	r8,[r7,#1]
	ldrb	r12,[r6,#1]
	cmp	r8,r12
	bne	cmp_string_ne
	add	r7,r7,#2
	add	r6,r6,#2
cmp_string_2:
	tst	r3,#1
	beq	cmp_string_eq
	ldrb	r8,[r7]
	ldrb	r12,[r6]
	cmp	r8,r12
	bne	cmp_string_ne
cmp_string_eq:
	ldr	pc,[sp],#4
cmp_string_ne4:
@ to do compare bytes using and instead of ldrb
	ldrb	r3,[r7]
	ldrb	r12,[r6]
	cmp	r3,r12
	bne	cmp_string_ne
	ldrb	r3,[r7,#1]
	ldrb	r12,[r6,#1]
	cmp	r3,r12
	bne	cmp_string_ne
	ldrb	r3,[r7,#2]
	ldrb	r12,[r6,#2]
	cmp	r3,r12
	bne	cmp_string_ne
	ldrb	r3,[r7,#3]
	ldrb	r12,[r6,#3]
	cmp	r3,r12
cmp_string_ne:
	bhi	cmp_string_r1
	mov	r4,#-1
	ldr	pc,[sp],#4
cmp_string_r1:
	mov	r4,#1
	ldr	pc,[sp],#4

	.section .text.string_to_string_node,"ax"
string_to_string_node:
	ldr	r4,[r6],#4

	add	r3,r4,#3
	lsr	r3,r3,#2

	add	r12,r3,#2
	subs	r5,r5,r12
	blo	string_to_string_node_gc

string_to_string_node_r:
	ldr	r12,=__STRING__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	mov	r8,r10
	add	r10,r10,#8
	b	string_to_string_node_4

string_to_string_node_2:
	ldr	r4,[r6],#4
	str	r4,[r10],#4
string_to_string_node_4:
	subs	r3,r3,#1
	bge	string_to_string_node_2

	mov	r6,r8
	ldr	pc,[sp],#4

string_to_string_node_gc:
	str	r6,[sp,#-4]!
	bl	collect_0
	ldr	r6,[sp],#4
	b	string_to_string_node_r

	.section .text.int_array_to_node,"ax"
int_array_to_node:
	ldr	r4,[r6,#-8]

	add	r12,r4,#3
	subs	r5,r5,r12
	blo	int_array_to_node_gc

int_array_to_node_r:
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	mov	r7,r6
	str	r4,[r10,#4]
	mov	r6,r10
	ldr	r12,=INT+2
	str	r12,[r10,#8]
	add	r10,r10,#12
	b	int_array_to_node_4

int_array_to_node_2:
	ldr	r3,[r7],#4
	str	r3,[r10],#4
int_array_to_node_4:
	subs	r4,r4,#1
	bge	int_array_to_node_2

	ldr	pc,[sp],#4

int_array_to_node_gc:
	str	r6,[sp,#-4]!
	bl	collect_0
	ldr	r6,[sp],#4
	b	int_array_to_node_r

	.section .text.real_array_to_node,"ax"
real_array_to_node:
	ldr	r4,[r6,#-8]

	add	r12,r4,#3+1
	subs	r5,r5,r12
	blo	real_array_to_node_gc

real_array_to_node_r:
	tst	r10,#4
	orr	r10,r10,#4
	addne	r5,r5,#1
	mov	r7,r6
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	mov	r6,r10
	ldr	r12,=REAL+2
	str	r12,[r10,#8]
	add	r10,r10,#12
	b	real_array_to_node_4

real_array_to_node_2:
	ldr	r3,[r7]
	str	r3,[r10]
	ldr	r8,[r7,#4]
	add	r7,r7,#8
	str	r8,[r10,#4]
	add	r10,r10,#8
real_array_to_node_4:
	subs	r4,r4,#1
	bge	real_array_to_node_2

	ldr	pc,[sp],#4

real_array_to_node_gc:
	str	r6,[sp,#-4]!
	bl	collect_0
	ldr	r6,[sp],#4
	b	real_array_to_node_r

	.p2align	2
	.long	3
_c3:	b	__cycle__in__spine
	.p2align	2

	.long	4
_c4:	b	__cycle__in__spine
	.p2align	2
	.long	5
_c5:	b	__cycle__in__spine
	.p2align	2
	.long	6
_c6:	b	__cycle__in__spine
	.p2align	2
	.long	7
_c7:	b	__cycle__in__spine
	.p2align	2
	.long	8
_c8:	b	__cycle__in__spine
	.p2align	2
	.long	9
_c9:	b	__cycle__in__spine
	.p2align	2
	.long	10
_c10:	b	__cycle__in__spine
	.p2align	2
	.long	11
_c11:	b	__cycle__in__spine
	.p2align	2
	.long	12
_c12:	b	__cycle__in__spine
	.p2align	2
	.long	13
_c13:	b	__cycle__in__spine
	.p2align	2
	.long	14
_c14:	b	__cycle__in__spine
	.p2align	2
	.long	15
_c15:	b	__cycle__in__spine
	.p2align	2
	.long	16
_c16:	b	__cycle__in__spine
	.p2align	2
	.long	17
_c17:	b	__cycle__in__spine
	.p2align	2
	.long	18
_c18:	b	__cycle__in__spine
	.p2align	2
	.long	19
_c19:	b	__cycle__in__spine
	.p2align	2
	.long	20
_c20:	b	__cycle__in__spine
	.p2align	2
	.long	21
_c21:	b	__cycle__in__spine
	.p2align	2
	.long	22
_c22:	b	__cycle__in__spine
	.p2align	2
	.long	23
_c23:	b	__cycle__in__spine
	.p2align	2
	.long	24
_c24:	b	__cycle__in__spine
	.p2align	2
	.long	25
_c25:	b	__cycle__in__spine
	.p2align	2
	.long	26
_c26:	b	__cycle__in__spine
	.p2align	2
	.long	27
_c27:	b	__cycle__in__spine
	.p2align	2
	.long	28
_c28:	b	__cycle__in__spine
	.p2align	2
	.long	29
_c29:	b	__cycle__in__spine
	.p2align	2
	.long	30
_c30:	b	__cycle__in__spine
	.p2align	2
	.long	31
_c31:	b	__cycle__in__spine
	.p2align	2
	.long	32
_c32:	b	__cycle__in__spine

@
@	ARRAYS
@

_create_arrayB:
	add	r3,r4,#3
	lsr	r3,r3,#2

	add	r12,r3,#3
	subs	r5,r5,r12
	bhs	no_collect_4574
	bl	collect_0
no_collect_4574:
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	ldr	r12,=BOOL+2
	str	r12,[r10,#8]
	add	r12,r10,#12
	add	r10,r12,r3,lsl #2
	ldr	pc,[sp],#4

_create_arrayC:
	add	r3,r4,#3
	lsr	r3,r3,#2

	add	r12,r3,#2
	subs	r5,r5,r12
	bhs	no_collect_4573
	bl	collect_0
no_collect_4573:
	mov	r6,r10
	ldr	r12,=__STRING__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	add	r12,r10,#8
	add	r10,r12,r3,lsl #2
	ldr	pc,[sp],#4

_create_arrayI:
	add	r12,r4,#3
	subs	r5,r5,r12
	bhs	no_collect_4572
	bl	collect_0
no_collect_4572:
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	ldr	r12,=INT+2
	str	r12,[r10,#8]
	add	r12,r10,#12
	add	r10,r12,r4,lsl #2
	ldr	pc,[sp],#4

_create_arrayR:
	add	r12,r4,r4
	add	r12,r12,#3+1
	subs	r5,r5,r12
	bhs	no_collect_4580
	bl	collect_0
no_collect_4580:
	tst	r10,#4
	orr	r10,r10,#4
	addne	r5,r5,#1
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	ldr	r12,=REAL+2
	str	r12,[r10,#8]
	add	r12,r10,#12
	add	r10,r12,r4,lsl #3
	ldr	pc,[sp],#4

@ r4: number of elements, r3: element descriptor
@ r2: element size, r1: element a size, a0:a_element-> a0: array

_create_r_array:
	mul	r12,r4,r2
	add	r12,r12,#3
	subs	r5,r5,r12
	bhs	no_collect_4586
	bl	collect_1
no_collect_4586:
	mov	r8,r6

	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	str	r3,[r10,#8]

	mov	r6,r10
	add	r10,r10,#12

@ r4: number of elements, a0: array
@ r2: element size, r1: element a size, a2:a_element

	cmp	r1,#0
	beq	_create_r_array_0
	cmp	r1,#2
	blo	_create_r_array_1
	beq	_create_r_array_2
	cmp	r1,#4
	blo	_create_r_array_3
	beq	_create_r_array_4
	b	_create_r_array_5

_create_r_array_0:
	lsl	r2,r2,#2
	mul	r12,r4,r2
	add	r10,r10,r12
	ldr	pc,[sp],#4

_create_r_array_1:
	lsl	r2,r2,#2
	b	_st_fillr1_array
_fillr1_array:
	str	r8,[r10]
	add	r10,r10,r2
_st_fillr1_array:
	subs	r4,r4,#1
	bcs	_fillr1_array
	ldr	pc,[sp],#4

_create_r_array_2:
	lsl	r2,r2,#2
	b	_st_fillr2_array
_fillr2_array:
	str	r8,[r10]
	str	r8,[r10,#4]
	add	r10,r10,r2
_st_fillr2_array:
	subs	r4,r4,#1
	bcs	_fillr2_array
	ldr	pc,[sp],#4

_create_r_array_3:
	lsl	r2,r2,#2
	b	_st_fillr3_array
_fillr3_array:
	str	r8,[r10]
	str	r8,[r10,#4]
	str	r8,[r10,#8]
	add	r10,r10,r2
_st_fillr3_array:
	subs	r4,r4,#1
	bcs	_fillr3_array
	ldr	pc,[sp],#4

_create_r_array_4:
	lsl	r2,r2,#2
	b	_st_fillr4_array
_fillr4_array:
	str	r8,[r10]
	str	r8,[r10,#4]
	str	r8,[r10,#8]
	str	r8,[r10,#12]
	add	r10,r10,r2
_st_fillr4_array:
	subs	r4,r4,#1
	bcs	_fillr4_array
	ldr	pc,[sp],#4

_create_r_array_5:
	sub	r2,r2,r1
	lsl	r2,r2,#2
	b	_st_fillr5_array

_fillr5_array:
	str	r8,[r10]
	str	r8,[r10,#4]
	str	r8,[r10,#8]
	str	r8,[r10,#12]
	add	r10,r10,#16

	sub	r3,r1,#5
_copy_elem_5_lp:
	str	r8,[r10],#4
	subs	r3,r3,#1
	bcs	_copy_elem_5_lp

	add	r10,r10,r2
_st_fillr5_array:
	subs	r4,r4,#1
	bcs	_fillr5_array

	ldr	pc,[sp],#4

create_arrayB:
	mov	r7,r3
	add	r3,r3,#3
	lsr	r3,r3,#2

	add	r12,r3,#3
	subs	r5,r5,r12
	bhs	no_collect_4575

	str	r7,[sp,#-4]!
	bl	collect_0
	ldr	r7,[sp],#4

no_collect_4575:
	orr	r4,r4,r4,lsl #8
	orr	r4,r4,r4,lsl #16
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r7,[r10,#4]
	ldr	r12,=BOOL+2
	str	r12,[r10,#8]
	add	r10,r10,#12
	b	create_arrayBCI

create_arrayC:
	mov	r7,r3
	add	r3,r3,#3
	lsr	r3,r3,#2

	add	r12,r3,#2
	subs	r5,r5,r12
	bhs	no_collect_4578

	str	r7,[sp,#-4]!
	bl	collect_0
	ldr	r7,[sp],#4

no_collect_4578:
	orr	r4,r4,r4,lsl #8
	orr	r4,r4,r4,lsl #16
	mov	r6,r10
	ldr	r12,=__STRING__+2
	str	r12,[r10]
	str	r7,[r10,#4]
	add	r10,r10,#8
	b	create_arrayBCI

create_arrayI:
	add	r12,r3,#3
	subs	r5,r5,r12
	bhs	no_collect_4577

	bl	collect_0

no_collect_4577:
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r3,[r10,#4]
	ldr	r12,=INT+2
	str	r12,[r10,#8]
	add	r10,r10,#12
create_arrayBCI:
	tst	r3,#1
	lsr	r3,r3,#1
	beq	st_filli_array

	str	r4,[r10],#4
	b	st_filli_array

filli_array:
	str	r4,[r10]
	str	r4,[r10,#4]
	add	r10,r10,#8
st_filli_array:
	subs	r3,r3,#1
	bcs	filli_array

	ldr	pc,[sp],#4

create_arrayR:
	add	r12,r4,r4
	add	r12,r12,#3+1

	vmov	r3,r7,d0

	subs	r5,r5,r12
	bhs	no_collect_4579

	str	r7,[sp,#-4]!
	bl	collect_0
	ldr	r7,[sp],#4

no_collect_4579:
	tst	r10,#4
	orr	r10,r10,#4
	addne	r5,r5,#1

	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	ldr	r12,=REAL+2
	str	r12,[r10,#8]
	add	r10,r10,#12
	b	st_fillr_array
fillr_array:
	str	r3,[r10]
	str	r7,[r10,#4]
	add	r10,r10,#8
st_fillr_array:
	subs	r4,r4,#1
	bcs	fillr_array

	ldr	pc,[sp],#4

create_array:
	add	r12,r4,#3
	subs	r5,r5,r12
	bhs	no_collect_4576

	bl	collect_1

no_collect_4576:
	mov	r3,r6
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	mov	r12,#0
	str	r12,[r10,#8]
	add	r10,r10,#12
	mov	r1,r4
	b	fillr1_array

@ in r4: number of elements, r3: element descriptor
@ r2: element size, r1: element a size -> a0: array

create_R_array:
	cmp	r2,#2
	blo	create_R_array_1
	beq	create_R_array_2
	cmp	r2,#4
	blo	create_R_array_3
	beq	create_R_array_4
	b	create_R_array_5

create_R_array_1:
@ r4: number of elements, r3: element descriptor
@ r1: element a size

	add	r12,r4,#3
	subs	r5,r5,r12
	bhs	no_collect_4581

	bl	collect_0

no_collect_4581:
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	str	r3,[r10,#8]
	add	r10,r10,#12

	cmp	r1,#0
	beq	r_array_1_b

	ldr	r3,[r9,#-4]
	b	fillr1_array

r_array_1_b:
	ldr	r3,[sp,#4]

fillr1_array:
	tst	r4,#1
	lsr	r4,r4,#1
	beq	st_fillr1_array_1

	str	r3,[r10],#4
	b	st_fillr1_array_1

fillr1_array_lp:
	str	r3,[r10]
	str	r3,[r10,#4]
	add	r10,r10,#8
st_fillr1_array_1:
	subs	r4,r4,#1
	bcs	fillr1_array_lp

	ldr	pc,[sp],#4

create_R_array_2:
@ r4: number of elements, r3: element descriptor
@ r1: element a size

	add	r12,r4,r4
	add	r12,r12,#3
	subs	r5,r5,r12
	bhs	no_collect_4582

	bl	collect_0

no_collect_4582:
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	str	r3,[r10,#8]
	add	r10,r10,#12

	subs	r1,r1,#1
	blo	r_array_2_bb
	beq	r_array_2_ab
r_array_2_aa:
	ldr	r3,[r9,#-4]
	ldr	r8,[r9,#-8]
	b	st_fillr2_array
r_array_2_ab:
	ldr	r3,[r9,#-4]
	ldr	r8,[sp,#4]
	b	st_fillr2_array
r_array_2_bb:
	ldr	r3,[sp,#4]
	ldr	r8,[sp,#8]
	b	st_fillr2_array

fillr2_array_1:
	str	r3,[r10]
	str	r8,[r10,#4]
	add	r10,r10,#8
st_fillr2_array:
	subs	r4,r4,#1
	bcs	fillr2_array_1

	ldr	pc,[sp],#4

create_R_array_3:
@ r4: number of elements, r3: element descriptor
@ r1: element a size

	add	r12,r4,r4,lsl #1
	add	r12,r12,#3
	subs	r5,r5,r12
	bhs	no_collect_4583

	bl	collect_0

no_collect_4583:
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	str	r3,[r10,#8]
	add	r10,r10,#12

	ldr	lr,[sp],#4
	mov	r2,sp

	cmp	r1,#0
	beq	r_array_3

	sub	r8,r9,r1,lsl #2
	subs	r1,r1,#1

copy_a_to_b_lp3:
	ldr	r12,[r8],#4
	str	r12,[sp,#-4]!
	subs	r1,r1,#1
	bcs	copy_a_to_b_lp3

r_array_3:
	ldr	r3,[sp]
	ldr	r7,[sp,#4]
	ldr	r8,[sp,#8]	

	mov	sp,r2
	b	st_fillr3_array

fillr3_array_1:
	str	r3,[r10]
	str	r7,[r10,#4]
	str	r8,[r10,#8]
	add	r10,r10,#12
st_fillr3_array:
	subs	r4,r4,#1
	bcs	fillr3_array_1

	bx	lr

create_R_array_4:
@ r4: number of elements, r3: element descriptor
@ r1: element a size

	lsl	r12,r4,#2
	add	r12,r12,#3
	subs	r5,r5,r12
	bhs	no_collect_4584

	bl	collect_0

no_collect_4584:
	mov	r6,r10
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	str	r3,[r10,#8]
	add	r10,r10,#12

	ldr	lr,[sp],#4
	mov	r2,sp

	cmp	r1,#0
	beq	r_array_4
	
	sub	r8,r9,r1,lsl #2
	subs	r1,r1,#1

copy_a_to_b_lp4:
	ldr	r12,[r8],#4
	str	r12,[sp,#-4]!
	subs	r1,r1,#1
	bcs	copy_a_to_b_lp4

r_array_4:
	ldr	r0,[sp]
	ldr	r3,[sp,#4]
	ldr	r7,[sp,#8]
	ldr	r8,[sp,#12]

	mov	sp,r2
	b	st_fillr4_array

fillr4_array:
	str	r0,[r10]
	str	r3,[r10,#4]
	str	r7,[r10,#8]
	str	r8,[r10,#12]
	add	r10,r10,#16
st_fillr4_array:
	subs	r4,r4,#1
	bcs	fillr4_array

	bx	lr

create_R_array_5:
@ r4: number of elements, r3: element descriptor
@ r1: element a size, r2: element size

	mul	r12,r4,r2
	add	r12,r12,#3
	subs	r5,r5,r12
	bhs	no_collect_4585

	bl	collect_0

no_collect_4585:
	ldr	r12,=__ARRAY__+2
	str	r12,[r10]
	str	r4,[r10,#4]
	str	r3,[r10,#8]

	ldr	lr,[sp],#4
	mov	r11,sp

	cmp	r1,#0
	beq	r_array_5

	sub	r8,r9,r1,lsl #2
	subs	r1,r1,#1

copy_a_to_b_lp5:
	ldr	r12,[r8],#4
	str	r12,[sp,#-4]!
	subs	r1,r1,#1
	bcs	copy_a_to_b_lp5

r_array_5:
	mov	r6,r10
	add	r10,r10,#12

	ldr	r3,[sp]
	ldr	r7,[sp,#4]
	b	st_fillr5_array

fillr5_array_1:
	str	r3,[r10]
	str	r7,[r10,#4]

	sub	r12,r2,#5

	ldr	r8,[sp,#8]
	str	r8,[r10,#8]

	ldr	r8,[sp,#12]
	add	r0,sp,#16
	str	r8,[r10,#12]
	add	r10,r10,#16

copy_elem_lp5:
	ldr	r8,[r0],#4
	str	r8,[r10],#4
	subs	r12,r12,#1
	bcs	copy_elem_lp5

st_fillr5_array:
	subs	r4,r4,#1
	bcs	fillr5_array_1

	mov	sp,r11

	bx	lr

repl_args_b:
	cmp	r4,#0
	ble	repl_args_b_1

	subs	r4,r4,#1
	beq	repl_args_b_4

	ldr	r7,[r6,#8]
	subs	r3,r3,#2
	bne	repl_args_b_2

	str	r7,[r9],#4
	b	repl_args_b_4

repl_args_b_2:
	add	r7,r7,r4,lsl #2

repl_args_b_3:
	ldr	r8,[r7,#-4]!
	str	r8,[r9],#4
	subs	r4,r4,#1
	bne	repl_args_b_3

repl_args_b_4:
	ldr	r8,[r6,#4]
	str	r8,[r9],#4
repl_args_b_1:
	ldr	pc,[sp],#4

push_arg_b:
	cmp	r3,#2
	blo	push_arg_b_1
	bne	push_arg_b_2
	cmp	r3,r4
	beq	push_arg_b_1
push_arg_b_2:
	ldr	r6,[r6,#8]
	subs	r3,r3,#2
push_arg_b_1:
	ldr	r6,[r6,r3,lsl #2]
	ldr	pc,[sp],#4

del_args:
	ldr	r3,[r6]
	subs	r3,r3,r4
	ldrsh	r4,[r3,#-2]
	subs	r4,r4,#2
	bge	del_args_2

	str	r3,[r7]
	ldr	r8,[r6,#4]
	str	r8,[r7,#4]	
	ldr	r8,[r6,#8]
	str	r8,[r7,#8]
	ldr	pc,[sp],#4

del_args_2:
	bne	del_args_3

	str	r3,[r7]
	ldr	r8,[r6,#4]
	str	r8,[r7,#4]
	ldr	r8,[r6,#8]
	ldr	r8,[r8]
	str	r8,[r7,#8]
	ldr	pc,[sp],#4

del_args_3:
	subs	r5,r5,r4
	blo	del_args_gc
del_args_r_gc:
	str	r3,[r7]
	str	r10,[r7,#8]
	ldr	r8,[r6,#4]
	ldr	r6,[r6,#8]
	str	r8,[r7,#4]

del_args_copy_args:
	ldr	r8,[r6],#4
	str	r8,[r10],#4
	subs	r4,r4,#1
	bgt	del_args_copy_args

	ldr	pc,[sp],#4

del_args_gc:
	bl	collect_2
	b	del_args_r_gc

	.section .text.sin_real,"ax"
sin_real:
	bl	sin
	ldr	pc,[sp],#4

	.section .text.cos_real,"ax"
cos_real:
	bl	cos
	ldr	pc,[sp],#4

	.section .text.tan_real,"ax"
tan_real:
	bl	tan
	ldr	pc,[sp],#4

	.section .text.asin_real,"ax"	
asin_real:
	bl	asin
	ldr	pc,[sp],#4

	.section .text.acos_real,"ax"
acos_real:
	bl	acos
	ldr	pc,[sp],#4

	.section .text.atan_real,"ax"
atan_real:
	bl	atan
	ldr	pc,[sp],#4

	.section .text.ln_real,"ax"
ln_real:
	bl	log
	ldr	pc,[sp],#4

	.section .text.log10_real,"ax"
log10_real:
	bl	log10
	ldr	pc,[sp],#4

	.section .text.exp_real,"ax"
exp_real:
	bl	exp
	ldr	pc,[sp],#4

	.section .text.pow_real,"ax"
pow_real:
	vmov.f64 d2,d0
	vmov.f64 d0,d1
	vmov.f64 d1,d2
	bl	pow
	ldr	pc,[sp],#4

	.section .text.entier_real,"ax"
entier_real:
	bl	floor

r_to_i_real:
	vcvtr.s32.f64 s0,d0
	vmov	r4,s0
	ldr	pc,[sp],#4

	.ltorg

.if NEW_DESCRIPTORS
	.include "armap.s"
.endif