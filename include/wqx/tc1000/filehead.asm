;FOR  WQX/TC1000

CreateHead.MACRO;BinName [, BinEntry]
	.ORG $3FD0
	.DB "Application     "
	.DB "  "
.Head	.DB ?1
	.DB ".bin"
.Tail:
.NameLen=.Tail-.Head
	.IF .NameLen>14
	BinName_is_overflow
	.ENDIF
	.REPT 14-.NameLen
	.DB $20
	.ENDR
	.DB $F8,$DF,$FF,$FF,$FF,$FF,$FF,$FF
	.DB $00,$00,$00,$00
	.DB $FF,$FF,$FF,$FF
	.DB $AA,$A5,$5A
	.DB $00,$10,$00,$20
	.IF ?0>1
	JMP ?2
	.ENDIF
	.IF ?0<2
	JMP .Main
	.ENDIF
	.DB $E8,$03,$30,$03,$FF,$FF
.Main:
	.ENDM

	.include "..\common\station.asm"