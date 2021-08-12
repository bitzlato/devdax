# View the kv v2 data
path "secret/data/*/*" {
  capabilities = ["read", "list"]
}

# View the kv v2 metadata
path "secret/metadata/*/*" {
  capabilities = ["read", "list"]
}

# Manage the transit secrets engine
path "transit/keys/*_kaigara_*" {
  capabilities = ["create", "read", "list", "update"]
}

# Encrypt secrets data
path "transit/encrypt/*_kaigara_*" {
  capabilities = ["create", "read", "update"]
}

# Decrypt secrets data
path "transit/decrypt/*_kaigara_*" {
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
