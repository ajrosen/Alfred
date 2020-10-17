#!/usr/bin/osascript
# *-*- apples -*-*

global Issuer, Account, Username, SecretKey

set Issuer to ""
set Account to ""
set Username to ""
set SecretKey to ""


# https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/EncodeandDecodeText.html
on decodeCharacterHexString(theCharacters)
	copy theCharacters to {theIdentifyingCharacter, theMultiplierCharacter, theRemainderCharacter}
	set theHexList to "123456789ABCDEF"
	if theMultiplierCharacter is in "ABCDEF" then
		set theMultiplierAmount to offset of theMultiplierCharacter in theHexList
	else
		set theMultiplierAmount to theMultiplierCharacter as integer
	end if
	if theRemainderCharacter is in "ABCDEF" then
		set theRemainderAmount to offset of theRemainderCharacter in theHexList
	else
		set theRemainderAmount to theRemainderCharacter as integer
	end if
	set theASCIINumber to (theMultiplierAmount * 16) + theRemainderAmount
	return (ASCII character theASCIINumber)
end decodeCharacterHexString

on decodeText(theText)
	set flagA to false
	set flagB to false
	set theTempCharacter to ""
	set theCharacterList to {}
	repeat with theCurrentCharacter in theText
		set theCurrentCharacter to contents of theCurrentCharacter
		if theCurrentCharacter is "%" then
			set flagA to true
		else if flagA is true then
			set theTempCharacter to theCurrentCharacter
			set flagA to false
			set flagB to true
		else if flagB is true then
			set end of theCharacterList to decodeCharacterHexString(("%" & theTempCharacter & theCurrentCharacter) as string)
			set theTempCharacter to ""
			set flagA to false
			set flagB to false
		else
			set end of theCharacterList to theCurrentCharacter
		end if
	end repeat
	return theCharacterList as string
end decodeText


# otpauth://totp/Issuer:Account?secret=ABC&issuer=Issuer
on splitURI(uri)
	set tid to AppleScript's text item delimiters
	
	set AppleScript's text item delimiters to ":"
	set otp to fourth text item of uri
	
	set AppleScript's text item delimiters to "?"
	set Account to first text item of otp
	set args to last text item of otp
	
	set AppleScript's text item delimiters to "&"
	set SecretKey to first text item of args
	set Issuer to last text item of args
	
	set AppleScript's text item delimiters to "="
	set Issuer to last text item of Issuer
	set SecretKey to last text item of SecretKey
	
	set AppleScript's text item delimiters to tid
	
	set Issuer to decodeText(Issuer)
	set Account to decodeText(Account)
	set SecretKey to decodeText(SecretKey)
end splitURI


##################################################
# Main

set T to "Add new MFA device"
set B to {"OK", "Cancel"}

# Issuer
set d to display dialog "Enter Issuer or import QR code" buttons B & "Import" default answer Issuer default button "OK" with title T
set Issuer to text returned of d

repeat while button returned of d = "Import" or Issuer = ""
	set f to POSIX path of (choose file of type {"public.image"} with showing package contents)
	set uri to do shell script "/usr/local/bin/zbarimg -q " & f
	splitURI(uri)
	
	set d to display dialog "Enter Issuer or import QR code" buttons B & "Import" default answer Issuer default button "OK" with title T
	set Issuer to text returned of d
end repeat

# Account
set Account to text returned of (display dialog "Enter Account" buttons B default answer Account default button "OK" with title T)
repeat while Account = ""
	set Account to text returned of (display dialog "Enter Account" buttons B default answer Account default button "OK" with title T)
end repeat

# Username
set Username to text returned of (display dialog "Enter Username (optional)" buttons B default answer Username default button "OK" with title T)

# Secret Key
repeat while SecretKey = ""
	set SecretKey to text returned of (display dialog "Enter Secret Key" buttons B default answer SecretKey default button "OK" with title T)
end repeat

# Insert into db
set db to system attribute "db"

do shell script "sqlite3 " & db & " \"insert into totp (issuer, account, username, secret_key) values ('" & Issuer & "','" & Account & "','" & Username & "','" & SecretKey & "')\""
do shell script "sqlite3 " & db & " \"select item from totp where secret_key = '" & SecretKey & "'\""
