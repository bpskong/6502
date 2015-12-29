CreateHead.MACRO;BinName [, BinEntry]
	.ORG $4000
	.DB $40,$00
.Head	.DB ?1
.Tail
.NameLen=.Tail-.Head
	.IF .NameLen>16
	BinName_is_overflow
	.ENDIF
	.REPT 16-.NameLen
	.DB $20
	.ENDR
	.DB "      "
	.IF ?0>1
	JMP ?2
	.ENDIF
	.IF ?0<2
	JMP .Main
	.ENDIF
	.DB $A5,$AA,$55,$01,$00
.Main
	.ENDM
	.include "..\common\station.asm"