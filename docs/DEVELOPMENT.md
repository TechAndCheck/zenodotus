# Development

## Environment Setup

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

We have a `pre-commit` githook that will enforce RuboCop style compliance. To install it, copy `githooks/pre-commit' into `.git/hooks/` and `chmod +x` the copied file. 

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
