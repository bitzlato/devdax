# Manage the kv v2 data
path "secret/data/*/*" {
  capabilities = ["create", "read", "list", "update"]
}

# Manage the kv v2 metadata
path "secret/metadata/*/*" {
  capabilities = ["create", "read", "list", "update"]
}

# Manage the transit secrets engine
path "transit/keys/*_kaigara_*" {
  capabilities = ["create", "read", "list"]
}

# Encrypt secrets data
path "transit/encrypt/*_kaigara_*" {
  capabilities = ["create", "read", "update"]
}

# Decrypt Finex secrets data
path "transit/decrypt/*_kaigara_finex" {
  capabilities = ["create", "read", "update"]
}

# Decrypt Sonic secrets data
path "transit/decrypt/*_kaigara_sonic" {
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
