
struct file {								/* 48 bytes */
	unsigned char *	file_read_p;			/* offset 0 */
	unsigned char *	file_write_p;			/* offset 4 */
	unsigned char *	file_end_read_buffer_p;	/* offset 8 */
	unsigned char *	file_end_write_buffer_p;/* offset 12 */
	short			file_mode;				/* offset 16 */
	char			file_unique;			/* offset 18 */
	char			file_error;				/* offset 19 */

	unsigned char *	file_read_buffer_p;
	unsigned char *	file_write_buffer_p;

	unsigned long	file_offset;
	unsigned long	file_length;

	char *			file_name;
	unsigned long	file_position;
	unsigned long	file_position_2;

	HFILE			file_read_refnum;
	HFILE			file_write_refnum;
	
	long			file_fill_offset_56,	/* fill to 64 bytes */
					file_fill_offset_60;
};

extern struct file file_table[];

#define CLEAN_TRUE 1
#define CLEAN_BOOL int

extern int file_read_char (struct file *f);
extern CLEAN_BOOL file_read_int (struct file *f,int *i_p);
extern CLEAN_BOOL file_read_real (struct file *f,double *r_p);
extern unsigned long file_read_characters (struct file *f,unsigned long *length_p,char *s);
extern void file_write_char (int c,struct file *f);

extern void file_write_char (int c,struct file *f);
extern void file_write_characters (unsigned char *p,int length,struct file *f);
extern void file_write_int (int i,struct file *f);
extern void file_write_real (double r,struct file *f);
extern CLEAN_BOOL flush_file_buffer (struct file *f);
