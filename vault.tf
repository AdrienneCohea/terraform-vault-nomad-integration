data "vault_policy_document" "nomad_server" {
  rule {
    path         = "/auth/token/create/nomad-server"
    capabilities = ["create", "read", "update"]
    description  = "Create tokens with the role"
  }

  rule {
    path         = "auth/token/roles/nomad-server"
    capabilities = ["read"]
    description  = "Read the role"
  }

  rule {
    path         = "auth/token/revoke-accessor"
    capabilities = ["update"]
    description  = "Revocation by accessor"
  }

  rule {
    path         = "consul/creds/nomad-server"
    capabilities = ["read"]
    description  = "Obtain a Consul ACL"
  }

  rule {
    path         = "/gcp/roleset/*/token"
    capabilities = ["create", "read", "update"]
    description  = "Create OAuth 2 tokens for any GCP roleset"
  }

  rule {
    path         = "/gcp/roleset/*/key"
    capabilities = ["create", "read", "update"]
    description  = "Create service account keys for any GCP roleset"
  }
}

resource "vault_policy" "nomad_server" {
  name   = "nomad-server"
  policy = data.vault_policy_document.nomad_server.hcl
}

resource "vault_token_auth_backend_role" "nomad_server" {
  role_name        = "nomad-server"
  allowed_policies = ["nomad-server"]
  orphan           = true
  renewable        = true
  token_period     = 24 * 60 * 60
}
