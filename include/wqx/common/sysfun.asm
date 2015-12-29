sGetDot .MACRO;X,Y
	LB sX,?1
	LB sY,?2
	LB sColor,?3
	INT _sGetDot
	.ENDM

sPutDot .MACRO;X,Y
	LB sX,?1
	LB sY,?2
	LB sColor,?3
	INT _sPutDot
	.ENDM

sDrawLine.MACRO;Left,Top,Right,Bottom,Color
	LB sLeft,?1
	LB sTop,?2
	LB sRight,?3
	LB sBottom,?4
	LB sColor,?5
	INT _sDrawLine
	.ENDM

sDrawLineEx.MACRO;Left,Top,Right,Bottom,Color
	LB sLeft,?1
	LB sColor,?5
	LDA ?2
	LDX ?3
	LDY ?4
	INT _sDrawLineEx
	.ENDM

sDrawRect.MACRO;Left,Top,Right,Bottom,Color
	LB sLeft,?1
	LB sTop,?2
	LB sRight,?3
	LB sBottom,?4
	LB sColor,?5
	INT _sDrawRect
	.ENDM

sDrawRectEx.MACRO;Left,Top,Right,Bottom,Color
	LB sLeft,?1
	LB sColor,?5
	LDA ?2
	LDX ?3
	LDY ?4
	INT _sDrawRectEx
	.ENDM

sFillRect.MACRO;Left,Top,Right,Bottom,Color
	LB sLeft,?1
	LB sTop,?2
	LB sRight,?3
	LB sBottom,?4
	LB sColor,?5
	INT _sFillRect
	.ENDM

sFillRectEx.MACRO;Left,Top,Right,Bottom,Color
	LB sLeft,?1
	LB sColor,?5
	LDA ?2
	LDX ?3
	LDY ?4
	INT _sFillRectEx
	.ENDM

sWriteBlock.MACRO;Left,Top,Right,Bottom,BlockDatPtr
	LB sLeft,?1
	LB sTop,?2
	LB sRight,?3
	LB sBottom,?4
	LW sBlockDatPtr,?5
	INT _sWriteBlock
	.ENDM

sWriteBlockEx.MACRO;;Left,Top,BlockDatPtr
	LDX ?1
	LDY ?2
	LW sBlockDatPtr,?3
	INT _sWriteBlockEx
	.ENDM
	
;16*16 input
sInput	.MACRO;Type,Left,Top,Len,HelpStr
	LXY #.ParamLst
	LB sCrsTyp,#0
	LB $044A,#$15
	INT _sInput
	RTS
.ParamLst:
	.DB [??2 2 0]+[??3 2 0]*20
	.DB [??4 2 0]
	.DB [??1 2 0]
	.DW .InputHelp
.InputHelp:
	.DB ?5,0,0
	.ENDM

;Type:(lo 4 bit)
SMSGBOX=0;msg box
SQUEBOX=1;question + [YES OR NO]
SEXCBOX=2;exclamatory + [YES OR NO]
SSELBOX=3;sub menu
;ChrAttr:
;bit7:0--no inverse;1--inverse
;bit2:0--small font;1--big font
sOpenWin .MACRO; Type,TextAddr,WinLeft,WinTop,WinWid/8,WinHgt/8,ChrAttr,SubAddr
	LXY #.ParamLst
	LDA ?1		;Type
	INT _sOpenWin
	RTS
.ParamLst:
	.DB $80
	.DW ?2		;TextAddr
	.DB ??3 2 0	;WinLeft
	.DB ??4 2 0	;WinTop
	.DB ??5 2 0	;Value=WinWid/8 also is the length of line_string
	.DB ??6 2 0	;Value=BoxHgt/8
	.DW .ChrAttrPtr
	.IF ??1 2 0>2
	.DW ?8		;SubAddr
	.ENDIF
.ChrAttrPtr:
	.DB ??7 2 0	;ChrAttr
	.ENDM

;Read Nand Flash
sNDReadBytes.MACRO;Slot,Offset,Length,DatDst
	LW sPhySectSlot,?1
	LW sPhySectOffset,?2
	LW sLength,?3
	LW sNandDatDst,?4
	INT _sNDReadBytes
	.ENDM

sReadInode.MACRO;InodeID,FileState
	LW sInodeID,?1
	LB  sFileState,?2
	INT _sGetInodeSlot
	INT _sGetInode
	.ENDM

sDiv	.MACRO;Dividend,Divisor
	LW sDividend,?1
	LW sDivisor,?2
	INT _sDiv
	.ENDM

sMul	.MACRO;N1,N2
	LDA ?1
	LDX ?2
	INT _sMul
	.ENDM