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
