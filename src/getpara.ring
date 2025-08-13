/*
	Title :	Ring Code Formatter Parameter Handler
	Date  : 2025.08.12
	Author: Azzeddine
*/

func getParameters cProgramName
	aPara = sysargv
	cEXEFileName = exefilename()

	# Extract just the filename from full path
	nPos = 0
	for i = len(cEXEFileName) to 1 step -1 {
		if cEXEFileName[i] = "\" or cEXEFileName[i] = "/" {
			nPos = i
			exit
		}
	}
	if nPos > 0 {
		cEXEFileName = substr(cEXEFileName, nPos + 1)
	}

	cEXEFileName = lower(cEXEFileName)

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
