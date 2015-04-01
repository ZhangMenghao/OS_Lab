
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 06 5d 00 00       	call   105d5c <memset>

    cons_init();                // init the console
  100056:	e8 71 15 00 00       	call   1015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 00 5f 10 00 	movl   $0x105f00,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 1c 5f 10 00 	movl   $0x105f1c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 f4 41 00 00       	call   104278 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 ac 16 00 00       	call   101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 24 18 00 00       	call   1018b2 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ef 0c 00 00       	call   100d82 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0b 16 00 00       	call   1016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f8 0b 00 00       	call   100cb4 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 21 5f 10 00 	movl   $0x105f21,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 2f 5f 10 00 	movl   $0x105f2f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 3d 5f 10 00 	movl   $0x105f3d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 4b 5f 10 00 	movl   $0x105f4b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 59 5f 10 00 	movl   $0x105f59,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 68 5f 10 00 	movl   $0x105f68,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 88 5f 10 00 	movl   $0x105f88,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 a7 5f 10 00 	movl   $0x105fa7,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fe 12 00 00       	call   1015f8 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 3e 52 00 00       	call   105575 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 85 12 00 00       	call   1015f8 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 65 12 00 00       	call   101634 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 ac 5f 10 00    	movl   $0x105fac,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 ac 5f 10 00 	movl   $0x105fac,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 08 72 10 00 	movl   $0x107208,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 e0 1d 11 00 	movl   $0x111de0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec e1 1d 11 00 	movl   $0x111de1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 17 48 11 00 	movl   $0x114817,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 e4 54 00 00       	call   105bd0 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 b6 5f 10 00 	movl   $0x105fb6,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 cf 5f 10 00 	movl   $0x105fcf,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 e5 5e 10 	movl   $0x105ee5,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 e7 5f 10 00 	movl   $0x105fe7,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 ff 5f 10 00 	movl   $0x105fff,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 17 60 10 00 	movl   $0x106017,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 30 60 10 00 	movl   $0x106030,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 5a 60 10 00 	movl   $0x10605a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 76 60 10 00 	movl   $0x106076,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 88 00 00 00       	jmp    100a67 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 88 60 10 00 	movl   $0x106088,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	83 c0 08             	add    $0x8,%eax
  1009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a09:	eb 25                	jmp    100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a20:	c7 04 24 a4 60 10 00 	movl   $0x1060a4,(%esp)
  100a27:	e8 10 f9 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a34:	7e d5                	jle    100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a36:	c7 04 24 ac 60 10 00 	movl   $0x1060ac,(%esp)
  100a3d:	e8 fa f8 ff ff       	call   10033c <cprintf>
        print_debuginfo(eip - 1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	83 e8 01             	sub    $0x1,%eax
  100a48:	89 04 24             	mov    %eax,(%esp)
  100a4b:	e8 b6 fe ff ff       	call   100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a53:	83 c0 04             	add    $0x4,%eax
  100a56:	8b 00                	mov    (%eax),%eax
  100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a6b:	74 0a                	je     100a77 <print_stackframe+0xbd>
  100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a71:	0f 8e 68 ff ff ff    	jle    1009df <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    

00100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a86:	eb 0c                	jmp    100a94 <parse+0x1b>
            *buf ++ = '\0';
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	0f b6 00             	movzbl (%eax),%eax
  100a9a:	84 c0                	test   %al,%al
  100a9c:	74 1d                	je     100abb <parse+0x42>
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	0f be c0             	movsbl %al,%eax
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 30 61 10 00 	movl   $0x106130,(%esp)
  100ab2:	e8 e6 50 00 00       	call   105b9d <strchr>
  100ab7:	85 c0                	test   %eax,%eax
  100ab9:	75 cd                	jne    100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	75 02                	jne    100ac7 <parse+0x4e>
            break;
  100ac5:	eb 67                	jmp    100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100acb:	75 14                	jne    100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad4:	00 
  100ad5:	c7 04 24 35 61 10 00 	movl   $0x106135,(%esp)
  100adc:	e8 5b f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae4:	8d 50 01             	lea    0x1(%eax),%edx
  100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af4:	01 c2                	add    %eax,%edx
  100af6:	8b 45 08             	mov    0x8(%ebp),%eax
  100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	eb 04                	jmp    100b01 <parse+0x88>
            buf ++;
  100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1d                	je     100b28 <parse+0xaf>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 30 61 10 00 	movl   $0x106130,(%esp)
  100b1f:	e8 79 50 00 00       	call   105b9d <strchr>
  100b24:	85 c0                	test   %eax,%eax
  100b26:	74 d5                	je     100afd <parse+0x84>
            buf ++;
        }
    }
  100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b29:	e9 66 ff ff ff       	jmp    100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b31:	c9                   	leave  
  100b32:	c3                   	ret    

00100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b33:	55                   	push   %ebp
  100b34:	89 e5                	mov    %esp,%ebp
  100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 2e ff ff ff       	call   100a79 <parse>
  100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b52:	75 0a                	jne    100b5e <runcmd+0x2b>
        return 0;
  100b54:	b8 00 00 00 00       	mov    $0x0,%eax
  100b59:	e9 85 00 00 00       	jmp    100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b65:	eb 5c                	jmp    100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	01 c0                	add    %eax,%eax
  100b71:	01 d0                	add    %edx,%eax
  100b73:	c1 e0 02             	shl    $0x2,%eax
  100b76:	05 20 70 11 00       	add    $0x117020,%eax
  100b7b:	8b 00                	mov    (%eax),%eax
  100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b81:	89 04 24             	mov    %eax,(%esp)
  100b84:	e8 75 4f 00 00       	call   105afe <strcmp>
  100b89:	85 c0                	test   %eax,%eax
  100b8b:	75 32                	jne    100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b90:	89 d0                	mov    %edx,%eax
  100b92:	01 c0                	add    %eax,%eax
  100b94:	01 d0                	add    %edx,%eax
  100b96:	c1 e0 02             	shl    $0x2,%eax
  100b99:	05 20 70 11 00       	add    $0x117020,%eax
  100b9e:	8b 40 08             	mov    0x8(%eax),%eax
  100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb1:	83 c2 04             	add    $0x4,%edx
  100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb8:	89 0c 24             	mov    %ecx,(%esp)
  100bbb:	ff d0                	call   *%eax
  100bbd:	eb 24                	jmp    100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	76 9c                	jbe    100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	c7 04 24 53 61 10 00 	movl   $0x106153,(%esp)
  100bd9:	e8 5e f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be3:	c9                   	leave  
  100be4:	c3                   	ret    

00100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be5:	55                   	push   %ebp
  100be6:	89 e5                	mov    %esp,%ebp
  100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100beb:	c7 04 24 6c 61 10 00 	movl   $0x10616c,(%esp)
  100bf2:	e8 45 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf7:	c7 04 24 94 61 10 00 	movl   $0x106194,(%esp)
  100bfe:	e8 39 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c07:	74 0b                	je     100c14 <kmonitor+0x2f>
        print_trapframe(tf);
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 d7 0d 00 00       	call   1019eb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c14:	c7 04 24 b9 61 10 00 	movl   $0x1061b9,(%esp)
  100c1b:	e8 13 f6 ff ff       	call   100233 <readline>
  100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c27:	74 18                	je     100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c33:	89 04 24             	mov    %eax,(%esp)
  100c36:	e8 f8 fe ff ff       	call   100b33 <runcmd>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	79 02                	jns    100c41 <kmonitor+0x5c>
                break;
  100c3f:	eb 02                	jmp    100c43 <kmonitor+0x5e>
            }
        }
    }
  100c41:	eb d1                	jmp    100c14 <kmonitor+0x2f>
}
  100c43:	c9                   	leave  
  100c44:	c3                   	ret    

00100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c45:	55                   	push   %ebp
  100c46:	89 e5                	mov    %esp,%ebp
  100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c52:	eb 3f                	jmp    100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c57:	89 d0                	mov    %edx,%eax
  100c59:	01 c0                	add    %eax,%eax
  100c5b:	01 d0                	add    %edx,%eax
  100c5d:	c1 e0 02             	shl    $0x2,%eax
  100c60:	05 20 70 11 00       	add    $0x117020,%eax
  100c65:	8b 48 04             	mov    0x4(%eax),%ecx
  100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6b:	89 d0                	mov    %edx,%eax
  100c6d:	01 c0                	add    %eax,%eax
  100c6f:	01 d0                	add    %edx,%eax
  100c71:	c1 e0 02             	shl    $0x2,%eax
  100c74:	05 20 70 11 00       	add    $0x117020,%eax
  100c79:	8b 00                	mov    (%eax),%eax
  100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c83:	c7 04 24 bd 61 10 00 	movl   $0x1061bd,(%esp)
  100c8a:	e8 ad f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	83 f8 02             	cmp    $0x2,%eax
  100c99:	76 b9                	jbe    100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca0:	c9                   	leave  
  100ca1:	c3                   	ret    

00100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca2:	55                   	push   %ebp
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca8:	e8 c3 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb2:	c9                   	leave  
  100cb3:	c3                   	ret    

00100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
  100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cba:	e8 fb fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc4:	c9                   	leave  
  100cc5:	c3                   	ret    

00100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc6:	55                   	push   %ebp
  100cc7:	89 e5                	mov    %esp,%ebp
  100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccc:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd1:	85 c0                	test   %eax,%eax
  100cd3:	74 02                	je     100cd7 <__panic+0x11>
        goto panic_dead;
  100cd5:	eb 48                	jmp    100d1f <__panic+0x59>
    }
    is_panic = 1;
  100cd7:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cee:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	c7 04 24 c6 61 10 00 	movl   $0x1061c6,(%esp)
  100cfc:	e8 3b f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0b:	89 04 24             	mov    %eax,(%esp)
  100d0e:	e8 f6 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d13:	c7 04 24 e2 61 10 00 	movl   $0x1061e2,(%esp)
  100d1a:	e8 1d f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1f:	e8 85 09 00 00       	call   1016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2b:	e8 b5 fe ff ff       	call   100be5 <kmonitor>
    }
  100d30:	eb f2                	jmp    100d24 <__panic+0x5e>

00100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d38:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d45:	8b 45 08             	mov    0x8(%ebp),%eax
  100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4c:	c7 04 24 e4 61 10 00 	movl   $0x1061e4,(%esp)
  100d53:	e8 e4 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d62:	89 04 24             	mov    %eax,(%esp)
  100d65:	e8 9f f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6a:	c7 04 24 e2 61 10 00 	movl   $0x1061e2,(%esp)
  100d71:	e8 c6 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7b:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d80:	5d                   	pop    %ebp
  100d81:	c3                   	ret    

00100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 28             	sub    $0x28,%esp
  100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
  100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc1:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcb:	c7 04 24 02 62 10 00 	movl   $0x106202,(%esp)
  100dd2:	e8 65 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dde:	e8 24 09 00 00       	call   101707 <pic_enable>
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de5:	55                   	push   %ebp
  100de6:	89 e5                	mov    %esp,%ebp
  100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100deb:	9c                   	pushf  
  100dec:	58                   	pop    %eax
  100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df3:	25 00 02 00 00       	and    $0x200,%eax
  100df8:	85 c0                	test   %eax,%eax
  100dfa:	74 0c                	je     100e08 <__intr_save+0x23>
        intr_disable();
  100dfc:	e8 a8 08 00 00       	call   1016a9 <intr_disable>
        return 1;
  100e01:	b8 01 00 00 00       	mov    $0x1,%eax
  100e06:	eb 05                	jmp    100e0d <__intr_save+0x28>
    }
    return 0;
  100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0d:	c9                   	leave  
  100e0e:	c3                   	ret    

00100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0f:	55                   	push   %ebp
  100e10:	89 e5                	mov    %esp,%ebp
  100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e19:	74 05                	je     100e20 <__intr_restore+0x11>
        intr_enable();
  100e1b:	e8 83 08 00 00       	call   1016a3 <intr_enable>
    }
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 10             	sub    $0x10,%esp
  100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e32:	89 c2                	mov    %eax,%edx
  100e34:	ec                   	in     (%dx),%al
  100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e62:	89 c2                	mov    %eax,%edx
  100e64:	ec                   	in     (%dx),%al
  100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e68:	c9                   	leave  
  100e69:	c3                   	ret    

00100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6a:	55                   	push   %ebp
  100e6b:	89 e5                	mov    %esp,%ebp
  100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7a:	0f b7 00             	movzwl (%eax),%eax
  100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e93:	74 12                	je     100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9c:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea3:	b4 03 
  100ea5:	eb 13                	jmp    100eba <cga_init+0x50>
    } else {
        *cp = was;
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb1:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eba:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec1:	0f b7 c0             	movzwl %ax,%eax
  100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edc:	83 c0 01             	add    $0x1,%eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef4:	0f b6 c0             	movzbl %al,%eax
  100ef7:	c1 e0 08             	shl    $0x8,%eax
  100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f18:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1f:	83 c0 01             	add    $0x1,%eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2d:	89 c2                	mov    %eax,%edx
  100f2f:	ec                   	in     (%dx),%al
  100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f37:	0f b6 c0             	movzbl %al,%eax
  100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f40:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f48:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4e:	c9                   	leave  
  100f4f:	c3                   	ret    

00100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f50:	55                   	push   %ebp
  100f51:	89 e5                	mov    %esp,%ebp
  100f53:	83 ec 48             	sub    $0x48,%esp
  100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
  100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
  100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
  100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
  100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fef:	3c ff                	cmp    $0xff,%al
  100ff1:	0f 95 c0             	setne  %al
  100ff4:	0f b6 c0             	movzbl %al,%eax
  100ff7:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101016:	89 c2                	mov    %eax,%edx
  101018:	ec                   	in     (%dx),%al
  101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101c:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101021:	85 c0                	test   %eax,%eax
  101023:	74 0c                	je     101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102c:	e8 d6 06 00 00       	call   101707 <pic_enable>
    }
}
  101031:	c9                   	leave  
  101032:	c3                   	ret    

00101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101033:	55                   	push   %ebp
  101034:	89 e5                	mov    %esp,%ebp
  101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101040:	eb 09                	jmp    10104b <lpt_putc_sub+0x18>
        delay();
  101042:	e8 db fd ff ff       	call   100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101055:	89 c2                	mov    %eax,%edx
  101057:	ec                   	in     (%dx),%al
  101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105f:	84 c0                	test   %al,%al
  101061:	78 09                	js     10106c <lpt_putc_sub+0x39>
  101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106a:	7e d6                	jle    101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106c:	8b 45 08             	mov    0x8(%ebp),%eax
  10106f:	0f b6 c0             	movzbl %al,%eax
  101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
  101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
  101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010aa:	c9                   	leave  
  1010ab:	c3                   	ret    

001010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ac:	55                   	push   %ebp
  1010ad:	89 e5                	mov    %esp,%ebp
  1010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b6:	74 0d                	je     1010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bb:	89 04 24             	mov    %eax,(%esp)
  1010be:	e8 70 ff ff ff       	call   101033 <lpt_putc_sub>
  1010c3:	eb 24                	jmp    1010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cc:	e8 62 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d8:	e8 56 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e4:	e8 4a ff ff ff       	call   101033 <lpt_putc_sub>
    }
}
  1010e9:	c9                   	leave  
  1010ea:	c3                   	ret    

001010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010eb:	55                   	push   %ebp
  1010ec:	89 e5                	mov    %esp,%ebp
  1010ee:	53                   	push   %ebx
  1010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f5:	b0 00                	mov    $0x0,%al
  1010f7:	85 c0                	test   %eax,%eax
  1010f9:	75 07                	jne    101102 <cga_putc+0x17>
        c |= 0x0700;
  1010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101102:	8b 45 08             	mov    0x8(%ebp),%eax
  101105:	0f b6 c0             	movzbl %al,%eax
  101108:	83 f8 0a             	cmp    $0xa,%eax
  10110b:	74 4c                	je     101159 <cga_putc+0x6e>
  10110d:	83 f8 0d             	cmp    $0xd,%eax
  101110:	74 57                	je     101169 <cga_putc+0x7e>
  101112:	83 f8 08             	cmp    $0x8,%eax
  101115:	0f 85 88 00 00 00    	jne    1011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101122:	66 85 c0             	test   %ax,%ax
  101125:	74 30                	je     101157 <cga_putc+0x6c>
            crt_pos --;
  101127:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112e:	83 e8 01             	sub    $0x1,%eax
  101131:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101137:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113c:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101143:	0f b7 d2             	movzwl %dx,%edx
  101146:	01 d2                	add    %edx,%edx
  101148:	01 c2                	add    %eax,%edx
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	b0 00                	mov    $0x0,%al
  10114f:	83 c8 20             	or     $0x20,%eax
  101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101155:	eb 72                	jmp    1011c9 <cga_putc+0xde>
  101157:	eb 70                	jmp    1011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101159:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101160:	83 c0 50             	add    $0x50,%eax
  101163:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101169:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101170:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101177:	0f b7 c1             	movzwl %cx,%eax
  10117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101180:	c1 e8 10             	shr    $0x10,%eax
  101183:	89 c2                	mov    %eax,%edx
  101185:	66 c1 ea 06          	shr    $0x6,%dx
  101189:	89 d0                	mov    %edx,%eax
  10118b:	c1 e0 02             	shl    $0x2,%eax
  10118e:	01 d0                	add    %edx,%eax
  101190:	c1 e0 04             	shl    $0x4,%eax
  101193:	29 c1                	sub    %eax,%ecx
  101195:	89 ca                	mov    %ecx,%edx
  101197:	89 d8                	mov    %ebx,%eax
  101199:	29 d0                	sub    %edx,%eax
  10119b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a1:	eb 26                	jmp    1011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a3:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b0:	8d 50 01             	lea    0x1(%eax),%edx
  1011b3:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011ba:	0f b7 c0             	movzwl %ax,%eax
  1011bd:	01 c0                	add    %eax,%eax
  1011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d4:	76 5b                	jbe    101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ed:	00 
  1011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f2:	89 04 24             	mov    %eax,(%esp)
  1011f5:	e8 a1 4b 00 00       	call   105d9b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101201:	eb 15                	jmp    101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101203:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120b:	01 d2                	add    %edx,%edx
  10120d:	01 d0                	add    %edx,%eax
  10120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121f:	7e e2                	jle    101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101221:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101228:	83 e8 50             	sub    $0x50,%eax
  10122b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101231:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101253:	66 c1 e8 08          	shr    $0x8,%ax
  101257:	0f b6 c0             	movzbl %al,%eax
  10125a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101261:	83 c2 01             	add    $0x1,%edx
  101264:	0f b7 d2             	movzwl %dx,%edx
  101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101277:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127e:	0f b7 c0             	movzwl %ax,%eax
  101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101292:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a3:	83 c2 01             	add    $0x1,%edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	83 c4 34             	add    $0x34,%esp
  1012bc:	5b                   	pop    %ebx
  1012bd:	5d                   	pop    %ebp
  1012be:	c3                   	ret    

001012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 09                	jmp    1012d7 <serial_putc_sub+0x18>
        delay();
  1012ce:	e8 4f fb ff ff       	call   100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	83 e0 20             	and    $0x20,%eax
  1012f1:	85 c0                	test   %eax,%eax
  1012f3:	75 09                	jne    1012fe <serial_putc_sub+0x3f>
  1012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fc:	7e d0                	jle    1012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	0f b6 c0             	movzbl %al,%eax
  101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101322:	74 0d                	je     101331 <serial_putc+0x19>
        serial_putc_sub(c);
  101324:	8b 45 08             	mov    0x8(%ebp),%eax
  101327:	89 04 24             	mov    %eax,(%esp)
  10132a:	e8 90 ff ff ff       	call   1012bf <serial_putc_sub>
  10132f:	eb 24                	jmp    101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101338:	e8 82 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub(' ');
  10133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101344:	e8 76 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub('\b');
  101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101350:	e8 6a ff ff ff       	call   1012bf <serial_putc_sub>
    }
}
  101355:	c9                   	leave  
  101356:	c3                   	ret    

00101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101357:	55                   	push   %ebp
  101358:	89 e5                	mov    %esp,%ebp
  10135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135d:	eb 33                	jmp    101392 <cons_intr+0x3b>
        if (c != 0) {
  10135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101363:	74 2d                	je     101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101365:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136a:	8d 50 01             	lea    0x1(%eax),%edx
  10136d:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101376:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101381:	3d 00 02 00 00       	cmp    $0x200,%eax
  101386:	75 0a                	jne    101392 <cons_intr+0x3b>
                cons.wpos = 0;
  101388:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101392:	8b 45 08             	mov    0x8(%ebp),%eax
  101395:	ff d0                	call   *%eax
  101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139e:	75 bf                	jne    10135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 10             	sub    $0x10,%esp
  1013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	83 e0 01             	and    $0x1,%eax
  1013c2:	85 c0                	test   %eax,%eax
  1013c4:	75 07                	jne    1013cd <serial_proc_data+0x2b>
        return -1;
  1013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cb:	eb 2a                	jmp    1013f7 <serial_proc_data+0x55>
  1013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x52>
        c = '\b';
  1013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f7:	c9                   	leave  
  1013f8:	c3                   	ret    

001013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f9:	55                   	push   %ebp
  1013fa:	89 e5                	mov    %esp,%ebp
  1013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ff:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101404:	85 c0                	test   %eax,%eax
  101406:	74 0c                	je     101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101408:	c7 04 24 a2 13 10 00 	movl   $0x1013a2,(%esp)
  10140f:	e8 43 ff ff ff       	call   101357 <cons_intr>
    }
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 38             	sub    $0x38,%esp
  10141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101426:	89 c2                	mov    %eax,%edx
  101428:	ec                   	in     (%dx),%al
  101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101430:	0f b6 c0             	movzbl %al,%eax
  101433:	83 e0 01             	and    $0x1,%eax
  101436:	85 c0                	test   %eax,%eax
  101438:	75 0a                	jne    101444 <kbd_proc_data+0x2e>
        return -1;
  10143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143f:	e9 59 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
  101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144e:	89 c2                	mov    %eax,%edx
  101450:	ec                   	in     (%dx),%al
  101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145f:	75 17                	jne    101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101461:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101466:	83 c8 40             	or     $0x40,%eax
  101469:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
  101473:	e9 25 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147c:	84 c0                	test   %al,%al
  10147e:	79 47                	jns    1014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101480:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101485:	83 e0 40             	and    $0x40,%eax
  101488:	85 c0                	test   %eax,%eax
  10148a:	75 09                	jne    101495 <kbd_proc_data+0x7f>
  10148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101490:	83 e0 7f             	and    $0x7f,%eax
  101493:	eb 04                	jmp    101499 <kbd_proc_data+0x83>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a7:	83 c8 40             	or     $0x40,%eax
  1014aa:	0f b6 c0             	movzbl %al,%eax
  1014ad:	f7 d0                	not    %eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b6:	21 d0                	and    %edx,%eax
  1014b8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c2:	e9 d6 00 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cc:	83 e0 40             	and    $0x40,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	74 11                	je     1014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dc:	83 e0 bf             	and    $0xffffffbf,%eax
  1014df:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e8:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ef:	0f b6 d0             	movzbl %al,%edx
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	09 d0                	or     %edx,%eax
  1014f9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101511:	31 d0                	xor    %edx,%eax
  101513:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101518:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151d:	83 e0 03             	and    $0x3,%eax
  101520:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	01 d0                	add    %edx,%eax
  10152d:	0f b6 00             	movzbl (%eax),%eax
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101536:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153b:	83 e0 08             	and    $0x8,%eax
  10153e:	85 c0                	test   %eax,%eax
  101540:	74 22                	je     101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101546:	7e 0c                	jle    101554 <kbd_proc_data+0x13e>
  101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154c:	7f 06                	jg     101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101552:	eb 10                	jmp    101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101558:	7e 0a                	jle    101564 <kbd_proc_data+0x14e>
  10155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155e:	7f 04                	jg     101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101564:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101569:	f7 d0                	not    %eax
  10156b:	83 e0 06             	and    $0x6,%eax
  10156e:	85 c0                	test   %eax,%eax
  101570:	75 28                	jne    10159a <kbd_proc_data+0x184>
  101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101579:	75 1f                	jne    10159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157b:	c7 04 24 1d 62 10 00 	movl   $0x10621d,(%esp)
  101582:	e8 b5 ed ff ff       	call   10033c <cprintf>
  101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a5:	c7 04 24 16 14 10 00 	movl   $0x101416,(%esp)
  1015ac:	e8 a6 fd ff ff       	call   101357 <cons_intr>
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <kbd_init>:

static void
kbd_init(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b9:	e8 e1 ff ff ff       	call   10159f <kbd_intr>
    pic_enable(IRQ_KBD);
  1015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c5:	e8 3d 01 00 00       	call   101707 <pic_enable>
}
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d2:	e8 93 f8 ff ff       	call   100e6a <cga_init>
    serial_init();
  1015d7:	e8 74 f9 ff ff       	call   100f50 <serial_init>
    kbd_init();
  1015dc:	e8 d2 ff ff ff       	call   1015b3 <kbd_init>
    if (!serial_exists) {
  1015e1:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 0c                	jne    1015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ea:	c7 04 24 29 62 10 00 	movl   $0x106229,(%esp)
  1015f1:	e8 46 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f6:	c9                   	leave  
  1015f7:	c3                   	ret    

001015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f8:	55                   	push   %ebp
  1015f9:	89 e5                	mov    %esp,%ebp
  1015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fe:	e8 e2 f7 ff ff       	call   100de5 <__intr_save>
  101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101606:	8b 45 08             	mov    0x8(%ebp),%eax
  101609:	89 04 24             	mov    %eax,(%esp)
  10160c:	e8 9b fa ff ff       	call   1010ac <lpt_putc>
        cga_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 cf fa ff ff       	call   1010eb <cga_putc>
        serial_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 f1 fc ff ff       	call   101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 dd f7 ff ff       	call   100e0f <__intr_restore>
}
  101632:	c9                   	leave  
  101633:	c3                   	ret    

00101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101641:	e8 9f f7 ff ff       	call   100de5 <__intr_save>
  101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101649:	e8 ab fd ff ff       	call   1013f9 <serial_intr>
        kbd_intr();
  10164e:	e8 4c ff ff ff       	call   10159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101653:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101659:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165e:	39 c2                	cmp    %eax,%edx
  101660:	74 31                	je     101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101662:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101667:	8d 50 01             	lea    0x1(%eax),%edx
  10166a:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101670:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101677:	0f b6 c0             	movzbl %al,%eax
  10167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101682:	3d 00 02 00 00       	cmp    $0x200,%eax
  101687:	75 0a                	jne    101693 <cons_getc+0x5f>
                cons.rpos = 0;
  101689:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101696:	89 04 24             	mov    %eax,(%esp)
  101699:	e8 71 f7 ff ff       	call   100e0f <__intr_restore>
    return c;
  10169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a1:	c9                   	leave  
  1016a2:	c3                   	ret    

001016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a6:	fb                   	sti    
    sti();
}
  1016a7:	5d                   	pop    %ebp
  1016a8:	c3                   	ret    

001016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ac:	fa                   	cli    
    cli();
}
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    

001016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 14             	sub    $0x14,%esp
  1016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c0:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c6:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016cb:	85 c0                	test   %eax,%eax
  1016cd:	74 36                	je     101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d3:	0f b6 c0             	movzbl %al,%eax
  1016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ec:	66 c1 e8 08          	shr    $0x8,%ax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
    }
}
  101705:	c9                   	leave  
  101706:	c3                   	ret    

00101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101707:	55                   	push   %ebp
  101708:	89 e5                	mov    %esp,%ebp
  10170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170d:	8b 45 08             	mov    0x8(%ebp),%eax
  101710:	ba 01 00 00 00       	mov    $0x1,%edx
  101715:	89 c1                	mov    %eax,%ecx
  101717:	d3 e2                	shl    %cl,%edx
  101719:	89 d0                	mov    %edx,%eax
  10171b:	f7 d0                	not    %eax
  10171d:	89 c2                	mov    %eax,%edx
  10171f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101726:	21 d0                	and    %edx,%eax
  101728:	0f b7 c0             	movzwl %ax,%eax
  10172b:	89 04 24             	mov    %eax,(%esp)
  10172e:	e8 7c ff ff ff       	call   1016af <pic_setmask>
}
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101735:	55                   	push   %ebp
  101736:	89 e5                	mov    %esp,%ebp
  101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173b:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101742:	00 00 00 
  101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101757:	ee                   	out    %al,(%dx)
  101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176a:	ee                   	out    %al,(%dx)
  10176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177d:	ee                   	out    %al,(%dx)
  10177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
  101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a3:	ee                   	out    %al,(%dx)
  1017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
  1017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
  1017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
  1017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ef:	ee                   	out    %al,(%dx)
  1017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
  101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101815:	ee                   	out    %al,(%dx)
  101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
  101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
  10183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101856:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185a:	74 12                	je     10186e <pic_init+0x139>
        pic_setmask(irq_mask);
  10185c:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101863:	0f b7 c0             	movzwl %ax,%eax
  101866:	89 04 24             	mov    %eax,(%esp)
  101869:	e8 41 fe ff ff       	call   1016af <pic_setmask>
    }
}
  10186e:	c9                   	leave  
  10186f:	c3                   	ret    

00101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101870:	55                   	push   %ebp
  101871:	89 e5                	mov    %esp,%ebp
  101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187d:	00 
  10187e:	c7 04 24 60 62 10 00 	movl   $0x106260,(%esp)
  101885:	e8 b2 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10188a:	c7 04 24 6a 62 10 00 	movl   $0x10626a,(%esp)
  101891:	e8 a6 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  101896:	c7 44 24 08 78 62 10 	movl   $0x106278,0x8(%esp)
  10189d:	00 
  10189e:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018a5:	00 
  1018a6:	c7 04 24 8e 62 10 00 	movl   $0x10628e,(%esp)
  1018ad:	e8 14 f4 ff ff       	call   100cc6 <__panic>

001018b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b2:	55                   	push   %ebp
  1018b3:	89 e5                	mov    %esp,%ebp
  1018b5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018bf:	e9 c3 00 00 00       	jmp    101987 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c7:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018ce:	89 c2                	mov    %eax,%edx
  1018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d3:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018da:	00 
  1018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018de:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018e5:	00 08 00 
  1018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018eb:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f2:	00 
  1018f3:	83 e2 e0             	and    $0xffffffe0,%edx
  1018f6:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101900:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101907:	00 
  101908:	83 e2 1f             	and    $0x1f,%edx
  10190b:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101915:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10191c:	00 
  10191d:	83 e2 f0             	and    $0xfffffff0,%edx
  101920:	83 ca 0e             	or     $0xe,%edx
  101923:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101934:	00 
  101935:	83 e2 ef             	and    $0xffffffef,%edx
  101938:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101942:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101949:	00 
  10194a:	83 e2 9f             	and    $0xffffff9f,%edx
  10194d:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101954:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101957:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10195e:	00 
  10195f:	83 ca 80             	or     $0xffffff80,%edx
  101962:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196c:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101973:	c1 e8 10             	shr    $0x10,%eax
  101976:	89 c2                	mov    %eax,%edx
  101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197b:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101982:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101983:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198a:	3d ff 00 00 00       	cmp    $0xff,%eax
  10198f:	0f 86 2f ff ff ff    	jbe    1018c4 <idt_init+0x12>
  101995:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  10199c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10199f:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
  1019a2:	c9                   	leave  
  1019a3:	c3                   	ret    

001019a4 <trapname>:

static const char *
trapname(int trapno) {
  1019a4:	55                   	push   %ebp
  1019a5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019aa:	83 f8 13             	cmp    $0x13,%eax
  1019ad:	77 0c                	ja     1019bb <trapname+0x17>
        return excnames[trapno];
  1019af:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b2:	8b 04 85 e0 65 10 00 	mov    0x1065e0(,%eax,4),%eax
  1019b9:	eb 18                	jmp    1019d3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019bb:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019bf:	7e 0d                	jle    1019ce <trapname+0x2a>
  1019c1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019c5:	7f 07                	jg     1019ce <trapname+0x2a>
        return "Hardware Interrupt";
  1019c7:	b8 9f 62 10 00       	mov    $0x10629f,%eax
  1019cc:	eb 05                	jmp    1019d3 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019ce:	b8 b2 62 10 00       	mov    $0x1062b2,%eax
}
  1019d3:	5d                   	pop    %ebp
  1019d4:	c3                   	ret    

001019d5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019d5:	55                   	push   %ebp
  1019d6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019df:	66 83 f8 08          	cmp    $0x8,%ax
  1019e3:	0f 94 c0             	sete   %al
  1019e6:	0f b6 c0             	movzbl %al,%eax
}
  1019e9:	5d                   	pop    %ebp
  1019ea:	c3                   	ret    

001019eb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019eb:	55                   	push   %ebp
  1019ec:	89 e5                	mov    %esp,%ebp
  1019ee:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f8:	c7 04 24 f3 62 10 00 	movl   $0x1062f3,(%esp)
  1019ff:	e8 38 e9 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a04:	8b 45 08             	mov    0x8(%ebp),%eax
  101a07:	89 04 24             	mov    %eax,(%esp)
  101a0a:	e8 a1 01 00 00       	call   101bb0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a12:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a16:	0f b7 c0             	movzwl %ax,%eax
  101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1d:	c7 04 24 04 63 10 00 	movl   $0x106304,(%esp)
  101a24:	e8 13 e9 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a29:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a30:	0f b7 c0             	movzwl %ax,%eax
  101a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a37:	c7 04 24 17 63 10 00 	movl   $0x106317,(%esp)
  101a3e:	e8 f9 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4a:	0f b7 c0             	movzwl %ax,%eax
  101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a51:	c7 04 24 2a 63 10 00 	movl   $0x10632a,(%esp)
  101a58:	e8 df e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a64:	0f b7 c0             	movzwl %ax,%eax
  101a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6b:	c7 04 24 3d 63 10 00 	movl   $0x10633d,(%esp)
  101a72:	e8 c5 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a77:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7a:	8b 40 30             	mov    0x30(%eax),%eax
  101a7d:	89 04 24             	mov    %eax,(%esp)
  101a80:	e8 1f ff ff ff       	call   1019a4 <trapname>
  101a85:	8b 55 08             	mov    0x8(%ebp),%edx
  101a88:	8b 52 30             	mov    0x30(%edx),%edx
  101a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a8f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a93:	c7 04 24 50 63 10 00 	movl   $0x106350,(%esp)
  101a9a:	e8 9d e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 34             	mov    0x34(%eax),%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 62 63 10 00 	movl   $0x106362,(%esp)
  101ab0:	e8 87 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	8b 40 38             	mov    0x38(%eax),%eax
  101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abf:	c7 04 24 71 63 10 00 	movl   $0x106371,(%esp)
  101ac6:	e8 71 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101acb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ace:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad2:	0f b7 c0             	movzwl %ax,%eax
  101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad9:	c7 04 24 80 63 10 00 	movl   $0x106380,(%esp)
  101ae0:	e8 57 e8 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae8:	8b 40 40             	mov    0x40(%eax),%eax
  101aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aef:	c7 04 24 93 63 10 00 	movl   $0x106393,(%esp)
  101af6:	e8 41 e8 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101afb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b02:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b09:	eb 3e                	jmp    101b49 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	8b 50 40             	mov    0x40(%eax),%edx
  101b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b14:	21 d0                	and    %edx,%eax
  101b16:	85 c0                	test   %eax,%eax
  101b18:	74 28                	je     101b42 <print_trapframe+0x157>
  101b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b1d:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b24:	85 c0                	test   %eax,%eax
  101b26:	74 1a                	je     101b42 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2b:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b32:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b36:	c7 04 24 a2 63 10 00 	movl   $0x1063a2,(%esp)
  101b3d:	e8 fa e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b46:	d1 65 f0             	shll   -0x10(%ebp)
  101b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b4c:	83 f8 17             	cmp    $0x17,%eax
  101b4f:	76 ba                	jbe    101b0b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	8b 40 40             	mov    0x40(%eax),%eax
  101b57:	25 00 30 00 00       	and    $0x3000,%eax
  101b5c:	c1 e8 0c             	shr    $0xc,%eax
  101b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b63:	c7 04 24 a6 63 10 00 	movl   $0x1063a6,(%esp)
  101b6a:	e8 cd e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b72:	89 04 24             	mov    %eax,(%esp)
  101b75:	e8 5b fe ff ff       	call   1019d5 <trap_in_kernel>
  101b7a:	85 c0                	test   %eax,%eax
  101b7c:	75 30                	jne    101bae <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	8b 40 44             	mov    0x44(%eax),%eax
  101b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b88:	c7 04 24 af 63 10 00 	movl   $0x1063af,(%esp)
  101b8f:	e8 a8 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b94:	8b 45 08             	mov    0x8(%ebp),%eax
  101b97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b9b:	0f b7 c0             	movzwl %ax,%eax
  101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba2:	c7 04 24 be 63 10 00 	movl   $0x1063be,(%esp)
  101ba9:	e8 8e e7 ff ff       	call   10033c <cprintf>
    }
}
  101bae:	c9                   	leave  
  101baf:	c3                   	ret    

00101bb0 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb0:	55                   	push   %ebp
  101bb1:	89 e5                	mov    %esp,%ebp
  101bb3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb9:	8b 00                	mov    (%eax),%eax
  101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbf:	c7 04 24 d1 63 10 00 	movl   $0x1063d1,(%esp)
  101bc6:	e8 71 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	8b 40 04             	mov    0x4(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 e0 63 10 00 	movl   $0x1063e0,(%esp)
  101bdc:	e8 5b e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 08             	mov    0x8(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 ef 63 10 00 	movl   $0x1063ef,(%esp)
  101bf2:	e8 45 e7 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  101bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c01:	c7 04 24 fe 63 10 00 	movl   $0x1063fe,(%esp)
  101c08:	e8 2f e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c10:	8b 40 10             	mov    0x10(%eax),%eax
  101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c17:	c7 04 24 0d 64 10 00 	movl   $0x10640d,(%esp)
  101c1e:	e8 19 e7 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c23:	8b 45 08             	mov    0x8(%ebp),%eax
  101c26:	8b 40 14             	mov    0x14(%eax),%eax
  101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2d:	c7 04 24 1c 64 10 00 	movl   $0x10641c,(%esp)
  101c34:	e8 03 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c39:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3c:	8b 40 18             	mov    0x18(%eax),%eax
  101c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c43:	c7 04 24 2b 64 10 00 	movl   $0x10642b,(%esp)
  101c4a:	e8 ed e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c52:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c59:	c7 04 24 3a 64 10 00 	movl   $0x10643a,(%esp)
  101c60:	e8 d7 e6 ff ff       	call   10033c <cprintf>
}
  101c65:	c9                   	leave  
  101c66:	c3                   	ret    

00101c67 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c67:	55                   	push   %ebp
  101c68:	89 e5                	mov    %esp,%ebp
  101c6a:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 30             	mov    0x30(%eax),%eax
  101c73:	83 f8 2f             	cmp    $0x2f,%eax
  101c76:	77 21                	ja     101c99 <trap_dispatch+0x32>
  101c78:	83 f8 2e             	cmp    $0x2e,%eax
  101c7b:	0f 83 04 01 00 00    	jae    101d85 <trap_dispatch+0x11e>
  101c81:	83 f8 21             	cmp    $0x21,%eax
  101c84:	0f 84 81 00 00 00    	je     101d0b <trap_dispatch+0xa4>
  101c8a:	83 f8 24             	cmp    $0x24,%eax
  101c8d:	74 56                	je     101ce5 <trap_dispatch+0x7e>
  101c8f:	83 f8 20             	cmp    $0x20,%eax
  101c92:	74 16                	je     101caa <trap_dispatch+0x43>
  101c94:	e9 b4 00 00 00       	jmp    101d4d <trap_dispatch+0xe6>
  101c99:	83 e8 78             	sub    $0x78,%eax
  101c9c:	83 f8 01             	cmp    $0x1,%eax
  101c9f:	0f 87 a8 00 00 00    	ja     101d4d <trap_dispatch+0xe6>
  101ca5:	e9 87 00 00 00       	jmp    101d31 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks ++;
  101caa:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101caf:	83 c0 01             	add    $0x1,%eax
  101cb2:	a3 4c 89 11 00       	mov    %eax,0x11894c
		if (ticks % TICK_NUM == 0) {
  101cb7:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101cbd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cc2:	89 c8                	mov    %ecx,%eax
  101cc4:	f7 e2                	mul    %edx
  101cc6:	89 d0                	mov    %edx,%eax
  101cc8:	c1 e8 05             	shr    $0x5,%eax
  101ccb:	6b c0 64             	imul   $0x64,%eax,%eax
  101cce:	29 c1                	sub    %eax,%ecx
  101cd0:	89 c8                	mov    %ecx,%eax
  101cd2:	85 c0                	test   %eax,%eax
  101cd4:	75 0a                	jne    101ce0 <trap_dispatch+0x79>
			print_ticks();
  101cd6:	e8 95 fb ff ff       	call   101870 <print_ticks>
		}
        break;
  101cdb:	e9 a6 00 00 00       	jmp    101d86 <trap_dispatch+0x11f>
  101ce0:	e9 a1 00 00 00       	jmp    101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ce5:	e8 4a f9 ff ff       	call   101634 <cons_getc>
  101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfd:	c7 04 24 49 64 10 00 	movl   $0x106449,(%esp)
  101d04:	e8 33 e6 ff ff       	call   10033c <cprintf>
        break;
  101d09:	eb 7b                	jmp    101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d0b:	e8 24 f9 ff ff       	call   101634 <cons_getc>
  101d10:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d13:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d17:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d23:	c7 04 24 5b 64 10 00 	movl   $0x10645b,(%esp)
  101d2a:	e8 0d e6 ff ff       	call   10033c <cprintf>
        break;
  101d2f:	eb 55                	jmp    101d86 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d31:	c7 44 24 08 6a 64 10 	movl   $0x10646a,0x8(%esp)
  101d38:	00 
  101d39:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101d40:	00 
  101d41:	c7 04 24 8e 62 10 00 	movl   $0x10628e,(%esp)
  101d48:	e8 79 ef ff ff       	call   100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d50:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d54:	0f b7 c0             	movzwl %ax,%eax
  101d57:	83 e0 03             	and    $0x3,%eax
  101d5a:	85 c0                	test   %eax,%eax
  101d5c:	75 28                	jne    101d86 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d61:	89 04 24             	mov    %eax,(%esp)
  101d64:	e8 82 fc ff ff       	call   1019eb <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d69:	c7 44 24 08 7a 64 10 	movl   $0x10647a,0x8(%esp)
  101d70:	00 
  101d71:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101d78:	00 
  101d79:	c7 04 24 8e 62 10 00 	movl   $0x10628e,(%esp)
  101d80:	e8 41 ef ff ff       	call   100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d85:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d86:	c9                   	leave  
  101d87:	c3                   	ret    

00101d88 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d88:	55                   	push   %ebp
  101d89:	89 e5                	mov    %esp,%ebp
  101d8b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	89 04 24             	mov    %eax,(%esp)
  101d94:	e8 ce fe ff ff       	call   101c67 <trap_dispatch>
}
  101d99:	c9                   	leave  
  101d9a:	c3                   	ret    

00101d9b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d9b:	1e                   	push   %ds
    pushl %es
  101d9c:	06                   	push   %es
    pushl %fs
  101d9d:	0f a0                	push   %fs
    pushl %gs
  101d9f:	0f a8                	push   %gs
    pushal
  101da1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101da2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101da7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101da9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101dab:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101dac:	e8 d7 ff ff ff       	call   101d88 <trap>

    # pop the pushed stack pointer
    popl %esp
  101db1:	5c                   	pop    %esp

00101db2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101db2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101db3:	0f a9                	pop    %gs
    popl %fs
  101db5:	0f a1                	pop    %fs
    popl %es
  101db7:	07                   	pop    %es
    popl %ds
  101db8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101db9:	83 c4 08             	add    $0x8,%esp
    iret
  101dbc:	cf                   	iret   

00101dbd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dbd:	6a 00                	push   $0x0
  pushl $0
  101dbf:	6a 00                	push   $0x0
  jmp __alltraps
  101dc1:	e9 d5 ff ff ff       	jmp    101d9b <__alltraps>

00101dc6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101dc6:	6a 00                	push   $0x0
  pushl $1
  101dc8:	6a 01                	push   $0x1
  jmp __alltraps
  101dca:	e9 cc ff ff ff       	jmp    101d9b <__alltraps>

00101dcf <vector2>:
.globl vector2
vector2:
  pushl $0
  101dcf:	6a 00                	push   $0x0
  pushl $2
  101dd1:	6a 02                	push   $0x2
  jmp __alltraps
  101dd3:	e9 c3 ff ff ff       	jmp    101d9b <__alltraps>

00101dd8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101dd8:	6a 00                	push   $0x0
  pushl $3
  101dda:	6a 03                	push   $0x3
  jmp __alltraps
  101ddc:	e9 ba ff ff ff       	jmp    101d9b <__alltraps>

00101de1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101de1:	6a 00                	push   $0x0
  pushl $4
  101de3:	6a 04                	push   $0x4
  jmp __alltraps
  101de5:	e9 b1 ff ff ff       	jmp    101d9b <__alltraps>

00101dea <vector5>:
.globl vector5
vector5:
  pushl $0
  101dea:	6a 00                	push   $0x0
  pushl $5
  101dec:	6a 05                	push   $0x5
  jmp __alltraps
  101dee:	e9 a8 ff ff ff       	jmp    101d9b <__alltraps>

00101df3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101df3:	6a 00                	push   $0x0
  pushl $6
  101df5:	6a 06                	push   $0x6
  jmp __alltraps
  101df7:	e9 9f ff ff ff       	jmp    101d9b <__alltraps>

00101dfc <vector7>:
.globl vector7
vector7:
  pushl $0
  101dfc:	6a 00                	push   $0x0
  pushl $7
  101dfe:	6a 07                	push   $0x7
  jmp __alltraps
  101e00:	e9 96 ff ff ff       	jmp    101d9b <__alltraps>

00101e05 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e05:	6a 08                	push   $0x8
  jmp __alltraps
  101e07:	e9 8f ff ff ff       	jmp    101d9b <__alltraps>

00101e0c <vector9>:
.globl vector9
vector9:
  pushl $9
  101e0c:	6a 09                	push   $0x9
  jmp __alltraps
  101e0e:	e9 88 ff ff ff       	jmp    101d9b <__alltraps>

00101e13 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e13:	6a 0a                	push   $0xa
  jmp __alltraps
  101e15:	e9 81 ff ff ff       	jmp    101d9b <__alltraps>

00101e1a <vector11>:
.globl vector11
vector11:
  pushl $11
  101e1a:	6a 0b                	push   $0xb
  jmp __alltraps
  101e1c:	e9 7a ff ff ff       	jmp    101d9b <__alltraps>

00101e21 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e21:	6a 0c                	push   $0xc
  jmp __alltraps
  101e23:	e9 73 ff ff ff       	jmp    101d9b <__alltraps>

00101e28 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e28:	6a 0d                	push   $0xd
  jmp __alltraps
  101e2a:	e9 6c ff ff ff       	jmp    101d9b <__alltraps>

00101e2f <vector14>:
.globl vector14
vector14:
  pushl $14
  101e2f:	6a 0e                	push   $0xe
  jmp __alltraps
  101e31:	e9 65 ff ff ff       	jmp    101d9b <__alltraps>

00101e36 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $15
  101e38:	6a 0f                	push   $0xf
  jmp __alltraps
  101e3a:	e9 5c ff ff ff       	jmp    101d9b <__alltraps>

00101e3f <vector16>:
.globl vector16
vector16:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $16
  101e41:	6a 10                	push   $0x10
  jmp __alltraps
  101e43:	e9 53 ff ff ff       	jmp    101d9b <__alltraps>

00101e48 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e48:	6a 11                	push   $0x11
  jmp __alltraps
  101e4a:	e9 4c ff ff ff       	jmp    101d9b <__alltraps>

00101e4f <vector18>:
.globl vector18
vector18:
  pushl $0
  101e4f:	6a 00                	push   $0x0
  pushl $18
  101e51:	6a 12                	push   $0x12
  jmp __alltraps
  101e53:	e9 43 ff ff ff       	jmp    101d9b <__alltraps>

00101e58 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e58:	6a 00                	push   $0x0
  pushl $19
  101e5a:	6a 13                	push   $0x13
  jmp __alltraps
  101e5c:	e9 3a ff ff ff       	jmp    101d9b <__alltraps>

00101e61 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e61:	6a 00                	push   $0x0
  pushl $20
  101e63:	6a 14                	push   $0x14
  jmp __alltraps
  101e65:	e9 31 ff ff ff       	jmp    101d9b <__alltraps>

00101e6a <vector21>:
.globl vector21
vector21:
  pushl $0
  101e6a:	6a 00                	push   $0x0
  pushl $21
  101e6c:	6a 15                	push   $0x15
  jmp __alltraps
  101e6e:	e9 28 ff ff ff       	jmp    101d9b <__alltraps>

00101e73 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e73:	6a 00                	push   $0x0
  pushl $22
  101e75:	6a 16                	push   $0x16
  jmp __alltraps
  101e77:	e9 1f ff ff ff       	jmp    101d9b <__alltraps>

00101e7c <vector23>:
.globl vector23
vector23:
  pushl $0
  101e7c:	6a 00                	push   $0x0
  pushl $23
  101e7e:	6a 17                	push   $0x17
  jmp __alltraps
  101e80:	e9 16 ff ff ff       	jmp    101d9b <__alltraps>

00101e85 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e85:	6a 00                	push   $0x0
  pushl $24
  101e87:	6a 18                	push   $0x18
  jmp __alltraps
  101e89:	e9 0d ff ff ff       	jmp    101d9b <__alltraps>

00101e8e <vector25>:
.globl vector25
vector25:
  pushl $0
  101e8e:	6a 00                	push   $0x0
  pushl $25
  101e90:	6a 19                	push   $0x19
  jmp __alltraps
  101e92:	e9 04 ff ff ff       	jmp    101d9b <__alltraps>

00101e97 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e97:	6a 00                	push   $0x0
  pushl $26
  101e99:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e9b:	e9 fb fe ff ff       	jmp    101d9b <__alltraps>

00101ea0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ea0:	6a 00                	push   $0x0
  pushl $27
  101ea2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ea4:	e9 f2 fe ff ff       	jmp    101d9b <__alltraps>

00101ea9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ea9:	6a 00                	push   $0x0
  pushl $28
  101eab:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ead:	e9 e9 fe ff ff       	jmp    101d9b <__alltraps>

00101eb2 <vector29>:
.globl vector29
vector29:
  pushl $0
  101eb2:	6a 00                	push   $0x0
  pushl $29
  101eb4:	6a 1d                	push   $0x1d
  jmp __alltraps
  101eb6:	e9 e0 fe ff ff       	jmp    101d9b <__alltraps>

00101ebb <vector30>:
.globl vector30
vector30:
  pushl $0
  101ebb:	6a 00                	push   $0x0
  pushl $30
  101ebd:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ebf:	e9 d7 fe ff ff       	jmp    101d9b <__alltraps>

00101ec4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ec4:	6a 00                	push   $0x0
  pushl $31
  101ec6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ec8:	e9 ce fe ff ff       	jmp    101d9b <__alltraps>

00101ecd <vector32>:
.globl vector32
vector32:
  pushl $0
  101ecd:	6a 00                	push   $0x0
  pushl $32
  101ecf:	6a 20                	push   $0x20
  jmp __alltraps
  101ed1:	e9 c5 fe ff ff       	jmp    101d9b <__alltraps>

00101ed6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ed6:	6a 00                	push   $0x0
  pushl $33
  101ed8:	6a 21                	push   $0x21
  jmp __alltraps
  101eda:	e9 bc fe ff ff       	jmp    101d9b <__alltraps>

00101edf <vector34>:
.globl vector34
vector34:
  pushl $0
  101edf:	6a 00                	push   $0x0
  pushl $34
  101ee1:	6a 22                	push   $0x22
  jmp __alltraps
  101ee3:	e9 b3 fe ff ff       	jmp    101d9b <__alltraps>

00101ee8 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ee8:	6a 00                	push   $0x0
  pushl $35
  101eea:	6a 23                	push   $0x23
  jmp __alltraps
  101eec:	e9 aa fe ff ff       	jmp    101d9b <__alltraps>

00101ef1 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ef1:	6a 00                	push   $0x0
  pushl $36
  101ef3:	6a 24                	push   $0x24
  jmp __alltraps
  101ef5:	e9 a1 fe ff ff       	jmp    101d9b <__alltraps>

00101efa <vector37>:
.globl vector37
vector37:
  pushl $0
  101efa:	6a 00                	push   $0x0
  pushl $37
  101efc:	6a 25                	push   $0x25
  jmp __alltraps
  101efe:	e9 98 fe ff ff       	jmp    101d9b <__alltraps>

00101f03 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f03:	6a 00                	push   $0x0
  pushl $38
  101f05:	6a 26                	push   $0x26
  jmp __alltraps
  101f07:	e9 8f fe ff ff       	jmp    101d9b <__alltraps>

00101f0c <vector39>:
.globl vector39
vector39:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $39
  101f0e:	6a 27                	push   $0x27
  jmp __alltraps
  101f10:	e9 86 fe ff ff       	jmp    101d9b <__alltraps>

00101f15 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $40
  101f17:	6a 28                	push   $0x28
  jmp __alltraps
  101f19:	e9 7d fe ff ff       	jmp    101d9b <__alltraps>

00101f1e <vector41>:
.globl vector41
vector41:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $41
  101f20:	6a 29                	push   $0x29
  jmp __alltraps
  101f22:	e9 74 fe ff ff       	jmp    101d9b <__alltraps>

00101f27 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $42
  101f29:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f2b:	e9 6b fe ff ff       	jmp    101d9b <__alltraps>

00101f30 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $43
  101f32:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f34:	e9 62 fe ff ff       	jmp    101d9b <__alltraps>

00101f39 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $44
  101f3b:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f3d:	e9 59 fe ff ff       	jmp    101d9b <__alltraps>

00101f42 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $45
  101f44:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f46:	e9 50 fe ff ff       	jmp    101d9b <__alltraps>

00101f4b <vector46>:
.globl vector46
vector46:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $46
  101f4d:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f4f:	e9 47 fe ff ff       	jmp    101d9b <__alltraps>

00101f54 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $47
  101f56:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f58:	e9 3e fe ff ff       	jmp    101d9b <__alltraps>

00101f5d <vector48>:
.globl vector48
vector48:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $48
  101f5f:	6a 30                	push   $0x30
  jmp __alltraps
  101f61:	e9 35 fe ff ff       	jmp    101d9b <__alltraps>

00101f66 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $49
  101f68:	6a 31                	push   $0x31
  jmp __alltraps
  101f6a:	e9 2c fe ff ff       	jmp    101d9b <__alltraps>

00101f6f <vector50>:
.globl vector50
vector50:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $50
  101f71:	6a 32                	push   $0x32
  jmp __alltraps
  101f73:	e9 23 fe ff ff       	jmp    101d9b <__alltraps>

00101f78 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $51
  101f7a:	6a 33                	push   $0x33
  jmp __alltraps
  101f7c:	e9 1a fe ff ff       	jmp    101d9b <__alltraps>

00101f81 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $52
  101f83:	6a 34                	push   $0x34
  jmp __alltraps
  101f85:	e9 11 fe ff ff       	jmp    101d9b <__alltraps>

00101f8a <vector53>:
.globl vector53
vector53:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $53
  101f8c:	6a 35                	push   $0x35
  jmp __alltraps
  101f8e:	e9 08 fe ff ff       	jmp    101d9b <__alltraps>

00101f93 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $54
  101f95:	6a 36                	push   $0x36
  jmp __alltraps
  101f97:	e9 ff fd ff ff       	jmp    101d9b <__alltraps>

00101f9c <vector55>:
.globl vector55
vector55:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $55
  101f9e:	6a 37                	push   $0x37
  jmp __alltraps
  101fa0:	e9 f6 fd ff ff       	jmp    101d9b <__alltraps>

00101fa5 <vector56>:
.globl vector56
vector56:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $56
  101fa7:	6a 38                	push   $0x38
  jmp __alltraps
  101fa9:	e9 ed fd ff ff       	jmp    101d9b <__alltraps>

00101fae <vector57>:
.globl vector57
vector57:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $57
  101fb0:	6a 39                	push   $0x39
  jmp __alltraps
  101fb2:	e9 e4 fd ff ff       	jmp    101d9b <__alltraps>

00101fb7 <vector58>:
.globl vector58
vector58:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $58
  101fb9:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fbb:	e9 db fd ff ff       	jmp    101d9b <__alltraps>

00101fc0 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $59
  101fc2:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fc4:	e9 d2 fd ff ff       	jmp    101d9b <__alltraps>

00101fc9 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $60
  101fcb:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fcd:	e9 c9 fd ff ff       	jmp    101d9b <__alltraps>

00101fd2 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $61
  101fd4:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fd6:	e9 c0 fd ff ff       	jmp    101d9b <__alltraps>

00101fdb <vector62>:
.globl vector62
vector62:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $62
  101fdd:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fdf:	e9 b7 fd ff ff       	jmp    101d9b <__alltraps>

00101fe4 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $63
  101fe6:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fe8:	e9 ae fd ff ff       	jmp    101d9b <__alltraps>

00101fed <vector64>:
.globl vector64
vector64:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $64
  101fef:	6a 40                	push   $0x40
  jmp __alltraps
  101ff1:	e9 a5 fd ff ff       	jmp    101d9b <__alltraps>

00101ff6 <vector65>:
.globl vector65
vector65:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $65
  101ff8:	6a 41                	push   $0x41
  jmp __alltraps
  101ffa:	e9 9c fd ff ff       	jmp    101d9b <__alltraps>

00101fff <vector66>:
.globl vector66
vector66:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $66
  102001:	6a 42                	push   $0x42
  jmp __alltraps
  102003:	e9 93 fd ff ff       	jmp    101d9b <__alltraps>

00102008 <vector67>:
.globl vector67
vector67:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $67
  10200a:	6a 43                	push   $0x43
  jmp __alltraps
  10200c:	e9 8a fd ff ff       	jmp    101d9b <__alltraps>

00102011 <vector68>:
.globl vector68
vector68:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $68
  102013:	6a 44                	push   $0x44
  jmp __alltraps
  102015:	e9 81 fd ff ff       	jmp    101d9b <__alltraps>

0010201a <vector69>:
.globl vector69
vector69:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $69
  10201c:	6a 45                	push   $0x45
  jmp __alltraps
  10201e:	e9 78 fd ff ff       	jmp    101d9b <__alltraps>

00102023 <vector70>:
.globl vector70
vector70:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $70
  102025:	6a 46                	push   $0x46
  jmp __alltraps
  102027:	e9 6f fd ff ff       	jmp    101d9b <__alltraps>

0010202c <vector71>:
.globl vector71
vector71:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $71
  10202e:	6a 47                	push   $0x47
  jmp __alltraps
  102030:	e9 66 fd ff ff       	jmp    101d9b <__alltraps>

00102035 <vector72>:
.globl vector72
vector72:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $72
  102037:	6a 48                	push   $0x48
  jmp __alltraps
  102039:	e9 5d fd ff ff       	jmp    101d9b <__alltraps>

0010203e <vector73>:
.globl vector73
vector73:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $73
  102040:	6a 49                	push   $0x49
  jmp __alltraps
  102042:	e9 54 fd ff ff       	jmp    101d9b <__alltraps>

00102047 <vector74>:
.globl vector74
vector74:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $74
  102049:	6a 4a                	push   $0x4a
  jmp __alltraps
  10204b:	e9 4b fd ff ff       	jmp    101d9b <__alltraps>

00102050 <vector75>:
.globl vector75
vector75:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $75
  102052:	6a 4b                	push   $0x4b
  jmp __alltraps
  102054:	e9 42 fd ff ff       	jmp    101d9b <__alltraps>

00102059 <vector76>:
.globl vector76
vector76:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $76
  10205b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10205d:	e9 39 fd ff ff       	jmp    101d9b <__alltraps>

00102062 <vector77>:
.globl vector77
vector77:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $77
  102064:	6a 4d                	push   $0x4d
  jmp __alltraps
  102066:	e9 30 fd ff ff       	jmp    101d9b <__alltraps>

0010206b <vector78>:
.globl vector78
vector78:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $78
  10206d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10206f:	e9 27 fd ff ff       	jmp    101d9b <__alltraps>

00102074 <vector79>:
.globl vector79
vector79:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $79
  102076:	6a 4f                	push   $0x4f
  jmp __alltraps
  102078:	e9 1e fd ff ff       	jmp    101d9b <__alltraps>

0010207d <vector80>:
.globl vector80
vector80:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $80
  10207f:	6a 50                	push   $0x50
  jmp __alltraps
  102081:	e9 15 fd ff ff       	jmp    101d9b <__alltraps>

00102086 <vector81>:
.globl vector81
vector81:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $81
  102088:	6a 51                	push   $0x51
  jmp __alltraps
  10208a:	e9 0c fd ff ff       	jmp    101d9b <__alltraps>

0010208f <vector82>:
.globl vector82
vector82:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $82
  102091:	6a 52                	push   $0x52
  jmp __alltraps
  102093:	e9 03 fd ff ff       	jmp    101d9b <__alltraps>

00102098 <vector83>:
.globl vector83
vector83:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $83
  10209a:	6a 53                	push   $0x53
  jmp __alltraps
  10209c:	e9 fa fc ff ff       	jmp    101d9b <__alltraps>

001020a1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $84
  1020a3:	6a 54                	push   $0x54
  jmp __alltraps
  1020a5:	e9 f1 fc ff ff       	jmp    101d9b <__alltraps>

001020aa <vector85>:
.globl vector85
vector85:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $85
  1020ac:	6a 55                	push   $0x55
  jmp __alltraps
  1020ae:	e9 e8 fc ff ff       	jmp    101d9b <__alltraps>

001020b3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $86
  1020b5:	6a 56                	push   $0x56
  jmp __alltraps
  1020b7:	e9 df fc ff ff       	jmp    101d9b <__alltraps>

001020bc <vector87>:
.globl vector87
vector87:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $87
  1020be:	6a 57                	push   $0x57
  jmp __alltraps
  1020c0:	e9 d6 fc ff ff       	jmp    101d9b <__alltraps>

001020c5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $88
  1020c7:	6a 58                	push   $0x58
  jmp __alltraps
  1020c9:	e9 cd fc ff ff       	jmp    101d9b <__alltraps>

001020ce <vector89>:
.globl vector89
vector89:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $89
  1020d0:	6a 59                	push   $0x59
  jmp __alltraps
  1020d2:	e9 c4 fc ff ff       	jmp    101d9b <__alltraps>

001020d7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $90
  1020d9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020db:	e9 bb fc ff ff       	jmp    101d9b <__alltraps>

001020e0 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $91
  1020e2:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020e4:	e9 b2 fc ff ff       	jmp    101d9b <__alltraps>

001020e9 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $92
  1020eb:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020ed:	e9 a9 fc ff ff       	jmp    101d9b <__alltraps>

001020f2 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $93
  1020f4:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020f6:	e9 a0 fc ff ff       	jmp    101d9b <__alltraps>

001020fb <vector94>:
.globl vector94
vector94:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $94
  1020fd:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020ff:	e9 97 fc ff ff       	jmp    101d9b <__alltraps>

00102104 <vector95>:
.globl vector95
vector95:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $95
  102106:	6a 5f                	push   $0x5f
  jmp __alltraps
  102108:	e9 8e fc ff ff       	jmp    101d9b <__alltraps>

0010210d <vector96>:
.globl vector96
vector96:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $96
  10210f:	6a 60                	push   $0x60
  jmp __alltraps
  102111:	e9 85 fc ff ff       	jmp    101d9b <__alltraps>

00102116 <vector97>:
.globl vector97
vector97:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $97
  102118:	6a 61                	push   $0x61
  jmp __alltraps
  10211a:	e9 7c fc ff ff       	jmp    101d9b <__alltraps>

0010211f <vector98>:
.globl vector98
vector98:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $98
  102121:	6a 62                	push   $0x62
  jmp __alltraps
  102123:	e9 73 fc ff ff       	jmp    101d9b <__alltraps>

00102128 <vector99>:
.globl vector99
vector99:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $99
  10212a:	6a 63                	push   $0x63
  jmp __alltraps
  10212c:	e9 6a fc ff ff       	jmp    101d9b <__alltraps>

00102131 <vector100>:
.globl vector100
vector100:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $100
  102133:	6a 64                	push   $0x64
  jmp __alltraps
  102135:	e9 61 fc ff ff       	jmp    101d9b <__alltraps>

0010213a <vector101>:
.globl vector101
vector101:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $101
  10213c:	6a 65                	push   $0x65
  jmp __alltraps
  10213e:	e9 58 fc ff ff       	jmp    101d9b <__alltraps>

00102143 <vector102>:
.globl vector102
vector102:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $102
  102145:	6a 66                	push   $0x66
  jmp __alltraps
  102147:	e9 4f fc ff ff       	jmp    101d9b <__alltraps>

0010214c <vector103>:
.globl vector103
vector103:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $103
  10214e:	6a 67                	push   $0x67
  jmp __alltraps
  102150:	e9 46 fc ff ff       	jmp    101d9b <__alltraps>

00102155 <vector104>:
.globl vector104
vector104:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $104
  102157:	6a 68                	push   $0x68
  jmp __alltraps
  102159:	e9 3d fc ff ff       	jmp    101d9b <__alltraps>

0010215e <vector105>:
.globl vector105
vector105:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $105
  102160:	6a 69                	push   $0x69
  jmp __alltraps
  102162:	e9 34 fc ff ff       	jmp    101d9b <__alltraps>

00102167 <vector106>:
.globl vector106
vector106:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $106
  102169:	6a 6a                	push   $0x6a
  jmp __alltraps
  10216b:	e9 2b fc ff ff       	jmp    101d9b <__alltraps>

00102170 <vector107>:
.globl vector107
vector107:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $107
  102172:	6a 6b                	push   $0x6b
  jmp __alltraps
  102174:	e9 22 fc ff ff       	jmp    101d9b <__alltraps>

00102179 <vector108>:
.globl vector108
vector108:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $108
  10217b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10217d:	e9 19 fc ff ff       	jmp    101d9b <__alltraps>

00102182 <vector109>:
.globl vector109
vector109:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $109
  102184:	6a 6d                	push   $0x6d
  jmp __alltraps
  102186:	e9 10 fc ff ff       	jmp    101d9b <__alltraps>

0010218b <vector110>:
.globl vector110
vector110:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $110
  10218d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10218f:	e9 07 fc ff ff       	jmp    101d9b <__alltraps>

00102194 <vector111>:
.globl vector111
vector111:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $111
  102196:	6a 6f                	push   $0x6f
  jmp __alltraps
  102198:	e9 fe fb ff ff       	jmp    101d9b <__alltraps>

0010219d <vector112>:
.globl vector112
vector112:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $112
  10219f:	6a 70                	push   $0x70
  jmp __alltraps
  1021a1:	e9 f5 fb ff ff       	jmp    101d9b <__alltraps>

001021a6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $113
  1021a8:	6a 71                	push   $0x71
  jmp __alltraps
  1021aa:	e9 ec fb ff ff       	jmp    101d9b <__alltraps>

001021af <vector114>:
.globl vector114
vector114:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $114
  1021b1:	6a 72                	push   $0x72
  jmp __alltraps
  1021b3:	e9 e3 fb ff ff       	jmp    101d9b <__alltraps>

001021b8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $115
  1021ba:	6a 73                	push   $0x73
  jmp __alltraps
  1021bc:	e9 da fb ff ff       	jmp    101d9b <__alltraps>

001021c1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $116
  1021c3:	6a 74                	push   $0x74
  jmp __alltraps
  1021c5:	e9 d1 fb ff ff       	jmp    101d9b <__alltraps>

001021ca <vector117>:
.globl vector117
vector117:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $117
  1021cc:	6a 75                	push   $0x75
  jmp __alltraps
  1021ce:	e9 c8 fb ff ff       	jmp    101d9b <__alltraps>

001021d3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $118
  1021d5:	6a 76                	push   $0x76
  jmp __alltraps
  1021d7:	e9 bf fb ff ff       	jmp    101d9b <__alltraps>

001021dc <vector119>:
.globl vector119
vector119:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $119
  1021de:	6a 77                	push   $0x77
  jmp __alltraps
  1021e0:	e9 b6 fb ff ff       	jmp    101d9b <__alltraps>

001021e5 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $120
  1021e7:	6a 78                	push   $0x78
  jmp __alltraps
  1021e9:	e9 ad fb ff ff       	jmp    101d9b <__alltraps>

001021ee <vector121>:
.globl vector121
vector121:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $121
  1021f0:	6a 79                	push   $0x79
  jmp __alltraps
  1021f2:	e9 a4 fb ff ff       	jmp    101d9b <__alltraps>

001021f7 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $122
  1021f9:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021fb:	e9 9b fb ff ff       	jmp    101d9b <__alltraps>

00102200 <vector123>:
.globl vector123
vector123:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $123
  102202:	6a 7b                	push   $0x7b
  jmp __alltraps
  102204:	e9 92 fb ff ff       	jmp    101d9b <__alltraps>

00102209 <vector124>:
.globl vector124
vector124:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $124
  10220b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10220d:	e9 89 fb ff ff       	jmp    101d9b <__alltraps>

00102212 <vector125>:
.globl vector125
vector125:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $125
  102214:	6a 7d                	push   $0x7d
  jmp __alltraps
  102216:	e9 80 fb ff ff       	jmp    101d9b <__alltraps>

0010221b <vector126>:
.globl vector126
vector126:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $126
  10221d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10221f:	e9 77 fb ff ff       	jmp    101d9b <__alltraps>

00102224 <vector127>:
.globl vector127
vector127:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $127
  102226:	6a 7f                	push   $0x7f
  jmp __alltraps
  102228:	e9 6e fb ff ff       	jmp    101d9b <__alltraps>

0010222d <vector128>:
.globl vector128
vector128:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $128
  10222f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102234:	e9 62 fb ff ff       	jmp    101d9b <__alltraps>

00102239 <vector129>:
.globl vector129
vector129:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $129
  10223b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102240:	e9 56 fb ff ff       	jmp    101d9b <__alltraps>

00102245 <vector130>:
.globl vector130
vector130:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $130
  102247:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10224c:	e9 4a fb ff ff       	jmp    101d9b <__alltraps>

00102251 <vector131>:
.globl vector131
vector131:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $131
  102253:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102258:	e9 3e fb ff ff       	jmp    101d9b <__alltraps>

0010225d <vector132>:
.globl vector132
vector132:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $132
  10225f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102264:	e9 32 fb ff ff       	jmp    101d9b <__alltraps>

00102269 <vector133>:
.globl vector133
vector133:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $133
  10226b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102270:	e9 26 fb ff ff       	jmp    101d9b <__alltraps>

00102275 <vector134>:
.globl vector134
vector134:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $134
  102277:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10227c:	e9 1a fb ff ff       	jmp    101d9b <__alltraps>

00102281 <vector135>:
.globl vector135
vector135:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $135
  102283:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102288:	e9 0e fb ff ff       	jmp    101d9b <__alltraps>

0010228d <vector136>:
.globl vector136
vector136:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $136
  10228f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102294:	e9 02 fb ff ff       	jmp    101d9b <__alltraps>

00102299 <vector137>:
.globl vector137
vector137:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $137
  10229b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022a0:	e9 f6 fa ff ff       	jmp    101d9b <__alltraps>

001022a5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $138
  1022a7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022ac:	e9 ea fa ff ff       	jmp    101d9b <__alltraps>

001022b1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $139
  1022b3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022b8:	e9 de fa ff ff       	jmp    101d9b <__alltraps>

001022bd <vector140>:
.globl vector140
vector140:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $140
  1022bf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022c4:	e9 d2 fa ff ff       	jmp    101d9b <__alltraps>

001022c9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $141
  1022cb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022d0:	e9 c6 fa ff ff       	jmp    101d9b <__alltraps>

001022d5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $142
  1022d7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022dc:	e9 ba fa ff ff       	jmp    101d9b <__alltraps>

001022e1 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $143
  1022e3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022e8:	e9 ae fa ff ff       	jmp    101d9b <__alltraps>

001022ed <vector144>:
.globl vector144
vector144:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $144
  1022ef:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022f4:	e9 a2 fa ff ff       	jmp    101d9b <__alltraps>

001022f9 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $145
  1022fb:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102300:	e9 96 fa ff ff       	jmp    101d9b <__alltraps>

00102305 <vector146>:
.globl vector146
vector146:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $146
  102307:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10230c:	e9 8a fa ff ff       	jmp    101d9b <__alltraps>

00102311 <vector147>:
.globl vector147
vector147:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $147
  102313:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102318:	e9 7e fa ff ff       	jmp    101d9b <__alltraps>

0010231d <vector148>:
.globl vector148
vector148:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $148
  10231f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102324:	e9 72 fa ff ff       	jmp    101d9b <__alltraps>

00102329 <vector149>:
.globl vector149
vector149:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $149
  10232b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102330:	e9 66 fa ff ff       	jmp    101d9b <__alltraps>

00102335 <vector150>:
.globl vector150
vector150:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $150
  102337:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10233c:	e9 5a fa ff ff       	jmp    101d9b <__alltraps>

00102341 <vector151>:
.globl vector151
vector151:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $151
  102343:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102348:	e9 4e fa ff ff       	jmp    101d9b <__alltraps>

0010234d <vector152>:
.globl vector152
vector152:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $152
  10234f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102354:	e9 42 fa ff ff       	jmp    101d9b <__alltraps>

00102359 <vector153>:
.globl vector153
vector153:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $153
  10235b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102360:	e9 36 fa ff ff       	jmp    101d9b <__alltraps>

00102365 <vector154>:
.globl vector154
vector154:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $154
  102367:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10236c:	e9 2a fa ff ff       	jmp    101d9b <__alltraps>

00102371 <vector155>:
.globl vector155
vector155:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $155
  102373:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102378:	e9 1e fa ff ff       	jmp    101d9b <__alltraps>

0010237d <vector156>:
.globl vector156
vector156:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $156
  10237f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102384:	e9 12 fa ff ff       	jmp    101d9b <__alltraps>

00102389 <vector157>:
.globl vector157
vector157:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $157
  10238b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102390:	e9 06 fa ff ff       	jmp    101d9b <__alltraps>

00102395 <vector158>:
.globl vector158
vector158:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $158
  102397:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10239c:	e9 fa f9 ff ff       	jmp    101d9b <__alltraps>

001023a1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $159
  1023a3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023a8:	e9 ee f9 ff ff       	jmp    101d9b <__alltraps>

001023ad <vector160>:
.globl vector160
vector160:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $160
  1023af:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023b4:	e9 e2 f9 ff ff       	jmp    101d9b <__alltraps>

001023b9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $161
  1023bb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023c0:	e9 d6 f9 ff ff       	jmp    101d9b <__alltraps>

001023c5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $162
  1023c7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023cc:	e9 ca f9 ff ff       	jmp    101d9b <__alltraps>

001023d1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $163
  1023d3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023d8:	e9 be f9 ff ff       	jmp    101d9b <__alltraps>

001023dd <vector164>:
.globl vector164
vector164:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $164
  1023df:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023e4:	e9 b2 f9 ff ff       	jmp    101d9b <__alltraps>

001023e9 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $165
  1023eb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023f0:	e9 a6 f9 ff ff       	jmp    101d9b <__alltraps>

001023f5 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $166
  1023f7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023fc:	e9 9a f9 ff ff       	jmp    101d9b <__alltraps>

00102401 <vector167>:
.globl vector167
vector167:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $167
  102403:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102408:	e9 8e f9 ff ff       	jmp    101d9b <__alltraps>

0010240d <vector168>:
.globl vector168
vector168:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $168
  10240f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102414:	e9 82 f9 ff ff       	jmp    101d9b <__alltraps>

00102419 <vector169>:
.globl vector169
vector169:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $169
  10241b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102420:	e9 76 f9 ff ff       	jmp    101d9b <__alltraps>

00102425 <vector170>:
.globl vector170
vector170:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $170
  102427:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10242c:	e9 6a f9 ff ff       	jmp    101d9b <__alltraps>

00102431 <vector171>:
.globl vector171
vector171:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $171
  102433:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102438:	e9 5e f9 ff ff       	jmp    101d9b <__alltraps>

0010243d <vector172>:
.globl vector172
vector172:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $172
  10243f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102444:	e9 52 f9 ff ff       	jmp    101d9b <__alltraps>

00102449 <vector173>:
.globl vector173
vector173:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $173
  10244b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102450:	e9 46 f9 ff ff       	jmp    101d9b <__alltraps>

00102455 <vector174>:
.globl vector174
vector174:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $174
  102457:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10245c:	e9 3a f9 ff ff       	jmp    101d9b <__alltraps>

00102461 <vector175>:
.globl vector175
vector175:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $175
  102463:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102468:	e9 2e f9 ff ff       	jmp    101d9b <__alltraps>

0010246d <vector176>:
.globl vector176
vector176:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $176
  10246f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102474:	e9 22 f9 ff ff       	jmp    101d9b <__alltraps>

00102479 <vector177>:
.globl vector177
vector177:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $177
  10247b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102480:	e9 16 f9 ff ff       	jmp    101d9b <__alltraps>

00102485 <vector178>:
.globl vector178
vector178:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $178
  102487:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10248c:	e9 0a f9 ff ff       	jmp    101d9b <__alltraps>

00102491 <vector179>:
.globl vector179
vector179:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $179
  102493:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102498:	e9 fe f8 ff ff       	jmp    101d9b <__alltraps>

0010249d <vector180>:
.globl vector180
vector180:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $180
  10249f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024a4:	e9 f2 f8 ff ff       	jmp    101d9b <__alltraps>

001024a9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $181
  1024ab:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024b0:	e9 e6 f8 ff ff       	jmp    101d9b <__alltraps>

001024b5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $182
  1024b7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024bc:	e9 da f8 ff ff       	jmp    101d9b <__alltraps>

001024c1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024c1:	6a 00                	push   $0x0
  pushl $183
  1024c3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024c8:	e9 ce f8 ff ff       	jmp    101d9b <__alltraps>

001024cd <vector184>:
.globl vector184
vector184:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $184
  1024cf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024d4:	e9 c2 f8 ff ff       	jmp    101d9b <__alltraps>

001024d9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $185
  1024db:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024e0:	e9 b6 f8 ff ff       	jmp    101d9b <__alltraps>

001024e5 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024e5:	6a 00                	push   $0x0
  pushl $186
  1024e7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024ec:	e9 aa f8 ff ff       	jmp    101d9b <__alltraps>

001024f1 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $187
  1024f3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024f8:	e9 9e f8 ff ff       	jmp    101d9b <__alltraps>

001024fd <vector188>:
.globl vector188
vector188:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $188
  1024ff:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102504:	e9 92 f8 ff ff       	jmp    101d9b <__alltraps>

00102509 <vector189>:
.globl vector189
vector189:
  pushl $0
  102509:	6a 00                	push   $0x0
  pushl $189
  10250b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102510:	e9 86 f8 ff ff       	jmp    101d9b <__alltraps>

00102515 <vector190>:
.globl vector190
vector190:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $190
  102517:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10251c:	e9 7a f8 ff ff       	jmp    101d9b <__alltraps>

00102521 <vector191>:
.globl vector191
vector191:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $191
  102523:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102528:	e9 6e f8 ff ff       	jmp    101d9b <__alltraps>

0010252d <vector192>:
.globl vector192
vector192:
  pushl $0
  10252d:	6a 00                	push   $0x0
  pushl $192
  10252f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102534:	e9 62 f8 ff ff       	jmp    101d9b <__alltraps>

00102539 <vector193>:
.globl vector193
vector193:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $193
  10253b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102540:	e9 56 f8 ff ff       	jmp    101d9b <__alltraps>

00102545 <vector194>:
.globl vector194
vector194:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $194
  102547:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10254c:	e9 4a f8 ff ff       	jmp    101d9b <__alltraps>

00102551 <vector195>:
.globl vector195
vector195:
  pushl $0
  102551:	6a 00                	push   $0x0
  pushl $195
  102553:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102558:	e9 3e f8 ff ff       	jmp    101d9b <__alltraps>

0010255d <vector196>:
.globl vector196
vector196:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $196
  10255f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102564:	e9 32 f8 ff ff       	jmp    101d9b <__alltraps>

00102569 <vector197>:
.globl vector197
vector197:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $197
  10256b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102570:	e9 26 f8 ff ff       	jmp    101d9b <__alltraps>

00102575 <vector198>:
.globl vector198
vector198:
  pushl $0
  102575:	6a 00                	push   $0x0
  pushl $198
  102577:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10257c:	e9 1a f8 ff ff       	jmp    101d9b <__alltraps>

00102581 <vector199>:
.globl vector199
vector199:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $199
  102583:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102588:	e9 0e f8 ff ff       	jmp    101d9b <__alltraps>

0010258d <vector200>:
.globl vector200
vector200:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $200
  10258f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102594:	e9 02 f8 ff ff       	jmp    101d9b <__alltraps>

00102599 <vector201>:
.globl vector201
vector201:
  pushl $0
  102599:	6a 00                	push   $0x0
  pushl $201
  10259b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025a0:	e9 f6 f7 ff ff       	jmp    101d9b <__alltraps>

001025a5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $202
  1025a7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025ac:	e9 ea f7 ff ff       	jmp    101d9b <__alltraps>

001025b1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $203
  1025b3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025b8:	e9 de f7 ff ff       	jmp    101d9b <__alltraps>

001025bd <vector204>:
.globl vector204
vector204:
  pushl $0
  1025bd:	6a 00                	push   $0x0
  pushl $204
  1025bf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025c4:	e9 d2 f7 ff ff       	jmp    101d9b <__alltraps>

001025c9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $205
  1025cb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025d0:	e9 c6 f7 ff ff       	jmp    101d9b <__alltraps>

001025d5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $206
  1025d7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025dc:	e9 ba f7 ff ff       	jmp    101d9b <__alltraps>

001025e1 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025e1:	6a 00                	push   $0x0
  pushl $207
  1025e3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025e8:	e9 ae f7 ff ff       	jmp    101d9b <__alltraps>

001025ed <vector208>:
.globl vector208
vector208:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $208
  1025ef:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025f4:	e9 a2 f7 ff ff       	jmp    101d9b <__alltraps>

001025f9 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $209
  1025fb:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102600:	e9 96 f7 ff ff       	jmp    101d9b <__alltraps>

00102605 <vector210>:
.globl vector210
vector210:
  pushl $0
  102605:	6a 00                	push   $0x0
  pushl $210
  102607:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10260c:	e9 8a f7 ff ff       	jmp    101d9b <__alltraps>

00102611 <vector211>:
.globl vector211
vector211:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $211
  102613:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102618:	e9 7e f7 ff ff       	jmp    101d9b <__alltraps>

0010261d <vector212>:
.globl vector212
vector212:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $212
  10261f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102624:	e9 72 f7 ff ff       	jmp    101d9b <__alltraps>

00102629 <vector213>:
.globl vector213
vector213:
  pushl $0
  102629:	6a 00                	push   $0x0
  pushl $213
  10262b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102630:	e9 66 f7 ff ff       	jmp    101d9b <__alltraps>

00102635 <vector214>:
.globl vector214
vector214:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $214
  102637:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10263c:	e9 5a f7 ff ff       	jmp    101d9b <__alltraps>

00102641 <vector215>:
.globl vector215
vector215:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $215
  102643:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102648:	e9 4e f7 ff ff       	jmp    101d9b <__alltraps>

0010264d <vector216>:
.globl vector216
vector216:
  pushl $0
  10264d:	6a 00                	push   $0x0
  pushl $216
  10264f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102654:	e9 42 f7 ff ff       	jmp    101d9b <__alltraps>

00102659 <vector217>:
.globl vector217
vector217:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $217
  10265b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102660:	e9 36 f7 ff ff       	jmp    101d9b <__alltraps>

00102665 <vector218>:
.globl vector218
vector218:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $218
  102667:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10266c:	e9 2a f7 ff ff       	jmp    101d9b <__alltraps>

00102671 <vector219>:
.globl vector219
vector219:
  pushl $0
  102671:	6a 00                	push   $0x0
  pushl $219
  102673:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102678:	e9 1e f7 ff ff       	jmp    101d9b <__alltraps>

0010267d <vector220>:
.globl vector220
vector220:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $220
  10267f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102684:	e9 12 f7 ff ff       	jmp    101d9b <__alltraps>

00102689 <vector221>:
.globl vector221
vector221:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $221
  10268b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102690:	e9 06 f7 ff ff       	jmp    101d9b <__alltraps>

00102695 <vector222>:
.globl vector222
vector222:
  pushl $0
  102695:	6a 00                	push   $0x0
  pushl $222
  102697:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10269c:	e9 fa f6 ff ff       	jmp    101d9b <__alltraps>

001026a1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $223
  1026a3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026a8:	e9 ee f6 ff ff       	jmp    101d9b <__alltraps>

001026ad <vector224>:
.globl vector224
vector224:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $224
  1026af:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026b4:	e9 e2 f6 ff ff       	jmp    101d9b <__alltraps>

001026b9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026b9:	6a 00                	push   $0x0
  pushl $225
  1026bb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026c0:	e9 d6 f6 ff ff       	jmp    101d9b <__alltraps>

001026c5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $226
  1026c7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026cc:	e9 ca f6 ff ff       	jmp    101d9b <__alltraps>

001026d1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $227
  1026d3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026d8:	e9 be f6 ff ff       	jmp    101d9b <__alltraps>

001026dd <vector228>:
.globl vector228
vector228:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $228
  1026df:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026e4:	e9 b2 f6 ff ff       	jmp    101d9b <__alltraps>

001026e9 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $229
  1026eb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026f0:	e9 a6 f6 ff ff       	jmp    101d9b <__alltraps>

001026f5 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $230
  1026f7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026fc:	e9 9a f6 ff ff       	jmp    101d9b <__alltraps>

00102701 <vector231>:
.globl vector231
vector231:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $231
  102703:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102708:	e9 8e f6 ff ff       	jmp    101d9b <__alltraps>

0010270d <vector232>:
.globl vector232
vector232:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $232
  10270f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102714:	e9 82 f6 ff ff       	jmp    101d9b <__alltraps>

00102719 <vector233>:
.globl vector233
vector233:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $233
  10271b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102720:	e9 76 f6 ff ff       	jmp    101d9b <__alltraps>

00102725 <vector234>:
.globl vector234
vector234:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $234
  102727:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10272c:	e9 6a f6 ff ff       	jmp    101d9b <__alltraps>

00102731 <vector235>:
.globl vector235
vector235:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $235
  102733:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102738:	e9 5e f6 ff ff       	jmp    101d9b <__alltraps>

0010273d <vector236>:
.globl vector236
vector236:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $236
  10273f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102744:	e9 52 f6 ff ff       	jmp    101d9b <__alltraps>

00102749 <vector237>:
.globl vector237
vector237:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $237
  10274b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102750:	e9 46 f6 ff ff       	jmp    101d9b <__alltraps>

00102755 <vector238>:
.globl vector238
vector238:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $238
  102757:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10275c:	e9 3a f6 ff ff       	jmp    101d9b <__alltraps>

00102761 <vector239>:
.globl vector239
vector239:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $239
  102763:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102768:	e9 2e f6 ff ff       	jmp    101d9b <__alltraps>

0010276d <vector240>:
.globl vector240
vector240:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $240
  10276f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102774:	e9 22 f6 ff ff       	jmp    101d9b <__alltraps>

00102779 <vector241>:
.globl vector241
vector241:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $241
  10277b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102780:	e9 16 f6 ff ff       	jmp    101d9b <__alltraps>

00102785 <vector242>:
.globl vector242
vector242:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $242
  102787:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10278c:	e9 0a f6 ff ff       	jmp    101d9b <__alltraps>

00102791 <vector243>:
.globl vector243
vector243:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $243
  102793:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102798:	e9 fe f5 ff ff       	jmp    101d9b <__alltraps>

0010279d <vector244>:
.globl vector244
vector244:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $244
  10279f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027a4:	e9 f2 f5 ff ff       	jmp    101d9b <__alltraps>

001027a9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $245
  1027ab:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027b0:	e9 e6 f5 ff ff       	jmp    101d9b <__alltraps>

001027b5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $246
  1027b7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027bc:	e9 da f5 ff ff       	jmp    101d9b <__alltraps>

001027c1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $247
  1027c3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027c8:	e9 ce f5 ff ff       	jmp    101d9b <__alltraps>

001027cd <vector248>:
.globl vector248
vector248:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $248
  1027cf:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027d4:	e9 c2 f5 ff ff       	jmp    101d9b <__alltraps>

001027d9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $249
  1027db:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027e0:	e9 b6 f5 ff ff       	jmp    101d9b <__alltraps>

001027e5 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $250
  1027e7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027ec:	e9 aa f5 ff ff       	jmp    101d9b <__alltraps>

001027f1 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $251
  1027f3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027f8:	e9 9e f5 ff ff       	jmp    101d9b <__alltraps>

001027fd <vector252>:
.globl vector252
vector252:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $252
  1027ff:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102804:	e9 92 f5 ff ff       	jmp    101d9b <__alltraps>

00102809 <vector253>:
.globl vector253
vector253:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $253
  10280b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102810:	e9 86 f5 ff ff       	jmp    101d9b <__alltraps>

00102815 <vector254>:
.globl vector254
vector254:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $254
  102817:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10281c:	e9 7a f5 ff ff       	jmp    101d9b <__alltraps>

00102821 <vector255>:
.globl vector255
vector255:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $255
  102823:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102828:	e9 6e f5 ff ff       	jmp    101d9b <__alltraps>

0010282d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10282d:	55                   	push   %ebp
  10282e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102830:	8b 55 08             	mov    0x8(%ebp),%edx
  102833:	a1 64 89 11 00       	mov    0x118964,%eax
  102838:	29 c2                	sub    %eax,%edx
  10283a:	89 d0                	mov    %edx,%eax
  10283c:	c1 f8 02             	sar    $0x2,%eax
  10283f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102845:	5d                   	pop    %ebp
  102846:	c3                   	ret    

00102847 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102847:	55                   	push   %ebp
  102848:	89 e5                	mov    %esp,%ebp
  10284a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10284d:	8b 45 08             	mov    0x8(%ebp),%eax
  102850:	89 04 24             	mov    %eax,(%esp)
  102853:	e8 d5 ff ff ff       	call   10282d <page2ppn>
  102858:	c1 e0 0c             	shl    $0xc,%eax
}
  10285b:	c9                   	leave  
  10285c:	c3                   	ret    

0010285d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10285d:	55                   	push   %ebp
  10285e:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102860:	8b 45 08             	mov    0x8(%ebp),%eax
  102863:	8b 00                	mov    (%eax),%eax
}
  102865:	5d                   	pop    %ebp
  102866:	c3                   	ret    

00102867 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102867:	55                   	push   %ebp
  102868:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10286a:	8b 45 08             	mov    0x8(%ebp),%eax
  10286d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102870:	89 10                	mov    %edx,(%eax)
}
  102872:	5d                   	pop    %ebp
  102873:	c3                   	ret    

00102874 <default_init>:

#define free_list (free_area.free_list)//空块的链表
#define nr_free (free_area.nr_free)//空块数目

static void
default_init(void) {
  102874:	55                   	push   %ebp
  102875:	89 e5                	mov    %esp,%ebp
  102877:	83 ec 10             	sub    $0x10,%esp
  10287a:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102884:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102887:	89 50 04             	mov    %edx,0x4(%eax)
  10288a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10288d:	8b 50 04             	mov    0x4(%eax),%edx
  102890:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102893:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102895:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10289c:	00 00 00 
}
  10289f:	c9                   	leave  
  1028a0:	c3                   	ret    

001028a1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1028a1:	55                   	push   %ebp
  1028a2:	89 e5                	mov    %esp,%ebp
  1028a4:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1028a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028ab:	75 24                	jne    1028d1 <default_init_memmap+0x30>
  1028ad:	c7 44 24 0c 30 66 10 	movl   $0x106630,0xc(%esp)
  1028b4:	00 
  1028b5:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1028bc:	00 
  1028bd:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1028c4:	00 
  1028c5:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1028cc:	e8 f5 e3 ff ff       	call   100cc6 <__panic>
    struct Page *p = base;
  1028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1028d7:	e9 de 00 00 00       	jmp    1029ba <default_init_memmap+0x119>
        assert(PageReserved(p));
  1028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028df:	83 c0 04             	add    $0x4,%eax
  1028e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1028ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1028f2:	0f a3 10             	bt     %edx,(%eax)
  1028f5:	19 c0                	sbb    %eax,%eax
  1028f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1028fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1028fe:	0f 95 c0             	setne  %al
  102901:	0f b6 c0             	movzbl %al,%eax
  102904:	85 c0                	test   %eax,%eax
  102906:	75 24                	jne    10292c <default_init_memmap+0x8b>
  102908:	c7 44 24 0c 61 66 10 	movl   $0x106661,0xc(%esp)
  10290f:	00 
  102910:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102917:	00 
  102918:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  10291f:	00 
  102920:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102927:	e8 9a e3 ff ff       	call   100cc6 <__panic>
        p->flags = p->property = 0;
  10292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10292f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102939:	8b 50 08             	mov    0x8(%eax),%edx
  10293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10293f:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);
  102942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102945:	83 c0 04             	add    $0x4,%eax
  102948:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10294f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102958:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  10295b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102962:	00 
  102963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102966:	89 04 24             	mov    %eax,(%esp)
  102969:	e8 f9 fe ff ff       	call   102867 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  10296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102971:	83 c0 0c             	add    $0xc,%eax
  102974:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  10297b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10297e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102981:	8b 00                	mov    (%eax),%eax
  102983:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102986:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102989:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10298c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10298f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102992:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102995:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102998:	89 10                	mov    %edx,(%eax)
  10299a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10299d:	8b 10                	mov    (%eax),%edx
  10299f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029a2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1029ab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1029ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029b1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1029b4:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029b6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029bd:	89 d0                	mov    %edx,%eax
  1029bf:	c1 e0 02             	shl    $0x2,%eax
  1029c2:	01 d0                	add    %edx,%eax
  1029c4:	c1 e0 02             	shl    $0x2,%eax
  1029c7:	89 c2                	mov    %eax,%edx
  1029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cc:	01 d0                	add    %edx,%eax
  1029ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1029d1:	0f 85 05 ff ff ff    	jne    1028dc <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        SetPageProperty(p);
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029dd:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    nr_free += n;
  1029e0:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1029e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029e9:	01 d0                	add    %edx,%eax
  1029eb:	a3 58 89 11 00       	mov    %eax,0x118958
    //list_add(&free_list, &(base->page_link));
}
  1029f0:	c9                   	leave  
  1029f1:	c3                   	ret    

001029f2 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1029f2:	55                   	push   %ebp
  1029f3:	89 e5                	mov    %esp,%ebp
  1029f5:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1029f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029fc:	75 24                	jne    102a22 <default_alloc_pages+0x30>
  1029fe:	c7 44 24 0c 30 66 10 	movl   $0x106630,0xc(%esp)
  102a05:	00 
  102a06:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102a0d:	00 
  102a0e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  102a15:	00 
  102a16:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102a1d:	e8 a4 e2 ff ff       	call   100cc6 <__panic>
    if (n > nr_free) {
  102a22:	a1 58 89 11 00       	mov    0x118958,%eax
  102a27:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a2a:	73 0a                	jae    102a36 <default_alloc_pages+0x44>
        return NULL;
  102a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  102a31:	e9 37 01 00 00       	jmp    102b6d <default_alloc_pages+0x17b>
    }
    list_entry_t *le = &free_list;
  102a36:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)

    while ((le = list_next(le)) != &free_list) {
  102a3d:	e9 0a 01 00 00       	jmp    102b4c <default_alloc_pages+0x15a>
        struct Page *p = le2page(le, page_link);
  102a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a45:	83 e8 0c             	sub    $0xc,%eax
  102a48:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a4e:	8b 40 08             	mov    0x8(%eax),%eax
  102a51:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a54:	0f 82 f2 00 00 00    	jb     102b4c <default_alloc_pages+0x15a>
        	int i;
	for(i=0;i<n;i++){
  102a5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a61:	eb 7c                	jmp    102adf <default_alloc_pages+0xed>
  102a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a66:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a6c:	8b 40 04             	mov    0x4(%eax),%eax
	 list_entry_t *len = list_next(le);
  102a6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 struct Page *pp = le2page(le, page_link);
  102a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a75:	83 e8 0c             	sub    $0xc,%eax
  102a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 SetPageReserved(pp);
  102a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a7e:	83 c0 04             	add    $0x4,%eax
  102a81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102a88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a91:	0f ab 10             	bts    %edx,(%eax)
	 ClearPageProperty(pp);
  102a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a97:	83 c0 04             	add    $0x4,%eax
  102a9a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102aa1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102aa4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102aa7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102aaa:	0f b3 10             	btr    %edx,(%eax)
  102aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab0:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102ab3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ab6:	8b 40 04             	mov    0x4(%eax),%eax
  102ab9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102abc:	8b 12                	mov    (%edx),%edx
  102abe:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ac1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102ac4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ac7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102aca:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102acd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ad0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102ad3:	89 10                	mov    %edx,(%eax)
	 list_del(le);
	 le = len;
  102ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
        	int i;
	for(i=0;i<n;i++){
  102adb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ae2:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ae5:	0f 82 78 ff ff ff    	jb     102a63 <default_alloc_pages+0x71>
	 SetPageReserved(pp);
	 ClearPageProperty(pp);
	 list_del(le);
	 le = len;
	}
        if(p->property>n){
  102aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102aee:	8b 40 08             	mov    0x8(%eax),%eax
  102af1:	3b 45 08             	cmp    0x8(%ebp),%eax
  102af4:	76 12                	jbe    102b08 <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
  102af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af9:	8d 50 f4             	lea    -0xc(%eax),%edx
  102afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102aff:	8b 40 08             	mov    0x8(%eax),%eax
  102b02:	2b 45 08             	sub    0x8(%ebp),%eax
  102b05:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
  102b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b0b:	83 c0 04             	add    $0x4,%eax
  102b0e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102b15:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102b18:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b1b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b1e:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
  102b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b24:	83 c0 04             	add    $0x4,%eax
  102b27:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102b2e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b31:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b34:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b37:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
  102b3a:	a1 58 89 11 00       	mov    0x118958,%eax
  102b3f:	2b 45 08             	sub    0x8(%ebp),%eax
  102b42:	a3 58 89 11 00       	mov    %eax,0x118958
        return p;
  102b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b4a:	eb 21                	jmp    102b6d <default_alloc_pages+0x17b>
  102b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b4f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b52:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102b55:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    list_entry_t *le = &free_list;

    while ((le = list_next(le)) != &free_list) {
  102b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b5b:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102b62:	0f 85 da fe ff ff    	jne    102a42 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
  102b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b6d:	c9                   	leave  
  102b6e:	c3                   	ret    

00102b6f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102b6f:	55                   	push   %ebp
  102b70:	89 e5                	mov    %esp,%ebp
  102b72:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102b75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b79:	75 24                	jne    102b9f <default_free_pages+0x30>
  102b7b:	c7 44 24 0c 30 66 10 	movl   $0x106630,0xc(%esp)
  102b82:	00 
  102b83:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102b8a:	00 
  102b8b:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  102b92:	00 
  102b93:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102b9a:	e8 27 e1 ff ff       	call   100cc6 <__panic>
    assert(PageReserved(base));
  102b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba2:	83 c0 04             	add    $0x4,%eax
  102ba5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102bac:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102baf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102bb5:	0f a3 10             	bt     %edx,(%eax)
  102bb8:	19 c0                	sbb    %eax,%eax
  102bba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102bbd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102bc1:	0f 95 c0             	setne  %al
  102bc4:	0f b6 c0             	movzbl %al,%eax
  102bc7:	85 c0                	test   %eax,%eax
  102bc9:	75 24                	jne    102bef <default_free_pages+0x80>
  102bcb:	c7 44 24 0c 71 66 10 	movl   $0x106671,0xc(%esp)
  102bd2:	00 
  102bd3:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102bda:	00 
  102bdb:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  102be2:	00 
  102be3:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102bea:	e8 d7 e0 ff ff       	call   100cc6 <__panic>

    list_entry_t *le = &free_list;
  102bef:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
  102bf6:	eb 13                	jmp    102c0b <default_free_pages+0x9c>
      p = le2page(le, page_link);
  102bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bfb:	83 e8 0c             	sub    $0xc,%eax
  102bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
  102c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c04:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c07:	76 02                	jbe    102c0b <default_free_pages+0x9c>
        break;
  102c09:	eb 18                	jmp    102c23 <default_free_pages+0xb4>
  102c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c14:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
  102c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c1a:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102c21:	75 d5                	jne    102bf8 <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
  102c23:	8b 45 08             	mov    0x8(%ebp),%eax
  102c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c29:	eb 4b                	jmp    102c76 <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
  102c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c2e:	8d 50 0c             	lea    0xc(%eax),%edx
  102c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c34:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102c37:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102c3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c3d:	8b 00                	mov    (%eax),%eax
  102c3f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c42:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c45:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c4b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c51:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c54:	89 10                	mov    %edx,(%eax)
  102c56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c59:	8b 10                	mov    (%eax),%edx
  102c5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c5e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c64:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c67:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c6d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c70:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
  102c72:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c79:	89 d0                	mov    %edx,%eax
  102c7b:	c1 e0 02             	shl    $0x2,%eax
  102c7e:	01 d0                	add    %edx,%eax
  102c80:	c1 e0 02             	shl    $0x2,%eax
  102c83:	89 c2                	mov    %eax,%edx
  102c85:	8b 45 08             	mov    0x8(%ebp),%eax
  102c88:	01 d0                	add    %edx,%eax
  102c8a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102c8d:	77 9c                	ja     102c2b <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
  102c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  102c99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102ca0:	00 
  102ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca4:	89 04 24             	mov    %eax,(%esp)
  102ca7:	e8 bb fb ff ff       	call   102867 <set_page_ref>
    ClearPageProperty(base);
  102cac:	8b 45 08             	mov    0x8(%ebp),%eax
  102caf:	83 c0 04             	add    $0x4,%eax
  102cb2:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102cb9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cbc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102cbf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102cc2:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc8:	83 c0 04             	add    $0x4,%eax
  102ccb:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102cd2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cd5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102cd8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102cdb:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102cde:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ce4:	89 50 08             	mov    %edx,0x8(%eax)

	p = le2page(le,page_link) ;
  102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cea:	83 e8 0c             	sub    $0xc,%eax
  102ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if( base+n == p ){
  102cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cf3:	89 d0                	mov    %edx,%eax
  102cf5:	c1 e0 02             	shl    $0x2,%eax
  102cf8:	01 d0                	add    %edx,%eax
  102cfa:	c1 e0 02             	shl    $0x2,%eax
  102cfd:	89 c2                	mov    %eax,%edx
  102cff:	8b 45 08             	mov    0x8(%ebp),%eax
  102d02:	01 d0                	add    %edx,%eax
  102d04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d07:	75 1e                	jne    102d27 <default_free_pages+0x1b8>
	  base->property += p->property;
  102d09:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0c:	8b 50 08             	mov    0x8(%eax),%edx
  102d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d12:	8b 40 08             	mov    0x8(%eax),%eax
  102d15:	01 c2                	add    %eax,%edx
  102d17:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1a:	89 50 08             	mov    %edx,0x8(%eax)
	  p->property = 0;
  102d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	le = list_prev(&(base->page_link));
  102d27:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2a:	83 c0 0c             	add    $0xc,%eax
  102d2d:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d33:	8b 00                	mov    (%eax),%eax
  102d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
  102d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d3b:	83 e8 0c             	sub    $0xc,%eax
  102d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(le!=&free_list && p==base-1){
  102d41:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102d48:	74 57                	je     102da1 <default_free_pages+0x232>
  102d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4d:	83 e8 14             	sub    $0x14,%eax
  102d50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d53:	75 4c                	jne    102da1 <default_free_pages+0x232>
	  while(le!=&free_list){
  102d55:	eb 41                	jmp    102d98 <default_free_pages+0x229>
		if(p->property){
  102d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d5a:	8b 40 08             	mov    0x8(%eax),%eax
  102d5d:	85 c0                	test   %eax,%eax
  102d5f:	74 20                	je     102d81 <default_free_pages+0x212>
		  p->property += base->property;
  102d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d64:	8b 50 08             	mov    0x8(%eax),%edx
  102d67:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6a:	8b 40 08             	mov    0x8(%eax),%eax
  102d6d:	01 c2                	add    %eax,%edx
  102d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d72:	89 50 08             	mov    %edx,0x8(%eax)
		  base->property = 0;
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		  break;
  102d7f:	eb 20                	jmp    102da1 <default_free_pages+0x232>
  102d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d84:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102d87:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d8a:	8b 00                	mov    (%eax),%eax
        }
		 le = list_prev(le);
  102d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p = le2page(le,page_link);
  102d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d92:	83 e8 0c             	sub    $0xc,%eax
  102d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  p->property = 0;
	}
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	if(le!=&free_list && p==base-1){
	  while(le!=&free_list){
  102d98:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102d9f:	75 b6                	jne    102d57 <default_free_pages+0x1e8>
        }
		 le = list_prev(le);
		p = le2page(le,page_link);
	  }
    }
    nr_free += n;
  102da1:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102daa:	01 d0                	add    %edx,%eax
  102dac:	a3 58 89 11 00       	mov    %eax,0x118958
    return ;
  102db1:	90                   	nop
}
  102db2:	c9                   	leave  
  102db3:	c3                   	ret    

00102db4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102db4:	55                   	push   %ebp
  102db5:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102db7:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102dbc:	5d                   	pop    %ebp
  102dbd:	c3                   	ret    

00102dbe <basic_check>:

static void
basic_check(void) {
  102dbe:	55                   	push   %ebp
  102dbf:	89 e5                	mov    %esp,%ebp
  102dc1:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102dc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102dd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102dde:	e8 85 0e 00 00       	call   103c68 <alloc_pages>
  102de3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102de6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102dea:	75 24                	jne    102e10 <basic_check+0x52>
  102dec:	c7 44 24 0c 84 66 10 	movl   $0x106684,0xc(%esp)
  102df3:	00 
  102df4:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102dfb:	00 
  102dfc:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  102e03:	00 
  102e04:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102e0b:	e8 b6 de ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e17:	e8 4c 0e 00 00       	call   103c68 <alloc_pages>
  102e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e23:	75 24                	jne    102e49 <basic_check+0x8b>
  102e25:	c7 44 24 0c a0 66 10 	movl   $0x1066a0,0xc(%esp)
  102e2c:	00 
  102e2d:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102e34:	00 
  102e35:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  102e3c:	00 
  102e3d:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102e44:	e8 7d de ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102e49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e50:	e8 13 0e 00 00       	call   103c68 <alloc_pages>
  102e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102e5c:	75 24                	jne    102e82 <basic_check+0xc4>
  102e5e:	c7 44 24 0c bc 66 10 	movl   $0x1066bc,0xc(%esp)
  102e65:	00 
  102e66:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102e6d:	00 
  102e6e:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  102e75:	00 
  102e76:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102e7d:	e8 44 de ff ff       	call   100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102e82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102e88:	74 10                	je     102e9a <basic_check+0xdc>
  102e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e8d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e90:	74 08                	je     102e9a <basic_check+0xdc>
  102e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e95:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e98:	75 24                	jne    102ebe <basic_check+0x100>
  102e9a:	c7 44 24 0c d8 66 10 	movl   $0x1066d8,0xc(%esp)
  102ea1:	00 
  102ea2:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102ea9:	00 
  102eaa:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102eb1:	00 
  102eb2:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102eb9:	e8 08 de ff ff       	call   100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ec1:	89 04 24             	mov    %eax,(%esp)
  102ec4:	e8 94 f9 ff ff       	call   10285d <page_ref>
  102ec9:	85 c0                	test   %eax,%eax
  102ecb:	75 1e                	jne    102eeb <basic_check+0x12d>
  102ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ed0:	89 04 24             	mov    %eax,(%esp)
  102ed3:	e8 85 f9 ff ff       	call   10285d <page_ref>
  102ed8:	85 c0                	test   %eax,%eax
  102eda:	75 0f                	jne    102eeb <basic_check+0x12d>
  102edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102edf:	89 04 24             	mov    %eax,(%esp)
  102ee2:	e8 76 f9 ff ff       	call   10285d <page_ref>
  102ee7:	85 c0                	test   %eax,%eax
  102ee9:	74 24                	je     102f0f <basic_check+0x151>
  102eeb:	c7 44 24 0c fc 66 10 	movl   $0x1066fc,0xc(%esp)
  102ef2:	00 
  102ef3:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102efa:	00 
  102efb:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102f02:	00 
  102f03:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102f0a:	e8 b7 dd ff ff       	call   100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f12:	89 04 24             	mov    %eax,(%esp)
  102f15:	e8 2d f9 ff ff       	call   102847 <page2pa>
  102f1a:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f20:	c1 e2 0c             	shl    $0xc,%edx
  102f23:	39 d0                	cmp    %edx,%eax
  102f25:	72 24                	jb     102f4b <basic_check+0x18d>
  102f27:	c7 44 24 0c 38 67 10 	movl   $0x106738,0xc(%esp)
  102f2e:	00 
  102f2f:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102f36:	00 
  102f37:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102f3e:	00 
  102f3f:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102f46:	e8 7b dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f4e:	89 04 24             	mov    %eax,(%esp)
  102f51:	e8 f1 f8 ff ff       	call   102847 <page2pa>
  102f56:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f5c:	c1 e2 0c             	shl    $0xc,%edx
  102f5f:	39 d0                	cmp    %edx,%eax
  102f61:	72 24                	jb     102f87 <basic_check+0x1c9>
  102f63:	c7 44 24 0c 55 67 10 	movl   $0x106755,0xc(%esp)
  102f6a:	00 
  102f6b:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102f72:	00 
  102f73:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  102f7a:	00 
  102f7b:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102f82:	e8 3f dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f8a:	89 04 24             	mov    %eax,(%esp)
  102f8d:	e8 b5 f8 ff ff       	call   102847 <page2pa>
  102f92:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f98:	c1 e2 0c             	shl    $0xc,%edx
  102f9b:	39 d0                	cmp    %edx,%eax
  102f9d:	72 24                	jb     102fc3 <basic_check+0x205>
  102f9f:	c7 44 24 0c 72 67 10 	movl   $0x106772,0xc(%esp)
  102fa6:	00 
  102fa7:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  102fae:	00 
  102faf:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  102fb6:	00 
  102fb7:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102fbe:	e8 03 dd ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  102fc3:	a1 50 89 11 00       	mov    0x118950,%eax
  102fc8:	8b 15 54 89 11 00    	mov    0x118954,%edx
  102fce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fd1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fd4:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fde:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102fe1:	89 50 04             	mov    %edx,0x4(%eax)
  102fe4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fe7:	8b 50 04             	mov    0x4(%eax),%edx
  102fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fed:	89 10                	mov    %edx,(%eax)
  102fef:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102ff6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ff9:	8b 40 04             	mov    0x4(%eax),%eax
  102ffc:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102fff:	0f 94 c0             	sete   %al
  103002:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103005:	85 c0                	test   %eax,%eax
  103007:	75 24                	jne    10302d <basic_check+0x26f>
  103009:	c7 44 24 0c 8f 67 10 	movl   $0x10678f,0xc(%esp)
  103010:	00 
  103011:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103018:	00 
  103019:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  103020:	00 
  103021:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103028:	e8 99 dc ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  10302d:	a1 58 89 11 00       	mov    0x118958,%eax
  103032:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103035:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10303c:	00 00 00 

    assert(alloc_page() == NULL);
  10303f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103046:	e8 1d 0c 00 00       	call   103c68 <alloc_pages>
  10304b:	85 c0                	test   %eax,%eax
  10304d:	74 24                	je     103073 <basic_check+0x2b5>
  10304f:	c7 44 24 0c a6 67 10 	movl   $0x1067a6,0xc(%esp)
  103056:	00 
  103057:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  10305e:	00 
  10305f:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  103066:	00 
  103067:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  10306e:	e8 53 dc ff ff       	call   100cc6 <__panic>

    free_page(p0);
  103073:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10307a:	00 
  10307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10307e:	89 04 24             	mov    %eax,(%esp)
  103081:	e8 1a 0c 00 00       	call   103ca0 <free_pages>
    free_page(p1);
  103086:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10308d:	00 
  10308e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103091:	89 04 24             	mov    %eax,(%esp)
  103094:	e8 07 0c 00 00       	call   103ca0 <free_pages>
    free_page(p2);
  103099:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030a0:	00 
  1030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030a4:	89 04 24             	mov    %eax,(%esp)
  1030a7:	e8 f4 0b 00 00       	call   103ca0 <free_pages>
    assert(nr_free == 3);
  1030ac:	a1 58 89 11 00       	mov    0x118958,%eax
  1030b1:	83 f8 03             	cmp    $0x3,%eax
  1030b4:	74 24                	je     1030da <basic_check+0x31c>
  1030b6:	c7 44 24 0c bb 67 10 	movl   $0x1067bb,0xc(%esp)
  1030bd:	00 
  1030be:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1030c5:	00 
  1030c6:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  1030cd:	00 
  1030ce:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1030d5:	e8 ec db ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1030da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030e1:	e8 82 0b 00 00       	call   103c68 <alloc_pages>
  1030e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1030ed:	75 24                	jne    103113 <basic_check+0x355>
  1030ef:	c7 44 24 0c 84 66 10 	movl   $0x106684,0xc(%esp)
  1030f6:	00 
  1030f7:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1030fe:	00 
  1030ff:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  103106:	00 
  103107:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  10310e:	e8 b3 db ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103113:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10311a:	e8 49 0b 00 00       	call   103c68 <alloc_pages>
  10311f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103122:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103126:	75 24                	jne    10314c <basic_check+0x38e>
  103128:	c7 44 24 0c a0 66 10 	movl   $0x1066a0,0xc(%esp)
  10312f:	00 
  103130:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103137:	00 
  103138:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  10313f:	00 
  103140:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103147:	e8 7a db ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10314c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103153:	e8 10 0b 00 00       	call   103c68 <alloc_pages>
  103158:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10315b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10315f:	75 24                	jne    103185 <basic_check+0x3c7>
  103161:	c7 44 24 0c bc 66 10 	movl   $0x1066bc,0xc(%esp)
  103168:	00 
  103169:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103170:	00 
  103171:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  103178:	00 
  103179:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103180:	e8 41 db ff ff       	call   100cc6 <__panic>

    assert(alloc_page() == NULL);
  103185:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10318c:	e8 d7 0a 00 00       	call   103c68 <alloc_pages>
  103191:	85 c0                	test   %eax,%eax
  103193:	74 24                	je     1031b9 <basic_check+0x3fb>
  103195:	c7 44 24 0c a6 67 10 	movl   $0x1067a6,0xc(%esp)
  10319c:	00 
  10319d:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1031a4:	00 
  1031a5:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  1031ac:	00 
  1031ad:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1031b4:	e8 0d db ff ff       	call   100cc6 <__panic>

    free_page(p0);
  1031b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031c0:	00 
  1031c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031c4:	89 04 24             	mov    %eax,(%esp)
  1031c7:	e8 d4 0a 00 00       	call   103ca0 <free_pages>
  1031cc:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  1031d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1031d6:	8b 40 04             	mov    0x4(%eax),%eax
  1031d9:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1031dc:	0f 94 c0             	sete   %al
  1031df:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1031e2:	85 c0                	test   %eax,%eax
  1031e4:	74 24                	je     10320a <basic_check+0x44c>
  1031e6:	c7 44 24 0c c8 67 10 	movl   $0x1067c8,0xc(%esp)
  1031ed:	00 
  1031ee:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1031f5:	00 
  1031f6:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  1031fd:	00 
  1031fe:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103205:	e8 bc da ff ff       	call   100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10320a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103211:	e8 52 0a 00 00       	call   103c68 <alloc_pages>
  103216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10321c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10321f:	74 24                	je     103245 <basic_check+0x487>
  103221:	c7 44 24 0c e0 67 10 	movl   $0x1067e0,0xc(%esp)
  103228:	00 
  103229:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103230:	00 
  103231:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103238:	00 
  103239:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103240:	e8 81 da ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  103245:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10324c:	e8 17 0a 00 00       	call   103c68 <alloc_pages>
  103251:	85 c0                	test   %eax,%eax
  103253:	74 24                	je     103279 <basic_check+0x4bb>
  103255:	c7 44 24 0c a6 67 10 	movl   $0x1067a6,0xc(%esp)
  10325c:	00 
  10325d:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103264:	00 
  103265:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  10326c:	00 
  10326d:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103274:	e8 4d da ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  103279:	a1 58 89 11 00       	mov    0x118958,%eax
  10327e:	85 c0                	test   %eax,%eax
  103280:	74 24                	je     1032a6 <basic_check+0x4e8>
  103282:	c7 44 24 0c f9 67 10 	movl   $0x1067f9,0xc(%esp)
  103289:	00 
  10328a:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103291:	00 
  103292:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  103299:	00 
  10329a:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1032a1:	e8 20 da ff ff       	call   100cc6 <__panic>
    free_list = free_list_store;
  1032a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032ac:	a3 50 89 11 00       	mov    %eax,0x118950
  1032b1:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  1032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ba:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  1032bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032c6:	00 
  1032c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032ca:	89 04 24             	mov    %eax,(%esp)
  1032cd:	e8 ce 09 00 00       	call   103ca0 <free_pages>
    free_page(p1);
  1032d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032d9:	00 
  1032da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032dd:	89 04 24             	mov    %eax,(%esp)
  1032e0:	e8 bb 09 00 00       	call   103ca0 <free_pages>
    free_page(p2);
  1032e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032ec:	00 
  1032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032f0:	89 04 24             	mov    %eax,(%esp)
  1032f3:	e8 a8 09 00 00       	call   103ca0 <free_pages>
}
  1032f8:	c9                   	leave  
  1032f9:	c3                   	ret    

001032fa <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1032fa:	55                   	push   %ebp
  1032fb:	89 e5                	mov    %esp,%ebp
  1032fd:	53                   	push   %ebx
  1032fe:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10330b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103312:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103319:	eb 6b                	jmp    103386 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10331b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10331e:	83 e8 0c             	sub    $0xc,%eax
  103321:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103327:	83 c0 04             	add    $0x4,%eax
  10332a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103331:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103334:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103337:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10333a:	0f a3 10             	bt     %edx,(%eax)
  10333d:	19 c0                	sbb    %eax,%eax
  10333f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103342:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103346:	0f 95 c0             	setne  %al
  103349:	0f b6 c0             	movzbl %al,%eax
  10334c:	85 c0                	test   %eax,%eax
  10334e:	75 24                	jne    103374 <default_check+0x7a>
  103350:	c7 44 24 0c 06 68 10 	movl   $0x106806,0xc(%esp)
  103357:	00 
  103358:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  10335f:	00 
  103360:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103367:	00 
  103368:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  10336f:	e8 52 d9 ff ff       	call   100cc6 <__panic>
        count ++, total += p->property;
  103374:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337b:	8b 50 08             	mov    0x8(%eax),%edx
  10337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103381:	01 d0                	add    %edx,%eax
  103383:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10338c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10338f:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103392:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103395:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  10339c:	0f 85 79 ff ff ff    	jne    10331b <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1033a2:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1033a5:	e8 28 09 00 00       	call   103cd2 <nr_free_pages>
  1033aa:	39 c3                	cmp    %eax,%ebx
  1033ac:	74 24                	je     1033d2 <default_check+0xd8>
  1033ae:	c7 44 24 0c 16 68 10 	movl   $0x106816,0xc(%esp)
  1033b5:	00 
  1033b6:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1033bd:	00 
  1033be:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  1033c5:	00 
  1033c6:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1033cd:	e8 f4 d8 ff ff       	call   100cc6 <__panic>

    basic_check();
  1033d2:	e8 e7 f9 ff ff       	call   102dbe <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1033d7:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1033de:	e8 85 08 00 00       	call   103c68 <alloc_pages>
  1033e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1033e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1033ea:	75 24                	jne    103410 <default_check+0x116>
  1033ec:	c7 44 24 0c 2f 68 10 	movl   $0x10682f,0xc(%esp)
  1033f3:	00 
  1033f4:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1033fb:	00 
  1033fc:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103403:	00 
  103404:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  10340b:	e8 b6 d8 ff ff       	call   100cc6 <__panic>
    assert(!PageProperty(p0));
  103410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103413:	83 c0 04             	add    $0x4,%eax
  103416:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10341d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103420:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103423:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103426:	0f a3 10             	bt     %edx,(%eax)
  103429:	19 c0                	sbb    %eax,%eax
  10342b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10342e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103432:	0f 95 c0             	setne  %al
  103435:	0f b6 c0             	movzbl %al,%eax
  103438:	85 c0                	test   %eax,%eax
  10343a:	74 24                	je     103460 <default_check+0x166>
  10343c:	c7 44 24 0c 3a 68 10 	movl   $0x10683a,0xc(%esp)
  103443:	00 
  103444:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  10344b:	00 
  10344c:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103453:	00 
  103454:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  10345b:	e8 66 d8 ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  103460:	a1 50 89 11 00       	mov    0x118950,%eax
  103465:	8b 15 54 89 11 00    	mov    0x118954,%edx
  10346b:	89 45 80             	mov    %eax,-0x80(%ebp)
  10346e:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103471:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103478:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10347b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10347e:	89 50 04             	mov    %edx,0x4(%eax)
  103481:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103484:	8b 50 04             	mov    0x4(%eax),%edx
  103487:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10348a:	89 10                	mov    %edx,(%eax)
  10348c:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103493:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103496:	8b 40 04             	mov    0x4(%eax),%eax
  103499:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  10349c:	0f 94 c0             	sete   %al
  10349f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1034a2:	85 c0                	test   %eax,%eax
  1034a4:	75 24                	jne    1034ca <default_check+0x1d0>
  1034a6:	c7 44 24 0c 8f 67 10 	movl   $0x10678f,0xc(%esp)
  1034ad:	00 
  1034ae:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1034b5:	00 
  1034b6:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1034bd:	00 
  1034be:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1034c5:	e8 fc d7 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1034ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034d1:	e8 92 07 00 00       	call   103c68 <alloc_pages>
  1034d6:	85 c0                	test   %eax,%eax
  1034d8:	74 24                	je     1034fe <default_check+0x204>
  1034da:	c7 44 24 0c a6 67 10 	movl   $0x1067a6,0xc(%esp)
  1034e1:	00 
  1034e2:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1034e9:	00 
  1034ea:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  1034f1:	00 
  1034f2:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1034f9:	e8 c8 d7 ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  1034fe:	a1 58 89 11 00       	mov    0x118958,%eax
  103503:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103506:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10350d:	00 00 00 

    free_pages(p0 + 2, 3);
  103510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103513:	83 c0 28             	add    $0x28,%eax
  103516:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10351d:	00 
  10351e:	89 04 24             	mov    %eax,(%esp)
  103521:	e8 7a 07 00 00       	call   103ca0 <free_pages>
    assert(alloc_pages(4) == NULL);
  103526:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10352d:	e8 36 07 00 00       	call   103c68 <alloc_pages>
  103532:	85 c0                	test   %eax,%eax
  103534:	74 24                	je     10355a <default_check+0x260>
  103536:	c7 44 24 0c 4c 68 10 	movl   $0x10684c,0xc(%esp)
  10353d:	00 
  10353e:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103545:	00 
  103546:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  10354d:	00 
  10354e:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103555:	e8 6c d7 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10355a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10355d:	83 c0 28             	add    $0x28,%eax
  103560:	83 c0 04             	add    $0x4,%eax
  103563:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10356a:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10356d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103570:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103573:	0f a3 10             	bt     %edx,(%eax)
  103576:	19 c0                	sbb    %eax,%eax
  103578:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  10357b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10357f:	0f 95 c0             	setne  %al
  103582:	0f b6 c0             	movzbl %al,%eax
  103585:	85 c0                	test   %eax,%eax
  103587:	74 0e                	je     103597 <default_check+0x29d>
  103589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10358c:	83 c0 28             	add    $0x28,%eax
  10358f:	8b 40 08             	mov    0x8(%eax),%eax
  103592:	83 f8 03             	cmp    $0x3,%eax
  103595:	74 24                	je     1035bb <default_check+0x2c1>
  103597:	c7 44 24 0c 64 68 10 	movl   $0x106864,0xc(%esp)
  10359e:	00 
  10359f:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1035a6:	00 
  1035a7:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  1035ae:	00 
  1035af:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1035b6:	e8 0b d7 ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1035bb:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1035c2:	e8 a1 06 00 00       	call   103c68 <alloc_pages>
  1035c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1035ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1035ce:	75 24                	jne    1035f4 <default_check+0x2fa>
  1035d0:	c7 44 24 0c 90 68 10 	movl   $0x106890,0xc(%esp)
  1035d7:	00 
  1035d8:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1035df:	00 
  1035e0:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1035e7:	00 
  1035e8:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1035ef:	e8 d2 d6 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1035f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035fb:	e8 68 06 00 00       	call   103c68 <alloc_pages>
  103600:	85 c0                	test   %eax,%eax
  103602:	74 24                	je     103628 <default_check+0x32e>
  103604:	c7 44 24 0c a6 67 10 	movl   $0x1067a6,0xc(%esp)
  10360b:	00 
  10360c:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103613:	00 
  103614:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  10361b:	00 
  10361c:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103623:	e8 9e d6 ff ff       	call   100cc6 <__panic>
    assert(p0 + 2 == p1);
  103628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10362b:	83 c0 28             	add    $0x28,%eax
  10362e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103631:	74 24                	je     103657 <default_check+0x35d>
  103633:	c7 44 24 0c ae 68 10 	movl   $0x1068ae,0xc(%esp)
  10363a:	00 
  10363b:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103642:	00 
  103643:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10364a:	00 
  10364b:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103652:	e8 6f d6 ff ff       	call   100cc6 <__panic>

    p2 = p0 + 1;
  103657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10365a:	83 c0 14             	add    $0x14,%eax
  10365d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103660:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103667:	00 
  103668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10366b:	89 04 24             	mov    %eax,(%esp)
  10366e:	e8 2d 06 00 00       	call   103ca0 <free_pages>
    free_pages(p1, 3);
  103673:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10367a:	00 
  10367b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10367e:	89 04 24             	mov    %eax,(%esp)
  103681:	e8 1a 06 00 00       	call   103ca0 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103689:	83 c0 04             	add    $0x4,%eax
  10368c:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103693:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103696:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103699:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10369c:	0f a3 10             	bt     %edx,(%eax)
  10369f:	19 c0                	sbb    %eax,%eax
  1036a1:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1036a4:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1036a8:	0f 95 c0             	setne  %al
  1036ab:	0f b6 c0             	movzbl %al,%eax
  1036ae:	85 c0                	test   %eax,%eax
  1036b0:	74 0b                	je     1036bd <default_check+0x3c3>
  1036b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036b5:	8b 40 08             	mov    0x8(%eax),%eax
  1036b8:	83 f8 01             	cmp    $0x1,%eax
  1036bb:	74 24                	je     1036e1 <default_check+0x3e7>
  1036bd:	c7 44 24 0c bc 68 10 	movl   $0x1068bc,0xc(%esp)
  1036c4:	00 
  1036c5:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1036cc:	00 
  1036cd:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  1036d4:	00 
  1036d5:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1036dc:	e8 e5 d5 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1036e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036e4:	83 c0 04             	add    $0x4,%eax
  1036e7:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1036ee:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  1036f4:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1036f7:	0f a3 10             	bt     %edx,(%eax)
  1036fa:	19 c0                	sbb    %eax,%eax
  1036fc:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1036ff:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103703:	0f 95 c0             	setne  %al
  103706:	0f b6 c0             	movzbl %al,%eax
  103709:	85 c0                	test   %eax,%eax
  10370b:	74 0b                	je     103718 <default_check+0x41e>
  10370d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103710:	8b 40 08             	mov    0x8(%eax),%eax
  103713:	83 f8 03             	cmp    $0x3,%eax
  103716:	74 24                	je     10373c <default_check+0x442>
  103718:	c7 44 24 0c e4 68 10 	movl   $0x1068e4,0xc(%esp)
  10371f:	00 
  103720:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103727:	00 
  103728:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10372f:	00 
  103730:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103737:	e8 8a d5 ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10373c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103743:	e8 20 05 00 00       	call   103c68 <alloc_pages>
  103748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10374b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10374e:	83 e8 14             	sub    $0x14,%eax
  103751:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103754:	74 24                	je     10377a <default_check+0x480>
  103756:	c7 44 24 0c 0a 69 10 	movl   $0x10690a,0xc(%esp)
  10375d:	00 
  10375e:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103765:	00 
  103766:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  10376d:	00 
  10376e:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103775:	e8 4c d5 ff ff       	call   100cc6 <__panic>
    free_page(p0);
  10377a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103781:	00 
  103782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103785:	89 04 24             	mov    %eax,(%esp)
  103788:	e8 13 05 00 00       	call   103ca0 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10378d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103794:	e8 cf 04 00 00       	call   103c68 <alloc_pages>
  103799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10379c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10379f:	83 c0 14             	add    $0x14,%eax
  1037a2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037a5:	74 24                	je     1037cb <default_check+0x4d1>
  1037a7:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  1037ae:	00 
  1037af:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  1037b6:	00 
  1037b7:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1037be:	00 
  1037bf:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  1037c6:	e8 fb d4 ff ff       	call   100cc6 <__panic>

    free_pages(p0, 2);
  1037cb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1037d2:	00 
  1037d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037d6:	89 04 24             	mov    %eax,(%esp)
  1037d9:	e8 c2 04 00 00       	call   103ca0 <free_pages>
    free_page(p2);
  1037de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037e5:	00 
  1037e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037e9:	89 04 24             	mov    %eax,(%esp)
  1037ec:	e8 af 04 00 00       	call   103ca0 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1037f1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1037f8:	e8 6b 04 00 00       	call   103c68 <alloc_pages>
  1037fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103804:	75 24                	jne    10382a <default_check+0x530>
  103806:	c7 44 24 0c 48 69 10 	movl   $0x106948,0xc(%esp)
  10380d:	00 
  10380e:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103815:	00 
  103816:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  10381d:	00 
  10381e:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103825:	e8 9c d4 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  10382a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103831:	e8 32 04 00 00       	call   103c68 <alloc_pages>
  103836:	85 c0                	test   %eax,%eax
  103838:	74 24                	je     10385e <default_check+0x564>
  10383a:	c7 44 24 0c a6 67 10 	movl   $0x1067a6,0xc(%esp)
  103841:	00 
  103842:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103849:	00 
  10384a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  103851:	00 
  103852:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103859:	e8 68 d4 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  10385e:	a1 58 89 11 00       	mov    0x118958,%eax
  103863:	85 c0                	test   %eax,%eax
  103865:	74 24                	je     10388b <default_check+0x591>
  103867:	c7 44 24 0c f9 67 10 	movl   $0x1067f9,0xc(%esp)
  10386e:	00 
  10386f:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103876:	00 
  103877:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10387e:	00 
  10387f:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103886:	e8 3b d4 ff ff       	call   100cc6 <__panic>
    nr_free = nr_free_store;
  10388b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10388e:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  103893:	8b 45 80             	mov    -0x80(%ebp),%eax
  103896:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103899:	a3 50 89 11 00       	mov    %eax,0x118950
  10389e:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  1038a4:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1038ab:	00 
  1038ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038af:	89 04 24             	mov    %eax,(%esp)
  1038b2:	e8 e9 03 00 00       	call   103ca0 <free_pages>

    le = &free_list;
  1038b7:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1038be:	eb 1d                	jmp    1038dd <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  1038c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038c3:	83 e8 0c             	sub    $0xc,%eax
  1038c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1038c9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1038cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1038d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1038d3:	8b 40 08             	mov    0x8(%eax),%eax
  1038d6:	29 c2                	sub    %eax,%edx
  1038d8:	89 d0                	mov    %edx,%eax
  1038da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038e0:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1038e3:	8b 45 88             	mov    -0x78(%ebp),%eax
  1038e6:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1038e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1038ec:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1038f3:	75 cb                	jne    1038c0 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1038f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1038f9:	74 24                	je     10391f <default_check+0x625>
  1038fb:	c7 44 24 0c 66 69 10 	movl   $0x106966,0xc(%esp)
  103902:	00 
  103903:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  10390a:	00 
  10390b:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103912:	00 
  103913:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  10391a:	e8 a7 d3 ff ff       	call   100cc6 <__panic>
    assert(total == 0);
  10391f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103923:	74 24                	je     103949 <default_check+0x64f>
  103925:	c7 44 24 0c 71 69 10 	movl   $0x106971,0xc(%esp)
  10392c:	00 
  10392d:	c7 44 24 08 36 66 10 	movl   $0x106636,0x8(%esp)
  103934:	00 
  103935:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  10393c:	00 
  10393d:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  103944:	e8 7d d3 ff ff       	call   100cc6 <__panic>
}
  103949:	81 c4 94 00 00 00    	add    $0x94,%esp
  10394f:	5b                   	pop    %ebx
  103950:	5d                   	pop    %ebp
  103951:	c3                   	ret    

00103952 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103952:	55                   	push   %ebp
  103953:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103955:	8b 55 08             	mov    0x8(%ebp),%edx
  103958:	a1 64 89 11 00       	mov    0x118964,%eax
  10395d:	29 c2                	sub    %eax,%edx
  10395f:	89 d0                	mov    %edx,%eax
  103961:	c1 f8 02             	sar    $0x2,%eax
  103964:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10396a:	5d                   	pop    %ebp
  10396b:	c3                   	ret    

0010396c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10396c:	55                   	push   %ebp
  10396d:	89 e5                	mov    %esp,%ebp
  10396f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103972:	8b 45 08             	mov    0x8(%ebp),%eax
  103975:	89 04 24             	mov    %eax,(%esp)
  103978:	e8 d5 ff ff ff       	call   103952 <page2ppn>
  10397d:	c1 e0 0c             	shl    $0xc,%eax
}
  103980:	c9                   	leave  
  103981:	c3                   	ret    

00103982 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103982:	55                   	push   %ebp
  103983:	89 e5                	mov    %esp,%ebp
  103985:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103988:	8b 45 08             	mov    0x8(%ebp),%eax
  10398b:	c1 e8 0c             	shr    $0xc,%eax
  10398e:	89 c2                	mov    %eax,%edx
  103990:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103995:	39 c2                	cmp    %eax,%edx
  103997:	72 1c                	jb     1039b5 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103999:	c7 44 24 08 ac 69 10 	movl   $0x1069ac,0x8(%esp)
  1039a0:	00 
  1039a1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1039a8:	00 
  1039a9:	c7 04 24 cb 69 10 00 	movl   $0x1069cb,(%esp)
  1039b0:	e8 11 d3 ff ff       	call   100cc6 <__panic>
    }
    return &pages[PPN(pa)];
  1039b5:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  1039bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1039be:	c1 e8 0c             	shr    $0xc,%eax
  1039c1:	89 c2                	mov    %eax,%edx
  1039c3:	89 d0                	mov    %edx,%eax
  1039c5:	c1 e0 02             	shl    $0x2,%eax
  1039c8:	01 d0                	add    %edx,%eax
  1039ca:	c1 e0 02             	shl    $0x2,%eax
  1039cd:	01 c8                	add    %ecx,%eax
}
  1039cf:	c9                   	leave  
  1039d0:	c3                   	ret    

001039d1 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1039d1:	55                   	push   %ebp
  1039d2:	89 e5                	mov    %esp,%ebp
  1039d4:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1039d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1039da:	89 04 24             	mov    %eax,(%esp)
  1039dd:	e8 8a ff ff ff       	call   10396c <page2pa>
  1039e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1039e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039e8:	c1 e8 0c             	shr    $0xc,%eax
  1039eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039ee:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039f3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1039f6:	72 23                	jb     103a1b <page2kva+0x4a>
  1039f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039ff:	c7 44 24 08 dc 69 10 	movl   $0x1069dc,0x8(%esp)
  103a06:	00 
  103a07:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a0e:	00 
  103a0f:	c7 04 24 cb 69 10 00 	movl   $0x1069cb,(%esp)
  103a16:	e8 ab d2 ff ff       	call   100cc6 <__panic>
  103a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a1e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a23:	c9                   	leave  
  103a24:	c3                   	ret    

00103a25 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a25:	55                   	push   %ebp
  103a26:	89 e5                	mov    %esp,%ebp
  103a28:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a2e:	83 e0 01             	and    $0x1,%eax
  103a31:	85 c0                	test   %eax,%eax
  103a33:	75 1c                	jne    103a51 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a35:	c7 44 24 08 00 6a 10 	movl   $0x106a00,0x8(%esp)
  103a3c:	00 
  103a3d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103a44:	00 
  103a45:	c7 04 24 cb 69 10 00 	movl   $0x1069cb,(%esp)
  103a4c:	e8 75 d2 ff ff       	call   100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103a51:	8b 45 08             	mov    0x8(%ebp),%eax
  103a54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a59:	89 04 24             	mov    %eax,(%esp)
  103a5c:	e8 21 ff ff ff       	call   103982 <pa2page>
}
  103a61:	c9                   	leave  
  103a62:	c3                   	ret    

00103a63 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103a63:	55                   	push   %ebp
  103a64:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103a66:	8b 45 08             	mov    0x8(%ebp),%eax
  103a69:	8b 00                	mov    (%eax),%eax
}
  103a6b:	5d                   	pop    %ebp
  103a6c:	c3                   	ret    

00103a6d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103a6d:	55                   	push   %ebp
  103a6e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103a70:	8b 45 08             	mov    0x8(%ebp),%eax
  103a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a76:	89 10                	mov    %edx,(%eax)
}
  103a78:	5d                   	pop    %ebp
  103a79:	c3                   	ret    

00103a7a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103a7a:	55                   	push   %ebp
  103a7b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a80:	8b 00                	mov    (%eax),%eax
  103a82:	8d 50 01             	lea    0x1(%eax),%edx
  103a85:	8b 45 08             	mov    0x8(%ebp),%eax
  103a88:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  103a8d:	8b 00                	mov    (%eax),%eax
}
  103a8f:	5d                   	pop    %ebp
  103a90:	c3                   	ret    

00103a91 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103a91:	55                   	push   %ebp
  103a92:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103a94:	8b 45 08             	mov    0x8(%ebp),%eax
  103a97:	8b 00                	mov    (%eax),%eax
  103a99:	8d 50 ff             	lea    -0x1(%eax),%edx
  103a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  103a9f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa4:	8b 00                	mov    (%eax),%eax
}
  103aa6:	5d                   	pop    %ebp
  103aa7:	c3                   	ret    

00103aa8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103aa8:	55                   	push   %ebp
  103aa9:	89 e5                	mov    %esp,%ebp
  103aab:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103aae:	9c                   	pushf  
  103aaf:	58                   	pop    %eax
  103ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103ab6:	25 00 02 00 00       	and    $0x200,%eax
  103abb:	85 c0                	test   %eax,%eax
  103abd:	74 0c                	je     103acb <__intr_save+0x23>
        intr_disable();
  103abf:	e8 e5 db ff ff       	call   1016a9 <intr_disable>
        return 1;
  103ac4:	b8 01 00 00 00       	mov    $0x1,%eax
  103ac9:	eb 05                	jmp    103ad0 <__intr_save+0x28>
    }
    return 0;
  103acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103ad0:	c9                   	leave  
  103ad1:	c3                   	ret    

00103ad2 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103ad2:	55                   	push   %ebp
  103ad3:	89 e5                	mov    %esp,%ebp
  103ad5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103ad8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103adc:	74 05                	je     103ae3 <__intr_restore+0x11>
        intr_enable();
  103ade:	e8 c0 db ff ff       	call   1016a3 <intr_enable>
    }
}
  103ae3:	c9                   	leave  
  103ae4:	c3                   	ret    

00103ae5 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103ae5:	55                   	push   %ebp
  103ae6:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  103aeb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103aee:	b8 23 00 00 00       	mov    $0x23,%eax
  103af3:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103af5:	b8 23 00 00 00       	mov    $0x23,%eax
  103afa:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103afc:	b8 10 00 00 00       	mov    $0x10,%eax
  103b01:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b03:	b8 10 00 00 00       	mov    $0x10,%eax
  103b08:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b0a:	b8 10 00 00 00       	mov    $0x10,%eax
  103b0f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b11:	ea 18 3b 10 00 08 00 	ljmp   $0x8,$0x103b18
}
  103b18:	5d                   	pop    %ebp
  103b19:	c3                   	ret    

00103b1a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b1a:	55                   	push   %ebp
  103b1b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  103b20:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103b25:	5d                   	pop    %ebp
  103b26:	c3                   	ret    

00103b27 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b27:	55                   	push   %ebp
  103b28:	89 e5                	mov    %esp,%ebp
  103b2a:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b2d:	b8 00 70 11 00       	mov    $0x117000,%eax
  103b32:	89 04 24             	mov    %eax,(%esp)
  103b35:	e8 e0 ff ff ff       	call   103b1a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b3a:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103b41:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103b43:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103b4a:	68 00 
  103b4c:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b51:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103b57:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b5c:	c1 e8 10             	shr    $0x10,%eax
  103b5f:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103b64:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b6b:	83 e0 f0             	and    $0xfffffff0,%eax
  103b6e:	83 c8 09             	or     $0x9,%eax
  103b71:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b76:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b7d:	83 e0 ef             	and    $0xffffffef,%eax
  103b80:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b85:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b8c:	83 e0 9f             	and    $0xffffff9f,%eax
  103b8f:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b94:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b9b:	83 c8 80             	or     $0xffffff80,%eax
  103b9e:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103ba3:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103baa:	83 e0 f0             	and    $0xfffffff0,%eax
  103bad:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bb2:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103bb9:	83 e0 ef             	and    $0xffffffef,%eax
  103bbc:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bc1:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103bc8:	83 e0 df             	and    $0xffffffdf,%eax
  103bcb:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bd0:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103bd7:	83 c8 40             	or     $0x40,%eax
  103bda:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bdf:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103be6:	83 e0 7f             	and    $0x7f,%eax
  103be9:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bee:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bf3:	c1 e8 18             	shr    $0x18,%eax
  103bf6:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103bfb:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c02:	e8 de fe ff ff       	call   103ae5 <lgdt>
  103c07:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c0d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c11:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c14:	c9                   	leave  
  103c15:	c3                   	ret    

00103c16 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c16:	55                   	push   %ebp
  103c17:	89 e5                	mov    %esp,%ebp
  103c19:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c1c:	c7 05 5c 89 11 00 90 	movl   $0x106990,0x11895c
  103c23:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c26:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c2b:	8b 00                	mov    (%eax),%eax
  103c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c31:	c7 04 24 2c 6a 10 00 	movl   $0x106a2c,(%esp)
  103c38:	e8 ff c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103c3d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c42:	8b 40 04             	mov    0x4(%eax),%eax
  103c45:	ff d0                	call   *%eax
}
  103c47:	c9                   	leave  
  103c48:	c3                   	ret    

00103c49 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103c49:	55                   	push   %ebp
  103c4a:	89 e5                	mov    %esp,%ebp
  103c4c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103c4f:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c54:	8b 40 08             	mov    0x8(%eax),%eax
  103c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c5a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  103c61:	89 14 24             	mov    %edx,(%esp)
  103c64:	ff d0                	call   *%eax
}
  103c66:	c9                   	leave  
  103c67:	c3                   	ret    

00103c68 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103c68:	55                   	push   %ebp
  103c69:	89 e5                	mov    %esp,%ebp
  103c6b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103c6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103c75:	e8 2e fe ff ff       	call   103aa8 <__intr_save>
  103c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103c7d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c82:	8b 40 0c             	mov    0xc(%eax),%eax
  103c85:	8b 55 08             	mov    0x8(%ebp),%edx
  103c88:	89 14 24             	mov    %edx,(%esp)
  103c8b:	ff d0                	call   *%eax
  103c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c93:	89 04 24             	mov    %eax,(%esp)
  103c96:	e8 37 fe ff ff       	call   103ad2 <__intr_restore>
    return page;
  103c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103c9e:	c9                   	leave  
  103c9f:	c3                   	ret    

00103ca0 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103ca0:	55                   	push   %ebp
  103ca1:	89 e5                	mov    %esp,%ebp
  103ca3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103ca6:	e8 fd fd ff ff       	call   103aa8 <__intr_save>
  103cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103cae:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cb3:	8b 40 10             	mov    0x10(%eax),%eax
  103cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cb9:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  103cc0:	89 14 24             	mov    %edx,(%esp)
  103cc3:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cc8:	89 04 24             	mov    %eax,(%esp)
  103ccb:	e8 02 fe ff ff       	call   103ad2 <__intr_restore>
}
  103cd0:	c9                   	leave  
  103cd1:	c3                   	ret    

00103cd2 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103cd2:	55                   	push   %ebp
  103cd3:	89 e5                	mov    %esp,%ebp
  103cd5:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103cd8:	e8 cb fd ff ff       	call   103aa8 <__intr_save>
  103cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103ce0:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103ce5:	8b 40 14             	mov    0x14(%eax),%eax
  103ce8:	ff d0                	call   *%eax
  103cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cf0:	89 04 24             	mov    %eax,(%esp)
  103cf3:	e8 da fd ff ff       	call   103ad2 <__intr_restore>
    return ret;
  103cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103cfb:	c9                   	leave  
  103cfc:	c3                   	ret    

00103cfd <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103cfd:	55                   	push   %ebp
  103cfe:	89 e5                	mov    %esp,%ebp
  103d00:	57                   	push   %edi
  103d01:	56                   	push   %esi
  103d02:	53                   	push   %ebx
  103d03:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d09:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d10:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d1e:	c7 04 24 43 6a 10 00 	movl   $0x106a43,(%esp)
  103d25:	e8 12 c6 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d31:	e9 15 01 00 00       	jmp    103e4b <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d36:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d3c:	89 d0                	mov    %edx,%eax
  103d3e:	c1 e0 02             	shl    $0x2,%eax
  103d41:	01 d0                	add    %edx,%eax
  103d43:	c1 e0 02             	shl    $0x2,%eax
  103d46:	01 c8                	add    %ecx,%eax
  103d48:	8b 50 08             	mov    0x8(%eax),%edx
  103d4b:	8b 40 04             	mov    0x4(%eax),%eax
  103d4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103d51:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103d54:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d5a:	89 d0                	mov    %edx,%eax
  103d5c:	c1 e0 02             	shl    $0x2,%eax
  103d5f:	01 d0                	add    %edx,%eax
  103d61:	c1 e0 02             	shl    $0x2,%eax
  103d64:	01 c8                	add    %ecx,%eax
  103d66:	8b 48 0c             	mov    0xc(%eax),%ecx
  103d69:	8b 58 10             	mov    0x10(%eax),%ebx
  103d6c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103d6f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103d72:	01 c8                	add    %ecx,%eax
  103d74:	11 da                	adc    %ebx,%edx
  103d76:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103d79:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103d7c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d82:	89 d0                	mov    %edx,%eax
  103d84:	c1 e0 02             	shl    $0x2,%eax
  103d87:	01 d0                	add    %edx,%eax
  103d89:	c1 e0 02             	shl    $0x2,%eax
  103d8c:	01 c8                	add    %ecx,%eax
  103d8e:	83 c0 14             	add    $0x14,%eax
  103d91:	8b 00                	mov    (%eax),%eax
  103d93:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103d99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103d9c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103d9f:	83 c0 ff             	add    $0xffffffff,%eax
  103da2:	83 d2 ff             	adc    $0xffffffff,%edx
  103da5:	89 c6                	mov    %eax,%esi
  103da7:	89 d7                	mov    %edx,%edi
  103da9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103daf:	89 d0                	mov    %edx,%eax
  103db1:	c1 e0 02             	shl    $0x2,%eax
  103db4:	01 d0                	add    %edx,%eax
  103db6:	c1 e0 02             	shl    $0x2,%eax
  103db9:	01 c8                	add    %ecx,%eax
  103dbb:	8b 48 0c             	mov    0xc(%eax),%ecx
  103dbe:	8b 58 10             	mov    0x10(%eax),%ebx
  103dc1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103dc7:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103dcb:	89 74 24 14          	mov    %esi,0x14(%esp)
  103dcf:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103dd3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103dd6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103dd9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ddd:	89 54 24 10          	mov    %edx,0x10(%esp)
  103de1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103de5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103de9:	c7 04 24 50 6a 10 00 	movl   $0x106a50,(%esp)
  103df0:	e8 47 c5 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103df5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103df8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dfb:	89 d0                	mov    %edx,%eax
  103dfd:	c1 e0 02             	shl    $0x2,%eax
  103e00:	01 d0                	add    %edx,%eax
  103e02:	c1 e0 02             	shl    $0x2,%eax
  103e05:	01 c8                	add    %ecx,%eax
  103e07:	83 c0 14             	add    $0x14,%eax
  103e0a:	8b 00                	mov    (%eax),%eax
  103e0c:	83 f8 01             	cmp    $0x1,%eax
  103e0f:	75 36                	jne    103e47 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e17:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e1a:	77 2b                	ja     103e47 <page_init+0x14a>
  103e1c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e1f:	72 05                	jb     103e26 <page_init+0x129>
  103e21:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e24:	73 21                	jae    103e47 <page_init+0x14a>
  103e26:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e2a:	77 1b                	ja     103e47 <page_init+0x14a>
  103e2c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e30:	72 09                	jb     103e3b <page_init+0x13e>
  103e32:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e39:	77 0c                	ja     103e47 <page_init+0x14a>
                maxpa = end;
  103e3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e3e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e41:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e47:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103e4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103e4e:	8b 00                	mov    (%eax),%eax
  103e50:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103e53:	0f 8f dd fe ff ff    	jg     103d36 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e5d:	72 1d                	jb     103e7c <page_init+0x17f>
  103e5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e63:	77 09                	ja     103e6e <page_init+0x171>
  103e65:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103e6c:	76 0e                	jbe    103e7c <page_init+0x17f>
        maxpa = KMEMSIZE;
  103e6e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103e75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103e7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e82:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103e86:	c1 ea 0c             	shr    $0xc,%edx
  103e89:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103e8e:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103e95:	b8 68 89 11 00       	mov    $0x118968,%eax
  103e9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  103e9d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103ea0:	01 d0                	add    %edx,%eax
  103ea2:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103ea5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103ea8:	ba 00 00 00 00       	mov    $0x0,%edx
  103ead:	f7 75 ac             	divl   -0x54(%ebp)
  103eb0:	89 d0                	mov    %edx,%eax
  103eb2:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103eb5:	29 c2                	sub    %eax,%edx
  103eb7:	89 d0                	mov    %edx,%eax
  103eb9:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103ebe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ec5:	eb 2f                	jmp    103ef6 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103ec7:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103ecd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ed0:	89 d0                	mov    %edx,%eax
  103ed2:	c1 e0 02             	shl    $0x2,%eax
  103ed5:	01 d0                	add    %edx,%eax
  103ed7:	c1 e0 02             	shl    $0x2,%eax
  103eda:	01 c8                	add    %ecx,%eax
  103edc:	83 c0 04             	add    $0x4,%eax
  103edf:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103ee6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103ee9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103eec:	8b 55 90             	mov    -0x70(%ebp),%edx
  103eef:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103ef2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ef6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ef9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103efe:	39 c2                	cmp    %eax,%edx
  103f00:	72 c5                	jb     103ec7 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f02:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f08:	89 d0                	mov    %edx,%eax
  103f0a:	c1 e0 02             	shl    $0x2,%eax
  103f0d:	01 d0                	add    %edx,%eax
  103f0f:	c1 e0 02             	shl    $0x2,%eax
  103f12:	89 c2                	mov    %eax,%edx
  103f14:	a1 64 89 11 00       	mov    0x118964,%eax
  103f19:	01 d0                	add    %edx,%eax
  103f1b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f1e:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f25:	77 23                	ja     103f4a <page_init+0x24d>
  103f27:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f2e:	c7 44 24 08 80 6a 10 	movl   $0x106a80,0x8(%esp)
  103f35:	00 
  103f36:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f3d:	00 
  103f3e:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  103f45:	e8 7c cd ff ff       	call   100cc6 <__panic>
  103f4a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f4d:	05 00 00 00 40       	add    $0x40000000,%eax
  103f52:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103f55:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f5c:	e9 74 01 00 00       	jmp    1040d5 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103f61:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f67:	89 d0                	mov    %edx,%eax
  103f69:	c1 e0 02             	shl    $0x2,%eax
  103f6c:	01 d0                	add    %edx,%eax
  103f6e:	c1 e0 02             	shl    $0x2,%eax
  103f71:	01 c8                	add    %ecx,%eax
  103f73:	8b 50 08             	mov    0x8(%eax),%edx
  103f76:	8b 40 04             	mov    0x4(%eax),%eax
  103f79:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103f7c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103f7f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f85:	89 d0                	mov    %edx,%eax
  103f87:	c1 e0 02             	shl    $0x2,%eax
  103f8a:	01 d0                	add    %edx,%eax
  103f8c:	c1 e0 02             	shl    $0x2,%eax
  103f8f:	01 c8                	add    %ecx,%eax
  103f91:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f94:	8b 58 10             	mov    0x10(%eax),%ebx
  103f97:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f9d:	01 c8                	add    %ecx,%eax
  103f9f:	11 da                	adc    %ebx,%edx
  103fa1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103fa4:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103fa7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103faa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fad:	89 d0                	mov    %edx,%eax
  103faf:	c1 e0 02             	shl    $0x2,%eax
  103fb2:	01 d0                	add    %edx,%eax
  103fb4:	c1 e0 02             	shl    $0x2,%eax
  103fb7:	01 c8                	add    %ecx,%eax
  103fb9:	83 c0 14             	add    $0x14,%eax
  103fbc:	8b 00                	mov    (%eax),%eax
  103fbe:	83 f8 01             	cmp    $0x1,%eax
  103fc1:	0f 85 0a 01 00 00    	jne    1040d1 <page_init+0x3d4>
            if (begin < freemem) {
  103fc7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103fca:	ba 00 00 00 00       	mov    $0x0,%edx
  103fcf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103fd2:	72 17                	jb     103feb <page_init+0x2ee>
  103fd4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103fd7:	77 05                	ja     103fde <page_init+0x2e1>
  103fd9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103fdc:	76 0d                	jbe    103feb <page_init+0x2ee>
                begin = freemem;
  103fde:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103fe1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fe4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103feb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103fef:	72 1d                	jb     10400e <page_init+0x311>
  103ff1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103ff5:	77 09                	ja     104000 <page_init+0x303>
  103ff7:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103ffe:	76 0e                	jbe    10400e <page_init+0x311>
                end = KMEMSIZE;
  104000:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104007:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10400e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104011:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104014:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104017:	0f 87 b4 00 00 00    	ja     1040d1 <page_init+0x3d4>
  10401d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104020:	72 09                	jb     10402b <page_init+0x32e>
  104022:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104025:	0f 83 a6 00 00 00    	jae    1040d1 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  10402b:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104032:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104035:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104038:	01 d0                	add    %edx,%eax
  10403a:	83 e8 01             	sub    $0x1,%eax
  10403d:	89 45 98             	mov    %eax,-0x68(%ebp)
  104040:	8b 45 98             	mov    -0x68(%ebp),%eax
  104043:	ba 00 00 00 00       	mov    $0x0,%edx
  104048:	f7 75 9c             	divl   -0x64(%ebp)
  10404b:	89 d0                	mov    %edx,%eax
  10404d:	8b 55 98             	mov    -0x68(%ebp),%edx
  104050:	29 c2                	sub    %eax,%edx
  104052:	89 d0                	mov    %edx,%eax
  104054:	ba 00 00 00 00       	mov    $0x0,%edx
  104059:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10405c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10405f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104062:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104065:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104068:	ba 00 00 00 00       	mov    $0x0,%edx
  10406d:	89 c7                	mov    %eax,%edi
  10406f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104075:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104078:	89 d0                	mov    %edx,%eax
  10407a:	83 e0 00             	and    $0x0,%eax
  10407d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104080:	8b 45 80             	mov    -0x80(%ebp),%eax
  104083:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104086:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104089:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10408c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10408f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104092:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104095:	77 3a                	ja     1040d1 <page_init+0x3d4>
  104097:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10409a:	72 05                	jb     1040a1 <page_init+0x3a4>
  10409c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10409f:	73 30                	jae    1040d1 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1040a1:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1040a4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1040a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040aa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1040ad:	29 c8                	sub    %ecx,%eax
  1040af:	19 da                	sbb    %ebx,%edx
  1040b1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1040b5:	c1 ea 0c             	shr    $0xc,%edx
  1040b8:	89 c3                	mov    %eax,%ebx
  1040ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040bd:	89 04 24             	mov    %eax,(%esp)
  1040c0:	e8 bd f8 ff ff       	call   103982 <pa2page>
  1040c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1040c9:	89 04 24             	mov    %eax,(%esp)
  1040cc:	e8 78 fb ff ff       	call   103c49 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1040d1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1040d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1040d8:	8b 00                	mov    (%eax),%eax
  1040da:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1040dd:	0f 8f 7e fe ff ff    	jg     103f61 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1040e3:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1040e9:	5b                   	pop    %ebx
  1040ea:	5e                   	pop    %esi
  1040eb:	5f                   	pop    %edi
  1040ec:	5d                   	pop    %ebp
  1040ed:	c3                   	ret    

001040ee <enable_paging>:

static void
enable_paging(void) {
  1040ee:	55                   	push   %ebp
  1040ef:	89 e5                	mov    %esp,%ebp
  1040f1:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1040f4:	a1 60 89 11 00       	mov    0x118960,%eax
  1040f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1040fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1040ff:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104102:	0f 20 c0             	mov    %cr0,%eax
  104105:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104108:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10410b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10410e:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104115:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104119:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10411c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10411f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104122:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104125:	c9                   	leave  
  104126:	c3                   	ret    

00104127 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104127:	55                   	push   %ebp
  104128:	89 e5                	mov    %esp,%ebp
  10412a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10412d:	8b 45 14             	mov    0x14(%ebp),%eax
  104130:	8b 55 0c             	mov    0xc(%ebp),%edx
  104133:	31 d0                	xor    %edx,%eax
  104135:	25 ff 0f 00 00       	and    $0xfff,%eax
  10413a:	85 c0                	test   %eax,%eax
  10413c:	74 24                	je     104162 <boot_map_segment+0x3b>
  10413e:	c7 44 24 0c b2 6a 10 	movl   $0x106ab2,0xc(%esp)
  104145:	00 
  104146:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  10414d:	00 
  10414e:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  104155:	00 
  104156:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10415d:	e8 64 cb ff ff       	call   100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104162:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104169:	8b 45 0c             	mov    0xc(%ebp),%eax
  10416c:	25 ff 0f 00 00       	and    $0xfff,%eax
  104171:	89 c2                	mov    %eax,%edx
  104173:	8b 45 10             	mov    0x10(%ebp),%eax
  104176:	01 c2                	add    %eax,%edx
  104178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10417b:	01 d0                	add    %edx,%eax
  10417d:	83 e8 01             	sub    $0x1,%eax
  104180:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104186:	ba 00 00 00 00       	mov    $0x0,%edx
  10418b:	f7 75 f0             	divl   -0x10(%ebp)
  10418e:	89 d0                	mov    %edx,%eax
  104190:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104193:	29 c2                	sub    %eax,%edx
  104195:	89 d0                	mov    %edx,%eax
  104197:	c1 e8 0c             	shr    $0xc,%eax
  10419a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10419d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1041a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1041ab:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1041ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1041b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1041b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1041bc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1041bf:	eb 6b                	jmp    10422c <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1041c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1041c8:	00 
  1041c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1041d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1041d3:	89 04 24             	mov    %eax,(%esp)
  1041d6:	e8 cc 01 00 00       	call   1043a7 <get_pte>
  1041db:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1041de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1041e2:	75 24                	jne    104208 <boot_map_segment+0xe1>
  1041e4:	c7 44 24 0c de 6a 10 	movl   $0x106ade,0xc(%esp)
  1041eb:	00 
  1041ec:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  1041f3:	00 
  1041f4:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1041fb:	00 
  1041fc:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104203:	e8 be ca ff ff       	call   100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
  104208:	8b 45 18             	mov    0x18(%ebp),%eax
  10420b:	8b 55 14             	mov    0x14(%ebp),%edx
  10420e:	09 d0                	or     %edx,%eax
  104210:	83 c8 01             	or     $0x1,%eax
  104213:	89 c2                	mov    %eax,%edx
  104215:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104218:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10421a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10421e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104225:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10422c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104230:	75 8f                	jne    1041c1 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104232:	c9                   	leave  
  104233:	c3                   	ret    

00104234 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104234:	55                   	push   %ebp
  104235:	89 e5                	mov    %esp,%ebp
  104237:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10423a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104241:	e8 22 fa ff ff       	call   103c68 <alloc_pages>
  104246:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104249:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10424d:	75 1c                	jne    10426b <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10424f:	c7 44 24 08 eb 6a 10 	movl   $0x106aeb,0x8(%esp)
  104256:	00 
  104257:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10425e:	00 
  10425f:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104266:	e8 5b ca ff ff       	call   100cc6 <__panic>
    }
    return page2kva(p);
  10426b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10426e:	89 04 24             	mov    %eax,(%esp)
  104271:	e8 5b f7 ff ff       	call   1039d1 <page2kva>
}
  104276:	c9                   	leave  
  104277:	c3                   	ret    

00104278 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104278:	55                   	push   %ebp
  104279:	89 e5                	mov    %esp,%ebp
  10427b:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10427e:	e8 93 f9 ff ff       	call   103c16 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104283:	e8 75 fa ff ff       	call   103cfd <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104288:	e8 66 04 00 00       	call   1046f3 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  10428d:	e8 a2 ff ff ff       	call   104234 <boot_alloc_page>
  104292:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  104297:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10429c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1042a3:	00 
  1042a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042ab:	00 
  1042ac:	89 04 24             	mov    %eax,(%esp)
  1042af:	e8 a8 1a 00 00       	call   105d5c <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1042b4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1042bc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1042c3:	77 23                	ja     1042e8 <pmm_init+0x70>
  1042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1042cc:	c7 44 24 08 80 6a 10 	movl   $0x106a80,0x8(%esp)
  1042d3:	00 
  1042d4:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1042db:	00 
  1042dc:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  1042e3:	e8 de c9 ff ff       	call   100cc6 <__panic>
  1042e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042eb:	05 00 00 00 40       	add    $0x40000000,%eax
  1042f0:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1042f5:	e8 17 04 00 00       	call   104711 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1042fa:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042ff:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104305:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10430a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10430d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104314:	77 23                	ja     104339 <pmm_init+0xc1>
  104316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10431d:	c7 44 24 08 80 6a 10 	movl   $0x106a80,0x8(%esp)
  104324:	00 
  104325:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10432c:	00 
  10432d:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104334:	e8 8d c9 ff ff       	call   100cc6 <__panic>
  104339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10433c:	05 00 00 00 40       	add    $0x40000000,%eax
  104341:	83 c8 03             	or     $0x3,%eax
  104344:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104346:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10434b:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104352:	00 
  104353:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10435a:	00 
  10435b:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104362:	38 
  104363:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10436a:	c0 
  10436b:	89 04 24             	mov    %eax,(%esp)
  10436e:	e8 b4 fd ff ff       	call   104127 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104373:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104378:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  10437e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104384:	89 10                	mov    %edx,(%eax)

    enable_paging();
  104386:	e8 63 fd ff ff       	call   1040ee <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10438b:	e8 97 f7 ff ff       	call   103b27 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104390:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10439b:	e8 0c 0a 00 00       	call   104dac <check_boot_pgdir>

    print_pgdir();
  1043a0:	e8 99 0e 00 00       	call   10523e <print_pgdir>

}
  1043a5:	c9                   	leave  
  1043a6:	c3                   	ret    

001043a7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1043a7:	55                   	push   %ebp
  1043a8:	89 e5                	mov    %esp,%ebp
  1043aa:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  1043ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043b0:	c1 e8 16             	shr    $0x16,%eax
  1043b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1043ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1043bd:	01 d0                	add    %edx,%eax
  1043bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P)) {
  1043c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043c5:	8b 00                	mov    (%eax),%eax
  1043c7:	83 e0 01             	and    $0x1,%eax
  1043ca:	85 c0                	test   %eax,%eax
  1043cc:	0f 85 af 00 00 00    	jne    104481 <get_pte+0xda>
		struct Page *page;
		if (!create || (page = alloc_page()) == NULL) {
  1043d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1043d6:	74 15                	je     1043ed <get_pte+0x46>
  1043d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1043df:	e8 84 f8 ff ff       	call   103c68 <alloc_pages>
  1043e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1043eb:	75 0a                	jne    1043f7 <get_pte+0x50>
			return NULL;
  1043ed:	b8 00 00 00 00       	mov    $0x0,%eax
  1043f2:	e9 e6 00 00 00       	jmp    1044dd <get_pte+0x136>
		}
		set_page_ref(page, 1);
  1043f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1043fe:	00 
  1043ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104402:	89 04 24             	mov    %eax,(%esp)
  104405:	e8 63 f6 ff ff       	call   103a6d <set_page_ref>
		uintptr_t pa = page2pa(page);
  10440a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10440d:	89 04 24             	mov    %eax,(%esp)
  104410:	e8 57 f5 ff ff       	call   10396c <page2pa>
  104415:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
  104418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10441b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10441e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104421:	c1 e8 0c             	shr    $0xc,%eax
  104424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104427:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10442c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10442f:	72 23                	jb     104454 <get_pte+0xad>
  104431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104434:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104438:	c7 44 24 08 dc 69 10 	movl   $0x1069dc,0x8(%esp)
  10443f:	00 
  104440:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
  104447:	00 
  104448:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10444f:	e8 72 c8 ff ff       	call   100cc6 <__panic>
  104454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104457:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10445c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104463:	00 
  104464:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10446b:	00 
  10446c:	89 04 24             	mov    %eax,(%esp)
  10446f:	e8 e8 18 00 00       	call   105d5c <memset>
		*pdep = pa | PTE_U | PTE_W | PTE_P;
  104474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104477:	83 c8 07             	or     $0x7,%eax
  10447a:	89 c2                	mov    %eax,%edx
  10447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10447f:	89 10                	mov    %edx,(%eax)
	}
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  104481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104484:	8b 00                	mov    (%eax),%eax
  104486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10448b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10448e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104491:	c1 e8 0c             	shr    $0xc,%eax
  104494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104497:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10449c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10449f:	72 23                	jb     1044c4 <get_pte+0x11d>
  1044a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044a8:	c7 44 24 08 dc 69 10 	movl   $0x1069dc,0x8(%esp)
  1044af:	00 
  1044b0:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  1044b7:	00 
  1044b8:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  1044bf:	e8 02 c8 ff ff       	call   100cc6 <__panic>
  1044c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044c7:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1044cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044cf:	c1 ea 0c             	shr    $0xc,%edx
  1044d2:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  1044d8:	c1 e2 02             	shl    $0x2,%edx
  1044db:	01 d0                	add    %edx,%eax
}
  1044dd:	c9                   	leave  
  1044de:	c3                   	ret    

001044df <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1044df:	55                   	push   %ebp
  1044e0:	89 e5                	mov    %esp,%ebp
  1044e2:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1044e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044ec:	00 
  1044ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1044f7:	89 04 24             	mov    %eax,(%esp)
  1044fa:	e8 a8 fe ff ff       	call   1043a7 <get_pte>
  1044ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104502:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104506:	74 08                	je     104510 <get_page+0x31>
        *ptep_store = ptep;
  104508:	8b 45 10             	mov    0x10(%ebp),%eax
  10450b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10450e:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104514:	74 1b                	je     104531 <get_page+0x52>
  104516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104519:	8b 00                	mov    (%eax),%eax
  10451b:	83 e0 01             	and    $0x1,%eax
  10451e:	85 c0                	test   %eax,%eax
  104520:	74 0f                	je     104531 <get_page+0x52>
        return pa2page(*ptep);
  104522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104525:	8b 00                	mov    (%eax),%eax
  104527:	89 04 24             	mov    %eax,(%esp)
  10452a:	e8 53 f4 ff ff       	call   103982 <pa2page>
  10452f:	eb 05                	jmp    104536 <get_page+0x57>
    }
    return NULL;
  104531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104536:	c9                   	leave  
  104537:	c3                   	ret    

00104538 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104538:	55                   	push   %ebp
  104539:	89 e5                	mov    %esp,%ebp
  10453b:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
		if (*ptep & PTE_P) {
  10453e:	8b 45 10             	mov    0x10(%ebp),%eax
  104541:	8b 00                	mov    (%eax),%eax
  104543:	83 e0 01             	and    $0x1,%eax
  104546:	85 c0                	test   %eax,%eax
  104548:	74 4d                	je     104597 <page_remove_pte+0x5f>
		struct Page *page = pte2page(*ptep);
  10454a:	8b 45 10             	mov    0x10(%ebp),%eax
  10454d:	8b 00                	mov    (%eax),%eax
  10454f:	89 04 24             	mov    %eax,(%esp)
  104552:	e8 ce f4 ff ff       	call   103a25 <pte2page>
  104557:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (page_ref_dec(page) == 0) {
  10455a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10455d:	89 04 24             	mov    %eax,(%esp)
  104560:	e8 2c f5 ff ff       	call   103a91 <page_ref_dec>
  104565:	85 c0                	test   %eax,%eax
  104567:	75 13                	jne    10457c <page_remove_pte+0x44>
			free_page(page);
  104569:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104570:	00 
  104571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104574:	89 04 24             	mov    %eax,(%esp)
  104577:	e8 24 f7 ff ff       	call   103ca0 <free_pages>
		}
		*ptep = 0;
  10457c:	8b 45 10             	mov    0x10(%ebp),%eax
  10457f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
  104585:	8b 45 0c             	mov    0xc(%ebp),%eax
  104588:	89 44 24 04          	mov    %eax,0x4(%esp)
  10458c:	8b 45 08             	mov    0x8(%ebp),%eax
  10458f:	89 04 24             	mov    %eax,(%esp)
  104592:	e8 ff 00 00 00       	call   104696 <tlb_invalidate>
	}
}
  104597:	c9                   	leave  
  104598:	c3                   	ret    

00104599 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104599:	55                   	push   %ebp
  10459a:	89 e5                	mov    %esp,%ebp
  10459c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10459f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045a6:	00 
  1045a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b1:	89 04 24             	mov    %eax,(%esp)
  1045b4:	e8 ee fd ff ff       	call   1043a7 <get_pte>
  1045b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1045bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045c0:	74 19                	je     1045db <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1045d3:	89 04 24             	mov    %eax,(%esp)
  1045d6:	e8 5d ff ff ff       	call   104538 <page_remove_pte>
    }
}
  1045db:	c9                   	leave  
  1045dc:	c3                   	ret    

001045dd <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1045dd:	55                   	push   %ebp
  1045de:	89 e5                	mov    %esp,%ebp
  1045e0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1045e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1045ea:	00 
  1045eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1045f5:	89 04 24             	mov    %eax,(%esp)
  1045f8:	e8 aa fd ff ff       	call   1043a7 <get_pte>
  1045fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104600:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104604:	75 0a                	jne    104610 <page_insert+0x33>
        return -E_NO_MEM;
  104606:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10460b:	e9 84 00 00 00       	jmp    104694 <page_insert+0xb7>
    }
    page_ref_inc(page);
  104610:	8b 45 0c             	mov    0xc(%ebp),%eax
  104613:	89 04 24             	mov    %eax,(%esp)
  104616:	e8 5f f4 ff ff       	call   103a7a <page_ref_inc>
    if (*ptep & PTE_P) {
  10461b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10461e:	8b 00                	mov    (%eax),%eax
  104620:	83 e0 01             	and    $0x1,%eax
  104623:	85 c0                	test   %eax,%eax
  104625:	74 3e                	je     104665 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10462a:	8b 00                	mov    (%eax),%eax
  10462c:	89 04 24             	mov    %eax,(%esp)
  10462f:	e8 f1 f3 ff ff       	call   103a25 <pte2page>
  104634:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10463a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10463d:	75 0d                	jne    10464c <page_insert+0x6f>
            page_ref_dec(page);
  10463f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104642:	89 04 24             	mov    %eax,(%esp)
  104645:	e8 47 f4 ff ff       	call   103a91 <page_ref_dec>
  10464a:	eb 19                	jmp    104665 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10464c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10464f:	89 44 24 08          	mov    %eax,0x8(%esp)
  104653:	8b 45 10             	mov    0x10(%ebp),%eax
  104656:	89 44 24 04          	mov    %eax,0x4(%esp)
  10465a:	8b 45 08             	mov    0x8(%ebp),%eax
  10465d:	89 04 24             	mov    %eax,(%esp)
  104660:	e8 d3 fe ff ff       	call   104538 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104665:	8b 45 0c             	mov    0xc(%ebp),%eax
  104668:	89 04 24             	mov    %eax,(%esp)
  10466b:	e8 fc f2 ff ff       	call   10396c <page2pa>
  104670:	0b 45 14             	or     0x14(%ebp),%eax
  104673:	83 c8 01             	or     $0x1,%eax
  104676:	89 c2                	mov    %eax,%edx
  104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10467b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10467d:	8b 45 10             	mov    0x10(%ebp),%eax
  104680:	89 44 24 04          	mov    %eax,0x4(%esp)
  104684:	8b 45 08             	mov    0x8(%ebp),%eax
  104687:	89 04 24             	mov    %eax,(%esp)
  10468a:	e8 07 00 00 00       	call   104696 <tlb_invalidate>
    return 0;
  10468f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104694:	c9                   	leave  
  104695:	c3                   	ret    

00104696 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104696:	55                   	push   %ebp
  104697:	89 e5                	mov    %esp,%ebp
  104699:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10469c:	0f 20 d8             	mov    %cr3,%eax
  10469f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1046a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1046a5:	89 c2                	mov    %eax,%edx
  1046a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1046ad:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1046b4:	77 23                	ja     1046d9 <tlb_invalidate+0x43>
  1046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046bd:	c7 44 24 08 80 6a 10 	movl   $0x106a80,0x8(%esp)
  1046c4:	00 
  1046c5:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  1046cc:	00 
  1046cd:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  1046d4:	e8 ed c5 ff ff       	call   100cc6 <__panic>
  1046d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046dc:	05 00 00 00 40       	add    $0x40000000,%eax
  1046e1:	39 c2                	cmp    %eax,%edx
  1046e3:	75 0c                	jne    1046f1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1046e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1046eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046ee:	0f 01 38             	invlpg (%eax)
    }
}
  1046f1:	c9                   	leave  
  1046f2:	c3                   	ret    

001046f3 <check_alloc_page>:

static void
check_alloc_page(void) {
  1046f3:	55                   	push   %ebp
  1046f4:	89 e5                	mov    %esp,%ebp
  1046f6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1046f9:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1046fe:	8b 40 18             	mov    0x18(%eax),%eax
  104701:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104703:	c7 04 24 04 6b 10 00 	movl   $0x106b04,(%esp)
  10470a:	e8 2d bc ff ff       	call   10033c <cprintf>
}
  10470f:	c9                   	leave  
  104710:	c3                   	ret    

00104711 <check_pgdir>:

static void
check_pgdir(void) {
  104711:	55                   	push   %ebp
  104712:	89 e5                	mov    %esp,%ebp
  104714:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104717:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10471c:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104721:	76 24                	jbe    104747 <check_pgdir+0x36>
  104723:	c7 44 24 0c 23 6b 10 	movl   $0x106b23,0xc(%esp)
  10472a:	00 
  10472b:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104732:	00 
  104733:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  10473a:	00 
  10473b:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104742:	e8 7f c5 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104747:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10474c:	85 c0                	test   %eax,%eax
  10474e:	74 0e                	je     10475e <check_pgdir+0x4d>
  104750:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104755:	25 ff 0f 00 00       	and    $0xfff,%eax
  10475a:	85 c0                	test   %eax,%eax
  10475c:	74 24                	je     104782 <check_pgdir+0x71>
  10475e:	c7 44 24 0c 40 6b 10 	movl   $0x106b40,0xc(%esp)
  104765:	00 
  104766:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  10476d:	00 
  10476e:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104775:	00 
  104776:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10477d:	e8 44 c5 ff ff       	call   100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104782:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104787:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10478e:	00 
  10478f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104796:	00 
  104797:	89 04 24             	mov    %eax,(%esp)
  10479a:	e8 40 fd ff ff       	call   1044df <get_page>
  10479f:	85 c0                	test   %eax,%eax
  1047a1:	74 24                	je     1047c7 <check_pgdir+0xb6>
  1047a3:	c7 44 24 0c 78 6b 10 	movl   $0x106b78,0xc(%esp)
  1047aa:	00 
  1047ab:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  1047b2:	00 
  1047b3:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  1047ba:	00 
  1047bb:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  1047c2:	e8 ff c4 ff ff       	call   100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1047c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1047ce:	e8 95 f4 ff ff       	call   103c68 <alloc_pages>
  1047d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1047d6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1047e2:	00 
  1047e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047ea:	00 
  1047eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1047f2:	89 04 24             	mov    %eax,(%esp)
  1047f5:	e8 e3 fd ff ff       	call   1045dd <page_insert>
  1047fa:	85 c0                	test   %eax,%eax
  1047fc:	74 24                	je     104822 <check_pgdir+0x111>
  1047fe:	c7 44 24 0c a0 6b 10 	movl   $0x106ba0,0xc(%esp)
  104805:	00 
  104806:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  10480d:	00 
  10480e:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104815:	00 
  104816:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10481d:	e8 a4 c4 ff ff       	call   100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104822:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104827:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10482e:	00 
  10482f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104836:	00 
  104837:	89 04 24             	mov    %eax,(%esp)
  10483a:	e8 68 fb ff ff       	call   1043a7 <get_pte>
  10483f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104842:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104846:	75 24                	jne    10486c <check_pgdir+0x15b>
  104848:	c7 44 24 0c cc 6b 10 	movl   $0x106bcc,0xc(%esp)
  10484f:	00 
  104850:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104857:	00 
  104858:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  10485f:	00 
  104860:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104867:	e8 5a c4 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  10486c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10486f:	8b 00                	mov    (%eax),%eax
  104871:	89 04 24             	mov    %eax,(%esp)
  104874:	e8 09 f1 ff ff       	call   103982 <pa2page>
  104879:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10487c:	74 24                	je     1048a2 <check_pgdir+0x191>
  10487e:	c7 44 24 0c f9 6b 10 	movl   $0x106bf9,0xc(%esp)
  104885:	00 
  104886:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  10488d:	00 
  10488e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104895:	00 
  104896:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10489d:	e8 24 c4 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 1);
  1048a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048a5:	89 04 24             	mov    %eax,(%esp)
  1048a8:	e8 b6 f1 ff ff       	call   103a63 <page_ref>
  1048ad:	83 f8 01             	cmp    $0x1,%eax
  1048b0:	74 24                	je     1048d6 <check_pgdir+0x1c5>
  1048b2:	c7 44 24 0c 0e 6c 10 	movl   $0x106c0e,0xc(%esp)
  1048b9:	00 
  1048ba:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  1048c1:	00 
  1048c2:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  1048c9:	00 
  1048ca:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  1048d1:	e8 f0 c3 ff ff       	call   100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1048d6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048db:	8b 00                	mov    (%eax),%eax
  1048dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1048e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1048e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048e8:	c1 e8 0c             	shr    $0xc,%eax
  1048eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1048ee:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048f3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1048f6:	72 23                	jb     10491b <check_pgdir+0x20a>
  1048f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1048ff:	c7 44 24 08 dc 69 10 	movl   $0x1069dc,0x8(%esp)
  104906:	00 
  104907:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  10490e:	00 
  10490f:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104916:	e8 ab c3 ff ff       	call   100cc6 <__panic>
  10491b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10491e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104923:	83 c0 04             	add    $0x4,%eax
  104926:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104929:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10492e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104935:	00 
  104936:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10493d:	00 
  10493e:	89 04 24             	mov    %eax,(%esp)
  104941:	e8 61 fa ff ff       	call   1043a7 <get_pte>
  104946:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104949:	74 24                	je     10496f <check_pgdir+0x25e>
  10494b:	c7 44 24 0c 20 6c 10 	movl   $0x106c20,0xc(%esp)
  104952:	00 
  104953:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  10495a:	00 
  10495b:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104962:	00 
  104963:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10496a:	e8 57 c3 ff ff       	call   100cc6 <__panic>

    p2 = alloc_page();
  10496f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104976:	e8 ed f2 ff ff       	call   103c68 <alloc_pages>
  10497b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10497e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104983:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10498a:	00 
  10498b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104992:	00 
  104993:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104996:	89 54 24 04          	mov    %edx,0x4(%esp)
  10499a:	89 04 24             	mov    %eax,(%esp)
  10499d:	e8 3b fc ff ff       	call   1045dd <page_insert>
  1049a2:	85 c0                	test   %eax,%eax
  1049a4:	74 24                	je     1049ca <check_pgdir+0x2b9>
  1049a6:	c7 44 24 0c 48 6c 10 	movl   $0x106c48,0xc(%esp)
  1049ad:	00 
  1049ae:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  1049b5:	00 
  1049b6:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  1049bd:	00 
  1049be:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  1049c5:	e8 fc c2 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1049ca:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049d6:	00 
  1049d7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049de:	00 
  1049df:	89 04 24             	mov    %eax,(%esp)
  1049e2:	e8 c0 f9 ff ff       	call   1043a7 <get_pte>
  1049e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1049ee:	75 24                	jne    104a14 <check_pgdir+0x303>
  1049f0:	c7 44 24 0c 80 6c 10 	movl   $0x106c80,0xc(%esp)
  1049f7:	00 
  1049f8:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  1049ff:	00 
  104a00:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104a07:	00 
  104a08:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104a0f:	e8 b2 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_U);
  104a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a17:	8b 00                	mov    (%eax),%eax
  104a19:	83 e0 04             	and    $0x4,%eax
  104a1c:	85 c0                	test   %eax,%eax
  104a1e:	75 24                	jne    104a44 <check_pgdir+0x333>
  104a20:	c7 44 24 0c b0 6c 10 	movl   $0x106cb0,0xc(%esp)
  104a27:	00 
  104a28:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104a2f:	00 
  104a30:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104a37:	00 
  104a38:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104a3f:	e8 82 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_W);
  104a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a47:	8b 00                	mov    (%eax),%eax
  104a49:	83 e0 02             	and    $0x2,%eax
  104a4c:	85 c0                	test   %eax,%eax
  104a4e:	75 24                	jne    104a74 <check_pgdir+0x363>
  104a50:	c7 44 24 0c be 6c 10 	movl   $0x106cbe,0xc(%esp)
  104a57:	00 
  104a58:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104a5f:	00 
  104a60:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104a67:	00 
  104a68:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104a6f:	e8 52 c2 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104a74:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a79:	8b 00                	mov    (%eax),%eax
  104a7b:	83 e0 04             	and    $0x4,%eax
  104a7e:	85 c0                	test   %eax,%eax
  104a80:	75 24                	jne    104aa6 <check_pgdir+0x395>
  104a82:	c7 44 24 0c cc 6c 10 	movl   $0x106ccc,0xc(%esp)
  104a89:	00 
  104a8a:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104a91:	00 
  104a92:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104a99:	00 
  104a9a:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104aa1:	e8 20 c2 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 1);
  104aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104aa9:	89 04 24             	mov    %eax,(%esp)
  104aac:	e8 b2 ef ff ff       	call   103a63 <page_ref>
  104ab1:	83 f8 01             	cmp    $0x1,%eax
  104ab4:	74 24                	je     104ada <check_pgdir+0x3c9>
  104ab6:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  104abd:	00 
  104abe:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104ac5:	00 
  104ac6:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104acd:	00 
  104ace:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104ad5:	e8 ec c1 ff ff       	call   100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104ada:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104adf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104ae6:	00 
  104ae7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104aee:	00 
  104aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104af2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104af6:	89 04 24             	mov    %eax,(%esp)
  104af9:	e8 df fa ff ff       	call   1045dd <page_insert>
  104afe:	85 c0                	test   %eax,%eax
  104b00:	74 24                	je     104b26 <check_pgdir+0x415>
  104b02:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  104b09:	00 
  104b0a:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104b11:	00 
  104b12:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104b19:	00 
  104b1a:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104b21:	e8 a0 c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 2);
  104b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b29:	89 04 24             	mov    %eax,(%esp)
  104b2c:	e8 32 ef ff ff       	call   103a63 <page_ref>
  104b31:	83 f8 02             	cmp    $0x2,%eax
  104b34:	74 24                	je     104b5a <check_pgdir+0x449>
  104b36:	c7 44 24 0c 20 6d 10 	movl   $0x106d20,0xc(%esp)
  104b3d:	00 
  104b3e:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104b45:	00 
  104b46:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104b4d:	00 
  104b4e:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104b55:	e8 6c c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b5d:	89 04 24             	mov    %eax,(%esp)
  104b60:	e8 fe ee ff ff       	call   103a63 <page_ref>
  104b65:	85 c0                	test   %eax,%eax
  104b67:	74 24                	je     104b8d <check_pgdir+0x47c>
  104b69:	c7 44 24 0c 32 6d 10 	movl   $0x106d32,0xc(%esp)
  104b70:	00 
  104b71:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104b78:	00 
  104b79:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104b80:	00 
  104b81:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104b88:	e8 39 c1 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b8d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b92:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b99:	00 
  104b9a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ba1:	00 
  104ba2:	89 04 24             	mov    %eax,(%esp)
  104ba5:	e8 fd f7 ff ff       	call   1043a7 <get_pte>
  104baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104bad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104bb1:	75 24                	jne    104bd7 <check_pgdir+0x4c6>
  104bb3:	c7 44 24 0c 80 6c 10 	movl   $0x106c80,0xc(%esp)
  104bba:	00 
  104bbb:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104bc2:	00 
  104bc3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104bca:	00 
  104bcb:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104bd2:	e8 ef c0 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  104bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bda:	8b 00                	mov    (%eax),%eax
  104bdc:	89 04 24             	mov    %eax,(%esp)
  104bdf:	e8 9e ed ff ff       	call   103982 <pa2page>
  104be4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104be7:	74 24                	je     104c0d <check_pgdir+0x4fc>
  104be9:	c7 44 24 0c f9 6b 10 	movl   $0x106bf9,0xc(%esp)
  104bf0:	00 
  104bf1:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104bf8:	00 
  104bf9:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104c00:	00 
  104c01:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104c08:	e8 b9 c0 ff ff       	call   100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c10:	8b 00                	mov    (%eax),%eax
  104c12:	83 e0 04             	and    $0x4,%eax
  104c15:	85 c0                	test   %eax,%eax
  104c17:	74 24                	je     104c3d <check_pgdir+0x52c>
  104c19:	c7 44 24 0c 44 6d 10 	movl   $0x106d44,0xc(%esp)
  104c20:	00 
  104c21:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104c28:	00 
  104c29:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104c30:	00 
  104c31:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104c38:	e8 89 c0 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104c3d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c49:	00 
  104c4a:	89 04 24             	mov    %eax,(%esp)
  104c4d:	e8 47 f9 ff ff       	call   104599 <page_remove>
    assert(page_ref(p1) == 1);
  104c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c55:	89 04 24             	mov    %eax,(%esp)
  104c58:	e8 06 ee ff ff       	call   103a63 <page_ref>
  104c5d:	83 f8 01             	cmp    $0x1,%eax
  104c60:	74 24                	je     104c86 <check_pgdir+0x575>
  104c62:	c7 44 24 0c 0e 6c 10 	movl   $0x106c0e,0xc(%esp)
  104c69:	00 
  104c6a:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104c71:	00 
  104c72:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104c79:	00 
  104c7a:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104c81:	e8 40 c0 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c89:	89 04 24             	mov    %eax,(%esp)
  104c8c:	e8 d2 ed ff ff       	call   103a63 <page_ref>
  104c91:	85 c0                	test   %eax,%eax
  104c93:	74 24                	je     104cb9 <check_pgdir+0x5a8>
  104c95:	c7 44 24 0c 32 6d 10 	movl   $0x106d32,0xc(%esp)
  104c9c:	00 
  104c9d:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104ca4:	00 
  104ca5:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104cac:	00 
  104cad:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104cb4:	e8 0d c0 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104cb9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cbe:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cc5:	00 
  104cc6:	89 04 24             	mov    %eax,(%esp)
  104cc9:	e8 cb f8 ff ff       	call   104599 <page_remove>
    assert(page_ref(p1) == 0);
  104cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cd1:	89 04 24             	mov    %eax,(%esp)
  104cd4:	e8 8a ed ff ff       	call   103a63 <page_ref>
  104cd9:	85 c0                	test   %eax,%eax
  104cdb:	74 24                	je     104d01 <check_pgdir+0x5f0>
  104cdd:	c7 44 24 0c 59 6d 10 	movl   $0x106d59,0xc(%esp)
  104ce4:	00 
  104ce5:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104cec:	00 
  104ced:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104cf4:	00 
  104cf5:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104cfc:	e8 c5 bf ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d04:	89 04 24             	mov    %eax,(%esp)
  104d07:	e8 57 ed ff ff       	call   103a63 <page_ref>
  104d0c:	85 c0                	test   %eax,%eax
  104d0e:	74 24                	je     104d34 <check_pgdir+0x623>
  104d10:	c7 44 24 0c 32 6d 10 	movl   $0x106d32,0xc(%esp)
  104d17:	00 
  104d18:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104d1f:	00 
  104d20:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104d27:	00 
  104d28:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104d2f:	e8 92 bf ff ff       	call   100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104d34:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d39:	8b 00                	mov    (%eax),%eax
  104d3b:	89 04 24             	mov    %eax,(%esp)
  104d3e:	e8 3f ec ff ff       	call   103982 <pa2page>
  104d43:	89 04 24             	mov    %eax,(%esp)
  104d46:	e8 18 ed ff ff       	call   103a63 <page_ref>
  104d4b:	83 f8 01             	cmp    $0x1,%eax
  104d4e:	74 24                	je     104d74 <check_pgdir+0x663>
  104d50:	c7 44 24 0c 6c 6d 10 	movl   $0x106d6c,0xc(%esp)
  104d57:	00 
  104d58:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104d5f:	00 
  104d60:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104d67:	00 
  104d68:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104d6f:	e8 52 bf ff ff       	call   100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104d74:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d79:	8b 00                	mov    (%eax),%eax
  104d7b:	89 04 24             	mov    %eax,(%esp)
  104d7e:	e8 ff eb ff ff       	call   103982 <pa2page>
  104d83:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d8a:	00 
  104d8b:	89 04 24             	mov    %eax,(%esp)
  104d8e:	e8 0d ef ff ff       	call   103ca0 <free_pages>
    boot_pgdir[0] = 0;
  104d93:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104d9e:	c7 04 24 92 6d 10 00 	movl   $0x106d92,(%esp)
  104da5:	e8 92 b5 ff ff       	call   10033c <cprintf>
}
  104daa:	c9                   	leave  
  104dab:	c3                   	ret    

00104dac <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104dac:	55                   	push   %ebp
  104dad:	89 e5                	mov    %esp,%ebp
  104daf:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104db2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104db9:	e9 ca 00 00 00       	jmp    104e88 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dc7:	c1 e8 0c             	shr    $0xc,%eax
  104dca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104dcd:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104dd2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104dd5:	72 23                	jb     104dfa <check_boot_pgdir+0x4e>
  104dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104dde:	c7 44 24 08 dc 69 10 	movl   $0x1069dc,0x8(%esp)
  104de5:	00 
  104de6:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104ded:	00 
  104dee:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104df5:	e8 cc be ff ff       	call   100cc6 <__panic>
  104dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dfd:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104e02:	89 c2                	mov    %eax,%edx
  104e04:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e09:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e10:	00 
  104e11:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e15:	89 04 24             	mov    %eax,(%esp)
  104e18:	e8 8a f5 ff ff       	call   1043a7 <get_pte>
  104e1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104e20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e24:	75 24                	jne    104e4a <check_boot_pgdir+0x9e>
  104e26:	c7 44 24 0c ac 6d 10 	movl   $0x106dac,0xc(%esp)
  104e2d:	00 
  104e2e:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104e35:	00 
  104e36:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104e3d:	00 
  104e3e:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104e45:	e8 7c be ff ff       	call   100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e4d:	8b 00                	mov    (%eax),%eax
  104e4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e54:	89 c2                	mov    %eax,%edx
  104e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e59:	39 c2                	cmp    %eax,%edx
  104e5b:	74 24                	je     104e81 <check_boot_pgdir+0xd5>
  104e5d:	c7 44 24 0c e9 6d 10 	movl   $0x106de9,0xc(%esp)
  104e64:	00 
  104e65:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104e6c:	00 
  104e6d:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104e74:	00 
  104e75:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104e7c:	e8 45 be ff ff       	call   100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e81:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e8b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e90:	39 c2                	cmp    %eax,%edx
  104e92:	0f 82 26 ff ff ff    	jb     104dbe <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104e98:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e9d:	05 ac 0f 00 00       	add    $0xfac,%eax
  104ea2:	8b 00                	mov    (%eax),%eax
  104ea4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ea9:	89 c2                	mov    %eax,%edx
  104eab:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104eb3:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104eba:	77 23                	ja     104edf <check_boot_pgdir+0x133>
  104ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ec3:	c7 44 24 08 80 6a 10 	movl   $0x106a80,0x8(%esp)
  104eca:	00 
  104ecb:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104ed2:	00 
  104ed3:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104eda:	e8 e7 bd ff ff       	call   100cc6 <__panic>
  104edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ee2:	05 00 00 00 40       	add    $0x40000000,%eax
  104ee7:	39 c2                	cmp    %eax,%edx
  104ee9:	74 24                	je     104f0f <check_boot_pgdir+0x163>
  104eeb:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104ef2:	00 
  104ef3:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104efa:	00 
  104efb:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104f02:	00 
  104f03:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104f0a:	e8 b7 bd ff ff       	call   100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
  104f0f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f14:	8b 00                	mov    (%eax),%eax
  104f16:	85 c0                	test   %eax,%eax
  104f18:	74 24                	je     104f3e <check_boot_pgdir+0x192>
  104f1a:	c7 44 24 0c 34 6e 10 	movl   $0x106e34,0xc(%esp)
  104f21:	00 
  104f22:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104f29:	00 
  104f2a:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104f31:	00 
  104f32:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104f39:	e8 88 bd ff ff       	call   100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
  104f3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f45:	e8 1e ed ff ff       	call   103c68 <alloc_pages>
  104f4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104f4d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f52:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104f59:	00 
  104f5a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104f61:	00 
  104f62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f65:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f69:	89 04 24             	mov    %eax,(%esp)
  104f6c:	e8 6c f6 ff ff       	call   1045dd <page_insert>
  104f71:	85 c0                	test   %eax,%eax
  104f73:	74 24                	je     104f99 <check_boot_pgdir+0x1ed>
  104f75:	c7 44 24 0c 48 6e 10 	movl   $0x106e48,0xc(%esp)
  104f7c:	00 
  104f7d:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104f84:	00 
  104f85:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104f8c:	00 
  104f8d:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104f94:	e8 2d bd ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 1);
  104f99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f9c:	89 04 24             	mov    %eax,(%esp)
  104f9f:	e8 bf ea ff ff       	call   103a63 <page_ref>
  104fa4:	83 f8 01             	cmp    $0x1,%eax
  104fa7:	74 24                	je     104fcd <check_boot_pgdir+0x221>
  104fa9:	c7 44 24 0c 76 6e 10 	movl   $0x106e76,0xc(%esp)
  104fb0:	00 
  104fb1:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  104fb8:	00 
  104fb9:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  104fc0:	00 
  104fc1:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  104fc8:	e8 f9 bc ff ff       	call   100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104fcd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fd2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104fd9:	00 
  104fda:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104fe1:	00 
  104fe2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fe5:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fe9:	89 04 24             	mov    %eax,(%esp)
  104fec:	e8 ec f5 ff ff       	call   1045dd <page_insert>
  104ff1:	85 c0                	test   %eax,%eax
  104ff3:	74 24                	je     105019 <check_boot_pgdir+0x26d>
  104ff5:	c7 44 24 0c 88 6e 10 	movl   $0x106e88,0xc(%esp)
  104ffc:	00 
  104ffd:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  105004:	00 
  105005:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  10500c:	00 
  10500d:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  105014:	e8 ad bc ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 2);
  105019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10501c:	89 04 24             	mov    %eax,(%esp)
  10501f:	e8 3f ea ff ff       	call   103a63 <page_ref>
  105024:	83 f8 02             	cmp    $0x2,%eax
  105027:	74 24                	je     10504d <check_boot_pgdir+0x2a1>
  105029:	c7 44 24 0c bf 6e 10 	movl   $0x106ebf,0xc(%esp)
  105030:	00 
  105031:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  105038:	00 
  105039:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  105040:	00 
  105041:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  105048:	e8 79 bc ff ff       	call   100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
  10504d:	c7 45 dc d0 6e 10 00 	movl   $0x106ed0,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105054:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105057:	89 44 24 04          	mov    %eax,0x4(%esp)
  10505b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105062:	e8 1e 0a 00 00       	call   105a85 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105067:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10506e:	00 
  10506f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105076:	e8 83 0a 00 00       	call   105afe <strcmp>
  10507b:	85 c0                	test   %eax,%eax
  10507d:	74 24                	je     1050a3 <check_boot_pgdir+0x2f7>
  10507f:	c7 44 24 0c e8 6e 10 	movl   $0x106ee8,0xc(%esp)
  105086:	00 
  105087:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  10508e:	00 
  10508f:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105096:	00 
  105097:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10509e:	e8 23 bc ff ff       	call   100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1050a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050a6:	89 04 24             	mov    %eax,(%esp)
  1050a9:	e8 23 e9 ff ff       	call   1039d1 <page2kva>
  1050ae:	05 00 01 00 00       	add    $0x100,%eax
  1050b3:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1050b6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050bd:	e8 6b 09 00 00       	call   105a2d <strlen>
  1050c2:	85 c0                	test   %eax,%eax
  1050c4:	74 24                	je     1050ea <check_boot_pgdir+0x33e>
  1050c6:	c7 44 24 0c 20 6f 10 	movl   $0x106f20,0xc(%esp)
  1050cd:	00 
  1050ce:	c7 44 24 08 c9 6a 10 	movl   $0x106ac9,0x8(%esp)
  1050d5:	00 
  1050d6:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  1050dd:	00 
  1050de:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  1050e5:	e8 dc bb ff ff       	call   100cc6 <__panic>

    free_page(p);
  1050ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050f1:	00 
  1050f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050f5:	89 04 24             	mov    %eax,(%esp)
  1050f8:	e8 a3 eb ff ff       	call   103ca0 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1050fd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105102:	8b 00                	mov    (%eax),%eax
  105104:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105109:	89 04 24             	mov    %eax,(%esp)
  10510c:	e8 71 e8 ff ff       	call   103982 <pa2page>
  105111:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105118:	00 
  105119:	89 04 24             	mov    %eax,(%esp)
  10511c:	e8 7f eb ff ff       	call   103ca0 <free_pages>
    boot_pgdir[0] = 0;
  105121:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10512c:	c7 04 24 44 6f 10 00 	movl   $0x106f44,(%esp)
  105133:	e8 04 b2 ff ff       	call   10033c <cprintf>
}
  105138:	c9                   	leave  
  105139:	c3                   	ret    

0010513a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10513a:	55                   	push   %ebp
  10513b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10513d:	8b 45 08             	mov    0x8(%ebp),%eax
  105140:	83 e0 04             	and    $0x4,%eax
  105143:	85 c0                	test   %eax,%eax
  105145:	74 07                	je     10514e <perm2str+0x14>
  105147:	b8 75 00 00 00       	mov    $0x75,%eax
  10514c:	eb 05                	jmp    105153 <perm2str+0x19>
  10514e:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105153:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105158:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10515f:	8b 45 08             	mov    0x8(%ebp),%eax
  105162:	83 e0 02             	and    $0x2,%eax
  105165:	85 c0                	test   %eax,%eax
  105167:	74 07                	je     105170 <perm2str+0x36>
  105169:	b8 77 00 00 00       	mov    $0x77,%eax
  10516e:	eb 05                	jmp    105175 <perm2str+0x3b>
  105170:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105175:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  10517a:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105181:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105186:	5d                   	pop    %ebp
  105187:	c3                   	ret    

00105188 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105188:	55                   	push   %ebp
  105189:	89 e5                	mov    %esp,%ebp
  10518b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10518e:	8b 45 10             	mov    0x10(%ebp),%eax
  105191:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105194:	72 0a                	jb     1051a0 <get_pgtable_items+0x18>
        return 0;
  105196:	b8 00 00 00 00       	mov    $0x0,%eax
  10519b:	e9 9c 00 00 00       	jmp    10523c <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1051a0:	eb 04                	jmp    1051a6 <get_pgtable_items+0x1e>
        start ++;
  1051a2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1051a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1051a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051ac:	73 18                	jae    1051c6 <get_pgtable_items+0x3e>
  1051ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1051b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1051b8:	8b 45 14             	mov    0x14(%ebp),%eax
  1051bb:	01 d0                	add    %edx,%eax
  1051bd:	8b 00                	mov    (%eax),%eax
  1051bf:	83 e0 01             	and    $0x1,%eax
  1051c2:	85 c0                	test   %eax,%eax
  1051c4:	74 dc                	je     1051a2 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1051c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1051c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051cc:	73 69                	jae    105237 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1051ce:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1051d2:	74 08                	je     1051dc <get_pgtable_items+0x54>
            *left_store = start;
  1051d4:	8b 45 18             	mov    0x18(%ebp),%eax
  1051d7:	8b 55 10             	mov    0x10(%ebp),%edx
  1051da:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1051dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1051df:	8d 50 01             	lea    0x1(%eax),%edx
  1051e2:	89 55 10             	mov    %edx,0x10(%ebp)
  1051e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1051ec:	8b 45 14             	mov    0x14(%ebp),%eax
  1051ef:	01 d0                	add    %edx,%eax
  1051f1:	8b 00                	mov    (%eax),%eax
  1051f3:	83 e0 07             	and    $0x7,%eax
  1051f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1051f9:	eb 04                	jmp    1051ff <get_pgtable_items+0x77>
            start ++;
  1051fb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1051ff:	8b 45 10             	mov    0x10(%ebp),%eax
  105202:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105205:	73 1d                	jae    105224 <get_pgtable_items+0x9c>
  105207:	8b 45 10             	mov    0x10(%ebp),%eax
  10520a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105211:	8b 45 14             	mov    0x14(%ebp),%eax
  105214:	01 d0                	add    %edx,%eax
  105216:	8b 00                	mov    (%eax),%eax
  105218:	83 e0 07             	and    $0x7,%eax
  10521b:	89 c2                	mov    %eax,%edx
  10521d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105220:	39 c2                	cmp    %eax,%edx
  105222:	74 d7                	je     1051fb <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105224:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105228:	74 08                	je     105232 <get_pgtable_items+0xaa>
            *right_store = start;
  10522a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10522d:	8b 55 10             	mov    0x10(%ebp),%edx
  105230:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105235:	eb 05                	jmp    10523c <get_pgtable_items+0xb4>
    }
    return 0;
  105237:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10523c:	c9                   	leave  
  10523d:	c3                   	ret    

0010523e <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10523e:	55                   	push   %ebp
  10523f:	89 e5                	mov    %esp,%ebp
  105241:	57                   	push   %edi
  105242:	56                   	push   %esi
  105243:	53                   	push   %ebx
  105244:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105247:	c7 04 24 64 6f 10 00 	movl   $0x106f64,(%esp)
  10524e:	e8 e9 b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105253:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10525a:	e9 fa 00 00 00       	jmp    105359 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10525f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105262:	89 04 24             	mov    %eax,(%esp)
  105265:	e8 d0 fe ff ff       	call   10513a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10526a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10526d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105270:	29 d1                	sub    %edx,%ecx
  105272:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105274:	89 d6                	mov    %edx,%esi
  105276:	c1 e6 16             	shl    $0x16,%esi
  105279:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10527c:	89 d3                	mov    %edx,%ebx
  10527e:	c1 e3 16             	shl    $0x16,%ebx
  105281:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105284:	89 d1                	mov    %edx,%ecx
  105286:	c1 e1 16             	shl    $0x16,%ecx
  105289:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10528c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10528f:	29 d7                	sub    %edx,%edi
  105291:	89 fa                	mov    %edi,%edx
  105293:	89 44 24 14          	mov    %eax,0x14(%esp)
  105297:	89 74 24 10          	mov    %esi,0x10(%esp)
  10529b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10529f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1052a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052a7:	c7 04 24 95 6f 10 00 	movl   $0x106f95,(%esp)
  1052ae:	e8 89 b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1052b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052b6:	c1 e0 0a             	shl    $0xa,%eax
  1052b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1052bc:	eb 54                	jmp    105312 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1052be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052c1:	89 04 24             	mov    %eax,(%esp)
  1052c4:	e8 71 fe ff ff       	call   10513a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1052c9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1052cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052cf:	29 d1                	sub    %edx,%ecx
  1052d1:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1052d3:	89 d6                	mov    %edx,%esi
  1052d5:	c1 e6 0c             	shl    $0xc,%esi
  1052d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1052db:	89 d3                	mov    %edx,%ebx
  1052dd:	c1 e3 0c             	shl    $0xc,%ebx
  1052e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052e3:	c1 e2 0c             	shl    $0xc,%edx
  1052e6:	89 d1                	mov    %edx,%ecx
  1052e8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1052eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052ee:	29 d7                	sub    %edx,%edi
  1052f0:	89 fa                	mov    %edi,%edx
  1052f2:	89 44 24 14          	mov    %eax,0x14(%esp)
  1052f6:	89 74 24 10          	mov    %esi,0x10(%esp)
  1052fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1052fe:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105302:	89 54 24 04          	mov    %edx,0x4(%esp)
  105306:	c7 04 24 b4 6f 10 00 	movl   $0x106fb4,(%esp)
  10530d:	e8 2a b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105312:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105317:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10531a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10531d:	89 ce                	mov    %ecx,%esi
  10531f:	c1 e6 0a             	shl    $0xa,%esi
  105322:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105325:	89 cb                	mov    %ecx,%ebx
  105327:	c1 e3 0a             	shl    $0xa,%ebx
  10532a:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  10532d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105331:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105334:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105338:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10533c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105340:	89 74 24 04          	mov    %esi,0x4(%esp)
  105344:	89 1c 24             	mov    %ebx,(%esp)
  105347:	e8 3c fe ff ff       	call   105188 <get_pgtable_items>
  10534c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10534f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105353:	0f 85 65 ff ff ff    	jne    1052be <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105359:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10535e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105361:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105364:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105368:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10536b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10536f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105373:	89 44 24 08          	mov    %eax,0x8(%esp)
  105377:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10537e:	00 
  10537f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105386:	e8 fd fd ff ff       	call   105188 <get_pgtable_items>
  10538b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10538e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105392:	0f 85 c7 fe ff ff    	jne    10525f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105398:	c7 04 24 d8 6f 10 00 	movl   $0x106fd8,(%esp)
  10539f:	e8 98 af ff ff       	call   10033c <cprintf>
}
  1053a4:	83 c4 4c             	add    $0x4c,%esp
  1053a7:	5b                   	pop    %ebx
  1053a8:	5e                   	pop    %esi
  1053a9:	5f                   	pop    %edi
  1053aa:	5d                   	pop    %ebp
  1053ab:	c3                   	ret    

001053ac <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1053ac:	55                   	push   %ebp
  1053ad:	89 e5                	mov    %esp,%ebp
  1053af:	83 ec 58             	sub    $0x58,%esp
  1053b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1053b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1053b8:	8b 45 14             	mov    0x14(%ebp),%eax
  1053bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1053be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1053c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1053ca:	8b 45 18             	mov    0x18(%ebp),%eax
  1053cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1053d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1053d9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1053dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1053e6:	74 1c                	je     105404 <printnum+0x58>
  1053e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1053f0:	f7 75 e4             	divl   -0x1c(%ebp)
  1053f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1053f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053f9:	ba 00 00 00 00       	mov    $0x0,%edx
  1053fe:	f7 75 e4             	divl   -0x1c(%ebp)
  105401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105404:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10540a:	f7 75 e4             	divl   -0x1c(%ebp)
  10540d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105410:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105416:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105419:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10541c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10541f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105422:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105425:	8b 45 18             	mov    0x18(%ebp),%eax
  105428:	ba 00 00 00 00       	mov    $0x0,%edx
  10542d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105430:	77 56                	ja     105488 <printnum+0xdc>
  105432:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105435:	72 05                	jb     10543c <printnum+0x90>
  105437:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10543a:	77 4c                	ja     105488 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10543c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10543f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105442:	8b 45 20             	mov    0x20(%ebp),%eax
  105445:	89 44 24 18          	mov    %eax,0x18(%esp)
  105449:	89 54 24 14          	mov    %edx,0x14(%esp)
  10544d:	8b 45 18             	mov    0x18(%ebp),%eax
  105450:	89 44 24 10          	mov    %eax,0x10(%esp)
  105454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105457:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10545a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10545e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105462:	8b 45 0c             	mov    0xc(%ebp),%eax
  105465:	89 44 24 04          	mov    %eax,0x4(%esp)
  105469:	8b 45 08             	mov    0x8(%ebp),%eax
  10546c:	89 04 24             	mov    %eax,(%esp)
  10546f:	e8 38 ff ff ff       	call   1053ac <printnum>
  105474:	eb 1c                	jmp    105492 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105476:	8b 45 0c             	mov    0xc(%ebp),%eax
  105479:	89 44 24 04          	mov    %eax,0x4(%esp)
  10547d:	8b 45 20             	mov    0x20(%ebp),%eax
  105480:	89 04 24             	mov    %eax,(%esp)
  105483:	8b 45 08             	mov    0x8(%ebp),%eax
  105486:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105488:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10548c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105490:	7f e4                	jg     105476 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105492:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105495:	05 8c 70 10 00       	add    $0x10708c,%eax
  10549a:	0f b6 00             	movzbl (%eax),%eax
  10549d:	0f be c0             	movsbl %al,%eax
  1054a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1054a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1054a7:	89 04 24             	mov    %eax,(%esp)
  1054aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1054ad:	ff d0                	call   *%eax
}
  1054af:	c9                   	leave  
  1054b0:	c3                   	ret    

001054b1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1054b1:	55                   	push   %ebp
  1054b2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1054b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1054b8:	7e 14                	jle    1054ce <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1054ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1054bd:	8b 00                	mov    (%eax),%eax
  1054bf:	8d 48 08             	lea    0x8(%eax),%ecx
  1054c2:	8b 55 08             	mov    0x8(%ebp),%edx
  1054c5:	89 0a                	mov    %ecx,(%edx)
  1054c7:	8b 50 04             	mov    0x4(%eax),%edx
  1054ca:	8b 00                	mov    (%eax),%eax
  1054cc:	eb 30                	jmp    1054fe <getuint+0x4d>
    }
    else if (lflag) {
  1054ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1054d2:	74 16                	je     1054ea <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1054d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1054d7:	8b 00                	mov    (%eax),%eax
  1054d9:	8d 48 04             	lea    0x4(%eax),%ecx
  1054dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1054df:	89 0a                	mov    %ecx,(%edx)
  1054e1:	8b 00                	mov    (%eax),%eax
  1054e3:	ba 00 00 00 00       	mov    $0x0,%edx
  1054e8:	eb 14                	jmp    1054fe <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1054ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1054ed:	8b 00                	mov    (%eax),%eax
  1054ef:	8d 48 04             	lea    0x4(%eax),%ecx
  1054f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1054f5:	89 0a                	mov    %ecx,(%edx)
  1054f7:	8b 00                	mov    (%eax),%eax
  1054f9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1054fe:	5d                   	pop    %ebp
  1054ff:	c3                   	ret    

00105500 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105500:	55                   	push   %ebp
  105501:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105503:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105507:	7e 14                	jle    10551d <getint+0x1d>
        return va_arg(*ap, long long);
  105509:	8b 45 08             	mov    0x8(%ebp),%eax
  10550c:	8b 00                	mov    (%eax),%eax
  10550e:	8d 48 08             	lea    0x8(%eax),%ecx
  105511:	8b 55 08             	mov    0x8(%ebp),%edx
  105514:	89 0a                	mov    %ecx,(%edx)
  105516:	8b 50 04             	mov    0x4(%eax),%edx
  105519:	8b 00                	mov    (%eax),%eax
  10551b:	eb 28                	jmp    105545 <getint+0x45>
    }
    else if (lflag) {
  10551d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105521:	74 12                	je     105535 <getint+0x35>
        return va_arg(*ap, long);
  105523:	8b 45 08             	mov    0x8(%ebp),%eax
  105526:	8b 00                	mov    (%eax),%eax
  105528:	8d 48 04             	lea    0x4(%eax),%ecx
  10552b:	8b 55 08             	mov    0x8(%ebp),%edx
  10552e:	89 0a                	mov    %ecx,(%edx)
  105530:	8b 00                	mov    (%eax),%eax
  105532:	99                   	cltd   
  105533:	eb 10                	jmp    105545 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105535:	8b 45 08             	mov    0x8(%ebp),%eax
  105538:	8b 00                	mov    (%eax),%eax
  10553a:	8d 48 04             	lea    0x4(%eax),%ecx
  10553d:	8b 55 08             	mov    0x8(%ebp),%edx
  105540:	89 0a                	mov    %ecx,(%edx)
  105542:	8b 00                	mov    (%eax),%eax
  105544:	99                   	cltd   
    }
}
  105545:	5d                   	pop    %ebp
  105546:	c3                   	ret    

00105547 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105547:	55                   	push   %ebp
  105548:	89 e5                	mov    %esp,%ebp
  10554a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10554d:	8d 45 14             	lea    0x14(%ebp),%eax
  105550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105556:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10555a:	8b 45 10             	mov    0x10(%ebp),%eax
  10555d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105561:	8b 45 0c             	mov    0xc(%ebp),%eax
  105564:	89 44 24 04          	mov    %eax,0x4(%esp)
  105568:	8b 45 08             	mov    0x8(%ebp),%eax
  10556b:	89 04 24             	mov    %eax,(%esp)
  10556e:	e8 02 00 00 00       	call   105575 <vprintfmt>
    va_end(ap);
}
  105573:	c9                   	leave  
  105574:	c3                   	ret    

00105575 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105575:	55                   	push   %ebp
  105576:	89 e5                	mov    %esp,%ebp
  105578:	56                   	push   %esi
  105579:	53                   	push   %ebx
  10557a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10557d:	eb 18                	jmp    105597 <vprintfmt+0x22>
            if (ch == '\0') {
  10557f:	85 db                	test   %ebx,%ebx
  105581:	75 05                	jne    105588 <vprintfmt+0x13>
                return;
  105583:	e9 d1 03 00 00       	jmp    105959 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105588:	8b 45 0c             	mov    0xc(%ebp),%eax
  10558b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10558f:	89 1c 24             	mov    %ebx,(%esp)
  105592:	8b 45 08             	mov    0x8(%ebp),%eax
  105595:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105597:	8b 45 10             	mov    0x10(%ebp),%eax
  10559a:	8d 50 01             	lea    0x1(%eax),%edx
  10559d:	89 55 10             	mov    %edx,0x10(%ebp)
  1055a0:	0f b6 00             	movzbl (%eax),%eax
  1055a3:	0f b6 d8             	movzbl %al,%ebx
  1055a6:	83 fb 25             	cmp    $0x25,%ebx
  1055a9:	75 d4                	jne    10557f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1055ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1055af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1055b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1055bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1055c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1055c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1055c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1055cc:	8d 50 01             	lea    0x1(%eax),%edx
  1055cf:	89 55 10             	mov    %edx,0x10(%ebp)
  1055d2:	0f b6 00             	movzbl (%eax),%eax
  1055d5:	0f b6 d8             	movzbl %al,%ebx
  1055d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1055db:	83 f8 55             	cmp    $0x55,%eax
  1055de:	0f 87 44 03 00 00    	ja     105928 <vprintfmt+0x3b3>
  1055e4:	8b 04 85 b0 70 10 00 	mov    0x1070b0(,%eax,4),%eax
  1055eb:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1055ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1055f1:	eb d6                	jmp    1055c9 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1055f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1055f7:	eb d0                	jmp    1055c9 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1055f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105603:	89 d0                	mov    %edx,%eax
  105605:	c1 e0 02             	shl    $0x2,%eax
  105608:	01 d0                	add    %edx,%eax
  10560a:	01 c0                	add    %eax,%eax
  10560c:	01 d8                	add    %ebx,%eax
  10560e:	83 e8 30             	sub    $0x30,%eax
  105611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105614:	8b 45 10             	mov    0x10(%ebp),%eax
  105617:	0f b6 00             	movzbl (%eax),%eax
  10561a:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10561d:	83 fb 2f             	cmp    $0x2f,%ebx
  105620:	7e 0b                	jle    10562d <vprintfmt+0xb8>
  105622:	83 fb 39             	cmp    $0x39,%ebx
  105625:	7f 06                	jg     10562d <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105627:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10562b:	eb d3                	jmp    105600 <vprintfmt+0x8b>
            goto process_precision;
  10562d:	eb 33                	jmp    105662 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  10562f:	8b 45 14             	mov    0x14(%ebp),%eax
  105632:	8d 50 04             	lea    0x4(%eax),%edx
  105635:	89 55 14             	mov    %edx,0x14(%ebp)
  105638:	8b 00                	mov    (%eax),%eax
  10563a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10563d:	eb 23                	jmp    105662 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  10563f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105643:	79 0c                	jns    105651 <vprintfmt+0xdc>
                width = 0;
  105645:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10564c:	e9 78 ff ff ff       	jmp    1055c9 <vprintfmt+0x54>
  105651:	e9 73 ff ff ff       	jmp    1055c9 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105656:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10565d:	e9 67 ff ff ff       	jmp    1055c9 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105662:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105666:	79 12                	jns    10567a <vprintfmt+0x105>
                width = precision, precision = -1;
  105668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10566b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10566e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105675:	e9 4f ff ff ff       	jmp    1055c9 <vprintfmt+0x54>
  10567a:	e9 4a ff ff ff       	jmp    1055c9 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10567f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105683:	e9 41 ff ff ff       	jmp    1055c9 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105688:	8b 45 14             	mov    0x14(%ebp),%eax
  10568b:	8d 50 04             	lea    0x4(%eax),%edx
  10568e:	89 55 14             	mov    %edx,0x14(%ebp)
  105691:	8b 00                	mov    (%eax),%eax
  105693:	8b 55 0c             	mov    0xc(%ebp),%edx
  105696:	89 54 24 04          	mov    %edx,0x4(%esp)
  10569a:	89 04 24             	mov    %eax,(%esp)
  10569d:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a0:	ff d0                	call   *%eax
            break;
  1056a2:	e9 ac 02 00 00       	jmp    105953 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1056a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1056aa:	8d 50 04             	lea    0x4(%eax),%edx
  1056ad:	89 55 14             	mov    %edx,0x14(%ebp)
  1056b0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1056b2:	85 db                	test   %ebx,%ebx
  1056b4:	79 02                	jns    1056b8 <vprintfmt+0x143>
                err = -err;
  1056b6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1056b8:	83 fb 06             	cmp    $0x6,%ebx
  1056bb:	7f 0b                	jg     1056c8 <vprintfmt+0x153>
  1056bd:	8b 34 9d 70 70 10 00 	mov    0x107070(,%ebx,4),%esi
  1056c4:	85 f6                	test   %esi,%esi
  1056c6:	75 23                	jne    1056eb <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1056c8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1056cc:	c7 44 24 08 9d 70 10 	movl   $0x10709d,0x8(%esp)
  1056d3:	00 
  1056d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056db:	8b 45 08             	mov    0x8(%ebp),%eax
  1056de:	89 04 24             	mov    %eax,(%esp)
  1056e1:	e8 61 fe ff ff       	call   105547 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1056e6:	e9 68 02 00 00       	jmp    105953 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1056eb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1056ef:	c7 44 24 08 a6 70 10 	movl   $0x1070a6,0x8(%esp)
  1056f6:	00 
  1056f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105701:	89 04 24             	mov    %eax,(%esp)
  105704:	e8 3e fe ff ff       	call   105547 <printfmt>
            }
            break;
  105709:	e9 45 02 00 00       	jmp    105953 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10570e:	8b 45 14             	mov    0x14(%ebp),%eax
  105711:	8d 50 04             	lea    0x4(%eax),%edx
  105714:	89 55 14             	mov    %edx,0x14(%ebp)
  105717:	8b 30                	mov    (%eax),%esi
  105719:	85 f6                	test   %esi,%esi
  10571b:	75 05                	jne    105722 <vprintfmt+0x1ad>
                p = "(null)";
  10571d:	be a9 70 10 00       	mov    $0x1070a9,%esi
            }
            if (width > 0 && padc != '-') {
  105722:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105726:	7e 3e                	jle    105766 <vprintfmt+0x1f1>
  105728:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10572c:	74 38                	je     105766 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10572e:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105734:	89 44 24 04          	mov    %eax,0x4(%esp)
  105738:	89 34 24             	mov    %esi,(%esp)
  10573b:	e8 15 03 00 00       	call   105a55 <strnlen>
  105740:	29 c3                	sub    %eax,%ebx
  105742:	89 d8                	mov    %ebx,%eax
  105744:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105747:	eb 17                	jmp    105760 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105749:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10574d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105750:	89 54 24 04          	mov    %edx,0x4(%esp)
  105754:	89 04 24             	mov    %eax,(%esp)
  105757:	8b 45 08             	mov    0x8(%ebp),%eax
  10575a:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10575c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105760:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105764:	7f e3                	jg     105749 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105766:	eb 38                	jmp    1057a0 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105768:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10576c:	74 1f                	je     10578d <vprintfmt+0x218>
  10576e:	83 fb 1f             	cmp    $0x1f,%ebx
  105771:	7e 05                	jle    105778 <vprintfmt+0x203>
  105773:	83 fb 7e             	cmp    $0x7e,%ebx
  105776:	7e 15                	jle    10578d <vprintfmt+0x218>
                    putch('?', putdat);
  105778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10577b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10577f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105786:	8b 45 08             	mov    0x8(%ebp),%eax
  105789:	ff d0                	call   *%eax
  10578b:	eb 0f                	jmp    10579c <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10578d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105790:	89 44 24 04          	mov    %eax,0x4(%esp)
  105794:	89 1c 24             	mov    %ebx,(%esp)
  105797:	8b 45 08             	mov    0x8(%ebp),%eax
  10579a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10579c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057a0:	89 f0                	mov    %esi,%eax
  1057a2:	8d 70 01             	lea    0x1(%eax),%esi
  1057a5:	0f b6 00             	movzbl (%eax),%eax
  1057a8:	0f be d8             	movsbl %al,%ebx
  1057ab:	85 db                	test   %ebx,%ebx
  1057ad:	74 10                	je     1057bf <vprintfmt+0x24a>
  1057af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1057b3:	78 b3                	js     105768 <vprintfmt+0x1f3>
  1057b5:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1057b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1057bd:	79 a9                	jns    105768 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1057bf:	eb 17                	jmp    1057d8 <vprintfmt+0x263>
                putch(' ', putdat);
  1057c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1057cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d2:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1057d4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057dc:	7f e3                	jg     1057c1 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1057de:	e9 70 01 00 00       	jmp    105953 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1057e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ea:	8d 45 14             	lea    0x14(%ebp),%eax
  1057ed:	89 04 24             	mov    %eax,(%esp)
  1057f0:	e8 0b fd ff ff       	call   105500 <getint>
  1057f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1057fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105801:	85 d2                	test   %edx,%edx
  105803:	79 26                	jns    10582b <vprintfmt+0x2b6>
                putch('-', putdat);
  105805:	8b 45 0c             	mov    0xc(%ebp),%eax
  105808:	89 44 24 04          	mov    %eax,0x4(%esp)
  10580c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105813:	8b 45 08             	mov    0x8(%ebp),%eax
  105816:	ff d0                	call   *%eax
                num = -(long long)num;
  105818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10581b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10581e:	f7 d8                	neg    %eax
  105820:	83 d2 00             	adc    $0x0,%edx
  105823:	f7 da                	neg    %edx
  105825:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105828:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10582b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105832:	e9 a8 00 00 00       	jmp    1058df <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10583a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583e:	8d 45 14             	lea    0x14(%ebp),%eax
  105841:	89 04 24             	mov    %eax,(%esp)
  105844:	e8 68 fc ff ff       	call   1054b1 <getuint>
  105849:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10584c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10584f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105856:	e9 84 00 00 00       	jmp    1058df <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10585b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10585e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105862:	8d 45 14             	lea    0x14(%ebp),%eax
  105865:	89 04 24             	mov    %eax,(%esp)
  105868:	e8 44 fc ff ff       	call   1054b1 <getuint>
  10586d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105870:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105873:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10587a:	eb 63                	jmp    1058df <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  10587c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10587f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105883:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10588a:	8b 45 08             	mov    0x8(%ebp),%eax
  10588d:	ff d0                	call   *%eax
            putch('x', putdat);
  10588f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105892:	89 44 24 04          	mov    %eax,0x4(%esp)
  105896:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10589d:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a0:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1058a2:	8b 45 14             	mov    0x14(%ebp),%eax
  1058a5:	8d 50 04             	lea    0x4(%eax),%edx
  1058a8:	89 55 14             	mov    %edx,0x14(%ebp)
  1058ab:	8b 00                	mov    (%eax),%eax
  1058ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1058b7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1058be:	eb 1f                	jmp    1058df <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1058c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058c7:	8d 45 14             	lea    0x14(%ebp),%eax
  1058ca:	89 04 24             	mov    %eax,(%esp)
  1058cd:	e8 df fb ff ff       	call   1054b1 <getuint>
  1058d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1058d8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1058df:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1058e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058e6:	89 54 24 18          	mov    %edx,0x18(%esp)
  1058ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1058ed:	89 54 24 14          	mov    %edx,0x14(%esp)
  1058f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1058f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105903:	8b 45 0c             	mov    0xc(%ebp),%eax
  105906:	89 44 24 04          	mov    %eax,0x4(%esp)
  10590a:	8b 45 08             	mov    0x8(%ebp),%eax
  10590d:	89 04 24             	mov    %eax,(%esp)
  105910:	e8 97 fa ff ff       	call   1053ac <printnum>
            break;
  105915:	eb 3c                	jmp    105953 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105917:	8b 45 0c             	mov    0xc(%ebp),%eax
  10591a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10591e:	89 1c 24             	mov    %ebx,(%esp)
  105921:	8b 45 08             	mov    0x8(%ebp),%eax
  105924:	ff d0                	call   *%eax
            break;
  105926:	eb 2b                	jmp    105953 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105928:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105936:	8b 45 08             	mov    0x8(%ebp),%eax
  105939:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10593b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10593f:	eb 04                	jmp    105945 <vprintfmt+0x3d0>
  105941:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105945:	8b 45 10             	mov    0x10(%ebp),%eax
  105948:	83 e8 01             	sub    $0x1,%eax
  10594b:	0f b6 00             	movzbl (%eax),%eax
  10594e:	3c 25                	cmp    $0x25,%al
  105950:	75 ef                	jne    105941 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105952:	90                   	nop
        }
    }
  105953:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105954:	e9 3e fc ff ff       	jmp    105597 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105959:	83 c4 40             	add    $0x40,%esp
  10595c:	5b                   	pop    %ebx
  10595d:	5e                   	pop    %esi
  10595e:	5d                   	pop    %ebp
  10595f:	c3                   	ret    

00105960 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105960:	55                   	push   %ebp
  105961:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105963:	8b 45 0c             	mov    0xc(%ebp),%eax
  105966:	8b 40 08             	mov    0x8(%eax),%eax
  105969:	8d 50 01             	lea    0x1(%eax),%edx
  10596c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10596f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105972:	8b 45 0c             	mov    0xc(%ebp),%eax
  105975:	8b 10                	mov    (%eax),%edx
  105977:	8b 45 0c             	mov    0xc(%ebp),%eax
  10597a:	8b 40 04             	mov    0x4(%eax),%eax
  10597d:	39 c2                	cmp    %eax,%edx
  10597f:	73 12                	jae    105993 <sprintputch+0x33>
        *b->buf ++ = ch;
  105981:	8b 45 0c             	mov    0xc(%ebp),%eax
  105984:	8b 00                	mov    (%eax),%eax
  105986:	8d 48 01             	lea    0x1(%eax),%ecx
  105989:	8b 55 0c             	mov    0xc(%ebp),%edx
  10598c:	89 0a                	mov    %ecx,(%edx)
  10598e:	8b 55 08             	mov    0x8(%ebp),%edx
  105991:	88 10                	mov    %dl,(%eax)
    }
}
  105993:	5d                   	pop    %ebp
  105994:	c3                   	ret    

00105995 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105995:	55                   	push   %ebp
  105996:	89 e5                	mov    %esp,%ebp
  105998:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10599b:	8d 45 14             	lea    0x14(%ebp),%eax
  10599e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1059a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1059a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1059ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b9:	89 04 24             	mov    %eax,(%esp)
  1059bc:	e8 08 00 00 00       	call   1059c9 <vsnprintf>
  1059c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1059c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1059c7:	c9                   	leave  
  1059c8:	c3                   	ret    

001059c9 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1059c9:	55                   	push   %ebp
  1059ca:	89 e5                	mov    %esp,%ebp
  1059cc:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1059cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1059db:	8b 45 08             	mov    0x8(%ebp),%eax
  1059de:	01 d0                	add    %edx,%eax
  1059e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1059ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1059ee:	74 0a                	je     1059fa <vsnprintf+0x31>
  1059f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1059f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059f6:	39 c2                	cmp    %eax,%edx
  1059f8:	76 07                	jbe    105a01 <vsnprintf+0x38>
        return -E_INVAL;
  1059fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1059ff:	eb 2a                	jmp    105a2b <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a01:	8b 45 14             	mov    0x14(%ebp),%eax
  105a04:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a08:	8b 45 10             	mov    0x10(%ebp),%eax
  105a0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a0f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a16:	c7 04 24 60 59 10 00 	movl   $0x105960,(%esp)
  105a1d:	e8 53 fb ff ff       	call   105575 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a25:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a2b:	c9                   	leave  
  105a2c:	c3                   	ret    

00105a2d <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105a2d:	55                   	push   %ebp
  105a2e:	89 e5                	mov    %esp,%ebp
  105a30:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105a3a:	eb 04                	jmp    105a40 <strlen+0x13>
        cnt ++;
  105a3c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105a40:	8b 45 08             	mov    0x8(%ebp),%eax
  105a43:	8d 50 01             	lea    0x1(%eax),%edx
  105a46:	89 55 08             	mov    %edx,0x8(%ebp)
  105a49:	0f b6 00             	movzbl (%eax),%eax
  105a4c:	84 c0                	test   %al,%al
  105a4e:	75 ec                	jne    105a3c <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a53:	c9                   	leave  
  105a54:	c3                   	ret    

00105a55 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105a55:	55                   	push   %ebp
  105a56:	89 e5                	mov    %esp,%ebp
  105a58:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105a62:	eb 04                	jmp    105a68 <strnlen+0x13>
        cnt ++;
  105a64:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105a6e:	73 10                	jae    105a80 <strnlen+0x2b>
  105a70:	8b 45 08             	mov    0x8(%ebp),%eax
  105a73:	8d 50 01             	lea    0x1(%eax),%edx
  105a76:	89 55 08             	mov    %edx,0x8(%ebp)
  105a79:	0f b6 00             	movzbl (%eax),%eax
  105a7c:	84 c0                	test   %al,%al
  105a7e:	75 e4                	jne    105a64 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a83:	c9                   	leave  
  105a84:	c3                   	ret    

00105a85 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105a85:	55                   	push   %ebp
  105a86:	89 e5                	mov    %esp,%ebp
  105a88:	57                   	push   %edi
  105a89:	56                   	push   %esi
  105a8a:	83 ec 20             	sub    $0x20,%esp
  105a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a9f:	89 d1                	mov    %edx,%ecx
  105aa1:	89 c2                	mov    %eax,%edx
  105aa3:	89 ce                	mov    %ecx,%esi
  105aa5:	89 d7                	mov    %edx,%edi
  105aa7:	ac                   	lods   %ds:(%esi),%al
  105aa8:	aa                   	stos   %al,%es:(%edi)
  105aa9:	84 c0                	test   %al,%al
  105aab:	75 fa                	jne    105aa7 <strcpy+0x22>
  105aad:	89 fa                	mov    %edi,%edx
  105aaf:	89 f1                	mov    %esi,%ecx
  105ab1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ab4:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105ab7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105abd:	83 c4 20             	add    $0x20,%esp
  105ac0:	5e                   	pop    %esi
  105ac1:	5f                   	pop    %edi
  105ac2:	5d                   	pop    %ebp
  105ac3:	c3                   	ret    

00105ac4 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105ac4:	55                   	push   %ebp
  105ac5:	89 e5                	mov    %esp,%ebp
  105ac7:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105aca:	8b 45 08             	mov    0x8(%ebp),%eax
  105acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105ad0:	eb 21                	jmp    105af3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad5:	0f b6 10             	movzbl (%eax),%edx
  105ad8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105adb:	88 10                	mov    %dl,(%eax)
  105add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ae0:	0f b6 00             	movzbl (%eax),%eax
  105ae3:	84 c0                	test   %al,%al
  105ae5:	74 04                	je     105aeb <strncpy+0x27>
            src ++;
  105ae7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105aeb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105aef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105af3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105af7:	75 d9                	jne    105ad2 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105af9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105afc:	c9                   	leave  
  105afd:	c3                   	ret    

00105afe <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105afe:	55                   	push   %ebp
  105aff:	89 e5                	mov    %esp,%ebp
  105b01:	57                   	push   %edi
  105b02:	56                   	push   %esi
  105b03:	83 ec 20             	sub    $0x20,%esp
  105b06:	8b 45 08             	mov    0x8(%ebp),%eax
  105b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b18:	89 d1                	mov    %edx,%ecx
  105b1a:	89 c2                	mov    %eax,%edx
  105b1c:	89 ce                	mov    %ecx,%esi
  105b1e:	89 d7                	mov    %edx,%edi
  105b20:	ac                   	lods   %ds:(%esi),%al
  105b21:	ae                   	scas   %es:(%edi),%al
  105b22:	75 08                	jne    105b2c <strcmp+0x2e>
  105b24:	84 c0                	test   %al,%al
  105b26:	75 f8                	jne    105b20 <strcmp+0x22>
  105b28:	31 c0                	xor    %eax,%eax
  105b2a:	eb 04                	jmp    105b30 <strcmp+0x32>
  105b2c:	19 c0                	sbb    %eax,%eax
  105b2e:	0c 01                	or     $0x1,%al
  105b30:	89 fa                	mov    %edi,%edx
  105b32:	89 f1                	mov    %esi,%ecx
  105b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b37:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105b40:	83 c4 20             	add    $0x20,%esp
  105b43:	5e                   	pop    %esi
  105b44:	5f                   	pop    %edi
  105b45:	5d                   	pop    %ebp
  105b46:	c3                   	ret    

00105b47 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105b47:	55                   	push   %ebp
  105b48:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b4a:	eb 0c                	jmp    105b58 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105b4c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b54:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b5c:	74 1a                	je     105b78 <strncmp+0x31>
  105b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b61:	0f b6 00             	movzbl (%eax),%eax
  105b64:	84 c0                	test   %al,%al
  105b66:	74 10                	je     105b78 <strncmp+0x31>
  105b68:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6b:	0f b6 10             	movzbl (%eax),%edx
  105b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b71:	0f b6 00             	movzbl (%eax),%eax
  105b74:	38 c2                	cmp    %al,%dl
  105b76:	74 d4                	je     105b4c <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105b78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b7c:	74 18                	je     105b96 <strncmp+0x4f>
  105b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b81:	0f b6 00             	movzbl (%eax),%eax
  105b84:	0f b6 d0             	movzbl %al,%edx
  105b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8a:	0f b6 00             	movzbl (%eax),%eax
  105b8d:	0f b6 c0             	movzbl %al,%eax
  105b90:	29 c2                	sub    %eax,%edx
  105b92:	89 d0                	mov    %edx,%eax
  105b94:	eb 05                	jmp    105b9b <strncmp+0x54>
  105b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b9b:	5d                   	pop    %ebp
  105b9c:	c3                   	ret    

00105b9d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105b9d:	55                   	push   %ebp
  105b9e:	89 e5                	mov    %esp,%ebp
  105ba0:	83 ec 04             	sub    $0x4,%esp
  105ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ba6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ba9:	eb 14                	jmp    105bbf <strchr+0x22>
        if (*s == c) {
  105bab:	8b 45 08             	mov    0x8(%ebp),%eax
  105bae:	0f b6 00             	movzbl (%eax),%eax
  105bb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105bb4:	75 05                	jne    105bbb <strchr+0x1e>
            return (char *)s;
  105bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb9:	eb 13                	jmp    105bce <strchr+0x31>
        }
        s ++;
  105bbb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc2:	0f b6 00             	movzbl (%eax),%eax
  105bc5:	84 c0                	test   %al,%al
  105bc7:	75 e2                	jne    105bab <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105bce:	c9                   	leave  
  105bcf:	c3                   	ret    

00105bd0 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105bd0:	55                   	push   %ebp
  105bd1:	89 e5                	mov    %esp,%ebp
  105bd3:	83 ec 04             	sub    $0x4,%esp
  105bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bd9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105bdc:	eb 11                	jmp    105bef <strfind+0x1f>
        if (*s == c) {
  105bde:	8b 45 08             	mov    0x8(%ebp),%eax
  105be1:	0f b6 00             	movzbl (%eax),%eax
  105be4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105be7:	75 02                	jne    105beb <strfind+0x1b>
            break;
  105be9:	eb 0e                	jmp    105bf9 <strfind+0x29>
        }
        s ++;
  105beb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105bef:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf2:	0f b6 00             	movzbl (%eax),%eax
  105bf5:	84 c0                	test   %al,%al
  105bf7:	75 e5                	jne    105bde <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105bfc:	c9                   	leave  
  105bfd:	c3                   	ret    

00105bfe <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105bfe:	55                   	push   %ebp
  105bff:	89 e5                	mov    %esp,%ebp
  105c01:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c12:	eb 04                	jmp    105c18 <strtol+0x1a>
        s ++;
  105c14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c18:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1b:	0f b6 00             	movzbl (%eax),%eax
  105c1e:	3c 20                	cmp    $0x20,%al
  105c20:	74 f2                	je     105c14 <strtol+0x16>
  105c22:	8b 45 08             	mov    0x8(%ebp),%eax
  105c25:	0f b6 00             	movzbl (%eax),%eax
  105c28:	3c 09                	cmp    $0x9,%al
  105c2a:	74 e8                	je     105c14 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2f:	0f b6 00             	movzbl (%eax),%eax
  105c32:	3c 2b                	cmp    $0x2b,%al
  105c34:	75 06                	jne    105c3c <strtol+0x3e>
        s ++;
  105c36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c3a:	eb 15                	jmp    105c51 <strtol+0x53>
    }
    else if (*s == '-') {
  105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3f:	0f b6 00             	movzbl (%eax),%eax
  105c42:	3c 2d                	cmp    $0x2d,%al
  105c44:	75 0b                	jne    105c51 <strtol+0x53>
        s ++, neg = 1;
  105c46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c4a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c55:	74 06                	je     105c5d <strtol+0x5f>
  105c57:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105c5b:	75 24                	jne    105c81 <strtol+0x83>
  105c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c60:	0f b6 00             	movzbl (%eax),%eax
  105c63:	3c 30                	cmp    $0x30,%al
  105c65:	75 1a                	jne    105c81 <strtol+0x83>
  105c67:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6a:	83 c0 01             	add    $0x1,%eax
  105c6d:	0f b6 00             	movzbl (%eax),%eax
  105c70:	3c 78                	cmp    $0x78,%al
  105c72:	75 0d                	jne    105c81 <strtol+0x83>
        s += 2, base = 16;
  105c74:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105c78:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105c7f:	eb 2a                	jmp    105cab <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105c81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c85:	75 17                	jne    105c9e <strtol+0xa0>
  105c87:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8a:	0f b6 00             	movzbl (%eax),%eax
  105c8d:	3c 30                	cmp    $0x30,%al
  105c8f:	75 0d                	jne    105c9e <strtol+0xa0>
        s ++, base = 8;
  105c91:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c95:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105c9c:	eb 0d                	jmp    105cab <strtol+0xad>
    }
    else if (base == 0) {
  105c9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ca2:	75 07                	jne    105cab <strtol+0xad>
        base = 10;
  105ca4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105cab:	8b 45 08             	mov    0x8(%ebp),%eax
  105cae:	0f b6 00             	movzbl (%eax),%eax
  105cb1:	3c 2f                	cmp    $0x2f,%al
  105cb3:	7e 1b                	jle    105cd0 <strtol+0xd2>
  105cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb8:	0f b6 00             	movzbl (%eax),%eax
  105cbb:	3c 39                	cmp    $0x39,%al
  105cbd:	7f 11                	jg     105cd0 <strtol+0xd2>
            dig = *s - '0';
  105cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc2:	0f b6 00             	movzbl (%eax),%eax
  105cc5:	0f be c0             	movsbl %al,%eax
  105cc8:	83 e8 30             	sub    $0x30,%eax
  105ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cce:	eb 48                	jmp    105d18 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd3:	0f b6 00             	movzbl (%eax),%eax
  105cd6:	3c 60                	cmp    $0x60,%al
  105cd8:	7e 1b                	jle    105cf5 <strtol+0xf7>
  105cda:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdd:	0f b6 00             	movzbl (%eax),%eax
  105ce0:	3c 7a                	cmp    $0x7a,%al
  105ce2:	7f 11                	jg     105cf5 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce7:	0f b6 00             	movzbl (%eax),%eax
  105cea:	0f be c0             	movsbl %al,%eax
  105ced:	83 e8 57             	sub    $0x57,%eax
  105cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cf3:	eb 23                	jmp    105d18 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf8:	0f b6 00             	movzbl (%eax),%eax
  105cfb:	3c 40                	cmp    $0x40,%al
  105cfd:	7e 3d                	jle    105d3c <strtol+0x13e>
  105cff:	8b 45 08             	mov    0x8(%ebp),%eax
  105d02:	0f b6 00             	movzbl (%eax),%eax
  105d05:	3c 5a                	cmp    $0x5a,%al
  105d07:	7f 33                	jg     105d3c <strtol+0x13e>
            dig = *s - 'A' + 10;
  105d09:	8b 45 08             	mov    0x8(%ebp),%eax
  105d0c:	0f b6 00             	movzbl (%eax),%eax
  105d0f:	0f be c0             	movsbl %al,%eax
  105d12:	83 e8 37             	sub    $0x37,%eax
  105d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  105d1e:	7c 02                	jl     105d22 <strtol+0x124>
            break;
  105d20:	eb 1a                	jmp    105d3c <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105d22:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d29:	0f af 45 10          	imul   0x10(%ebp),%eax
  105d2d:	89 c2                	mov    %eax,%edx
  105d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d32:	01 d0                	add    %edx,%eax
  105d34:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105d37:	e9 6f ff ff ff       	jmp    105cab <strtol+0xad>

    if (endptr) {
  105d3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105d40:	74 08                	je     105d4a <strtol+0x14c>
        *endptr = (char *) s;
  105d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d45:	8b 55 08             	mov    0x8(%ebp),%edx
  105d48:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105d4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105d4e:	74 07                	je     105d57 <strtol+0x159>
  105d50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d53:	f7 d8                	neg    %eax
  105d55:	eb 03                	jmp    105d5a <strtol+0x15c>
  105d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105d5a:	c9                   	leave  
  105d5b:	c3                   	ret    

00105d5c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105d5c:	55                   	push   %ebp
  105d5d:	89 e5                	mov    %esp,%ebp
  105d5f:	57                   	push   %edi
  105d60:	83 ec 24             	sub    $0x24,%esp
  105d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d66:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105d69:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  105d70:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105d73:	88 45 f7             	mov    %al,-0x9(%ebp)
  105d76:	8b 45 10             	mov    0x10(%ebp),%eax
  105d79:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105d7c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105d7f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105d83:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105d86:	89 d7                	mov    %edx,%edi
  105d88:	f3 aa                	rep stos %al,%es:(%edi)
  105d8a:	89 fa                	mov    %edi,%edx
  105d8c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d8f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105d92:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105d95:	83 c4 24             	add    $0x24,%esp
  105d98:	5f                   	pop    %edi
  105d99:	5d                   	pop    %ebp
  105d9a:	c3                   	ret    

00105d9b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105d9b:	55                   	push   %ebp
  105d9c:	89 e5                	mov    %esp,%ebp
  105d9e:	57                   	push   %edi
  105d9f:	56                   	push   %esi
  105da0:	53                   	push   %ebx
  105da1:	83 ec 30             	sub    $0x30,%esp
  105da4:	8b 45 08             	mov    0x8(%ebp),%eax
  105da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105db0:	8b 45 10             	mov    0x10(%ebp),%eax
  105db3:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105db9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105dbc:	73 42                	jae    105e00 <memmove+0x65>
  105dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105dca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105dcd:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105dd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105dd3:	c1 e8 02             	shr    $0x2,%eax
  105dd6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105dd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105dde:	89 d7                	mov    %edx,%edi
  105de0:	89 c6                	mov    %eax,%esi
  105de2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105de4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105de7:	83 e1 03             	and    $0x3,%ecx
  105dea:	74 02                	je     105dee <memmove+0x53>
  105dec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105dee:	89 f0                	mov    %esi,%eax
  105df0:	89 fa                	mov    %edi,%edx
  105df2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105df5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105df8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105dfe:	eb 36                	jmp    105e36 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e09:	01 c2                	add    %eax,%edx
  105e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e0e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e14:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e1a:	89 c1                	mov    %eax,%ecx
  105e1c:	89 d8                	mov    %ebx,%eax
  105e1e:	89 d6                	mov    %edx,%esi
  105e20:	89 c7                	mov    %eax,%edi
  105e22:	fd                   	std    
  105e23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e25:	fc                   	cld    
  105e26:	89 f8                	mov    %edi,%eax
  105e28:	89 f2                	mov    %esi,%edx
  105e2a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105e2d:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105e30:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105e36:	83 c4 30             	add    $0x30,%esp
  105e39:	5b                   	pop    %ebx
  105e3a:	5e                   	pop    %esi
  105e3b:	5f                   	pop    %edi
  105e3c:	5d                   	pop    %ebp
  105e3d:	c3                   	ret    

00105e3e <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105e3e:	55                   	push   %ebp
  105e3f:	89 e5                	mov    %esp,%ebp
  105e41:	57                   	push   %edi
  105e42:	56                   	push   %esi
  105e43:	83 ec 20             	sub    $0x20,%esp
  105e46:	8b 45 08             	mov    0x8(%ebp),%eax
  105e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e52:	8b 45 10             	mov    0x10(%ebp),%eax
  105e55:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e5b:	c1 e8 02             	shr    $0x2,%eax
  105e5e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e66:	89 d7                	mov    %edx,%edi
  105e68:	89 c6                	mov    %eax,%esi
  105e6a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e6c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105e6f:	83 e1 03             	and    $0x3,%ecx
  105e72:	74 02                	je     105e76 <memcpy+0x38>
  105e74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e76:	89 f0                	mov    %esi,%eax
  105e78:	89 fa                	mov    %edi,%edx
  105e7a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105e7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105e80:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105e86:	83 c4 20             	add    $0x20,%esp
  105e89:	5e                   	pop    %esi
  105e8a:	5f                   	pop    %edi
  105e8b:	5d                   	pop    %ebp
  105e8c:	c3                   	ret    

00105e8d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105e8d:	55                   	push   %ebp
  105e8e:	89 e5                	mov    %esp,%ebp
  105e90:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105e93:	8b 45 08             	mov    0x8(%ebp),%eax
  105e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105e9f:	eb 30                	jmp    105ed1 <memcmp+0x44>
        if (*s1 != *s2) {
  105ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ea4:	0f b6 10             	movzbl (%eax),%edx
  105ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105eaa:	0f b6 00             	movzbl (%eax),%eax
  105ead:	38 c2                	cmp    %al,%dl
  105eaf:	74 18                	je     105ec9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105eb4:	0f b6 00             	movzbl (%eax),%eax
  105eb7:	0f b6 d0             	movzbl %al,%edx
  105eba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ebd:	0f b6 00             	movzbl (%eax),%eax
  105ec0:	0f b6 c0             	movzbl %al,%eax
  105ec3:	29 c2                	sub    %eax,%edx
  105ec5:	89 d0                	mov    %edx,%eax
  105ec7:	eb 1a                	jmp    105ee3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105ec9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105ecd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  105ed4:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ed7:	89 55 10             	mov    %edx,0x10(%ebp)
  105eda:	85 c0                	test   %eax,%eax
  105edc:	75 c3                	jne    105ea1 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105ede:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ee3:	c9                   	leave  
  105ee4:	c3                   	ret    
