# Development

## Environment Setup

### Hosts

This app serves two sites (Fact-Check Insights and MediaVault), each on their own unique hosts configured via the `FACT_CHECK_INSIGHTS_HOST` and `MEDIA_VAULT_HOST` env vars. For authentication to be shared between the apps, this should be on the **same domain** but on **separate (unique) subdomains**.

To dynamically serve the correct experience, you should no longer access the site via `http://localhost`, but via these custom domains. We recommend (but do not require) something like `factcheckinsights.local`, routed to localhost.

Add the following entries to your `/etc/hosts` file:
```
127.0.0.1	www.factcheckinsights.local
127.0.0.1	vault.factcheckinsights.local
```

After starting the app, you will get to Insights via `http://www.factcheckinsights.local:3000` and to Vault via `http://vault.factcheckinsights.local:3000`. (If you setup your own local reverse proxy, you can do away with the `:3000` and/or setup HTTPS, as you wish.)

### Environment variables

To run Zenodotus, you'll need to set the following environment variables. Ask a dev on the team to provide you access to them. 

- `TWITTER_BEARER_TOKEN`
- `HYPATIA_SERVER_URL`
- `HYPATIA_AUTH_KEY`
- `secret_key_base` (Devise secret)
- `KEY_ENCRYPTION_SALT`
- `FACT_CHECK_INSIGHTS_HOST`, e.g. `www.factcheckinsights.local`
- `MEDIA_VAULT_HOST`, e.g. `vault.factcheckinsights.local`
- `MAIL_DOMAIN`, e.g. `mail.factcheckinsights.org`
- `MAILGUN_API_KEY`

Optional

- `USE_S3_DEV_TEST` If set to `"true"` (the string) the software will use S3 as a storage backend
  exactly the same as in production (except the bucket is set to clear itself every 24 hours).
  If set you will be required to also set `AWS_ACCESS_KEY` and `AWS_ACCESS_SECRET`


### Linters

We use two linters to insure that all code looks and acts the same. These enforced styles may be different
than what you're used to, and if you have questions please ask. However, until the changes are agreed by
most of us, please use the linting rules already included in this repo and if you feel the need to add,
change, or remove please open an issue first.

#### JavaScript

For this project, we [ESLint](https://eslint.org/). This is an extremely powerful project, but we
will only use its checking and highlighting for the moment.

##### Setup Instructions

ESLint is only available as a Node package, and is the only reason we even use Node on this project at all.

1. `yarn install`

###### Sublime Text 4

1. Install the [PackageController](https://packagecontrol.io) plugin for Sublime, according to the [instructions](https://packagecontrol.io/installation).
1. Install the [SublimeLinter](http://www.sublimelinter.com/en/stable/) plugin using PackageManager
1. Once installed, open up the plugin settings (on a Mac) `Sublime Text Menu -> Preference -> Package Settings -> SublimeLinter -> Settings`
1. In the right panel of the window that opened add a new section at the top that looks like this,
   which tells Sumblime to look here for eslint
   ```
   {
     "linters": {
       "eslint": {
         "env": {"PATH":"/Users/user-name/.nvm/versions/node/v12.6.0/bin/"}
       }
     }
   }
   ```
1. Open a terminal window and type `which node`
1. Take the output from the previous command, remove the `/node`, and replace the value of the `env` variable
   in the settings with the path. i.e. `/Users/christopher/.nvm/versions/node/v12.6.0/bin/node`
   become `/Users/christopher/.nvm/versions/node/v12.6.0/bin/`
1. Save the file and restart Sublime

#### Ruby

To handle Ruby linting we use the industry standard [RuboCop](https://docs.rubocop.org/en/stable/).

##### Setup Instructions

General setup instructions are here, followed by editor-specific additional steps.

Good news! RuboCop should be installed by Bundler when you first set up the project. Now just to let your
editor know.

##### Githooks

We have a `pre-commit` githook that will enforce RuboCop style compliance. To install it, copy `githooks/pre-commit` into `.git/hooks/` and `chmod +x` the copied file. 

###### Sublime Text 4

1. Install the [PackageController](https://packagecontrol.io) plugin for Sublime, according to the [instructions](https://packagecontrol.io/installation). (If you haven't already)
1. Install the [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop) plugin using PackageManager.


**Note** If you're using rbenv for managing your Ruby versions (which we'd recommend) there's a few settings to change:
1. Once installed, open up the plugin settings (on a Mac) `Sublime Text Menu -> Preference -> Package Settings -> RubCop -> Settings – Default`
1. Find the line that starts with `check_for_rvm` and set it to `false`
1. Find the line that starts wiht `check_for_rbenv` and set it to `true`
1. Open a terminal window and run `which rbenv`, note the response
1. In a terminal window run `which rubocop`, note the response
1. Back in the Sublime settings replace value of the line that starts with `rubocop_command` with response from `which rubocop`
1. Replace the value of the line starting with `rbenv_path` with the response form `which rbenv`
1. Save the file and restart Sublime

TODO: Add Sorbet instructions

## Front-End Development

### CSS/Style Development

We use [SCSS](https://sass-lang.com/) for more concise and powerful CSS, and use [Tailwind](https://tailwindcss.com/) selectively for rapid iterating on front-end components.

When editing HTML markup or SCSS styles, you will need to fire up the `./bin/dev` process to ensure Tailwind and SCSS watcher are running. If you are just running `rails s`, you won't see your changes reflected.
