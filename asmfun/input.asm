_KeyLst	.DB KEY_0,KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7
	.DB KEY_8,KEY_9,KEY_A,KEY_DOT,KEY_C,KEY_D,KEY_E,KEY_F
_KeyASC	.DB "0123456789ABCDEF"
KEYCOUNT=_KeyASC-_KeyLst

LoadHex16.MACRO
	LDX ?2
	JSR _BufStrToHex16
	STA ?1+1
	LDA zLo
	STA ?1
	.ENDM

_WaitKey:
	LB sKey,#0
.Loop	LB sNoidleAddr,#0
	LDA sKey
	BPL .Loop
	AND #$7F
	STA sKey
	RTS

KEYIN_LINE_IDX=5
KEYIN_OFFSET=CPR*KEYIN_LINE_IDX+5
KEYIN_BUF_HEAD=sTextBuf+KEYIN_OFFSET
KEYIN_BUF_LEN=16

_KeyInHex:
	FillChar KEYIN_BUF_HEAD,#KEYIN_BUF_LEN,#0
	JSR _UpDateLCD
	LDX #$00
.Wait	JSR _WaitKey
	CMP #KEY_EXIT
	BNE .NE
	CLC
	RTS
.NE	CMP #KEY_LF
	BNE .NL
	CPX #$00
	BEQ .Wait
	DEX
	LDA #' '
	STA KEYIN_BUF_HEAD,X
	JSR _UpDateLCD
	JMP .Wait
.NL	CMP #KEY_BLANK
	BNE .NB
	SEC
	RTS
.NB	LDY #KEYCOUNT
.Next	DEY
	BMI .Wait
	CMP _KeyLst,Y
	BNE .Next
	CPX #KEYIN_BUF_LEN
	BEQ .Wait
	LDA _KeyASC,Y
	STA KEYIN_BUF_HEAD,X
	INX
	JSR _UpDateLCD
	JMP .Wait

_PutCmdSym:
.Buf=sTextBuf+CPR*KEYIN_LINE_IDX
	PHA
	FillChar .Buf,#CPR,#0
	LB .Buf,#'-'
	PLB  .Buf+1
	JSR _UpDateLCD
	RTS

_GetAddr:
	JSR _KeyInHex
	BCS .NE
	RTS
.NE	CPX #$02
	BNE .NZP
	LDX #KEYIN_OFFSET
	JSR _BufStrToHex8
	STA zAddr
	LDA #$00
	STA zAddr+1
	SEC
	RTS
.NZP	CPX #$04
	BNE .WBNO
	LoadHex16 zAddr,#KEYIN_OFFSET
	SEC
	RTS
.WBNO	CPX #$06
	BNE _GetAddr
	LoadHex16 zAddr,#KEYIN_OFFSET
	LDX #KEYIN_OFFSET+4
	JSR _BufStrToHex8
	LDX zAddr+1
	CPX #$C0
	BCC .L1
	AND #$0F
	TAX
	LDA $0A
	AND #$F0
	STA $0A
	TXA
	ORA $0A
	STA $0A
	SEC
	RTS
.L1	STA $00
	SEC
	RTS

_CmdD:
	PutCmdSym #'D'
	BIT Flag
	BMI .NAND
	JSR _GetAddr
	RTS
.NAND	JSR _KeyInHex
	BCS .NE
	RTS
.NE	CPX #$04
	BNE .WO
	LoadHex16 SectSlot,#KEYIN_OFFSET
	SEC
	RTS
.WO	CPX #$08
	BNE .NAND
	LoadHex16 SectSlot,#KEYIN_OFFSET
	LDX #KEYIN_OFFSET+4
	JSR _BufStrToHex16
	AND #$3F
	STA SectOffset+1
	LDA zLo
	STA SectOffset
	SEC
	RTS


_CmdG:
	PHB $00,zAddr,zAddr+1
	PutCmdSym #'G'
	JSR _GetAddr
	BCC .EXIT
	JSR .CALL
.EXIT	PLB zAddr+1,zAddr,$00
	RTS
.CALL	JMP (zAddr)


_CmdE:

.FIRST_POS=5
.LAST_POS=CPR*RPS-6
.LINETAIL_ID=CHRNUMPERLINE-1

.PassNum=__BASE
	PutCmdSym #'E'
	JSR _GetAddr
	BCS .NotEnd
	RTS
.NotEnd	JSR _PutDat
	LBY .PassNum,#$00
	LDX #.FIRST_POS
.DisPlay
	JSR .SetFocus
	JSR _UpDateLCD
	JSR _WaitKey
	CMP #KEY_EXIT
	BNE .NotEXIT
	RTS
.NotEXIT:
	CMP #KEY_LF
	BNE .NotLF
	CPY #$00
	BEQ .LineHead
	DEY
	DEX
	JMP .DisPlay
.LineHead:
	LDY #.LINETAIL_ID
	CPX #.FIRST_POS
	BEQ .FirstByte
	XDEC #$0B
	BSBB  .PassNum,#CHRNUMPERLINE/2
	JMP .DisPlay
.FirstByte:
	LDX #.LAST_POS
	LB .PassNum,#CHRNUMPERLINE/2*5
	JSR _PU
	JSR _PutDat
	JMP .DisPlay
.NotLF:
	CMP #KEY_RT
	BNE .NotRT
.Offset:
	CPY #.LINETAIL_ID
	BEQ .LineTail
	INY
	INX
	JMP .DisPlay
.LineTail:
	LDY #$00
	CPX #.LAST_POS
	BEQ .LastByte
	XINC #$0B
	BADB  .PassNum,#CHRNUMPERLINE/2
	JMP .DisPlay
.LastByte:
	LDX #.FIRST_POS
	LDA #$00
	STA .PassNum
	JSR _PN
	JSR _PutDat
	JMP .DisPlay
.NotRT:
	CMP #KEY_UP
	BNE .NotUP
	CPX #CPR
	BCC .PageTop
	XDEC #CPR
	BSBB  .PassNum,#CHRNUMPERLINE/2
	JMP .DisPlay
.PageTop:
	JSR _LU
	JSR _PutDat
	JMP .DisPlay
.NotUP:
	CMP #KEY_DN
	BNE .NotDN
	CPX #CPR*5
	BCS .PageBottom
	XINC #CPR
	BADB  .PassNum,#CHRNUMPERLINE/2
	JMP .DisPlay
.PageBottom:
	JSR _LN
	JSR _PutDat
	JMP .DisPlay
.NotDN:
	CMP #KEY_PU
	BNE .NotPAGEUP
	JSR _PU
	JSR _PutDat
	JMP .DisPlay
.NotPAGEUP:
	CMP #KEY_PD
	BNE .NotPAGEDN
	JSR _PN
	JSR _PutDat
	JMP .DisPlay
.NotPAGEDN:
	STY Tmp
	LDY #KEYCOUNT
.Next:
	DEY
	BMI .Goto_DisPlay
	CMP _KeyLst,Y
	BNE .Next
	LDA _KeyASC,Y
	STA sTextBuf,X
	LDA Tmp
	LSR
	CLC
	ADC .PassNum
	TAY
	TXA
	PHA
	AND #$01
	BNE .EditData
	DEX
.EditData:
	LDA sTextBuf+1,X
	STA zLo
	LDA sTextBuf,X
	JSR _ToHex
	STA Byte
	STA (zAddr),Y
	PLA
	TAX
	LDY Tmp
	JMP .Offset
.Goto_DisPlay:
	LDY Tmp
	JMP .DisPlay

.SetFocus:
	PHXY
	JSR .ClrFocus
	TXA
	AND #$07
	TAY
	LDA #$80
	CPY #$00
	BEQ .L1
.Next	LSR
	DEY
	BNE .Next
.L1	TAY
	TXA
	LSR
	LSR
	LSR
	TAX
	TYA
	STA sChrAttr,X
	PLXY
	RTS
.ClrFocus:
.CONVERTBUF_LEN=14
	FillChar sChrAttr,#.CONVERTBUF_LEN,#0
	RTS

_CmdM:
	PutCmdSym #'M'
	JSR _KeyInHex
	BCS .NotEXIT
	RTS
.NotEXIT:
	CPX #$10
	BNE _CmdM
	LoadHex16 zSrcHeadPtr,#KEYIN_OFFSET
	LoadHex16 zSrcTailPtr,#KEYIN_OFFSET+4
	LoadHex16 zDstHeadPtr,#KEYIN_OFFSET+4+4
	LDX #KEYIN_OFFSET+4+4+4
	JSR _BufStrToHex8
	STA SrcBank
	LDX #KEYIN_OFFSET+4+4+4+2
	JSR _BufStrToHex8
	STA DstBank

	LW zAddr,zDstHeadPtr

.MoveNext:
	CPW zSrcHeadPtr,zSrcTailPtr
	BNE .L1
	RTS
.L1:
	LDY #$00
	LB $00,SrcBank
	LDA (zSrcHeadPtr),Y
	PHA
	LB $00,DstBank
	PLA
	STA (zDstHeadPtr),Y
	INW zSrcHeadPtr
	INW zDstHeadPtr
	JMP .MoveNext

_CmdS:
	PutCmdSym #'S'
	JSR _KeyInHex
	BCS .NotEXIT
	RTS
.NotEXIT:
	CPX #12
	BNE _CmdS
	LoadHex16 zFindSrcHead,#KEYIN_OFFSET
	LoadHex16 zFindSrcTail,#KEYIN_OFFSET+4
	LDX #KEYIN_OFFSET+4+4
	JSR _BufStrToHex8
	STA BankHead
	LDX #KEYIN_OFFSET+4+4+2
	JSR _BufStrToHex8
	STA BankTail
	RTS

_CmdH:
	PutCmdSym #'H'
	JSR _KeyInHex
	BCS .NotEXIT
	RTS
.NotEXIT:
	TXA
	AND #$01
	BNE _CmdH
	TXA
	LSR
	STA AimDatLen
	LDX #KEYIN_OFFSET
	LDY #$00
.Next:
	JSR _BufStrToHex8
	STA AimHome,Y
	INX
	INX
	INY
	CPY #KEYIN_BUF_LEN/2
	BNE .Next
	JSR _Search
	RTS

_CmdC:
	PHB sCode
	LB sCode,#CODE_GB
	LB sBigFont,#1
	JSR .InputC
	CMP #KEY_EXIT
	BEQ .Exit
	LDX #$FF
.Next:
	INX
	LDA sTextBuf,X
	BNE .Next
	CPX #21
	BCC .L
	LDX #20
.L:
	TXA
	BEQ .Exit
	STA AimDatLen
	MemMove AimHome,sTextBuf,AimDatLen
	JSR _Search
.Exit:
	LB sBigFont,#0
	PLB sCode
	RTS

.InputC:
	sInput #$20,#0,#0,#20,"输入要查找的字符!"
	RTS

;05.4.20
_Search:
	LW zSrcHeadPtr,zFindSrcHead
	LW zDstHeadPtr,#AimHome
	LB SrcBank,BankHead

_SearchNext:
	LB Tmp,$00
	LB Byte,$0A
	LB $00,SrcBank
	AND #$0F
	ORA #$10
	STA $0A
	JSR _ClrTextBuf
	StrCpy sTextBuf+CPR*2+4,.SearchingStr
	LDX sCode
	LB sCode,#CODE_GB
	JSR _UpDateLCD
	STX sCode
.BEGIN:
	LDY AimDatLen
.NEXT:
	LDA $C3
	AND $80
	BEQ .NotFound
	DEY
	CPY #$FF
	BNE .GO
	LB SrcBank,$00
	LW zAddr,zSrcHeadPtr
	INW zSrcHeadPtr
	CLC
	RTS
.GO:
	LDA (zSrcHeadPtr),Y
	CMP (zDstHeadPtr),Y
	BEQ .NEXT
	CPW zSrcHeadPtr,zFindSrcTail
	BEQ .L1
	INW zSrcHeadPtr
	JMP .BEGIN
.L1:
	CPB $00,BankTail
	BEQ .NotFound
	INC $00
	LDA $0A
	AND #$0F
	TAX
	CPX #$0F
	BNE .L2
	LDX #$FF
.L2:
	INX
	TXA
	ORA #$10
	STA $0A
	LW zSrcHeadPtr,zFindSrcHead
	LB sNoidleAddr,#0
	JMP .BEGIN
.NotFound:
	LB SrcBank,$00
	LB $00,Tmp
	LB $0A,Byte
	JSR _ClrTextBuf
	StrCpy sTextBuf+CPR*2+4,.NotFoundStr
	LDX sCode
	LB sCode,#CODE_GB
	JSR _UpDateLCD
	STX sCode
	JSR _WaitKey
	SEC
	RTS
.SearchingStr:
	.DB "你要我找，我就找...",0
.NotFoundStr:
	.DB "找不到不是我的错^_^",0
