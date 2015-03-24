
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 de 33 00 00       	call   10340a <memset>

    cons_init();                // init the console
  10002c:	e8 3f 15 00 00       	call   101570 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 a0 35 10 00 	movl   $0x1035a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 bc 35 10 00 	movl   $0x1035bc,(%esp)
  100046:	e8 d2 02 00 00       	call   10031d <cprintf>

    print_kerninfo();
  10004b:	e8 01 08 00 00       	call   100851 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 f6 29 00 00       	call   102a50 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 54 16 00 00       	call   1016b3 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 cc 17 00 00       	call   101830 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 fa 0c 00 00       	call   100d63 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 b3 15 00 00       	call   101621 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 03 0c 00 00       	call   100c95 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 c1 35 10 00 	movl   $0x1035c1,(%esp)
  100132:	e8 e6 01 00 00       	call   10031d <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 cf 35 10 00 	movl   $0x1035cf,(%esp)
  100152:	e8 c6 01 00 00       	call   10031d <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 dd 35 10 00 	movl   $0x1035dd,(%esp)
  100172:	e8 a6 01 00 00       	call   10031d <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 eb 35 10 00 	movl   $0x1035eb,(%esp)
  100192:	e8 86 01 00 00       	call   10031d <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 f9 35 10 00 	movl   $0x1035f9,(%esp)
  1001b2:	e8 66 01 00 00       	call   10031d <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001c9:	83 ec 08             	sub    $0x8,%esp
  1001cc:	cd 78                	int    $0x78
  1001ce:	89 ec                	mov    %ebp,%esp
		    "int %0 \n"
		    "movl %%ebp, %%esp"
		    :
		    : "i"(T_SWITCH_TOU)
		);
}
  1001d0:	5d                   	pop    %ebp
  1001d1:	c3                   	ret    

001001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d2:	55                   	push   %ebp
  1001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001d5:	cd 79                	int    $0x79
  1001d7:	89 ec                	mov    %ebp,%esp
		    "int %0 \n"
		    "movl %%ebp, %%esp \n"
		    :
		    : "i"(T_SWITCH_TOK)
		);
}
  1001d9:	5d                   	pop    %ebp
  1001da:	c3                   	ret    

001001db <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001db:	55                   	push   %ebp
  1001dc:	89 e5                	mov    %esp,%ebp
  1001de:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e1:	e8 1a ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e6:	c7 04 24 08 36 10 00 	movl   $0x103608,(%esp)
  1001ed:	e8 2b 01 00 00       	call   10031d <cprintf>
    lab1_switch_to_user();
  1001f2:	e8 cf ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f7:	e8 04 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001fc:	c7 04 24 28 36 10 00 	movl   $0x103628,(%esp)
  100203:	e8 15 01 00 00       	call   10031d <cprintf>
    lab1_switch_to_kernel();
  100208:	e8 c5 ff ff ff       	call   1001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10020d:	e8 ee fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100212:	c9                   	leave  
  100213:	c3                   	ret    

00100214 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100214:	55                   	push   %ebp
  100215:	89 e5                	mov    %esp,%ebp
  100217:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10021a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10021e:	74 13                	je     100233 <readline+0x1f>
        cprintf("%s", prompt);
  100220:	8b 45 08             	mov    0x8(%ebp),%eax
  100223:	89 44 24 04          	mov    %eax,0x4(%esp)
  100227:	c7 04 24 47 36 10 00 	movl   $0x103647,(%esp)
  10022e:	e8 ea 00 00 00       	call   10031d <cprintf>
    }
    int i = 0, c;
  100233:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10023a:	e8 66 01 00 00       	call   1003a5 <getchar>
  10023f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100242:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100246:	79 07                	jns    10024f <readline+0x3b>
            return NULL;
  100248:	b8 00 00 00 00       	mov    $0x0,%eax
  10024d:	eb 79                	jmp    1002c8 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10024f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100253:	7e 28                	jle    10027d <readline+0x69>
  100255:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10025c:	7f 1f                	jg     10027d <readline+0x69>
            cputchar(c);
  10025e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100261:	89 04 24             	mov    %eax,(%esp)
  100264:	e8 da 00 00 00       	call   100343 <cputchar>
            buf[i ++] = c;
  100269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10026c:	8d 50 01             	lea    0x1(%eax),%edx
  10026f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100272:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100275:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10027b:	eb 46                	jmp    1002c3 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10027d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100281:	75 17                	jne    10029a <readline+0x86>
  100283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100287:	7e 11                	jle    10029a <readline+0x86>
            cputchar(c);
  100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028c:	89 04 24             	mov    %eax,(%esp)
  10028f:	e8 af 00 00 00       	call   100343 <cputchar>
            i --;
  100294:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100298:	eb 29                	jmp    1002c3 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10029a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10029e:	74 06                	je     1002a6 <readline+0x92>
  1002a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a4:	75 1d                	jne    1002c3 <readline+0xaf>
            cputchar(c);
  1002a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a9:	89 04 24             	mov    %eax,(%esp)
  1002ac:	e8 92 00 00 00       	call   100343 <cputchar>
            buf[i] = '\0';
  1002b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b4:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002b9:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002bc:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002c1:	eb 05                	jmp    1002c8 <readline+0xb4>
        }
    }
  1002c3:	e9 72 ff ff ff       	jmp    10023a <readline+0x26>
}
  1002c8:	c9                   	leave  
  1002c9:	c3                   	ret    

001002ca <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002ca:	55                   	push   %ebp
  1002cb:	89 e5                	mov    %esp,%ebp
  1002cd:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d3:	89 04 24             	mov    %eax,(%esp)
  1002d6:	e8 c1 12 00 00       	call   10159c <cons_putc>
    (*cnt) ++;
  1002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002de:	8b 00                	mov    (%eax),%eax
  1002e0:	8d 50 01             	lea    0x1(%eax),%edx
  1002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e6:	89 10                	mov    %edx,(%eax)
}
  1002e8:	c9                   	leave  
  1002e9:	c3                   	ret    

001002ea <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002ea:	55                   	push   %ebp
  1002eb:	89 e5                	mov    %esp,%ebp
  1002ed:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100301:	89 44 24 08          	mov    %eax,0x8(%esp)
  100305:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100308:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030c:	c7 04 24 ca 02 10 00 	movl   $0x1002ca,(%esp)
  100313:	e8 0b 29 00 00       	call   102c23 <vprintfmt>
    return cnt;
  100318:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10031b:	c9                   	leave  
  10031c:	c3                   	ret    

0010031d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10031d:	55                   	push   %ebp
  10031e:	89 e5                	mov    %esp,%ebp
  100320:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100323:	8d 45 0c             	lea    0xc(%ebp),%eax
  100326:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10032c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100330:	8b 45 08             	mov    0x8(%ebp),%eax
  100333:	89 04 24             	mov    %eax,(%esp)
  100336:	e8 af ff ff ff       	call   1002ea <vcprintf>
  10033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100341:	c9                   	leave  
  100342:	c3                   	ret    

00100343 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100343:	55                   	push   %ebp
  100344:	89 e5                	mov    %esp,%ebp
  100346:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100349:	8b 45 08             	mov    0x8(%ebp),%eax
  10034c:	89 04 24             	mov    %eax,(%esp)
  10034f:	e8 48 12 00 00       	call   10159c <cons_putc>
}
  100354:	c9                   	leave  
  100355:	c3                   	ret    

00100356 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100356:	55                   	push   %ebp
  100357:	89 e5                	mov    %esp,%ebp
  100359:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100363:	eb 13                	jmp    100378 <cputs+0x22>
        cputch(c, &cnt);
  100365:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100369:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10036c:	89 54 24 04          	mov    %edx,0x4(%esp)
  100370:	89 04 24             	mov    %eax,(%esp)
  100373:	e8 52 ff ff ff       	call   1002ca <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100378:	8b 45 08             	mov    0x8(%ebp),%eax
  10037b:	8d 50 01             	lea    0x1(%eax),%edx
  10037e:	89 55 08             	mov    %edx,0x8(%ebp)
  100381:	0f b6 00             	movzbl (%eax),%eax
  100384:	88 45 f7             	mov    %al,-0x9(%ebp)
  100387:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10038b:	75 d8                	jne    100365 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  10038d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100390:	89 44 24 04          	mov    %eax,0x4(%esp)
  100394:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10039b:	e8 2a ff ff ff       	call   1002ca <cputch>
    return cnt;
  1003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a3:	c9                   	leave  
  1003a4:	c3                   	ret    

001003a5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003a5:	55                   	push   %ebp
  1003a6:	89 e5                	mov    %esp,%ebp
  1003a8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ab:	e8 15 12 00 00       	call   1015c5 <cons_getc>
  1003b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b7:	74 f2                	je     1003ab <getchar+0x6>
        /* do nothing */;
    return c;
  1003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003bc:	c9                   	leave  
  1003bd:	c3                   	ret    

001003be <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003be:	55                   	push   %ebp
  1003bf:	89 e5                	mov    %esp,%ebp
  1003c1:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003c7:	8b 00                	mov    (%eax),%eax
  1003c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1003cf:	8b 00                	mov    (%eax),%eax
  1003d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003db:	e9 d2 00 00 00       	jmp    1004b2 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003e6:	01 d0                	add    %edx,%eax
  1003e8:	89 c2                	mov    %eax,%edx
  1003ea:	c1 ea 1f             	shr    $0x1f,%edx
  1003ed:	01 d0                	add    %edx,%eax
  1003ef:	d1 f8                	sar    %eax
  1003f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003f7:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003fa:	eb 04                	jmp    100400 <stab_binsearch+0x42>
            m --;
  1003fc:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100403:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100406:	7c 1f                	jl     100427 <stab_binsearch+0x69>
  100408:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10040b:	89 d0                	mov    %edx,%eax
  10040d:	01 c0                	add    %eax,%eax
  10040f:	01 d0                	add    %edx,%eax
  100411:	c1 e0 02             	shl    $0x2,%eax
  100414:	89 c2                	mov    %eax,%edx
  100416:	8b 45 08             	mov    0x8(%ebp),%eax
  100419:	01 d0                	add    %edx,%eax
  10041b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10041f:	0f b6 c0             	movzbl %al,%eax
  100422:	3b 45 14             	cmp    0x14(%ebp),%eax
  100425:	75 d5                	jne    1003fc <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10042d:	7d 0b                	jge    10043a <stab_binsearch+0x7c>
            l = true_m + 1;
  10042f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100432:	83 c0 01             	add    $0x1,%eax
  100435:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100438:	eb 78                	jmp    1004b2 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10043a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100444:	89 d0                	mov    %edx,%eax
  100446:	01 c0                	add    %eax,%eax
  100448:	01 d0                	add    %edx,%eax
  10044a:	c1 e0 02             	shl    $0x2,%eax
  10044d:	89 c2                	mov    %eax,%edx
  10044f:	8b 45 08             	mov    0x8(%ebp),%eax
  100452:	01 d0                	add    %edx,%eax
  100454:	8b 40 08             	mov    0x8(%eax),%eax
  100457:	3b 45 18             	cmp    0x18(%ebp),%eax
  10045a:	73 13                	jae    10046f <stab_binsearch+0xb1>
            *region_left = m;
  10045c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10045f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100462:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100467:	83 c0 01             	add    $0x1,%eax
  10046a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10046d:	eb 43                	jmp    1004b2 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100472:	89 d0                	mov    %edx,%eax
  100474:	01 c0                	add    %eax,%eax
  100476:	01 d0                	add    %edx,%eax
  100478:	c1 e0 02             	shl    $0x2,%eax
  10047b:	89 c2                	mov    %eax,%edx
  10047d:	8b 45 08             	mov    0x8(%ebp),%eax
  100480:	01 d0                	add    %edx,%eax
  100482:	8b 40 08             	mov    0x8(%eax),%eax
  100485:	3b 45 18             	cmp    0x18(%ebp),%eax
  100488:	76 16                	jbe    1004a0 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100490:	8b 45 10             	mov    0x10(%ebp),%eax
  100493:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100498:	83 e8 01             	sub    $0x1,%eax
  10049b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10049e:	eb 12                	jmp    1004b2 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a6:	89 10                	mov    %edx,(%eax)
            l = m;
  1004a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004ae:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004b8:	0f 8e 22 ff ff ff    	jle    1003e0 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c2:	75 0f                	jne    1004d3 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c7:	8b 00                	mov    (%eax),%eax
  1004c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cf:	89 10                	mov    %edx,(%eax)
  1004d1:	eb 3f                	jmp    100512 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d6:	8b 00                	mov    (%eax),%eax
  1004d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004db:	eb 04                	jmp    1004e1 <stab_binsearch+0x123>
  1004dd:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e4:	8b 00                	mov    (%eax),%eax
  1004e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e9:	7d 1f                	jge    10050a <stab_binsearch+0x14c>
  1004eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004ee:	89 d0                	mov    %edx,%eax
  1004f0:	01 c0                	add    %eax,%eax
  1004f2:	01 d0                	add    %edx,%eax
  1004f4:	c1 e0 02             	shl    $0x2,%eax
  1004f7:	89 c2                	mov    %eax,%edx
  1004f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004fc:	01 d0                	add    %edx,%eax
  1004fe:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100502:	0f b6 c0             	movzbl %al,%eax
  100505:	3b 45 14             	cmp    0x14(%ebp),%eax
  100508:	75 d3                	jne    1004dd <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  10050a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100510:	89 10                	mov    %edx,(%eax)
    }
}
  100512:	c9                   	leave  
  100513:	c3                   	ret    

00100514 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100514:	55                   	push   %ebp
  100515:	89 e5                	mov    %esp,%ebp
  100517:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10051a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051d:	c7 00 4c 36 10 00    	movl   $0x10364c,(%eax)
    info->eip_line = 0;
  100523:	8b 45 0c             	mov    0xc(%ebp),%eax
  100526:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100530:	c7 40 08 4c 36 10 00 	movl   $0x10364c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100537:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053a:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100541:	8b 45 0c             	mov    0xc(%ebp),%eax
  100544:	8b 55 08             	mov    0x8(%ebp),%edx
  100547:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10054a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100554:	c7 45 f4 cc 3e 10 00 	movl   $0x103ecc,-0xc(%ebp)
    stab_end = __STAB_END__;
  10055b:	c7 45 f0 d8 b6 10 00 	movl   $0x10b6d8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100562:	c7 45 ec d9 b6 10 00 	movl   $0x10b6d9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100569:	c7 45 e8 e7 d6 10 00 	movl   $0x10d6e7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100570:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100573:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100576:	76 0d                	jbe    100585 <debuginfo_eip+0x71>
  100578:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10057b:	83 e8 01             	sub    $0x1,%eax
  10057e:	0f b6 00             	movzbl (%eax),%eax
  100581:	84 c0                	test   %al,%al
  100583:	74 0a                	je     10058f <debuginfo_eip+0x7b>
        return -1;
  100585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058a:	e9 c0 02 00 00       	jmp    10084f <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10058f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100596:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10059c:	29 c2                	sub    %eax,%edx
  10059e:	89 d0                	mov    %edx,%eax
  1005a0:	c1 f8 02             	sar    $0x2,%eax
  1005a3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005a9:	83 e8 01             	sub    $0x1,%eax
  1005ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005af:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005b6:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005bd:	00 
  1005be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005cf:	89 04 24             	mov    %eax,(%esp)
  1005d2:	e8 e7 fd ff ff       	call   1003be <stab_binsearch>
    if (lfile == 0)
  1005d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005da:	85 c0                	test   %eax,%eax
  1005dc:	75 0a                	jne    1005e8 <debuginfo_eip+0xd4>
        return -1;
  1005de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e3:	e9 67 02 00 00       	jmp    10084f <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005fb:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100602:	00 
  100603:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100606:	89 44 24 08          	mov    %eax,0x8(%esp)
  10060a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10060d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100614:	89 04 24             	mov    %eax,(%esp)
  100617:	e8 a2 fd ff ff       	call   1003be <stab_binsearch>

    if (lfun <= rfun) {
  10061c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10061f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100622:	39 c2                	cmp    %eax,%edx
  100624:	7f 7c                	jg     1006a2 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100626:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	89 d0                	mov    %edx,%eax
  10062d:	01 c0                	add    %eax,%eax
  10062f:	01 d0                	add    %edx,%eax
  100631:	c1 e0 02             	shl    $0x2,%eax
  100634:	89 c2                	mov    %eax,%edx
  100636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100639:	01 d0                	add    %edx,%eax
  10063b:	8b 10                	mov    (%eax),%edx
  10063d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100640:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100643:	29 c1                	sub    %eax,%ecx
  100645:	89 c8                	mov    %ecx,%eax
  100647:	39 c2                	cmp    %eax,%edx
  100649:	73 22                	jae    10066d <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10064b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	89 d0                	mov    %edx,%eax
  100652:	01 c0                	add    %eax,%eax
  100654:	01 d0                	add    %edx,%eax
  100656:	c1 e0 02             	shl    $0x2,%eax
  100659:	89 c2                	mov    %eax,%edx
  10065b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10065e:	01 d0                	add    %edx,%eax
  100660:	8b 10                	mov    (%eax),%edx
  100662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100665:	01 c2                	add    %eax,%edx
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10066d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	89 d0                	mov    %edx,%eax
  100674:	01 c0                	add    %eax,%eax
  100676:	01 d0                	add    %edx,%eax
  100678:	c1 e0 02             	shl    $0x2,%eax
  10067b:	89 c2                	mov    %eax,%edx
  10067d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100680:	01 d0                	add    %edx,%eax
  100682:	8b 50 08             	mov    0x8(%eax),%edx
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10068b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068e:	8b 40 10             	mov    0x10(%eax),%eax
  100691:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100694:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100697:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10069a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10069d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006a0:	eb 15                	jmp    1006b7 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a5:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ba:	8b 40 08             	mov    0x8(%eax),%eax
  1006bd:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006c4:	00 
  1006c5:	89 04 24             	mov    %eax,(%esp)
  1006c8:	e8 b1 2b 00 00       	call   10327e <strfind>
  1006cd:	89 c2                	mov    %eax,%edx
  1006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d2:	8b 40 08             	mov    0x8(%eax),%eax
  1006d5:	29 c2                	sub    %eax,%edx
  1006d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006da:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e4:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006eb:	00 
  1006ec:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fd:	89 04 24             	mov    %eax,(%esp)
  100700:	e8 b9 fc ff ff       	call   1003be <stab_binsearch>
    if (lline <= rline) {
  100705:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100708:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10070b:	39 c2                	cmp    %eax,%edx
  10070d:	7f 24                	jg     100733 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10070f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	89 d0                	mov    %edx,%eax
  100716:	01 c0                	add    %eax,%eax
  100718:	01 d0                	add    %edx,%eax
  10071a:	c1 e0 02             	shl    $0x2,%eax
  10071d:	89 c2                	mov    %eax,%edx
  10071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100722:	01 d0                	add    %edx,%eax
  100724:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100728:	0f b7 d0             	movzwl %ax,%edx
  10072b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100731:	eb 13                	jmp    100746 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100733:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100738:	e9 12 01 00 00       	jmp    10084f <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10073d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100740:	83 e8 01             	sub    $0x1,%eax
  100743:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100746:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10074c:	39 c2                	cmp    %eax,%edx
  10074e:	7c 56                	jl     1007a6 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	89 d0                	mov    %edx,%eax
  100757:	01 c0                	add    %eax,%eax
  100759:	01 d0                	add    %edx,%eax
  10075b:	c1 e0 02             	shl    $0x2,%eax
  10075e:	89 c2                	mov    %eax,%edx
  100760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100763:	01 d0                	add    %edx,%eax
  100765:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100769:	3c 84                	cmp    $0x84,%al
  10076b:	74 39                	je     1007a6 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	89 d0                	mov    %edx,%eax
  100774:	01 c0                	add    %eax,%eax
  100776:	01 d0                	add    %edx,%eax
  100778:	c1 e0 02             	shl    $0x2,%eax
  10077b:	89 c2                	mov    %eax,%edx
  10077d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100780:	01 d0                	add    %edx,%eax
  100782:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100786:	3c 64                	cmp    $0x64,%al
  100788:	75 b3                	jne    10073d <debuginfo_eip+0x229>
  10078a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	89 d0                	mov    %edx,%eax
  100791:	01 c0                	add    %eax,%eax
  100793:	01 d0                	add    %edx,%eax
  100795:	c1 e0 02             	shl    $0x2,%eax
  100798:	89 c2                	mov    %eax,%edx
  10079a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079d:	01 d0                	add    %edx,%eax
  10079f:	8b 40 08             	mov    0x8(%eax),%eax
  1007a2:	85 c0                	test   %eax,%eax
  1007a4:	74 97                	je     10073d <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ac:	39 c2                	cmp    %eax,%edx
  1007ae:	7c 46                	jl     1007f6 <debuginfo_eip+0x2e2>
  1007b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	89 d0                	mov    %edx,%eax
  1007b7:	01 c0                	add    %eax,%eax
  1007b9:	01 d0                	add    %edx,%eax
  1007bb:	c1 e0 02             	shl    $0x2,%eax
  1007be:	89 c2                	mov    %eax,%edx
  1007c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c3:	01 d0                	add    %edx,%eax
  1007c5:	8b 10                	mov    (%eax),%edx
  1007c7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007cd:	29 c1                	sub    %eax,%ecx
  1007cf:	89 c8                	mov    %ecx,%eax
  1007d1:	39 c2                	cmp    %eax,%edx
  1007d3:	73 21                	jae    1007f6 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	89 d0                	mov    %edx,%eax
  1007dc:	01 c0                	add    %eax,%eax
  1007de:	01 d0                	add    %edx,%eax
  1007e0:	c1 e0 02             	shl    $0x2,%eax
  1007e3:	89 c2                	mov    %eax,%edx
  1007e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e8:	01 d0                	add    %edx,%eax
  1007ea:	8b 10                	mov    (%eax),%edx
  1007ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ef:	01 c2                	add    %eax,%edx
  1007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f4:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007fc:	39 c2                	cmp    %eax,%edx
  1007fe:	7d 4a                	jge    10084a <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100803:	83 c0 01             	add    $0x1,%eax
  100806:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100809:	eb 18                	jmp    100823 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10080b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080e:	8b 40 14             	mov    0x14(%eax),%eax
  100811:	8d 50 01             	lea    0x1(%eax),%edx
  100814:	8b 45 0c             	mov    0xc(%ebp),%eax
  100817:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10081a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081d:	83 c0 01             	add    $0x1,%eax
  100820:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100823:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100826:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100829:	39 c2                	cmp    %eax,%edx
  10082b:	7d 1d                	jge    10084a <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10082d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	89 d0                	mov    %edx,%eax
  100834:	01 c0                	add    %eax,%eax
  100836:	01 d0                	add    %edx,%eax
  100838:	c1 e0 02             	shl    $0x2,%eax
  10083b:	89 c2                	mov    %eax,%edx
  10083d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100840:	01 d0                	add    %edx,%eax
  100842:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100846:	3c a0                	cmp    $0xa0,%al
  100848:	74 c1                	je     10080b <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10084a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10084f:	c9                   	leave  
  100850:	c3                   	ret    

00100851 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100851:	55                   	push   %ebp
  100852:	89 e5                	mov    %esp,%ebp
  100854:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100857:	c7 04 24 56 36 10 00 	movl   $0x103656,(%esp)
  10085e:	e8 ba fa ff ff       	call   10031d <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100863:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086a:	00 
  10086b:	c7 04 24 6f 36 10 00 	movl   $0x10366f,(%esp)
  100872:	e8 a6 fa ff ff       	call   10031d <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100877:	c7 44 24 04 93 35 10 	movl   $0x103593,0x4(%esp)
  10087e:	00 
  10087f:	c7 04 24 87 36 10 00 	movl   $0x103687,(%esp)
  100886:	e8 92 fa ff ff       	call   10031d <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10088b:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100892:	00 
  100893:	c7 04 24 9f 36 10 00 	movl   $0x10369f,(%esp)
  10089a:	e8 7e fa ff ff       	call   10031d <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  10089f:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  1008a6:	00 
  1008a7:	c7 04 24 b7 36 10 00 	movl   $0x1036b7,(%esp)
  1008ae:	e8 6a fa ff ff       	call   10031d <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b3:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  1008b8:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008be:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008c3:	29 c2                	sub    %eax,%edx
  1008c5:	89 d0                	mov    %edx,%eax
  1008c7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008cd:	85 c0                	test   %eax,%eax
  1008cf:	0f 48 c2             	cmovs  %edx,%eax
  1008d2:	c1 f8 0a             	sar    $0xa,%eax
  1008d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d9:	c7 04 24 d0 36 10 00 	movl   $0x1036d0,(%esp)
  1008e0:	e8 38 fa ff ff       	call   10031d <cprintf>
}
  1008e5:	c9                   	leave  
  1008e6:	c3                   	ret    

001008e7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008e7:	55                   	push   %ebp
  1008e8:	89 e5                	mov    %esp,%ebp
  1008ea:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fa:	89 04 24             	mov    %eax,(%esp)
  1008fd:	e8 12 fc ff ff       	call   100514 <debuginfo_eip>
  100902:	85 c0                	test   %eax,%eax
  100904:	74 15                	je     10091b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100906:	8b 45 08             	mov    0x8(%ebp),%eax
  100909:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090d:	c7 04 24 fa 36 10 00 	movl   $0x1036fa,(%esp)
  100914:	e8 04 fa ff ff       	call   10031d <cprintf>
  100919:	eb 6d                	jmp    100988 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100922:	eb 1c                	jmp    100940 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100924:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092a:	01 d0                	add    %edx,%eax
  10092c:	0f b6 00             	movzbl (%eax),%eax
  10092f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100938:	01 ca                	add    %ecx,%edx
  10093a:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100943:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100946:	7f dc                	jg     100924 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100948:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10094e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100951:	01 d0                	add    %edx,%eax
  100953:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100956:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100959:	8b 55 08             	mov    0x8(%ebp),%edx
  10095c:	89 d1                	mov    %edx,%ecx
  10095e:	29 c1                	sub    %eax,%ecx
  100960:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100963:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100966:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10096a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100970:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100974:	89 54 24 08          	mov    %edx,0x8(%esp)
  100978:	89 44 24 04          	mov    %eax,0x4(%esp)
  10097c:	c7 04 24 16 37 10 00 	movl   $0x103716,(%esp)
  100983:	e8 95 f9 ff ff       	call   10031d <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100988:	c9                   	leave  
  100989:	c3                   	ret    

0010098a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098a:	55                   	push   %ebp
  10098b:	89 e5                	mov    %esp,%ebp
  10098d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100990:	8b 45 04             	mov    0x4(%ebp),%eax
  100993:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100996:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100999:	c9                   	leave  
  10099a:	c3                   	ret    

0010099b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10099b:	55                   	push   %ebp
  10099c:	89 e5                	mov    %esp,%ebp
  10099e:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a1:	89 e8                	mov    %ebp,%eax
  1009a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009ac:	e8 d9 ff ff ff       	call   10098a <read_eip>
  1009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009bb:	e9 88 00 00 00       	jmp    100a48 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ce:	c7 04 24 28 37 10 00 	movl   $0x103728,(%esp)
  1009d5:	e8 43 f9 ff ff       	call   10031d <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  1009da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009dd:	83 c0 08             	add    $0x8,%eax
  1009e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  1009e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009ea:	eb 25                	jmp    100a11 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  1009ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009f9:	01 d0                	add    %edx,%eax
  1009fb:	8b 00                	mov    (%eax),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	c7 04 24 44 37 10 00 	movl   $0x103744,(%esp)
  100a08:	e8 10 f9 ff ff       	call   10031d <cprintf>
    uint32_t ebp = read_ebp(), eip = read_eip();
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a0d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a11:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a15:	7e d5                	jle    1009ec <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a17:	c7 04 24 4c 37 10 00 	movl   $0x10374c,(%esp)
  100a1e:	e8 fa f8 ff ff       	call   10031d <cprintf>
        print_debuginfo(eip - 1);
  100a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a26:	83 e8 01             	sub    $0x1,%eax
  100a29:	89 04 24             	mov    %eax,(%esp)
  100a2c:	e8 b6 fe ff ff       	call   1008e7 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	83 c0 04             	add    $0x4,%eax
  100a37:	8b 00                	mov    (%eax),%eax
  100a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3f:	8b 00                	mov    (%eax),%eax
  100a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a44:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a4c:	74 0a                	je     100a58 <print_stackframe+0xbd>
  100a4e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a52:	0f 8e 68 ff ff ff    	jle    1009c0 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a58:	c9                   	leave  
  100a59:	c3                   	ret    

00100a5a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a5a:	55                   	push   %ebp
  100a5b:	89 e5                	mov    %esp,%ebp
  100a5d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a67:	eb 0c                	jmp    100a75 <parse+0x1b>
            *buf ++ = '\0';
  100a69:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6c:	8d 50 01             	lea    0x1(%eax),%edx
  100a6f:	89 55 08             	mov    %edx,0x8(%ebp)
  100a72:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a75:	8b 45 08             	mov    0x8(%ebp),%eax
  100a78:	0f b6 00             	movzbl (%eax),%eax
  100a7b:	84 c0                	test   %al,%al
  100a7d:	74 1d                	je     100a9c <parse+0x42>
  100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a82:	0f b6 00             	movzbl (%eax),%eax
  100a85:	0f be c0             	movsbl %al,%eax
  100a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8c:	c7 04 24 d0 37 10 00 	movl   $0x1037d0,(%esp)
  100a93:	e8 b3 27 00 00       	call   10324b <strchr>
  100a98:	85 c0                	test   %eax,%eax
  100a9a:	75 cd                	jne    100a69 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9f:	0f b6 00             	movzbl (%eax),%eax
  100aa2:	84 c0                	test   %al,%al
  100aa4:	75 02                	jne    100aa8 <parse+0x4e>
            break;
  100aa6:	eb 67                	jmp    100b0f <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aac:	75 14                	jne    100ac2 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aae:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab5:	00 
  100ab6:	c7 04 24 d5 37 10 00 	movl   $0x1037d5,(%esp)
  100abd:	e8 5b f8 ff ff       	call   10031d <cprintf>
        }
        argv[argc ++] = buf;
  100ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac5:	8d 50 01             	lea    0x1(%eax),%edx
  100ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100acb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad5:	01 c2                	add    %eax,%edx
  100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ada:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100adc:	eb 04                	jmp    100ae2 <parse+0x88>
            buf ++;
  100ade:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae5:	0f b6 00             	movzbl (%eax),%eax
  100ae8:	84 c0                	test   %al,%al
  100aea:	74 1d                	je     100b09 <parse+0xaf>
  100aec:	8b 45 08             	mov    0x8(%ebp),%eax
  100aef:	0f b6 00             	movzbl (%eax),%eax
  100af2:	0f be c0             	movsbl %al,%eax
  100af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af9:	c7 04 24 d0 37 10 00 	movl   $0x1037d0,(%esp)
  100b00:	e8 46 27 00 00       	call   10324b <strchr>
  100b05:	85 c0                	test   %eax,%eax
  100b07:	74 d5                	je     100ade <parse+0x84>
            buf ++;
        }
    }
  100b09:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b0a:	e9 66 ff ff ff       	jmp    100a75 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b12:	c9                   	leave  
  100b13:	c3                   	ret    

00100b14 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b14:	55                   	push   %ebp
  100b15:	89 e5                	mov    %esp,%ebp
  100b17:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b1a:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b21:	8b 45 08             	mov    0x8(%ebp),%eax
  100b24:	89 04 24             	mov    %eax,(%esp)
  100b27:	e8 2e ff ff ff       	call   100a5a <parse>
  100b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b33:	75 0a                	jne    100b3f <runcmd+0x2b>
        return 0;
  100b35:	b8 00 00 00 00       	mov    $0x0,%eax
  100b3a:	e9 85 00 00 00       	jmp    100bc4 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b46:	eb 5c                	jmp    100ba4 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b48:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4e:	89 d0                	mov    %edx,%eax
  100b50:	01 c0                	add    %eax,%eax
  100b52:	01 d0                	add    %edx,%eax
  100b54:	c1 e0 02             	shl    $0x2,%eax
  100b57:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b5c:	8b 00                	mov    (%eax),%eax
  100b5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b62:	89 04 24             	mov    %eax,(%esp)
  100b65:	e8 42 26 00 00       	call   1031ac <strcmp>
  100b6a:	85 c0                	test   %eax,%eax
  100b6c:	75 32                	jne    100ba0 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b71:	89 d0                	mov    %edx,%eax
  100b73:	01 c0                	add    %eax,%eax
  100b75:	01 d0                	add    %edx,%eax
  100b77:	c1 e0 02             	shl    $0x2,%eax
  100b7a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b7f:	8b 40 08             	mov    0x8(%eax),%eax
  100b82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b85:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b8f:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b92:	83 c2 04             	add    $0x4,%edx
  100b95:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b99:	89 0c 24             	mov    %ecx,(%esp)
  100b9c:	ff d0                	call   *%eax
  100b9e:	eb 24                	jmp    100bc4 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba7:	83 f8 02             	cmp    $0x2,%eax
  100baa:	76 9c                	jbe    100b48 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb3:	c7 04 24 f3 37 10 00 	movl   $0x1037f3,(%esp)
  100bba:	e8 5e f7 ff ff       	call   10031d <cprintf>
    return 0;
  100bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc4:	c9                   	leave  
  100bc5:	c3                   	ret    

00100bc6 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bc6:	55                   	push   %ebp
  100bc7:	89 e5                	mov    %esp,%ebp
  100bc9:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bcc:	c7 04 24 0c 38 10 00 	movl   $0x10380c,(%esp)
  100bd3:	e8 45 f7 ff ff       	call   10031d <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd8:	c7 04 24 34 38 10 00 	movl   $0x103834,(%esp)
  100bdf:	e8 39 f7 ff ff       	call   10031d <cprintf>

    if (tf != NULL) {
  100be4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be8:	74 0b                	je     100bf5 <kmonitor+0x2f>
        print_trapframe(tf);
  100bea:	8b 45 08             	mov    0x8(%ebp),%eax
  100bed:	89 04 24             	mov    %eax,(%esp)
  100bf0:	e8 f3 0d 00 00       	call   1019e8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf5:	c7 04 24 59 38 10 00 	movl   $0x103859,(%esp)
  100bfc:	e8 13 f6 ff ff       	call   100214 <readline>
  100c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c08:	74 18                	je     100c22 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c14:	89 04 24             	mov    %eax,(%esp)
  100c17:	e8 f8 fe ff ff       	call   100b14 <runcmd>
  100c1c:	85 c0                	test   %eax,%eax
  100c1e:	79 02                	jns    100c22 <kmonitor+0x5c>
                break;
  100c20:	eb 02                	jmp    100c24 <kmonitor+0x5e>
            }
        }
    }
  100c22:	eb d1                	jmp    100bf5 <kmonitor+0x2f>
}
  100c24:	c9                   	leave  
  100c25:	c3                   	ret    

00100c26 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c26:	55                   	push   %ebp
  100c27:	89 e5                	mov    %esp,%ebp
  100c29:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c33:	eb 3f                	jmp    100c74 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c38:	89 d0                	mov    %edx,%eax
  100c3a:	01 c0                	add    %eax,%eax
  100c3c:	01 d0                	add    %edx,%eax
  100c3e:	c1 e0 02             	shl    $0x2,%eax
  100c41:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c46:	8b 48 04             	mov    0x4(%eax),%ecx
  100c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4c:	89 d0                	mov    %edx,%eax
  100c4e:	01 c0                	add    %eax,%eax
  100c50:	01 d0                	add    %edx,%eax
  100c52:	c1 e0 02             	shl    $0x2,%eax
  100c55:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c5a:	8b 00                	mov    (%eax),%eax
  100c5c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c64:	c7 04 24 5d 38 10 00 	movl   $0x10385d,(%esp)
  100c6b:	e8 ad f6 ff ff       	call   10031d <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c77:	83 f8 02             	cmp    $0x2,%eax
  100c7a:	76 b9                	jbe    100c35 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c81:	c9                   	leave  
  100c82:	c3                   	ret    

00100c83 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c83:	55                   	push   %ebp
  100c84:	89 e5                	mov    %esp,%ebp
  100c86:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c89:	e8 c3 fb ff ff       	call   100851 <print_kerninfo>
    return 0;
  100c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c93:	c9                   	leave  
  100c94:	c3                   	ret    

00100c95 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c95:	55                   	push   %ebp
  100c96:	89 e5                	mov    %esp,%ebp
  100c98:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c9b:	e8 fb fc ff ff       	call   10099b <print_stackframe>
    return 0;
  100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca5:	c9                   	leave  
  100ca6:	c3                   	ret    

00100ca7 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca7:	55                   	push   %ebp
  100ca8:	89 e5                	mov    %esp,%ebp
  100caa:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cad:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cb2:	85 c0                	test   %eax,%eax
  100cb4:	74 02                	je     100cb8 <__panic+0x11>
        goto panic_dead;
  100cb6:	eb 48                	jmp    100d00 <__panic+0x59>
    }
    is_panic = 1;
  100cb8:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cbf:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc2:	8d 45 14             	lea    0x14(%ebp),%eax
  100cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ccb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd6:	c7 04 24 66 38 10 00 	movl   $0x103866,(%esp)
  100cdd:	e8 3b f6 ff ff       	call   10031d <cprintf>
    vcprintf(fmt, ap);
  100ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  100cec:	89 04 24             	mov    %eax,(%esp)
  100cef:	e8 f6 f5 ff ff       	call   1002ea <vcprintf>
    cprintf("\n");
  100cf4:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  100cfb:	e8 1d f6 ff ff       	call   10031d <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d00:	e8 22 09 00 00       	call   101627 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d0c:	e8 b5 fe ff ff       	call   100bc6 <kmonitor>
    }
  100d11:	eb f2                	jmp    100d05 <__panic+0x5e>

00100d13 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d13:	55                   	push   %ebp
  100d14:	89 e5                	mov    %esp,%ebp
  100d16:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d19:	8d 45 14             	lea    0x14(%ebp),%eax
  100d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d22:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d26:	8b 45 08             	mov    0x8(%ebp),%eax
  100d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2d:	c7 04 24 84 38 10 00 	movl   $0x103884,(%esp)
  100d34:	e8 e4 f5 ff ff       	call   10031d <cprintf>
    vcprintf(fmt, ap);
  100d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d40:	8b 45 10             	mov    0x10(%ebp),%eax
  100d43:	89 04 24             	mov    %eax,(%esp)
  100d46:	e8 9f f5 ff ff       	call   1002ea <vcprintf>
    cprintf("\n");
  100d4b:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  100d52:	e8 c6 f5 ff ff       	call   10031d <cprintf>
    va_end(ap);
}
  100d57:	c9                   	leave  
  100d58:	c3                   	ret    

00100d59 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d59:	55                   	push   %ebp
  100d5a:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d5c:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d61:	5d                   	pop    %ebp
  100d62:	c3                   	ret    

00100d63 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d63:	55                   	push   %ebp
  100d64:	89 e5                	mov    %esp,%ebp
  100d66:	83 ec 28             	sub    $0x28,%esp
  100d69:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d6f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d73:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d77:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7b:	ee                   	out    %al,(%dx)
  100d7c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d82:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d86:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d8e:	ee                   	out    %al,(%dx)
  100d8f:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d95:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da1:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da2:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100da9:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dac:	c7 04 24 a2 38 10 00 	movl   $0x1038a2,(%esp)
  100db3:	e8 65 f5 ff ff       	call   10031d <cprintf>
    pic_enable(IRQ_TIMER);
  100db8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dbf:	e8 c1 08 00 00       	call   101685 <pic_enable>
}
  100dc4:	c9                   	leave  
  100dc5:	c3                   	ret    

00100dc6 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dc6:	55                   	push   %ebp
  100dc7:	89 e5                	mov    %esp,%ebp
  100dc9:	83 ec 10             	sub    $0x10,%esp
  100dcc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dd6:	89 c2                	mov    %eax,%edx
  100dd8:	ec                   	in     (%dx),%al
  100dd9:	88 45 fd             	mov    %al,-0x3(%ebp)
  100ddc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100de6:	89 c2                	mov    %eax,%edx
  100de8:	ec                   	in     (%dx),%al
  100de9:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dec:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100df2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100df6:	89 c2                	mov    %eax,%edx
  100df8:	ec                   	in     (%dx),%al
  100df9:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dfc:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e02:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e06:	89 c2                	mov    %eax,%edx
  100e08:	ec                   	in     (%dx),%al
  100e09:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e0c:	c9                   	leave  
  100e0d:	c3                   	ret    

00100e0e <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e0e:	55                   	push   %ebp
  100e0f:	89 e5                	mov    %esp,%ebp
  100e11:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e14:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1e:	0f b7 00             	movzwl (%eax),%eax
  100e21:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e28:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e30:	0f b7 00             	movzwl (%eax),%eax
  100e33:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e37:	74 12                	je     100e4b <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e39:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e40:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e47:	b4 03 
  100e49:	eb 13                	jmp    100e5e <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e52:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e55:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e5c:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e5e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e65:	0f b7 c0             	movzwl %ax,%eax
  100e68:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e6c:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e70:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e74:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e78:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e79:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e80:	83 c0 01             	add    $0x1,%eax
  100e83:	0f b7 c0             	movzwl %ax,%eax
  100e86:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e8a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e8e:	89 c2                	mov    %eax,%edx
  100e90:	ec                   	in     (%dx),%al
  100e91:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e94:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e98:	0f b6 c0             	movzbl %al,%eax
  100e9b:	c1 e0 08             	shl    $0x8,%eax
  100e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ea1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea8:	0f b7 c0             	movzwl %ax,%eax
  100eab:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eaf:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eb7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ebb:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ebc:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec3:	83 c0 01             	add    $0x1,%eax
  100ec6:	0f b7 c0             	movzwl %ax,%eax
  100ec9:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ecd:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ed1:	89 c2                	mov    %eax,%edx
  100ed3:	ec                   	in     (%dx),%al
  100ed4:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ed7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100edb:	0f b6 c0             	movzbl %al,%eax
  100ede:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee4:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100eec:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ef2:	c9                   	leave  
  100ef3:	c3                   	ret    

00100ef4 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ef4:	55                   	push   %ebp
  100ef5:	89 e5                	mov    %esp,%ebp
  100ef7:	83 ec 48             	sub    $0x48,%esp
  100efa:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f00:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f04:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f08:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f0c:	ee                   	out    %al,(%dx)
  100f0d:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f13:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f17:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f1b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f1f:	ee                   	out    %al,(%dx)
  100f20:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f26:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f2a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f32:	ee                   	out    %al,(%dx)
  100f33:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f39:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f3d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f41:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f45:	ee                   	out    %al,(%dx)
  100f46:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f4c:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f50:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f54:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f58:	ee                   	out    %al,(%dx)
  100f59:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f5f:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f63:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f67:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f6b:	ee                   	out    %al,(%dx)
  100f6c:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f72:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f76:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f7a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f7e:	ee                   	out    %al,(%dx)
  100f7f:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f85:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f89:	89 c2                	mov    %eax,%edx
  100f8b:	ec                   	in     (%dx),%al
  100f8c:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f8f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f93:	3c ff                	cmp    $0xff,%al
  100f95:	0f 95 c0             	setne  %al
  100f98:	0f b6 c0             	movzbl %al,%eax
  100f9b:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fa0:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fa6:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100faa:	89 c2                	mov    %eax,%edx
  100fac:	ec                   	in     (%dx),%al
  100fad:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fb0:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fb6:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fba:	89 c2                	mov    %eax,%edx
  100fbc:	ec                   	in     (%dx),%al
  100fbd:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fc0:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fc5:	85 c0                	test   %eax,%eax
  100fc7:	74 0c                	je     100fd5 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fc9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fd0:	e8 b0 06 00 00       	call   101685 <pic_enable>
    }
}
  100fd5:	c9                   	leave  
  100fd6:	c3                   	ret    

00100fd7 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fd7:	55                   	push   %ebp
  100fd8:	89 e5                	mov    %esp,%ebp
  100fda:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fe4:	eb 09                	jmp    100fef <lpt_putc_sub+0x18>
        delay();
  100fe6:	e8 db fd ff ff       	call   100dc6 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100feb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fef:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ff5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ff9:	89 c2                	mov    %eax,%edx
  100ffb:	ec                   	in     (%dx),%al
  100ffc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fff:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101003:	84 c0                	test   %al,%al
  101005:	78 09                	js     101010 <lpt_putc_sub+0x39>
  101007:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10100e:	7e d6                	jle    100fe6 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101010:	8b 45 08             	mov    0x8(%ebp),%eax
  101013:	0f b6 c0             	movzbl %al,%eax
  101016:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10101c:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10101f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101023:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101027:	ee                   	out    %al,(%dx)
  101028:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10102e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101032:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101036:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10103a:	ee                   	out    %al,(%dx)
  10103b:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101041:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101045:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101049:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10104d:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10104e:	c9                   	leave  
  10104f:	c3                   	ret    

00101050 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101050:	55                   	push   %ebp
  101051:	89 e5                	mov    %esp,%ebp
  101053:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101056:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10105a:	74 0d                	je     101069 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10105c:	8b 45 08             	mov    0x8(%ebp),%eax
  10105f:	89 04 24             	mov    %eax,(%esp)
  101062:	e8 70 ff ff ff       	call   100fd7 <lpt_putc_sub>
  101067:	eb 24                	jmp    10108d <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101069:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101070:	e8 62 ff ff ff       	call   100fd7 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101075:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10107c:	e8 56 ff ff ff       	call   100fd7 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101081:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101088:	e8 4a ff ff ff       	call   100fd7 <lpt_putc_sub>
    }
}
  10108d:	c9                   	leave  
  10108e:	c3                   	ret    

0010108f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10108f:	55                   	push   %ebp
  101090:	89 e5                	mov    %esp,%ebp
  101092:	53                   	push   %ebx
  101093:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101096:	8b 45 08             	mov    0x8(%ebp),%eax
  101099:	b0 00                	mov    $0x0,%al
  10109b:	85 c0                	test   %eax,%eax
  10109d:	75 07                	jne    1010a6 <cga_putc+0x17>
        c |= 0x0700;
  10109f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a9:	0f b6 c0             	movzbl %al,%eax
  1010ac:	83 f8 0a             	cmp    $0xa,%eax
  1010af:	74 4c                	je     1010fd <cga_putc+0x6e>
  1010b1:	83 f8 0d             	cmp    $0xd,%eax
  1010b4:	74 57                	je     10110d <cga_putc+0x7e>
  1010b6:	83 f8 08             	cmp    $0x8,%eax
  1010b9:	0f 85 88 00 00 00    	jne    101147 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010bf:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c6:	66 85 c0             	test   %ax,%ax
  1010c9:	74 30                	je     1010fb <cga_putc+0x6c>
            crt_pos --;
  1010cb:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d2:	83 e8 01             	sub    $0x1,%eax
  1010d5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010db:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010e0:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010e7:	0f b7 d2             	movzwl %dx,%edx
  1010ea:	01 d2                	add    %edx,%edx
  1010ec:	01 c2                	add    %eax,%edx
  1010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f1:	b0 00                	mov    $0x0,%al
  1010f3:	83 c8 20             	or     $0x20,%eax
  1010f6:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010f9:	eb 72                	jmp    10116d <cga_putc+0xde>
  1010fb:	eb 70                	jmp    10116d <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010fd:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101104:	83 c0 50             	add    $0x50,%eax
  101107:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10110d:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101114:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10111b:	0f b7 c1             	movzwl %cx,%eax
  10111e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101124:	c1 e8 10             	shr    $0x10,%eax
  101127:	89 c2                	mov    %eax,%edx
  101129:	66 c1 ea 06          	shr    $0x6,%dx
  10112d:	89 d0                	mov    %edx,%eax
  10112f:	c1 e0 02             	shl    $0x2,%eax
  101132:	01 d0                	add    %edx,%eax
  101134:	c1 e0 04             	shl    $0x4,%eax
  101137:	29 c1                	sub    %eax,%ecx
  101139:	89 ca                	mov    %ecx,%edx
  10113b:	89 d8                	mov    %ebx,%eax
  10113d:	29 d0                	sub    %edx,%eax
  10113f:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101145:	eb 26                	jmp    10116d <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101147:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10114d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101154:	8d 50 01             	lea    0x1(%eax),%edx
  101157:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10115e:	0f b7 c0             	movzwl %ax,%eax
  101161:	01 c0                	add    %eax,%eax
  101163:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101166:	8b 45 08             	mov    0x8(%ebp),%eax
  101169:	66 89 02             	mov    %ax,(%edx)
        break;
  10116c:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10116d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101174:	66 3d cf 07          	cmp    $0x7cf,%ax
  101178:	76 5b                	jbe    1011d5 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10117a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101185:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118a:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101191:	00 
  101192:	89 54 24 04          	mov    %edx,0x4(%esp)
  101196:	89 04 24             	mov    %eax,(%esp)
  101199:	e8 ab 22 00 00       	call   103449 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119e:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011a5:	eb 15                	jmp    1011bc <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011a7:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011af:	01 d2                	add    %edx,%edx
  1011b1:	01 d0                	add    %edx,%eax
  1011b3:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011bc:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011c3:	7e e2                	jle    1011a7 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011c5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011cc:	83 e8 50             	sub    $0x50,%eax
  1011cf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011d5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011dc:	0f b7 c0             	movzwl %ax,%eax
  1011df:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011e3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011e7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011eb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011ef:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011f0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011f7:	66 c1 e8 08          	shr    $0x8,%ax
  1011fb:	0f b6 c0             	movzbl %al,%eax
  1011fe:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101205:	83 c2 01             	add    $0x1,%edx
  101208:	0f b7 d2             	movzwl %dx,%edx
  10120b:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10120f:	88 45 ed             	mov    %al,-0x13(%ebp)
  101212:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101216:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10121a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10121b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101222:	0f b7 c0             	movzwl %ax,%eax
  101225:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101229:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10122d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101231:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101235:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101236:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10123d:	0f b6 c0             	movzbl %al,%eax
  101240:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101247:	83 c2 01             	add    $0x1,%edx
  10124a:	0f b7 d2             	movzwl %dx,%edx
  10124d:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101251:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101254:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101258:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10125c:	ee                   	out    %al,(%dx)
}
  10125d:	83 c4 34             	add    $0x34,%esp
  101260:	5b                   	pop    %ebx
  101261:	5d                   	pop    %ebp
  101262:	c3                   	ret    

00101263 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101263:	55                   	push   %ebp
  101264:	89 e5                	mov    %esp,%ebp
  101266:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101270:	eb 09                	jmp    10127b <serial_putc_sub+0x18>
        delay();
  101272:	e8 4f fb ff ff       	call   100dc6 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101277:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10127b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101281:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101285:	89 c2                	mov    %eax,%edx
  101287:	ec                   	in     (%dx),%al
  101288:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10128b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10128f:	0f b6 c0             	movzbl %al,%eax
  101292:	83 e0 20             	and    $0x20,%eax
  101295:	85 c0                	test   %eax,%eax
  101297:	75 09                	jne    1012a2 <serial_putc_sub+0x3f>
  101299:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a0:	7e d0                	jle    101272 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a5:	0f b6 c0             	movzbl %al,%eax
  1012a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012ae:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012b5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012b9:	ee                   	out    %al,(%dx)
}
  1012ba:	c9                   	leave  
  1012bb:	c3                   	ret    

001012bc <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012bc:	55                   	push   %ebp
  1012bd:	89 e5                	mov    %esp,%ebp
  1012bf:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c6:	74 0d                	je     1012d5 <serial_putc+0x19>
        serial_putc_sub(c);
  1012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012cb:	89 04 24             	mov    %eax,(%esp)
  1012ce:	e8 90 ff ff ff       	call   101263 <serial_putc_sub>
  1012d3:	eb 24                	jmp    1012f9 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012d5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012dc:	e8 82 ff ff ff       	call   101263 <serial_putc_sub>
        serial_putc_sub(' ');
  1012e1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012e8:	e8 76 ff ff ff       	call   101263 <serial_putc_sub>
        serial_putc_sub('\b');
  1012ed:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f4:	e8 6a ff ff ff       	call   101263 <serial_putc_sub>
    }
}
  1012f9:	c9                   	leave  
  1012fa:	c3                   	ret    

001012fb <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012fb:	55                   	push   %ebp
  1012fc:	89 e5                	mov    %esp,%ebp
  1012fe:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101301:	eb 33                	jmp    101336 <cons_intr+0x3b>
        if (c != 0) {
  101303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101307:	74 2d                	je     101336 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101309:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10130e:	8d 50 01             	lea    0x1(%eax),%edx
  101311:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10131a:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101320:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101325:	3d 00 02 00 00       	cmp    $0x200,%eax
  10132a:	75 0a                	jne    101336 <cons_intr+0x3b>
                cons.wpos = 0;
  10132c:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101333:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101336:	8b 45 08             	mov    0x8(%ebp),%eax
  101339:	ff d0                	call   *%eax
  10133b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10133e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101342:	75 bf                	jne    101303 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101344:	c9                   	leave  
  101345:	c3                   	ret    

00101346 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101346:	55                   	push   %ebp
  101347:	89 e5                	mov    %esp,%ebp
  101349:	83 ec 10             	sub    $0x10,%esp
  10134c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101352:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101356:	89 c2                	mov    %eax,%edx
  101358:	ec                   	in     (%dx),%al
  101359:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10135c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101360:	0f b6 c0             	movzbl %al,%eax
  101363:	83 e0 01             	and    $0x1,%eax
  101366:	85 c0                	test   %eax,%eax
  101368:	75 07                	jne    101371 <serial_proc_data+0x2b>
        return -1;
  10136a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10136f:	eb 2a                	jmp    10139b <serial_proc_data+0x55>
  101371:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101377:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10137b:	89 c2                	mov    %eax,%edx
  10137d:	ec                   	in     (%dx),%al
  10137e:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101381:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101385:	0f b6 c0             	movzbl %al,%eax
  101388:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10138b:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10138f:	75 07                	jne    101398 <serial_proc_data+0x52>
        c = '\b';
  101391:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10139b:	c9                   	leave  
  10139c:	c3                   	ret    

0010139d <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10139d:	55                   	push   %ebp
  10139e:	89 e5                	mov    %esp,%ebp
  1013a0:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013a3:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013a8:	85 c0                	test   %eax,%eax
  1013aa:	74 0c                	je     1013b8 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013ac:	c7 04 24 46 13 10 00 	movl   $0x101346,(%esp)
  1013b3:	e8 43 ff ff ff       	call   1012fb <cons_intr>
    }
}
  1013b8:	c9                   	leave  
  1013b9:	c3                   	ret    

001013ba <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ba:	55                   	push   %ebp
  1013bb:	89 e5                	mov    %esp,%ebp
  1013bd:	83 ec 38             	sub    $0x38,%esp
  1013c0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013ca:	89 c2                	mov    %eax,%edx
  1013cc:	ec                   	in     (%dx),%al
  1013cd:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013d4:	0f b6 c0             	movzbl %al,%eax
  1013d7:	83 e0 01             	and    $0x1,%eax
  1013da:	85 c0                	test   %eax,%eax
  1013dc:	75 0a                	jne    1013e8 <kbd_proc_data+0x2e>
        return -1;
  1013de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e3:	e9 59 01 00 00       	jmp    101541 <kbd_proc_data+0x187>
  1013e8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f2:	89 c2                	mov    %eax,%edx
  1013f4:	ec                   	in     (%dx),%al
  1013f5:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013f8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013fc:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013ff:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101403:	75 17                	jne    10141c <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101405:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140a:	83 c8 40             	or     $0x40,%eax
  10140d:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101412:	b8 00 00 00 00       	mov    $0x0,%eax
  101417:	e9 25 01 00 00       	jmp    101541 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10141c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101420:	84 c0                	test   %al,%al
  101422:	79 47                	jns    10146b <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101424:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101429:	83 e0 40             	and    $0x40,%eax
  10142c:	85 c0                	test   %eax,%eax
  10142e:	75 09                	jne    101439 <kbd_proc_data+0x7f>
  101430:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101434:	83 e0 7f             	and    $0x7f,%eax
  101437:	eb 04                	jmp    10143d <kbd_proc_data+0x83>
  101439:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101440:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101444:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10144b:	83 c8 40             	or     $0x40,%eax
  10144e:	0f b6 c0             	movzbl %al,%eax
  101451:	f7 d0                	not    %eax
  101453:	89 c2                	mov    %eax,%edx
  101455:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145a:	21 d0                	and    %edx,%eax
  10145c:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101461:	b8 00 00 00 00       	mov    $0x0,%eax
  101466:	e9 d6 00 00 00       	jmp    101541 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10146b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101470:	83 e0 40             	and    $0x40,%eax
  101473:	85 c0                	test   %eax,%eax
  101475:	74 11                	je     101488 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101477:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10147b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101480:	83 e0 bf             	and    $0xffffffbf,%eax
  101483:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101488:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148c:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101493:	0f b6 d0             	movzbl %al,%edx
  101496:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149b:	09 d0                	or     %edx,%eax
  10149d:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a6:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014ad:	0f b6 d0             	movzbl %al,%edx
  1014b0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b5:	31 d0                	xor    %edx,%eax
  1014b7:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014bc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c1:	83 e0 03             	and    $0x3,%eax
  1014c4:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014cb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014cf:	01 d0                	add    %edx,%eax
  1014d1:	0f b6 00             	movzbl (%eax),%eax
  1014d4:	0f b6 c0             	movzbl %al,%eax
  1014d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014da:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014df:	83 e0 08             	and    $0x8,%eax
  1014e2:	85 c0                	test   %eax,%eax
  1014e4:	74 22                	je     101508 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014e6:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014ea:	7e 0c                	jle    1014f8 <kbd_proc_data+0x13e>
  1014ec:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f0:	7f 06                	jg     1014f8 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f2:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f6:	eb 10                	jmp    101508 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014f8:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014fc:	7e 0a                	jle    101508 <kbd_proc_data+0x14e>
  1014fe:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101502:	7f 04                	jg     101508 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101504:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101508:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10150d:	f7 d0                	not    %eax
  10150f:	83 e0 06             	and    $0x6,%eax
  101512:	85 c0                	test   %eax,%eax
  101514:	75 28                	jne    10153e <kbd_proc_data+0x184>
  101516:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10151d:	75 1f                	jne    10153e <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10151f:	c7 04 24 bd 38 10 00 	movl   $0x1038bd,(%esp)
  101526:	e8 f2 ed ff ff       	call   10031d <cprintf>
  10152b:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101531:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101535:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101539:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10153d:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10153e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101541:	c9                   	leave  
  101542:	c3                   	ret    

00101543 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101543:	55                   	push   %ebp
  101544:	89 e5                	mov    %esp,%ebp
  101546:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101549:	c7 04 24 ba 13 10 00 	movl   $0x1013ba,(%esp)
  101550:	e8 a6 fd ff ff       	call   1012fb <cons_intr>
}
  101555:	c9                   	leave  
  101556:	c3                   	ret    

00101557 <kbd_init>:

static void
kbd_init(void) {
  101557:	55                   	push   %ebp
  101558:	89 e5                	mov    %esp,%ebp
  10155a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10155d:	e8 e1 ff ff ff       	call   101543 <kbd_intr>
    pic_enable(IRQ_KBD);
  101562:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101569:	e8 17 01 00 00       	call   101685 <pic_enable>
}
  10156e:	c9                   	leave  
  10156f:	c3                   	ret    

00101570 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101570:	55                   	push   %ebp
  101571:	89 e5                	mov    %esp,%ebp
  101573:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101576:	e8 93 f8 ff ff       	call   100e0e <cga_init>
    serial_init();
  10157b:	e8 74 f9 ff ff       	call   100ef4 <serial_init>
    kbd_init();
  101580:	e8 d2 ff ff ff       	call   101557 <kbd_init>
    if (!serial_exists) {
  101585:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10158a:	85 c0                	test   %eax,%eax
  10158c:	75 0c                	jne    10159a <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10158e:	c7 04 24 c9 38 10 00 	movl   $0x1038c9,(%esp)
  101595:	e8 83 ed ff ff       	call   10031d <cprintf>
    }
}
  10159a:	c9                   	leave  
  10159b:	c3                   	ret    

0010159c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10159c:	55                   	push   %ebp
  10159d:	89 e5                	mov    %esp,%ebp
  10159f:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a5:	89 04 24             	mov    %eax,(%esp)
  1015a8:	e8 a3 fa ff ff       	call   101050 <lpt_putc>
    cga_putc(c);
  1015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b0:	89 04 24             	mov    %eax,(%esp)
  1015b3:	e8 d7 fa ff ff       	call   10108f <cga_putc>
    serial_putc(c);
  1015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bb:	89 04 24             	mov    %eax,(%esp)
  1015be:	e8 f9 fc ff ff       	call   1012bc <serial_putc>
}
  1015c3:	c9                   	leave  
  1015c4:	c3                   	ret    

001015c5 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015c5:	55                   	push   %ebp
  1015c6:	89 e5                	mov    %esp,%ebp
  1015c8:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015cb:	e8 cd fd ff ff       	call   10139d <serial_intr>
    kbd_intr();
  1015d0:	e8 6e ff ff ff       	call   101543 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015d5:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015db:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015e0:	39 c2                	cmp    %eax,%edx
  1015e2:	74 36                	je     10161a <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015e4:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e9:	8d 50 01             	lea    0x1(%eax),%edx
  1015ec:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015f2:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f9:	0f b6 c0             	movzbl %al,%eax
  1015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015ff:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101604:	3d 00 02 00 00       	cmp    $0x200,%eax
  101609:	75 0a                	jne    101615 <cons_getc+0x50>
            cons.rpos = 0;
  10160b:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101612:	00 00 00 
        }
        return c;
  101615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101618:	eb 05                	jmp    10161f <cons_getc+0x5a>
    }
    return 0;
  10161a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10161f:	c9                   	leave  
  101620:	c3                   	ret    

00101621 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101621:	55                   	push   %ebp
  101622:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101624:	fb                   	sti    
    sti();
}
  101625:	5d                   	pop    %ebp
  101626:	c3                   	ret    

00101627 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101627:	55                   	push   %ebp
  101628:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10162a:	fa                   	cli    
    cli();
}
  10162b:	5d                   	pop    %ebp
  10162c:	c3                   	ret    

0010162d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10162d:	55                   	push   %ebp
  10162e:	89 e5                	mov    %esp,%ebp
  101630:	83 ec 14             	sub    $0x14,%esp
  101633:	8b 45 08             	mov    0x8(%ebp),%eax
  101636:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10163a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163e:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101644:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101649:	85 c0                	test   %eax,%eax
  10164b:	74 36                	je     101683 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10164d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101651:	0f b6 c0             	movzbl %al,%eax
  101654:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10165a:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10165d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101661:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101665:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101666:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10166a:	66 c1 e8 08          	shr    $0x8,%ax
  10166e:	0f b6 c0             	movzbl %al,%eax
  101671:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101677:	88 45 f9             	mov    %al,-0x7(%ebp)
  10167a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10167e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101682:	ee                   	out    %al,(%dx)
    }
}
  101683:	c9                   	leave  
  101684:	c3                   	ret    

00101685 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101685:	55                   	push   %ebp
  101686:	89 e5                	mov    %esp,%ebp
  101688:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10168b:	8b 45 08             	mov    0x8(%ebp),%eax
  10168e:	ba 01 00 00 00       	mov    $0x1,%edx
  101693:	89 c1                	mov    %eax,%ecx
  101695:	d3 e2                	shl    %cl,%edx
  101697:	89 d0                	mov    %edx,%eax
  101699:	f7 d0                	not    %eax
  10169b:	89 c2                	mov    %eax,%edx
  10169d:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a4:	21 d0                	and    %edx,%eax
  1016a6:	0f b7 c0             	movzwl %ax,%eax
  1016a9:	89 04 24             	mov    %eax,(%esp)
  1016ac:	e8 7c ff ff ff       	call   10162d <pic_setmask>
}
  1016b1:	c9                   	leave  
  1016b2:	c3                   	ret    

001016b3 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b3:	55                   	push   %ebp
  1016b4:	89 e5                	mov    %esp,%ebp
  1016b6:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016b9:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016c0:	00 00 00 
  1016c3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c9:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016cd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016d1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d5:	ee                   	out    %al,(%dx)
  1016d6:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016dc:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016e4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e8:	ee                   	out    %al,(%dx)
  1016e9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016ef:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016f3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016f7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016fb:	ee                   	out    %al,(%dx)
  1016fc:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101702:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101706:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10170a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10170e:	ee                   	out    %al,(%dx)
  10170f:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101715:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101719:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10171d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101721:	ee                   	out    %al,(%dx)
  101722:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101728:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10172c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101730:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101734:	ee                   	out    %al,(%dx)
  101735:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10173b:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10173f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101743:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101747:	ee                   	out    %al,(%dx)
  101748:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10174e:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101752:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101756:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10175a:	ee                   	out    %al,(%dx)
  10175b:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101761:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101765:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101769:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10176d:	ee                   	out    %al,(%dx)
  10176e:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101774:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101778:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10177c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101780:	ee                   	out    %al,(%dx)
  101781:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101787:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10178b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10178f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101793:	ee                   	out    %al,(%dx)
  101794:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10179a:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10179e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a2:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a6:	ee                   	out    %al,(%dx)
  1017a7:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017ad:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017b1:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017b5:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017b9:	ee                   	out    %al,(%dx)
  1017ba:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017c0:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017c4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c8:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017cc:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017cd:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d4:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d8:	74 12                	je     1017ec <pic_init+0x139>
        pic_setmask(irq_mask);
  1017da:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e1:	0f b7 c0             	movzwl %ax,%eax
  1017e4:	89 04 24             	mov    %eax,(%esp)
  1017e7:	e8 41 fe ff ff       	call   10162d <pic_setmask>
    }
}
  1017ec:	c9                   	leave  
  1017ed:	c3                   	ret    

001017ee <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1017ee:	55                   	push   %ebp
  1017ef:	89 e5                	mov    %esp,%ebp
  1017f1:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f4:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017fb:	00 
  1017fc:	c7 04 24 00 39 10 00 	movl   $0x103900,(%esp)
  101803:	e8 15 eb ff ff       	call   10031d <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101808:	c7 04 24 0a 39 10 00 	movl   $0x10390a,(%esp)
  10180f:	e8 09 eb ff ff       	call   10031d <cprintf>
    panic("EOT: kernel seems ok.");
  101814:	c7 44 24 08 18 39 10 	movl   $0x103918,0x8(%esp)
  10181b:	00 
  10181c:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101823:	00 
  101824:	c7 04 24 2e 39 10 00 	movl   $0x10392e,(%esp)
  10182b:	e8 77 f4 ff ff       	call   100ca7 <__panic>

00101830 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101830:	55                   	push   %ebp
  101831:	89 e5                	mov    %esp,%ebp
  101833:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10183d:	e9 c3 00 00 00       	jmp    101905 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101845:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10184c:	89 c2                	mov    %eax,%edx
  10184e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101851:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101858:	00 
  101859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185c:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101863:	00 08 00 
  101866:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101869:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101870:	00 
  101871:	83 e2 e0             	and    $0xffffffe0,%edx
  101874:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10187b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187e:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101885:	00 
  101886:	83 e2 1f             	and    $0x1f,%edx
  101889:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101890:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101893:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189a:	00 
  10189b:	83 e2 f0             	and    $0xfffffff0,%edx
  10189e:	83 ca 0e             	or     $0xe,%edx
  1018a1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ab:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b2:	00 
  1018b3:	83 e2 ef             	and    $0xffffffef,%edx
  1018b6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c0:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c7:	00 
  1018c8:	83 e2 9f             	and    $0xffffff9f,%edx
  1018cb:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d5:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018dc:	00 
  1018dd:	83 ca 80             	or     $0xffffff80,%edx
  1018e0:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ea:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f1:	c1 e8 10             	shr    $0x10,%eax
  1018f4:	89 c2                	mov    %eax,%edx
  1018f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f9:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101900:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101901:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101905:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101908:	3d ff 00 00 00       	cmp    $0xff,%eax
  10190d:	0f 86 2f ff ff ff    	jbe    101842 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101913:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101918:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  10191e:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101925:	08 00 
  101927:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10192e:	83 e0 e0             	and    $0xffffffe0,%eax
  101931:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101936:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10193d:	83 e0 1f             	and    $0x1f,%eax
  101940:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101945:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194c:	83 e0 f0             	and    $0xfffffff0,%eax
  10194f:	83 c8 0e             	or     $0xe,%eax
  101952:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101957:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10195e:	83 e0 ef             	and    $0xffffffef,%eax
  101961:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101966:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10196d:	83 c8 60             	or     $0x60,%eax
  101970:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101975:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10197c:	83 c8 80             	or     $0xffffff80,%eax
  10197f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101984:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101989:	c1 e8 10             	shr    $0x10,%eax
  10198c:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101992:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101999:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10199c:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  10199f:	c9                   	leave  
  1019a0:	c3                   	ret    

001019a1 <trapname>:

static const char *
trapname(int trapno) {
  1019a1:	55                   	push   %ebp
  1019a2:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a7:	83 f8 13             	cmp    $0x13,%eax
  1019aa:	77 0c                	ja     1019b8 <trapname+0x17>
        return excnames[trapno];
  1019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1019af:	8b 04 85 80 3c 10 00 	mov    0x103c80(,%eax,4),%eax
  1019b6:	eb 18                	jmp    1019d0 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019b8:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019bc:	7e 0d                	jle    1019cb <trapname+0x2a>
  1019be:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019c2:	7f 07                	jg     1019cb <trapname+0x2a>
        return "Hardware Interrupt";
  1019c4:	b8 3f 39 10 00       	mov    $0x10393f,%eax
  1019c9:	eb 05                	jmp    1019d0 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019cb:	b8 52 39 10 00       	mov    $0x103952,%eax
}
  1019d0:	5d                   	pop    %ebp
  1019d1:	c3                   	ret    

001019d2 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019d2:	55                   	push   %ebp
  1019d3:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019dc:	66 83 f8 08          	cmp    $0x8,%ax
  1019e0:	0f 94 c0             	sete   %al
  1019e3:	0f b6 c0             	movzbl %al,%eax
}
  1019e6:	5d                   	pop    %ebp
  1019e7:	c3                   	ret    

001019e8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019e8:	55                   	push   %ebp
  1019e9:	89 e5                	mov    %esp,%ebp
  1019eb:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f5:	c7 04 24 93 39 10 00 	movl   $0x103993,(%esp)
  1019fc:	e8 1c e9 ff ff       	call   10031d <cprintf>
    print_regs(&tf->tf_regs);
  101a01:	8b 45 08             	mov    0x8(%ebp),%eax
  101a04:	89 04 24             	mov    %eax,(%esp)
  101a07:	e8 a1 01 00 00       	call   101bad <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a13:	0f b7 c0             	movzwl %ax,%eax
  101a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1a:	c7 04 24 a4 39 10 00 	movl   $0x1039a4,(%esp)
  101a21:	e8 f7 e8 ff ff       	call   10031d <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a26:	8b 45 08             	mov    0x8(%ebp),%eax
  101a29:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a2d:	0f b7 c0             	movzwl %ax,%eax
  101a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a34:	c7 04 24 b7 39 10 00 	movl   $0x1039b7,(%esp)
  101a3b:	e8 dd e8 ff ff       	call   10031d <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a40:	8b 45 08             	mov    0x8(%ebp),%eax
  101a43:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a47:	0f b7 c0             	movzwl %ax,%eax
  101a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a4e:	c7 04 24 ca 39 10 00 	movl   $0x1039ca,(%esp)
  101a55:	e8 c3 e8 ff ff       	call   10031d <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a61:	0f b7 c0             	movzwl %ax,%eax
  101a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a68:	c7 04 24 dd 39 10 00 	movl   $0x1039dd,(%esp)
  101a6f:	e8 a9 e8 ff ff       	call   10031d <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a74:	8b 45 08             	mov    0x8(%ebp),%eax
  101a77:	8b 40 30             	mov    0x30(%eax),%eax
  101a7a:	89 04 24             	mov    %eax,(%esp)
  101a7d:	e8 1f ff ff ff       	call   1019a1 <trapname>
  101a82:	8b 55 08             	mov    0x8(%ebp),%edx
  101a85:	8b 52 30             	mov    0x30(%edx),%edx
  101a88:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a8c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a90:	c7 04 24 f0 39 10 00 	movl   $0x1039f0,(%esp)
  101a97:	e8 81 e8 ff ff       	call   10031d <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9f:	8b 40 34             	mov    0x34(%eax),%eax
  101aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa6:	c7 04 24 02 3a 10 00 	movl   $0x103a02,(%esp)
  101aad:	e8 6b e8 ff ff       	call   10031d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	8b 40 38             	mov    0x38(%eax),%eax
  101ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abc:	c7 04 24 11 3a 10 00 	movl   $0x103a11,(%esp)
  101ac3:	e8 55 e8 ff ff       	call   10031d <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  101acb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101acf:	0f b7 c0             	movzwl %ax,%eax
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	c7 04 24 20 3a 10 00 	movl   $0x103a20,(%esp)
  101add:	e8 3b e8 ff ff       	call   10031d <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae5:	8b 40 40             	mov    0x40(%eax),%eax
  101ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aec:	c7 04 24 33 3a 10 00 	movl   $0x103a33,(%esp)
  101af3:	e8 25 e8 ff ff       	call   10031d <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101af8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101aff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b06:	eb 3e                	jmp    101b46 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b08:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0b:	8b 50 40             	mov    0x40(%eax),%edx
  101b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b11:	21 d0                	and    %edx,%eax
  101b13:	85 c0                	test   %eax,%eax
  101b15:	74 28                	je     101b3f <print_trapframe+0x157>
  101b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b1a:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b21:	85 c0                	test   %eax,%eax
  101b23:	74 1a                	je     101b3f <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b28:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b33:	c7 04 24 42 3a 10 00 	movl   $0x103a42,(%esp)
  101b3a:	e8 de e7 ff ff       	call   10031d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b43:	d1 65 f0             	shll   -0x10(%ebp)
  101b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b49:	83 f8 17             	cmp    $0x17,%eax
  101b4c:	76 ba                	jbe    101b08 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b51:	8b 40 40             	mov    0x40(%eax),%eax
  101b54:	25 00 30 00 00       	and    $0x3000,%eax
  101b59:	c1 e8 0c             	shr    $0xc,%eax
  101b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b60:	c7 04 24 46 3a 10 00 	movl   $0x103a46,(%esp)
  101b67:	e8 b1 e7 ff ff       	call   10031d <cprintf>

    if (!trap_in_kernel(tf)) {
  101b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6f:	89 04 24             	mov    %eax,(%esp)
  101b72:	e8 5b fe ff ff       	call   1019d2 <trap_in_kernel>
  101b77:	85 c0                	test   %eax,%eax
  101b79:	75 30                	jne    101bab <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7e:	8b 40 44             	mov    0x44(%eax),%eax
  101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b85:	c7 04 24 4f 3a 10 00 	movl   $0x103a4f,(%esp)
  101b8c:	e8 8c e7 ff ff       	call   10031d <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b91:	8b 45 08             	mov    0x8(%ebp),%eax
  101b94:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b98:	0f b7 c0             	movzwl %ax,%eax
  101b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9f:	c7 04 24 5e 3a 10 00 	movl   $0x103a5e,(%esp)
  101ba6:	e8 72 e7 ff ff       	call   10031d <cprintf>
    }
}
  101bab:	c9                   	leave  
  101bac:	c3                   	ret    

00101bad <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bad:	55                   	push   %ebp
  101bae:	89 e5                	mov    %esp,%ebp
  101bb0:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb6:	8b 00                	mov    (%eax),%eax
  101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbc:	c7 04 24 71 3a 10 00 	movl   $0x103a71,(%esp)
  101bc3:	e8 55 e7 ff ff       	call   10031d <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	8b 40 04             	mov    0x4(%eax),%eax
  101bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd2:	c7 04 24 80 3a 10 00 	movl   $0x103a80,(%esp)
  101bd9:	e8 3f e7 ff ff       	call   10031d <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bde:	8b 45 08             	mov    0x8(%ebp),%eax
  101be1:	8b 40 08             	mov    0x8(%eax),%eax
  101be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be8:	c7 04 24 8f 3a 10 00 	movl   $0x103a8f,(%esp)
  101bef:	e8 29 e7 ff ff       	call   10031d <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  101bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfe:	c7 04 24 9e 3a 10 00 	movl   $0x103a9e,(%esp)
  101c05:	e8 13 e7 ff ff       	call   10031d <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0d:	8b 40 10             	mov    0x10(%eax),%eax
  101c10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c14:	c7 04 24 ad 3a 10 00 	movl   $0x103aad,(%esp)
  101c1b:	e8 fd e6 ff ff       	call   10031d <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c20:	8b 45 08             	mov    0x8(%ebp),%eax
  101c23:	8b 40 14             	mov    0x14(%eax),%eax
  101c26:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2a:	c7 04 24 bc 3a 10 00 	movl   $0x103abc,(%esp)
  101c31:	e8 e7 e6 ff ff       	call   10031d <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c36:	8b 45 08             	mov    0x8(%ebp),%eax
  101c39:	8b 40 18             	mov    0x18(%eax),%eax
  101c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c40:	c7 04 24 cb 3a 10 00 	movl   $0x103acb,(%esp)
  101c47:	e8 d1 e6 ff ff       	call   10031d <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4f:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c56:	c7 04 24 da 3a 10 00 	movl   $0x103ada,(%esp)
  101c5d:	e8 bb e6 ff ff       	call   10031d <cprintf>
}
  101c62:	c9                   	leave  
  101c63:	c3                   	ret    

00101c64 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c64:	55                   	push   %ebp
  101c65:	89 e5                	mov    %esp,%ebp
  101c67:	57                   	push   %edi
  101c68:	56                   	push   %esi
  101c69:	53                   	push   %ebx
  101c6a:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 30             	mov    0x30(%eax),%eax
  101c73:	83 f8 2f             	cmp    $0x2f,%eax
  101c76:	77 21                	ja     101c99 <trap_dispatch+0x35>
  101c78:	83 f8 2e             	cmp    $0x2e,%eax
  101c7b:	0f 83 ec 01 00 00    	jae    101e6d <trap_dispatch+0x209>
  101c81:	83 f8 21             	cmp    $0x21,%eax
  101c84:	0f 84 8a 00 00 00    	je     101d14 <trap_dispatch+0xb0>
  101c8a:	83 f8 24             	cmp    $0x24,%eax
  101c8d:	74 5c                	je     101ceb <trap_dispatch+0x87>
  101c8f:	83 f8 20             	cmp    $0x20,%eax
  101c92:	74 1c                	je     101cb0 <trap_dispatch+0x4c>
  101c94:	e9 9c 01 00 00       	jmp    101e35 <trap_dispatch+0x1d1>
  101c99:	83 f8 78             	cmp    $0x78,%eax
  101c9c:	0f 84 9b 00 00 00    	je     101d3d <trap_dispatch+0xd9>
  101ca2:	83 f8 79             	cmp    $0x79,%eax
  101ca5:	0f 84 11 01 00 00    	je     101dbc <trap_dispatch+0x158>
  101cab:	e9 85 01 00 00       	jmp    101e35 <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101cb0:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cb5:	83 c0 01             	add    $0x1,%eax
  101cb8:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101cbd:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cc3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cc8:	89 c8                	mov    %ecx,%eax
  101cca:	f7 e2                	mul    %edx
  101ccc:	89 d0                	mov    %edx,%eax
  101cce:	c1 e8 05             	shr    $0x5,%eax
  101cd1:	6b c0 64             	imul   $0x64,%eax,%eax
  101cd4:	29 c1                	sub    %eax,%ecx
  101cd6:	89 c8                	mov    %ecx,%eax
  101cd8:	85 c0                	test   %eax,%eax
  101cda:	75 0a                	jne    101ce6 <trap_dispatch+0x82>
            print_ticks();
  101cdc:	e8 0d fb ff ff       	call   1017ee <print_ticks>
        }
        break;
  101ce1:	e9 88 01 00 00       	jmp    101e6e <trap_dispatch+0x20a>
  101ce6:	e9 83 01 00 00       	jmp    101e6e <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ceb:	e8 d5 f8 ff ff       	call   1015c5 <cons_getc>
  101cf0:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cf3:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101cf7:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 e9 3a 10 00 	movl   $0x103ae9,(%esp)
  101d0a:	e8 0e e6 ff ff       	call   10031d <cprintf>
        break;
  101d0f:	e9 5a 01 00 00       	jmp    101e6e <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d14:	e8 ac f8 ff ff       	call   1015c5 <cons_getc>
  101d19:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d1c:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d20:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d24:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2c:	c7 04 24 fb 3a 10 00 	movl   $0x103afb,(%esp)
  101d33:	e8 e5 e5 ff ff       	call   10031d <cprintf>
        break;
  101d38:	e9 31 01 00 00       	jmp    101e6e <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d40:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d44:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d48:	74 6d                	je     101db7 <trap_dispatch+0x153>
            switchk2u = *tf;
  101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4d:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101d52:	89 c3                	mov    %eax,%ebx
  101d54:	b8 13 00 00 00       	mov    $0x13,%eax
  101d59:	89 d7                	mov    %edx,%edi
  101d5b:	89 de                	mov    %ebx,%esi
  101d5d:	89 c1                	mov    %eax,%ecx
  101d5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d61:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d68:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d6a:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101d71:	23 00 
  101d73:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101d7a:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101d80:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101d87:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d90:	83 c0 44             	add    $0x44,%eax
  101d93:	a3 64 f9 10 00       	mov    %eax,0x10f964

            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101d98:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101d9d:	80 cc 30             	or     $0x30,%ah
  101da0:	a3 60 f9 10 00       	mov    %eax,0x10f960

            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101da5:	8b 45 08             	mov    0x8(%ebp),%eax
  101da8:	8d 50 fc             	lea    -0x4(%eax),%edx
  101dab:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101db0:	89 02                	mov    %eax,(%edx)
        }
        break;
  101db2:	e9 b7 00 00 00       	jmp    101e6e <trap_dispatch+0x20a>
  101db7:	e9 b2 00 00 00       	jmp    101e6e <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dc3:	66 83 f8 08          	cmp    $0x8,%ax
  101dc7:	74 6a                	je     101e33 <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
  101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcc:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd5:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dde:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101de2:	8b 45 08             	mov    0x8(%ebp),%eax
  101de5:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101de9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dec:	8b 40 40             	mov    0x40(%eax),%eax
  101def:	80 e4 cf             	and    $0xcf,%ah
  101df2:	89 c2                	mov    %eax,%edx
  101df4:	8b 45 08             	mov    0x8(%ebp),%eax
  101df7:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfd:	8b 40 44             	mov    0x44(%eax),%eax
  101e00:	83 e8 44             	sub    $0x44,%eax
  101e03:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e08:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e0d:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e14:	00 
  101e15:	8b 55 08             	mov    0x8(%ebp),%edx
  101e18:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e1c:	89 04 24             	mov    %eax,(%esp)
  101e1f:	e8 25 16 00 00       	call   103449 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e24:	8b 45 08             	mov    0x8(%ebp),%eax
  101e27:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e2a:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e2f:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e31:	eb 3b                	jmp    101e6e <trap_dispatch+0x20a>
  101e33:	eb 39                	jmp    101e6e <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e35:	8b 45 08             	mov    0x8(%ebp),%eax
  101e38:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e3c:	0f b7 c0             	movzwl %ax,%eax
  101e3f:	83 e0 03             	and    $0x3,%eax
  101e42:	85 c0                	test   %eax,%eax
  101e44:	75 28                	jne    101e6e <trap_dispatch+0x20a>
            print_trapframe(tf);
  101e46:	8b 45 08             	mov    0x8(%ebp),%eax
  101e49:	89 04 24             	mov    %eax,(%esp)
  101e4c:	e8 97 fb ff ff       	call   1019e8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e51:	c7 44 24 08 0a 3b 10 	movl   $0x103b0a,0x8(%esp)
  101e58:	00 
  101e59:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101e60:	00 
  101e61:	c7 04 24 2e 39 10 00 	movl   $0x10392e,(%esp)
  101e68:	e8 3a ee ff ff       	call   100ca7 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e6d:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e6e:	83 c4 2c             	add    $0x2c,%esp
  101e71:	5b                   	pop    %ebx
  101e72:	5e                   	pop    %esi
  101e73:	5f                   	pop    %edi
  101e74:	5d                   	pop    %ebp
  101e75:	c3                   	ret    

00101e76 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e76:	55                   	push   %ebp
  101e77:	89 e5                	mov    %esp,%ebp
  101e79:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7f:	89 04 24             	mov    %eax,(%esp)
  101e82:	e8 dd fd ff ff       	call   101c64 <trap_dispatch>
}
  101e87:	c9                   	leave  
  101e88:	c3                   	ret    

00101e89 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e89:	1e                   	push   %ds
    pushl %es
  101e8a:	06                   	push   %es
    pushl %fs
  101e8b:	0f a0                	push   %fs
    pushl %gs
  101e8d:	0f a8                	push   %gs
    pushal
  101e8f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e90:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e95:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e97:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e99:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e9a:	e8 d7 ff ff ff       	call   101e76 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e9f:	5c                   	pop    %esp

00101ea0 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ea0:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ea1:	0f a9                	pop    %gs
    popl %fs
  101ea3:	0f a1                	pop    %fs
    popl %es
  101ea5:	07                   	pop    %es
    popl %ds
  101ea6:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101ea7:	83 c4 08             	add    $0x8,%esp
    iret
  101eaa:	cf                   	iret   

00101eab <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $0
  101ead:	6a 00                	push   $0x0
  jmp __alltraps
  101eaf:	e9 d5 ff ff ff       	jmp    101e89 <__alltraps>

00101eb4 <vector1>:
.globl vector1
vector1:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $1
  101eb6:	6a 01                	push   $0x1
  jmp __alltraps
  101eb8:	e9 cc ff ff ff       	jmp    101e89 <__alltraps>

00101ebd <vector2>:
.globl vector2
vector2:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $2
  101ebf:	6a 02                	push   $0x2
  jmp __alltraps
  101ec1:	e9 c3 ff ff ff       	jmp    101e89 <__alltraps>

00101ec6 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $3
  101ec8:	6a 03                	push   $0x3
  jmp __alltraps
  101eca:	e9 ba ff ff ff       	jmp    101e89 <__alltraps>

00101ecf <vector4>:
.globl vector4
vector4:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $4
  101ed1:	6a 04                	push   $0x4
  jmp __alltraps
  101ed3:	e9 b1 ff ff ff       	jmp    101e89 <__alltraps>

00101ed8 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $5
  101eda:	6a 05                	push   $0x5
  jmp __alltraps
  101edc:	e9 a8 ff ff ff       	jmp    101e89 <__alltraps>

00101ee1 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $6
  101ee3:	6a 06                	push   $0x6
  jmp __alltraps
  101ee5:	e9 9f ff ff ff       	jmp    101e89 <__alltraps>

00101eea <vector7>:
.globl vector7
vector7:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $7
  101eec:	6a 07                	push   $0x7
  jmp __alltraps
  101eee:	e9 96 ff ff ff       	jmp    101e89 <__alltraps>

00101ef3 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ef3:	6a 08                	push   $0x8
  jmp __alltraps
  101ef5:	e9 8f ff ff ff       	jmp    101e89 <__alltraps>

00101efa <vector9>:
.globl vector9
vector9:
  pushl $9
  101efa:	6a 09                	push   $0x9
  jmp __alltraps
  101efc:	e9 88 ff ff ff       	jmp    101e89 <__alltraps>

00101f01 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f01:	6a 0a                	push   $0xa
  jmp __alltraps
  101f03:	e9 81 ff ff ff       	jmp    101e89 <__alltraps>

00101f08 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f08:	6a 0b                	push   $0xb
  jmp __alltraps
  101f0a:	e9 7a ff ff ff       	jmp    101e89 <__alltraps>

00101f0f <vector12>:
.globl vector12
vector12:
  pushl $12
  101f0f:	6a 0c                	push   $0xc
  jmp __alltraps
  101f11:	e9 73 ff ff ff       	jmp    101e89 <__alltraps>

00101f16 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f16:	6a 0d                	push   $0xd
  jmp __alltraps
  101f18:	e9 6c ff ff ff       	jmp    101e89 <__alltraps>

00101f1d <vector14>:
.globl vector14
vector14:
  pushl $14
  101f1d:	6a 0e                	push   $0xe
  jmp __alltraps
  101f1f:	e9 65 ff ff ff       	jmp    101e89 <__alltraps>

00101f24 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $15
  101f26:	6a 0f                	push   $0xf
  jmp __alltraps
  101f28:	e9 5c ff ff ff       	jmp    101e89 <__alltraps>

00101f2d <vector16>:
.globl vector16
vector16:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $16
  101f2f:	6a 10                	push   $0x10
  jmp __alltraps
  101f31:	e9 53 ff ff ff       	jmp    101e89 <__alltraps>

00101f36 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f36:	6a 11                	push   $0x11
  jmp __alltraps
  101f38:	e9 4c ff ff ff       	jmp    101e89 <__alltraps>

00101f3d <vector18>:
.globl vector18
vector18:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $18
  101f3f:	6a 12                	push   $0x12
  jmp __alltraps
  101f41:	e9 43 ff ff ff       	jmp    101e89 <__alltraps>

00101f46 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $19
  101f48:	6a 13                	push   $0x13
  jmp __alltraps
  101f4a:	e9 3a ff ff ff       	jmp    101e89 <__alltraps>

00101f4f <vector20>:
.globl vector20
vector20:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $20
  101f51:	6a 14                	push   $0x14
  jmp __alltraps
  101f53:	e9 31 ff ff ff       	jmp    101e89 <__alltraps>

00101f58 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $21
  101f5a:	6a 15                	push   $0x15
  jmp __alltraps
  101f5c:	e9 28 ff ff ff       	jmp    101e89 <__alltraps>

00101f61 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $22
  101f63:	6a 16                	push   $0x16
  jmp __alltraps
  101f65:	e9 1f ff ff ff       	jmp    101e89 <__alltraps>

00101f6a <vector23>:
.globl vector23
vector23:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $23
  101f6c:	6a 17                	push   $0x17
  jmp __alltraps
  101f6e:	e9 16 ff ff ff       	jmp    101e89 <__alltraps>

00101f73 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $24
  101f75:	6a 18                	push   $0x18
  jmp __alltraps
  101f77:	e9 0d ff ff ff       	jmp    101e89 <__alltraps>

00101f7c <vector25>:
.globl vector25
vector25:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $25
  101f7e:	6a 19                	push   $0x19
  jmp __alltraps
  101f80:	e9 04 ff ff ff       	jmp    101e89 <__alltraps>

00101f85 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $26
  101f87:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f89:	e9 fb fe ff ff       	jmp    101e89 <__alltraps>

00101f8e <vector27>:
.globl vector27
vector27:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $27
  101f90:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f92:	e9 f2 fe ff ff       	jmp    101e89 <__alltraps>

00101f97 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $28
  101f99:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f9b:	e9 e9 fe ff ff       	jmp    101e89 <__alltraps>

00101fa0 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $29
  101fa2:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fa4:	e9 e0 fe ff ff       	jmp    101e89 <__alltraps>

00101fa9 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $30
  101fab:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fad:	e9 d7 fe ff ff       	jmp    101e89 <__alltraps>

00101fb2 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $31
  101fb4:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fb6:	e9 ce fe ff ff       	jmp    101e89 <__alltraps>

00101fbb <vector32>:
.globl vector32
vector32:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $32
  101fbd:	6a 20                	push   $0x20
  jmp __alltraps
  101fbf:	e9 c5 fe ff ff       	jmp    101e89 <__alltraps>

00101fc4 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $33
  101fc6:	6a 21                	push   $0x21
  jmp __alltraps
  101fc8:	e9 bc fe ff ff       	jmp    101e89 <__alltraps>

00101fcd <vector34>:
.globl vector34
vector34:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $34
  101fcf:	6a 22                	push   $0x22
  jmp __alltraps
  101fd1:	e9 b3 fe ff ff       	jmp    101e89 <__alltraps>

00101fd6 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $35
  101fd8:	6a 23                	push   $0x23
  jmp __alltraps
  101fda:	e9 aa fe ff ff       	jmp    101e89 <__alltraps>

00101fdf <vector36>:
.globl vector36
vector36:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $36
  101fe1:	6a 24                	push   $0x24
  jmp __alltraps
  101fe3:	e9 a1 fe ff ff       	jmp    101e89 <__alltraps>

00101fe8 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $37
  101fea:	6a 25                	push   $0x25
  jmp __alltraps
  101fec:	e9 98 fe ff ff       	jmp    101e89 <__alltraps>

00101ff1 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $38
  101ff3:	6a 26                	push   $0x26
  jmp __alltraps
  101ff5:	e9 8f fe ff ff       	jmp    101e89 <__alltraps>

00101ffa <vector39>:
.globl vector39
vector39:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $39
  101ffc:	6a 27                	push   $0x27
  jmp __alltraps
  101ffe:	e9 86 fe ff ff       	jmp    101e89 <__alltraps>

00102003 <vector40>:
.globl vector40
vector40:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $40
  102005:	6a 28                	push   $0x28
  jmp __alltraps
  102007:	e9 7d fe ff ff       	jmp    101e89 <__alltraps>

0010200c <vector41>:
.globl vector41
vector41:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $41
  10200e:	6a 29                	push   $0x29
  jmp __alltraps
  102010:	e9 74 fe ff ff       	jmp    101e89 <__alltraps>

00102015 <vector42>:
.globl vector42
vector42:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $42
  102017:	6a 2a                	push   $0x2a
  jmp __alltraps
  102019:	e9 6b fe ff ff       	jmp    101e89 <__alltraps>

0010201e <vector43>:
.globl vector43
vector43:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $43
  102020:	6a 2b                	push   $0x2b
  jmp __alltraps
  102022:	e9 62 fe ff ff       	jmp    101e89 <__alltraps>

00102027 <vector44>:
.globl vector44
vector44:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $44
  102029:	6a 2c                	push   $0x2c
  jmp __alltraps
  10202b:	e9 59 fe ff ff       	jmp    101e89 <__alltraps>

00102030 <vector45>:
.globl vector45
vector45:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $45
  102032:	6a 2d                	push   $0x2d
  jmp __alltraps
  102034:	e9 50 fe ff ff       	jmp    101e89 <__alltraps>

00102039 <vector46>:
.globl vector46
vector46:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $46
  10203b:	6a 2e                	push   $0x2e
  jmp __alltraps
  10203d:	e9 47 fe ff ff       	jmp    101e89 <__alltraps>

00102042 <vector47>:
.globl vector47
vector47:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $47
  102044:	6a 2f                	push   $0x2f
  jmp __alltraps
  102046:	e9 3e fe ff ff       	jmp    101e89 <__alltraps>

0010204b <vector48>:
.globl vector48
vector48:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $48
  10204d:	6a 30                	push   $0x30
  jmp __alltraps
  10204f:	e9 35 fe ff ff       	jmp    101e89 <__alltraps>

00102054 <vector49>:
.globl vector49
vector49:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $49
  102056:	6a 31                	push   $0x31
  jmp __alltraps
  102058:	e9 2c fe ff ff       	jmp    101e89 <__alltraps>

0010205d <vector50>:
.globl vector50
vector50:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $50
  10205f:	6a 32                	push   $0x32
  jmp __alltraps
  102061:	e9 23 fe ff ff       	jmp    101e89 <__alltraps>

00102066 <vector51>:
.globl vector51
vector51:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $51
  102068:	6a 33                	push   $0x33
  jmp __alltraps
  10206a:	e9 1a fe ff ff       	jmp    101e89 <__alltraps>

0010206f <vector52>:
.globl vector52
vector52:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $52
  102071:	6a 34                	push   $0x34
  jmp __alltraps
  102073:	e9 11 fe ff ff       	jmp    101e89 <__alltraps>

00102078 <vector53>:
.globl vector53
vector53:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $53
  10207a:	6a 35                	push   $0x35
  jmp __alltraps
  10207c:	e9 08 fe ff ff       	jmp    101e89 <__alltraps>

00102081 <vector54>:
.globl vector54
vector54:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $54
  102083:	6a 36                	push   $0x36
  jmp __alltraps
  102085:	e9 ff fd ff ff       	jmp    101e89 <__alltraps>

0010208a <vector55>:
.globl vector55
vector55:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $55
  10208c:	6a 37                	push   $0x37
  jmp __alltraps
  10208e:	e9 f6 fd ff ff       	jmp    101e89 <__alltraps>

00102093 <vector56>:
.globl vector56
vector56:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $56
  102095:	6a 38                	push   $0x38
  jmp __alltraps
  102097:	e9 ed fd ff ff       	jmp    101e89 <__alltraps>

0010209c <vector57>:
.globl vector57
vector57:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $57
  10209e:	6a 39                	push   $0x39
  jmp __alltraps
  1020a0:	e9 e4 fd ff ff       	jmp    101e89 <__alltraps>

001020a5 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $58
  1020a7:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020a9:	e9 db fd ff ff       	jmp    101e89 <__alltraps>

001020ae <vector59>:
.globl vector59
vector59:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $59
  1020b0:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020b2:	e9 d2 fd ff ff       	jmp    101e89 <__alltraps>

001020b7 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $60
  1020b9:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020bb:	e9 c9 fd ff ff       	jmp    101e89 <__alltraps>

001020c0 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $61
  1020c2:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020c4:	e9 c0 fd ff ff       	jmp    101e89 <__alltraps>

001020c9 <vector62>:
.globl vector62
vector62:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $62
  1020cb:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020cd:	e9 b7 fd ff ff       	jmp    101e89 <__alltraps>

001020d2 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $63
  1020d4:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020d6:	e9 ae fd ff ff       	jmp    101e89 <__alltraps>

001020db <vector64>:
.globl vector64
vector64:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $64
  1020dd:	6a 40                	push   $0x40
  jmp __alltraps
  1020df:	e9 a5 fd ff ff       	jmp    101e89 <__alltraps>

001020e4 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $65
  1020e6:	6a 41                	push   $0x41
  jmp __alltraps
  1020e8:	e9 9c fd ff ff       	jmp    101e89 <__alltraps>

001020ed <vector66>:
.globl vector66
vector66:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $66
  1020ef:	6a 42                	push   $0x42
  jmp __alltraps
  1020f1:	e9 93 fd ff ff       	jmp    101e89 <__alltraps>

001020f6 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $67
  1020f8:	6a 43                	push   $0x43
  jmp __alltraps
  1020fa:	e9 8a fd ff ff       	jmp    101e89 <__alltraps>

001020ff <vector68>:
.globl vector68
vector68:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $68
  102101:	6a 44                	push   $0x44
  jmp __alltraps
  102103:	e9 81 fd ff ff       	jmp    101e89 <__alltraps>

00102108 <vector69>:
.globl vector69
vector69:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $69
  10210a:	6a 45                	push   $0x45
  jmp __alltraps
  10210c:	e9 78 fd ff ff       	jmp    101e89 <__alltraps>

00102111 <vector70>:
.globl vector70
vector70:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $70
  102113:	6a 46                	push   $0x46
  jmp __alltraps
  102115:	e9 6f fd ff ff       	jmp    101e89 <__alltraps>

0010211a <vector71>:
.globl vector71
vector71:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $71
  10211c:	6a 47                	push   $0x47
  jmp __alltraps
  10211e:	e9 66 fd ff ff       	jmp    101e89 <__alltraps>

00102123 <vector72>:
.globl vector72
vector72:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $72
  102125:	6a 48                	push   $0x48
  jmp __alltraps
  102127:	e9 5d fd ff ff       	jmp    101e89 <__alltraps>

0010212c <vector73>:
.globl vector73
vector73:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $73
  10212e:	6a 49                	push   $0x49
  jmp __alltraps
  102130:	e9 54 fd ff ff       	jmp    101e89 <__alltraps>

00102135 <vector74>:
.globl vector74
vector74:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $74
  102137:	6a 4a                	push   $0x4a
  jmp __alltraps
  102139:	e9 4b fd ff ff       	jmp    101e89 <__alltraps>

0010213e <vector75>:
.globl vector75
vector75:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $75
  102140:	6a 4b                	push   $0x4b
  jmp __alltraps
  102142:	e9 42 fd ff ff       	jmp    101e89 <__alltraps>

00102147 <vector76>:
.globl vector76
vector76:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $76
  102149:	6a 4c                	push   $0x4c
  jmp __alltraps
  10214b:	e9 39 fd ff ff       	jmp    101e89 <__alltraps>

00102150 <vector77>:
.globl vector77
vector77:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $77
  102152:	6a 4d                	push   $0x4d
  jmp __alltraps
  102154:	e9 30 fd ff ff       	jmp    101e89 <__alltraps>

00102159 <vector78>:
.globl vector78
vector78:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $78
  10215b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10215d:	e9 27 fd ff ff       	jmp    101e89 <__alltraps>

00102162 <vector79>:
.globl vector79
vector79:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $79
  102164:	6a 4f                	push   $0x4f
  jmp __alltraps
  102166:	e9 1e fd ff ff       	jmp    101e89 <__alltraps>

0010216b <vector80>:
.globl vector80
vector80:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $80
  10216d:	6a 50                	push   $0x50
  jmp __alltraps
  10216f:	e9 15 fd ff ff       	jmp    101e89 <__alltraps>

00102174 <vector81>:
.globl vector81
vector81:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $81
  102176:	6a 51                	push   $0x51
  jmp __alltraps
  102178:	e9 0c fd ff ff       	jmp    101e89 <__alltraps>

0010217d <vector82>:
.globl vector82
vector82:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $82
  10217f:	6a 52                	push   $0x52
  jmp __alltraps
  102181:	e9 03 fd ff ff       	jmp    101e89 <__alltraps>

00102186 <vector83>:
.globl vector83
vector83:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $83
  102188:	6a 53                	push   $0x53
  jmp __alltraps
  10218a:	e9 fa fc ff ff       	jmp    101e89 <__alltraps>

0010218f <vector84>:
.globl vector84
vector84:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $84
  102191:	6a 54                	push   $0x54
  jmp __alltraps
  102193:	e9 f1 fc ff ff       	jmp    101e89 <__alltraps>

00102198 <vector85>:
.globl vector85
vector85:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $85
  10219a:	6a 55                	push   $0x55
  jmp __alltraps
  10219c:	e9 e8 fc ff ff       	jmp    101e89 <__alltraps>

001021a1 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $86
  1021a3:	6a 56                	push   $0x56
  jmp __alltraps
  1021a5:	e9 df fc ff ff       	jmp    101e89 <__alltraps>

001021aa <vector87>:
.globl vector87
vector87:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $87
  1021ac:	6a 57                	push   $0x57
  jmp __alltraps
  1021ae:	e9 d6 fc ff ff       	jmp    101e89 <__alltraps>

001021b3 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $88
  1021b5:	6a 58                	push   $0x58
  jmp __alltraps
  1021b7:	e9 cd fc ff ff       	jmp    101e89 <__alltraps>

001021bc <vector89>:
.globl vector89
vector89:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $89
  1021be:	6a 59                	push   $0x59
  jmp __alltraps
  1021c0:	e9 c4 fc ff ff       	jmp    101e89 <__alltraps>

001021c5 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $90
  1021c7:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021c9:	e9 bb fc ff ff       	jmp    101e89 <__alltraps>

001021ce <vector91>:
.globl vector91
vector91:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $91
  1021d0:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021d2:	e9 b2 fc ff ff       	jmp    101e89 <__alltraps>

001021d7 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $92
  1021d9:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021db:	e9 a9 fc ff ff       	jmp    101e89 <__alltraps>

001021e0 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $93
  1021e2:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021e4:	e9 a0 fc ff ff       	jmp    101e89 <__alltraps>

001021e9 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $94
  1021eb:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021ed:	e9 97 fc ff ff       	jmp    101e89 <__alltraps>

001021f2 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $95
  1021f4:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021f6:	e9 8e fc ff ff       	jmp    101e89 <__alltraps>

001021fb <vector96>:
.globl vector96
vector96:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $96
  1021fd:	6a 60                	push   $0x60
  jmp __alltraps
  1021ff:	e9 85 fc ff ff       	jmp    101e89 <__alltraps>

00102204 <vector97>:
.globl vector97
vector97:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $97
  102206:	6a 61                	push   $0x61
  jmp __alltraps
  102208:	e9 7c fc ff ff       	jmp    101e89 <__alltraps>

0010220d <vector98>:
.globl vector98
vector98:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $98
  10220f:	6a 62                	push   $0x62
  jmp __alltraps
  102211:	e9 73 fc ff ff       	jmp    101e89 <__alltraps>

00102216 <vector99>:
.globl vector99
vector99:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $99
  102218:	6a 63                	push   $0x63
  jmp __alltraps
  10221a:	e9 6a fc ff ff       	jmp    101e89 <__alltraps>

0010221f <vector100>:
.globl vector100
vector100:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $100
  102221:	6a 64                	push   $0x64
  jmp __alltraps
  102223:	e9 61 fc ff ff       	jmp    101e89 <__alltraps>

00102228 <vector101>:
.globl vector101
vector101:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $101
  10222a:	6a 65                	push   $0x65
  jmp __alltraps
  10222c:	e9 58 fc ff ff       	jmp    101e89 <__alltraps>

00102231 <vector102>:
.globl vector102
vector102:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $102
  102233:	6a 66                	push   $0x66
  jmp __alltraps
  102235:	e9 4f fc ff ff       	jmp    101e89 <__alltraps>

0010223a <vector103>:
.globl vector103
vector103:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $103
  10223c:	6a 67                	push   $0x67
  jmp __alltraps
  10223e:	e9 46 fc ff ff       	jmp    101e89 <__alltraps>

00102243 <vector104>:
.globl vector104
vector104:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $104
  102245:	6a 68                	push   $0x68
  jmp __alltraps
  102247:	e9 3d fc ff ff       	jmp    101e89 <__alltraps>

0010224c <vector105>:
.globl vector105
vector105:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $105
  10224e:	6a 69                	push   $0x69
  jmp __alltraps
  102250:	e9 34 fc ff ff       	jmp    101e89 <__alltraps>

00102255 <vector106>:
.globl vector106
vector106:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $106
  102257:	6a 6a                	push   $0x6a
  jmp __alltraps
  102259:	e9 2b fc ff ff       	jmp    101e89 <__alltraps>

0010225e <vector107>:
.globl vector107
vector107:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $107
  102260:	6a 6b                	push   $0x6b
  jmp __alltraps
  102262:	e9 22 fc ff ff       	jmp    101e89 <__alltraps>

00102267 <vector108>:
.globl vector108
vector108:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $108
  102269:	6a 6c                	push   $0x6c
  jmp __alltraps
  10226b:	e9 19 fc ff ff       	jmp    101e89 <__alltraps>

00102270 <vector109>:
.globl vector109
vector109:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $109
  102272:	6a 6d                	push   $0x6d
  jmp __alltraps
  102274:	e9 10 fc ff ff       	jmp    101e89 <__alltraps>

00102279 <vector110>:
.globl vector110
vector110:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $110
  10227b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10227d:	e9 07 fc ff ff       	jmp    101e89 <__alltraps>

00102282 <vector111>:
.globl vector111
vector111:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $111
  102284:	6a 6f                	push   $0x6f
  jmp __alltraps
  102286:	e9 fe fb ff ff       	jmp    101e89 <__alltraps>

0010228b <vector112>:
.globl vector112
vector112:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $112
  10228d:	6a 70                	push   $0x70
  jmp __alltraps
  10228f:	e9 f5 fb ff ff       	jmp    101e89 <__alltraps>

00102294 <vector113>:
.globl vector113
vector113:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $113
  102296:	6a 71                	push   $0x71
  jmp __alltraps
  102298:	e9 ec fb ff ff       	jmp    101e89 <__alltraps>

0010229d <vector114>:
.globl vector114
vector114:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $114
  10229f:	6a 72                	push   $0x72
  jmp __alltraps
  1022a1:	e9 e3 fb ff ff       	jmp    101e89 <__alltraps>

001022a6 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $115
  1022a8:	6a 73                	push   $0x73
  jmp __alltraps
  1022aa:	e9 da fb ff ff       	jmp    101e89 <__alltraps>

001022af <vector116>:
.globl vector116
vector116:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $116
  1022b1:	6a 74                	push   $0x74
  jmp __alltraps
  1022b3:	e9 d1 fb ff ff       	jmp    101e89 <__alltraps>

001022b8 <vector117>:
.globl vector117
vector117:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $117
  1022ba:	6a 75                	push   $0x75
  jmp __alltraps
  1022bc:	e9 c8 fb ff ff       	jmp    101e89 <__alltraps>

001022c1 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $118
  1022c3:	6a 76                	push   $0x76
  jmp __alltraps
  1022c5:	e9 bf fb ff ff       	jmp    101e89 <__alltraps>

001022ca <vector119>:
.globl vector119
vector119:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $119
  1022cc:	6a 77                	push   $0x77
  jmp __alltraps
  1022ce:	e9 b6 fb ff ff       	jmp    101e89 <__alltraps>

001022d3 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $120
  1022d5:	6a 78                	push   $0x78
  jmp __alltraps
  1022d7:	e9 ad fb ff ff       	jmp    101e89 <__alltraps>

001022dc <vector121>:
.globl vector121
vector121:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $121
  1022de:	6a 79                	push   $0x79
  jmp __alltraps
  1022e0:	e9 a4 fb ff ff       	jmp    101e89 <__alltraps>

001022e5 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $122
  1022e7:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022e9:	e9 9b fb ff ff       	jmp    101e89 <__alltraps>

001022ee <vector123>:
.globl vector123
vector123:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $123
  1022f0:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022f2:	e9 92 fb ff ff       	jmp    101e89 <__alltraps>

001022f7 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $124
  1022f9:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022fb:	e9 89 fb ff ff       	jmp    101e89 <__alltraps>

00102300 <vector125>:
.globl vector125
vector125:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $125
  102302:	6a 7d                	push   $0x7d
  jmp __alltraps
  102304:	e9 80 fb ff ff       	jmp    101e89 <__alltraps>

00102309 <vector126>:
.globl vector126
vector126:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $126
  10230b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10230d:	e9 77 fb ff ff       	jmp    101e89 <__alltraps>

00102312 <vector127>:
.globl vector127
vector127:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $127
  102314:	6a 7f                	push   $0x7f
  jmp __alltraps
  102316:	e9 6e fb ff ff       	jmp    101e89 <__alltraps>

0010231b <vector128>:
.globl vector128
vector128:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $128
  10231d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102322:	e9 62 fb ff ff       	jmp    101e89 <__alltraps>

00102327 <vector129>:
.globl vector129
vector129:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $129
  102329:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10232e:	e9 56 fb ff ff       	jmp    101e89 <__alltraps>

00102333 <vector130>:
.globl vector130
vector130:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $130
  102335:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10233a:	e9 4a fb ff ff       	jmp    101e89 <__alltraps>

0010233f <vector131>:
.globl vector131
vector131:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $131
  102341:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102346:	e9 3e fb ff ff       	jmp    101e89 <__alltraps>

0010234b <vector132>:
.globl vector132
vector132:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $132
  10234d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102352:	e9 32 fb ff ff       	jmp    101e89 <__alltraps>

00102357 <vector133>:
.globl vector133
vector133:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $133
  102359:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10235e:	e9 26 fb ff ff       	jmp    101e89 <__alltraps>

00102363 <vector134>:
.globl vector134
vector134:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $134
  102365:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10236a:	e9 1a fb ff ff       	jmp    101e89 <__alltraps>

0010236f <vector135>:
.globl vector135
vector135:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $135
  102371:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102376:	e9 0e fb ff ff       	jmp    101e89 <__alltraps>

0010237b <vector136>:
.globl vector136
vector136:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $136
  10237d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102382:	e9 02 fb ff ff       	jmp    101e89 <__alltraps>

00102387 <vector137>:
.globl vector137
vector137:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $137
  102389:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10238e:	e9 f6 fa ff ff       	jmp    101e89 <__alltraps>

00102393 <vector138>:
.globl vector138
vector138:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $138
  102395:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10239a:	e9 ea fa ff ff       	jmp    101e89 <__alltraps>

0010239f <vector139>:
.globl vector139
vector139:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $139
  1023a1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023a6:	e9 de fa ff ff       	jmp    101e89 <__alltraps>

001023ab <vector140>:
.globl vector140
vector140:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $140
  1023ad:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023b2:	e9 d2 fa ff ff       	jmp    101e89 <__alltraps>

001023b7 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $141
  1023b9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023be:	e9 c6 fa ff ff       	jmp    101e89 <__alltraps>

001023c3 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $142
  1023c5:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023ca:	e9 ba fa ff ff       	jmp    101e89 <__alltraps>

001023cf <vector143>:
.globl vector143
vector143:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $143
  1023d1:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023d6:	e9 ae fa ff ff       	jmp    101e89 <__alltraps>

001023db <vector144>:
.globl vector144
vector144:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $144
  1023dd:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023e2:	e9 a2 fa ff ff       	jmp    101e89 <__alltraps>

001023e7 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $145
  1023e9:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023ee:	e9 96 fa ff ff       	jmp    101e89 <__alltraps>

001023f3 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $146
  1023f5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023fa:	e9 8a fa ff ff       	jmp    101e89 <__alltraps>

001023ff <vector147>:
.globl vector147
vector147:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $147
  102401:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102406:	e9 7e fa ff ff       	jmp    101e89 <__alltraps>

0010240b <vector148>:
.globl vector148
vector148:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $148
  10240d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102412:	e9 72 fa ff ff       	jmp    101e89 <__alltraps>

00102417 <vector149>:
.globl vector149
vector149:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $149
  102419:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10241e:	e9 66 fa ff ff       	jmp    101e89 <__alltraps>

00102423 <vector150>:
.globl vector150
vector150:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $150
  102425:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10242a:	e9 5a fa ff ff       	jmp    101e89 <__alltraps>

0010242f <vector151>:
.globl vector151
vector151:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $151
  102431:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102436:	e9 4e fa ff ff       	jmp    101e89 <__alltraps>

0010243b <vector152>:
.globl vector152
vector152:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $152
  10243d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102442:	e9 42 fa ff ff       	jmp    101e89 <__alltraps>

00102447 <vector153>:
.globl vector153
vector153:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $153
  102449:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10244e:	e9 36 fa ff ff       	jmp    101e89 <__alltraps>

00102453 <vector154>:
.globl vector154
vector154:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $154
  102455:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10245a:	e9 2a fa ff ff       	jmp    101e89 <__alltraps>

0010245f <vector155>:
.globl vector155
vector155:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $155
  102461:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102466:	e9 1e fa ff ff       	jmp    101e89 <__alltraps>

0010246b <vector156>:
.globl vector156
vector156:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $156
  10246d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102472:	e9 12 fa ff ff       	jmp    101e89 <__alltraps>

00102477 <vector157>:
.globl vector157
vector157:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $157
  102479:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10247e:	e9 06 fa ff ff       	jmp    101e89 <__alltraps>

00102483 <vector158>:
.globl vector158
vector158:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $158
  102485:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10248a:	e9 fa f9 ff ff       	jmp    101e89 <__alltraps>

0010248f <vector159>:
.globl vector159
vector159:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $159
  102491:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102496:	e9 ee f9 ff ff       	jmp    101e89 <__alltraps>

0010249b <vector160>:
.globl vector160
vector160:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $160
  10249d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024a2:	e9 e2 f9 ff ff       	jmp    101e89 <__alltraps>

001024a7 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $161
  1024a9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024ae:	e9 d6 f9 ff ff       	jmp    101e89 <__alltraps>

001024b3 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $162
  1024b5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024ba:	e9 ca f9 ff ff       	jmp    101e89 <__alltraps>

001024bf <vector163>:
.globl vector163
vector163:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $163
  1024c1:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024c6:	e9 be f9 ff ff       	jmp    101e89 <__alltraps>

001024cb <vector164>:
.globl vector164
vector164:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $164
  1024cd:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024d2:	e9 b2 f9 ff ff       	jmp    101e89 <__alltraps>

001024d7 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $165
  1024d9:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024de:	e9 a6 f9 ff ff       	jmp    101e89 <__alltraps>

001024e3 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $166
  1024e5:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024ea:	e9 9a f9 ff ff       	jmp    101e89 <__alltraps>

001024ef <vector167>:
.globl vector167
vector167:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $167
  1024f1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024f6:	e9 8e f9 ff ff       	jmp    101e89 <__alltraps>

001024fb <vector168>:
.globl vector168
vector168:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $168
  1024fd:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102502:	e9 82 f9 ff ff       	jmp    101e89 <__alltraps>

00102507 <vector169>:
.globl vector169
vector169:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $169
  102509:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10250e:	e9 76 f9 ff ff       	jmp    101e89 <__alltraps>

00102513 <vector170>:
.globl vector170
vector170:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $170
  102515:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10251a:	e9 6a f9 ff ff       	jmp    101e89 <__alltraps>

0010251f <vector171>:
.globl vector171
vector171:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $171
  102521:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102526:	e9 5e f9 ff ff       	jmp    101e89 <__alltraps>

0010252b <vector172>:
.globl vector172
vector172:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $172
  10252d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102532:	e9 52 f9 ff ff       	jmp    101e89 <__alltraps>

00102537 <vector173>:
.globl vector173
vector173:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $173
  102539:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10253e:	e9 46 f9 ff ff       	jmp    101e89 <__alltraps>

00102543 <vector174>:
.globl vector174
vector174:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $174
  102545:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10254a:	e9 3a f9 ff ff       	jmp    101e89 <__alltraps>

0010254f <vector175>:
.globl vector175
vector175:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $175
  102551:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102556:	e9 2e f9 ff ff       	jmp    101e89 <__alltraps>

0010255b <vector176>:
.globl vector176
vector176:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $176
  10255d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102562:	e9 22 f9 ff ff       	jmp    101e89 <__alltraps>

00102567 <vector177>:
.globl vector177
vector177:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $177
  102569:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10256e:	e9 16 f9 ff ff       	jmp    101e89 <__alltraps>

00102573 <vector178>:
.globl vector178
vector178:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $178
  102575:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10257a:	e9 0a f9 ff ff       	jmp    101e89 <__alltraps>

0010257f <vector179>:
.globl vector179
vector179:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $179
  102581:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102586:	e9 fe f8 ff ff       	jmp    101e89 <__alltraps>

0010258b <vector180>:
.globl vector180
vector180:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $180
  10258d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102592:	e9 f2 f8 ff ff       	jmp    101e89 <__alltraps>

00102597 <vector181>:
.globl vector181
vector181:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $181
  102599:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10259e:	e9 e6 f8 ff ff       	jmp    101e89 <__alltraps>

001025a3 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $182
  1025a5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025aa:	e9 da f8 ff ff       	jmp    101e89 <__alltraps>

001025af <vector183>:
.globl vector183
vector183:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $183
  1025b1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025b6:	e9 ce f8 ff ff       	jmp    101e89 <__alltraps>

001025bb <vector184>:
.globl vector184
vector184:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $184
  1025bd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025c2:	e9 c2 f8 ff ff       	jmp    101e89 <__alltraps>

001025c7 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $185
  1025c9:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025ce:	e9 b6 f8 ff ff       	jmp    101e89 <__alltraps>

001025d3 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $186
  1025d5:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025da:	e9 aa f8 ff ff       	jmp    101e89 <__alltraps>

001025df <vector187>:
.globl vector187
vector187:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $187
  1025e1:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025e6:	e9 9e f8 ff ff       	jmp    101e89 <__alltraps>

001025eb <vector188>:
.globl vector188
vector188:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $188
  1025ed:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025f2:	e9 92 f8 ff ff       	jmp    101e89 <__alltraps>

001025f7 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $189
  1025f9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025fe:	e9 86 f8 ff ff       	jmp    101e89 <__alltraps>

00102603 <vector190>:
.globl vector190
vector190:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $190
  102605:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10260a:	e9 7a f8 ff ff       	jmp    101e89 <__alltraps>

0010260f <vector191>:
.globl vector191
vector191:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $191
  102611:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102616:	e9 6e f8 ff ff       	jmp    101e89 <__alltraps>

0010261b <vector192>:
.globl vector192
vector192:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $192
  10261d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102622:	e9 62 f8 ff ff       	jmp    101e89 <__alltraps>

00102627 <vector193>:
.globl vector193
vector193:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $193
  102629:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10262e:	e9 56 f8 ff ff       	jmp    101e89 <__alltraps>

00102633 <vector194>:
.globl vector194
vector194:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $194
  102635:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10263a:	e9 4a f8 ff ff       	jmp    101e89 <__alltraps>

0010263f <vector195>:
.globl vector195
vector195:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $195
  102641:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102646:	e9 3e f8 ff ff       	jmp    101e89 <__alltraps>

0010264b <vector196>:
.globl vector196
vector196:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $196
  10264d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102652:	e9 32 f8 ff ff       	jmp    101e89 <__alltraps>

00102657 <vector197>:
.globl vector197
vector197:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $197
  102659:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10265e:	e9 26 f8 ff ff       	jmp    101e89 <__alltraps>

00102663 <vector198>:
.globl vector198
vector198:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $198
  102665:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10266a:	e9 1a f8 ff ff       	jmp    101e89 <__alltraps>

0010266f <vector199>:
.globl vector199
vector199:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $199
  102671:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102676:	e9 0e f8 ff ff       	jmp    101e89 <__alltraps>

0010267b <vector200>:
.globl vector200
vector200:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $200
  10267d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102682:	e9 02 f8 ff ff       	jmp    101e89 <__alltraps>

00102687 <vector201>:
.globl vector201
vector201:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $201
  102689:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10268e:	e9 f6 f7 ff ff       	jmp    101e89 <__alltraps>

00102693 <vector202>:
.globl vector202
vector202:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $202
  102695:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10269a:	e9 ea f7 ff ff       	jmp    101e89 <__alltraps>

0010269f <vector203>:
.globl vector203
vector203:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $203
  1026a1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026a6:	e9 de f7 ff ff       	jmp    101e89 <__alltraps>

001026ab <vector204>:
.globl vector204
vector204:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $204
  1026ad:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026b2:	e9 d2 f7 ff ff       	jmp    101e89 <__alltraps>

001026b7 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $205
  1026b9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026be:	e9 c6 f7 ff ff       	jmp    101e89 <__alltraps>

001026c3 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $206
  1026c5:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026ca:	e9 ba f7 ff ff       	jmp    101e89 <__alltraps>

001026cf <vector207>:
.globl vector207
vector207:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $207
  1026d1:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026d6:	e9 ae f7 ff ff       	jmp    101e89 <__alltraps>

001026db <vector208>:
.globl vector208
vector208:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $208
  1026dd:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026e2:	e9 a2 f7 ff ff       	jmp    101e89 <__alltraps>

001026e7 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $209
  1026e9:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026ee:	e9 96 f7 ff ff       	jmp    101e89 <__alltraps>

001026f3 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $210
  1026f5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026fa:	e9 8a f7 ff ff       	jmp    101e89 <__alltraps>

001026ff <vector211>:
.globl vector211
vector211:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $211
  102701:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102706:	e9 7e f7 ff ff       	jmp    101e89 <__alltraps>

0010270b <vector212>:
.globl vector212
vector212:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $212
  10270d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102712:	e9 72 f7 ff ff       	jmp    101e89 <__alltraps>

00102717 <vector213>:
.globl vector213
vector213:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $213
  102719:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10271e:	e9 66 f7 ff ff       	jmp    101e89 <__alltraps>

00102723 <vector214>:
.globl vector214
vector214:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $214
  102725:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10272a:	e9 5a f7 ff ff       	jmp    101e89 <__alltraps>

0010272f <vector215>:
.globl vector215
vector215:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $215
  102731:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102736:	e9 4e f7 ff ff       	jmp    101e89 <__alltraps>

0010273b <vector216>:
.globl vector216
vector216:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $216
  10273d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102742:	e9 42 f7 ff ff       	jmp    101e89 <__alltraps>

00102747 <vector217>:
.globl vector217
vector217:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $217
  102749:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10274e:	e9 36 f7 ff ff       	jmp    101e89 <__alltraps>

00102753 <vector218>:
.globl vector218
vector218:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $218
  102755:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10275a:	e9 2a f7 ff ff       	jmp    101e89 <__alltraps>

0010275f <vector219>:
.globl vector219
vector219:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $219
  102761:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102766:	e9 1e f7 ff ff       	jmp    101e89 <__alltraps>

0010276b <vector220>:
.globl vector220
vector220:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $220
  10276d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102772:	e9 12 f7 ff ff       	jmp    101e89 <__alltraps>

00102777 <vector221>:
.globl vector221
vector221:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $221
  102779:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10277e:	e9 06 f7 ff ff       	jmp    101e89 <__alltraps>

00102783 <vector222>:
.globl vector222
vector222:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $222
  102785:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10278a:	e9 fa f6 ff ff       	jmp    101e89 <__alltraps>

0010278f <vector223>:
.globl vector223
vector223:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $223
  102791:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102796:	e9 ee f6 ff ff       	jmp    101e89 <__alltraps>

0010279b <vector224>:
.globl vector224
vector224:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $224
  10279d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027a2:	e9 e2 f6 ff ff       	jmp    101e89 <__alltraps>

001027a7 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $225
  1027a9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027ae:	e9 d6 f6 ff ff       	jmp    101e89 <__alltraps>

001027b3 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $226
  1027b5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027ba:	e9 ca f6 ff ff       	jmp    101e89 <__alltraps>

001027bf <vector227>:
.globl vector227
vector227:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $227
  1027c1:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027c6:	e9 be f6 ff ff       	jmp    101e89 <__alltraps>

001027cb <vector228>:
.globl vector228
vector228:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $228
  1027cd:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027d2:	e9 b2 f6 ff ff       	jmp    101e89 <__alltraps>

001027d7 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $229
  1027d9:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027de:	e9 a6 f6 ff ff       	jmp    101e89 <__alltraps>

001027e3 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $230
  1027e5:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027ea:	e9 9a f6 ff ff       	jmp    101e89 <__alltraps>

001027ef <vector231>:
.globl vector231
vector231:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $231
  1027f1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027f6:	e9 8e f6 ff ff       	jmp    101e89 <__alltraps>

001027fb <vector232>:
.globl vector232
vector232:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $232
  1027fd:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102802:	e9 82 f6 ff ff       	jmp    101e89 <__alltraps>

00102807 <vector233>:
.globl vector233
vector233:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $233
  102809:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10280e:	e9 76 f6 ff ff       	jmp    101e89 <__alltraps>

00102813 <vector234>:
.globl vector234
vector234:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $234
  102815:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10281a:	e9 6a f6 ff ff       	jmp    101e89 <__alltraps>

0010281f <vector235>:
.globl vector235
vector235:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $235
  102821:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102826:	e9 5e f6 ff ff       	jmp    101e89 <__alltraps>

0010282b <vector236>:
.globl vector236
vector236:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $236
  10282d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102832:	e9 52 f6 ff ff       	jmp    101e89 <__alltraps>

00102837 <vector237>:
.globl vector237
vector237:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $237
  102839:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10283e:	e9 46 f6 ff ff       	jmp    101e89 <__alltraps>

00102843 <vector238>:
.globl vector238
vector238:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $238
  102845:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10284a:	e9 3a f6 ff ff       	jmp    101e89 <__alltraps>

0010284f <vector239>:
.globl vector239
vector239:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $239
  102851:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102856:	e9 2e f6 ff ff       	jmp    101e89 <__alltraps>

0010285b <vector240>:
.globl vector240
vector240:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $240
  10285d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102862:	e9 22 f6 ff ff       	jmp    101e89 <__alltraps>

00102867 <vector241>:
.globl vector241
vector241:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $241
  102869:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10286e:	e9 16 f6 ff ff       	jmp    101e89 <__alltraps>

00102873 <vector242>:
.globl vector242
vector242:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $242
  102875:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10287a:	e9 0a f6 ff ff       	jmp    101e89 <__alltraps>

0010287f <vector243>:
.globl vector243
vector243:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $243
  102881:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102886:	e9 fe f5 ff ff       	jmp    101e89 <__alltraps>

0010288b <vector244>:
.globl vector244
vector244:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $244
  10288d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102892:	e9 f2 f5 ff ff       	jmp    101e89 <__alltraps>

00102897 <vector245>:
.globl vector245
vector245:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $245
  102899:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10289e:	e9 e6 f5 ff ff       	jmp    101e89 <__alltraps>

001028a3 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $246
  1028a5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028aa:	e9 da f5 ff ff       	jmp    101e89 <__alltraps>

001028af <vector247>:
.globl vector247
vector247:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $247
  1028b1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028b6:	e9 ce f5 ff ff       	jmp    101e89 <__alltraps>

001028bb <vector248>:
.globl vector248
vector248:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $248
  1028bd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028c2:	e9 c2 f5 ff ff       	jmp    101e89 <__alltraps>

001028c7 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $249
  1028c9:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028ce:	e9 b6 f5 ff ff       	jmp    101e89 <__alltraps>

001028d3 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $250
  1028d5:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028da:	e9 aa f5 ff ff       	jmp    101e89 <__alltraps>

001028df <vector251>:
.globl vector251
vector251:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $251
  1028e1:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028e6:	e9 9e f5 ff ff       	jmp    101e89 <__alltraps>

001028eb <vector252>:
.globl vector252
vector252:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $252
  1028ed:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028f2:	e9 92 f5 ff ff       	jmp    101e89 <__alltraps>

001028f7 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $253
  1028f9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028fe:	e9 86 f5 ff ff       	jmp    101e89 <__alltraps>

00102903 <vector254>:
.globl vector254
vector254:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $254
  102905:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10290a:	e9 7a f5 ff ff       	jmp    101e89 <__alltraps>

0010290f <vector255>:
.globl vector255
vector255:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $255
  102911:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102916:	e9 6e f5 ff ff       	jmp    101e89 <__alltraps>

0010291b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10291b:	55                   	push   %ebp
  10291c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10291e:	8b 45 08             	mov    0x8(%ebp),%eax
  102921:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102924:	b8 23 00 00 00       	mov    $0x23,%eax
  102929:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10292b:	b8 23 00 00 00       	mov    $0x23,%eax
  102930:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102932:	b8 10 00 00 00       	mov    $0x10,%eax
  102937:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102939:	b8 10 00 00 00       	mov    $0x10,%eax
  10293e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102940:	b8 10 00 00 00       	mov    $0x10,%eax
  102945:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102947:	ea 4e 29 10 00 08 00 	ljmp   $0x8,$0x10294e
}
  10294e:	5d                   	pop    %ebp
  10294f:	c3                   	ret    

00102950 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102950:	55                   	push   %ebp
  102951:	89 e5                	mov    %esp,%ebp
  102953:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102956:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  10295b:	05 00 04 00 00       	add    $0x400,%eax
  102960:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102965:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10296c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10296e:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102975:	68 00 
  102977:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10297c:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102982:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102987:	c1 e8 10             	shr    $0x10,%eax
  10298a:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10298f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102996:	83 e0 f0             	and    $0xfffffff0,%eax
  102999:	83 c8 09             	or     $0x9,%eax
  10299c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029a1:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029a8:	83 c8 10             	or     $0x10,%eax
  1029ab:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029b0:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029b7:	83 e0 9f             	and    $0xffffff9f,%eax
  1029ba:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029bf:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029c6:	83 c8 80             	or     $0xffffff80,%eax
  1029c9:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029ce:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029d5:	83 e0 f0             	and    $0xfffffff0,%eax
  1029d8:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029dd:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029e4:	83 e0 ef             	and    $0xffffffef,%eax
  1029e7:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029ec:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029f3:	83 e0 df             	and    $0xffffffdf,%eax
  1029f6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029fb:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a02:	83 c8 40             	or     $0x40,%eax
  102a05:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a0a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a11:	83 e0 7f             	and    $0x7f,%eax
  102a14:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a19:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a1e:	c1 e8 18             	shr    $0x18,%eax
  102a21:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a26:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a2d:	83 e0 ef             	and    $0xffffffef,%eax
  102a30:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a35:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a3c:	e8 da fe ff ff       	call   10291b <lgdt>
  102a41:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a47:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a4b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a4e:	c9                   	leave  
  102a4f:	c3                   	ret    

00102a50 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a50:	55                   	push   %ebp
  102a51:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a53:	e8 f8 fe ff ff       	call   102950 <gdt_init>
}
  102a58:	5d                   	pop    %ebp
  102a59:	c3                   	ret    

00102a5a <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a5a:	55                   	push   %ebp
  102a5b:	89 e5                	mov    %esp,%ebp
  102a5d:	83 ec 58             	sub    $0x58,%esp
  102a60:	8b 45 10             	mov    0x10(%ebp),%eax
  102a63:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a66:	8b 45 14             	mov    0x14(%ebp),%eax
  102a69:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102a6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a72:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a75:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102a78:	8b 45 18             	mov    0x18(%ebp),%eax
  102a7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a87:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a94:	74 1c                	je     102ab2 <printnum+0x58>
  102a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a99:	ba 00 00 00 00       	mov    $0x0,%edx
  102a9e:	f7 75 e4             	divl   -0x1c(%ebp)
  102aa1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  102aac:	f7 75 e4             	divl   -0x1c(%ebp)
  102aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ab8:	f7 75 e4             	divl   -0x1c(%ebp)
  102abb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102abe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ac4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ac7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102aca:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102acd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ad0:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102ad3:	8b 45 18             	mov    0x18(%ebp),%eax
  102ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  102adb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ade:	77 56                	ja     102b36 <printnum+0xdc>
  102ae0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ae3:	72 05                	jb     102aea <printnum+0x90>
  102ae5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102ae8:	77 4c                	ja     102b36 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102aea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102aed:	8d 50 ff             	lea    -0x1(%eax),%edx
  102af0:	8b 45 20             	mov    0x20(%ebp),%eax
  102af3:	89 44 24 18          	mov    %eax,0x18(%esp)
  102af7:	89 54 24 14          	mov    %edx,0x14(%esp)
  102afb:	8b 45 18             	mov    0x18(%ebp),%eax
  102afe:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b08:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b0c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b17:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1a:	89 04 24             	mov    %eax,(%esp)
  102b1d:	e8 38 ff ff ff       	call   102a5a <printnum>
  102b22:	eb 1c                	jmp    102b40 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b27:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b2b:	8b 45 20             	mov    0x20(%ebp),%eax
  102b2e:	89 04 24             	mov    %eax,(%esp)
  102b31:	8b 45 08             	mov    0x8(%ebp),%eax
  102b34:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b36:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b3a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b3e:	7f e4                	jg     102b24 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b40:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b43:	05 50 3d 10 00       	add    $0x103d50,%eax
  102b48:	0f b6 00             	movzbl (%eax),%eax
  102b4b:	0f be c0             	movsbl %al,%eax
  102b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b51:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b55:	89 04 24             	mov    %eax,(%esp)
  102b58:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5b:	ff d0                	call   *%eax
}
  102b5d:	c9                   	leave  
  102b5e:	c3                   	ret    

00102b5f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b5f:	55                   	push   %ebp
  102b60:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b62:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b66:	7e 14                	jle    102b7c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b68:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6b:	8b 00                	mov    (%eax),%eax
  102b6d:	8d 48 08             	lea    0x8(%eax),%ecx
  102b70:	8b 55 08             	mov    0x8(%ebp),%edx
  102b73:	89 0a                	mov    %ecx,(%edx)
  102b75:	8b 50 04             	mov    0x4(%eax),%edx
  102b78:	8b 00                	mov    (%eax),%eax
  102b7a:	eb 30                	jmp    102bac <getuint+0x4d>
    }
    else if (lflag) {
  102b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b80:	74 16                	je     102b98 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102b82:	8b 45 08             	mov    0x8(%ebp),%eax
  102b85:	8b 00                	mov    (%eax),%eax
  102b87:	8d 48 04             	lea    0x4(%eax),%ecx
  102b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  102b8d:	89 0a                	mov    %ecx,(%edx)
  102b8f:	8b 00                	mov    (%eax),%eax
  102b91:	ba 00 00 00 00       	mov    $0x0,%edx
  102b96:	eb 14                	jmp    102bac <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102b98:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9b:	8b 00                	mov    (%eax),%eax
  102b9d:	8d 48 04             	lea    0x4(%eax),%ecx
  102ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  102ba3:	89 0a                	mov    %ecx,(%edx)
  102ba5:	8b 00                	mov    (%eax),%eax
  102ba7:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102bac:	5d                   	pop    %ebp
  102bad:	c3                   	ret    

00102bae <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102bae:	55                   	push   %ebp
  102baf:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bb1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bb5:	7e 14                	jle    102bcb <getint+0x1d>
        return va_arg(*ap, long long);
  102bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bba:	8b 00                	mov    (%eax),%eax
  102bbc:	8d 48 08             	lea    0x8(%eax),%ecx
  102bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  102bc2:	89 0a                	mov    %ecx,(%edx)
  102bc4:	8b 50 04             	mov    0x4(%eax),%edx
  102bc7:	8b 00                	mov    (%eax),%eax
  102bc9:	eb 28                	jmp    102bf3 <getint+0x45>
    }
    else if (lflag) {
  102bcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bcf:	74 12                	je     102be3 <getint+0x35>
        return va_arg(*ap, long);
  102bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd4:	8b 00                	mov    (%eax),%eax
  102bd6:	8d 48 04             	lea    0x4(%eax),%ecx
  102bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  102bdc:	89 0a                	mov    %ecx,(%edx)
  102bde:	8b 00                	mov    (%eax),%eax
  102be0:	99                   	cltd   
  102be1:	eb 10                	jmp    102bf3 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102be3:	8b 45 08             	mov    0x8(%ebp),%eax
  102be6:	8b 00                	mov    (%eax),%eax
  102be8:	8d 48 04             	lea    0x4(%eax),%ecx
  102beb:	8b 55 08             	mov    0x8(%ebp),%edx
  102bee:	89 0a                	mov    %ecx,(%edx)
  102bf0:	8b 00                	mov    (%eax),%eax
  102bf2:	99                   	cltd   
    }
}
  102bf3:	5d                   	pop    %ebp
  102bf4:	c3                   	ret    

00102bf5 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102bf5:	55                   	push   %ebp
  102bf6:	89 e5                	mov    %esp,%ebp
  102bf8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102bfb:	8d 45 14             	lea    0x14(%ebp),%eax
  102bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c04:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c08:	8b 45 10             	mov    0x10(%ebp),%eax
  102c0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c16:	8b 45 08             	mov    0x8(%ebp),%eax
  102c19:	89 04 24             	mov    %eax,(%esp)
  102c1c:	e8 02 00 00 00       	call   102c23 <vprintfmt>
    va_end(ap);
}
  102c21:	c9                   	leave  
  102c22:	c3                   	ret    

00102c23 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c23:	55                   	push   %ebp
  102c24:	89 e5                	mov    %esp,%ebp
  102c26:	56                   	push   %esi
  102c27:	53                   	push   %ebx
  102c28:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c2b:	eb 18                	jmp    102c45 <vprintfmt+0x22>
            if (ch == '\0') {
  102c2d:	85 db                	test   %ebx,%ebx
  102c2f:	75 05                	jne    102c36 <vprintfmt+0x13>
                return;
  102c31:	e9 d1 03 00 00       	jmp    103007 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c3d:	89 1c 24             	mov    %ebx,(%esp)
  102c40:	8b 45 08             	mov    0x8(%ebp),%eax
  102c43:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c45:	8b 45 10             	mov    0x10(%ebp),%eax
  102c48:	8d 50 01             	lea    0x1(%eax),%edx
  102c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  102c4e:	0f b6 00             	movzbl (%eax),%eax
  102c51:	0f b6 d8             	movzbl %al,%ebx
  102c54:	83 fb 25             	cmp    $0x25,%ebx
  102c57:	75 d4                	jne    102c2d <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c59:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c5d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c67:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102c6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c74:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102c77:	8b 45 10             	mov    0x10(%ebp),%eax
  102c7a:	8d 50 01             	lea    0x1(%eax),%edx
  102c7d:	89 55 10             	mov    %edx,0x10(%ebp)
  102c80:	0f b6 00             	movzbl (%eax),%eax
  102c83:	0f b6 d8             	movzbl %al,%ebx
  102c86:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102c89:	83 f8 55             	cmp    $0x55,%eax
  102c8c:	0f 87 44 03 00 00    	ja     102fd6 <vprintfmt+0x3b3>
  102c92:	8b 04 85 74 3d 10 00 	mov    0x103d74(,%eax,4),%eax
  102c99:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102c9b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102c9f:	eb d6                	jmp    102c77 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102ca1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102ca5:	eb d0                	jmp    102c77 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ca7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102cae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cb1:	89 d0                	mov    %edx,%eax
  102cb3:	c1 e0 02             	shl    $0x2,%eax
  102cb6:	01 d0                	add    %edx,%eax
  102cb8:	01 c0                	add    %eax,%eax
  102cba:	01 d8                	add    %ebx,%eax
  102cbc:	83 e8 30             	sub    $0x30,%eax
  102cbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  102cc5:	0f b6 00             	movzbl (%eax),%eax
  102cc8:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102ccb:	83 fb 2f             	cmp    $0x2f,%ebx
  102cce:	7e 0b                	jle    102cdb <vprintfmt+0xb8>
  102cd0:	83 fb 39             	cmp    $0x39,%ebx
  102cd3:	7f 06                	jg     102cdb <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cd5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102cd9:	eb d3                	jmp    102cae <vprintfmt+0x8b>
            goto process_precision;
  102cdb:	eb 33                	jmp    102d10 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  102ce0:	8d 50 04             	lea    0x4(%eax),%edx
  102ce3:	89 55 14             	mov    %edx,0x14(%ebp)
  102ce6:	8b 00                	mov    (%eax),%eax
  102ce8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102ceb:	eb 23                	jmp    102d10 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102ced:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cf1:	79 0c                	jns    102cff <vprintfmt+0xdc>
                width = 0;
  102cf3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102cfa:	e9 78 ff ff ff       	jmp    102c77 <vprintfmt+0x54>
  102cff:	e9 73 ff ff ff       	jmp    102c77 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d0b:	e9 67 ff ff ff       	jmp    102c77 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102d10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d14:	79 12                	jns    102d28 <vprintfmt+0x105>
                width = precision, precision = -1;
  102d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d19:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d1c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d23:	e9 4f ff ff ff       	jmp    102c77 <vprintfmt+0x54>
  102d28:	e9 4a ff ff ff       	jmp    102c77 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d2d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d31:	e9 41 ff ff ff       	jmp    102c77 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d36:	8b 45 14             	mov    0x14(%ebp),%eax
  102d39:	8d 50 04             	lea    0x4(%eax),%edx
  102d3c:	89 55 14             	mov    %edx,0x14(%ebp)
  102d3f:	8b 00                	mov    (%eax),%eax
  102d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d44:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d48:	89 04 24             	mov    %eax,(%esp)
  102d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4e:	ff d0                	call   *%eax
            break;
  102d50:	e9 ac 02 00 00       	jmp    103001 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d55:	8b 45 14             	mov    0x14(%ebp),%eax
  102d58:	8d 50 04             	lea    0x4(%eax),%edx
  102d5b:	89 55 14             	mov    %edx,0x14(%ebp)
  102d5e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d60:	85 db                	test   %ebx,%ebx
  102d62:	79 02                	jns    102d66 <vprintfmt+0x143>
                err = -err;
  102d64:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d66:	83 fb 06             	cmp    $0x6,%ebx
  102d69:	7f 0b                	jg     102d76 <vprintfmt+0x153>
  102d6b:	8b 34 9d 34 3d 10 00 	mov    0x103d34(,%ebx,4),%esi
  102d72:	85 f6                	test   %esi,%esi
  102d74:	75 23                	jne    102d99 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102d76:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102d7a:	c7 44 24 08 61 3d 10 	movl   $0x103d61,0x8(%esp)
  102d81:	00 
  102d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d89:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8c:	89 04 24             	mov    %eax,(%esp)
  102d8f:	e8 61 fe ff ff       	call   102bf5 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102d94:	e9 68 02 00 00       	jmp    103001 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102d99:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102d9d:	c7 44 24 08 6a 3d 10 	movl   $0x103d6a,0x8(%esp)
  102da4:	00 
  102da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dac:	8b 45 08             	mov    0x8(%ebp),%eax
  102daf:	89 04 24             	mov    %eax,(%esp)
  102db2:	e8 3e fe ff ff       	call   102bf5 <printfmt>
            }
            break;
  102db7:	e9 45 02 00 00       	jmp    103001 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102dbc:	8b 45 14             	mov    0x14(%ebp),%eax
  102dbf:	8d 50 04             	lea    0x4(%eax),%edx
  102dc2:	89 55 14             	mov    %edx,0x14(%ebp)
  102dc5:	8b 30                	mov    (%eax),%esi
  102dc7:	85 f6                	test   %esi,%esi
  102dc9:	75 05                	jne    102dd0 <vprintfmt+0x1ad>
                p = "(null)";
  102dcb:	be 6d 3d 10 00       	mov    $0x103d6d,%esi
            }
            if (width > 0 && padc != '-') {
  102dd0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dd4:	7e 3e                	jle    102e14 <vprintfmt+0x1f1>
  102dd6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102dda:	74 38                	je     102e14 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ddc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102de2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de6:	89 34 24             	mov    %esi,(%esp)
  102de9:	e8 15 03 00 00       	call   103103 <strnlen>
  102dee:	29 c3                	sub    %eax,%ebx
  102df0:	89 d8                	mov    %ebx,%eax
  102df2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102df5:	eb 17                	jmp    102e0e <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102df7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dfe:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e02:	89 04 24             	mov    %eax,(%esp)
  102e05:	8b 45 08             	mov    0x8(%ebp),%eax
  102e08:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e0a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e12:	7f e3                	jg     102df7 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e14:	eb 38                	jmp    102e4e <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e16:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e1a:	74 1f                	je     102e3b <vprintfmt+0x218>
  102e1c:	83 fb 1f             	cmp    $0x1f,%ebx
  102e1f:	7e 05                	jle    102e26 <vprintfmt+0x203>
  102e21:	83 fb 7e             	cmp    $0x7e,%ebx
  102e24:	7e 15                	jle    102e3b <vprintfmt+0x218>
                    putch('?', putdat);
  102e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e2d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e34:	8b 45 08             	mov    0x8(%ebp),%eax
  102e37:	ff d0                	call   *%eax
  102e39:	eb 0f                	jmp    102e4a <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e42:	89 1c 24             	mov    %ebx,(%esp)
  102e45:	8b 45 08             	mov    0x8(%ebp),%eax
  102e48:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e4a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e4e:	89 f0                	mov    %esi,%eax
  102e50:	8d 70 01             	lea    0x1(%eax),%esi
  102e53:	0f b6 00             	movzbl (%eax),%eax
  102e56:	0f be d8             	movsbl %al,%ebx
  102e59:	85 db                	test   %ebx,%ebx
  102e5b:	74 10                	je     102e6d <vprintfmt+0x24a>
  102e5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e61:	78 b3                	js     102e16 <vprintfmt+0x1f3>
  102e63:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e6b:	79 a9                	jns    102e16 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e6d:	eb 17                	jmp    102e86 <vprintfmt+0x263>
                putch(' ', putdat);
  102e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e72:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e76:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e80:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e82:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e8a:	7f e3                	jg     102e6f <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102e8c:	e9 70 01 00 00       	jmp    103001 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102e91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e94:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e98:	8d 45 14             	lea    0x14(%ebp),%eax
  102e9b:	89 04 24             	mov    %eax,(%esp)
  102e9e:	e8 0b fd ff ff       	call   102bae <getint>
  102ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eaf:	85 d2                	test   %edx,%edx
  102eb1:	79 26                	jns    102ed9 <vprintfmt+0x2b6>
                putch('-', putdat);
  102eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eba:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec4:	ff d0                	call   *%eax
                num = -(long long)num;
  102ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ecc:	f7 d8                	neg    %eax
  102ece:	83 d2 00             	adc    $0x0,%edx
  102ed1:	f7 da                	neg    %edx
  102ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ed6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102ed9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ee0:	e9 a8 00 00 00       	jmp    102f8d <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eec:	8d 45 14             	lea    0x14(%ebp),%eax
  102eef:	89 04 24             	mov    %eax,(%esp)
  102ef2:	e8 68 fc ff ff       	call   102b5f <getuint>
  102ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102efa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102efd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f04:	e9 84 00 00 00       	jmp    102f8d <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f10:	8d 45 14             	lea    0x14(%ebp),%eax
  102f13:	89 04 24             	mov    %eax,(%esp)
  102f16:	e8 44 fc ff ff       	call   102b5f <getuint>
  102f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f21:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f28:	eb 63                	jmp    102f8d <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f31:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f38:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3b:	ff d0                	call   *%eax
            putch('x', putdat);
  102f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f40:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f44:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f50:	8b 45 14             	mov    0x14(%ebp),%eax
  102f53:	8d 50 04             	lea    0x4(%eax),%edx
  102f56:	89 55 14             	mov    %edx,0x14(%ebp)
  102f59:	8b 00                	mov    (%eax),%eax
  102f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f65:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102f6c:	eb 1f                	jmp    102f8d <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f71:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f75:	8d 45 14             	lea    0x14(%ebp),%eax
  102f78:	89 04 24             	mov    %eax,(%esp)
  102f7b:	e8 df fb ff ff       	call   102b5f <getuint>
  102f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f83:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102f86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102f8d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f94:	89 54 24 18          	mov    %edx,0x18(%esp)
  102f98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102f9b:	89 54 24 14          	mov    %edx,0x14(%esp)
  102f9f:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fa9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fad:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbb:	89 04 24             	mov    %eax,(%esp)
  102fbe:	e8 97 fa ff ff       	call   102a5a <printnum>
            break;
  102fc3:	eb 3c                	jmp    103001 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fcc:	89 1c 24             	mov    %ebx,(%esp)
  102fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd2:	ff d0                	call   *%eax
            break;
  102fd4:	eb 2b                	jmp    103001 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fdd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102fe9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fed:	eb 04                	jmp    102ff3 <vprintfmt+0x3d0>
  102fef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ff6:	83 e8 01             	sub    $0x1,%eax
  102ff9:	0f b6 00             	movzbl (%eax),%eax
  102ffc:	3c 25                	cmp    $0x25,%al
  102ffe:	75 ef                	jne    102fef <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103000:	90                   	nop
        }
    }
  103001:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103002:	e9 3e fc ff ff       	jmp    102c45 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  103007:	83 c4 40             	add    $0x40,%esp
  10300a:	5b                   	pop    %ebx
  10300b:	5e                   	pop    %esi
  10300c:	5d                   	pop    %ebp
  10300d:	c3                   	ret    

0010300e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10300e:	55                   	push   %ebp
  10300f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103011:	8b 45 0c             	mov    0xc(%ebp),%eax
  103014:	8b 40 08             	mov    0x8(%eax),%eax
  103017:	8d 50 01             	lea    0x1(%eax),%edx
  10301a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103020:	8b 45 0c             	mov    0xc(%ebp),%eax
  103023:	8b 10                	mov    (%eax),%edx
  103025:	8b 45 0c             	mov    0xc(%ebp),%eax
  103028:	8b 40 04             	mov    0x4(%eax),%eax
  10302b:	39 c2                	cmp    %eax,%edx
  10302d:	73 12                	jae    103041 <sprintputch+0x33>
        *b->buf ++ = ch;
  10302f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103032:	8b 00                	mov    (%eax),%eax
  103034:	8d 48 01             	lea    0x1(%eax),%ecx
  103037:	8b 55 0c             	mov    0xc(%ebp),%edx
  10303a:	89 0a                	mov    %ecx,(%edx)
  10303c:	8b 55 08             	mov    0x8(%ebp),%edx
  10303f:	88 10                	mov    %dl,(%eax)
    }
}
  103041:	5d                   	pop    %ebp
  103042:	c3                   	ret    

00103043 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103043:	55                   	push   %ebp
  103044:	89 e5                	mov    %esp,%ebp
  103046:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103049:	8d 45 14             	lea    0x14(%ebp),%eax
  10304c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103052:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103056:	8b 45 10             	mov    0x10(%ebp),%eax
  103059:	89 44 24 08          	mov    %eax,0x8(%esp)
  10305d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103060:	89 44 24 04          	mov    %eax,0x4(%esp)
  103064:	8b 45 08             	mov    0x8(%ebp),%eax
  103067:	89 04 24             	mov    %eax,(%esp)
  10306a:	e8 08 00 00 00       	call   103077 <vsnprintf>
  10306f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103072:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103075:	c9                   	leave  
  103076:	c3                   	ret    

00103077 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103077:	55                   	push   %ebp
  103078:	89 e5                	mov    %esp,%ebp
  10307a:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10307d:	8b 45 08             	mov    0x8(%ebp),%eax
  103080:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103083:	8b 45 0c             	mov    0xc(%ebp),%eax
  103086:	8d 50 ff             	lea    -0x1(%eax),%edx
  103089:	8b 45 08             	mov    0x8(%ebp),%eax
  10308c:	01 d0                	add    %edx,%eax
  10308e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103091:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103098:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10309c:	74 0a                	je     1030a8 <vsnprintf+0x31>
  10309e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030a4:	39 c2                	cmp    %eax,%edx
  1030a6:	76 07                	jbe    1030af <vsnprintf+0x38>
        return -E_INVAL;
  1030a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030ad:	eb 2a                	jmp    1030d9 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030af:	8b 45 14             	mov    0x14(%ebp),%eax
  1030b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030bd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030c4:	c7 04 24 0e 30 10 00 	movl   $0x10300e,(%esp)
  1030cb:	e8 53 fb ff ff       	call   102c23 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1030d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030d3:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030d9:	c9                   	leave  
  1030da:	c3                   	ret    

001030db <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1030db:	55                   	push   %ebp
  1030dc:	89 e5                	mov    %esp,%ebp
  1030de:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030e8:	eb 04                	jmp    1030ee <strlen+0x13>
        cnt ++;
  1030ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f1:	8d 50 01             	lea    0x1(%eax),%edx
  1030f4:	89 55 08             	mov    %edx,0x8(%ebp)
  1030f7:	0f b6 00             	movzbl (%eax),%eax
  1030fa:	84 c0                	test   %al,%al
  1030fc:	75 ec                	jne    1030ea <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1030fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103101:	c9                   	leave  
  103102:	c3                   	ret    

00103103 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103103:	55                   	push   %ebp
  103104:	89 e5                	mov    %esp,%ebp
  103106:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103110:	eb 04                	jmp    103116 <strnlen+0x13>
        cnt ++;
  103112:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103119:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10311c:	73 10                	jae    10312e <strnlen+0x2b>
  10311e:	8b 45 08             	mov    0x8(%ebp),%eax
  103121:	8d 50 01             	lea    0x1(%eax),%edx
  103124:	89 55 08             	mov    %edx,0x8(%ebp)
  103127:	0f b6 00             	movzbl (%eax),%eax
  10312a:	84 c0                	test   %al,%al
  10312c:	75 e4                	jne    103112 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10312e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103131:	c9                   	leave  
  103132:	c3                   	ret    

00103133 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103133:	55                   	push   %ebp
  103134:	89 e5                	mov    %esp,%ebp
  103136:	57                   	push   %edi
  103137:	56                   	push   %esi
  103138:	83 ec 20             	sub    $0x20,%esp
  10313b:	8b 45 08             	mov    0x8(%ebp),%eax
  10313e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103141:	8b 45 0c             	mov    0xc(%ebp),%eax
  103144:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103147:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10314d:	89 d1                	mov    %edx,%ecx
  10314f:	89 c2                	mov    %eax,%edx
  103151:	89 ce                	mov    %ecx,%esi
  103153:	89 d7                	mov    %edx,%edi
  103155:	ac                   	lods   %ds:(%esi),%al
  103156:	aa                   	stos   %al,%es:(%edi)
  103157:	84 c0                	test   %al,%al
  103159:	75 fa                	jne    103155 <strcpy+0x22>
  10315b:	89 fa                	mov    %edi,%edx
  10315d:	89 f1                	mov    %esi,%ecx
  10315f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103162:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103165:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103168:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10316b:	83 c4 20             	add    $0x20,%esp
  10316e:	5e                   	pop    %esi
  10316f:	5f                   	pop    %edi
  103170:	5d                   	pop    %ebp
  103171:	c3                   	ret    

00103172 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103172:	55                   	push   %ebp
  103173:	89 e5                	mov    %esp,%ebp
  103175:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103178:	8b 45 08             	mov    0x8(%ebp),%eax
  10317b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10317e:	eb 21                	jmp    1031a1 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103180:	8b 45 0c             	mov    0xc(%ebp),%eax
  103183:	0f b6 10             	movzbl (%eax),%edx
  103186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103189:	88 10                	mov    %dl,(%eax)
  10318b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10318e:	0f b6 00             	movzbl (%eax),%eax
  103191:	84 c0                	test   %al,%al
  103193:	74 04                	je     103199 <strncpy+0x27>
            src ++;
  103195:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103199:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10319d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1031a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031a5:	75 d9                	jne    103180 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1031a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031aa:	c9                   	leave  
  1031ab:	c3                   	ret    

001031ac <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1031ac:	55                   	push   %ebp
  1031ad:	89 e5                	mov    %esp,%ebp
  1031af:	57                   	push   %edi
  1031b0:	56                   	push   %esi
  1031b1:	83 ec 20             	sub    $0x20,%esp
  1031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1031c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c6:	89 d1                	mov    %edx,%ecx
  1031c8:	89 c2                	mov    %eax,%edx
  1031ca:	89 ce                	mov    %ecx,%esi
  1031cc:	89 d7                	mov    %edx,%edi
  1031ce:	ac                   	lods   %ds:(%esi),%al
  1031cf:	ae                   	scas   %es:(%edi),%al
  1031d0:	75 08                	jne    1031da <strcmp+0x2e>
  1031d2:	84 c0                	test   %al,%al
  1031d4:	75 f8                	jne    1031ce <strcmp+0x22>
  1031d6:	31 c0                	xor    %eax,%eax
  1031d8:	eb 04                	jmp    1031de <strcmp+0x32>
  1031da:	19 c0                	sbb    %eax,%eax
  1031dc:	0c 01                	or     $0x1,%al
  1031de:	89 fa                	mov    %edi,%edx
  1031e0:	89 f1                	mov    %esi,%ecx
  1031e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031e5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1031e8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1031eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1031ee:	83 c4 20             	add    $0x20,%esp
  1031f1:	5e                   	pop    %esi
  1031f2:	5f                   	pop    %edi
  1031f3:	5d                   	pop    %ebp
  1031f4:	c3                   	ret    

001031f5 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1031f5:	55                   	push   %ebp
  1031f6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031f8:	eb 0c                	jmp    103206 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1031fa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103202:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103206:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10320a:	74 1a                	je     103226 <strncmp+0x31>
  10320c:	8b 45 08             	mov    0x8(%ebp),%eax
  10320f:	0f b6 00             	movzbl (%eax),%eax
  103212:	84 c0                	test   %al,%al
  103214:	74 10                	je     103226 <strncmp+0x31>
  103216:	8b 45 08             	mov    0x8(%ebp),%eax
  103219:	0f b6 10             	movzbl (%eax),%edx
  10321c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321f:	0f b6 00             	movzbl (%eax),%eax
  103222:	38 c2                	cmp    %al,%dl
  103224:	74 d4                	je     1031fa <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10322a:	74 18                	je     103244 <strncmp+0x4f>
  10322c:	8b 45 08             	mov    0x8(%ebp),%eax
  10322f:	0f b6 00             	movzbl (%eax),%eax
  103232:	0f b6 d0             	movzbl %al,%edx
  103235:	8b 45 0c             	mov    0xc(%ebp),%eax
  103238:	0f b6 00             	movzbl (%eax),%eax
  10323b:	0f b6 c0             	movzbl %al,%eax
  10323e:	29 c2                	sub    %eax,%edx
  103240:	89 d0                	mov    %edx,%eax
  103242:	eb 05                	jmp    103249 <strncmp+0x54>
  103244:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103249:	5d                   	pop    %ebp
  10324a:	c3                   	ret    

0010324b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10324b:	55                   	push   %ebp
  10324c:	89 e5                	mov    %esp,%ebp
  10324e:	83 ec 04             	sub    $0x4,%esp
  103251:	8b 45 0c             	mov    0xc(%ebp),%eax
  103254:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103257:	eb 14                	jmp    10326d <strchr+0x22>
        if (*s == c) {
  103259:	8b 45 08             	mov    0x8(%ebp),%eax
  10325c:	0f b6 00             	movzbl (%eax),%eax
  10325f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103262:	75 05                	jne    103269 <strchr+0x1e>
            return (char *)s;
  103264:	8b 45 08             	mov    0x8(%ebp),%eax
  103267:	eb 13                	jmp    10327c <strchr+0x31>
        }
        s ++;
  103269:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10326d:	8b 45 08             	mov    0x8(%ebp),%eax
  103270:	0f b6 00             	movzbl (%eax),%eax
  103273:	84 c0                	test   %al,%al
  103275:	75 e2                	jne    103259 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103277:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10327c:	c9                   	leave  
  10327d:	c3                   	ret    

0010327e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10327e:	55                   	push   %ebp
  10327f:	89 e5                	mov    %esp,%ebp
  103281:	83 ec 04             	sub    $0x4,%esp
  103284:	8b 45 0c             	mov    0xc(%ebp),%eax
  103287:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10328a:	eb 11                	jmp    10329d <strfind+0x1f>
        if (*s == c) {
  10328c:	8b 45 08             	mov    0x8(%ebp),%eax
  10328f:	0f b6 00             	movzbl (%eax),%eax
  103292:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103295:	75 02                	jne    103299 <strfind+0x1b>
            break;
  103297:	eb 0e                	jmp    1032a7 <strfind+0x29>
        }
        s ++;
  103299:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10329d:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a0:	0f b6 00             	movzbl (%eax),%eax
  1032a3:	84 c0                	test   %al,%al
  1032a5:	75 e5                	jne    10328c <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1032a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1032aa:	c9                   	leave  
  1032ab:	c3                   	ret    

001032ac <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1032ac:	55                   	push   %ebp
  1032ad:	89 e5                	mov    %esp,%ebp
  1032af:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1032b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032c0:	eb 04                	jmp    1032c6 <strtol+0x1a>
        s ++;
  1032c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c9:	0f b6 00             	movzbl (%eax),%eax
  1032cc:	3c 20                	cmp    $0x20,%al
  1032ce:	74 f2                	je     1032c2 <strtol+0x16>
  1032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d3:	0f b6 00             	movzbl (%eax),%eax
  1032d6:	3c 09                	cmp    $0x9,%al
  1032d8:	74 e8                	je     1032c2 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1032da:	8b 45 08             	mov    0x8(%ebp),%eax
  1032dd:	0f b6 00             	movzbl (%eax),%eax
  1032e0:	3c 2b                	cmp    $0x2b,%al
  1032e2:	75 06                	jne    1032ea <strtol+0x3e>
        s ++;
  1032e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032e8:	eb 15                	jmp    1032ff <strtol+0x53>
    }
    else if (*s == '-') {
  1032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ed:	0f b6 00             	movzbl (%eax),%eax
  1032f0:	3c 2d                	cmp    $0x2d,%al
  1032f2:	75 0b                	jne    1032ff <strtol+0x53>
        s ++, neg = 1;
  1032f4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1032ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103303:	74 06                	je     10330b <strtol+0x5f>
  103305:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103309:	75 24                	jne    10332f <strtol+0x83>
  10330b:	8b 45 08             	mov    0x8(%ebp),%eax
  10330e:	0f b6 00             	movzbl (%eax),%eax
  103311:	3c 30                	cmp    $0x30,%al
  103313:	75 1a                	jne    10332f <strtol+0x83>
  103315:	8b 45 08             	mov    0x8(%ebp),%eax
  103318:	83 c0 01             	add    $0x1,%eax
  10331b:	0f b6 00             	movzbl (%eax),%eax
  10331e:	3c 78                	cmp    $0x78,%al
  103320:	75 0d                	jne    10332f <strtol+0x83>
        s += 2, base = 16;
  103322:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103326:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10332d:	eb 2a                	jmp    103359 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10332f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103333:	75 17                	jne    10334c <strtol+0xa0>
  103335:	8b 45 08             	mov    0x8(%ebp),%eax
  103338:	0f b6 00             	movzbl (%eax),%eax
  10333b:	3c 30                	cmp    $0x30,%al
  10333d:	75 0d                	jne    10334c <strtol+0xa0>
        s ++, base = 8;
  10333f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103343:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10334a:	eb 0d                	jmp    103359 <strtol+0xad>
    }
    else if (base == 0) {
  10334c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103350:	75 07                	jne    103359 <strtol+0xad>
        base = 10;
  103352:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103359:	8b 45 08             	mov    0x8(%ebp),%eax
  10335c:	0f b6 00             	movzbl (%eax),%eax
  10335f:	3c 2f                	cmp    $0x2f,%al
  103361:	7e 1b                	jle    10337e <strtol+0xd2>
  103363:	8b 45 08             	mov    0x8(%ebp),%eax
  103366:	0f b6 00             	movzbl (%eax),%eax
  103369:	3c 39                	cmp    $0x39,%al
  10336b:	7f 11                	jg     10337e <strtol+0xd2>
            dig = *s - '0';
  10336d:	8b 45 08             	mov    0x8(%ebp),%eax
  103370:	0f b6 00             	movzbl (%eax),%eax
  103373:	0f be c0             	movsbl %al,%eax
  103376:	83 e8 30             	sub    $0x30,%eax
  103379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10337c:	eb 48                	jmp    1033c6 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10337e:	8b 45 08             	mov    0x8(%ebp),%eax
  103381:	0f b6 00             	movzbl (%eax),%eax
  103384:	3c 60                	cmp    $0x60,%al
  103386:	7e 1b                	jle    1033a3 <strtol+0xf7>
  103388:	8b 45 08             	mov    0x8(%ebp),%eax
  10338b:	0f b6 00             	movzbl (%eax),%eax
  10338e:	3c 7a                	cmp    $0x7a,%al
  103390:	7f 11                	jg     1033a3 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103392:	8b 45 08             	mov    0x8(%ebp),%eax
  103395:	0f b6 00             	movzbl (%eax),%eax
  103398:	0f be c0             	movsbl %al,%eax
  10339b:	83 e8 57             	sub    $0x57,%eax
  10339e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033a1:	eb 23                	jmp    1033c6 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a6:	0f b6 00             	movzbl (%eax),%eax
  1033a9:	3c 40                	cmp    $0x40,%al
  1033ab:	7e 3d                	jle    1033ea <strtol+0x13e>
  1033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b0:	0f b6 00             	movzbl (%eax),%eax
  1033b3:	3c 5a                	cmp    $0x5a,%al
  1033b5:	7f 33                	jg     1033ea <strtol+0x13e>
            dig = *s - 'A' + 10;
  1033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ba:	0f b6 00             	movzbl (%eax),%eax
  1033bd:	0f be c0             	movsbl %al,%eax
  1033c0:	83 e8 37             	sub    $0x37,%eax
  1033c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  1033cc:	7c 02                	jl     1033d0 <strtol+0x124>
            break;
  1033ce:	eb 1a                	jmp    1033ea <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1033d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033d7:	0f af 45 10          	imul   0x10(%ebp),%eax
  1033db:	89 c2                	mov    %eax,%edx
  1033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033e0:	01 d0                	add    %edx,%eax
  1033e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1033e5:	e9 6f ff ff ff       	jmp    103359 <strtol+0xad>

    if (endptr) {
  1033ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033ee:	74 08                	je     1033f8 <strtol+0x14c>
        *endptr = (char *) s;
  1033f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1033f6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1033f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1033fc:	74 07                	je     103405 <strtol+0x159>
  1033fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103401:	f7 d8                	neg    %eax
  103403:	eb 03                	jmp    103408 <strtol+0x15c>
  103405:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103408:	c9                   	leave  
  103409:	c3                   	ret    

0010340a <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10340a:	55                   	push   %ebp
  10340b:	89 e5                	mov    %esp,%ebp
  10340d:	57                   	push   %edi
  10340e:	83 ec 24             	sub    $0x24,%esp
  103411:	8b 45 0c             	mov    0xc(%ebp),%eax
  103414:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103417:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10341b:	8b 55 08             	mov    0x8(%ebp),%edx
  10341e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103421:	88 45 f7             	mov    %al,-0x9(%ebp)
  103424:	8b 45 10             	mov    0x10(%ebp),%eax
  103427:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10342a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10342d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103431:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103434:	89 d7                	mov    %edx,%edi
  103436:	f3 aa                	rep stos %al,%es:(%edi)
  103438:	89 fa                	mov    %edi,%edx
  10343a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10343d:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103440:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103443:	83 c4 24             	add    $0x24,%esp
  103446:	5f                   	pop    %edi
  103447:	5d                   	pop    %ebp
  103448:	c3                   	ret    

00103449 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103449:	55                   	push   %ebp
  10344a:	89 e5                	mov    %esp,%ebp
  10344c:	57                   	push   %edi
  10344d:	56                   	push   %esi
  10344e:	53                   	push   %ebx
  10344f:	83 ec 30             	sub    $0x30,%esp
  103452:	8b 45 08             	mov    0x8(%ebp),%eax
  103455:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103458:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10345e:	8b 45 10             	mov    0x10(%ebp),%eax
  103461:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103467:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10346a:	73 42                	jae    1034ae <memmove+0x65>
  10346c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10346f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103475:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10347b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10347e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103481:	c1 e8 02             	shr    $0x2,%eax
  103484:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103486:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10348c:	89 d7                	mov    %edx,%edi
  10348e:	89 c6                	mov    %eax,%esi
  103490:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103492:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103495:	83 e1 03             	and    $0x3,%ecx
  103498:	74 02                	je     10349c <memmove+0x53>
  10349a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10349c:	89 f0                	mov    %esi,%eax
  10349e:	89 fa                	mov    %edi,%edx
  1034a0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1034a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1034a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034ac:	eb 36                	jmp    1034e4 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034b7:	01 c2                	add    %eax,%edx
  1034b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034bc:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034c2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1034c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034c8:	89 c1                	mov    %eax,%ecx
  1034ca:	89 d8                	mov    %ebx,%eax
  1034cc:	89 d6                	mov    %edx,%esi
  1034ce:	89 c7                	mov    %eax,%edi
  1034d0:	fd                   	std    
  1034d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034d3:	fc                   	cld    
  1034d4:	89 f8                	mov    %edi,%eax
  1034d6:	89 f2                	mov    %esi,%edx
  1034d8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1034db:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1034de:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1034e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1034e4:	83 c4 30             	add    $0x30,%esp
  1034e7:	5b                   	pop    %ebx
  1034e8:	5e                   	pop    %esi
  1034e9:	5f                   	pop    %edi
  1034ea:	5d                   	pop    %ebp
  1034eb:	c3                   	ret    

001034ec <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1034ec:	55                   	push   %ebp
  1034ed:	89 e5                	mov    %esp,%ebp
  1034ef:	57                   	push   %edi
  1034f0:	56                   	push   %esi
  1034f1:	83 ec 20             	sub    $0x20,%esp
  1034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103500:	8b 45 10             	mov    0x10(%ebp),%eax
  103503:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103509:	c1 e8 02             	shr    $0x2,%eax
  10350c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10350e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103514:	89 d7                	mov    %edx,%edi
  103516:	89 c6                	mov    %eax,%esi
  103518:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10351a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10351d:	83 e1 03             	and    $0x3,%ecx
  103520:	74 02                	je     103524 <memcpy+0x38>
  103522:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103524:	89 f0                	mov    %esi,%eax
  103526:	89 fa                	mov    %edi,%edx
  103528:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10352b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10352e:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103531:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103534:	83 c4 20             	add    $0x20,%esp
  103537:	5e                   	pop    %esi
  103538:	5f                   	pop    %edi
  103539:	5d                   	pop    %ebp
  10353a:	c3                   	ret    

0010353b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10353b:	55                   	push   %ebp
  10353c:	89 e5                	mov    %esp,%ebp
  10353e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103541:	8b 45 08             	mov    0x8(%ebp),%eax
  103544:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103547:	8b 45 0c             	mov    0xc(%ebp),%eax
  10354a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10354d:	eb 30                	jmp    10357f <memcmp+0x44>
        if (*s1 != *s2) {
  10354f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103552:	0f b6 10             	movzbl (%eax),%edx
  103555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103558:	0f b6 00             	movzbl (%eax),%eax
  10355b:	38 c2                	cmp    %al,%dl
  10355d:	74 18                	je     103577 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10355f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103562:	0f b6 00             	movzbl (%eax),%eax
  103565:	0f b6 d0             	movzbl %al,%edx
  103568:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10356b:	0f b6 00             	movzbl (%eax),%eax
  10356e:	0f b6 c0             	movzbl %al,%eax
  103571:	29 c2                	sub    %eax,%edx
  103573:	89 d0                	mov    %edx,%eax
  103575:	eb 1a                	jmp    103591 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103577:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10357b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10357f:	8b 45 10             	mov    0x10(%ebp),%eax
  103582:	8d 50 ff             	lea    -0x1(%eax),%edx
  103585:	89 55 10             	mov    %edx,0x10(%ebp)
  103588:	85 c0                	test   %eax,%eax
  10358a:	75 c3                	jne    10354f <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10358c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103591:	c9                   	leave  
  103592:	c3                   	ret    
