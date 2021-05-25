## LastPass Accelerator

Interact with [LastPass CLI](https://github.com/lastpass/lastpass-cli).

LastPass Accelerator uses the LastPass CLI.  The easiest way to install it is with [brew](https://brew.sh/):

```
brew install lastpass-cli
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```


### Variables

These can also be changed using the [***lpconfigure***](#lpconfigure) command.

- **ClipboardTimeout**

  Number of seconds a password is stored in the clipboard before restoring the clipboard to its previous contents.  Default is `30`.

- **PostNotification**

  Whether to post a nofication each time a field is copied to the clipboard.  Default is `true`.

- **ShowFolders**

  Show only folders in the initial results.  This lets you navigate your vault like using Finder.  Default is `false`.

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

  Copy an item's password to the clipboard.  If your web browser is the front-most window, items that match the current URL's hostname will be listed first.  Supported browsers:
  
  - Safari
  - Chrome
  - Firefox<sup>[1](#1)</sup>
  - Opera
  - Edge

  Use these modifiers to copy other fields<sup>[2](#2)</sup>:

  - `Ctrl` Username
  - `Shift` URL
  - `CMD` Notes
  - `Fn` Show all fields in a dialog window

  Or use the **Option** key to open a new menu with additional actions you can perform on the selected item.

  - ##### Launch
	Open item's URL

  - ##### Delete
	Remove item (with confirmation)

  - ##### Move
	Move item to a different folder

  - ##### Duplicate
	Duplicate item

  - ##### Show item
    Show all fields in a dialog window for easy copy/paste


- #### lpconfigure

  Quickly view and modify the workflow's [variables](#variables).


- #### lpmanage

  Manage LastPass account.

  - ##### Change your LastPass password
  - ##### Import items from a file
  - ##### Export items to a file


- #### lpgen

  Use LastPass to generate a random password.  You can specify the password length.  The default is `20`.  Use the `CMD` key to allow symbols in the password.

-------------------------------------------------------------------------------

<a name="1"/>*<sup>1</sup> Support for Firefox requires the [Alfred Integration extension](https://addons.mozilla.org/en-US/firefox/addon/alfred-launcher-integration) and [alfred-firefox workflow](https://github.com/deanishe/alfred-firefox/releases/latest).*

<a name="2"/>*<sup>2</sup> Only the `Option` moidifier is available for Secure Notes.  They are always displayed in a dialog window.*
