PutCmdSym.MACRO
	LDA ?1
	JSR _PutCmdSym
	.ENDM
PutC	.MACRO
	LDA ?1
	JSR _PutC
	.ENDM
PutHex	.MACRO
	LDA ?1
	JSR _PutHex
	.ENDM

CPR=26
RPS=6
LINECOUNT=RPS
CODE_ASC=$80
CODE_GB=$40
CODE_BIG=$20
CODE_HAN=$10
CHRNUMPERLINE=16

__zBASE = $40
	zALLOC	1,zLo
	zALLOC	2,zAddr
	zALLOC	2,zFuncAddr

	zALLOC	2,zSrcHeadPtr
	zALLOC	2,zSrcTailPtr
	zALLOC	2,zDstHeadPtr

	zALLOC	2,zFindSrcHead
	zALLOC	2,zFindSrcTail
	

__BASE = $1500
	ALLOC	1,NumPerLine
	ALLOC	1,DispMode
	ALLOC	1,Flag
	ALLOC	1,Tmp
	ALLOC	1,Byte
	ALLOC	2,SectSlot
	ALLOC	2,SectOffset
	ALLOC	1,SrcBank
	ALLOC	1,DstBank
	ALLOC	2,StaPtr

	ALLOC	1,BankHead
	ALLOC	1,BankTail
	ALLOC	20,AimHome
	ALLOC	1,AimDatLen
	
	ALLOC	SDIRITEMSIZE*LINECOUNT,FileNameArray
	ALLOC	2,CurItemFileID
	ALLOC	1,CurItemID
	ALLOC	1,BottomItemID