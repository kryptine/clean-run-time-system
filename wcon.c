/*
	File:	wcon.c
	Author:	John van Groningen
	At:		University of Nijmegen
*/

#include <float.h>

#define GC_FLAGS
#define STACK_OVERFLOW_EXCEPTION_HANDLER

#ifdef WINDOWS
# include <windows.h>
# define ULONG unsigned long
# define DosWrite(f,p,l,lp) WriteFile ((HANDLE)f,p,l,lp,NULL)
# define DosRead(f,p,l,lp) ReadFile ((HANDLE)f,p,l,lp,NULL)
# define OS(w,o) w
# define StdInput std_input_handle
# define StdOutput std_output_handle
# define StdError std_error_handle
# ifdef TIME_PROFILE
#  define TCHAR char
#  if 0
   typedef struct _WIN32_FIND_DATA {
		DWORD dwFileAttributes;
		FILETIME ftCreationTime;
		FILETIME ftLastAccessTime;
		FILETIME ftLastWriteTime;
		DWORD    nFileSizeHigh;
		DWORD    nFileSizeLow;
		DWORD    dwReserved0;
		DWORD    dwReserved1;
		TCHAR    cFileName[ MAX_PATH ];
		TCHAR    cAlternateFileName[ 14 ];
   } WIN32_FIND_DATA;
#  endif
# endif
# include "wfileIO3.h"
#else
# define INCL_DOSFILEMGR
# include <os2.h>
# define OS(w,o) o
# define StdInput 0
# define StdOutput 1
# define StdError 2
#endif

#define SHOW_EXECUTION_TIME_MASK 8
#define NO_RESULT_MASK 16

#ifdef WINDOWS
HANDLE std_input_handle,std_output_handle,std_error_handle;
int console_window_visible,console_allocated,console_flag=0;
int std_input_from_file=0;
int std_output_to_file=0;
extern void init_std_io_from_or_to_file (void);
#endif

extern int c_entier (double);
extern double c_log10 (double);
extern double c_pow (double,double);

extern long ab_stack_size,heap_size,flags;

static void print_char (char c,OS(HANDLE,int) file_number)
{
	ULONG n_chars;

	if (c==10){
		c=13;
		DosWrite (file_number,&c,1,&n_chars);
		c=10;
	}
	DosWrite (file_number,&c,1,&n_chars);
}

static void print_text (char *s,unsigned long length,OS(HANDLE,int) file_number)
{
	ULONG n_chars;
	int n;

	n=0;
	while (n!=length)
		if (s[n]!=10)
			++n;
		else {
			char c;

			if (n>0)
				DosWrite (file_number,s,n,&n_chars);
			c=13;
			DosWrite (file_number,&c,1,&n_chars);

			s+=n;
			length-=n;
			n=1;
		}

	if (length>0)
		DosWrite (file_number,s,length,&n_chars);
}

#ifdef WINDOWS
static void make_console_window_visible ()
{
	if (!console_window_visible){
		if (console_flag==0 ||
			std_input_handle==INVALID_HANDLE_VALUE || std_input_handle==NULL ||
			std_output_handle==INVALID_HANDLE_VALUE || std_output_handle==NULL ||
			std_error_handle==INVALID_HANDLE_VALUE || std_error_handle==NULL)
		{
			console_allocated=AllocConsole();
	
			if (std_input_handle==INVALID_HANDLE_VALUE || std_input_handle==NULL)
				std_input_handle=GetStdHandle (STD_INPUT_HANDLE);
			if (std_output_handle==INVALID_HANDLE_VALUE || std_output_handle==NULL
				|| GetFileType (std_output_handle)==FILE_TYPE_UNKNOWN /* hack for windows 2000/XP */
				)
				std_output_handle=GetStdHandle (STD_OUTPUT_HANDLE);
			if (std_error_handle==INVALID_HANDLE_VALUE || std_error_handle==NULL)
				std_error_handle=GetStdHandle (STD_ERROR_HANDLE);
		}
		
		console_window_visible=1;
	}
}
#endif

void w_print_char (char c)
{
#ifdef WINDOWS
	if (std_output_to_file){
		file_write_char (c,&file_table[1]);
		return;
	}
	
	if (!console_window_visible)
		make_console_window_visible();
#endif

	print_char (c,StdOutput);
}

void w_print_text (char *s,unsigned long length)
{
#ifdef WINDOWS
	if (std_output_to_file){
		file_write_characters (s,length,&file_table[1]);
		return;
	}

	if (!console_window_visible)
		make_console_window_visible();
#endif

	print_text (s,length,StdOutput);
}

void ew_print_char (char c)
{
#ifdef WINDOWS
	if (!console_window_visible)
		make_console_window_visible();
#endif

	print_char (c,StdError);
}

void ew_print_text (char *s,unsigned long length)
{
#ifdef WINDOWS
	if (!console_window_visible)
		make_console_window_visible();
#endif

	print_text (s,length,StdError);
}

static int next_stdin_character=-1;

int w_get_char (void)
{
	ULONG n_chars;
	char c;

#ifdef WINDOWS
	if (std_input_from_file)
		return file_read_char (&file_table[1]);

	if (!console_window_visible)
		make_console_window_visible();
#endif

	if (next_stdin_character==-1){
		do {
			DosRead (StdInput,&c,1,&n_chars);
			if (n_chars>0 && c!=13)
				return c;
		} while (n_chars>0);

		return -1;
	} else {
		c=next_stdin_character;
		next_stdin_character=-1;
		return c;
	}
}

#define is_digit(n) ((unsigned)((n)-'0')<(unsigned)10)

int w_get_int (int *i_p)
{
	int c,negative;
	unsigned int i;

#ifdef WINDOWS	
	if (std_input_from_file)
		return file_read_int (&file_table[1],i_p);
#endif

	c=w_get_char();
	while (c==' ' || c=='\t' || c=='\n')
		c=w_get_char();
	
	negative=0;
	if (c=='+')
		c=w_get_char();
	else
		if (c=='-'){
			c=w_get_char();
			negative=1;
		}
	
	if (!is_digit (c)){
		next_stdin_character=c;
		
		*i_p=0;
		return 0;
	}
	
	i=c-'0';
	while (c=w_get_char(),is_digit (c)){
		i+=i<<2;
		i+=i;
		i+=c-'0';
	};

	if (negative)
		i=-i;

	next_stdin_character=c;

	*i_p=i;
	return -1;
}

char *convert_string_to_real (char *string,double *r_p)
{
	int neg,has_digits,has_dot;
	char *s_p,*end_s;
	long scale;
	double d;

	s_p=string;

	neg=0;
	if (*s_p=='+')
		++s_p;
	else if (*s_p=='-'){
		neg = 1;
		++s_p;
    }

	has_digits=0;
	has_dot=0;
	scale=0;
	d=0.0;

	for (;;){
		if (*s_p== '.' && !has_dot){
			++s_p;
			has_dot=1;
		} else if ((unsigned)(*s_p-'0') < (unsigned)10){
			if (!has_digits){
				d=(double)(*s_p - '0');
				has_digits=1;
			} else {
				if (d >= 1e18)
					++scale;
				else
					d = d*10.0 + (double)(*s_p - '0');
			}
			++s_p;
			if (has_dot)
				--scale;
		} else
			break;
	}

	if (!has_digits){
		*r_p=0.0;
		return string;
	}

	end_s=s_p;

	if ((*s_p & ~0x20)=='E'){
		int neg_exponent;

		++s_p;

		neg_exponent=0;
		if (*s_p=='+')
			++s_p;
		else if (*s_p=='-'){
			neg_exponent=1;
			++s_p;
		}
		
		if ((unsigned)(*s_p-'0') < (unsigned)10){
			int exponent;
			
			exponent=*s_p++ - '0';
			while ((unsigned)(*s_p-'0') < (unsigned)10)
				exponent=exponent*10 + *s_p++ - '0';

			if (neg_exponent)
				scale -= exponent;
			else
				scale += exponent;
			
			end_s=s_p;
        }
    }

	if (scale!=0 && d!=0.0)
		d *= c_pow (10.0,(double)scale);

	if (neg)
		d=-d;

	*r_p=d;

	return end_s;
}

int w_get_real (double *r_p)
{
	char s[256+1];
	int c,dot,digits,result,n;

#ifdef WINDOWS
	if (std_input_from_file)
		return file_read_real (&file_table[1],r_p);
#endif
	
	n=0;
	
	c=w_get_char();
	while (c==' ' || c=='\t' || c=='\n')
		c=w_get_char();
	
	if (c=='+')
		c=w_get_char();
	else
		if (c=='-'){
			s[n++]=c;
			c=w_get_char();
		}
	
	dot=0;
	digits=0;
	
	while (is_digit (c) || c=='.'){
		if (c=='.'){
			if (dot){
				dot=2;
				break;
			}
			dot=1;
		} else
			digits=-1;
		if (n<256)
			s[n++]=c;
		c=w_get_char();
	}

	result=0;
	if (digits)
		if (dot==2 || ! (c=='e' || c=='E'))
			result=-1;
		else {
			if (n<256)
				s[n++]=c;
			c=w_get_char();
			
			if (c=='+')
				c=w_get_char();
			else
				if (c=='-'){
					if (n<256)
						s[n++]=c;
					c=w_get_char();
				}
			
			if (is_digit (c)){
				do {
					if (n<256)
						s[n++]=c;
					c=w_get_char();
				} while (is_digit (c));

				result=-1;
			}
		}

	if (n>=256)
		result=0;

	next_stdin_character=c;

	*r_p=0.0;
	
	if (result){
		s[n]='\0';
		result= convert_string_to_real (s,r_p)==&s[n];
	}
	
	return result;
}

unsigned long w_get_text (char *string,unsigned long max_length)
{
	ULONG length;

	length=0;

#ifdef WINDOWS
	if (std_input_from_file){
		unsigned long length;
		
		length=max_length;
		return file_read_characters (&file_table[1],&length,string);
	}

	if (!console_window_visible)
		make_console_window_visible();
#endif
	
	if (max_length==0)
		return length;
	
	if (next_stdin_character!=-1){
		*string++=next_stdin_character;
		next_stdin_character=-1;
		--max_length;
		++length;
	}
	
	while (max_length>0){
		ULONG r_length;
		int s,d;
		
		DosRead (StdInput,string,max_length,&r_length);
		
		s=0;
		d=0;
		while (s<r_length){
			char c;
			
			c=string[s];
			++s;
			
			if (c!=13){
				string[d]=c;
				++d;
			}
		}
		length += d;

		if (r_length!=max_length)
			break;
		
		string += d;
		max_length -= d;
	}

	return length;
}

void w_print_string (char *s)
{
	char *p;

#ifdef WINDOWS
	if (std_output_to_file){
		for (p=s; *p!=0; ++p)
			;
		file_write_characters (p,p-s,&file_table[1]);
		return;
	}

	if (!console_window_visible)
		make_console_window_visible();
#endif

	for (p=s; *p!=0; ++p)
		;

	print_text (s,p-s,StdOutput);
}

void ew_print_string (char *s)
{
	char *p;

#ifdef WINDOWS
	if (!console_window_visible)
		make_console_window_visible();
#endif

	for (p=s; *p!=0; ++p)
		;

	print_text (s,p-s,StdError);
}

static void print_integer (int n,OS(HANDLE,int) file_number)
{
	char s[16];
	int length;
	unsigned int m;
	ULONG n_chars;

	if (n<0)
		m=-n;
	else
		m=n;

	length=16;

	while (m>=10){
		unsigned int r;

		r=m/10;
		s[--length]=48+m-r*10;
		m=r;
	}

	s[--length]=48+m;
	if (n<0)
		s[--length]='-';

	DosWrite (file_number,&s[length],16-length,&n_chars);
}

void w_print_int (int n)
{
#ifdef WINDOWS
	if (std_output_to_file){
		file_write_int (n,&file_table[1]);
		return;
	}

	if (!console_window_visible)
		make_console_window_visible();
#endif

	print_integer (n,StdOutput);
}

void ew_print_int (int n)
{
#ifdef WINDOWS
	if (!console_window_visible)
		make_console_window_visible();
#endif

	print_integer (n,StdError);
}

int xam_and_fstsw (double d)
{
	int i;

#if 0	
	asm ("fxam ; fstsw %%ax" : : "f" (d) : "%ax");
	asm ("movzwl %%ax,%0" : "=g" (i) : );
#else
	asm ("fxam ; fstsw %%ax; movzwl %%ax,%0" : "=g" (i) : "t" (d) : "%ax");
#endif
	return i;
}

#if 0
int fbstp (double d,char *buffer)
{
# if 0
	asm ("movl %0,%%eax ; fbstp (%%eax) ; fld1" : : "g" (buffer) , "f" (d) : "%eax");
# else
	asm ("fbstp (%0)" : : "r" (buffer) , "t" (d) : "st");
# endif
}
#endif

#define N_DIGITS 15

#if 1
static unsigned int dtoi_divmod_1e9 (double d,unsigned int *rem_p)
{
	double a[1];
	unsigned int q,r;
# if 1
	asm (
		"fistpq (%3); "
		"movl	$1000000000,%%ebx; "
		"movl 4(%3),%%edx; "
		"movl (%3),%%eax; "
		"divl %%ebx; "
		: "=&a" (q), "=&d" (r) : "t" (d), "r" (a)
		:  "%ebx","st"
		);
# else
	asm (
		"fistpq (%3); "
		"movl	$1000000000,%%ebx; "
		"movl 4(%3),%%edx; "
		"movl (%3),%%eax; "
		"divl %%ebx; "
		"movl %%eax,%0"
		: "&=g" (q), "&=d" (r) : "t" (d), "r" (a)
		:  "%eax","%ebx","%ecx","%edx","st"
		);
# endif

	*rem_p=r;
	return q;
}

static unsigned int to14_18 (int i)
{
	int r;
	
	asm (
		"mov $0x0a7c5ac48,%%eax; "	// 2^18 / 1e5 * 2^30 rounded up
		"mull %1; "					// Divide by 1e5,
		"shr $30,%%eax; "			// converting it into
		"lea 1(%%eax,%%edx,4),%0"	// 14.18 fixed-point format
		: "=r" (r) : "g" (i)
		: "%eax","%edx"
		);
	
	return r;
}

static unsigned int to4_28 (int i)
{
	int r;
	
	asm (
		"mov $0xabcc7712,%%eax; "	// 2^28 / 1e8 * 2^30 rounded up
		"mull %1; "					// Divide by 1e8
		"shr $30,%%eax; "			// converting it into
		"lea 1(%%eax,%%edx,4),%0"	// 4.28 fixed-point format
		: "=r" (r) : "g" (i)
		: "%eax","%edx"
		);
	
	return r;
}

static void d_to_a (double d,char *s)
{
	unsigned int i1,i2,n,r;

	n=dtoi_divmod_1e9 (d,&r);

	i2=to4_28 (r);

	s[6]=(i2>>28)+'0';

	i1=to14_18 (n);

	i2=(i2 & 0xfffffff)*5;
	s[7]=(i2>>27)+'0';

	s[0]=(i1>>18)+'0';

	i2=(i2 & 0x7ffffff)*5;
	s[8]=(i2>>26)+'0';

	i1=(i1 & 0x3ffff)*5;
	s[1]=(i1>>17)+'0';

	i2=(i2 & 0x3ffffff)*5;
	s[9]=(i2>>25)+'0';

	i1=(i1 & 0x1ffff)*5;
	s[2]=(i1>>16)+'0';

	i2=(i2 & 0x1ffffff)*5;
	s[10]=(i2>>24)+'0';

	i1=(i1 & 0xffff)*5;
	s[3]=(i1>>15)+'0';

	i2=(i2 & 0xffffff)*5;
	s[11]=(i2>>23)+'0';

	i1=(i1 & 0x7fff)*5;
	s[4]=(i1>>14)+'0';

	i2=(i2 & 0x7fffff)*5;
	s[12]=(i2>>22)+'0';

	i1=(i1 & 0x3fff)*5;
	s[5]=(i1>>13)+'0';

	i2=(i2 & 0x3fffff)*5;
	s[13]=(i2>>21)+'0';

	s[15]='\0';

	i2=(i2 & 0x1fffff)*5;
	s[14]=(i2>>20)+'0';
}
#endif

char *convert_real_to_string (double d,char *s_p)
{
	double scale_factor;
	int exponent,n;
	unsigned int fpu_status;

	fpu_status = xam_and_fstsw (d);

	switch (fpu_status & 0x4500){
		case 0x500:
			if (fpu_status & 0x200)
				*s_p++='-';
			s_p[0]='#';
			s_p[1]='I';
			s_p[2]='N';
			s_p[3]='F';
			s_p[4]='\0';
			return s_p+4;
		case 0x100:
			s_p[0]='#';
			s_p[1]='N';
			s_p[2]='A';
			s_p[3]='N';
			s_p[4]='\0';
			return s_p+4;
		case 0x4100:
			if (fpu_status & 0x200)
				*s_p++='-';
			s_p[0]='#';
			s_p[1]='E';
			s_p[2]='M';
			s_p[3]='P';
			s_p[4]='\0';
			return s_p+4;
	}

	if (d<0){
		d=-d;
		*s_p++ = '-';
	}

	if (d==0){
		*s_p++ = '0';
		*s_p = '\0';
		return s_p;
	}

	if (d<1e4){
		if (d<1e0){
			if (d<1e-4){
				exponent=c_entier (c_log10 (d));
				if (N_DIGITS-exponent>=308){
					d=d*1e20;
					scale_factor=c_pow (10.0,N_DIGITS-1-20-exponent);
				} else {
					scale_factor=c_pow (10.0,N_DIGITS-1-exponent);
				}
			} else {
				if (d<1e-2){
					if (d<1e-3){
						exponent=-4;
						scale_factor=1e18;
					} else {
						exponent=-3;
						scale_factor=1e17;
					}
				} else {
					if (d<1e-1){
						exponent=-2;
						scale_factor=1e16;
					} else {
						exponent=-1;
						scale_factor=1e15;
					}
				}
			}
		} else {
			if (d<1e2){
				if (d<1e1){
					exponent=0;
					scale_factor=1e14;
				} else {
					exponent=1;
					scale_factor=1e13;
				}				
			} else {
				if (d<1e3){
					exponent=2;
					scale_factor=1e12;
				} else {
					exponent=3;
					scale_factor=1e11;
				}			
			}
		}		
	} else {
		if (d<1e8){
			if (d<1e6){
				if (d<1e5){
					exponent=4;
					scale_factor=1e10;
				} else {
					exponent=5;
					scale_factor=1e9;
				}
			} else {
				if (d<1e7){
					exponent=6;
					scale_factor=1e8;
				} else {
					exponent=7;
					scale_factor=1e7;			
				} 
			}
		} else if (d<1e12){
			if (d<1e10){
				if (d<1e9){
					exponent=8;
					scale_factor=1e6;
				} else {
					exponent=9;
					scale_factor=1e5;
				}
			} else {
				if (d<1e11){
					exponent=10;
					scale_factor=1e4;
				} else {
					exponent=11;
					scale_factor=1e3;
				}
			}						
		} else {
			exponent=c_entier (c_log10 (d));
			scale_factor=c_pow (10.0,N_DIGITS-1-exponent);
		}
	}

	d *= scale_factor;

	if (d<1e14){
		d *= 10.0;
		--exponent;
	}

#if 1
	d_to_a (d,s_p);
#else
	{
		unsigned char bcd_buffer[16];
		int i,j;

		fbstp (d,bcd_buffer);
	
		j=14;
		for (i=0; i<7; ++i){
			unsigned char bcd_byte;
			
			bcd_byte=bcd_buffer[i];
			s_p[j] ='0'+(bcd_byte & 0xf);
			s_p[j-1]='0'+((bcd_byte & 0xf0)>>4);
			j-=2;
		}
		s_p[j] ='0'+(bcd_buffer[i] & 0xf);
	}
#endif
	
	s_p+=N_DIGITS;

	if (exponent>(N_DIGITS-1) || exponent<-4){
		int exponent_d10;
		
		for (n=-1; n>=-(N_DIGITS-1); --n)
			s_p[n+1]=s_p[n];
		s_p[-(N_DIGITS-1)]='.';

		++s_p;
		while (s_p[-1]=='0')
			--s_p;

		if (s_p[-1]=='.')
			--s_p;
		
		*s_p++ = 'e';
		
		if (exponent>=0)
			*s_p++ = '+';
		else {
			*s_p++ = '-';
			exponent= -exponent;
		}
		
		if (exponent>=100){
			int exponent_d100;
			
			exponent_d100=exponent/100;
			*s_p++ = '0'+exponent_d100;
			exponent -= 100*exponent_d100;
		}
		
		exponent_d10=exponent/10;
		*s_p++ = '0'+exponent_d10;
		*s_p++ = '0'+exponent-10*exponent_d10;
	} else {
		if (exponent>=-1){
			for (n=-1; n>=exponent-(N_DIGITS-1); --n)
				s_p[n+1]=s_p[n];
			s_p[exponent-(N_DIGITS-1)]='.';
			++s_p;
		} else {
			for (n=-1; n>=-N_DIGITS; --n)
				s_p[n-exponent]=s_p[n];		
			s_p[-N_DIGITS] = '.';
			
			for (n=exponent; n<-1; ++n)
				s_p[-(N_DIGITS-1)+(n-exponent)] = '0';
			s_p+= -exponent;			
		}

		while (s_p[-1]=='0')
			--s_p;

		if (s_p[-1]=='.')
			--s_p;
	}

	*s_p='\0';
	return s_p;	
}

void w_print_real (double r)
{
	char s[32],*end_s;

#ifdef WINDOWS
	if (std_output_to_file){
		file_write_real (r,&file_table[1]);
		return;
	}

	if (!console_window_visible)
		make_console_window_visible();
#endif
	
	end_s=convert_real_to_string (r,s);
	print_text (s,end_s-s,StdOutput);
}

void ew_print_real (double r)
{
	char s[32],*end_s;

#ifdef WINDOWS
	if (!console_window_visible)
		make_console_window_visible();
#endif
	
	end_s=convert_real_to_string (r,s);
	print_text (s,end_s-s,StdError);
}

#ifdef WINDOWS
void wait_for_key_press (VOID)
{
	DWORD console_mode;
		
	SetConsoleTitleA ("press any key to exit");
		
	GetConsoleMode (std_input_handle,&console_mode);
	SetConsoleMode (std_input_handle,console_mode & ~(ENABLE_LINE_INPUT | ENABLE_ECHO_INPUT));		
	{
		ULONG n_chars;
		char c;

		n_chars=1;
		DosRead (StdInput,&c,1,&n_chars);
	}
	SetConsoleMode (std_input_handle,console_mode);
}
#endif

int free_memory (void *p)
{
#ifdef WINDOWS
	if (GlobalFree (p)==NULL)
		return 0;
	else
		return GetLastError();
#else
	return DosFreeMem (p);
#endif
}

void *allocate_memory (int size)
{
#ifdef WINDOWS
	return LocalAlloc (GMEM_FIXED,size);
#else
	APIRET rc;
	void *pb;

	rc=DosAllocMem (&pb,size,fALLOC);
	if (rc!=0)
		return NULL;
	else
		return pb;
#endif
}

#if defined (WINDOWS) && defined (STACK_OVERFLOW_EXCEPTION_HANDLER)
void *allocate_memory_with_guard_page_at_end (int size)
{
	int alloc_size;
	DWORD old_protect;
	char *p,*end_p;
	
	alloc_size=(size+4096+4095) & -4096;
	
	p=LocalAlloc (GMEM_FIXED,alloc_size);
	if (p==NULL)
		return p;

	end_p=(char*)(((int)p+size+4095) & -4096);
	if (!VirtualProtect (end_p,4096,PAGE_READWRITE | PAGE_GUARD,&old_protect))
		VirtualProtect (end_p,4096,PAGE_NOACCESS,&old_protect);

	return p;
}
#endif

static long parse_size (char *s)
{
	int c;
	long n;
	
	c=*s++;
	if (c<'0' || c>'9'){
		w_print_string ("Digit expected in argument\n");
		return -1;
	}
	
	n=c-'0';
	
	while (c=*s++,c>='0' && c<='9')
		n=n*10+(c-'0');
	
	if (c=='k' || c=='K'){
		c=*s++;
		n<<=10;
	} else if (c=='m' || c=='M'){
		c=*s++;
		n<<=20;
	}
	
	if (c!='\0'){
		w_print_string ("Error in argument\n");
		return -1;
	}
	
	return n;
}

#ifdef GC_FLAGS
static long parse_integer (register char *s)
{
	register int c;
	register long n;

	c=*s++;
	if (c<'0' || c>'9'){
		w_print_string ("Digit expected in argument\n");
		return (-1);
	}

	n=c-'0';

	while (c=*s++,c>='0' && c<='9')
		n=n*10+(c-'0');

	if (c!='\0'){
		w_print_string ("Error in integer");
		return (-1);
	}
	
	return n;
}
#endif

int global_argc;
char **global_argv;

#ifdef DLL
extern void abc_main (void *);
#else
extern void abc_main (void);
#endif

#define EQ_STRING1(s,c1) ((s)[0]==(c1) && (s)[1]=='\0')
#define EQ_STRING2(s,c1,c2) ((s)[0]==(c1) && (s)[1]==(c2) &&(s)[2]=='\0')
#define EQ_STRING3(s,c1,c2,c3) ((s)[0]==(c1) && (s)[1]==(c2) && (s)[2]==(c3) && (s)[3]=='\0')

#ifdef WINDOWS
extern long heap_size_multiple;
extern long initial_heap_size;

# define MINIMUM_HEAP_SIZE_MULTIPLE ((2*256)+128)
# define MAXIMUM_HEAP_SIZE_MULTIPLE (100*256)
#endif

void (*exit_tcpip_function) (void);
#ifdef WINDOWS
int execution_aborted;
int return_code;
#endif

#ifdef STACK_OVERFLOW_EXCEPTION_HANDLER
extern __stdcall LONG clean_exception_handler (struct _EXCEPTION_POINTERS *exception_p);
#endif

#ifdef DLL
int clean_main (int heap_size_param,int flags_param,int ab_stack_size_param,void *start_address,int argc,char **argv)
#else
# ifdef CLIB
int main (int argc,char **argv)
# else
int clean_main (void)
# endif
#endif
{
	int arg_n;
#ifndef CLIB
	char **argv,*arg_p,*arg_p_copy,*command_p;
	int argc;
	
	argc=0;
	command_p=GetCommandLineA();
	if (command_p==NULL || *command_p=='\0')
		command_p="?";

	{
		char c;
	
		arg_p=command_p;

		while ((c=*arg_p)!=0){
			while (c==' ' || c=='\t' || c=='\n' || c=='\r')
				c = * ++arg_p;
			
			if (c=='\0')
				break;
			
			++argc;

			if (c=='\"'){
				do {
					c = * ++arg_p;
				} while (!(c=='\0' || c=='\"'));
				
				if (c=='\"')
					c = * ++arg_p;
			} else {
				while (!(c=='\0' || c==' ' || c=='\t' || c=='\n' || c=='\r'))
					c = * ++arg_p;
			}
			
			if (c=='\0')
				break;
			
			++arg_p;		
		}
	}
	
	argv=LocalAlloc (GMEM_FIXED,argc*sizeof (char*));
	arg_p_copy=LocalAlloc (GMEM_FIXED,(1+arg_p-command_p)*sizeof (char));

	argc=0;
	arg_p=command_p;

	if (argv==NULL || arg_p_copy==NULL){
		argv=&arg_p;
		argc=1;
	} else {
		char c;
		
		while ((c=*arg_p)!='\0'){
			while (c==' ' || c=='\t' || c=='\n' || c=='\r')
				c=* ++arg_p;
			
			if (c=='\0')
				break;
	
			argv[argc++]=arg_p_copy;

			if (c=='\"'){
				c = * ++arg_p;
				
				while (!(c=='\0' || c=='\"')){
					*arg_p_copy++ = c;
					c = * ++arg_p;
				}
			
				if (c=='\"')
					c = * ++arg_p;
			} else {
				while (!(c=='\0' || c==' ' || c=='\t' || c=='\n' || c=='\r')){
					*arg_p_copy++ = c;
					c = * ++arg_p;
				}
			}
	
			*arg_p_copy++ = '\0';

			if (c=='\0')
				break;
			
			++arg_p;		
		}
	}
#endif

	exit_tcpip_function=NULL;
#ifdef WINDOWS
	execution_aborted=0;
	return_code=0;
#endif

#ifdef DLL
	heap_size=heap_size_param;
	flags=flags_param;
	ab_stack_size=ab_stack_size_param;
#endif

#ifdef WINDOWS
	std_input_handle=GetStdHandle (STD_INPUT_HANDLE);
	std_output_handle=GetStdHandle (STD_OUTPUT_HANDLE);

	if (flags & 128)
		std_error_handle=CreateFileA ("Messages",GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
	else
		std_error_handle=GetStdHandle (STD_ERROR_HANDLE);

	std_input_from_file = GetFileType (std_input_handle)==FILE_TYPE_DISK;
	std_output_to_file = GetFileType (std_output_handle)==FILE_TYPE_DISK;

	if (std_input_from_file || std_output_to_file)
		init_std_io_from_or_to_file();

	console_window_visible=flags & NO_RESULT_MASK ? 0 : 1;

	if (heap_size_multiple<MINIMUM_HEAP_SIZE_MULTIPLE)
		heap_size_multiple=MINIMUM_HEAP_SIZE_MULTIPLE;
	if (heap_size_multiple>MAXIMUM_HEAP_SIZE_MULTIPLE)
		heap_size_multiple=MAXIMUM_HEAP_SIZE_MULTIPLE;
#endif

	for (arg_n=1; arg_n<argc; ++arg_n){
		char *s;
		
		s=argv[arg_n];
		if (*s!='-')
			break;

		++s;
		if (EQ_STRING1 (s,'h')){
   			long s;

			++arg_n;
			if (arg_n>=argc){
				w_print_string ("Heapsize missing\n");
				return -1;
			}
			s=parse_size (argv[arg_n]);
			if (s<0)
				return -1;
			heap_size=s;
		} else if (EQ_STRING1 (s,'s')){
   			long s;

			++arg_n;
			if (arg_n>=argc){
				w_print_string ("Stacksize missing\n");
				return -1;
			}
			s=parse_size (argv[arg_n]);
			if (s<0)
				return -1;
			ab_stack_size=s;
		} else if (EQ_STRING1 (s,'b'))
			flags |= 1;
		else if (EQ_STRING2 (s,'s','c'))
			flags &= ~1;
		else if (EQ_STRING1 (s,'t'))
			flags |= SHOW_EXECUTION_TIME_MASK;
		else if (EQ_STRING2 (s,'n','t'))
			flags &= ~SHOW_EXECUTION_TIME_MASK;
		else if (EQ_STRING2 (s,'g','c'))
			flags |= 2;
		else if (EQ_STRING3 (s,'n','g','c'))
			flags &= ~2;
		else if (EQ_STRING2 (s,'s','t'))
			flags |= 4;
		else if (EQ_STRING3 (s,'n','s','t'))
			flags &= ~4;
		else if (EQ_STRING2 (s,'n','r'))
			flags |= NO_RESULT_MASK;
#ifdef GC_FLAGS
		else if (EQ_STRING3 (s,'g','c','m'))
			flags |= 64;
		else if (EQ_STRING3 (s,'g','c','c'))
			flags &= ~64;
		else if (EQ_STRING3 (s,'g','c','i')){
			int s;
			
			++arg_n;
			if (arg_n>=argc){
				w_print_string ("Initial heap size missing\n");
				return -1;
			}
			s=parse_size (argv[arg_n]);
			if (s<0)
				return -1;
			initial_heap_size=s;
		} else if (EQ_STRING3 (s,'g','c','f')){
			int i;
			
			++arg_n;
			if (arg_n>=argc){
				w_print_string ("Next heap size factor missing\n");
				return -1;
			}
			i=parse_integer (argv[arg_n]);
			if (i<0)
				return -1;
			heap_size_multiple=i<<8;
		}
#endif
#ifdef WINDOWS
		else if (EQ_STRING3 (s,'c','o','n'))
			console_flag=1;
#endif
		else
			break;
	}

	--arg_n;
	argv[arg_n]=argv[0];
	global_argv=&argv[arg_n];
	global_argc=argc-arg_n;

#ifdef STACK_OVERFLOW_EXCEPTION_HANDLER
	SetUnhandledExceptionFilter (&clean_exception_handler);
#endif

#ifdef DLL
	abc_main (start_address);
#else
	abc_main();
#endif

	if (exit_tcpip_function!=NULL)
		exit_tcpip_function();

#ifdef WINDOWS
# if 1
	if ( (!(flags & NO_RESULT_MASK) || (flags & SHOW_EXECUTION_TIME_MASK) || execution_aborted || (console_window_visible && !console_allocated) ) && !console_flag)
# else
	if ( (!(flags & NO_RESULT_MASK) || (flags & SHOW_EXECUTION_TIME_MASK) || execution_aborted) && !console_flag)
# endif
		wait_for_key_press();

	if (std_output_to_file)
		flush_file_buffer (&file_table[1]);

	if (return_code==0 && execution_aborted)
		return_code= -1;
#endif

#ifndef CLIB
	ExitProcess (return_code);
#endif

#ifdef WINDOWS
	return return_code;
#else
	return 0;
#endif
}

#ifdef TIME_PROFILE
char time_profile_file_name_suffix[]=" Time Profile.pcl";

#define MAX_PATH_LENGTH 256

void create_profile_file_name (unsigned char *profile_file_name_string)
{
	char *time_profile_file_name_p,*time_profile_file_name_suffix_p,*profile_file_name,*p;
	int length_time_profile_file_name,time_profile_file_name_suffix_length,i;

	time_profile_file_name_p=global_argv[0];
	profile_file_name=&profile_file_name_string[8];
	
	for (p=time_profile_file_name_p; *p!='\0'; ++p)
		;
	length_time_profile_file_name=p-time_profile_file_name_p;
	
	if (time_profile_file_name_p[0]=='\"' && length_time_profile_file_name>1 && time_profile_file_name_p[length_time_profile_file_name-1]=='\"'){
		++time_profile_file_name_p;
		length_time_profile_file_name-=2;
	}
	
	for (i=0; i<length_time_profile_file_name; ++i)
		profile_file_name[i]=time_profile_file_name_p[i];
	profile_file_name[length_time_profile_file_name]='\0';
	
	if (length_time_profile_file_name<=MAX_PATH_LENGTH){
		WIN32_FIND_DATA find_data;
		HANDLE find_first_file_handle;

		find_first_file_handle=FindFirstFileA (profile_file_name,&find_data);
		if (find_first_file_handle!=INVALID_HANDLE_VALUE){
			char *file_name_p,*p;
			int file_name_length;
			
			file_name_p=find_data.cFileName;
			for (p=file_name_p; *p!='\0'; ++p)
				;
			file_name_length=p-file_name_p;
			
			for (p=profile_file_name+length_time_profile_file_name; p>profile_file_name && p[-1]!='\\' && p[-1]!='/'; --p)
				;
			
			if ((p-profile_file_name)+file_name_length<=MAX_PATH_LENGTH){				
				for (i=0; i<file_name_length; ++i)
					p[i]=file_name_p[i];
				p[i]='\0';
				
				length_time_profile_file_name=&p[i]-profile_file_name;
			}
			
			FindClose (find_first_file_handle);
		}
	}

	p=&profile_file_name[length_time_profile_file_name];
	if (length_time_profile_file_name>3 && p[-4]=='.' && p[-3]=='e' && p[-2]=='x' && p[-1]=='e')
		length_time_profile_file_name-=4;
	
	time_profile_file_name_suffix_p=time_profile_file_name_suffix;
	time_profile_file_name_suffix_length=sizeof (time_profile_file_name_suffix);	
	if (length_time_profile_file_name+time_profile_file_name_suffix_length>MAX_PATH_LENGTH){
		time_profile_file_name_suffix_length=MAX_PATH_LENGTH-length_time_profile_file_name;
		time_profile_file_name_suffix_p=&time_profile_file_name_suffix_p[sizeof (time_profile_file_name_suffix)-time_profile_file_name_suffix_length];
	}
	
	p=profile_file_name+length_time_profile_file_name;
	for (i=0; i<=time_profile_file_name_suffix_length; ++i)
		p[i]=time_profile_file_name_suffix_p[i];
	
	*(unsigned int*)(&profile_file_name_string[4])=length_time_profile_file_name+time_profile_file_name_suffix_length;
}
#endif

#ifdef WRITE_HEAP
# include "iwrite_heap.c"
#endif
