# User instructions

## GitHub CLI authentication

The GitHub token is stored at `$HOME/.config/github/github-token`.

For authenticated GitHub CLI commands, use:

```bash
GH_TOKEN="$(cat "$HOME/.config/github/github-token")" gh ...
```

Read the token only to pass its value directly to the `gh` command for
authentication, using the command-scoped `GH_TOKEN` assignment shown above.
Never read its value into tool output or model context, print or log it, copy it
into files, store it in an intermediate variable, export it for the shell session,
or pass it to any other command or service.
