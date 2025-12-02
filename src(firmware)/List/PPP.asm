
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.


;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x20,0x23,0x20,0x45,0x4E,0x54,0x45,0x52
	.DB  0x20,0x50,0x41,0x53,0x53,0x0,0x20,0x2A
	.DB  0x20,0x43,0x48,0x41,0x4E,0x47,0x45,0x20
	.DB  0x50,0x41,0x53,0x53,0x0,0x4F,0x50,0x45
	.DB  0x4E,0x0,0x43,0x4C,0x4F,0x53,0x45,0x0
	.DB  0x53,0x4F,0x52,0x52,0x59,0x0,0x52,0x45
	.DB  0x53,0x45,0x54,0x0,0x25,0x75,0x0,0x45
	.DB  0x4E,0x54,0x45,0x52,0x20,0x4F,0x4C,0x44
	.DB  0x20,0x50,0x41,0x53,0x53,0x0,0x45,0x4E
	.DB  0x54,0x45,0x52,0x20,0x4E,0x45,0x57,0x20
	.DB  0x50,0x41,0x53,0x53,0x0,0x4F,0x4B,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0E
	.DW  _0xA
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0xA+14
	.DW  _0x0*2+14

	.DW  0x05
	.DW  _0xA+29
	.DW  _0x0*2+29

	.DW  0x06
	.DW  _0xA+34
	.DW  _0x0*2+34

	.DW  0x06
	.DW  _0xA+40
	.DW  _0x0*2+40

	.DW  0x06
	.DW  _0xA+46
	.DW  _0x0*2+46

	.DW  0x0F
	.DW  _0x29
	.DW  _0x0*2+55

	.DW  0x0F
	.DW  _0x29+15
	.DW  _0x0*2+70

	.DW  0x03
	.DW  _0x29+30
	.DW  _0x0*2+85

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <lcd.h>
;#include <stdio.h>
;
;#asm
   .equ __lcd_port=0x1B ;PORTA
; 0000 0008 #endasm
;
;#define KEYPAD_PORT PORTC
;#define KEYPAD_PIN PINC
;#define KEYPAD_DDR DDRC
;#define OUTPUT_PORT PORTD
;#define OUTPUT_DDR DDRD
;#define RESET_PIN PINB
;
;
;eeprom  int pass ,j;
;unsigned char key[10];
;
;unsigned char keypad();
;void change_pass();
;int enter_pass();
;
;void main(void)
; 0000 001A {

	.CSEG
_main:
; .FSTART _main
; 0000 001B   char Temp;
; 0000 001C   lcd_init(16);
;	Temp -> R17
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 001D   OUTPUT_DDR=0b10000000;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 001E   DDRB.0 =0;
	CBI  0x17,0
; 0000 001F   PORTB.0 =1;
	SBI  0x18,0
; 0000 0020 
; 0000 0021     while (1)
_0x7:
; 0000 0022     {
; 0000 0023        lcd_puts(" # ENTER PASS");
	__POINTW2MN _0xA,0
	CALL _lcd_puts
; 0000 0024        lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0025        lcd_puts(" * CHANGE PASS");
	__POINTW2MN _0xA,14
	CALL _lcd_puts
; 0000 0026        lcd_putchar(j);
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	CALL __EEPROMRDB
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 0027        Temp=keypad();
	RCALL _keypad
	MOV  R17,R30
; 0000 0028        delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0029 
; 0000 002A        if(Temp=='#' && j>0)
	CPI  R17,35
	BRNE _0xC
	CALL SUBOPT_0x0
	CALL __CPW01
	BRLT _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 002B        {
; 0000 002C        if(enter_pass()== pass)
	CALL SUBOPT_0x1
	BRNE _0xE
; 0000 002D         {
; 0000 002E         lcd_clear();
	CALL _lcd_clear
; 0000 002F          lcd_puts("OPEN");
	__POINTW2MN _0xA,29
	CALL _lcd_puts
; 0000 0030           OUTPUT_PORT =128;
	LDI  R30,LOW(128)
	OUT  0x12,R30
; 0000 0031            delay_ms(500);
	CALL SUBOPT_0x2
; 0000 0032             lcd_clear();
; 0000 0033             OUTPUT_PORT =0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0034             j=3;
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x46
; 0000 0035           }
; 0000 0036        else
_0xE:
; 0000 0037         {
; 0000 0038         lcd_clear();
	CALL _lcd_clear
; 0000 0039          lcd_puts("CLOSE");
	__POINTW2MN _0xA,34
	CALL _lcd_puts
; 0000 003A           delay_ms(500);
	CALL SUBOPT_0x2
; 0000 003B            lcd_clear();
; 0000 003C            j--;
	CALL SUBOPT_0x0
	SBIW R30,1
_0x46:
	CALL __EEPROMWRW
; 0000 003D          }
; 0000 003E        }
; 0000 003F 
; 0000 0040        else if(Temp=='*' && j>0)
	RJMP _0x10
_0xB:
	CPI  R17,42
	BRNE _0x12
	CALL SUBOPT_0x0
	CALL __CPW01
	BRLT _0x13
_0x12:
	RJMP _0x11
_0x13:
; 0000 0041        change_pass();
	RCALL _change_pass
; 0000 0042 
; 0000 0043        if(j<=0)
_0x11:
_0x10:
	CALL SUBOPT_0x0
	CALL __CPW01
	BRLT _0x14
; 0000 0044        {
; 0000 0045        lcd_clear();
	CALL _lcd_clear
; 0000 0046        lcd_puts("SORRY");
	__POINTW2MN _0xA,40
	CALL _lcd_puts
; 0000 0047        while(1)
_0x15:
; 0000 0048         {
; 0000 0049         if(RESET_PIN==0)
	IN   R30,0x16
	CPI  R30,0
	BRNE _0x18
; 0000 004A          {
; 0000 004B           lcd_clear();
	CALL _lcd_clear
; 0000 004C           lcd_puts("RESET");
	__POINTW2MN _0xA,46
	CALL _lcd_puts
; 0000 004D           pass=1234;
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	LDI  R30,LOW(1234)
	LDI  R31,HIGH(1234)
	CALL __EEPROMWRW
; 0000 004E           j=3;
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EEPROMWRW
; 0000 004F           delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0050           lcd_clear();
	CALL _lcd_clear
; 0000 0051           break;
	RJMP _0x17
; 0000 0052            }
; 0000 0053           }
_0x18:
	RJMP _0x15
_0x17:
; 0000 0054          }
; 0000 0055       }
_0x14:
	RJMP _0x7
; 0000 0056  }
_0x19:
	RJMP _0x19
; .FEND

	.DSEG
_0xA:
	.BYTE 0x34
;
;
;int enter_pass()
; 0000 005A {

	.CSEG
_enter_pass:
; .FSTART _enter_pass
; 0000 005B  int n=0 ,i=0 ,num;
; 0000 005C  lcd_clear();
	CALL __SAVELOCR6
;	n -> R16,R17
;	i -> R18,R19
;	num -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	CALL _lcd_clear
; 0000 005D 
; 0000 005E  while(i<=8) {
_0x1A:
	__CPWRN 18,19,9
	BRLT PC+2
	RJMP _0x1C
; 0000 005F 
; 0000 0060    key[i]=keypad();
	MOVW R30,R18
	SUBI R30,LOW(-_key)
	SBCI R31,HIGH(-_key)
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0061 
; 0000 0062     if(key[i]=='#' && i>3)
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x23)
	BRNE _0x1E
	__CPWRN 18,19,4
	BRGE _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 0063       {
; 0000 0064        sscanf(key,"%u",&num);
	LDI  R30,LOW(_key)
	LDI  R31,HIGH(_key)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,52
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	CALL __PUTPARD1L
	PUSH R21
	PUSH R20
	LDI  R24,4
	CALL _sscanf
	ADIW R28,8
	POP  R20
	POP  R21
; 0000 0065        return num;
	MOVW R30,R20
	RJMP _0x20C0005
; 0000 0066         }
; 0000 0067       else if (key[i] =='*')
_0x1D:
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x2A)
	BRNE _0x21
; 0000 0068         {
; 0000 0069            i--;
	__SUBWRN 18,19,1
; 0000 006A            lcd_clear();
	CALL _lcd_clear
; 0000 006B            for(n=0;n<i;n++)lcd_putchar(key[n]);
	__GETWRN 16,17,0
_0x23:
	__CPWRR 16,17,18,19
	BRGE _0x24
	LDI  R26,LOW(_key)
	LDI  R27,HIGH(_key)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CALL _lcd_putchar
	__ADDWRN 16,17,1
	RJMP _0x23
_0x24:
; 0000 006C }
; 0000 006D         else if (i<8 && key[i]!='#')
	RJMP _0x25
_0x21:
	__CPWRN 18,19,8
	BRGE _0x27
	CALL SUBOPT_0x3
	CPI  R26,LOW(0x23)
	BRNE _0x28
_0x27:
	RJMP _0x26
_0x28:
; 0000 006E           {
; 0000 006F            lcd_putchar(key[i]);
	CALL SUBOPT_0x3
	CALL _lcd_putchar
; 0000 0070            i++;
	__ADDWRN 18,19,1
; 0000 0071             }
; 0000 0072     delay_ms(250);
_0x26:
_0x25:
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 0073    }
	RJMP _0x1A
_0x1C:
; 0000 0074 }
_0x20C0005:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;
;void change_pass()
; 0000 0078 {
_change_pass:
; .FSTART _change_pass
; 0000 0079  lcd_clear();
	CALL _lcd_clear
; 0000 007A  lcd_puts("ENTER OLD PASS");
	__POINTW2MN _0x29,0
	CALL SUBOPT_0x4
; 0000 007B  delay_ms(500);
; 0000 007C 
; 0000 007D  while(j!=0)
_0x2A:
	CALL SUBOPT_0x0
	SBIW R30,0
	BREQ _0x2C
; 0000 007E   {
; 0000 007F    if(enter_pass()==pass)
	CALL SUBOPT_0x1
	BRNE _0x2D
; 0000 0080     {
; 0000 0081      lcd_clear();
	CALL _lcd_clear
; 0000 0082       lcd_puts("ENTER NEW PASS");
	__POINTW2MN _0x29,15
	CALL SUBOPT_0x4
; 0000 0083        delay_ms(500);
; 0000 0084      pass = enter_pass();
	RCALL _enter_pass
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	CALL __EEPROMWRW
; 0000 0085      lcd_clear();
	CALL _lcd_clear
; 0000 0086       lcd_puts("OK");
	__POINTW2MN _0x29,30
	CALL SUBOPT_0x4
; 0000 0087        delay_ms(500);
; 0000 0088         return;
	RET
; 0000 0089        }
; 0000 008A    else j--;
_0x2D:
	CALL SUBOPT_0x0
	SBIW R30,1
	CALL __EEPROMWRW
; 0000 008B     }
	RJMP _0x2A
_0x2C:
; 0000 008C }
	RET
; .FEND

	.DSEG
_0x29:
	.BYTE 0x21
;
;
;char keypad()
; 0000 0090 {

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 0091  unsigned char scanCode=0xf0 ,butNum;
; 0000 0092 
; 0000 0093    while(scanCode==0xf0)
	ST   -Y,R17
	ST   -Y,R16
;	scanCode -> R17
;	butNum -> R16
	LDI  R17,240
_0x2F:
	CPI  R17,240
	BRNE _0x31
; 0000 0094    {
; 0000 0095     KEYPAD_DDR = 0x0f;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 0096     KEYPAD_PORT = 0xf0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0097     delay_us(5);
	__DELAY_USB 13
; 0000 0098     scanCode= KEYPAD_PIN;
	IN   R17,19
; 0000 0099       }
	RJMP _0x2F
_0x31:
; 0000 009A     KEYPAD_DDR = 0xf0;
	LDI  R30,LOW(240)
	OUT  0x14,R30
; 0000 009B     KEYPAD_PORT = 0x0f;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 009C     delay_us(5);
	__DELAY_USB 13
; 0000 009D     scanCode |= KEYPAD_PIN;
	IN   R30,0x13
	OR   R17,R30
; 0000 009E 
; 0000 009F 
; 0000 00A0           switch (scanCode)
	MOV  R30,R17
	LDI  R31,0
; 0000 00A1           {
; 0000 00A2            case 0xee: butNum='1'; break;
	CPI  R30,LOW(0xEE)
	LDI  R26,HIGH(0xEE)
	CPC  R31,R26
	BRNE _0x35
	LDI  R16,LOW(49)
	RJMP _0x34
; 0000 00A3            case 0xed: butNum='2'; break;
_0x35:
	CPI  R30,LOW(0xED)
	LDI  R26,HIGH(0xED)
	CPC  R31,R26
	BRNE _0x36
	LDI  R16,LOW(50)
	RJMP _0x34
; 0000 00A4            case 0xeb: butNum='3'; break;
_0x36:
	CPI  R30,LOW(0xEB)
	LDI  R26,HIGH(0xEB)
	CPC  R31,R26
	BRNE _0x37
	LDI  R16,LOW(51)
	RJMP _0x34
; 0000 00A5            case 0xe7: butNum=0; break;
_0x37:
	CPI  R30,LOW(0xE7)
	LDI  R26,HIGH(0xE7)
	CPC  R31,R26
	BRNE _0x38
	LDI  R16,LOW(0)
	RJMP _0x34
; 0000 00A6            case 0xde: butNum='4'; break;
_0x38:
	CPI  R30,LOW(0xDE)
	LDI  R26,HIGH(0xDE)
	CPC  R31,R26
	BRNE _0x39
	LDI  R16,LOW(52)
	RJMP _0x34
; 0000 00A7            case 0xdd: butNum='5'; break;
_0x39:
	CPI  R30,LOW(0xDD)
	LDI  R26,HIGH(0xDD)
	CPC  R31,R26
	BRNE _0x3A
	LDI  R16,LOW(53)
	RJMP _0x34
; 0000 00A8            case 0xdb: butNum='6'; break;
_0x3A:
	CPI  R30,LOW(0xDB)
	LDI  R26,HIGH(0xDB)
	CPC  R31,R26
	BRNE _0x3B
	LDI  R16,LOW(54)
	RJMP _0x34
; 0000 00A9            case 0xd7: butNum=0; break;
_0x3B:
	CPI  R30,LOW(0xD7)
	LDI  R26,HIGH(0xD7)
	CPC  R31,R26
	BRNE _0x3C
	LDI  R16,LOW(0)
	RJMP _0x34
; 0000 00AA            case 0xbe: butNum='7'; break;
_0x3C:
	CPI  R30,LOW(0xBE)
	LDI  R26,HIGH(0xBE)
	CPC  R31,R26
	BRNE _0x3D
	LDI  R16,LOW(55)
	RJMP _0x34
; 0000 00AB            case 0xbd: butNum='8'; break;
_0x3D:
	CPI  R30,LOW(0xBD)
	LDI  R26,HIGH(0xBD)
	CPC  R31,R26
	BRNE _0x3E
	LDI  R16,LOW(56)
	RJMP _0x34
; 0000 00AC            case 0xbb: butNum='9'; break;
_0x3E:
	CPI  R30,LOW(0xBB)
	LDI  R26,HIGH(0xBB)
	CPC  R31,R26
	BRNE _0x3F
	LDI  R16,LOW(57)
	RJMP _0x34
; 0000 00AD            case 0xb7: butNum=0; break;
_0x3F:
	CPI  R30,LOW(0xB7)
	LDI  R26,HIGH(0xB7)
	CPC  R31,R26
	BRNE _0x40
	LDI  R16,LOW(0)
	RJMP _0x34
; 0000 00AE            case 0x7e: butNum='*'; break;
_0x40:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x41
	LDI  R16,LOW(42)
	RJMP _0x34
; 0000 00AF            case 0x7d: butNum='0'; break;
_0x41:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x42
	LDI  R16,LOW(48)
	RJMP _0x34
; 0000 00B0            case 0x7b: butNum='#'; break;
_0x42:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x43
	LDI  R16,LOW(35)
	RJMP _0x34
; 0000 00B1            case 0x77: butNum=0; break;
_0x43:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x45
	LDI  R16,LOW(0)
	RJMP _0x34
; 0000 00B2            default: butNum='_';
_0x45:
	LDI  R16,LOW(95)
; 0000 00B3             };
_0x34:
; 0000 00B4 
; 0000 00B5 
; 0000 00B6      return butNum;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00B7 }
; .FEND
;
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0004
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R5,R7
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R4
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R4
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R5
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0004
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	CALL SUBOPT_0x6
	LDI  R26,LOW(4)
	CALL SUBOPT_0x6
	LDI  R26,LOW(133)
	CALL SUBOPT_0x6
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x200000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0004:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_get_buff_G101:
; .FSTART _get_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20200C1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20200C2
_0x20200C1:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x20200C3
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	LDD  R27,Z+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20200C4
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20200C4:
	RJMP _0x20200C5
_0x20200C3:
	LDI  R17,LOW(0)
_0x20200C5:
_0x20200C2:
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
__scanf_G101:
; .FSTART __scanf_G101
	PUSH R15
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R20,R30
_0x20200C6:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200C8
	CALL SUBOPT_0x7
	BREQ _0x20200C9
_0x20200CA:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20200CD
	CALL SUBOPT_0x7
	BRNE _0x20200CE
_0x20200CD:
	RJMP _0x20200CC
_0x20200CE:
	CALL SUBOPT_0x9
	BRGE _0x20200CF
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200CF:
	RJMP _0x20200CA
_0x20200CC:
	MOV  R20,R19
	RJMP _0x20200D0
_0x20200C9:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x20200D1
	LDI  R21,LOW(0)
_0x20200D2:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LPM  R19,Z+
	STD  Y+16,R30
	STD  Y+16+1,R31
	CPI  R19,48
	BRLO _0x20200D6
	CPI  R19,58
	BRLO _0x20200D5
_0x20200D6:
	RJMP _0x20200D4
_0x20200D5:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x20200D2
_0x20200D4:
	CPI  R19,0
	BRNE _0x20200D8
	RJMP _0x20200C8
_0x20200D8:
_0x20200D9:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R18,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x20200DB
	CALL SUBOPT_0x9
	BRGE _0x20200DC
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200DC:
	RJMP _0x20200D9
_0x20200DB:
	CPI  R18,0
	BRNE _0x20200DD
	RJMP _0x20200DE
_0x20200DD:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x20200DF
	LDI  R21,LOW(255)
_0x20200DF:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x20200E3
	CALL SUBOPT_0xA
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOVW R26,R16
	ST   X,R30
	CALL SUBOPT_0x9
	BRGE _0x20200E4
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200E4:
	RJMP _0x20200E2
_0x20200E3:
	CPI  R30,LOW(0x73)
	BRNE _0x20200ED
	CALL SUBOPT_0xA
_0x20200E6:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20200E8
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20200EA
	CALL SUBOPT_0x7
	BREQ _0x20200E9
_0x20200EA:
	CALL SUBOPT_0x9
	BRGE _0x20200EC
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200EC:
	RJMP _0x20200E8
_0x20200E9:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x20200E6
_0x20200E8:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x20200E2
_0x20200ED:
	SET
	BLD  R15,1
	CLT
	BLD  R15,2
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20200F2
	CPI  R30,LOW(0x69)
	BRNE _0x20200F3
_0x20200F2:
	CLT
	BLD  R15,1
	RJMP _0x20200F4
_0x20200F3:
	CPI  R30,LOW(0x75)
	BRNE _0x20200F5
_0x20200F4:
	LDI  R18,LOW(10)
	RJMP _0x20200F0
_0x20200F5:
	CPI  R30,LOW(0x78)
	BRNE _0x20200F6
	LDI  R18,LOW(16)
	RJMP _0x20200F0
_0x20200F6:
	CPI  R30,LOW(0x25)
	BRNE _0x20200F9
	RJMP _0x20200F8
_0x20200F9:
	RJMP _0x20C0003
_0x20200F0:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	SET
	BLD  R15,0
_0x20200FA:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20200FC
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20200FD
	CALL SUBOPT_0x9
	BRGE _0x20200FE
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x20200FE:
	RJMP _0x20200FF
_0x20200FD:
	SBRC R15,1
	RJMP _0x2020100
	SET
	BLD  R15,1
	CPI  R19,45
	BRNE _0x2020101
	BLD  R15,2
	RJMP _0x20200FA
_0x2020101:
	CPI  R19,43
	BREQ _0x20200FA
_0x2020100:
	CPI  R18,16
	BRNE _0x2020103
	MOV  R26,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x20200FF
	RJMP _0x2020105
_0x2020103:
	MOV  R26,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x2020106
_0x20200FF:
	SBRC R15,0
	RJMP _0x2020108
	MOV  R20,R19
	RJMP _0x20200FC
_0x2020106:
_0x2020105:
	CPI  R19,97
	BRLO _0x2020109
	SUBI R19,LOW(87)
	RJMP _0x202010A
_0x2020109:
	CPI  R19,65
	BRLO _0x202010B
	SUBI R19,LOW(55)
	RJMP _0x202010C
_0x202010B:
	SUBI R19,LOW(48)
_0x202010C:
_0x202010A:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	CLT
	BLD  R15,0
	RJMP _0x20200FA
_0x20200FC:
	CALL SUBOPT_0xA
	SBRS R15,2
	RJMP _0x202010D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202010D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x20200E2:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x202010E
_0x20200D1:
_0x20200F8:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x8
	POP  R20
	CP   R30,R19
	BREQ _0x202010F
	CALL SUBOPT_0x9
	BRGE _0x2020110
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2020110:
_0x20200DE:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x2020111
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2020111:
	RJMP _0x20200C8
_0x202010F:
_0x202010E:
_0x20200D0:
	RJMP _0x20200C6
_0x20200C8:
_0x2020108:
_0x20C0003:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x20C0002:
	CALL __LOADLOCR6
	ADIW R28,18
	POP  R15
	RET
; .FEND
_sscanf:
; .FSTART _sscanf
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0xB
	SBIW R30,0
	BRNE _0x2020112
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2020112:
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xB
	STD  Y+3,R30
	STD  Y+3+1,R31
	MOVW R26,R28
	ADIW R26,5
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_get_buff_G101)
	LDI  R31,HIGH(_get_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __scanf_G101
_0x20C0001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	POP  R15
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND
_isxdigit:
; .FSTART _isxdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.ESEG
_pass:
	.BYTE 0x2
_j:
	.BYTE 0x2

	.DSEG
_key:
	.BYTE 0xA
__base_y_G100:
	.BYTE 0x4
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_j)
	LDI  R27,HIGH(_j)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	CALL _enter_pass
	MOVW R0,R30
	LDI  R26,LOW(_pass)
	LDI  R27,HIGH(_pass)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_key)
	LDI  R27,HIGH(_key)
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	CALL _lcd_puts
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	CALL __long_delay_G100
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOVW R26,R28
	ADIW R26,7
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTPARD1L:
	LDI  R22,0
	LDI  R23,0
__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
