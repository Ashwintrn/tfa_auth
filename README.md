# tfa_auth - Two-Factor Authentication (TFA) App
tfa_auth is a Rails application that demonstrates the implementation of two-factor authentication (TFA) using Google Authenticator. The app provides both traditional password-based authentication and TFA one-time password (OTP) authentication for enhanced security.

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
