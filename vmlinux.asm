
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_skernel>:
    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    # Set up the stack
    la sp, boot_stack_top
    80200000:	00003117          	auipc	sp,0x3
    80200004:	02013103          	ld	sp,32(sp) # 80203020 <_GLOBAL_OFFSET_TABLE_+0x18>

    # Initialize physical memory management
    jal mm_init
    80200008:	3b0000ef          	jal	802003b8 <mm_init>

    # Initialize process table and first processes
    jal task_init
    8020000c:	3f0000ef          	jal	802003fc <task_init>

    # Set stvec = _traps
    la t0, _traps
    80200010:	00003297          	auipc	t0,0x3
    80200014:	0202b283          	ld	t0,32(t0) # 80203030 <_GLOBAL_OFFSET_TABLE_+0x28>
    csrw stvec, t0
    80200018:	10529073          	csrw	stvec,t0

    # sie[STIE] = 1
    csrr t0,sie
    8020001c:	104022f3          	csrr	t0,sie
    ori t0, t0, 0x20
    80200020:	0202e293          	ori	t0,t0,32
    csrw sie, t0
    80200024:	10429073          	csrw	sie,t0

    # Set the timer for the first time
    call sbi_set_timer
    80200028:	28d000ef          	jal	80200ab4 <sbi_set_timer>

    # Interrupts globally enabled: sstatus[SIE] = 1
    csrr t0, sstatus
    8020002c:	100022f3          	csrr	t0,sstatus
    ori t0, t0, 0x02
    80200030:	0022e293          	ori	t0,t0,2
    csrw sstatus, t0
    80200034:	10029073          	csrw	sstatus,t0

    # Jump to the C kernel entry point
    jal start_kernel
    80200038:	6b1000ef          	jal	80200ee8 <start_kernel>

000000008020003c <_traps>:
    .section .text.entry
    .align 2
    .globl _traps 
_traps:
    # save 32 registers and sepc
    addi sp, sp, -264
    8020003c:	ef810113          	addi	sp,sp,-264
    sd x0, 0(sp)
    80200040:	00013023          	sd	zero,0(sp)
    sd x1, 8(sp)
    80200044:	00113423          	sd	ra,8(sp)
    sd x2, 16(sp)
    80200048:	00213823          	sd	sp,16(sp)
    sd x3, 24(sp)
    8020004c:	00313c23          	sd	gp,24(sp)
    sd x4, 32(sp)
    80200050:	02413023          	sd	tp,32(sp)
    sd x5, 40(sp)
    80200054:	02513423          	sd	t0,40(sp)
    sd x6, 48(sp)
    80200058:	02613823          	sd	t1,48(sp)
    sd x7, 56(sp)
    8020005c:	02713c23          	sd	t2,56(sp)
    sd x8, 64(sp)
    80200060:	04813023          	sd	s0,64(sp)
    sd x9, 72(sp)
    80200064:	04913423          	sd	s1,72(sp)
    sd x10, 80(sp)
    80200068:	04a13823          	sd	a0,80(sp)
    sd x11, 88(sp)
    8020006c:	04b13c23          	sd	a1,88(sp)
    sd x12, 96(sp)
    80200070:	06c13023          	sd	a2,96(sp)
    sd x13, 104(sp)
    80200074:	06d13423          	sd	a3,104(sp)
    sd x14, 112(sp)
    80200078:	06e13823          	sd	a4,112(sp)
    sd x15, 120(sp)
    8020007c:	06f13c23          	sd	a5,120(sp)
    sd x16, 128(sp)
    80200080:	09013023          	sd	a6,128(sp)
    sd x17, 136(sp)
    80200084:	09113423          	sd	a7,136(sp)
    sd x18, 144(sp)
    80200088:	09213823          	sd	s2,144(sp)
    sd x19, 152(sp)
    8020008c:	09313c23          	sd	s3,152(sp)
    sd x20, 160(sp)
    80200090:	0b413023          	sd	s4,160(sp)
    sd x21, 168(sp)
    80200094:	0b513423          	sd	s5,168(sp)
    sd x22, 176(sp)
    80200098:	0b613823          	sd	s6,176(sp)
    sd x23, 184(sp)
    8020009c:	0b713c23          	sd	s7,184(sp)
    sd x24, 192(sp)
    802000a0:	0d813023          	sd	s8,192(sp)
    sd x25, 200(sp)
    802000a4:	0d913423          	sd	s9,200(sp)
    sd x26, 208(sp)
    802000a8:	0da13823          	sd	s10,208(sp)
    sd x27, 216(sp)
    802000ac:	0db13c23          	sd	s11,216(sp)
    sd x28, 224(sp)
    802000b0:	0fc13023          	sd	t3,224(sp)
    sd x29, 232(sp)
    802000b4:	0fd13423          	sd	t4,232(sp)
    sd x30, 240(sp)
    802000b8:	0fe13823          	sd	t5,240(sp)
    sd x31, 248(sp)
    802000bc:	0ff13c23          	sd	t6,248(sp)

    # save sepc
    csrr t0, sepc
    802000c0:	141022f3          	csrr	t0,sepc
    sd t0, 256(sp)
    802000c4:	10513023          	sd	t0,256(sp)

    # set arguments for trap_handler and call it
    csrr a0, scause
    802000c8:	14202573          	csrr	a0,scause
    csrr a1, sepc
    802000cc:	141025f3          	csrr	a1,sepc
    call trap_handler
    802000d0:	3ed000ef          	jal	80200cbc <trap_handler>

    # restore sepc
    ld t0, 256(sp)
    802000d4:	10013283          	ld	t0,256(sp)
    csrw sepc, t0
    802000d8:	14129073          	csrw	sepc,t0

    # restore 32 registers
    ld x0, 0(sp)
    802000dc:	00013003          	ld	zero,0(sp)
    ld x1, 8(sp)
    802000e0:	00813083          	ld	ra,8(sp)
    # restore x2(sp) last
    ld x3, 24(sp)
    802000e4:	01813183          	ld	gp,24(sp)
    ld x4, 32(sp)
    802000e8:	02013203          	ld	tp,32(sp)
    ld x5, 40(sp)
    802000ec:	02813283          	ld	t0,40(sp)
    ld x6, 48(sp)
    802000f0:	03013303          	ld	t1,48(sp)
    ld x7, 56(sp)
    802000f4:	03813383          	ld	t2,56(sp)
    ld x8, 64(sp)
    802000f8:	04013403          	ld	s0,64(sp)
    ld x9, 72(sp)
    802000fc:	04813483          	ld	s1,72(sp)
    ld x10, 80(sp)
    80200100:	05013503          	ld	a0,80(sp)
    ld x11, 88(sp)
    80200104:	05813583          	ld	a1,88(sp)
    ld x12, 96(sp)
    80200108:	06013603          	ld	a2,96(sp)
    ld x13, 104(sp)
    8020010c:	06813683          	ld	a3,104(sp)
    ld x14, 112(sp)
    80200110:	07013703          	ld	a4,112(sp)
    ld x15, 120(sp)
    80200114:	07813783          	ld	a5,120(sp)
    ld x16, 128(sp)
    80200118:	08013803          	ld	a6,128(sp)
    ld x17, 136(sp)
    8020011c:	08813883          	ld	a7,136(sp)
    ld x18, 144(sp)
    80200120:	09013903          	ld	s2,144(sp)
    ld x19, 152(sp)
    80200124:	09813983          	ld	s3,152(sp)
    ld x20, 160(sp)
    80200128:	0a013a03          	ld	s4,160(sp)
    ld x21, 168(sp)
    8020012c:	0a813a83          	ld	s5,168(sp)
    ld x22, 176(sp)
    80200130:	0b013b03          	ld	s6,176(sp)
    ld x23, 184(sp)
    80200134:	0b813b83          	ld	s7,184(sp)
    ld x24, 192(sp)
    80200138:	0c013c03          	ld	s8,192(sp)
    ld x25, 200(sp)
    8020013c:	0c813c83          	ld	s9,200(sp)
    ld x26, 208(sp)
    80200140:	0d013d03          	ld	s10,208(sp)
    ld x27, 216(sp)
    80200144:	0d813d83          	ld	s11,216(sp)
    ld x28, 224(sp)
    80200148:	0e013e03          	ld	t3,224(sp)
    ld x29, 232(sp)
    8020014c:	0e813e83          	ld	t4,232(sp)
    ld x30, 240(sp)
    80200150:	0f013f03          	ld	t5,240(sp)
    ld x31, 248(sp)
    80200154:	0f813f83          	ld	t6,248(sp)

    # restore x2(sp) last
    ld x2, 16(sp)
    80200158:	01013103          	ld	sp,16(sp)

    addi sp, sp, 264
    8020015c:	10810113          	addi	sp,sp,264
    # return from trap
    sret
    80200160:	10200073          	sret

0000000080200164 <__dummy>:

    .extern dummy
    .global __dummy
__dummy:
    la t0, dummy
    80200164:	00003297          	auipc	t0,0x3
    80200168:	ec42b283          	ld	t0,-316(t0) # 80203028 <_GLOBAL_OFFSET_TABLE_+0x20>
    csrw sepc, t0
    8020016c:	14129073          	csrw	sepc,t0
    sret
    80200170:	10200073          	sret

0000000080200174 <__switch_to>:

    .globl __switch_to
__switch_to:
    # save state to prev process
    # 4 variables in task_struct: 4*8 = 32 bytes
    addi t0, a0, 32
    80200174:	02050293          	addi	t0,a0,32
    sd ra, 0(t0)
    80200178:	0012b023          	sd	ra,0(t0)
    sd sp, 8(t0)
    8020017c:	0022b423          	sd	sp,8(t0)
    sd s0, 16(t0)
    80200180:	0082b823          	sd	s0,16(t0)
    sd s1, 24(t0)
    80200184:	0092bc23          	sd	s1,24(t0)
    sd s2, 32(t0)
    80200188:	0322b023          	sd	s2,32(t0)
    sd s3, 40(t0)
    8020018c:	0332b423          	sd	s3,40(t0)
    sd s4, 48(t0)
    80200190:	0342b823          	sd	s4,48(t0)
    sd s5, 56(t0)
    80200194:	0352bc23          	sd	s5,56(t0)
    sd s6, 64(t0)
    80200198:	0562b023          	sd	s6,64(t0)
    sd s7, 72(t0)
    8020019c:	0572b423          	sd	s7,72(t0)
    sd s8, 80(t0)
    802001a0:	0582b823          	sd	s8,80(t0)
    sd s9, 88(t0)
    802001a4:	0592bc23          	sd	s9,88(t0)
    sd s10, 96(t0)
    802001a8:	07a2b023          	sd	s10,96(t0)
    sd s11, 104(t0)
    802001ac:	07b2b423          	sd	s11,104(t0)

    # restore state from next process
    addi t0, a1, 32
    802001b0:	02058293          	addi	t0,a1,32
    ld ra, 0(t0)
    802001b4:	0002b083          	ld	ra,0(t0)
    ld sp, 8(t0)
    802001b8:	0082b103          	ld	sp,8(t0)
    ld s0, 16(t0)
    802001bc:	0102b403          	ld	s0,16(t0)
    ld s1, 24(t0)
    802001c0:	0182b483          	ld	s1,24(t0)
    ld s2, 32(t0)
    802001c4:	0202b903          	ld	s2,32(t0)
    ld s3, 40(t0)
    802001c8:	0282b983          	ld	s3,40(t0)
    ld s4, 48(t0)
    802001cc:	0302ba03          	ld	s4,48(t0)
    ld s5, 56(t0)
    802001d0:	0382ba83          	ld	s5,56(t0)
    ld s6, 64(t0)
    802001d4:	0402bb03          	ld	s6,64(t0)
    ld s7, 72(t0)
    802001d8:	0482bb83          	ld	s7,72(t0)
    ld s8, 80(t0)
    802001dc:	0502bc03          	ld	s8,80(t0)
    ld s9, 88(t0)
    802001e0:	0582bc83          	ld	s9,88(t0)
    ld s10, 96(t0)
    802001e4:	0602bd03          	ld	s10,96(t0)
    ld s11, 104(t0)
    802001e8:	0682bd83          	ld	s11,104(t0)

    802001ec:	00008067          	ret

00000000802001f0 <get_cycles>:
#include "clock.h"

// Clock frequency in QEMU = 10MHz
unsigned long TIMECLOCK = 10000000;

uint64_t get_cycles() {
    802001f0:	fe010113          	addi	sp,sp,-32
    802001f4:	00813c23          	sd	s0,24(sp)
    802001f8:	02010413          	addi	s0,sp,32
    unsigned long t;
    __asm__ volatile(
    802001fc:	c01027f3          	rdtime	a5
    80200200:	fef43423          	sd	a5,-24(s0)
        "rdtime %[t]"
        :[t] "=r" (t)
        :
        : "memory"
    );
    return t;
    80200204:	fe843783          	ld	a5,-24(s0)
}
    80200208:	00078513          	mv	a0,a5
    8020020c:	01813403          	ld	s0,24(sp)
    80200210:	02010113          	addi	sp,sp,32
    80200214:	00008067          	ret

0000000080200218 <clock_set_next_event>:

void clock_set_next_event() {
    80200218:	fe010113          	addi	sp,sp,-32
    8020021c:	00113c23          	sd	ra,24(sp)
    80200220:	00813823          	sd	s0,16(sp)
    80200224:	02010413          	addi	s0,sp,32
    // set the register mtimecmp,
    // next interrupt happens TIMECLOCK cycles later
    unsigned long next = get_cycles() + TIMECLOCK;
    80200228:	fc9ff0ef          	jal	802001f0 <get_cycles>
    8020022c:	00050713          	mv	a4,a0
    80200230:	00003797          	auipc	a5,0x3
    80200234:	dd078793          	addi	a5,a5,-560 # 80203000 <TIMECLOCK>
    80200238:	0007b783          	ld	a5,0(a5)
    8020023c:	00f707b3          	add	a5,a4,a5
    80200240:	fef43423          	sd	a5,-24(s0)
    sbi_set_timer(next);
    80200244:	fe843503          	ld	a0,-24(s0)
    80200248:	06d000ef          	jal	80200ab4 <sbi_set_timer>
    8020024c:	00000013          	nop
    80200250:	01813083          	ld	ra,24(sp)
    80200254:	01013403          	ld	s0,16(sp)
    80200258:	02010113          	addi	sp,sp,32
    8020025c:	00008067          	ret

0000000080200260 <kalloc>:

struct {
    struct run *freelist;
} kmem;

void *kalloc() {
    80200260:	fe010113          	addi	sp,sp,-32
    80200264:	00113c23          	sd	ra,24(sp)
    80200268:	00813823          	sd	s0,16(sp)
    8020026c:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
    80200270:	00005797          	auipc	a5,0x5
    80200274:	d9078793          	addi	a5,a5,-624 # 80205000 <kmem>
    80200278:	0007b783          	ld	a5,0(a5)
    8020027c:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
    80200280:	fe843783          	ld	a5,-24(s0)
    80200284:	0007b703          	ld	a4,0(a5)
    80200288:	00005797          	auipc	a5,0x5
    8020028c:	d7878793          	addi	a5,a5,-648 # 80205000 <kmem>
    80200290:	00e7b023          	sd	a4,0(a5)
    
    memset((void *)r, 0x0, PGSIZE);
    80200294:	00001637          	lui	a2,0x1
    80200298:	00000593          	li	a1,0
    8020029c:	fe843503          	ld	a0,-24(s0)
    802002a0:	491010ef          	jal	80201f30 <memset>
    return (void *)r;
    802002a4:	fe843783          	ld	a5,-24(s0)
}
    802002a8:	00078513          	mv	a0,a5
    802002ac:	01813083          	ld	ra,24(sp)
    802002b0:	01013403          	ld	s0,16(sp)
    802002b4:	02010113          	addi	sp,sp,32
    802002b8:	00008067          	ret

00000000802002bc <kfree>:

void kfree(void *addr) {
    802002bc:	fd010113          	addi	sp,sp,-48
    802002c0:	02113423          	sd	ra,40(sp)
    802002c4:	02813023          	sd	s0,32(sp)
    802002c8:	03010413          	addi	s0,sp,48
    802002cc:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    *(uintptr_t *)&addr = (uintptr_t)addr & ~(PGSIZE - 1);
    802002d0:	fd843783          	ld	a5,-40(s0)
    802002d4:	00078693          	mv	a3,a5
    802002d8:	fd840793          	addi	a5,s0,-40
    802002dc:	fffff737          	lui	a4,0xfffff
    802002e0:	00e6f733          	and	a4,a3,a4
    802002e4:	00e7b023          	sd	a4,0(a5)

    memset(addr, 0x0, (uint64_t)PGSIZE);
    802002e8:	fd843783          	ld	a5,-40(s0)
    802002ec:	00001637          	lui	a2,0x1
    802002f0:	00000593          	li	a1,0
    802002f4:	00078513          	mv	a0,a5
    802002f8:	439010ef          	jal	80201f30 <memset>

    r = (struct run *)addr;
    802002fc:	fd843783          	ld	a5,-40(s0)
    80200300:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
    80200304:	00005797          	auipc	a5,0x5
    80200308:	cfc78793          	addi	a5,a5,-772 # 80205000 <kmem>
    8020030c:	0007b703          	ld	a4,0(a5)
    80200310:	fe843783          	ld	a5,-24(s0)
    80200314:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
    80200318:	00005797          	auipc	a5,0x5
    8020031c:	ce878793          	addi	a5,a5,-792 # 80205000 <kmem>
    80200320:	fe843703          	ld	a4,-24(s0)
    80200324:	00e7b023          	sd	a4,0(a5)

    return;
    80200328:	00000013          	nop
}
    8020032c:	02813083          	ld	ra,40(sp)
    80200330:	02013403          	ld	s0,32(sp)
    80200334:	03010113          	addi	sp,sp,48
    80200338:	00008067          	ret

000000008020033c <kfreerange>:

void kfreerange(char *start, char *end) {
    8020033c:	fd010113          	addi	sp,sp,-48
    80200340:	02113423          	sd	ra,40(sp)
    80200344:	02813023          	sd	s0,32(sp)
    80200348:	03010413          	addi	s0,sp,48
    8020034c:	fca43c23          	sd	a0,-40(s0)
    80200350:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
    80200354:	fd843703          	ld	a4,-40(s0)
    80200358:	000017b7          	lui	a5,0x1
    8020035c:	fff78793          	addi	a5,a5,-1 # fff <_skernel-0x801ff001>
    80200360:	00f70733          	add	a4,a4,a5
    80200364:	fffff7b7          	lui	a5,0xfffff
    80200368:	00f777b3          	and	a5,a4,a5
    8020036c:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    80200370:	01c0006f          	j	8020038c <kfreerange+0x50>
        kfree((void *)addr);
    80200374:	fe843503          	ld	a0,-24(s0)
    80200378:	f45ff0ef          	jal	802002bc <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    8020037c:	fe843703          	ld	a4,-24(s0)
    80200380:	000017b7          	lui	a5,0x1
    80200384:	00f707b3          	add	a5,a4,a5
    80200388:	fef43423          	sd	a5,-24(s0)
    8020038c:	fe843703          	ld	a4,-24(s0)
    80200390:	000017b7          	lui	a5,0x1
    80200394:	00f70733          	add	a4,a4,a5
    80200398:	fd043783          	ld	a5,-48(s0)
    8020039c:	fce7fce3          	bgeu	a5,a4,80200374 <kfreerange+0x38>
    }
}
    802003a0:	00000013          	nop
    802003a4:	00000013          	nop
    802003a8:	02813083          	ld	ra,40(sp)
    802003ac:	02013403          	ld	s0,32(sp)
    802003b0:	03010113          	addi	sp,sp,48
    802003b4:	00008067          	ret

00000000802003b8 <mm_init>:

void mm_init(void) {
    802003b8:	ff010113          	addi	sp,sp,-16
    802003bc:	00113423          	sd	ra,8(sp)
    802003c0:	00813023          	sd	s0,0(sp)
    802003c4:	01010413          	addi	s0,sp,16
    kfreerange(_ekernel, (char *)PHY_END);
    802003c8:	01100793          	li	a5,17
    802003cc:	01b79593          	slli	a1,a5,0x1b
    802003d0:	00003517          	auipc	a0,0x3
    802003d4:	c4053503          	ld	a0,-960(a0) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>
    802003d8:	f65ff0ef          	jal	8020033c <kfreerange>
    printk("...mm_init done!\n");
    802003dc:	00002517          	auipc	a0,0x2
    802003e0:	c2450513          	addi	a0,a0,-988 # 80202000 <_srodata>
    802003e4:	22d010ef          	jal	80201e10 <printk>
}
    802003e8:	00000013          	nop
    802003ec:	00813083          	ld	ra,8(sp)
    802003f0:	00013403          	ld	s0,0(sp)
    802003f4:	01010113          	addi	sp,sp,16
    802003f8:	00008067          	ret

00000000802003fc <task_init>:

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
    802003fc:	fe010113          	addi	sp,sp,-32
    80200400:	00113c23          	sd	ra,24(sp)
    80200404:	00813823          	sd	s0,16(sp)
    80200408:	02010413          	addi	s0,sp,32
    srand(2024);
    8020040c:	7e800513          	li	a0,2024
    80200410:	281010ef          	jal	80201e90 <srand>
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    idle = (struct task_struct *)kalloc();
    80200414:	e4dff0ef          	jal	80200260 <kalloc>
    80200418:	00050713          	mv	a4,a0
    8020041c:	00005797          	auipc	a5,0x5
    80200420:	bec78793          	addi	a5,a5,-1044 # 80205008 <idle>
    80200424:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
    80200428:	00005797          	auipc	a5,0x5
    8020042c:	be078793          	addi	a5,a5,-1056 # 80205008 <idle>
    80200430:	0007b783          	ld	a5,0(a5)
    80200434:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
    80200438:	00005797          	auipc	a5,0x5
    8020043c:	bd078793          	addi	a5,a5,-1072 # 80205008 <idle>
    80200440:	0007b783          	ld	a5,0(a5)
    80200444:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
    80200448:	00005797          	auipc	a5,0x5
    8020044c:	bc078793          	addi	a5,a5,-1088 # 80205008 <idle>
    80200450:	0007b783          	ld	a5,0(a5)
    80200454:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
    80200458:	00005797          	auipc	a5,0x5
    8020045c:	bb078793          	addi	a5,a5,-1104 # 80205008 <idle>
    80200460:	0007b783          	ld	a5,0(a5)
    80200464:	0007bc23          	sd	zero,24(a5)
    current = idle;
    80200468:	00005797          	auipc	a5,0x5
    8020046c:	ba078793          	addi	a5,a5,-1120 # 80205008 <idle>
    80200470:	0007b703          	ld	a4,0(a5)
    80200474:	00005797          	auipc	a5,0x5
    80200478:	b9c78793          	addi	a5,a5,-1124 # 80205010 <current>
    8020047c:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
    80200480:	00005797          	auipc	a5,0x5
    80200484:	b8878793          	addi	a5,a5,-1144 # 80205008 <idle>
    80200488:	0007b703          	ld	a4,0(a5)
    8020048c:	00005797          	auipc	a5,0x5
    80200490:	b8c78793          	addi	a5,a5,-1140 # 80205018 <task>
    80200494:	00e7b023          	sd	a4,0(a5)
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    for (int i = 1; i < NR_TASKS; i++) {
    80200498:	00100793          	li	a5,1
    8020049c:	fef42623          	sw	a5,-20(s0)
    802004a0:	12c0006f          	j	802005cc <task_init+0x1d0>
        task[i] = (struct task_struct *)kalloc();
    802004a4:	dbdff0ef          	jal	80200260 <kalloc>
    802004a8:	00050693          	mv	a3,a0
    802004ac:	00005717          	auipc	a4,0x5
    802004b0:	b6c70713          	addi	a4,a4,-1172 # 80205018 <task>
    802004b4:	fec42783          	lw	a5,-20(s0)
    802004b8:	00379793          	slli	a5,a5,0x3
    802004bc:	00f707b3          	add	a5,a4,a5
    802004c0:	00d7b023          	sd	a3,0(a5)
        task[i]->state = TASK_RUNNING;
    802004c4:	00005717          	auipc	a4,0x5
    802004c8:	b5470713          	addi	a4,a4,-1196 # 80205018 <task>
    802004cc:	fec42783          	lw	a5,-20(s0)
    802004d0:	00379793          	slli	a5,a5,0x3
    802004d4:	00f707b3          	add	a5,a4,a5
    802004d8:	0007b783          	ld	a5,0(a5)
    802004dc:	0007b023          	sd	zero,0(a5)
        task[i]->counter = 0;
    802004e0:	00005717          	auipc	a4,0x5
    802004e4:	b3870713          	addi	a4,a4,-1224 # 80205018 <task>
    802004e8:	fec42783          	lw	a5,-20(s0)
    802004ec:	00379793          	slli	a5,a5,0x3
    802004f0:	00f707b3          	add	a5,a4,a5
    802004f4:	0007b783          	ld	a5,0(a5)
    802004f8:	0007b423          	sd	zero,8(a5)
        task[i]->priority = (rand() % (PRIORITY_MAX - PRIORITY_MIN + 1)) + PRIORITY_MIN;
    802004fc:	1d9010ef          	jal	80201ed4 <rand>
    80200500:	00050793          	mv	a5,a0
    80200504:	00078713          	mv	a4,a5
    80200508:	00a00793          	li	a5,10
    8020050c:	02f767bb          	remw	a5,a4,a5
    80200510:	0007879b          	sext.w	a5,a5
    80200514:	0017879b          	addiw	a5,a5,1
    80200518:	0007869b          	sext.w	a3,a5
    8020051c:	00005717          	auipc	a4,0x5
    80200520:	afc70713          	addi	a4,a4,-1284 # 80205018 <task>
    80200524:	fec42783          	lw	a5,-20(s0)
    80200528:	00379793          	slli	a5,a5,0x3
    8020052c:	00f707b3          	add	a5,a4,a5
    80200530:	0007b783          	ld	a5,0(a5)
    80200534:	00068713          	mv	a4,a3
    80200538:	00e7b823          	sd	a4,16(a5)
        task[i]->pid = i;
    8020053c:	00005717          	auipc	a4,0x5
    80200540:	adc70713          	addi	a4,a4,-1316 # 80205018 <task>
    80200544:	fec42783          	lw	a5,-20(s0)
    80200548:	00379793          	slli	a5,a5,0x3
    8020054c:	00f707b3          	add	a5,a4,a5
    80200550:	0007b783          	ld	a5,0(a5)
    80200554:	fec42703          	lw	a4,-20(s0)
    80200558:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
    8020055c:	00005717          	auipc	a4,0x5
    80200560:	abc70713          	addi	a4,a4,-1348 # 80205018 <task>
    80200564:	fec42783          	lw	a5,-20(s0)
    80200568:	00379793          	slli	a5,a5,0x3
    8020056c:	00f707b3          	add	a5,a4,a5
    80200570:	0007b783          	ld	a5,0(a5)
    80200574:	00003717          	auipc	a4,0x3
    80200578:	aa473703          	ld	a4,-1372(a4) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    8020057c:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)task[i] + PGSIZE;
    80200580:	00005717          	auipc	a4,0x5
    80200584:	a9870713          	addi	a4,a4,-1384 # 80205018 <task>
    80200588:	fec42783          	lw	a5,-20(s0)
    8020058c:	00379793          	slli	a5,a5,0x3
    80200590:	00f707b3          	add	a5,a4,a5
    80200594:	0007b783          	ld	a5,0(a5)
    80200598:	00078693          	mv	a3,a5
    8020059c:	00005717          	auipc	a4,0x5
    802005a0:	a7c70713          	addi	a4,a4,-1412 # 80205018 <task>
    802005a4:	fec42783          	lw	a5,-20(s0)
    802005a8:	00379793          	slli	a5,a5,0x3
    802005ac:	00f707b3          	add	a5,a4,a5
    802005b0:	0007b783          	ld	a5,0(a5)
    802005b4:	00001737          	lui	a4,0x1
    802005b8:	00e68733          	add	a4,a3,a4
    802005bc:	02e7b423          	sd	a4,40(a5)
    for (int i = 1; i < NR_TASKS; i++) {
    802005c0:	fec42783          	lw	a5,-20(s0)
    802005c4:	0017879b          	addiw	a5,a5,1
    802005c8:	fef42623          	sw	a5,-20(s0)
    802005cc:	fec42783          	lw	a5,-20(s0)
    802005d0:	0007871b          	sext.w	a4,a5
    802005d4:	01f00793          	li	a5,31
    802005d8:	ece7d6e3          	bge	a5,a4,802004a4 <task_init+0xa8>
    }

    printk("...task_init done!\n");
    802005dc:	00002517          	auipc	a0,0x2
    802005e0:	a3c50513          	addi	a0,a0,-1476 # 80202018 <_srodata+0x18>
    802005e4:	02d010ef          	jal	80201e10 <printk>
}
    802005e8:	00000013          	nop
    802005ec:	01813083          	ld	ra,24(sp)
    802005f0:	01013403          	ld	s0,16(sp)
    802005f4:	02010113          	addi	sp,sp,32
    802005f8:	00008067          	ret

00000000802005fc <switch_to>:

void switch_to(struct task_struct *next) {
    802005fc:	fd010113          	addi	sp,sp,-48
    80200600:	02113423          	sd	ra,40(sp)
    80200604:	02813023          	sd	s0,32(sp)
    80200608:	03010413          	addi	s0,sp,48
    8020060c:	fca43c23          	sd	a0,-40(s0)
    if (next == current) { // 如果切换的目标就是当前线程则直接返回
    80200610:	00005797          	auipc	a5,0x5
    80200614:	a0078793          	addi	a5,a5,-1536 # 80205010 <current>
    80200618:	0007b783          	ld	a5,0(a5)
    8020061c:	fd843703          	ld	a4,-40(s0)
    80200620:	02f70a63          	beq	a4,a5,80200654 <switch_to+0x58>
        return;
    }
    else { // 否则进行线程切换
        struct task_struct *prev = current;
    80200624:	00005797          	auipc	a5,0x5
    80200628:	9ec78793          	addi	a5,a5,-1556 # 80205010 <current>
    8020062c:	0007b783          	ld	a5,0(a5)
    80200630:	fef43423          	sd	a5,-24(s0)
        current = next;
    80200634:	00005797          	auipc	a5,0x5
    80200638:	9dc78793          	addi	a5,a5,-1572 # 80205010 <current>
    8020063c:	fd843703          	ld	a4,-40(s0)
    80200640:	00e7b023          	sd	a4,0(a5)
        __switch_to(prev, next);
    80200644:	fd843583          	ld	a1,-40(s0)
    80200648:	fe843503          	ld	a0,-24(s0)
    8020064c:	b29ff0ef          	jal	80200174 <__switch_to>
    80200650:	0080006f          	j	80200658 <switch_to+0x5c>
        return;
    80200654:	00000013          	nop
    }
}
    80200658:	02813083          	ld	ra,40(sp)
    8020065c:	02013403          	ld	s0,32(sp)
    80200660:	03010113          	addi	sp,sp,48
    80200664:	00008067          	ret

0000000080200668 <do_timer>:

void do_timer() {
    80200668:	ff010113          	addi	sp,sp,-16
    8020066c:	00113423          	sd	ra,8(sp)
    80200670:	00813023          	sd	s0,0(sp)
    80200674:	01010413          	addi	s0,sp,16
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    if (current == idle) {
    80200678:	00005797          	auipc	a5,0x5
    8020067c:	99878793          	addi	a5,a5,-1640 # 80205010 <current>
    80200680:	0007b703          	ld	a4,0(a5)
    80200684:	00005797          	auipc	a5,0x5
    80200688:	98478793          	addi	a5,a5,-1660 # 80205008 <idle>
    8020068c:	0007b783          	ld	a5,0(a5)
    80200690:	00f71663          	bne	a4,a5,8020069c <do_timer+0x34>
        schedule();
    80200694:	06c000ef          	jal	80200700 <schedule>
    80200698:	0580006f          	j	802006f0 <do_timer+0x88>
    }
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
    else {
        current->counter -= 1;
    8020069c:	00005797          	auipc	a5,0x5
    802006a0:	97478793          	addi	a5,a5,-1676 # 80205010 <current>
    802006a4:	0007b783          	ld	a5,0(a5)
    802006a8:	0087b703          	ld	a4,8(a5)
    802006ac:	00005797          	auipc	a5,0x5
    802006b0:	96478793          	addi	a5,a5,-1692 # 80205010 <current>
    802006b4:	0007b783          	ld	a5,0(a5)
    802006b8:	fff70713          	addi	a4,a4,-1 # fff <_skernel-0x801ff001>
    802006bc:	00e7b423          	sd	a4,8(a5)
        if ((long)(current->counter) > 0) { // 使用 (long) 防止下溢
    802006c0:	00005797          	auipc	a5,0x5
    802006c4:	95078793          	addi	a5,a5,-1712 # 80205010 <current>
    802006c8:	0007b783          	ld	a5,0(a5)
    802006cc:	0087b783          	ld	a5,8(a5)
    802006d0:	00f04e63          	bgtz	a5,802006ec <do_timer+0x84>
            return;
        } else {
            current->counter = 0;
    802006d4:	00005797          	auipc	a5,0x5
    802006d8:	93c78793          	addi	a5,a5,-1732 # 80205010 <current>
    802006dc:	0007b783          	ld	a5,0(a5)
    802006e0:	0007b423          	sd	zero,8(a5)
            schedule();
    802006e4:	01c000ef          	jal	80200700 <schedule>
    802006e8:	0080006f          	j	802006f0 <do_timer+0x88>
            return;
    802006ec:	00000013          	nop
        }
    }
}
    802006f0:	00813083          	ld	ra,8(sp)
    802006f4:	00013403          	ld	s0,0(sp)
    802006f8:	01010113          	addi	sp,sp,16
    802006fc:	00008067          	ret

0000000080200700 <schedule>:

void schedule() {
    80200700:	fe010113          	addi	sp,sp,-32
    80200704:	00113c23          	sd	ra,24(sp)
    80200708:	00813823          	sd	s0,16(sp)
    8020070c:	02010413          	addi	s0,sp,32
    int next, max_counter;
    while (1) {
        max_counter = -1;
    80200710:	fff00793          	li	a5,-1
    80200714:	fef42423          	sw	a5,-24(s0)
        next = 0;
    80200718:	fe042623          	sw	zero,-20(s0)

        // 1. 遍历 task 数组，找到 counter 最大的线程作为 next
        for (int i = 1; i < NR_TASKS; i++) {
    8020071c:	00100793          	li	a5,1
    80200720:	fef42223          	sw	a5,-28(s0)
    80200724:	09c0006f          	j	802007c0 <schedule+0xc0>
            if (task[i] && task[i]->state == TASK_RUNNING && (long)(task[i]->counter) >= max_counter){
    80200728:	00005717          	auipc	a4,0x5
    8020072c:	8f070713          	addi	a4,a4,-1808 # 80205018 <task>
    80200730:	fe442783          	lw	a5,-28(s0)
    80200734:	00379793          	slli	a5,a5,0x3
    80200738:	00f707b3          	add	a5,a4,a5
    8020073c:	0007b783          	ld	a5,0(a5)
    80200740:	06078a63          	beqz	a5,802007b4 <schedule+0xb4>
    80200744:	00005717          	auipc	a4,0x5
    80200748:	8d470713          	addi	a4,a4,-1836 # 80205018 <task>
    8020074c:	fe442783          	lw	a5,-28(s0)
    80200750:	00379793          	slli	a5,a5,0x3
    80200754:	00f707b3          	add	a5,a4,a5
    80200758:	0007b783          	ld	a5,0(a5)
    8020075c:	0007b783          	ld	a5,0(a5)
    80200760:	04079a63          	bnez	a5,802007b4 <schedule+0xb4>
    80200764:	00005717          	auipc	a4,0x5
    80200768:	8b470713          	addi	a4,a4,-1868 # 80205018 <task>
    8020076c:	fe442783          	lw	a5,-28(s0)
    80200770:	00379793          	slli	a5,a5,0x3
    80200774:	00f707b3          	add	a5,a4,a5
    80200778:	0007b783          	ld	a5,0(a5)
    8020077c:	0087b783          	ld	a5,8(a5)
    80200780:	00078713          	mv	a4,a5
    80200784:	fe842783          	lw	a5,-24(s0)
    80200788:	02f74663          	blt	a4,a5,802007b4 <schedule+0xb4>
                max_counter = task[i]->counter;
    8020078c:	00005717          	auipc	a4,0x5
    80200790:	88c70713          	addi	a4,a4,-1908 # 80205018 <task>
    80200794:	fe442783          	lw	a5,-28(s0)
    80200798:	00379793          	slli	a5,a5,0x3
    8020079c:	00f707b3          	add	a5,a4,a5
    802007a0:	0007b783          	ld	a5,0(a5)
    802007a4:	0087b783          	ld	a5,8(a5)
    802007a8:	fef42423          	sw	a5,-24(s0)
                next = i;
    802007ac:	fe442783          	lw	a5,-28(s0)
    802007b0:	fef42623          	sw	a5,-20(s0)
        for (int i = 1; i < NR_TASKS; i++) {
    802007b4:	fe442783          	lw	a5,-28(s0)
    802007b8:	0017879b          	addiw	a5,a5,1
    802007bc:	fef42223          	sw	a5,-28(s0)
    802007c0:	fe442783          	lw	a5,-28(s0)
    802007c4:	0007871b          	sext.w	a4,a5
    802007c8:	01f00793          	li	a5,31
    802007cc:	f4e7dee3          	bge	a5,a4,80200728 <schedule+0x28>
            }
        }

        // 2. 若找到的 next 的 counter 大于 0，则跳出循环，进行线程切换
        if (max_counter) {
    802007d0:	fe842783          	lw	a5,-24(s0)
    802007d4:	0007879b          	sext.w	a5,a5
    802007d8:	04078c63          	beqz	a5,80200830 <schedule+0x130>
            printk("switch to [PID = %d PRIORITY = %d COUNTER = %d]\n", next, task[next]->priority, task[next]->counter);
    802007dc:	00005717          	auipc	a4,0x5
    802007e0:	83c70713          	addi	a4,a4,-1988 # 80205018 <task>
    802007e4:	fec42783          	lw	a5,-20(s0)
    802007e8:	00379793          	slli	a5,a5,0x3
    802007ec:	00f707b3          	add	a5,a4,a5
    802007f0:	0007b783          	ld	a5,0(a5)
    802007f4:	0107b603          	ld	a2,16(a5)
    802007f8:	00005717          	auipc	a4,0x5
    802007fc:	82070713          	addi	a4,a4,-2016 # 80205018 <task>
    80200800:	fec42783          	lw	a5,-20(s0)
    80200804:	00379793          	slli	a5,a5,0x3
    80200808:	00f707b3          	add	a5,a4,a5
    8020080c:	0007b783          	ld	a5,0(a5)
    80200810:	0087b703          	ld	a4,8(a5)
    80200814:	fec42783          	lw	a5,-20(s0)
    80200818:	00070693          	mv	a3,a4
    8020081c:	00078593          	mv	a1,a5
    80200820:	00002517          	auipc	a0,0x2
    80200824:	81050513          	addi	a0,a0,-2032 # 80202030 <_srodata+0x30>
    80200828:	5e8010ef          	jal	80201e10 <printk>
            break;
    8020082c:	0d40006f          	j	80200900 <schedule+0x200>
        }

        // 3. 否则，为所有线程重新分配时间片，新的时间片大小为该线程的 priority
        for (int i = 1; i < NR_TASKS; i++) {
    80200830:	00100793          	li	a5,1
    80200834:	fef42023          	sw	a5,-32(s0)
    80200838:	0b40006f          	j	802008ec <schedule+0x1ec>
            if (task[i]){
    8020083c:	00004717          	auipc	a4,0x4
    80200840:	7dc70713          	addi	a4,a4,2012 # 80205018 <task>
    80200844:	fe042783          	lw	a5,-32(s0)
    80200848:	00379793          	slli	a5,a5,0x3
    8020084c:	00f707b3          	add	a5,a4,a5
    80200850:	0007b783          	ld	a5,0(a5)
    80200854:	08078663          	beqz	a5,802008e0 <schedule+0x1e0>
                task[i]->counter = task[i]->priority;
    80200858:	00004717          	auipc	a4,0x4
    8020085c:	7c070713          	addi	a4,a4,1984 # 80205018 <task>
    80200860:	fe042783          	lw	a5,-32(s0)
    80200864:	00379793          	slli	a5,a5,0x3
    80200868:	00f707b3          	add	a5,a4,a5
    8020086c:	0007b703          	ld	a4,0(a5)
    80200870:	00004697          	auipc	a3,0x4
    80200874:	7a868693          	addi	a3,a3,1960 # 80205018 <task>
    80200878:	fe042783          	lw	a5,-32(s0)
    8020087c:	00379793          	slli	a5,a5,0x3
    80200880:	00f687b3          	add	a5,a3,a5
    80200884:	0007b783          	ld	a5,0(a5)
    80200888:	01073703          	ld	a4,16(a4)
    8020088c:	00e7b423          	sd	a4,8(a5)
                printk("SET [PID = %d PRIORITY = %d COUNTER = %d]\n", i, task[i]->priority, task[i]->counter);
    80200890:	00004717          	auipc	a4,0x4
    80200894:	78870713          	addi	a4,a4,1928 # 80205018 <task>
    80200898:	fe042783          	lw	a5,-32(s0)
    8020089c:	00379793          	slli	a5,a5,0x3
    802008a0:	00f707b3          	add	a5,a4,a5
    802008a4:	0007b783          	ld	a5,0(a5)
    802008a8:	0107b603          	ld	a2,16(a5)
    802008ac:	00004717          	auipc	a4,0x4
    802008b0:	76c70713          	addi	a4,a4,1900 # 80205018 <task>
    802008b4:	fe042783          	lw	a5,-32(s0)
    802008b8:	00379793          	slli	a5,a5,0x3
    802008bc:	00f707b3          	add	a5,a4,a5
    802008c0:	0007b783          	ld	a5,0(a5)
    802008c4:	0087b703          	ld	a4,8(a5)
    802008c8:	fe042783          	lw	a5,-32(s0)
    802008cc:	00070693          	mv	a3,a4
    802008d0:	00078593          	mv	a1,a5
    802008d4:	00001517          	auipc	a0,0x1
    802008d8:	79450513          	addi	a0,a0,1940 # 80202068 <_srodata+0x68>
    802008dc:	534010ef          	jal	80201e10 <printk>
        for (int i = 1; i < NR_TASKS; i++) {
    802008e0:	fe042783          	lw	a5,-32(s0)
    802008e4:	0017879b          	addiw	a5,a5,1
    802008e8:	fef42023          	sw	a5,-32(s0)
    802008ec:	fe042783          	lw	a5,-32(s0)
    802008f0:	0007871b          	sext.w	a4,a5
    802008f4:	01f00793          	li	a5,31
    802008f8:	f4e7d2e3          	bge	a5,a4,8020083c <schedule+0x13c>
        max_counter = -1;
    802008fc:	e15ff06f          	j	80200710 <schedule+0x10>
            }
        }
    }
    switch_to(task[next]);
    80200900:	00004717          	auipc	a4,0x4
    80200904:	71870713          	addi	a4,a4,1816 # 80205018 <task>
    80200908:	fec42783          	lw	a5,-20(s0)
    8020090c:	00379793          	slli	a5,a5,0x3
    80200910:	00f707b3          	add	a5,a4,a5
    80200914:	0007b783          	ld	a5,0(a5)
    80200918:	00078513          	mv	a0,a5
    8020091c:	ce1ff0ef          	jal	802005fc <switch_to>
} 
    80200920:	00000013          	nop
    80200924:	01813083          	ld	ra,24(sp)
    80200928:	01013403          	ld	s0,16(sp)
    8020092c:	02010113          	addi	sp,sp,32
    80200930:	00008067          	ret

0000000080200934 <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    80200934:	fd010113          	addi	sp,sp,-48
    80200938:	02113423          	sd	ra,40(sp)
    8020093c:	02813023          	sd	s0,32(sp)
    80200940:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
    80200944:	3b9ad7b7          	lui	a5,0x3b9ad
    80200948:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <_skernel-0x448535f9>
    8020094c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
    80200950:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
    80200954:	fff00793          	li	a5,-1
    80200958:	fef42223          	sw	a5,-28(s0)
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    8020095c:	fe442783          	lw	a5,-28(s0)
    80200960:	0007871b          	sext.w	a4,a5
    80200964:	fff00793          	li	a5,-1
    80200968:	00f70e63          	beq	a4,a5,80200984 <dummy+0x50>
    8020096c:	00004797          	auipc	a5,0x4
    80200970:	6a478793          	addi	a5,a5,1700 # 80205010 <current>
    80200974:	0007b783          	ld	a5,0(a5)
    80200978:	0087b703          	ld	a4,8(a5)
    8020097c:	fe442783          	lw	a5,-28(s0)
    80200980:	fcf70ee3          	beq	a4,a5,8020095c <dummy+0x28>
    80200984:	00004797          	auipc	a5,0x4
    80200988:	68c78793          	addi	a5,a5,1676 # 80205010 <current>
    8020098c:	0007b783          	ld	a5,0(a5)
    80200990:	0087b783          	ld	a5,8(a5)
    80200994:	fc0784e3          	beqz	a5,8020095c <dummy+0x28>
            if (current->counter == 1) {
    80200998:	00004797          	auipc	a5,0x4
    8020099c:	67878793          	addi	a5,a5,1656 # 80205010 <current>
    802009a0:	0007b783          	ld	a5,0(a5)
    802009a4:	0087b703          	ld	a4,8(a5)
    802009a8:	00100793          	li	a5,1
    802009ac:	00f71e63          	bne	a4,a5,802009c8 <dummy+0x94>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
    802009b0:	00004797          	auipc	a5,0x4
    802009b4:	66078793          	addi	a5,a5,1632 # 80205010 <current>
    802009b8:	0007b783          	ld	a5,0(a5)
    802009bc:	0087b703          	ld	a4,8(a5)
    802009c0:	fff70713          	addi	a4,a4,-1
    802009c4:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
    802009c8:	00004797          	auipc	a5,0x4
    802009cc:	64878793          	addi	a5,a5,1608 # 80205010 <current>
    802009d0:	0007b783          	ld	a5,0(a5)
    802009d4:	0087b783          	ld	a5,8(a5)
    802009d8:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
    802009dc:	fe843783          	ld	a5,-24(s0)
    802009e0:	00178713          	addi	a4,a5,1
    802009e4:	fd843783          	ld	a5,-40(s0)
    802009e8:	02f777b3          	remu	a5,a4,a5
    802009ec:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
    802009f0:	00004797          	auipc	a5,0x4
    802009f4:	62078793          	addi	a5,a5,1568 # 80205010 <current>
    802009f8:	0007b783          	ld	a5,0(a5)
    802009fc:	0187b783          	ld	a5,24(a5)
    80200a00:	fe843603          	ld	a2,-24(s0)
    80200a04:	00078593          	mv	a1,a5
    80200a08:	00001517          	auipc	a0,0x1
    80200a0c:	69050513          	addi	a0,a0,1680 # 80202098 <_srodata+0x98>
    80200a10:	400010ef          	jal	80201e10 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    80200a14:	f49ff06f          	j	8020095c <dummy+0x28>

0000000080200a18 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    80200a18:	f9010113          	addi	sp,sp,-112
    80200a1c:	06813423          	sd	s0,104(sp)
    80200a20:	07010413          	addi	s0,sp,112
    80200a24:	fca43423          	sd	a0,-56(s0)
    80200a28:	fcb43023          	sd	a1,-64(s0)
    80200a2c:	fac43c23          	sd	a2,-72(s0)
    80200a30:	fad43823          	sd	a3,-80(s0)
    80200a34:	fae43423          	sd	a4,-88(s0)
    80200a38:	faf43023          	sd	a5,-96(s0)
    80200a3c:	f9043c23          	sd	a6,-104(s0)
    80200a40:	f9143823          	sd	a7,-112(s0)
    struct sbiret ret;

    // Put arguments into registers
    register uint64_t a0 asm("a0") = arg0;
    80200a44:	fb843503          	ld	a0,-72(s0)
    register uint64_t a1 asm("a1") = arg1;
    80200a48:	fb043583          	ld	a1,-80(s0)
    register uint64_t a2 asm("a2") = arg2;
    80200a4c:	fa843603          	ld	a2,-88(s0)
    register uint64_t a3 asm("a3") = arg3;
    80200a50:	fa043683          	ld	a3,-96(s0)
    register uint64_t a4 asm("a4") = arg4;
    80200a54:	f9843703          	ld	a4,-104(s0)
    register uint64_t a5 asm("a5") = arg5;
    80200a58:	f9043783          	ld	a5,-112(s0)
    register uint64_t a6 asm("a6") = fid; // Function ID
    80200a5c:	fc043803          	ld	a6,-64(s0)
    register uint64_t a7 asm("a7") = eid; // Extension ID
    80200a60:	fc843883          	ld	a7,-56(s0)

    // Make the ecall
    asm volatile("ecall"
    80200a64:	00000073          	ecall
                    : "=r"(a0), "=r"(a1) // Store return values
                    : "r"(a0), "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5), "r"(a6), "r"(a7) // Input values
                    : "memory" // Memory may be affected
                );

    ret.error = a0; // Error code
    80200a68:	00050793          	mv	a5,a0
    80200a6c:	fcf43823          	sd	a5,-48(s0)
    ret.value = a1; // Return value
    80200a70:	00058793          	mv	a5,a1
    80200a74:	fcf43c23          	sd	a5,-40(s0)

    return ret;
    80200a78:	fd043783          	ld	a5,-48(s0)
    80200a7c:	fef43023          	sd	a5,-32(s0)
    80200a80:	fd843783          	ld	a5,-40(s0)
    80200a84:	fef43423          	sd	a5,-24(s0)
    80200a88:	fe043703          	ld	a4,-32(s0)
    80200a8c:	fe843783          	ld	a5,-24(s0)
    80200a90:	00070313          	mv	t1,a4
    80200a94:	00078393          	mv	t2,a5
    80200a98:	00030713          	mv	a4,t1
    80200a9c:	00038793          	mv	a5,t2
}
    80200aa0:	00070513          	mv	a0,a4
    80200aa4:	00078593          	mv	a1,a5
    80200aa8:	06813403          	ld	s0,104(sp)
    80200aac:	07010113          	addi	sp,sp,112
    80200ab0:	00008067          	ret

0000000080200ab4 <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value) {
    80200ab4:	fa010113          	addi	sp,sp,-96
    80200ab8:	04113c23          	sd	ra,88(sp)
    80200abc:	04813823          	sd	s0,80(sp)
    80200ac0:	05213423          	sd	s2,72(sp)
    80200ac4:	05313023          	sd	s3,64(sp)
    80200ac8:	06010413          	addi	s0,sp,96
    80200acc:	faa43423          	sd	a0,-88(s0)
    uint64_t eid = 0x00; // SET_TIMER extenstion (Legacy Extensions)
    80200ad0:	fc043c23          	sd	zero,-40(s0)
    uint64_t fid = 0; // SET_TIMER function
    80200ad4:	fc043823          	sd	zero,-48(s0)
    
    // Call the sbi_ecall function
    struct sbiret ret = sbi_ecall(eid, fid, stime_value, 0, 0, 0, 0, 0);
    80200ad8:	00000893          	li	a7,0
    80200adc:	00000813          	li	a6,0
    80200ae0:	00000793          	li	a5,0
    80200ae4:	00000713          	li	a4,0
    80200ae8:	00000693          	li	a3,0
    80200aec:	fa843603          	ld	a2,-88(s0)
    80200af0:	fd043583          	ld	a1,-48(s0)
    80200af4:	fd843503          	ld	a0,-40(s0)
    80200af8:	f21ff0ef          	jal	80200a18 <sbi_ecall>
    80200afc:	00050713          	mv	a4,a0
    80200b00:	00058793          	mv	a5,a1
    80200b04:	fae43823          	sd	a4,-80(s0)
    80200b08:	faf43c23          	sd	a5,-72(s0)
    
    return ret;
    80200b0c:	fb043783          	ld	a5,-80(s0)
    80200b10:	fcf43023          	sd	a5,-64(s0)
    80200b14:	fb843783          	ld	a5,-72(s0)
    80200b18:	fcf43423          	sd	a5,-56(s0)
    80200b1c:	fc043703          	ld	a4,-64(s0)
    80200b20:	fc843783          	ld	a5,-56(s0)
    80200b24:	00070913          	mv	s2,a4
    80200b28:	00078993          	mv	s3,a5
    80200b2c:	00090713          	mv	a4,s2
    80200b30:	00098793          	mv	a5,s3
}
    80200b34:	00070513          	mv	a0,a4
    80200b38:	00078593          	mv	a1,a5
    80200b3c:	05813083          	ld	ra,88(sp)
    80200b40:	05013403          	ld	s0,80(sp)
    80200b44:	04813903          	ld	s2,72(sp)
    80200b48:	04013983          	ld	s3,64(sp)
    80200b4c:	06010113          	addi	sp,sp,96
    80200b50:	00008067          	ret

0000000080200b54 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    80200b54:	fa010113          	addi	sp,sp,-96
    80200b58:	04113c23          	sd	ra,88(sp)
    80200b5c:	04813823          	sd	s0,80(sp)
    80200b60:	05213423          	sd	s2,72(sp)
    80200b64:	05313023          	sd	s3,64(sp)
    80200b68:	06010413          	addi	s0,sp,96
    80200b6c:	00050793          	mv	a5,a0
    80200b70:	faf407a3          	sb	a5,-81(s0)
    uint64_t eid = 0x4442434E; // DBCN in ASCII
    80200b74:	444247b7          	lui	a5,0x44424
    80200b78:	34e78793          	addi	a5,a5,846 # 4442434e <_skernel-0x3bddbcb2>
    80200b7c:	fcf43c23          	sd	a5,-40(s0)
    uint64_t fid = 0x2; // CONSOLE_WRITE_BYTE function
    80200b80:	00200793          	li	a5,2
    80200b84:	fcf43823          	sd	a5,-48(s0)
    
    // Call the sbi_ecall function
    struct sbiret ret = sbi_ecall(eid, fid, (uint64_t)byte, 0, 0, 0, 0, 0);
    80200b88:	faf44603          	lbu	a2,-81(s0)
    80200b8c:	00000893          	li	a7,0
    80200b90:	00000813          	li	a6,0
    80200b94:	00000793          	li	a5,0
    80200b98:	00000713          	li	a4,0
    80200b9c:	00000693          	li	a3,0
    80200ba0:	fd043583          	ld	a1,-48(s0)
    80200ba4:	fd843503          	ld	a0,-40(s0)
    80200ba8:	e71ff0ef          	jal	80200a18 <sbi_ecall>
    80200bac:	00050713          	mv	a4,a0
    80200bb0:	00058793          	mv	a5,a1
    80200bb4:	fae43823          	sd	a4,-80(s0)
    80200bb8:	faf43c23          	sd	a5,-72(s0)
    
    return ret;
    80200bbc:	fb043783          	ld	a5,-80(s0)
    80200bc0:	fcf43023          	sd	a5,-64(s0)
    80200bc4:	fb843783          	ld	a5,-72(s0)
    80200bc8:	fcf43423          	sd	a5,-56(s0)
    80200bcc:	fc043703          	ld	a4,-64(s0)
    80200bd0:	fc843783          	ld	a5,-56(s0)
    80200bd4:	00070913          	mv	s2,a4
    80200bd8:	00078993          	mv	s3,a5
    80200bdc:	00090713          	mv	a4,s2
    80200be0:	00098793          	mv	a5,s3
}
    80200be4:	00070513          	mv	a0,a4
    80200be8:	00078593          	mv	a1,a5
    80200bec:	05813083          	ld	ra,88(sp)
    80200bf0:	05013403          	ld	s0,80(sp)
    80200bf4:	04813903          	ld	s2,72(sp)
    80200bf8:	04013983          	ld	s3,64(sp)
    80200bfc:	06010113          	addi	sp,sp,96
    80200c00:	00008067          	ret

0000000080200c04 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    80200c04:	fa010113          	addi	sp,sp,-96
    80200c08:	04113c23          	sd	ra,88(sp)
    80200c0c:	04813823          	sd	s0,80(sp)
    80200c10:	05213423          	sd	s2,72(sp)
    80200c14:	05313023          	sd	s3,64(sp)
    80200c18:	06010413          	addi	s0,sp,96
    80200c1c:	00050793          	mv	a5,a0
    80200c20:	00058713          	mv	a4,a1
    80200c24:	faf42623          	sw	a5,-84(s0)
    80200c28:	00070793          	mv	a5,a4
    80200c2c:	faf42423          	sw	a5,-88(s0)
    uint64_t eid = 0x53525354; // SRST in ASCII
    80200c30:	535257b7          	lui	a5,0x53525
    80200c34:	35478793          	addi	a5,a5,852 # 53525354 <_skernel-0x2ccdacac>
    80200c38:	fcf43c23          	sd	a5,-40(s0)
    uint64_t fid = 0; // SYSTEM_RESET function
    80200c3c:	fc043823          	sd	zero,-48(s0)
    
    // Call the sbi_ecall function
    struct sbiret ret = sbi_ecall(eid, fid, (uint64_t)reset_type, (uint64_t)reset_reason, 0, 0, 0, 0);
    80200c40:	fac46603          	lwu	a2,-84(s0)
    80200c44:	fa846683          	lwu	a3,-88(s0)
    80200c48:	00000893          	li	a7,0
    80200c4c:	00000813          	li	a6,0
    80200c50:	00000793          	li	a5,0
    80200c54:	00000713          	li	a4,0
    80200c58:	fd043583          	ld	a1,-48(s0)
    80200c5c:	fd843503          	ld	a0,-40(s0)
    80200c60:	db9ff0ef          	jal	80200a18 <sbi_ecall>
    80200c64:	00050713          	mv	a4,a0
    80200c68:	00058793          	mv	a5,a1
    80200c6c:	fae43823          	sd	a4,-80(s0)
    80200c70:	faf43c23          	sd	a5,-72(s0)
    
    return ret;
    80200c74:	fb043783          	ld	a5,-80(s0)
    80200c78:	fcf43023          	sd	a5,-64(s0)
    80200c7c:	fb843783          	ld	a5,-72(s0)
    80200c80:	fcf43423          	sd	a5,-56(s0)
    80200c84:	fc043703          	ld	a4,-64(s0)
    80200c88:	fc843783          	ld	a5,-56(s0)
    80200c8c:	00070913          	mv	s2,a4
    80200c90:	00078993          	mv	s3,a5
    80200c94:	00090713          	mv	a4,s2
    80200c98:	00098793          	mv	a5,s3
    80200c9c:	00070513          	mv	a0,a4
    80200ca0:	00078593          	mv	a1,a5
    80200ca4:	05813083          	ld	ra,88(sp)
    80200ca8:	05013403          	ld	s0,80(sp)
    80200cac:	04813903          	ld	s2,72(sp)
    80200cb0:	04013983          	ld	s3,64(sp)
    80200cb4:	06010113          	addi	sp,sp,96
    80200cb8:	00008067          	ret

0000000080200cbc <trap_handler>:
#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "proc.h"

void trap_handler(uint64_t scause, uint64_t sepc) {
    80200cbc:	fd010113          	addi	sp,sp,-48
    80200cc0:	02113423          	sd	ra,40(sp)
    80200cc4:	02813023          	sd	s0,32(sp)
    80200cc8:	03010413          	addi	s0,sp,48
    80200ccc:	fca43c23          	sd	a0,-40(s0)
    80200cd0:	fcb43823          	sd	a1,-48(s0)
    unsigned long interrupt_flag = scause >> 63;
    80200cd4:	fd843783          	ld	a5,-40(s0)
    80200cd8:	03f7d793          	srli	a5,a5,0x3f
    80200cdc:	fef43423          	sd	a5,-24(s0)
    unsigned long cause_code = scause & 0x7FFFFFFFFFFFFFFF;
    80200ce0:	fd843703          	ld	a4,-40(s0)
    80200ce4:	fff00793          	li	a5,-1
    80200ce8:	0017d793          	srli	a5,a5,0x1
    80200cec:	00f777b3          	and	a5,a4,a5
    80200cf0:	fef43023          	sd	a5,-32(s0)

    // Interrupt
    if (interrupt_flag) {
    80200cf4:	fe843783          	ld	a5,-24(s0)
    80200cf8:	0a078063          	beqz	a5,80200d98 <trap_handler+0xdc>
        switch (cause_code) {
    80200cfc:	fe043703          	ld	a4,-32(s0)
    80200d00:	00d00793          	li	a5,13
    80200d04:	06f70863          	beq	a4,a5,80200d74 <trap_handler+0xb8>
    80200d08:	fe043703          	ld	a4,-32(s0)
    80200d0c:	00d00793          	li	a5,13
    80200d10:	06e7ea63          	bltu	a5,a4,80200d84 <trap_handler+0xc8>
    80200d14:	fe043703          	ld	a4,-32(s0)
    80200d18:	00900793          	li	a5,9
    80200d1c:	04f70463          	beq	a4,a5,80200d64 <trap_handler+0xa8>
    80200d20:	fe043703          	ld	a4,-32(s0)
    80200d24:	00900793          	li	a5,9
    80200d28:	04e7ee63          	bltu	a5,a4,80200d84 <trap_handler+0xc8>
    80200d2c:	fe043703          	ld	a4,-32(s0)
    80200d30:	00100793          	li	a5,1
    80200d34:	00f70a63          	beq	a4,a5,80200d48 <trap_handler+0x8c>
    80200d38:	fe043703          	ld	a4,-32(s0)
    80200d3c:	00500793          	li	a5,5
    80200d40:	00f70c63          	beq	a4,a5,80200d58 <trap_handler+0x9c>
    80200d44:	0400006f          	j	80200d84 <trap_handler+0xc8>
            case 1:
                printk("[S] Supervisor Software Interrupt\n");
    80200d48:	00001517          	auipc	a0,0x1
    80200d4c:	38050513          	addi	a0,a0,896 # 802020c8 <_srodata+0xc8>
    80200d50:	0c0010ef          	jal	80201e10 <printk>
                break;
    80200d54:	1800006f          	j	80200ed4 <trap_handler+0x218>
            case 5:
                //printk("[S] Supervisor Mode Timer Interrupt\n");
                clock_set_next_event();
    80200d58:	cc0ff0ef          	jal	80200218 <clock_set_next_event>
                do_timer();
    80200d5c:	90dff0ef          	jal	80200668 <do_timer>
                break;
    80200d60:	1740006f          	j	80200ed4 <trap_handler+0x218>
            case 9:
                printk("[S] Supervisor External Interrupt\n");
    80200d64:	00001517          	auipc	a0,0x1
    80200d68:	38c50513          	addi	a0,a0,908 # 802020f0 <_srodata+0xf0>
    80200d6c:	0a4010ef          	jal	80201e10 <printk>
                break;
    80200d70:	1640006f          	j	80200ed4 <trap_handler+0x218>
            case 13:
                printk("Counter-overflow Interrupt\n");
    80200d74:	00001517          	auipc	a0,0x1
    80200d78:	3a450513          	addi	a0,a0,932 # 80202118 <_srodata+0x118>
    80200d7c:	094010ef          	jal	80201e10 <printk>
                break;
    80200d80:	1540006f          	j	80200ed4 <trap_handler+0x218>
            default:
                printk("Unknown Interrupt: %d\n", cause_code);
    80200d84:	fe043583          	ld	a1,-32(s0)
    80200d88:	00001517          	auipc	a0,0x1
    80200d8c:	3b050513          	addi	a0,a0,944 # 80202138 <_srodata+0x138>
    80200d90:	080010ef          	jal	80201e10 <printk>
                break;
    80200d94:	1400006f          	j	80200ed4 <trap_handler+0x218>
        }
    }

    // Exception
    else {
        switch (cause_code) {
    80200d98:	fe043703          	ld	a4,-32(s0)
    80200d9c:	01300793          	li	a5,19
    80200da0:	12e7e063          	bltu	a5,a4,80200ec0 <trap_handler+0x204>
    80200da4:	fe043783          	ld	a5,-32(s0)
    80200da8:	00279713          	slli	a4,a5,0x2
    80200dac:	00001797          	auipc	a5,0x1
    80200db0:	53c78793          	addi	a5,a5,1340 # 802022e8 <_srodata+0x2e8>
    80200db4:	00f707b3          	add	a5,a4,a5
    80200db8:	0007a783          	lw	a5,0(a5)
    80200dbc:	0007871b          	sext.w	a4,a5
    80200dc0:	00001797          	auipc	a5,0x1
    80200dc4:	52878793          	addi	a5,a5,1320 # 802022e8 <_srodata+0x2e8>
    80200dc8:	00f707b3          	add	a5,a4,a5
    80200dcc:	00078067          	jr	a5
            case 0:
                printk("Instruction Address Misaligned\n");
    80200dd0:	00001517          	auipc	a0,0x1
    80200dd4:	38050513          	addi	a0,a0,896 # 80202150 <_srodata+0x150>
    80200dd8:	038010ef          	jal	80201e10 <printk>
                break;
    80200ddc:	0f80006f          	j	80200ed4 <trap_handler+0x218>
            case 1:
                printk("Instruction Access Fault\n");
    80200de0:	00001517          	auipc	a0,0x1
    80200de4:	39050513          	addi	a0,a0,912 # 80202170 <_srodata+0x170>
    80200de8:	028010ef          	jal	80201e10 <printk>
                break;
    80200dec:	0e80006f          	j	80200ed4 <trap_handler+0x218>
            case 2:
                printk("Illegal Instruction\n");
    80200df0:	00001517          	auipc	a0,0x1
    80200df4:	3a050513          	addi	a0,a0,928 # 80202190 <_srodata+0x190>
    80200df8:	018010ef          	jal	80201e10 <printk>
                break;
    80200dfc:	0d80006f          	j	80200ed4 <trap_handler+0x218>
            case 3:
                printk("Breakpoint\n");
    80200e00:	00001517          	auipc	a0,0x1
    80200e04:	3a850513          	addi	a0,a0,936 # 802021a8 <_srodata+0x1a8>
    80200e08:	008010ef          	jal	80201e10 <printk>
                break;
    80200e0c:	0c80006f          	j	80200ed4 <trap_handler+0x218>
            case 4:
                printk("Load Address Misaligned\n");
    80200e10:	00001517          	auipc	a0,0x1
    80200e14:	3a850513          	addi	a0,a0,936 # 802021b8 <_srodata+0x1b8>
    80200e18:	7f9000ef          	jal	80201e10 <printk>
                break;
    80200e1c:	0b80006f          	j	80200ed4 <trap_handler+0x218>
            case 5:
                printk("Load Access Fault\n");
    80200e20:	00001517          	auipc	a0,0x1
    80200e24:	3b850513          	addi	a0,a0,952 # 802021d8 <_srodata+0x1d8>
    80200e28:	7e9000ef          	jal	80201e10 <printk>
                break;
    80200e2c:	0a80006f          	j	80200ed4 <trap_handler+0x218>
            case 6:
                printk("Store/AMO Address Misaligned\n");
    80200e30:	00001517          	auipc	a0,0x1
    80200e34:	3c050513          	addi	a0,a0,960 # 802021f0 <_srodata+0x1f0>
    80200e38:	7d9000ef          	jal	80201e10 <printk>
                break;
    80200e3c:	0980006f          	j	80200ed4 <trap_handler+0x218>
            case 7:
                printk("Store/AMO Access Fault\n");
    80200e40:	00001517          	auipc	a0,0x1
    80200e44:	3d050513          	addi	a0,a0,976 # 80202210 <_srodata+0x210>
    80200e48:	7c9000ef          	jal	80201e10 <printk>
                break;
    80200e4c:	0880006f          	j	80200ed4 <trap_handler+0x218>
            case 8:
                printk("Environment Call from U-mode\n");
    80200e50:	00001517          	auipc	a0,0x1
    80200e54:	3d850513          	addi	a0,a0,984 # 80202228 <_srodata+0x228>
    80200e58:	7b9000ef          	jal	80201e10 <printk>
                break;
    80200e5c:	0780006f          	j	80200ed4 <trap_handler+0x218>
            case 9:
                printk("Environment Call from S-mode\n");
    80200e60:	00001517          	auipc	a0,0x1
    80200e64:	3e850513          	addi	a0,a0,1000 # 80202248 <_srodata+0x248>
    80200e68:	7a9000ef          	jal	80201e10 <printk>
                break;
    80200e6c:	0680006f          	j	80200ed4 <trap_handler+0x218>
            case 12:
                printk("Instruction Page Fault\n");
    80200e70:	00001517          	auipc	a0,0x1
    80200e74:	3f850513          	addi	a0,a0,1016 # 80202268 <_srodata+0x268>
    80200e78:	799000ef          	jal	80201e10 <printk>
                break;
    80200e7c:	0580006f          	j	80200ed4 <trap_handler+0x218>
            case 13:
                printk("Load Page Fault\n");
    80200e80:	00001517          	auipc	a0,0x1
    80200e84:	40050513          	addi	a0,a0,1024 # 80202280 <_srodata+0x280>
    80200e88:	789000ef          	jal	80201e10 <printk>
                break;
    80200e8c:	0480006f          	j	80200ed4 <trap_handler+0x218>
            case 15:
                printk("Store/AMO Page Fault\n");
    80200e90:	00001517          	auipc	a0,0x1
    80200e94:	40850513          	addi	a0,a0,1032 # 80202298 <_srodata+0x298>
    80200e98:	779000ef          	jal	80201e10 <printk>
                break;
    80200e9c:	0380006f          	j	80200ed4 <trap_handler+0x218>
            case 18:
                printk("Software Check\n");
    80200ea0:	00001517          	auipc	a0,0x1
    80200ea4:	41050513          	addi	a0,a0,1040 # 802022b0 <_srodata+0x2b0>
    80200ea8:	769000ef          	jal	80201e10 <printk>
                break;
    80200eac:	0280006f          	j	80200ed4 <trap_handler+0x218>
            case 19:
                printk("Hardware Error\n");
    80200eb0:	00001517          	auipc	a0,0x1
    80200eb4:	41050513          	addi	a0,a0,1040 # 802022c0 <_srodata+0x2c0>
    80200eb8:	759000ef          	jal	80201e10 <printk>
                break;
    80200ebc:	0180006f          	j	80200ed4 <trap_handler+0x218>
            default:
                printk("Unknown Exception: %d\n", cause_code);
    80200ec0:	fe043583          	ld	a1,-32(s0)
    80200ec4:	00001517          	auipc	a0,0x1
    80200ec8:	40c50513          	addi	a0,a0,1036 # 802022d0 <_srodata+0x2d0>
    80200ecc:	745000ef          	jal	80201e10 <printk>
                break;
    80200ed0:	00000013          	nop
        }
    }
    80200ed4:	00000013          	nop
    80200ed8:	02813083          	ld	ra,40(sp)
    80200edc:	02013403          	ld	s0,32(sp)
    80200ee0:	03010113          	addi	sp,sp,48
    80200ee4:	00008067          	ret

0000000080200ee8 <start_kernel>:
#include "printk.h"
#include "defs.h"

extern void test();

int start_kernel() {
    80200ee8:	ff010113          	addi	sp,sp,-16
    80200eec:	00113423          	sd	ra,8(sp)
    80200ef0:	00813023          	sd	s0,0(sp)
    80200ef4:	01010413          	addi	s0,sp,16
    printk("2024");
    80200ef8:	00001517          	auipc	a0,0x1
    80200efc:	44050513          	addi	a0,a0,1088 # 80202338 <_srodata+0x338>
    80200f00:	711000ef          	jal	80201e10 <printk>
    printk(" ZJU Operating System\n");
    80200f04:	00001517          	auipc	a0,0x1
    80200f08:	43c50513          	addi	a0,a0,1084 # 80202340 <_srodata+0x340>
    80200f0c:	705000ef          	jal	80201e10 <printk>

    test();
    80200f10:	01c000ef          	jal	80200f2c <test>
    return 0;
    80200f14:	00000793          	li	a5,0
}
    80200f18:	00078513          	mv	a0,a5
    80200f1c:	00813083          	ld	ra,8(sp)
    80200f20:	00013403          	ld	s0,0(sp)
    80200f24:	01010113          	addi	sp,sp,16
    80200f28:	00008067          	ret

0000000080200f2c <test>:
#include "printk.h"

void test() {
    80200f2c:	fe010113          	addi	sp,sp,-32
    80200f30:	00113c23          	sd	ra,24(sp)
    80200f34:	00813823          	sd	s0,16(sp)
    80200f38:	02010413          	addi	s0,sp,32
    int i = 0;
    80200f3c:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
    80200f40:	fec42783          	lw	a5,-20(s0)
    80200f44:	0017879b          	addiw	a5,a5,1
    80200f48:	fef42623          	sw	a5,-20(s0)
    80200f4c:	fec42783          	lw	a5,-20(s0)
    80200f50:	00078713          	mv	a4,a5
    80200f54:	05f5e7b7          	lui	a5,0x5f5e
    80200f58:	1007879b          	addiw	a5,a5,256 # 5f5e100 <_skernel-0x7a2a1f00>
    80200f5c:	02f767bb          	remw	a5,a4,a5
    80200f60:	0007879b          	sext.w	a5,a5
    80200f64:	fc079ee3          	bnez	a5,80200f40 <test+0x14>
            printk("kernel is running!\n");
    80200f68:	00001517          	auipc	a0,0x1
    80200f6c:	3f050513          	addi	a0,a0,1008 # 80202358 <_srodata+0x358>
    80200f70:	6a1000ef          	jal	80201e10 <printk>
            i = 0;
    80200f74:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
    80200f78:	fc9ff06f          	j	80200f40 <test+0x14>

0000000080200f7c <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
    80200f7c:	fe010113          	addi	sp,sp,-32
    80200f80:	00113c23          	sd	ra,24(sp)
    80200f84:	00813823          	sd	s0,16(sp)
    80200f88:	02010413          	addi	s0,sp,32
    80200f8c:	00050793          	mv	a5,a0
    80200f90:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
    80200f94:	fec42783          	lw	a5,-20(s0)
    80200f98:	0ff7f793          	zext.b	a5,a5
    80200f9c:	00078513          	mv	a0,a5
    80200fa0:	bb5ff0ef          	jal	80200b54 <sbi_debug_console_write_byte>
    return (char)c;
    80200fa4:	fec42783          	lw	a5,-20(s0)
    80200fa8:	0ff7f793          	zext.b	a5,a5
    80200fac:	0007879b          	sext.w	a5,a5
}
    80200fb0:	00078513          	mv	a0,a5
    80200fb4:	01813083          	ld	ra,24(sp)
    80200fb8:	01013403          	ld	s0,16(sp)
    80200fbc:	02010113          	addi	sp,sp,32
    80200fc0:	00008067          	ret

0000000080200fc4 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
    80200fc4:	fe010113          	addi	sp,sp,-32
    80200fc8:	00813c23          	sd	s0,24(sp)
    80200fcc:	02010413          	addi	s0,sp,32
    80200fd0:	00050793          	mv	a5,a0
    80200fd4:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
    80200fd8:	fec42783          	lw	a5,-20(s0)
    80200fdc:	0007871b          	sext.w	a4,a5
    80200fe0:	02000793          	li	a5,32
    80200fe4:	02f70263          	beq	a4,a5,80201008 <isspace+0x44>
    80200fe8:	fec42783          	lw	a5,-20(s0)
    80200fec:	0007871b          	sext.w	a4,a5
    80200ff0:	00800793          	li	a5,8
    80200ff4:	00e7de63          	bge	a5,a4,80201010 <isspace+0x4c>
    80200ff8:	fec42783          	lw	a5,-20(s0)
    80200ffc:	0007871b          	sext.w	a4,a5
    80201000:	00d00793          	li	a5,13
    80201004:	00e7c663          	blt	a5,a4,80201010 <isspace+0x4c>
    80201008:	00100793          	li	a5,1
    8020100c:	0080006f          	j	80201014 <isspace+0x50>
    80201010:	00000793          	li	a5,0
}
    80201014:	00078513          	mv	a0,a5
    80201018:	01813403          	ld	s0,24(sp)
    8020101c:	02010113          	addi	sp,sp,32
    80201020:	00008067          	ret

0000000080201024 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
    80201024:	fb010113          	addi	sp,sp,-80
    80201028:	04113423          	sd	ra,72(sp)
    8020102c:	04813023          	sd	s0,64(sp)
    80201030:	05010413          	addi	s0,sp,80
    80201034:	fca43423          	sd	a0,-56(s0)
    80201038:	fcb43023          	sd	a1,-64(s0)
    8020103c:	00060793          	mv	a5,a2
    80201040:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
    80201044:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
    80201048:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
    8020104c:	fc843783          	ld	a5,-56(s0)
    80201050:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
    80201054:	0100006f          	j	80201064 <strtol+0x40>
        p++;
    80201058:	fd843783          	ld	a5,-40(s0)
    8020105c:	00178793          	addi	a5,a5,1
    80201060:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
    80201064:	fd843783          	ld	a5,-40(s0)
    80201068:	0007c783          	lbu	a5,0(a5)
    8020106c:	0007879b          	sext.w	a5,a5
    80201070:	00078513          	mv	a0,a5
    80201074:	f51ff0ef          	jal	80200fc4 <isspace>
    80201078:	00050793          	mv	a5,a0
    8020107c:	fc079ee3          	bnez	a5,80201058 <strtol+0x34>
    }

    if (*p == '-') {
    80201080:	fd843783          	ld	a5,-40(s0)
    80201084:	0007c783          	lbu	a5,0(a5)
    80201088:	00078713          	mv	a4,a5
    8020108c:	02d00793          	li	a5,45
    80201090:	00f71e63          	bne	a4,a5,802010ac <strtol+0x88>
        neg = true;
    80201094:	00100793          	li	a5,1
    80201098:	fef403a3          	sb	a5,-25(s0)
        p++;
    8020109c:	fd843783          	ld	a5,-40(s0)
    802010a0:	00178793          	addi	a5,a5,1
    802010a4:	fcf43c23          	sd	a5,-40(s0)
    802010a8:	0240006f          	j	802010cc <strtol+0xa8>
    } else if (*p == '+') {
    802010ac:	fd843783          	ld	a5,-40(s0)
    802010b0:	0007c783          	lbu	a5,0(a5)
    802010b4:	00078713          	mv	a4,a5
    802010b8:	02b00793          	li	a5,43
    802010bc:	00f71863          	bne	a4,a5,802010cc <strtol+0xa8>
        p++;
    802010c0:	fd843783          	ld	a5,-40(s0)
    802010c4:	00178793          	addi	a5,a5,1
    802010c8:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
    802010cc:	fbc42783          	lw	a5,-68(s0)
    802010d0:	0007879b          	sext.w	a5,a5
    802010d4:	06079c63          	bnez	a5,8020114c <strtol+0x128>
        if (*p == '0') {
    802010d8:	fd843783          	ld	a5,-40(s0)
    802010dc:	0007c783          	lbu	a5,0(a5)
    802010e0:	00078713          	mv	a4,a5
    802010e4:	03000793          	li	a5,48
    802010e8:	04f71e63          	bne	a4,a5,80201144 <strtol+0x120>
            p++;
    802010ec:	fd843783          	ld	a5,-40(s0)
    802010f0:	00178793          	addi	a5,a5,1
    802010f4:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
    802010f8:	fd843783          	ld	a5,-40(s0)
    802010fc:	0007c783          	lbu	a5,0(a5)
    80201100:	00078713          	mv	a4,a5
    80201104:	07800793          	li	a5,120
    80201108:	00f70c63          	beq	a4,a5,80201120 <strtol+0xfc>
    8020110c:	fd843783          	ld	a5,-40(s0)
    80201110:	0007c783          	lbu	a5,0(a5)
    80201114:	00078713          	mv	a4,a5
    80201118:	05800793          	li	a5,88
    8020111c:	00f71e63          	bne	a4,a5,80201138 <strtol+0x114>
                base = 16;
    80201120:	01000793          	li	a5,16
    80201124:	faf42e23          	sw	a5,-68(s0)
                p++;
    80201128:	fd843783          	ld	a5,-40(s0)
    8020112c:	00178793          	addi	a5,a5,1
    80201130:	fcf43c23          	sd	a5,-40(s0)
    80201134:	0180006f          	j	8020114c <strtol+0x128>
            } else {
                base = 8;
    80201138:	00800793          	li	a5,8
    8020113c:	faf42e23          	sw	a5,-68(s0)
    80201140:	00c0006f          	j	8020114c <strtol+0x128>
            }
        } else {
            base = 10;
    80201144:	00a00793          	li	a5,10
    80201148:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
    8020114c:	fd843783          	ld	a5,-40(s0)
    80201150:	0007c783          	lbu	a5,0(a5)
    80201154:	00078713          	mv	a4,a5
    80201158:	02f00793          	li	a5,47
    8020115c:	02e7f863          	bgeu	a5,a4,8020118c <strtol+0x168>
    80201160:	fd843783          	ld	a5,-40(s0)
    80201164:	0007c783          	lbu	a5,0(a5)
    80201168:	00078713          	mv	a4,a5
    8020116c:	03900793          	li	a5,57
    80201170:	00e7ee63          	bltu	a5,a4,8020118c <strtol+0x168>
            digit = *p - '0';
    80201174:	fd843783          	ld	a5,-40(s0)
    80201178:	0007c783          	lbu	a5,0(a5)
    8020117c:	0007879b          	sext.w	a5,a5
    80201180:	fd07879b          	addiw	a5,a5,-48
    80201184:	fcf42a23          	sw	a5,-44(s0)
    80201188:	0800006f          	j	80201208 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
    8020118c:	fd843783          	ld	a5,-40(s0)
    80201190:	0007c783          	lbu	a5,0(a5)
    80201194:	00078713          	mv	a4,a5
    80201198:	06000793          	li	a5,96
    8020119c:	02e7f863          	bgeu	a5,a4,802011cc <strtol+0x1a8>
    802011a0:	fd843783          	ld	a5,-40(s0)
    802011a4:	0007c783          	lbu	a5,0(a5)
    802011a8:	00078713          	mv	a4,a5
    802011ac:	07a00793          	li	a5,122
    802011b0:	00e7ee63          	bltu	a5,a4,802011cc <strtol+0x1a8>
            digit = *p - ('a' - 10);
    802011b4:	fd843783          	ld	a5,-40(s0)
    802011b8:	0007c783          	lbu	a5,0(a5)
    802011bc:	0007879b          	sext.w	a5,a5
    802011c0:	fa97879b          	addiw	a5,a5,-87
    802011c4:	fcf42a23          	sw	a5,-44(s0)
    802011c8:	0400006f          	j	80201208 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
    802011cc:	fd843783          	ld	a5,-40(s0)
    802011d0:	0007c783          	lbu	a5,0(a5)
    802011d4:	00078713          	mv	a4,a5
    802011d8:	04000793          	li	a5,64
    802011dc:	06e7f863          	bgeu	a5,a4,8020124c <strtol+0x228>
    802011e0:	fd843783          	ld	a5,-40(s0)
    802011e4:	0007c783          	lbu	a5,0(a5)
    802011e8:	00078713          	mv	a4,a5
    802011ec:	05a00793          	li	a5,90
    802011f0:	04e7ee63          	bltu	a5,a4,8020124c <strtol+0x228>
            digit = *p - ('A' - 10);
    802011f4:	fd843783          	ld	a5,-40(s0)
    802011f8:	0007c783          	lbu	a5,0(a5)
    802011fc:	0007879b          	sext.w	a5,a5
    80201200:	fc97879b          	addiw	a5,a5,-55
    80201204:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
    80201208:	fd442783          	lw	a5,-44(s0)
    8020120c:	00078713          	mv	a4,a5
    80201210:	fbc42783          	lw	a5,-68(s0)
    80201214:	0007071b          	sext.w	a4,a4
    80201218:	0007879b          	sext.w	a5,a5
    8020121c:	02f75663          	bge	a4,a5,80201248 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
    80201220:	fbc42703          	lw	a4,-68(s0)
    80201224:	fe843783          	ld	a5,-24(s0)
    80201228:	02f70733          	mul	a4,a4,a5
    8020122c:	fd442783          	lw	a5,-44(s0)
    80201230:	00f707b3          	add	a5,a4,a5
    80201234:	fef43423          	sd	a5,-24(s0)
        p++;
    80201238:	fd843783          	ld	a5,-40(s0)
    8020123c:	00178793          	addi	a5,a5,1
    80201240:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
    80201244:	f09ff06f          	j	8020114c <strtol+0x128>
            break;
    80201248:	00000013          	nop
    }

    if (endptr) {
    8020124c:	fc043783          	ld	a5,-64(s0)
    80201250:	00078863          	beqz	a5,80201260 <strtol+0x23c>
        *endptr = (char *)p;
    80201254:	fc043783          	ld	a5,-64(s0)
    80201258:	fd843703          	ld	a4,-40(s0)
    8020125c:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
    80201260:	fe744783          	lbu	a5,-25(s0)
    80201264:	0ff7f793          	zext.b	a5,a5
    80201268:	00078863          	beqz	a5,80201278 <strtol+0x254>
    8020126c:	fe843783          	ld	a5,-24(s0)
    80201270:	40f007b3          	neg	a5,a5
    80201274:	0080006f          	j	8020127c <strtol+0x258>
    80201278:	fe843783          	ld	a5,-24(s0)
}
    8020127c:	00078513          	mv	a0,a5
    80201280:	04813083          	ld	ra,72(sp)
    80201284:	04013403          	ld	s0,64(sp)
    80201288:	05010113          	addi	sp,sp,80
    8020128c:	00008067          	ret

0000000080201290 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
    80201290:	fd010113          	addi	sp,sp,-48
    80201294:	02113423          	sd	ra,40(sp)
    80201298:	02813023          	sd	s0,32(sp)
    8020129c:	03010413          	addi	s0,sp,48
    802012a0:	fca43c23          	sd	a0,-40(s0)
    802012a4:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
    802012a8:	fd043783          	ld	a5,-48(s0)
    802012ac:	00079863          	bnez	a5,802012bc <puts_wo_nl+0x2c>
        s = "(null)";
    802012b0:	00001797          	auipc	a5,0x1
    802012b4:	0c078793          	addi	a5,a5,192 # 80202370 <_srodata+0x370>
    802012b8:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
    802012bc:	fd043783          	ld	a5,-48(s0)
    802012c0:	fef43423          	sd	a5,-24(s0)
    while (*p) {
    802012c4:	0240006f          	j	802012e8 <puts_wo_nl+0x58>
        putch(*p++);
    802012c8:	fe843783          	ld	a5,-24(s0)
    802012cc:	00178713          	addi	a4,a5,1
    802012d0:	fee43423          	sd	a4,-24(s0)
    802012d4:	0007c783          	lbu	a5,0(a5)
    802012d8:	0007871b          	sext.w	a4,a5
    802012dc:	fd843783          	ld	a5,-40(s0)
    802012e0:	00070513          	mv	a0,a4
    802012e4:	000780e7          	jalr	a5
    while (*p) {
    802012e8:	fe843783          	ld	a5,-24(s0)
    802012ec:	0007c783          	lbu	a5,0(a5)
    802012f0:	fc079ce3          	bnez	a5,802012c8 <puts_wo_nl+0x38>
    }
    return p - s;
    802012f4:	fe843703          	ld	a4,-24(s0)
    802012f8:	fd043783          	ld	a5,-48(s0)
    802012fc:	40f707b3          	sub	a5,a4,a5
    80201300:	0007879b          	sext.w	a5,a5
}
    80201304:	00078513          	mv	a0,a5
    80201308:	02813083          	ld	ra,40(sp)
    8020130c:	02013403          	ld	s0,32(sp)
    80201310:	03010113          	addi	sp,sp,48
    80201314:	00008067          	ret

0000000080201318 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
    80201318:	f9010113          	addi	sp,sp,-112
    8020131c:	06113423          	sd	ra,104(sp)
    80201320:	06813023          	sd	s0,96(sp)
    80201324:	07010413          	addi	s0,sp,112
    80201328:	faa43423          	sd	a0,-88(s0)
    8020132c:	fab43023          	sd	a1,-96(s0)
    80201330:	00060793          	mv	a5,a2
    80201334:	f8d43823          	sd	a3,-112(s0)
    80201338:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
    8020133c:	f9f44783          	lbu	a5,-97(s0)
    80201340:	0ff7f793          	zext.b	a5,a5
    80201344:	02078663          	beqz	a5,80201370 <print_dec_int+0x58>
    80201348:	fa043703          	ld	a4,-96(s0)
    8020134c:	fff00793          	li	a5,-1
    80201350:	03f79793          	slli	a5,a5,0x3f
    80201354:	00f71e63          	bne	a4,a5,80201370 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
    80201358:	00001597          	auipc	a1,0x1
    8020135c:	02058593          	addi	a1,a1,32 # 80202378 <_srodata+0x378>
    80201360:	fa843503          	ld	a0,-88(s0)
    80201364:	f2dff0ef          	jal	80201290 <puts_wo_nl>
    80201368:	00050793          	mv	a5,a0
    8020136c:	2a00006f          	j	8020160c <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
    80201370:	f9043783          	ld	a5,-112(s0)
    80201374:	00c7a783          	lw	a5,12(a5)
    80201378:	00079a63          	bnez	a5,8020138c <print_dec_int+0x74>
    8020137c:	fa043783          	ld	a5,-96(s0)
    80201380:	00079663          	bnez	a5,8020138c <print_dec_int+0x74>
        return 0;
    80201384:	00000793          	li	a5,0
    80201388:	2840006f          	j	8020160c <print_dec_int+0x2f4>
    }

    bool neg = false;
    8020138c:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
    80201390:	f9f44783          	lbu	a5,-97(s0)
    80201394:	0ff7f793          	zext.b	a5,a5
    80201398:	02078063          	beqz	a5,802013b8 <print_dec_int+0xa0>
    8020139c:	fa043783          	ld	a5,-96(s0)
    802013a0:	0007dc63          	bgez	a5,802013b8 <print_dec_int+0xa0>
        neg = true;
    802013a4:	00100793          	li	a5,1
    802013a8:	fef407a3          	sb	a5,-17(s0)
        num = -num;
    802013ac:	fa043783          	ld	a5,-96(s0)
    802013b0:	40f007b3          	neg	a5,a5
    802013b4:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
    802013b8:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
    802013bc:	f9f44783          	lbu	a5,-97(s0)
    802013c0:	0ff7f793          	zext.b	a5,a5
    802013c4:	02078863          	beqz	a5,802013f4 <print_dec_int+0xdc>
    802013c8:	fef44783          	lbu	a5,-17(s0)
    802013cc:	0ff7f793          	zext.b	a5,a5
    802013d0:	00079e63          	bnez	a5,802013ec <print_dec_int+0xd4>
    802013d4:	f9043783          	ld	a5,-112(s0)
    802013d8:	0057c783          	lbu	a5,5(a5)
    802013dc:	00079863          	bnez	a5,802013ec <print_dec_int+0xd4>
    802013e0:	f9043783          	ld	a5,-112(s0)
    802013e4:	0047c783          	lbu	a5,4(a5)
    802013e8:	00078663          	beqz	a5,802013f4 <print_dec_int+0xdc>
    802013ec:	00100793          	li	a5,1
    802013f0:	0080006f          	j	802013f8 <print_dec_int+0xe0>
    802013f4:	00000793          	li	a5,0
    802013f8:	fcf40ba3          	sb	a5,-41(s0)
    802013fc:	fd744783          	lbu	a5,-41(s0)
    80201400:	0017f793          	andi	a5,a5,1
    80201404:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
    80201408:	fa043703          	ld	a4,-96(s0)
    8020140c:	00a00793          	li	a5,10
    80201410:	02f777b3          	remu	a5,a4,a5
    80201414:	0ff7f713          	zext.b	a4,a5
    80201418:	fe842783          	lw	a5,-24(s0)
    8020141c:	0017869b          	addiw	a3,a5,1
    80201420:	fed42423          	sw	a3,-24(s0)
    80201424:	0307071b          	addiw	a4,a4,48
    80201428:	0ff77713          	zext.b	a4,a4
    8020142c:	ff078793          	addi	a5,a5,-16
    80201430:	008787b3          	add	a5,a5,s0
    80201434:	fce78423          	sb	a4,-56(a5)
        num /= 10;
    80201438:	fa043703          	ld	a4,-96(s0)
    8020143c:	00a00793          	li	a5,10
    80201440:	02f757b3          	divu	a5,a4,a5
    80201444:	faf43023          	sd	a5,-96(s0)
    } while (num);
    80201448:	fa043783          	ld	a5,-96(s0)
    8020144c:	fa079ee3          	bnez	a5,80201408 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
    80201450:	f9043783          	ld	a5,-112(s0)
    80201454:	00c7a783          	lw	a5,12(a5)
    80201458:	00078713          	mv	a4,a5
    8020145c:	fff00793          	li	a5,-1
    80201460:	02f71063          	bne	a4,a5,80201480 <print_dec_int+0x168>
    80201464:	f9043783          	ld	a5,-112(s0)
    80201468:	0037c783          	lbu	a5,3(a5)
    8020146c:	00078a63          	beqz	a5,80201480 <print_dec_int+0x168>
        flags->prec = flags->width;
    80201470:	f9043783          	ld	a5,-112(s0)
    80201474:	0087a703          	lw	a4,8(a5)
    80201478:	f9043783          	ld	a5,-112(s0)
    8020147c:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
    80201480:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80201484:	f9043783          	ld	a5,-112(s0)
    80201488:	0087a703          	lw	a4,8(a5)
    8020148c:	fe842783          	lw	a5,-24(s0)
    80201490:	fcf42823          	sw	a5,-48(s0)
    80201494:	f9043783          	ld	a5,-112(s0)
    80201498:	00c7a783          	lw	a5,12(a5)
    8020149c:	fcf42623          	sw	a5,-52(s0)
    802014a0:	fd042783          	lw	a5,-48(s0)
    802014a4:	00078593          	mv	a1,a5
    802014a8:	fcc42783          	lw	a5,-52(s0)
    802014ac:	00078613          	mv	a2,a5
    802014b0:	0006069b          	sext.w	a3,a2
    802014b4:	0005879b          	sext.w	a5,a1
    802014b8:	00f6d463          	bge	a3,a5,802014c0 <print_dec_int+0x1a8>
    802014bc:	00058613          	mv	a2,a1
    802014c0:	0006079b          	sext.w	a5,a2
    802014c4:	40f707bb          	subw	a5,a4,a5
    802014c8:	0007871b          	sext.w	a4,a5
    802014cc:	fd744783          	lbu	a5,-41(s0)
    802014d0:	0007879b          	sext.w	a5,a5
    802014d4:	40f707bb          	subw	a5,a4,a5
    802014d8:	fef42023          	sw	a5,-32(s0)
    802014dc:	0280006f          	j	80201504 <print_dec_int+0x1ec>
        putch(' ');
    802014e0:	fa843783          	ld	a5,-88(s0)
    802014e4:	02000513          	li	a0,32
    802014e8:	000780e7          	jalr	a5
        ++written;
    802014ec:	fe442783          	lw	a5,-28(s0)
    802014f0:	0017879b          	addiw	a5,a5,1
    802014f4:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    802014f8:	fe042783          	lw	a5,-32(s0)
    802014fc:	fff7879b          	addiw	a5,a5,-1
    80201500:	fef42023          	sw	a5,-32(s0)
    80201504:	fe042783          	lw	a5,-32(s0)
    80201508:	0007879b          	sext.w	a5,a5
    8020150c:	fcf04ae3          	bgtz	a5,802014e0 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
    80201510:	fd744783          	lbu	a5,-41(s0)
    80201514:	0ff7f793          	zext.b	a5,a5
    80201518:	04078463          	beqz	a5,80201560 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
    8020151c:	fef44783          	lbu	a5,-17(s0)
    80201520:	0ff7f793          	zext.b	a5,a5
    80201524:	00078663          	beqz	a5,80201530 <print_dec_int+0x218>
    80201528:	02d00793          	li	a5,45
    8020152c:	01c0006f          	j	80201548 <print_dec_int+0x230>
    80201530:	f9043783          	ld	a5,-112(s0)
    80201534:	0057c783          	lbu	a5,5(a5)
    80201538:	00078663          	beqz	a5,80201544 <print_dec_int+0x22c>
    8020153c:	02b00793          	li	a5,43
    80201540:	0080006f          	j	80201548 <print_dec_int+0x230>
    80201544:	02000793          	li	a5,32
    80201548:	fa843703          	ld	a4,-88(s0)
    8020154c:	00078513          	mv	a0,a5
    80201550:	000700e7          	jalr	a4
        ++written;
    80201554:	fe442783          	lw	a5,-28(s0)
    80201558:	0017879b          	addiw	a5,a5,1
    8020155c:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80201560:	fe842783          	lw	a5,-24(s0)
    80201564:	fcf42e23          	sw	a5,-36(s0)
    80201568:	0280006f          	j	80201590 <print_dec_int+0x278>
        putch('0');
    8020156c:	fa843783          	ld	a5,-88(s0)
    80201570:	03000513          	li	a0,48
    80201574:	000780e7          	jalr	a5
        ++written;
    80201578:	fe442783          	lw	a5,-28(s0)
    8020157c:	0017879b          	addiw	a5,a5,1
    80201580:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80201584:	fdc42783          	lw	a5,-36(s0)
    80201588:	0017879b          	addiw	a5,a5,1
    8020158c:	fcf42e23          	sw	a5,-36(s0)
    80201590:	f9043783          	ld	a5,-112(s0)
    80201594:	00c7a703          	lw	a4,12(a5)
    80201598:	fd744783          	lbu	a5,-41(s0)
    8020159c:	0007879b          	sext.w	a5,a5
    802015a0:	40f707bb          	subw	a5,a4,a5
    802015a4:	0007871b          	sext.w	a4,a5
    802015a8:	fdc42783          	lw	a5,-36(s0)
    802015ac:	0007879b          	sext.w	a5,a5
    802015b0:	fae7cee3          	blt	a5,a4,8020156c <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
    802015b4:	fe842783          	lw	a5,-24(s0)
    802015b8:	fff7879b          	addiw	a5,a5,-1
    802015bc:	fcf42c23          	sw	a5,-40(s0)
    802015c0:	03c0006f          	j	802015fc <print_dec_int+0x2e4>
        putch(buf[i]);
    802015c4:	fd842783          	lw	a5,-40(s0)
    802015c8:	ff078793          	addi	a5,a5,-16
    802015cc:	008787b3          	add	a5,a5,s0
    802015d0:	fc87c783          	lbu	a5,-56(a5)
    802015d4:	0007871b          	sext.w	a4,a5
    802015d8:	fa843783          	ld	a5,-88(s0)
    802015dc:	00070513          	mv	a0,a4
    802015e0:	000780e7          	jalr	a5
        ++written;
    802015e4:	fe442783          	lw	a5,-28(s0)
    802015e8:	0017879b          	addiw	a5,a5,1
    802015ec:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
    802015f0:	fd842783          	lw	a5,-40(s0)
    802015f4:	fff7879b          	addiw	a5,a5,-1
    802015f8:	fcf42c23          	sw	a5,-40(s0)
    802015fc:	fd842783          	lw	a5,-40(s0)
    80201600:	0007879b          	sext.w	a5,a5
    80201604:	fc07d0e3          	bgez	a5,802015c4 <print_dec_int+0x2ac>
    }

    return written;
    80201608:	fe442783          	lw	a5,-28(s0)
}
    8020160c:	00078513          	mv	a0,a5
    80201610:	06813083          	ld	ra,104(sp)
    80201614:	06013403          	ld	s0,96(sp)
    80201618:	07010113          	addi	sp,sp,112
    8020161c:	00008067          	ret

0000000080201620 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
    80201620:	f4010113          	addi	sp,sp,-192
    80201624:	0a113c23          	sd	ra,184(sp)
    80201628:	0a813823          	sd	s0,176(sp)
    8020162c:	0c010413          	addi	s0,sp,192
    80201630:	f4a43c23          	sd	a0,-168(s0)
    80201634:	f4b43823          	sd	a1,-176(s0)
    80201638:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
    8020163c:	f8043023          	sd	zero,-128(s0)
    80201640:	f8043423          	sd	zero,-120(s0)

    int written = 0;
    80201644:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
    80201648:	7a40006f          	j	80201dec <vprintfmt+0x7cc>
        if (flags.in_format) {
    8020164c:	f8044783          	lbu	a5,-128(s0)
    80201650:	72078e63          	beqz	a5,80201d8c <vprintfmt+0x76c>
            if (*fmt == '#') {
    80201654:	f5043783          	ld	a5,-176(s0)
    80201658:	0007c783          	lbu	a5,0(a5)
    8020165c:	00078713          	mv	a4,a5
    80201660:	02300793          	li	a5,35
    80201664:	00f71863          	bne	a4,a5,80201674 <vprintfmt+0x54>
                flags.sharpflag = true;
    80201668:	00100793          	li	a5,1
    8020166c:	f8f40123          	sb	a5,-126(s0)
    80201670:	7700006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
    80201674:	f5043783          	ld	a5,-176(s0)
    80201678:	0007c783          	lbu	a5,0(a5)
    8020167c:	00078713          	mv	a4,a5
    80201680:	03000793          	li	a5,48
    80201684:	00f71863          	bne	a4,a5,80201694 <vprintfmt+0x74>
                flags.zeroflag = true;
    80201688:	00100793          	li	a5,1
    8020168c:	f8f401a3          	sb	a5,-125(s0)
    80201690:	7500006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
    80201694:	f5043783          	ld	a5,-176(s0)
    80201698:	0007c783          	lbu	a5,0(a5)
    8020169c:	00078713          	mv	a4,a5
    802016a0:	06c00793          	li	a5,108
    802016a4:	04f70063          	beq	a4,a5,802016e4 <vprintfmt+0xc4>
    802016a8:	f5043783          	ld	a5,-176(s0)
    802016ac:	0007c783          	lbu	a5,0(a5)
    802016b0:	00078713          	mv	a4,a5
    802016b4:	07a00793          	li	a5,122
    802016b8:	02f70663          	beq	a4,a5,802016e4 <vprintfmt+0xc4>
    802016bc:	f5043783          	ld	a5,-176(s0)
    802016c0:	0007c783          	lbu	a5,0(a5)
    802016c4:	00078713          	mv	a4,a5
    802016c8:	07400793          	li	a5,116
    802016cc:	00f70c63          	beq	a4,a5,802016e4 <vprintfmt+0xc4>
    802016d0:	f5043783          	ld	a5,-176(s0)
    802016d4:	0007c783          	lbu	a5,0(a5)
    802016d8:	00078713          	mv	a4,a5
    802016dc:	06a00793          	li	a5,106
    802016e0:	00f71863          	bne	a4,a5,802016f0 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
    802016e4:	00100793          	li	a5,1
    802016e8:	f8f400a3          	sb	a5,-127(s0)
    802016ec:	6f40006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
    802016f0:	f5043783          	ld	a5,-176(s0)
    802016f4:	0007c783          	lbu	a5,0(a5)
    802016f8:	00078713          	mv	a4,a5
    802016fc:	02b00793          	li	a5,43
    80201700:	00f71863          	bne	a4,a5,80201710 <vprintfmt+0xf0>
                flags.sign = true;
    80201704:	00100793          	li	a5,1
    80201708:	f8f402a3          	sb	a5,-123(s0)
    8020170c:	6d40006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
    80201710:	f5043783          	ld	a5,-176(s0)
    80201714:	0007c783          	lbu	a5,0(a5)
    80201718:	00078713          	mv	a4,a5
    8020171c:	02000793          	li	a5,32
    80201720:	00f71863          	bne	a4,a5,80201730 <vprintfmt+0x110>
                flags.spaceflag = true;
    80201724:	00100793          	li	a5,1
    80201728:	f8f40223          	sb	a5,-124(s0)
    8020172c:	6b40006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
    80201730:	f5043783          	ld	a5,-176(s0)
    80201734:	0007c783          	lbu	a5,0(a5)
    80201738:	00078713          	mv	a4,a5
    8020173c:	02a00793          	li	a5,42
    80201740:	00f71e63          	bne	a4,a5,8020175c <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
    80201744:	f4843783          	ld	a5,-184(s0)
    80201748:	00878713          	addi	a4,a5,8
    8020174c:	f4e43423          	sd	a4,-184(s0)
    80201750:	0007a783          	lw	a5,0(a5)
    80201754:	f8f42423          	sw	a5,-120(s0)
    80201758:	6880006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
    8020175c:	f5043783          	ld	a5,-176(s0)
    80201760:	0007c783          	lbu	a5,0(a5)
    80201764:	00078713          	mv	a4,a5
    80201768:	03000793          	li	a5,48
    8020176c:	04e7f663          	bgeu	a5,a4,802017b8 <vprintfmt+0x198>
    80201770:	f5043783          	ld	a5,-176(s0)
    80201774:	0007c783          	lbu	a5,0(a5)
    80201778:	00078713          	mv	a4,a5
    8020177c:	03900793          	li	a5,57
    80201780:	02e7ec63          	bltu	a5,a4,802017b8 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
    80201784:	f5043783          	ld	a5,-176(s0)
    80201788:	f5040713          	addi	a4,s0,-176
    8020178c:	00a00613          	li	a2,10
    80201790:	00070593          	mv	a1,a4
    80201794:	00078513          	mv	a0,a5
    80201798:	88dff0ef          	jal	80201024 <strtol>
    8020179c:	00050793          	mv	a5,a0
    802017a0:	0007879b          	sext.w	a5,a5
    802017a4:	f8f42423          	sw	a5,-120(s0)
                fmt--;
    802017a8:	f5043783          	ld	a5,-176(s0)
    802017ac:	fff78793          	addi	a5,a5,-1
    802017b0:	f4f43823          	sd	a5,-176(s0)
    802017b4:	62c0006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
    802017b8:	f5043783          	ld	a5,-176(s0)
    802017bc:	0007c783          	lbu	a5,0(a5)
    802017c0:	00078713          	mv	a4,a5
    802017c4:	02e00793          	li	a5,46
    802017c8:	06f71863          	bne	a4,a5,80201838 <vprintfmt+0x218>
                fmt++;
    802017cc:	f5043783          	ld	a5,-176(s0)
    802017d0:	00178793          	addi	a5,a5,1
    802017d4:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
    802017d8:	f5043783          	ld	a5,-176(s0)
    802017dc:	0007c783          	lbu	a5,0(a5)
    802017e0:	00078713          	mv	a4,a5
    802017e4:	02a00793          	li	a5,42
    802017e8:	00f71e63          	bne	a4,a5,80201804 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
    802017ec:	f4843783          	ld	a5,-184(s0)
    802017f0:	00878713          	addi	a4,a5,8
    802017f4:	f4e43423          	sd	a4,-184(s0)
    802017f8:	0007a783          	lw	a5,0(a5)
    802017fc:	f8f42623          	sw	a5,-116(s0)
    80201800:	5e00006f          	j	80201de0 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
    80201804:	f5043783          	ld	a5,-176(s0)
    80201808:	f5040713          	addi	a4,s0,-176
    8020180c:	00a00613          	li	a2,10
    80201810:	00070593          	mv	a1,a4
    80201814:	00078513          	mv	a0,a5
    80201818:	80dff0ef          	jal	80201024 <strtol>
    8020181c:	00050793          	mv	a5,a0
    80201820:	0007879b          	sext.w	a5,a5
    80201824:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
    80201828:	f5043783          	ld	a5,-176(s0)
    8020182c:	fff78793          	addi	a5,a5,-1
    80201830:	f4f43823          	sd	a5,-176(s0)
    80201834:	5ac0006f          	j	80201de0 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80201838:	f5043783          	ld	a5,-176(s0)
    8020183c:	0007c783          	lbu	a5,0(a5)
    80201840:	00078713          	mv	a4,a5
    80201844:	07800793          	li	a5,120
    80201848:	02f70663          	beq	a4,a5,80201874 <vprintfmt+0x254>
    8020184c:	f5043783          	ld	a5,-176(s0)
    80201850:	0007c783          	lbu	a5,0(a5)
    80201854:	00078713          	mv	a4,a5
    80201858:	05800793          	li	a5,88
    8020185c:	00f70c63          	beq	a4,a5,80201874 <vprintfmt+0x254>
    80201860:	f5043783          	ld	a5,-176(s0)
    80201864:	0007c783          	lbu	a5,0(a5)
    80201868:	00078713          	mv	a4,a5
    8020186c:	07000793          	li	a5,112
    80201870:	30f71263          	bne	a4,a5,80201b74 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
    80201874:	f5043783          	ld	a5,-176(s0)
    80201878:	0007c783          	lbu	a5,0(a5)
    8020187c:	00078713          	mv	a4,a5
    80201880:	07000793          	li	a5,112
    80201884:	00f70663          	beq	a4,a5,80201890 <vprintfmt+0x270>
    80201888:	f8144783          	lbu	a5,-127(s0)
    8020188c:	00078663          	beqz	a5,80201898 <vprintfmt+0x278>
    80201890:	00100793          	li	a5,1
    80201894:	0080006f          	j	8020189c <vprintfmt+0x27c>
    80201898:	00000793          	li	a5,0
    8020189c:	faf403a3          	sb	a5,-89(s0)
    802018a0:	fa744783          	lbu	a5,-89(s0)
    802018a4:	0017f793          	andi	a5,a5,1
    802018a8:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
    802018ac:	fa744783          	lbu	a5,-89(s0)
    802018b0:	0ff7f793          	zext.b	a5,a5
    802018b4:	00078c63          	beqz	a5,802018cc <vprintfmt+0x2ac>
    802018b8:	f4843783          	ld	a5,-184(s0)
    802018bc:	00878713          	addi	a4,a5,8
    802018c0:	f4e43423          	sd	a4,-184(s0)
    802018c4:	0007b783          	ld	a5,0(a5)
    802018c8:	01c0006f          	j	802018e4 <vprintfmt+0x2c4>
    802018cc:	f4843783          	ld	a5,-184(s0)
    802018d0:	00878713          	addi	a4,a5,8
    802018d4:	f4e43423          	sd	a4,-184(s0)
    802018d8:	0007a783          	lw	a5,0(a5)
    802018dc:	02079793          	slli	a5,a5,0x20
    802018e0:	0207d793          	srli	a5,a5,0x20
    802018e4:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
    802018e8:	f8c42783          	lw	a5,-116(s0)
    802018ec:	02079463          	bnez	a5,80201914 <vprintfmt+0x2f4>
    802018f0:	fe043783          	ld	a5,-32(s0)
    802018f4:	02079063          	bnez	a5,80201914 <vprintfmt+0x2f4>
    802018f8:	f5043783          	ld	a5,-176(s0)
    802018fc:	0007c783          	lbu	a5,0(a5)
    80201900:	00078713          	mv	a4,a5
    80201904:	07000793          	li	a5,112
    80201908:	00f70663          	beq	a4,a5,80201914 <vprintfmt+0x2f4>
                    flags.in_format = false;
    8020190c:	f8040023          	sb	zero,-128(s0)
    80201910:	4d00006f          	j	80201de0 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
    80201914:	f5043783          	ld	a5,-176(s0)
    80201918:	0007c783          	lbu	a5,0(a5)
    8020191c:	00078713          	mv	a4,a5
    80201920:	07000793          	li	a5,112
    80201924:	00f70a63          	beq	a4,a5,80201938 <vprintfmt+0x318>
    80201928:	f8244783          	lbu	a5,-126(s0)
    8020192c:	00078a63          	beqz	a5,80201940 <vprintfmt+0x320>
    80201930:	fe043783          	ld	a5,-32(s0)
    80201934:	00078663          	beqz	a5,80201940 <vprintfmt+0x320>
    80201938:	00100793          	li	a5,1
    8020193c:	0080006f          	j	80201944 <vprintfmt+0x324>
    80201940:	00000793          	li	a5,0
    80201944:	faf40323          	sb	a5,-90(s0)
    80201948:	fa644783          	lbu	a5,-90(s0)
    8020194c:	0017f793          	andi	a5,a5,1
    80201950:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
    80201954:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
    80201958:	f5043783          	ld	a5,-176(s0)
    8020195c:	0007c783          	lbu	a5,0(a5)
    80201960:	00078713          	mv	a4,a5
    80201964:	05800793          	li	a5,88
    80201968:	00f71863          	bne	a4,a5,80201978 <vprintfmt+0x358>
    8020196c:	00001797          	auipc	a5,0x1
    80201970:	a2478793          	addi	a5,a5,-1500 # 80202390 <upperxdigits.1>
    80201974:	00c0006f          	j	80201980 <vprintfmt+0x360>
    80201978:	00001797          	auipc	a5,0x1
    8020197c:	a3078793          	addi	a5,a5,-1488 # 802023a8 <lowerxdigits.0>
    80201980:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
    80201984:	fe043783          	ld	a5,-32(s0)
    80201988:	00f7f793          	andi	a5,a5,15
    8020198c:	f9843703          	ld	a4,-104(s0)
    80201990:	00f70733          	add	a4,a4,a5
    80201994:	fdc42783          	lw	a5,-36(s0)
    80201998:	0017869b          	addiw	a3,a5,1
    8020199c:	fcd42e23          	sw	a3,-36(s0)
    802019a0:	00074703          	lbu	a4,0(a4)
    802019a4:	ff078793          	addi	a5,a5,-16
    802019a8:	008787b3          	add	a5,a5,s0
    802019ac:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
    802019b0:	fe043783          	ld	a5,-32(s0)
    802019b4:	0047d793          	srli	a5,a5,0x4
    802019b8:	fef43023          	sd	a5,-32(s0)
                } while (num);
    802019bc:	fe043783          	ld	a5,-32(s0)
    802019c0:	fc0792e3          	bnez	a5,80201984 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
    802019c4:	f8c42783          	lw	a5,-116(s0)
    802019c8:	00078713          	mv	a4,a5
    802019cc:	fff00793          	li	a5,-1
    802019d0:	02f71663          	bne	a4,a5,802019fc <vprintfmt+0x3dc>
    802019d4:	f8344783          	lbu	a5,-125(s0)
    802019d8:	02078263          	beqz	a5,802019fc <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
    802019dc:	f8842703          	lw	a4,-120(s0)
    802019e0:	fa644783          	lbu	a5,-90(s0)
    802019e4:	0007879b          	sext.w	a5,a5
    802019e8:	0017979b          	slliw	a5,a5,0x1
    802019ec:	0007879b          	sext.w	a5,a5
    802019f0:	40f707bb          	subw	a5,a4,a5
    802019f4:	0007879b          	sext.w	a5,a5
    802019f8:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    802019fc:	f8842703          	lw	a4,-120(s0)
    80201a00:	fa644783          	lbu	a5,-90(s0)
    80201a04:	0007879b          	sext.w	a5,a5
    80201a08:	0017979b          	slliw	a5,a5,0x1
    80201a0c:	0007879b          	sext.w	a5,a5
    80201a10:	40f707bb          	subw	a5,a4,a5
    80201a14:	0007871b          	sext.w	a4,a5
    80201a18:	fdc42783          	lw	a5,-36(s0)
    80201a1c:	f8f42a23          	sw	a5,-108(s0)
    80201a20:	f8c42783          	lw	a5,-116(s0)
    80201a24:	f8f42823          	sw	a5,-112(s0)
    80201a28:	f9442783          	lw	a5,-108(s0)
    80201a2c:	00078593          	mv	a1,a5
    80201a30:	f9042783          	lw	a5,-112(s0)
    80201a34:	00078613          	mv	a2,a5
    80201a38:	0006069b          	sext.w	a3,a2
    80201a3c:	0005879b          	sext.w	a5,a1
    80201a40:	00f6d463          	bge	a3,a5,80201a48 <vprintfmt+0x428>
    80201a44:	00058613          	mv	a2,a1
    80201a48:	0006079b          	sext.w	a5,a2
    80201a4c:	40f707bb          	subw	a5,a4,a5
    80201a50:	fcf42c23          	sw	a5,-40(s0)
    80201a54:	0280006f          	j	80201a7c <vprintfmt+0x45c>
                    putch(' ');
    80201a58:	f5843783          	ld	a5,-168(s0)
    80201a5c:	02000513          	li	a0,32
    80201a60:	000780e7          	jalr	a5
                    ++written;
    80201a64:	fec42783          	lw	a5,-20(s0)
    80201a68:	0017879b          	addiw	a5,a5,1
    80201a6c:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201a70:	fd842783          	lw	a5,-40(s0)
    80201a74:	fff7879b          	addiw	a5,a5,-1
    80201a78:	fcf42c23          	sw	a5,-40(s0)
    80201a7c:	fd842783          	lw	a5,-40(s0)
    80201a80:	0007879b          	sext.w	a5,a5
    80201a84:	fcf04ae3          	bgtz	a5,80201a58 <vprintfmt+0x438>
                }

                if (prefix) {
    80201a88:	fa644783          	lbu	a5,-90(s0)
    80201a8c:	0ff7f793          	zext.b	a5,a5
    80201a90:	04078463          	beqz	a5,80201ad8 <vprintfmt+0x4b8>
                    putch('0');
    80201a94:	f5843783          	ld	a5,-168(s0)
    80201a98:	03000513          	li	a0,48
    80201a9c:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
    80201aa0:	f5043783          	ld	a5,-176(s0)
    80201aa4:	0007c783          	lbu	a5,0(a5)
    80201aa8:	00078713          	mv	a4,a5
    80201aac:	05800793          	li	a5,88
    80201ab0:	00f71663          	bne	a4,a5,80201abc <vprintfmt+0x49c>
    80201ab4:	05800793          	li	a5,88
    80201ab8:	0080006f          	j	80201ac0 <vprintfmt+0x4a0>
    80201abc:	07800793          	li	a5,120
    80201ac0:	f5843703          	ld	a4,-168(s0)
    80201ac4:	00078513          	mv	a0,a5
    80201ac8:	000700e7          	jalr	a4
                    written += 2;
    80201acc:	fec42783          	lw	a5,-20(s0)
    80201ad0:	0027879b          	addiw	a5,a5,2
    80201ad4:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
    80201ad8:	fdc42783          	lw	a5,-36(s0)
    80201adc:	fcf42a23          	sw	a5,-44(s0)
    80201ae0:	0280006f          	j	80201b08 <vprintfmt+0x4e8>
                    putch('0');
    80201ae4:	f5843783          	ld	a5,-168(s0)
    80201ae8:	03000513          	li	a0,48
    80201aec:	000780e7          	jalr	a5
                    ++written;
    80201af0:	fec42783          	lw	a5,-20(s0)
    80201af4:	0017879b          	addiw	a5,a5,1
    80201af8:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
    80201afc:	fd442783          	lw	a5,-44(s0)
    80201b00:	0017879b          	addiw	a5,a5,1
    80201b04:	fcf42a23          	sw	a5,-44(s0)
    80201b08:	f8c42703          	lw	a4,-116(s0)
    80201b0c:	fd442783          	lw	a5,-44(s0)
    80201b10:	0007879b          	sext.w	a5,a5
    80201b14:	fce7c8e3          	blt	a5,a4,80201ae4 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
    80201b18:	fdc42783          	lw	a5,-36(s0)
    80201b1c:	fff7879b          	addiw	a5,a5,-1
    80201b20:	fcf42823          	sw	a5,-48(s0)
    80201b24:	03c0006f          	j	80201b60 <vprintfmt+0x540>
                    putch(buf[i]);
    80201b28:	fd042783          	lw	a5,-48(s0)
    80201b2c:	ff078793          	addi	a5,a5,-16
    80201b30:	008787b3          	add	a5,a5,s0
    80201b34:	f807c783          	lbu	a5,-128(a5)
    80201b38:	0007871b          	sext.w	a4,a5
    80201b3c:	f5843783          	ld	a5,-168(s0)
    80201b40:	00070513          	mv	a0,a4
    80201b44:	000780e7          	jalr	a5
                    ++written;
    80201b48:	fec42783          	lw	a5,-20(s0)
    80201b4c:	0017879b          	addiw	a5,a5,1
    80201b50:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
    80201b54:	fd042783          	lw	a5,-48(s0)
    80201b58:	fff7879b          	addiw	a5,a5,-1
    80201b5c:	fcf42823          	sw	a5,-48(s0)
    80201b60:	fd042783          	lw	a5,-48(s0)
    80201b64:	0007879b          	sext.w	a5,a5
    80201b68:	fc07d0e3          	bgez	a5,80201b28 <vprintfmt+0x508>
                }

                flags.in_format = false;
    80201b6c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80201b70:	2700006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201b74:	f5043783          	ld	a5,-176(s0)
    80201b78:	0007c783          	lbu	a5,0(a5)
    80201b7c:	00078713          	mv	a4,a5
    80201b80:	06400793          	li	a5,100
    80201b84:	02f70663          	beq	a4,a5,80201bb0 <vprintfmt+0x590>
    80201b88:	f5043783          	ld	a5,-176(s0)
    80201b8c:	0007c783          	lbu	a5,0(a5)
    80201b90:	00078713          	mv	a4,a5
    80201b94:	06900793          	li	a5,105
    80201b98:	00f70c63          	beq	a4,a5,80201bb0 <vprintfmt+0x590>
    80201b9c:	f5043783          	ld	a5,-176(s0)
    80201ba0:	0007c783          	lbu	a5,0(a5)
    80201ba4:	00078713          	mv	a4,a5
    80201ba8:	07500793          	li	a5,117
    80201bac:	08f71063          	bne	a4,a5,80201c2c <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
    80201bb0:	f8144783          	lbu	a5,-127(s0)
    80201bb4:	00078c63          	beqz	a5,80201bcc <vprintfmt+0x5ac>
    80201bb8:	f4843783          	ld	a5,-184(s0)
    80201bbc:	00878713          	addi	a4,a5,8
    80201bc0:	f4e43423          	sd	a4,-184(s0)
    80201bc4:	0007b783          	ld	a5,0(a5)
    80201bc8:	0140006f          	j	80201bdc <vprintfmt+0x5bc>
    80201bcc:	f4843783          	ld	a5,-184(s0)
    80201bd0:	00878713          	addi	a4,a5,8
    80201bd4:	f4e43423          	sd	a4,-184(s0)
    80201bd8:	0007a783          	lw	a5,0(a5)
    80201bdc:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
    80201be0:	fa843583          	ld	a1,-88(s0)
    80201be4:	f5043783          	ld	a5,-176(s0)
    80201be8:	0007c783          	lbu	a5,0(a5)
    80201bec:	0007871b          	sext.w	a4,a5
    80201bf0:	07500793          	li	a5,117
    80201bf4:	40f707b3          	sub	a5,a4,a5
    80201bf8:	00f037b3          	snez	a5,a5
    80201bfc:	0ff7f793          	zext.b	a5,a5
    80201c00:	f8040713          	addi	a4,s0,-128
    80201c04:	00070693          	mv	a3,a4
    80201c08:	00078613          	mv	a2,a5
    80201c0c:	f5843503          	ld	a0,-168(s0)
    80201c10:	f08ff0ef          	jal	80201318 <print_dec_int>
    80201c14:	00050793          	mv	a5,a0
    80201c18:	fec42703          	lw	a4,-20(s0)
    80201c1c:	00f707bb          	addw	a5,a4,a5
    80201c20:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201c24:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201c28:	1b80006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
    80201c2c:	f5043783          	ld	a5,-176(s0)
    80201c30:	0007c783          	lbu	a5,0(a5)
    80201c34:	00078713          	mv	a4,a5
    80201c38:	06e00793          	li	a5,110
    80201c3c:	04f71c63          	bne	a4,a5,80201c94 <vprintfmt+0x674>
                if (flags.longflag) {
    80201c40:	f8144783          	lbu	a5,-127(s0)
    80201c44:	02078463          	beqz	a5,80201c6c <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
    80201c48:	f4843783          	ld	a5,-184(s0)
    80201c4c:	00878713          	addi	a4,a5,8
    80201c50:	f4e43423          	sd	a4,-184(s0)
    80201c54:	0007b783          	ld	a5,0(a5)
    80201c58:	faf43823          	sd	a5,-80(s0)
                    *n = written;
    80201c5c:	fec42703          	lw	a4,-20(s0)
    80201c60:	fb043783          	ld	a5,-80(s0)
    80201c64:	00e7b023          	sd	a4,0(a5)
    80201c68:	0240006f          	j	80201c8c <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
    80201c6c:	f4843783          	ld	a5,-184(s0)
    80201c70:	00878713          	addi	a4,a5,8
    80201c74:	f4e43423          	sd	a4,-184(s0)
    80201c78:	0007b783          	ld	a5,0(a5)
    80201c7c:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
    80201c80:	fb843783          	ld	a5,-72(s0)
    80201c84:	fec42703          	lw	a4,-20(s0)
    80201c88:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
    80201c8c:	f8040023          	sb	zero,-128(s0)
    80201c90:	1500006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
    80201c94:	f5043783          	ld	a5,-176(s0)
    80201c98:	0007c783          	lbu	a5,0(a5)
    80201c9c:	00078713          	mv	a4,a5
    80201ca0:	07300793          	li	a5,115
    80201ca4:	02f71e63          	bne	a4,a5,80201ce0 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
    80201ca8:	f4843783          	ld	a5,-184(s0)
    80201cac:	00878713          	addi	a4,a5,8
    80201cb0:	f4e43423          	sd	a4,-184(s0)
    80201cb4:	0007b783          	ld	a5,0(a5)
    80201cb8:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
    80201cbc:	fc043583          	ld	a1,-64(s0)
    80201cc0:	f5843503          	ld	a0,-168(s0)
    80201cc4:	dccff0ef          	jal	80201290 <puts_wo_nl>
    80201cc8:	00050793          	mv	a5,a0
    80201ccc:	fec42703          	lw	a4,-20(s0)
    80201cd0:	00f707bb          	addw	a5,a4,a5
    80201cd4:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201cd8:	f8040023          	sb	zero,-128(s0)
    80201cdc:	1040006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
    80201ce0:	f5043783          	ld	a5,-176(s0)
    80201ce4:	0007c783          	lbu	a5,0(a5)
    80201ce8:	00078713          	mv	a4,a5
    80201cec:	06300793          	li	a5,99
    80201cf0:	02f71e63          	bne	a4,a5,80201d2c <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
    80201cf4:	f4843783          	ld	a5,-184(s0)
    80201cf8:	00878713          	addi	a4,a5,8
    80201cfc:	f4e43423          	sd	a4,-184(s0)
    80201d00:	0007a783          	lw	a5,0(a5)
    80201d04:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
    80201d08:	fcc42703          	lw	a4,-52(s0)
    80201d0c:	f5843783          	ld	a5,-168(s0)
    80201d10:	00070513          	mv	a0,a4
    80201d14:	000780e7          	jalr	a5
                ++written;
    80201d18:	fec42783          	lw	a5,-20(s0)
    80201d1c:	0017879b          	addiw	a5,a5,1
    80201d20:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201d24:	f8040023          	sb	zero,-128(s0)
    80201d28:	0b80006f          	j	80201de0 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
    80201d2c:	f5043783          	ld	a5,-176(s0)
    80201d30:	0007c783          	lbu	a5,0(a5)
    80201d34:	00078713          	mv	a4,a5
    80201d38:	02500793          	li	a5,37
    80201d3c:	02f71263          	bne	a4,a5,80201d60 <vprintfmt+0x740>
                putch('%');
    80201d40:	f5843783          	ld	a5,-168(s0)
    80201d44:	02500513          	li	a0,37
    80201d48:	000780e7          	jalr	a5
                ++written;
    80201d4c:	fec42783          	lw	a5,-20(s0)
    80201d50:	0017879b          	addiw	a5,a5,1
    80201d54:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201d58:	f8040023          	sb	zero,-128(s0)
    80201d5c:	0840006f          	j	80201de0 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
    80201d60:	f5043783          	ld	a5,-176(s0)
    80201d64:	0007c783          	lbu	a5,0(a5)
    80201d68:	0007871b          	sext.w	a4,a5
    80201d6c:	f5843783          	ld	a5,-168(s0)
    80201d70:	00070513          	mv	a0,a4
    80201d74:	000780e7          	jalr	a5
                ++written;
    80201d78:	fec42783          	lw	a5,-20(s0)
    80201d7c:	0017879b          	addiw	a5,a5,1
    80201d80:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201d84:	f8040023          	sb	zero,-128(s0)
    80201d88:	0580006f          	j	80201de0 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
    80201d8c:	f5043783          	ld	a5,-176(s0)
    80201d90:	0007c783          	lbu	a5,0(a5)
    80201d94:	00078713          	mv	a4,a5
    80201d98:	02500793          	li	a5,37
    80201d9c:	02f71063          	bne	a4,a5,80201dbc <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
    80201da0:	f8043023          	sd	zero,-128(s0)
    80201da4:	f8043423          	sd	zero,-120(s0)
    80201da8:	00100793          	li	a5,1
    80201dac:	f8f40023          	sb	a5,-128(s0)
    80201db0:	fff00793          	li	a5,-1
    80201db4:	f8f42623          	sw	a5,-116(s0)
    80201db8:	0280006f          	j	80201de0 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
    80201dbc:	f5043783          	ld	a5,-176(s0)
    80201dc0:	0007c783          	lbu	a5,0(a5)
    80201dc4:	0007871b          	sext.w	a4,a5
    80201dc8:	f5843783          	ld	a5,-168(s0)
    80201dcc:	00070513          	mv	a0,a4
    80201dd0:	000780e7          	jalr	a5
            ++written;
    80201dd4:	fec42783          	lw	a5,-20(s0)
    80201dd8:	0017879b          	addiw	a5,a5,1
    80201ddc:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
    80201de0:	f5043783          	ld	a5,-176(s0)
    80201de4:	00178793          	addi	a5,a5,1
    80201de8:	f4f43823          	sd	a5,-176(s0)
    80201dec:	f5043783          	ld	a5,-176(s0)
    80201df0:	0007c783          	lbu	a5,0(a5)
    80201df4:	84079ce3          	bnez	a5,8020164c <vprintfmt+0x2c>
        }
    }

    return written;
    80201df8:	fec42783          	lw	a5,-20(s0)
}
    80201dfc:	00078513          	mv	a0,a5
    80201e00:	0b813083          	ld	ra,184(sp)
    80201e04:	0b013403          	ld	s0,176(sp)
    80201e08:	0c010113          	addi	sp,sp,192
    80201e0c:	00008067          	ret

0000000080201e10 <printk>:

int printk(const char* s, ...) {
    80201e10:	f9010113          	addi	sp,sp,-112
    80201e14:	02113423          	sd	ra,40(sp)
    80201e18:	02813023          	sd	s0,32(sp)
    80201e1c:	03010413          	addi	s0,sp,48
    80201e20:	fca43c23          	sd	a0,-40(s0)
    80201e24:	00b43423          	sd	a1,8(s0)
    80201e28:	00c43823          	sd	a2,16(s0)
    80201e2c:	00d43c23          	sd	a3,24(s0)
    80201e30:	02e43023          	sd	a4,32(s0)
    80201e34:	02f43423          	sd	a5,40(s0)
    80201e38:	03043823          	sd	a6,48(s0)
    80201e3c:	03143c23          	sd	a7,56(s0)
    int res = 0;
    80201e40:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    80201e44:	04040793          	addi	a5,s0,64
    80201e48:	fcf43823          	sd	a5,-48(s0)
    80201e4c:	fd043783          	ld	a5,-48(s0)
    80201e50:	fc878793          	addi	a5,a5,-56
    80201e54:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    80201e58:	fe043783          	ld	a5,-32(s0)
    80201e5c:	00078613          	mv	a2,a5
    80201e60:	fd843583          	ld	a1,-40(s0)
    80201e64:	fffff517          	auipc	a0,0xfffff
    80201e68:	11850513          	addi	a0,a0,280 # 80200f7c <putc>
    80201e6c:	fb4ff0ef          	jal	80201620 <vprintfmt>
    80201e70:	00050793          	mv	a5,a0
    80201e74:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    80201e78:	fec42783          	lw	a5,-20(s0)
}
    80201e7c:	00078513          	mv	a0,a5
    80201e80:	02813083          	ld	ra,40(sp)
    80201e84:	02013403          	ld	s0,32(sp)
    80201e88:	07010113          	addi	sp,sp,112
    80201e8c:	00008067          	ret

0000000080201e90 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
    80201e90:	fe010113          	addi	sp,sp,-32
    80201e94:	00813c23          	sd	s0,24(sp)
    80201e98:	02010413          	addi	s0,sp,32
    80201e9c:	00050793          	mv	a5,a0
    80201ea0:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
    80201ea4:	fec42783          	lw	a5,-20(s0)
    80201ea8:	fff7879b          	addiw	a5,a5,-1
    80201eac:	0007879b          	sext.w	a5,a5
    80201eb0:	02079713          	slli	a4,a5,0x20
    80201eb4:	02075713          	srli	a4,a4,0x20
    80201eb8:	00003797          	auipc	a5,0x3
    80201ebc:	26078793          	addi	a5,a5,608 # 80205118 <seed>
    80201ec0:	00e7b023          	sd	a4,0(a5)
}
    80201ec4:	00000013          	nop
    80201ec8:	01813403          	ld	s0,24(sp)
    80201ecc:	02010113          	addi	sp,sp,32
    80201ed0:	00008067          	ret

0000000080201ed4 <rand>:

int rand(void) {
    80201ed4:	ff010113          	addi	sp,sp,-16
    80201ed8:	00813423          	sd	s0,8(sp)
    80201edc:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
    80201ee0:	00003797          	auipc	a5,0x3
    80201ee4:	23878793          	addi	a5,a5,568 # 80205118 <seed>
    80201ee8:	0007b703          	ld	a4,0(a5)
    80201eec:	00000797          	auipc	a5,0x0
    80201ef0:	4d478793          	addi	a5,a5,1236 # 802023c0 <lowerxdigits.0+0x18>
    80201ef4:	0007b783          	ld	a5,0(a5)
    80201ef8:	02f707b3          	mul	a5,a4,a5
    80201efc:	00178713          	addi	a4,a5,1
    80201f00:	00003797          	auipc	a5,0x3
    80201f04:	21878793          	addi	a5,a5,536 # 80205118 <seed>
    80201f08:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
    80201f0c:	00003797          	auipc	a5,0x3
    80201f10:	20c78793          	addi	a5,a5,524 # 80205118 <seed>
    80201f14:	0007b783          	ld	a5,0(a5)
    80201f18:	0217d793          	srli	a5,a5,0x21
    80201f1c:	0007879b          	sext.w	a5,a5
}
    80201f20:	00078513          	mv	a0,a5
    80201f24:	00813403          	ld	s0,8(sp)
    80201f28:	01010113          	addi	sp,sp,16
    80201f2c:	00008067          	ret

0000000080201f30 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
    80201f30:	fc010113          	addi	sp,sp,-64
    80201f34:	02813c23          	sd	s0,56(sp)
    80201f38:	04010413          	addi	s0,sp,64
    80201f3c:	fca43c23          	sd	a0,-40(s0)
    80201f40:	00058793          	mv	a5,a1
    80201f44:	fcc43423          	sd	a2,-56(s0)
    80201f48:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
    80201f4c:	fd843783          	ld	a5,-40(s0)
    80201f50:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
    80201f54:	fe043423          	sd	zero,-24(s0)
    80201f58:	0280006f          	j	80201f80 <memset+0x50>
        s[i] = c;
    80201f5c:	fe043703          	ld	a4,-32(s0)
    80201f60:	fe843783          	ld	a5,-24(s0)
    80201f64:	00f707b3          	add	a5,a4,a5
    80201f68:	fd442703          	lw	a4,-44(s0)
    80201f6c:	0ff77713          	zext.b	a4,a4
    80201f70:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
    80201f74:	fe843783          	ld	a5,-24(s0)
    80201f78:	00178793          	addi	a5,a5,1
    80201f7c:	fef43423          	sd	a5,-24(s0)
    80201f80:	fe843703          	ld	a4,-24(s0)
    80201f84:	fc843783          	ld	a5,-56(s0)
    80201f88:	fcf76ae3          	bltu	a4,a5,80201f5c <memset+0x2c>
    }
    return dest;
    80201f8c:	fd843783          	ld	a5,-40(s0)
}
    80201f90:	00078513          	mv	a0,a5
    80201f94:	03813403          	ld	s0,56(sp)
    80201f98:	04010113          	addi	sp,sp,64
    80201f9c:	00008067          	ret
