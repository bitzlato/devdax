# Manage the transit secrets engine
path "transit/keys/*_*" {
  capabilities = ["create", "read", "list"]
}
# Encrypt Payment Addresses secrets
path "transit/encrypt/*_payment_addresses_*" {
  capabilities = ["create", "read", "update"]
}
# Decrypt Payment Addresses secrets
path "transit/decrypt/*_payment_addresses_*" {
  capabilities = ["create", "read", "update"]
}
# Decrypt wallets secrets
path "transit/decrypt/*_wallets_*" {
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
# Renew tokens
path "auth/token/renew" {
  capabilities = ["update"]
}
# Lookup tokens
path "auth/token/lookup" {
  capabilities = ["update"]
}
