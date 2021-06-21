# Git Hooks

Git hooks are scripts that are automatically run at various points in the Git cycle. You can do things such as automatically format code, send notifications, etc.

We use two, a `post-commit` and `pre-commit` which do what they sound like.

## Setup

1. From the app root, copy the contents of `githooks/` (besides `README.md`) to the `.git/hooks/` directory
2. Set them all to executable: `sudo chmod 755 .git/hooks/*`

### Additional setup for the post-commit hook:

We need to be able to authenticate against Heroku so we can check what's what. To do that we're using the Heroku toolbelt, which is a CLI tool provided by Heroku.

1. Download and install the [Heroku toolbelt](https://devcenter.heroku.com/articles/heroku-cli)
2. Authenticate with either `heroku login` (opens a browser) or `heroku login -i` (directly through the CLI)

## Descriptions

### Pre-Commit

**See:** `githooks/pre-commit`

Runs the ruby linter `rubocop` against all changed files and won't let you proceed if it can't automatically fix any violations.

### Post-Commit

**See:** `githooks/post-commit`

Checks if there is a Heroku review app already set up for this branch, then gives you the web address so you don't have to log into Heroku to start testing.
