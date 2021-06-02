## OTP

Like [Authy](https://authy.com), [OTP Auth](https://cooperrs.de/otpauth.html), [Okta Verify](https://help.okta.com/en/prod/end-user/Content/Topics/end-user/ov-overview.htm), etc., but using your Mac and a SQLite database.


### YOU MUST PROTECT THE DATABASE

The data stored is as sensitive as your passwords.  If someone gains access to your database they can create copies of every virtual MFA device you have stored.

I recommend storing the database locally, or using a cloud storage service with end-to-end encryption.  Eg., [Sync.com](https://www.sync.com/?_sync_refer=e50112).


### Requirements

OTP relies on a few packages to generate tokens, import QR codes, and generate QR codes

`brew install oath-toolkit zbar qrencode`


### Adding a device

Virtual MFA devices typically have two fields: Issuer (the provider or service the device is associated with) and Account (usually the username you use to login).

OTP adds an (optional) explicit ***Username*** field.  This can be useful when you have multiple logins to the same account.  Eg., an AWS account where you have separate MFA devices for different IAM users.

You can add a device with its QR code or with its secret key.

- To use a QR code, either copy the image to the clipboard or save the image to a file.  When OTP finds a valid QR code in the clipboard (or you import from a file) it will fill in the form fields for you.

- When a provider shows the QR code there should be an option to show the secret key instead.  Copy and paste that into the form when prompted.


### Getting a token

OTP will show the current token under each of your devices.  Selecting one will copy the code to the clipboard.

- Ctrl - Automatically paste the code to the frontmost app
- Shift - Show the code using Large Type
- Ctrl + Shift - Automatically paste the code to the frontmost app and "press" return
- Cmd - Show the MFA device's QR code (to scan into your favorite phone app)
- Fn - Delete the MFA device from the database

OTP will also search recent Messages for authentication codes.
