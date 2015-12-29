_KeyProc:
.Count=Byte
	PHA
	LDY #$00
	LDA (zFuncAddr),Y
	TAY
	STY .Count
	PLA
.Next	CMP (zFuncAddr),Y
	BEQ .L1
	DEY
	BNE .Next
	SEC
	RTS
.L1	DEY
	TYA
	ASL
	CLC
	ADC .Count
	TAY
	INY
	LWWY StaPtr,zFuncAddr
	JSR .Call
	CLC
	RTS
.Call	JMP (StaPtr)

_BU:
	LDA #-1
	BNE _UPOffset
_LU:
	LDA NumPerLine
	EOR #$FF
	CLC
	ADC #$01
	BNE _UPOffset
_PU:
	LDA NumPerLine
	CMP #CHRNUMPERLINE/2
	BEQ .L2
	LDA #-CHRNUMPERLINE*LINECOUNT
	BNE _UPOffset
.L2:
	LDA #-CHRNUMPERLINE/2*LINECOUNT
_UPOffset:
	CLC
	ADC zAddr
	STA zAddr
	BCS .L1
	DEC zAddr+1
.L1:
	RTS

_BU100:
	DEC zAddr+1
	RTS

_BankUP:
	LDA zAddr+1
	CMP #$C0
	BCS .L1
	DEC $00
	RTS
.L1:
	LDA $0A
	AND #$0F
	TAX
	CPX #$00
	BNE .L2
	LDX #$10
.L2:
	DEX
	LDA $0A
	AND #$F0
	STA $0A
	TXA
	ORA $0A
	STA $0A
	RTS

_BN:
	LDA #$01
	BNE _DNOffset
_LN:
	LDA NumPerLine
	BNE _DNOffset
_PN:
	LDA NumPerLine
	CMP #CHRNUMPERLINE/2
	BEQ .L2
	LDA #CHRNUMPERLINE*LINECOUNT
	BNE _DNOffset
.L2:
	LDA #CHRNUMPERLINE/2*LINECOUNT
_DNOffset:
	CLC
	ADC zAddr
	STA zAddr
	BCC .L1
	INC zAddr+1
.L1:
	RTS

_BN100:
	INC zAddr+1
	RTS

_BankDN:
	LDA zAddr+1
	CMP #$C0
	BCS .L1
	INC $00
	RTS
.L1:
	LDA $0A
	AND #$0F
	TAX
	CPX #$0F
	BNE .L2
	LDX #$FF
.L2:
	INX
	LDA $0A
	AND #$F0
	STA $0A
	TXA
	ORA $0A
	STA $0A
	RTS

_NDBU:
	LDA #-1
	BNE _NDUPOffset
_NDLU:
	LDA NumPerLine
	EOR #$FF
	CLC
	ADC #$01
	BNE _NDUPOffset
_NDPU:
	LDA #-CHRNUMPERLINE/2*LINECOUNT
	LDX NumPerLine
	CPX #CHRNUMPERLINE/2
	BEQ _NDUPOffset
	LDA #-CHRNUMPERLINE*LINECOUNT
_NDUPOffset:
	CLC
	ADC SectOffset
	STA SectOffset
	BCS .L1
	LDA SectOffset+1
	BEQ .L2
	DEC SectOffset+1
.L1:
	RTS
.L2:
	LDA #$3F
	STA SectOffset+1
	LDA SectSlot
	BNE .L3
	DEC SectSlot+1
.L3:
	DEC SectSlot
	RTS
_NDBU100:
	JSR _NDBU
	LDA #$01
	JMP _NDUPOffset
_NDSU:
	LDX SectSlot
	BNE .L1
	DEC SectSlot+1
.L1:
	DEX
	STX SectSlot
	RTS

_NDBN:
	LDA #$01
	BNE _NDDNOffset
_NDLN:
	LDA NumPerLine
	BNE _NDDNOffset
_NDPN:
	LDA #CHRNUMPERLINE/2*LINECOUNT
	LDX NumPerLine
	CPX #CHRNUMPERLINE/2
	BEQ _NDDNOffset
	LDA #CHRNUMPERLINE*LINECOUNT
_NDDNOffset:
	CLC
	ADC SectOffset
	STA SectOffset
	BCC .L1
	LDA SectOffset+1
	CMP #$3F
	BEQ .L2
	INC SectOffset+1
.L1:
	RTS
.L2:
	LDA #$00
	STA SectOffset+1
	INC SectSlot
	BNE .L3
	INC SectSlot+1
.L3:
	RTS
_NDBN100:
	JSR _NDBN
	LDA #$FF
	JMP _NDDNOffset
_NDSN:
	INC SectSlot
	BNE .L1
	INC SectSlot+1
.L1:
	RTS


_ShfCode:
	LB NumPerLine,#CHRNUMPERLINE
	BIT sCode
	BVS .ShfBIG
	BPL .ShfHEX
	LBX sCode,#CODE_GB
	RTS
.ShfBIG	LBX sCode,#CODE_BIG
	RTS
.ShfHEX	LBX sCode,#CODE_ASC
	LSR
	STA NumPerLine
	RTS

_ShfDatMode:
	LDA Flag
	BPL .ShfND
	LB Flag,#$00
	RTS
.ShfND	LB Flag,#$80
	RTS

_ShfFlash:
	LDA $0A
	BPL .L1
	AND #$7F
	STA $0A
	RTS
.L1	ORA #$80
	STA $0A
	RTS

_Shf0D:
	LDX $0D
	CPX #$54
	BCC .L1
	LDX #$4F
.L1	INX
	STX $0D
	RTS

_ShfDispMode:
	BIT Flag
	BVC .ShfDA
	JSR _ReAddr
	LB Flag,#$00
	RTS
.ShfDA  LB Flag,#$40
	RTS

_MainWin:
	BIT Flag
	BVC .L1
	JSR _ReAddr
.L1	LB Flag,#$00
	RTS

_ShowAbout:
	MemMove sTextBuf,.AboutMsg,#CPR*RPS
	LDX sCode
	LB sCode,#CODE_GB
	JSR _UpDateLCD
	JSR _WaitKey
	STX sCode
	RTS
.AboutMsg:
	.DB "        ¡¾AsmFun¡¿        "
	.DB "»· ¾³:TC1000              "
	.DB "°æ ±¾:",V1,V2,V3,V4,"                "
	.DB "±à Ð´:bpskong             "
	.DB "email:bps-kong@hotmail.com   "
	.DB "                          "

_EXIT:
	INT $0310

_Func:
	.DB .Tail-.Head
.Head:
	.DB KEY_UP,KEY_DN,KEY_LF,KEY_RT,KEY_PU,KEY_PD,KEY_P,KEY_ENTER,KEY_I,KEY_K
	.DB KEY_SHIFT,KEY_F1,KEY_F2,KEY_F3,KEY_F4
	.DB KEY_D,KEY_E,KEY_G,KEY_M,KEY_S,KEY_H,KEY_C,KEY_0;,KEY_N
	.DB KEY_HELP,KEY_Q,KEY_EXIT
.Tail:
	.DW _LU,_LN,_BU,_BN,_PU,_PN,_BU100,_BN100,_BankUP,_BankDN
	.DW _ShfCode,_ShfDatMode,_ShfFlash,_Shf0D,_ShfDispMode
	.DW _CmdD,_CmdE,_CmdG,_CmdM,_CmdS,_CmdH,_CmdC,_SearchNext;,_NDR
	.DW _ShowAbout,_EXIT,_MainWin

_NDFunc:
	.DB .Tail-.Head
.Head:
	.DB KEY_UP,KEY_DN,KEY_LF,KEY_RT,KEY_PU,KEY_PD,KEY_P,KEY_ENTER,KEY_I,KEY_K
	.DB KEY_SHIFT,KEY_F1,KEY_F4
	.DB KEY_D
	.DB KEY_HELP,KEY_Q,KEY_EXIT
.Tail:
	.DW _NDLU,_NDLN,_NDBU,_NDBN,_NDPU,_NDPN,_NDBU100,_NDBN100,_NDSU,_NDSN
	.DW _ShfCode,_ShfDatMode,_ShfDispMode
	.DW _CmdD
	.DW _ShowAbout,_EXIT,_MainWin

_DAFunc:
	.DB .Tail-.Head
.Head:
	.DB KEY_UP,KEY_DN,KEY_LF,KEY_RT,KEY_PU,KEY_PD,KEY_P,KEY_ENTER
	.DB KEY_F1,KEY_F4
	.DB KEY_D,KEY_G,KEY_M,KEY_J,KEY_R
	.DB KEY_HELP,KEY_Q,KEY_EXIT
.Tail:
	.DW _DALU,_DALN,_DABU,_DABN,_DAPU,_Noth,_DABU100,_DABN100
	.DW _ShfDatMode,_ShfDispMode
	.DW _CmdD,_CmdG,_CmdM,_GetNewAddr,_GetOldAddr
	.DW _ShowAbout,_EXIT,_MainWin
