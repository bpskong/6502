V1='1'
V2='.'
V3='0'
V4='6'

	.include "..\include\wqx\tc1000\tc1000.asm"

	CreateHead "AsmFun",_Main

CodeHead=$2000

_BinEntry:
	.ORG CodeHead
	.include "content.asm"
_CodeTail:
CodeLen=_CodeTail-CodeHead
	.ORG _BinEntry+CodeLen

_Main:
	KMemCpy CodeHead,_BinEntry,_Main-1
	JMP CodeHead
