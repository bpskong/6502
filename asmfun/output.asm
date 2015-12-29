_Cursor	.DB CPR*5,CPR*4,CPR*3,CPR*2,CPR*1,CPR*0

_UpDateLCD:
	PHXY
	LB sFontSize,#$01
	LB sBigFont,#$00
	INT _sUpdateLCD
	PLXY
	RTS

_ClrScr:
	PHXY
	INT _sClrScr
	PLXY
	RTS

_ClrTextBuf:
	PHXY
	INT _sClrTextBuf
	PLXY
	RTS

_PutDat:
	BIT Flag
	BMI .NDMode
	BVS .DAMode
	JSR _PutChrPage
	JMP _PutRDat
.NDMode	JMP _PutNdDatPage
.DAMode	JMP _DeAsmPage

_GetByte:
	PHXY
	BIT Flag
	BMI .NAND
	LDY #$00
	LDA (zAddr),Y
	STA Byte
	INW zAddr
	PLXY
	RTS
.NAND	sNDReadBytes SectSlot,SectOffset,#1,#Byte
	LDA #$01
	JSR _NDDNOffset
	PLXY
	RTS

_PutC:
	STA sTextBuf,X
	INX
	RTS

_PutHex:
	JSR _ToAsc
	JSR _PutC
	LDA zLo
	JSR _PutC
	RTS

_PutCLine:
	PHY
	LDY NumPerLine
.Next	JSR _GetByte
	PutC Byte
	DEY
	BNE .Next
	PLY
	RTS

_PutHexLine:
	PHY
	LDY NumPerLine
.Next	JSR _GetByte
	PutHex Byte
	DEY
	BNE .Next
	PLY
	RTS

_PutChrLine:
	BIT sCode
	BMI .HEX
	JMP _PutCLine
.HEX	JMP _PutHexLine

_PutChrPage:
	PHXY
	PHW zAddr
	LDY #LINECOUNT-1
.Line	LDX _Cursor,Y
	PutHex zAddr+1
	PutHex zAddr
	PutC #'-'
	JSR _PutChrLine
	DEY
	BPL .Line
	PLW zAddr
	PLXY
	RTS

_PutRDat:
.SHOW00_POS=sTextBuf+CPR*1+22
.SHOW0A_POS=sTextBuf+CPR*2+22
.SHOW0D_POS=sTextBuf+CPR*3+22
.SHOWCHRTYPE_POS=sTextBuf+CPR*4+22
	LB .SHOW00_POS+0,#'0'
	LB .SHOW00_POS+1,#':'
	LDA $00
	JSR _ToAsc
	STA .SHOW00_POS+2
	LB .SHOW00_POS+3,zLo
	LB .SHOW0A_POS+0,#'A'
	LB .SHOW0A_POS+1,#':'
	STA .SHOW0A_POS+1
	LDA $0A
	JSR _ToAsc
	STA .SHOW0A_POS+2
	LB .SHOW0A_POS+3,zLo
	LB .SHOW0D_POS+0,#'D'
	LB .SHOW0D_POS+1,#':'
	LDA $0D
	JSR _ToAsc
	STA .SHOW0D_POS+2
	LB .SHOW0D_POS+3,zLo
	BIT sCode
	BMI .HEX
	BVC .BIG
	LB .SHOWCHRTYPE_POS+0,#' '
	LB .SHOWCHRTYPE_POS+1,#'G'
	LB .SHOWCHRTYPE_POS+2,#'B'
	LB .SHOWCHRTYPE_POS+3,#' '
	RTS
.BIG	LB .SHOWCHRTYPE_POS+0,#'B'
	LB .SHOWCHRTYPE_POS+1,#'I'
	LB .SHOWCHRTYPE_POS+2,#'G'
	LB .SHOWCHRTYPE_POS+3,#'5'
	RTS
.HEX	LB .SHOWCHRTYPE_POS+0,#'H'
	LB .SHOWCHRTYPE_POS+1,#'E'
	LB .SHOWCHRTYPE_POS+2,#'X'
	LB .SHOWCHRTYPE_POS+3,#' '
	RTS

_PutNdDatPage
	PHXY
	PHW SectSlot,SectOffset
	LDY #LINECOUNT-1
.Line	LDX _Cursor,Y
	PutHex SectSlot+1
	PutHex SectSlot
	PutC #':'
	PutHex SectOffset+1
	PutHex SectOffset
	PutC #'-'
	JSR _PutChrLine
	DEY
	BPL .Line
	PLW SectOffset,SectSlot
	PLXY
	RTS
