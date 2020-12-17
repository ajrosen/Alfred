# Alfred

Alfred workflows

- [External IP](#myip)
- [LastPass Accelrator](#lpass)
- [OTP](#otp)
- [GeekTool Refresher](#gt)

<a name="myip"></a>

## External IP

Show your external IP address by sending a DNS query to resolver1.opendns.com

- `Ctrl` Copy to clipboard and paste to front most app
- `Shift` Show large type
- `CMD` Copy to clipboard

----

<a name="lpass"></a>

## LastPass Accelerator

Interact with [LastPass CLI](https://github.com/lastpass/lastpass-cli).

LastPass Accelerator uses the LastPass CLI.  The easiest way to install it is with [brew](https://brew.sh/):

`brew install lastpass-cli`

If you have not installed brew, first run this:

`bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

### Variables

These can also be changed using the ***lpconfigure*** command (see below).

- **ClipboardTimeout**

  Number of seconds a password is stored in the clipboard before restoring the clipboard to its previous contents.  Default is `30`.

- **PostNotification**

  Whether to post a nofication each time a field is copied to the clipboard.  Default is `true`.

- **lppath**

  Location of the LastPass CLI program.  Default is `/usr/local/bin/lpass`.

- **lpuser**

  Your LastPass username.  This is automatically set when you login.


### Commands

All commands start with ***lp***, so there's only one thing to remember.

-  **lpin [username]**

    Login to LastPass.  The username is taken from the workflow variable {lpuser}, unless specified here.

    After you enter your LastPass password you will be prompted for your MFA code, unless you have previously logged in with the CLI's *--trust* option.

    If you have not enabled MFA for LastPass [do it now](https://www.lastpass.com/two-factor-authentication)!  Until then, leave this blank.

- **lpout**

  Logout of LastPass.

- **lpstat**

  Show LastPass status.  Either "Logged in as..." or "Not logged in."

- **lpass**

	Copy an item's password to the clipboard.  Use these modifiers to copy other fields:

  - `Ctrl` Username
  - `Shift` URL
  - `CMD` Notes

  Or use the **Option** key to open a new menu with additional actions you can perform on the selected item.

  - ##### Launch
	Open item's URL

  - ##### Share
	*Not yet implemented*

  - ##### Delete
	Remove item (with confirmation)

  - ##### Move
	Move item to a different folder

  - ##### Duplicate
	Duplicate item


- #### lpconfigure

  Quickly view and modify the workflow's variables.

- #### lpmanage

  Manage LastPass account.

  - ##### Change your LastPass password
  - ##### Import items from a file
  - ##### Export items to a file

----

<a name="otp"></a>

## OTP

Like Authy, FreeOTP, Okta Verify, etc., but using your Mac and a SQLite database.

**YOU MUST PROTECT THE DATABASE**

The data stored is as sensitive as your passwords.  If someone gains access to your database they can create copies of every virtual MFA device you have stored.


There is an additional field, ***Username***, useful when you have multiple logins to the same account.  Eg., an AWS account where you have separate MFA devices for the root account and different IAM users.

> - Ctrl - Automatically paste the code to the frontmost app
> - Shift - Show the code using Large Type
> - CMD - Show the MFA device's QR code

You can scan the QR code into your favorite phone app.

`brew install oath-toolkit qrencode zbar`

----

<a name="gt"></a>

## GeekTool Refresher

Tell [GeekTool](https://www.tynsoe.org/geektool/) to refresh the chosen geeklet now.  Assumes all geeklets have a name.

`brew install geektool`
