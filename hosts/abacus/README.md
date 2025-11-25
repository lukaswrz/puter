# abacus

## Managing ntfy

### Create a User

```bash
ntfy user add --role=admin someuser
```

Replace someuser with your desired username.
The `--role=admin` flag is optional but grants administrative privileges.

Set a password when prompted.

### Assign Permissions

To allow a user to only subscribe to UnifiedPush topics:

```
ntfy access someuser 'up*' read-only
```

To allow a user to subscribe and publish to all topics (including UnifiedPush):

```
ntfy access someuser '*' read-write
```

### Allow UnifiedPush Notifications

To ensure apps can send notifications via UnifiedPush, make UnifiedPush topics (which start with up\*) writable by anyone:

```
ntfy access '*' 'up*' write-only
```
