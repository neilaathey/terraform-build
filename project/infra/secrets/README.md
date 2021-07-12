# Project-Wide Secret Management

This provides a way of configuring project-wide secrets and centralised
access control. This will create the secrets in Secret Manager without 
any versions. You will still need to add a version manually once it has
been deployed.

When creating a secret, you'll need to consider whether or not the IAM policy
should be centralised or not. Use cases for each one:

- Centralised: A list of pre-defined users to access the key. e.g. Data analysts
  accessing a set of credentials
- De-centralised: Typically targeted for Service Account access. Common 
  credentials used by multiple resources. e.g. Service account accessing an
  API key

For each key value pair, the key will act as the secret name, the value will
consist of a description and accessors:

```yaml
  <SECRET_NAME>: # Secret name should confirm to lowercase snake-case ([a-z0-9_]*)
    accessors: # Optional. list of users/groups:
    - user:<USER EMAIL ADDRESS>
    - group:<GOOGLE GROUP EMAIL ADDRESS>
    description: <DESCRIPTION> # Mandatory. What the key is for? Format? Who manages? Additional Informsyion 
```

## Example usage

```yaml
...
secrets:
  secret_key_1_centralised:
    accessors:
     - user:some-user@itv.com
     - group:some-group@itv.com
    description: |
      Some multi-line description here
  secret_key_2_de_centralised:
    description: |
      Some multi-line description here
...
```

And for de-centralised IAM in a different deployment, use:

```
resource "google_secret_manager_secret_iam_member" "member" {
  project   = var.project_id
  secret_id = "secret_key_2_de_centralised"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:my-app@appspot.gserviceaccount.com"
}
```