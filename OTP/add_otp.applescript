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


# https://github.com/google/google-authenticator/wiki/Key-Uri-Format
# otpauth://TYPE/LABEL?PARAMETERS
# otpauth://totp/Issuer:Account?secret=ABC&issuer=Issuer
# otpauth://totp/alice@google.com?secret=JBSWY3DPEHPK3PXP
on splitURI(uri)
    # Check scheme and type
    if uri does not start with "otpauth://totp/" then
	error "Unknown scheme://type in " & uri
    end if

    # Strip scheme and type
    set uri_path to characters 16 through (length of uri) of uri as text

    # Separate label from parameters
    set AppleScript's text item delimiters to {"?"}
    set label to first text item of uri_path
    set parameters to last text item of uri_path

    # Parse parameters
    set AppleScript's text item delimiters to {"&"}
    repeat with parameter in text items of parameters
	copy parameter as text to p

	set e to offset of "=" in p
	set l to length of p

	set AppleScript's text item delimiters to {""}

	set k to (characters 1 through (e - 1) of p) as text
	set v to (characters (e + 1) through l of p) as text

	if k = "issuer" then set Issuer to v
	if k = "secret" then set SecretKey to v
	if k = "algorithm" then set Algorithm to v
	if k = "digits" then set Digits to v
	if k = "period" then set Period to v

	set AppleScript's text item delimiters to {"&"}
    end repeat

    set AppleScript's text item delimiters to {""}

    # Parse label
    set c to offset of ":" in label
    set l to length of label

    if c is not 0 then
	set Issuer to (characters 1 through (c - 1) of label) as text
	set Account to (characters (c + 1) through l of label) as text
    else
	set Account to label
    end if
end splitURI


##################################################
# Main

set T to "Add new MFA device"
set B to {"OK", "Cancel"}
set N to {"Next", "Cancel"}

# Check clipboard
try
    set f to (system attribute "alfred_workflow_cache") & "/clipboard.jpg"
    set fd to open for access f with write permission
    tell application "Image Events" to write (the clipboard as JPEG picture) to fd
    close access fd

    set uri to do shell script "/usr/local/bin/zbarimg -q --raw " & quoted form of f
    splitURI(uri)
end try

do shell script "rm -fv " & quoted form of f

# Issuer
set d to display dialog "Enter Issuer or import QR code" buttons N & "Import" default answer Issuer default button "Next" with title T
set Issuer to text returned of d

repeat while button returned of d = "Import" or Issuer = ""
    set f to POSIX path of (choose file of type {"public.image"} with showing package contents)
    set uri to do shell script "/usr/local/bin/zbarimg -q " & quoted form of f
    splitURI(uri)
    
    set d to display dialog "Enter Issuer or import QR code" buttons N & "Import" default answer Issuer default button "Next" with title T
    set Issuer to text returned of d
end repeat

# Account
set Account to text returned of (display dialog "Enter Account" buttons N default answer Account default button "Next" with title T)
repeat while Account = ""
    set Account to text returned of (display dialog "Enter Account" buttons N default answer Account default button "Next" with title T)
end repeat

# Username
set Username to text returned of (display dialog "Enter Username (optional)" buttons N default answer Username default button "Next" with title T)

# Secret Key
repeat while SecretKey = ""
    set SecretKey to text returned of (display dialog "Enter Secret Key" buttons B default answer SecretKey default button "OK" with title T)
    
    # Remove spaces
    set AppleScript's text item delimiters to {" "}
    set msbc to every text item of SecretKey as list
    set AppleScript's text item delimiters to {""}
    set SecretKey to msbc as text
end repeat

# Insert into db
set db to system attribute "db"

do shell script "sqlite3 " & db & " \"insert into totp (issuer, account, username, secret_key) values ('" & Issuer & "','" & Account & "','" & Username & "','" & SecretKey & "')\""
do shell script "sqlite3 " & db & " \"select item from totp where secret_key = '" & SecretKey & "'\""
