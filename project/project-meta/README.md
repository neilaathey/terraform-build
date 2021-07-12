# Project Meta

This Terraform deployment is focused around setting up the non-functional
aspects of a GCP project. For example:

- Notification Channels
- Enabling APIs
- ...

## Pre-Requisites

- Notification Channels depends on "slack-auth-token" entry within Secret Manager

## Notification Channels

```yaml
notifications:
  channels:
    <channel-lookup-name>:
      ...
```

You can specify the following types of channels:

- Email
- Slack

For emails, the following will need to be configured:

```yaml
notifications:
  channels:
    ...
    <channel-lookup-name>:
      email_address: "<email address>"
      description: "<description for email address>"
      type: "email"
    ...
```

And for Slack:

```yaml
notifications:
  channels:
    ...
    <channel-lookup-name>:
      channel: "#<slack channel>"
      description: "<description for slack channel>"
      type: "slack"
    ...
```

By default, slack channels #bde-alert (for PROD projects)
and #bde-alert-test (for DEV and TEST projects) will be setup by default
