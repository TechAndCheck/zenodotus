# Development

## Environment Setup

### Hosts

This app serves two sites (Fact-Check Insights and MediaVault), each on their own subdomain. To dynamically serve the correct experience, you should no longer access the site via `http://localhost`, but via a locally-routed domains rooted at `factcheckinsights.local`.

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
- `FACT_CHECK_INSIGHTS_URL`, e.g. `http://www.factcheckinsights.local:3000`
- `MEDIA_VAULT_URL`, e.g. `http://vault.factcheckinsights.local:3000`

Optional
- `USE_S3_DEV_TEST` If set to `"true"` (the string) the software will use S3 as a storage backend
  exactly the same as in production (except the bucket is set to clear itself every 24 hours).
  If set you will be required to also set `AWS_ACCESS_KEY` and `AWS_ACCESS_SECRET`


### Linters

We use two linters to insure that all code looks and acts the same. These enforeced styles may be different
than what you're used to, and if you have questions please ask. However, until the changes are agreed by
most of us, please use the linting rules already included in this repo and if you feel the need to add,
change, or remove please open an issue first.

#### Javascript

For this project, we'll use [ESLint](https://eslint.org/). This is an extremely powerful project, but we
will only use its checking and highlighting for the moment.

##### Setup Instructions

General setup instructions are here, followed by editor-specific additional steps.

1. Install ESLint `yarn global add eslint` (this installs globally, which is probably fine)

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

## Ongoing Issues

### Flowbite + Turbo

We use the Tailwind CSS component library [Flowbite](https://flowbite.com/) for some UI elements. Flowbite's JavaScript library currently relies on the `DOMContentLoaded` event for initalization. In our [Turbo](https://turbo.hotwired.dev/) environment, this is a problem; the Flowbite behavior is only applied on initial pageload, and then disappears after the first Turbo navigation. (This is a [known issue](https://github.com/themesberg/flowbite/issues?q=is%3Aissue+is%3Aopen+domcontentloaded).)

We resolve this with the method suggested [here](https://github.com/themesberg/flowbite/issues/88): we patch Flowbite using the [patch-package](https://github.com/ds300/patch-package) package to replace `DOMContentLoaded` with `turbo:load`. This occurs as a `postinstall` Yarn script in `package.json`; every time Yarn installs Flowbite, it immediately patches it with our patchfile.

This does mean, of course, that our patchfile will have to be updated anytime Flowbite is. (As of 2022-04-27, we haven't lived this out, so the information below could change after we've experienced an update. I'm hoping patch-package recognizes the diff won't work and notifies us that the patchfile needs updating rather than a more silent and invisible failure.)

**What this means for you:** First, just be aware this is happening. Second, if you update Flowbite, be prepared to patch it as described below. Third, remain uncomfortable with this solution to ensure you still have good instincts.

#### How to update the patchfile

When we do update Flowbite, here's how to generate a new patchfile:

1. Update Flowbite
1. Open `flowbite.js` (currently at `{repo}/node_modules/flowbite/dist/flowbite.js`)
1. Change all `DOMContentLoaded` references to `turbo:load` and save
1. Run `patch-package flowbite`
   - ⚠️ This may have to be invoked as `npx patch-package flowbite`
1. Run/test the app to ensure Flowbite-provided elements still work; be sure to navigate to new pages
1. Commit the resulting patchfile in `{repo}/patches/` to the repo

#### When can we stop doing this?

Great question! We have to keep doing this until Flowbite natively initializes in a way that survives Turbo page navigation. Let's keep an eye out for that update.
