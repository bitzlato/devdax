# Manage the transit secrets engine
path "transit/keys/*_*" {
  capabilities = ["create", "read", "list"]
}
# Encrypt engines secrets
path "transit/encrypt/*_engines_*" {
  capabilities = ["create", "read", "update"]
}
# Encrypt blockchains data
path "transit/encrypt/*_blockchains_*" {
  capabilities = ["create", "read", "update"]
}
# Decrypt blockchains data
path "transit/decrypt/*_blockchains_*" {
  capabilities = ["create", "read", "update"]
}
# Encrypt wallets secrets
path "transit/encrypt/*_wallets_*" {
  capabilities = ["create", "read", "update"]
}
# Encrypt beneficiaries data
path "transit/encrypt/*_beneficiaries_*" {
  capabilities = [ "create", "read", "update" ]
}
# Decrypt beneficiaries data
path "transit/decrypt/*_beneficiaries_*" {
  capabilities = [ "create", "read", "update" ]
}
# Renew tokens
path "auth/token/renew" {
  capabilities = ["update"]
}
# Lookup tokens
path "auth/token/lookup" {
  capabilities = ["update"]
}
# Verify an otp code
path "totp/code/*_*" {
  capabilities = ["update"]
}
