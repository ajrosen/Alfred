# Alfred
Alfred workflows


## External IP

Fetch your external IP address by sending a DNS query to resolver1.opendns.com

    Shift:      Show large type
    Cmd:	    Copy to clipboard
    Control:    Copy to clipboard and paste to front most app

With no modifiers show the address in a notification


## LastPass Accelerator

Interact with LastPass CLI.

LastPass Accelerator uses the LastPass CLI.  The easiest way to install it is with brew:

    brew install lastpass-cli

If you have not installed brew, first run this:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

### Variables

#### ClipboardTimeout
Number of seconds a password is stored in the clipboard before restoring the clipboard to its previous contents

#### lppath
Location of the LastPass CLI program

#### lpuser
Your LastPass username

### Commands

#### lpin [username]
Login to LastPass.  The username is taken from the workflow variable {lpuser}, unless provided here.

After you enter your LastPass password you will be prompted for your MFA code.  If you have previously logged in with the CLI's --trust option you can leave this blank.

If you have not enabled MFA for LastPass do it now.  Until then, you can leave this blank.  

#### lpout
Logout of LastPass.

#### lpstat
Show LastPass status.  Either "Logged in as..." or "Not logged in."

#### lpass
Copy an item's password, username (with Control), URL (with Shift), or notes (with Command) to the clipboard.


## OTP

Like Authy, FreeOTP, Okta Verify, etc., but using your Mac and a SQLite database.

**YOU MUST PROTECT THE DATABASE**

The data stored is as sensitive as your passwords.  If someone gains access to your database they can create copies of every virtual MFA device you have stored.


There is an additional field, Username, useful when you have multiple logins to the same account.  Eg., an AWS account where you have separate MFA devices for the root account and different IAM users.

    Shift:      Show the code using Large Type
    Option:     Show the MFA device's QR code
    Control:    Automatically paste the code to the frontmost app

You can scan the QR code into your favorite phone app.

    brew install oath-toolkit qrencode zbar


## GeekTool Refresher

Tell GeekTool to refresh the chosen geeklet now.  Assumes all geeklets have a name.
