sNoidleAddr = $03F7
sKey = $C7
sRWDatBuf = $E0
sLength = $0967
sNandDatDst = $F0
sBlockDatPtr = $92
sDividend = $80
sDivRe = $80

SPAGESIZE = 512
SDIRITEMSIZE = 16
SINODESIZE = 32
SINODEBLOCKNUM = 17
SPATH_LEN = 57

__BASE = $0747
	ALLOC	128,sACorpseBitMap
	ALLOC	1,sActiveSBPos
	ALLOC	5,sSBBank
	ALLOC	10,sSBAddr
	ALLOC	SINODEBLOCKNUM,sInodeBank
	ALLOC	SINODEBLOCKNUM*2,sInodeAddr
	ALLOC	1,sPlBadLst
	ALLOC	1,sPhase
	ALLOC	2,sReclaimBlockNum
	ALLOC	2,sReclaimedBlockNum
	ALLOC	4,sNDAddrReg
	ALLOC	1,sNDStatusReg
	ALLOC	2,sNDIDReg
	ALLOC	2,sNDDatCnt
	ALLOC	2,sNDDatLen
	ALLOC	2,sWFlashTime
	ALLOC	2,sPhySectSlot
	ALLOC	3,sPhySectOffset
	ALLOC	SPATH_LEN,sFilePath
	ALLOC	2,sDatSize
	ALLOC	1,sFileHandle	;$085D
	ALLOC	1,sFileOpMode
	ALLOC	2,sFileAttr
	ALLOC	1,sFileErr
	ALLOC	4,sSeekOffset
	ALLOC	1,sSeekOrigin
	ALLOC	2,sCurDirID
	ALLOC	32,sInodeBuf
	ALLOC	2,sInodeSlot
	ALLOC	2,sInodeID
	ALLOC	2,sSectSlot
	ALLOC	1,sOpFileNum
	ALLOC	4,sFileSize
	ALLOC	1,sFileMode
	ALLOC	1,sFileState
	ALLOC	2,sDirNode
	ALLOC	4,sDirPtr
	ALLOC	17,sDirent
	ALLOC	2,sSectOffset
	ALLOC	15,sNewName

__BASE = $02C0
	ALLOC	200,sTextBuf
	ALLOC	10,sIconBuf
	ALLOC	1,sFontSize
	ALLOC	1,sBigFont
	ALLOC	1,sCurCPR
	ALLOC	1,sCurRPS
	ALLOC	25,sChrAttr
	ALLOC	2,sRowAttr
	ALLOC	2,sRowUpdate
	ALLOC	1,sCrsTyp
	ALLOC	1,sCrsX
	ALLOC	1,sCrsY
	ALLOC	1,sCrsStatus
	ALLOC	1,sChrMode
	ALLOC	2,sModeBuf
	ALLOC	2,sLineBuf
	ALLOC	1,sScrMode
	ALLOC	1,sUnderLineCrs
	ALLOC	2,sScrPtr
	ALLOC	1,sLCDch
	ALLOC	1,sLCDcv
	ALLOC	1,sScrncv

__BASE = $03C3
	ALLOC	1,sLeft
	ALLOC	1,sTop
	ALLOC	1,sRight
	ALLOC	1,sBottom
	ALLOC	1,sX
	ALLOC	1,sY
	ALLOC	1,sColor
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	2,sDivisor
	ALLOC	2,sHexNum
	ALLOC	5,sNumAsc

SCOLOR_WHITE	=0
SCOLOR_BLACK	=1
SCOLOR_CONVERT	=2

__BASE = $03E8
	ALLOC	1,sCode
	ALLOC	1,sBright
	ALLOC	1,sVolume

__BASE = $03F8
	ALLOC	1,sHour
	ALLOC	1,sMinute
	ALLOC	1,sSecond
	ALLOC	1,sYear
	ALLOC	1,sMonth
	ALLOC	1,sDay
	ALLOC	1,sWeek
	ALLOC	1,sHalfSecond
	ALLOC	1,sHundred

__BASE = $040B
	ALLOC	1,sLowPowerFlag
	ALLOC	1,sOnPicFlag
	ALLOC	1,s24HourMode
	ALLOC	1,sCjjHalfSecond
	ALLOC	12,sHostName

__BASE = $0501
	ALLOC	1,_sTestModel
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_sNDReadBytes
	ALLOC	1,_sNDReadPage
	ALLOC	1,_sNORReadByte
	ALLOC	1,_sNORReadBytes
	ALLOC	1,_sFileID2DirName
	ALLOC	1,_sTestDir
	ALLOC	1,_sCreateDir
	ALLOC	1,_sReadDir
	ALLOC	1,_sEnterDir
	ALLOC	1,_sDelFile
	ALLOC	1,_sDelDir
	ALLOC	1,_sReName
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_sGetFileLen
	ALLOC	1,_sOpenFile
	ALLOC	1,_sReadFile
	ALLOC	1,_sCloseFile
	ALLOC	1,_sWriteFile
	ALLOC	1,_sSeekFile
	ALLOC	1,_sGetInodeSlot
	ALLOC	1,_sGetInode

SLCDWID			=	160
SLCDHGT			=	80

__BASE = $19C0
	ALLOC	1600,sLCDBuf

__BASE = $C006
	ALLOC	1,_sWaitKey

__BASE = $C701
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_sGetFont8x10
	ALLOC	1,_sGetFont8x16
	ALLOC	1,_sGetFont12x12
	ALLOC	1,_sGetFont6x12
	ALLOC	1,_sFlashCursor
	ALLOC	1,_sWriteFont8x8
	ALLOC	1,_sWriteCode8x16
	ALLOC	1,_sWriteFont8x16
	ALLOC	1,_sWriteFont16x16
	ALLOC	1,_sWriteCode16x16
	ALLOC	1,_sWriteFont6x12
	ALLOC	1,_sWriteCode6x12
	ALLOC	1,_sWriteLable6x12
	ALLOC	1,_sWriteCode12x12
	ALLOC	1,_sWriteLable8x10
	ALLOC	1,_sWriteFont8x10
	ALLOC	1,_sWriteAscii
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_sUpdateLCD
	ALLOC	1,_sUpdateIcon
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_Unkown
	ALLOC	1,_sClrScr
	ALLOC	1,_sClrTextBuf

__BASE = $CA01
	ALLOC	1,_sToAsc16u
	ALLOC	1,_sDiv
	ALLOC	1,_sMul
	ALLOC	1,_sPutDot
	ALLOC	1,_sGetDot
	ALLOC	1,_sDrawRectEx
	ALLOC	1,_sFillRectEx
	ALLOC	1,_sDrawLineEx
	ALLOC	1,_sWriteBlock
	ALLOC	1,_sFillRect
	ALLOC	1,_sDrawLine
	ALLOC	1,_sDrawRect
	ALLOC	1,_sWriteBlockEx
	ALLOC	1,_sDrawCircle
	ALLOC	1,_sDrawEllipse
	ALLOC	1,_sFillCircle
	ALLOC	1,_sFillEllipse
	ALLOC	1,_sOpenWin
	ALLOC	1,_sRollMenu
	ALLOC	1,_sProcMenu
	ALLOC	1,_sSearching
	ALLOC	1,_sNotFound

__BASE = $CB05
	ALLOC	1,_sInput

__BASE = $E000
	ALLOC	3,_sNull
	ALLOC	3,_sNull
	ALLOC	3,_sBin2Dig
	ALLOC	3,_sEnterSleep
	ALLOC	3,_sEnterSleepz
	ALLOC	3,_sStart4ch
	ALLOC	3,_sStop4ch
	ALLOC	3,_sBell
	ALLOC	3,_sKeyClickBell

__BASE = $E063
	ALLOC	3,_sNDPhyWrite512B
	ALLOC	3,_sNDPhyWrite16B
	ALLOC	3,_sNDPhyRead16B
	ALLOC	3,_sNDPhyRead512B
	ALLOC	3,_sNDPhyRead_byte
	ALLOC	3,_sNgffsMoveData
	ALLOC	3,_sDispIcon
	ALLOC	3,_sExecBin
	ALLOC	3,_sProcMenuIcon
