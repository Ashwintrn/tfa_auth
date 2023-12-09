# tfa_auth - Two-Factor Authentication (TFA) App
tfa_auth is a Rails API-only application that demonstrates the implementation of two-factor authentication (TFA) using Google Authenticator. The app provides both traditional password-based authentication and TFA one-time password (OTP) authentication for enhanced security.

## Prerequisites
- Git/Github
- Rails
- Docker
- Gmail account and its app password (**Note**: Don't use gmail password instead you need to create an app password from https://myaccount.google.com/apppasswords this is what we use for sending emails)

## Setup the application
- Generate the app password from google and Navigate to docker-compose.yml and under web service, go to "environment" section and under **GMAIL_UNAME**, **GNAME_PASSWORD** provide you gmail id and app password accordingly.
eg: 
```yaml
    environment:
      - GMAIL_UNAME=dummyemail@example.com
      - GMAIL_PASS=12345678
```
- Start the application with ` docker-compose up`

## How to Use
Follow these steps to effectively use the tfa_auth application:

- **Create an Account:**
Register for an account by providing your name, email, and a secure password.
- **Receive Welcome Email:**
Upon successful registration, you will receive a welcome email containing a hyperlink to scan a QR code.
- **Scan QR Code:**
Use your Google Authenticator app to scan the QR code provided in the welcome email.
- **Traditional Login:**
Initiate your first login using the Traditional Login API.
- **TFA Login:**
For enhanced security, perform a TFA login using the access token obtained from the Traditional Login API and the code displayed in your Google Authenticator app.
- **Access API Endpoints:**
Congratulations! You are now logged in and can seamlessly utilize any available APIs without encountering unauthorized errors.
- **Handle Unauthorized Access:**
Ensure both Traditional Login and TFA Login are completed to avoid unauthorized errors.
- **Account Management:**
View and update your account details or log out of your session using the provided APIs.
- **Enable/Disable TFA:**
To enhance or adjust security settings, use the Update API with tfa_status set to false to disable TFA or true to enable it. Note that switching this setting will automatically log you out.
- **QR Code Registration:**
Upon enabling TFA, you will receive an email with instructions to scan a QR code and register your account.
- **TFA Disable:**
When TFA is disabled, you can access other APIs using only the token obtained from the Traditional Login API.
- **Logout Manually:**
Remember to manually log out if you wish to end your session.

## APIs Overview
### Create API

**Endpoint:** POST /account/register

**Description:** Create a new account with the specified details.

**Request Body:**

```json
{
  "name": "Tedd",
  "email": "tedd@gmail.com",
  "password": "Qwertyiop12!",
  "password_confirmation": "Qwertyiop12!"
}
```


### Traditional Login API

**Endpoint:** POST /auth/init_login

**Description:** Authenticate using traditional email and password.

**Request Body:**
```json
{
  "email": "tedd@gmail.com",
  "password": "Qwertyiop12!"
}
```
**Response Body:**
```json
{
  "token": "token_hash",
  "exp": "MM-DD-YYYY 21:00"
}
```


### TFA Login API
**Endpoint:** POST /auth/tfa_login

**Description:** Authenticate using TFA with OTP.

**Headers:** *"token"* from Traditional Login API.

**Request Body:**
```json
{
  "mfa_code": "123456" // OTP from Google Authenticator
}
```


### Show API

**Endpoint:** GET /account/

**Description:** Retrieve account details.

**Headers:** *"token"* from Traditional Login API.

**Response Body:** Account information in JSON format.


### Update API

**Endpoint:** PUT/PATCH /account

**Description:** Update account details (e.g., enable or disable TFA, change name, or password).

**Headers:** *"token"* from Traditional Login API.

**Request Body:**
```json
{
  "tfa_status": true // Only tfa_status, name, and password can be changed
}
```


### Logout API

**Endpoint:** DELETE /auth/logout

**Description:** Log out the account.

**Headers:** *"token"* from Traditional Login API.
