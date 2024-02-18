#!/bin/bash

2>&1 sqlite3 "${db}" <<EOF

.bail on

create table totp (
       "issuer",
       "account",
       "username",
       "secret_key",
       "item" generated always as (issuer || ":" || account || (case username when "" then "" else " (" || username || ")" end)) virtual,
       "alfred" generated always as (", {" || '"title": "' || item  || '", "arg": "' || secret_key || '"}') virtual,
       "otpauth" generated always as ("otpauth://totp/" || item || "?secret=" || secret_key || "&issuer=" || issuer) virtual
);

.print New OTP database created

EOF
