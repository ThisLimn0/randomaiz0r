@ECHO OFF&SETLOCAL EnableDelayedExpansion EnableExtensions
TITLE File randomaiz0r
COLOR 1F
MODE 100,35
SET "SELF=%~dp0"
SET "SELFEXT=%~dpnx0"
SET "SELFDropFolder=%~dp0randomaiz0r\"
CALL :SplishSplashSplosh
CALL :GetFolder
PAUSE
CALL :CheckFolderContents
CALL :RNDFilename
ECHO.Do you want to remove all Exif Data from images?
ECHO.If not: close this window.
PAUSE
CALL :RMVExifPhoto
ECHO.Do you want to remove all Exif Data from video?
ECHO.If not: close this window.
PAUSE
CALL :RMVExifVideo
ECHO.Process has finished.
PAUSE >NUL
EXIT

:SplishSplashSplosh
IF NOT DEFINED SPC SET "SPC=                      "
ECHO.
ECHO.!SPC! FILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILE
ECHO.!SPC!  d8888b.  .d8b.  d8b   db d8888b.  .d88b.
ECHO.!SPC!  88  `8D d8' `8b 888o  88 88  `8D .8P  Y8.
ECHO.!SPC!  88oobY' 88ooo88 88V8o 88 88   88 88    88  .88888.
ECHO.!SPC!  88`8b   88~~~88 88 V8o88 88   88 88    88  `88888'
ECHO.!SPC!  88 `88. 88   88 88  V888 88  .8D `8b  d8'
ECHO.!SPC!  88   YD YP   YP VP   V8P Y8888D'  `Y88P'
ECHO.!SPC! FILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILE
ECHO.!SPC! .88b  d88.  .d8b.  d888888b d88888D  .d88b.  d8888b.
ECHO.!SPC! 88'YbdP`88 d8' `8b   `88'   YP  d8' .8P  88. 88  `8D
ECHO.!SPC! 88  88  88 88ooo88    88       d8'  88  d'88 88oobY'
ECHO.!SPC! 88  88  88 88~~~88    88      d8'   88 d' 88 88`8b
ECHO.!SPC! 88  88  88 88   88   .88.    d8' db `88  d8' 88 `88.
ECHO.!SPC! YP  YP  YP YP   YP Y888888P d88888P  `Y88P'  88   YD
ECHO.!SPC! FILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILEFILE
ECHO.
EXIT /B

:GetFolder
IF NOT EXIST "!SELFDropFolder!" (
	MKDIR "!SELFDropFolder!"
	ECHO.### Folder !SELFDropFolder! successfully created. You can now drop your files to randomaiz in.
) ELSE (
	ECHO.### !SELFDropFolder! already exists. You can now drop your files to randomaiz in.
)
EXIT /B

:CheckFolderContents
>NUL 2>NUL DIR /a-d /s "!SELFDropFolder!*" && (ECHO.Files found. Continuing.) || (ECHO.Error. No files found. Please try again.&PAUSE >NUL&EXIT)
EXIT /B

:RNDFilename
FOR /R %SELFDropFolder% %%C IN (*) DO (
	SET "TMP=%%C"
	SET "TMP2=%%~dpC"
	SET "TMPX=%%~xC"
	CALL :ExtensionToUpper
	CALL :DetectMedia
	CALL :GenerateRandom
	SET /A TOTAL+=1
	ECHO.[!TOTAL!.!MediaType!] Masking: %%C --^> !TMPB!!TMPX!
	REN "%%C" "!TMPB!!TMPX!" >NUL
	REM ECHO.Random string is !TMPB!
	TITLE [RNDFilename] Processing Files in !SELFDropFolder! - !TOTAL!
)
ECHO.
ECHO.### Finished Masking Filenames
EXIT /B

:RMVExifPhoto
FOR /R %SELFDropFolder% %%C IN (*) DO (
	SET "TMP=%%C"
	SET "TMP2=%%~dpC"
	SET "TMPX=%%~xC"
	CALL :DetectMedia
	IF "!MediaType!"=="Image" (
		SET /A TOTAL2+=1
		exiftool -overwrite_original -all= %%C
		ECHO.[!TOTAL2!.] Stripped ^>^>^>%%C^<^<^< of all EXIF-Data.
	)
	REM ECHO.Random string is !TMPB!
	TITLE [RMVExifPhoto] Processing Files in !SELFDropFolder! - !TOTAL2!/!TOTAL!
)
EXIT /B

:RMVExifVideo
FOR /R %SELFDropFolder% %%C IN (*) DO (
	SET "TMP=%%C"
	SET "TMP2=%%~dpC"
	SET "TMPX=%%~xC"
	SET "TMPY=%%~nxC"
	CALL :DetectMedia
	IF "!MediaType!"=="Video" (
		SET /A TOTAL3+=1
		ffmpeg -y -i "%%C" -c copy -map_metadata -1 -metadata title="My Title" -metadata creation_time=2014-01-01T21:30:00 -map_chapters -1 "!TMP2!2!TMPY!"
		DEL /F /Q "!TMP2!!TMPY!"
		REN "!TMP2!2!TMPY!" "!TMPY!"
		ECHO.[!TOTAL3!.] Overwrote EXIF on ^>^>^>%%C^<^<^<.
	)
	REM ECHO.Random string is !TMPB!
	TITLE [RMVExifVideo] Processing Files in !SELFDropFolder! - !TOTAL3!/!TOTAL!
)
EXIT /B

:GenerateRandom
SET "ALPHANUMERICALS=ABCDEFGHIJKLMNOP0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

SET "TMPB="
FOR /L %%B IN (0,1,12) DO (
	SET /A RND=!RANDOM! * 62 / 32768 + 1
	FOR /F %%C IN ('ECHO.%%ALPHANUMERICALS:~!RND!^,1%%') DO SET "TMPB=!TMPB!%%C"
)
IF EXIST "!TMP2!!TMPB!!TMPX!" CALL :GenerateRandom
EXIT /B

:ExtensionToUpper
:: Subroutine to convert a variable VALUE to all UPPER CASE.
:: The argument for this subroutine is the variable NAME.
FOR %%I IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO (
	SET "TMPX=!TMPX:%%~I!"
)
EXIT /B

:DetectMedia
IF NOT DEFINED MediaTypePhoto SET "MediaTypePhoto=0"
IF NOT DEFINED MediaTypeVideo SET "MediaTypeVideo=0"
SET "MediaType="
FOR %%I IN ("BMP" "RLE" "DIB" "GIF" "JPG" "JPEG" "JP2" "J2C" "JPF" "J2K" "JPC" "JPS" "PNG" "TIF" "TIFF") DO (
	IF /I "!TMPX!"==".%%~I" (
		SET "MediaType=Image"
		SET /A MediaTypePhoto+=1
		EXIT /B
	)
)
FOR %%I IN ("MP4" "AVI" "MKV" "FLV") DO (
	IF /I "!TMPX!"==".%%~I" (
		SET "MediaType=Video"
		SET /A MediaTypeVideo+=1
		EXIT /B
	)
)
SET "MediaType=File"
EXIT /B
