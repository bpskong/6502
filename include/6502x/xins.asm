JCC	.MACRO
	BCS .L
	JMP ?1
.L
	.ENDM

JCS	.MACRO
	BCC .L
	JMP ?1
.L
	.ENDM

JEQ	.MACRO
	BNE .L
	JMP ?1
.L
	.ENDM

JNE	.MACRO
	BEQ .L
	JMP ?1
.L
	.ENDM

JMI	.MACRO
	BPL .L
	JMP ?1
.L
	.ENDM

JPL	.MACRO
	BMI .L
	JMP ?1
.L
	.ENDM

JVC	.MACRO
	BVS .L
	JMP ?1
.L
	.ENDM

JVS	.MACRO
	BVC .L
	JMP ?1
.L
	.ENDM

;ASL X times
;eg:
;XASL 5
XASL    .MACRO
	.REPT ?1
	ASL
	.ENDR
	.ENDM

;LSR X times
;eg:
;XLSR 5
XLSR    .MACRO
	.REPT ?1
	LSR
	.ENDR
	.ENDM

;X -> Stack
;eg:
;PHX
;...
;PLX
PHX	.MACRO
	TXA
	PHA
	.ENDM

;Stack -> X
;eg:
;PHX
;...
;PLX
PLX	.MACRO
	PLA
	TAX
	.ENDM

;X -> Stack
;eg:
;PHY
;...
;PLY
PHY	.MACRO
	TYA
	PHA
	.ENDM

;Stack -> Y
;eg:
;PHY
;...
;PLY
PLY	.MACRO
	PLA
	TAY
	.ENDM

;X,Y -> Stack
;eg:
;PHXY
;...
;PLXY
PHXY	.MACRO
	TXA
	PHA
	TYA
	PHA
	.ENDM

;Stack -> X,Y
;eg:
;PHXY
;...
;PLXY
PLXY	.MACRO
	PLA
	TAY
	PLA
	TAX
	.ENDM

;index X INC n times
;eg:
;XINC #$02
;XINC $40
XINC	.MACRO
	.IF "#"!=??1 1 1
	TXA
	CLC
	ADC ?1
	TAX
	.ENDIF
	.IF "#"==??1 1 1
	.IF [??1 2 0]<5
	.REPT [??1 2 0]
	INX
	.ENDR
	.ENDIF
	.IF [??1 2 0]>4
	TXA
	CLC
	ADC ?1
	TAX
	.ENDIF
	.ENDIF
	.ENDM

;index X DEC n times
;eg:
;XDEC #$02
;XDEC $40
XDEC	.MACRO
	.IF "#"!=??1 1 1
	TXA
	SEC
	SBC ?1
	TAX
	.ENDIF
	.IF "#"==??1 1 1
	.IF [??1 2 0]<5
	.REPT [??1 2 0]
	DEX
	.ENDR
	.ENDIF
	.IF [??1 2 0]>4
	TXA
	SEC
	SBC ?1
	TAX
	.ENDIF
	.ENDIF
	.ENDM

;index Y INC n times
;eg:
;YINC #$02
;YINC $40
YINC	.MACRO
	.IF "#"!=??1 1 1
	TYA
	CLC
	ADC ?1
	TAY
	.ENDIF
	.IF "#"==??1 1 1
	.IF [??1 2 0]<5
	.REPT [??1 2 0]
	INY
	.ENDR
	.ENDIF
	.IF [??1 2 0]>4
	TYA
	CLC
	ADC ?1
	TAY
	.ENDIF
	.ENDIF
	.ENDM

;index Y DEC n times
;eg:
;YDEC #$02
;YDEC $40
YDEC	.MACRO
	.IF "#"!=??1 1 1
	TYA
	SEC
	SBC ?1
	TAY
	.ENDIF
	.IF "#"==??1 1 1
	.IF [??1 2 0]<5
	.REPT [??1 2 0]
	DEY
	.ENDR
	.ENDIF
	.IF [??1 2 0]>4
	TYA
	SEC
	SBC ?1
	TAY
	.ENDIF
	.ENDIF
	.ENDM

;Word -> X,Y
;eg:
;LXY $2000
;LXY #$2000
LXY	.MACRO
	.IF "#"!=??1 1 1
	LDX ?1
	LDY ?1+1
	.ENDIF
	.IF "#"==??1 1 1
	LDX #<[??1 2 0]
	LDY #>[??1 2 0]
	.ENDIF
	.ENDM

;X,Y -> Word
;eg:
;SXY $2000
SXY	.MACRO
	STY ?1+1
	STX ?1
	.ENDM

;Byte -> Byte(Memory)
;"L":Load
;"B":Byte
;eg:
;LB $40,$20
;LB $40,$50[,...],$20
;LB $40,#$20
;LB $40,$50[,...],#$20
LB	.MACRO
	.IF ?0<2
	OP_NUM_ERROR
	.ENDIF
.cnt =  ?0
	LDA ?.cnt
	.REPT ?0-1
.cnt = .cnt - 1
	STA ?.cnt
	.ENDR
	.ENDM

;Byte -> Byte(Memory)
;"L":Load
;"BX":Byte use index X
;eg:
;LBX $40,$20
;LBX $40,$50[,...],$20
;LBX $40,#$20
;LBX $40,$50[,...],#$20
LBX	.MACRO
	.IF ?0<2
	OP_NUM_ERROR
	.ENDIF
.cnt =  ?0
	LDX ?.cnt
	.REPT ?0-1
.cnt = .cnt - 1
	STX ?.cnt
	.ENDR
	.ENDM

;Byte -> Byte(Memory)
;"L":Load
;"BY":Byte use index Y
;eg:
;LBY $40,$20
;LBY $40,$50[,...],$20
;LBY $40,#$20
;LBY $40,$50[,...],#$20
LBY	.MACRO
	.IF ?0<2
	OP_NUM_ERROR
	.ENDIF
.cnt =  ?0
	LDY ?.cnt
	.REPT ?0-1
.cnt = .cnt - 1
	STY ?.cnt
	.ENDR
	.ENDM

;Word -> Word(Memory)
;"L":Load
;"W":Word
;eg:
;LW $40,$2000
;LW $40,$50[,...],$2000
;LW $40,#$2000
;LW $40,$50[,...],#$2000
LW	.MACRO
	.IF ?0<2
	OP_NUM_ERROR
	.ENDIF
.cnt = ?0
	.IF "#"==??.cnt 1 1
	LDA #<[??.cnt 2 0]
	.REPT .cnt-1
.cnt = .cnt - 1
	STA ?.cnt
	.ENDR
.cnt = ?0
	LDA #>[??.cnt 2 0]
	.REPT .cnt-1
.cnt = .cnt - 1
	STA ?.cnt+1
	.ENDR
	.ENDIF
.cnt = ?0
	.IF "#"!=??.cnt 1 1
	LDA ?.cnt
	.REPT .cnt-1
.cnt = .cnt - 1
	STA ?.cnt
	.ENDR
.cnt = ?0
	LDA ?.cnt+1
	.REPT .cnt-1
.cnt = .cnt - 1
	STA ?.cnt+1
	.ENDR
	.ENDIF
	.ENDM

;Byte -> Word(Memory)
;"L":Load
;"W":Word(memory)
;"B":Byte
;eg:
;LWB $40,$20
;LWB $40,#$20 (==LW $40,#$20)
LWB	.MACRO
	LDA ?2
	STA ?1
	LDA #$00
	STA ?1+1
	.ENDM

;Byte(Memory),X -> Byte(Memory),X
;"L":Load
;"BX":Byte(memory) with index X
;"BX":Byte(memory) with index X
;eg:
;LBXBX $40,$20
LBXBX	.MACRO
	LDA ?2,X
	STA ?1,X
	.ENDM

;Byte(Memory),Y -> Byte(Memory),Y
;"L":Load
;"BY":Byte(memory) with index Y
;"BY":Byte(memory) with index Y
;eg:
;LBYBY $40,$20
LBYBY	.MACRO
	LDA (?2),Y
	STA (?1),Y
	.ENDM

;Word(Memory),X -> Word(Memory)
;"L":Load
;"W":Word(memory)
;"WX":Word(memory) with index X
;eg:
;LWWX $40,$20
LWWX	.MACRO
	LDA ?2,X
	STA ?1
	LDA ?2+1,X
	STA ?1+1
	.ENDM

;(Word(Memory)),Y -> Word(Memory)
;"L":Load
;"W":Word(memory)
;"WY":Word(memory) with index Y
;eg:
;LWWY $40,$20
LWWY	.MACRO
	LDA (?2),Y
	STA ?1
	INY
	LDA (?2),Y
	STA ?1+1
	.ENDM

;Word -> Word(Memory),X
;"L":Load
;"WX":Word(memory) with index X
;"W":Word
;eg:
;LWXW $40,$2000
;LWXW $40,#$2000
LWXW	.MACRO
	.IF "#"!=??2 1 1
	LDA ?2
	STA ?1,X
	LDA ?2+1
	STA ?1+1,X
	.ENDIF
	.IF "#"==??2 1 1
	LDA #<[??2 2 0]
	STA ?1,X
	LDA #>[??2 2 0]
	STA ?1+1,X
	.ENDIF
	.ENDM

;Word -> (Word(Memory)),Y
;"L":Load
;"WY":Word(memory) with index Y
;"W":Word
;eg:
;LWYW $40,$2000
;LWYW $40,#$2000
LWYW	.MACRO
	.IF "#"!=??2 1 1
	LDA ?2
	STA (?1),Y
	INY
	LDA ?2+1
	STA (?1),Y
	.ENDIF
	.IF "#"==??2 1 1
	LDA #<[??2 2 0]
	STA (?1),Y
	INY
	LDA #>[??2 2 0]
	STA (?1),Y
	.ENDIF
	.ENDM

;Byte -> Stack
;"PH":PusH
;"B":Byte
;eg:
;PH $40,$20[,...]
;PL $20,$40[,...]
PHB	.MACRO
	.IF ?0<1
	OP_NUM_ERROR
	.ENDIF
.cnt = 0
	.REPT ?0
.cnt = .cnt + 1
	LDA ?.cnt
	PHA
	.ENDR
	.ENDM

;Stack -> Byte(Memory)
;"PL":PulL
;"B":Byte(memory)
;eg:
;PH $40,$20[,...]
;PL $20,$40[,...]
PLB	.MACRO
	.IF ?0<1
	OP_NUM_ERROR
	.ENDIF
.cnt = 0
	.REPT ?0
.cnt = .cnt + 1
	PLA
	STA ?.cnt
	.ENDR
	.ENDM

;Word -> Stack
;"PH":PusH
;"W":Word
;eg:
;PH2 $40,$20[,...]
;PL2 $20,$40[,...]
PHW	.MACRO
	.IF ?0<1
	OP_NUM_ERROR
	.ENDIF
.cnt = 0
	.REPT ?0
.cnt = .cnt + 1
	LDA ?.cnt
	PHA
	LDA ?.cnt+1
	PHA
	.ENDR
	.ENDM

;Stack -> Word(Memory)
;"PL":PulL
;"W":Word(memory)
;eg:
;PH2 $40,$20[,...]
;PL2 $20,$40[,...]
PLW	.MACRO
	.IF ?0<1
	OP_NUM_ERROR
	.ENDIF
.cnt = 0
	.REPT ?0
.cnt = .cnt + 1
	PLA
	STA ?.cnt+1
	PLA
	STA ?.cnt
	.ENDR
	.ENDM

;Byte ORA Byte -> A
;"OR":ORa
;"B":Byte
;eg:
;OR $40,$20
;OR #$40,#$20
;OR $40,#$20
;OR #$40,$20
ORB	.MACRO
	LDA ?1
	ORA ?2
	.ENDM

;Byte CMP Byte
;"CP":ComPare
;"B":Byte
;eg:
;CPB $40,$20
;CPB #$40,#$20
;CPB $40,#$20
;CPB #$40,$20
CPB	.MACRO
	LDA ?1
	CMP ?2
	.ENDM

;Word CMP Word
;"CP":ComPare
;"W":Word
;eg:
;CPW $40,$2000
;CPW #$40,#$2000
;CPW $40,#$2000
;CPW #$40,$2000
CPW	.MACRO
	.IF "#"!=??1 1 1
	LDA ?1+1
	.ENDIF
	.IF "#"==??1 1 1
	LDA #>[??1 2 0]
	.ENDIF
	.IF "#"!=??2 1 1
	CMP ?2+1
	.ENDIF
	.IF "#"==??2 1 1
	CMP #>[??2 2 0]
	.ENDIF
	BNE .L
	.IF "#"!=??1 1 1
	LDA ?1
	.ENDIF
	.IF "#"==??1 1 1
	LDA #<[??1 2 0]
	.ENDIF
	.IF "#"!=??2 1 1
	CMP ?2
	.ENDIF
	.IF "#"==??2 1 1
	CMP #<[??2 2 0]
	.ENDIF
.L
	.ENDM

;Byte ADC Byte
;"B":Byte
;"AD":ADc
;"B":Byte
;eg:
;BADB $40,$20
;BADB $40,#$20
;BADB #$40,#$20,A
;BADB #$40,#$20,$50
BADB	.MACRO
	CLC
	LDA ?1
	ADC ?2
	.IF ?0<3
	STA ?1
	.ENDIF
	.IF ?0>2
	.IF "A"!=?3
	STA ?3
	.ENDIF
	.ENDIF
	.ENDM

;Byte SBC Byte
;"B":Byte
;"SB":SBc
;"B":Byte
;eg:
;BSBB $40,$20
;BSBB $40,#$20
;BSBB #$40,#$20,A
;BSBB #$40,#$20,$50
BSBB	.MACRO
	SEC
	LDA ?1
	SBC ?2
	.IF ?0<3
	STA ?1
	.ENDIF
	.IF ?0>2
	.IF "A"!=?3
	STA ?3
	.ENDIF
	.ENDIF
	.ENDM

;Word ADC Word
;"W":Word
;"AD":ADc
;"W":Word
;eg:
;WADW $40,$2000
;WADW $40,#$2000
;WADW $40,#$2000,$50
WADW	.MACRO
	CLC
	LDA ?1
	.IF "#"!=??2 1 1
	ADC ?2
	.ENDIF
	.IF "#"==??2 1 1
	ADC #<[??2 2 0]
	.ENDIF
	.IF ?0>2
	STA ?3
	.ENDIF
	.IF ?0<3
	STA ?1
	.ENDIF
	.IF "#"!=??2 1 1
	LDA ?1+1
	ADC ?2+1
	.IF ?0>2
	STA ?3+1
	.ENDIF
	.IF ?0<3
	STA ?1+1
	.ENDIF
	.ENDIF
	.IF "#"==??2 1 1
	.IF ?0>2
	LDA ?1+1
	ADC #>[??2 2 0]
	STA ?3+1
	.ENDIF
	.IF ?0<3
	.IF [??2 2 0]<256	;optimizing
	BCC .L
	INC ?1+1
.L
	.ENDIF
	.IF [??2 2 0]>255
	LDA ?1+1
	ADC #>[??2 2 0]
	STA ?1+1
	.ENDIF
	.ENDIF
	.ENDIF
	.ENDM

;Word SBC Word
;"W":Word
;"SB":SBc
;"W":Word
;eg:
;WSBW $40,$2000
;WSBW $40,#$2000
;WSBW $40,#$2000,$50
WSBW	.MACRO
	SEC
	LDA ?1
	.IF "#"!=??2 1 1
	SBC ?2
	.ENDIF
	.IF "#"==??2 1 1
	SBC #<[??2 2 0]
	.ENDIF
	.IF ?0>2
	STA ?3
	.ENDIF
	.IF ?0<3
	STA ?1
	.ENDIF
	.IF "#"!=??2 1 1
	LDA ?1+1
	SBC ?2+1
	.IF ?0>2
	STA ?3+1
	.ENDIF
	.IF ?0<3
	STA ?1+1
	.ENDIF
	.ENDIF
	.IF "#"==??2 1 1
	.IF ?0>2
	LDA ?1+1
	SBC #>[??2 2 0]
	STA ?3+1
	.ENDIF
	.IF ?0<3
	.IF [??2 2 0]<256	;optimizing
	BCS .L
	DEC ?1+1
.L
	.ENDIF
	.IF [??2 2 0]>255
	LDA ?1+1
	SBC #>[??2 2 0]
	STA ?1+1
	.ENDIF
	.ENDIF
	.ENDIF
	.ENDM

;Word ADC Byte
;"W":Word
;"AD":ADc
;"B":Byte
;eg:
;WADB $40,$20
;WADB $40,#$20 (==WADW $40,#$20)
WADB	.MACRO
	CLC
	LDA ?1
	ADC ?2
	STA ?1
	BCC .L
	INC ?1+1
.L
	.ENDM

;Word SBC Byte
;"W":Word
;"SB":SBc
;"B":Byte
;eg:
;WSBB $40,$20
;WSBB $40,#$20 (==WSBW $40,#$20)
WSBB	.MACRO
	SEC
	LDA ?1
	SBC ?2
	STA ?1
	BCS .L
	DEC ?1+1
.L
	.ENDM

;INC Word(Memory)
;"IN":INc
;"W":Word(memory)
;eg:
;INW $40
INW	.MACRO
	INC ?1
	BNE .L
	INC ?1+1
.L
	.ENDM
;DEC Word(Memory)
;"DE":DEc
;"W":Word(memory)
;eg:
;DEW $40
DEW	.MACRO
	LDA ?1
	BNE .L
	DEC ?1+1
.L	DEC ?1
	.ENDM

;Nonzero Page ALLOCcate Memory
;"ALLOC":ALLOCcate memory
;eg:
;ALLOC 2,int
ALLOC	.MACRO
?2 = __BASE
__BASE = __BASE + ?1
	.ENDM

;Zero Page ALLOCcate Memory
;"ZALLOC":Zero page ALLOCcate memory
;eg:
;ALLOC 2,int
ZALLOC  .MACRO
?2 = __zBASE
__zBASE = __zBASE + ?1
	.ENDM


;MemMoveX Dst,Src,Len
MemMoveX.MACRO
	LDX ?3
.Next:
	LDA [?2]-1,X
	STA [?1]-1,X
	DEX
	BNE .Next
	.ENDM

;MemMove Dst,Src,Len
MemMove	.MACRO
	PHX
	LDX ?3
.Next:
	LDA [?2]-1,X
	STA [?1]-1,X
	DEX
	BNE .Next
	PLX
	.ENDM

;FillChar Dst,Len,Val
FillCharX.MACRO
	LDX ?2
	LDA ?3
.NEXT:
	STA [?1]-1,X
	DEX
	BNE .NEXT
	.ENDM

;FillChar Dst,Len,Val
FillChar.MACRO
	PHX
	LDX ?2
	LDA ?3
.NEXT:
	STA [?1]-1,X
	DEX
	BNE .NEXT
	PLX
	.ENDM

;FillChar Dst,Src
;Return: index X = length of string
StrCpyX	.MACRO
	LDX #$00
.NEXT:
	LDA ?2,X
	STA ?1,X
	BEQ .L
	INX
	BNE .NEXT
.L:
	.ENDM

;FillChar Dst,Src
StrCpy	.MACRO
	PHX
	LDX #$00
.NEXT:
	LDA ?2,X
	STA ?1,X
	BEQ .L
	INX
	BNE .NEXT
.L:
	PLX
	.ENDM

__K_MEMCPY__=0
KMemCpy	.MACRO
	.IF __K_MEMCPY__==0
__zBASE = $40
	zALLOC  2,__k_zDstHeadPtr__
	zALLOC  2,__k_zSrcHeadPtr__
	zALLOC  2,__k_zSrcTailPtr__
	JMP .L
__K_MEMCPY__
	LDY #$00
	LBYBY __k_zDstHeadPtr__,__k_zSrcHeadPtr__
	CPW __k_zSrcHeadPtr__,__k_zSrcTailPtr__
	BNE .NEXT
	RTS
.NEXT	INW __k_zSrcHeadPtr__
	INW __k_zDstHeadPtr__
	JMP __K_MEMCPY__
	.ENDIF
.L	LW __k_zDstHeadPtr__,#?1
	LW __k_zSrcHeadPtr__,#?2
	.IF "#" != ??3 1 1
	LW __k_zSrcTailPtr__,#?3
	.ENDIF
	.IF "#" == ??3 1 1
	LW __k_zSrcTailPtr__,#?2+??3 2 0
	.ENDIF
	JSR __K_MEMCPY__
	.ENDM
