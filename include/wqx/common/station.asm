CreateStation.MACRO;BinName,Station
.S=$40
.D=$42
.StaTailHi=>$4000
	CreateHead ?1
	LW .S,#.Begin
	LW .D,#?2
	LDY #$00
.N	LBYBY .D,.S
	INY
	BNE .N
	INC .S+1
	INC .D+1
	CPB  .D+1,.StaTailHi
	BNE .N
.L	JMP ?2
.Begin	.ORG ?2
	.ENDM
