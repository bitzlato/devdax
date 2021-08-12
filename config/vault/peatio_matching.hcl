path "transit/*_*" {
  capabilities = [ "read" ]
}
# Decrypt secrets
path "transit/decrypt/*_*" {
  capabilities = [ "create", "update" ]
}
# Use key for signing
path "transit/sign/*_*" {
  capabilities = ["update"]
}
# Create transit key
path "transit/keys/*_*" {
  capabilities = ["create"]
}
# Renew tokens
path "auth/token/renew" {
  capabilities = ["update"]
}
# Lookup tokens
path "auth/token/lookup" {
  capabilities = ["update"]
}
