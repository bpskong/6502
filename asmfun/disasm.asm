	zALLOC	2,zCodPtr
	zALLOC	2,zInsStrPtr
	ALLOC	1,LineID
	ALLOC	1,BackAddrID
	ALLOC	1,InsStrPos
	ALLOC	255,ByteNumStack
	ALLOC	255,BackAddr

_DeAsm:
	INX
	JSR _GetByte
	PutHex Byte
	PHX
	LDX #-3
.GetCodInfor:
	CPX #_CodInforTail-_CodInfor-3
	BNE .DefineIns
	PLX
	JSR _CursorMove7
	LDA #'?'
	JSR _PutC
	JSR _PutC
	JSR _PutC
	LDA #$01
	RTS
.DefineIns:
	INX
	INX
	INX
	LDY _CodInfor,X
	LDA _CodInfor+1,X
	STA zCodPtr
	LDA _CodInfor+2,X
	STA zCodPtr+1
	LDA Byte
.CheckNext:
	DEY
	BMI .GetCodInfor
	CMP (zCodPtr),Y
	BNE .CheckNext
	TYA
	ASL
	STA InsStrPos
	CLC
	TYA
	ADC InsStrPos
	STA InsStrPos
	TXA
	TAY
	PLX
	LDA _InsInfor,Y
	STA zInsStrPtr
	LDA _InsInfor+1,Y
	STA zInsStrPtr+1

	CPY #$00
	BNE .Not1ByteIns
	JSR _CursorMove7
	JSR _PutInsStr
	LDA #$01
	RTS
.Not1ByteIns:
	INX
	JSR _GetByte
	PutHex Byte
	CPY #24
	BCS .Not2ByteIns
	JSR _CursorMove4
	JSR _PutPrefix
	CPY #12
	BEQ .PutJudgerIns
	BCC .2PrefixSym
	DEX
.2PrefixSym:
	PutHex Byte
	JSR _PutSuffix
	LDA #$02
	RTS
.PutJudgerIns:
	DEX
	LDY zAddr+1
	LDA Byte
	BMI .L2
	CLC
	LDA Byte
	ADC zAddr
	BCC .L3
	INY
	JMP .L3
.L2:
	CLC
	LDA Byte
	ADC zAddr
	BCS .L3
	DEY
.L3:
	PHA
	TYA
	JSR _PutHex
	PLA
	JSR _PutHex
	LDA #$02
	RTS
.Not2ByteIns:
	INX
	LDA Byte
	PHA
	JSR _GetByte
	PutHex Byte
	INX
	JSR _PutPrefix
	CPY #33
	BCS .is2PrefixSym
	DEX
.is2PrefixSym
	PutHex Byte
	PLA
	JSR _PutHex
	JSR _PutSuffix
	LDA #$03
	RTS

_PutInsStr:
	TYA
	PHA
	LDY InsStrPos
	LDA (zInsStrPtr),Y
	JSR _PutC
	INY
	LDA (zInsStrPtr),Y
	JSR _PutC
	INY
	LDA (zInsStrPtr),Y
	JSR _PutC
	PLA
	TAY
	RTS

_PutPrefix:
	JSR _PutInsStr
	INX
	LDA _PrefixSym,Y
	JSR _PutC
	LDA _PrefixSym+1,Y
	JSR _PutC
	RTS

_PutSuffix:
	LDA _SuffixSym,Y
	JSR _PutC
	LDA _SuffixSym+1,Y
	JSR _PutC
	LDA _SuffixSym+2,Y
	JSR _PutC
	RTS

_CursorMove7:
	XINC #7
	RTS

_CursorMove4:
	XINC #4
	RTS

_DeAsmLine:
.ByteNumPerLine=Tmp
	PHY
	JSR _DeAsm
	STA .ByteNumPerLine
	PLY
	LDA .ByteNumPerLine
	RTS

_DeAsmPage:
	PHXY
	LDY #LINECOUNT-1
.NextLine:
	LDX _Cursor,Y
	PutHex zAddr+1
	PutHex zAddr
	PutC #'-'
	JSR _DeAsmLine
	JSR _Record
	DEY
	BPL .NextLine
	PLXY
	RTS

_GetNewAddr:
	LDY #$00
.Juage:
	LDA sTextBuf+6,Y
	CMP #'0'
	BNE .NotINT
	LDA sTextBuf+7,Y
	CMP #'0'
	BEQ .I
.NotINT:
	LDA sTextBuf+15,Y
	CMP #'J'
	BNE .Offset
	LDA sTextBuf+19,Y
	CMP #'('
	BNE .J
.Offset:
	YINC #CPR
	CPY #CPR*RPS
	BCC .Juage
.NoNewAddr:
	LDY #$06
	JSR _Backwark
	RTS
.SaveAndGet:
	TYA
	TAX
	JSR _BufStrToHex16
	LDX BackAddrID
	CPX #$FF
	BEQ .NoNewAddr
	STA BackAddr+1,X
	LDA zLo
	STA BackAddr,X
	INX
	INX
	LDA $00
	STA BackAddr,X
	INX
	LDA $0A
	STA BackAddr,X
	INX
	STX BackAddrID
	TYA
	CLC
	ADC #20
	TAX
	JSR _BufStrToHex16
	RTS

.J:
	JSR .SaveAndGet
	STA zAddr+1
	LDA zLo
	STA zAddr
	RTS
.I:
	JSR .SaveAndGet
	CMP #$C0
	PHP
	STA $00
	AND #$0F
	ORA #$10
	STA $0A
	LDA zLo
	ASL
	STA zAddr
	LDA #$40
	PLP
	BCC .L1
	LDA #$C0
.L1:
	STA zAddr+1
	JSR _GetByte
	LDA Byte
	PHA
	JSR _GetByte
	LDA Byte
	STA zAddr+1
	PLA
	STA zAddr
	RTS

_GetOldAddr:
	LDX BackAddrID
	BNE .NotTop
	LDY #$06
	JSR _Backwark
	RTS
.NotTop:
	LDA BackAddr-1,X
	STA $0A
	LDA BackAddr-2,X
	STA $00
	DEX
	DEX
	LDA BackAddr-1,X
	STA zAddr+1
	LDA BackAddr-2,X
	STA zAddr
	DEX
	DEX
	STX BackAddrID
	RTS

_Record:
	PHA
	LDA LineID
	LSR
	LSR
	TAX
	PLA
	LSR
	ROR ByteNumStack,X
	LSR
	ROR ByteNumStack,X
	INC LineID
	RTS

_Backwark:
	PHX
.L2:
	DEC LineID
	LDA LineID
	LSR
	LSR
	TAX
	LDA #$00
	ASL ByteNumStack,X
	ROL
	ASL ByteNumStack,X
	ROL
	STA Tmp
	SEC
	LDA zAddr
	SBC Tmp
	STA zAddr
	BCS .L1
	DEC zAddr+1
.L1
	DEY
	BNE .L2
	PLX
	RTS

_ReAddr:
	LDY #6
	JMP _Backwark

_DABU:
	JSR _ReAddr
	JMP _BU

_DABN:
	JSR _ReAddr
	JMP _BN

_DALU:
	LDY #7
	JMP _Backwark

_DALN:
	LDY #5
	JMP _Backwark

_DAPU:
	LDY #12
	JMP _Backwark

_DABU100:
	JSR _ReAddr
	JMP _BU100

_DABN100:
	JSR _ReAddr
	JMP _BN100

_Noth:
	RTS

_SingleIns:
	.DB "PHP"
	.DB "PLP"
	.DB "PHA"
	.DB "PLA"
	.DB "DEY"
	.DB "TAY"
	.DB "INY"
	.DB "INX"

	.DB "CLC"
	.DB "SEC"
	.DB "CLI"
	.DB "SEI"
	.DB "TYA"
	.DB "CLV"
	.DB "CLD"
	.DB "SED"

	.DB "ASL"
	.DB "ROL"
	.DB "LSR"
	.DB "ROR"
	.DB "TXA"
	.DB "TAX"
	.DB "DEX"
	.DB "NOP"

	.DB "TXS"
	.DB "TSX"

	.DB "RTI"
	.DB "RTS"

_JudgerIns:
	.DB "BPL"
	.DB "BMI"
	.DB "BVC"
	.DB "BVS"
	.DB "BCC"
	.DB "BCS"
	.DB "BNE"
	.DB "BEQ"

_ZeroPageYIns:
	.DB "STX"
	.DB "LDX"

_OtherIns:
	.DB "JMP"

	.DB "ORA"
	.DB "AND"
	.DB "EOR"
	.DB "ADC"
	.DB "STA"
	.DB "LDA"
	.DB "CMP"
	.DB "SBC"

	.DB "ASL"
	.DB "ROL"
	.DB "LSR"
	.DB "ROR"
	.DB "STX"
	.DB "LDX"
	.DB "DEC"
	.DB "INC"

	.DB "LDY"
	.DB "STY"
	.DB "CPY"
	.DB "CPX"
	.DB "BIT"
	.DB "LDX"

	.DB "INT"
	.DB "JSR"

_Single:
	.DB $08
	.DB $28
	.DB $48
	.DB $68
	.DB $88
	.DB $A8
	.DB $C8
	.DB $E8

	.DB $18
	.DB $38
	.DB $58
	.DB $78
	.DB $98
	.DB $B8
	.DB $D8
	.DB $F8

	.DB $0A
	.DB $2A
	.DB $4A
	.DB $6A
	.DB $8A
	.DB $AA
	.DB $CA
	.DB $EA

	.DB $9A
	.DB $BA

	.DB $40
	.DB $60
_SingleTail:

;3
;-------------------------($**,X)---------------------
_IndirectX:
	.DB $01

	.DB $01
	.DB $21
	.DB $41
	.DB $61
	.DB $81
	.DB $A1
	.DB $C1
	.DB $E1
_IndirectXTail:
;6
;-------------------------($**),Y---------------------
_IndirectY:
	.DB $11

	.DB $11
	.DB $31
	.DB $51
	.DB $71
	.DB $91
	.DB $B1
	.DB $D1
	.DB $F1
_IndirectYTail:
;9
;-------------------------#$**---------------------
_Immediate:
	.DB $09

	.DB $09
	.DB $29
	.DB $49
	.DB $69
	.DB $A9
	.DB $A9
	.DB $C9
	.DB $E9

	.DB $A0
	.DB $A0
	.DB $A0
	.DB $A0
	.DB $A0
	.DB $A0
	.DB $A0
	.DB $A0

	.DB $A0
	.DB $C0
	.DB $C0
	.DB $E0
	.DB $A2
	.DB $A2
_ImmediateTail:
;12
;-------------------------$****---------------------
_Judger:
	.DB $10
	.DB $30
	.DB $50
	.DB $70
	.DB $90
	.DB $B0
	.DB $D0
	.DB $F0
_JudgerTail:
;15
;-------------------------$**---------------------
_ZeroPage:
	.DB $05

	.DB $05
	.DB $25
	.DB $45
	.DB $65
	.DB $85
	.DB $A5
	.DB $C5
	.DB $E5

	.DB $06
	.DB $26
	.DB $46
	.DB $66
	.DB $86
	.DB $A6
	.DB $C6
	.DB $E6

	.DB $A4
	.DB $84
	.DB $C4
	.DB $E4
	.DB $24
_ZeroPageTail:
;18
;-------------------------$**,X---------------------
_ZeroPageX:
	.DB $15

	.DB $15
	.DB $35
	.DB $55
	.DB $75
	.DB $95
	.DB $B5
	.DB $D5
	.DB $F5

	.DB $16
	.DB $36
	.DB $56
	.DB $76
	.DB $D6
	.DB $D6
	.DB $D6
	.DB $F6

	.DB $B4
	.DB $94
_ZeroPageXTail:
;21
;-------------------------$**,Y---------------------
_ZeroPageY:
	.DB $96
	.DB $B6
_ZeroPageYTail:


;24
;-------------------------$****---------------------
_Absolute:
	.DB $4C

	.DB $0D
	.DB $2D
	.DB $4D
	.DB $6D
	.DB $8D
	.DB $AD
	.DB $CD
	.DB $ED

	.DB $0E
	.DB $2E
	.DB $4E
	.DB $6E
	.DB $8E
	.DB $AE
	.DB $CE
	.DB $EE

	.DB $AC
	.DB $8C
	.DB $CC
	.DB $EC
	.DB $2C
	.DB $00
	.DB $00
	.DB $20
_AbsoluteTail:
;27
;-------------------------$****,X---------------------
_AbsoluteX:
	.DB $1D

	.DB $1D
	.DB $3D
	.DB $5D
	.DB $7D
	.DB $9D
	.DB $BD
	.DB $DD
	.DB $FD

	.DB $1E
	.DB $3E
	.DB $5E
	.DB $7E
	.DB $DE
	.DB $DE
	.DB $DE
	.DB $FE

	.DB $BC
_AbsoluteXTail:
;30
;-------------------------$****,Y---------------------
_AbsoluteY:
	.DB $19

	.DB $19
	.DB $39
	.DB $59
	.DB $79
	.DB $99
	.DB $B9
	.DB $D9
	.DB $F9

	.DB $BE
	.DB $BE
	.DB $BE
	.DB $BE
	.DB $BE
	.DB $BE
_AbsoluteYTail:
;33
;-------------------------($****)---------------------
_Indirect:
	.DB $6C
_IndirectTail:


_CodInfor:
	.DB _SingleTail-_Single
	.DW _Single

	.DB _IndirectXTail-_IndirectX
	.DW _IndirectX
	.DB _IndirectYTail-_IndirectY
	.DW _IndirectY
	.DB _ImmediateTail-_Immediate
	.DW _Immediate
	.DB _JudgerTail-_Judger
	.DW _Judger
	.DB _ZeroPageTail-_ZeroPage
	.DW _ZeroPage
	.DB _ZeroPageXTail-_ZeroPageX
	.DW _ZeroPageX
	.DB _ZeroPageYTail-_ZeroPageY
	.DW _ZeroPageY

	.DB _AbsoluteTail-_Absolute
	.DW _Absolute
	.DB _AbsoluteXTail-_AbsoluteX
	.DW _AbsoluteX
	.DB _AbsoluteYTail-_AbsoluteY
	.DW _AbsoluteY
	.DB _IndirectTail-_Indirect
	.DW _Indirect
_CodInforTail:

_InsInfor:
	.DW _SingleIns
	.DB $00

	.DW _OtherIns
	.DB $00
	.DW _OtherIns
	.DB $00
	.DW _OtherIns
	.DB $00
	.DW _JudgerIns
	.DB $00
	.DW _OtherIns
	.DB $00
	.DW _OtherIns
	.DB $00
	.DW _ZeroPageYIns
	.DB $00

	.DW _OtherIns
	.DB $00
	.DW _OtherIns
	.DB $00
	.DW _OtherIns
	.DB $00
	.DW _OtherIns
	.DB $00
_PrefixSym:
	.DB "   "
	.DB "($ "
	.DB "($ "
	.DB "#$ "
	.DB "$  "
	.DB "$  "
	.DB "$  "
	.DB "$  "

	.DB "$  "
	.DB "$  "
	.DB "$  "
	.DB "($ "
_SuffixSym:
	.DB "   "
	.DB ",X)"
	.DB "),Y"
	.DB "   "
	.DB "   "
	.DB "   "
	.DB ",X "
	.DB ",Y "

	.DB "   "
	.DB ",X "
	.DB ",Y "
	.DB ")  "