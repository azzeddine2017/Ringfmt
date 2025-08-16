/*
	Title :	Ring Code Formatter Parameter Handler
	Date  : 2025.08.12
	Author: Azzeddine
*/

func getParameters cProgramName
	aPara = sysargv
	cEXEFileName =  lower(JustFileName(exefilename()))

	# Remove .exe from the file name
	cEXEFileName = substr(cEXEFileName, ".exe", "")

	if cEXEFileName != cProgramName {
		nStart = 3
	else
		nStart = 2
	}

	aList = []
	if len(aPara) >= nStart {
		for x = nStart to len(aPara) {
			aList + aPara[x]
		}
	}

	return aList
