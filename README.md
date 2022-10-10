# Zenodotus (Ζηνόδοτος)

Zenodotus is an archive system for media that has been fact checked to provide durable, long-term storage for research purposes primarily. The project is named after [Zenodotus](https://en.wikipedia.org/wiki/Zenodotus), the first superintendent of the Library of Alexandria and the man credited with inventing the first tagging system.

Additional documentation can be found in the `/docs` folder.

## Setup

### Prerequisites

There are a few prerequisites that you need on your machine to run this system. All of this was designed for macOS, though any Linux distribution should be pretty similar. As for Windows, I have no idea, though @oneroyalace may be able to help with that. (I imagine the answer is WSL.)

Things we need to install include (steps below for all this):

- Homebrew (for macOS, or other package manager for other systems)
- Ruby (see [/.ruby-verison](.ruby-version) for the current version)
- Chrome (latest version)
- PostgreSQL (13 or higher)
- Redis
- ChromeDriver
- ffmpeg
- vips
- Yarn (v1) for JavaScript linting only

#### Homebrew

A package manager for macOS similar to Apt or Yum in the Linux world. You'll want this if you don't have it because it makes installing the other prereqs SUPER easy. Install it from [here](https://brew.sh).

**Note:** You may have to install the Xcode Command Line Tools for macOS: `xcode-select --install`.

#### Ruby

The version of Ruby installed by your operating system, or available through standard package managers, is probably out of date and doesn't support multiple versions of Ruby on a single machine. To remedy both problems, we recommend using a Ruby version manager. Once installed, make sure to use the version of Ruby indicated in [/.ruby-version](.ruby-version).

##### ✅ [rbenv](https://github.com/rbenv/rbenv)

**This is our recommended Ruby version manager.** It's lightweight, well maintained, and works pretty flawlessly.

**Note:** One of the Gems used in this project, `dhash-vips`, uses Ruby source files to speed up image similarity processing. To ensure that rbenv stores the Ruby source files locally, use the `--keep` flag when installing a new Ruby version. E.g. `rbenv install 3.0.2 --keep`. (Note that you would actually use the command `rbenv install --keep` while in the project root, and rbenv would pick up the correct version number from `./ruby-version` automatically.)

##### [RVM](https://rvm.io)

This is the classic Ruby version manager. Many developers have moved on to rbenv, but RVM continues to work perfectly fine, if a little heavier than rbenv.

##### ❌ [chruby](https://github.com/postmodern/chruby)

**Don't use this one.** For the most part, it's both too complex and too difficult, and it's probably not what you're actually looking for if you're reading this section anyways.

##### [ASDF](https://github.com/asdf-vm/asdf)

A version manager for multiple programming languages. Some people like it so you don't have to use multiple different managers on your machine. The Ruby plugin for it is [here](https://github.com/asdf-vm/asdf-ruby). I've never used it myself, but it's well maintained and I've heard good things.

#### Chrome

Well, if you don't have this already I'm not sure what to tell you.

#### PostgreSQL (13 or higher)

**macOS:**

You can download it from [here](https://www.postgresql.org/download/) for your system. Personally, if you can, just use the desktop [version](https://postgresapp.com/) so you don't accidentally have a database running 24/7 in the background. Keep the default credentials unless you know what you're doing, this is just development so we don't care about security and the like. Should you happen to change the credentials, you'll need to update the default rails db settings in `./config/database.yml` (and avoid committing the changes).

If `pg_config` isn't already in your `PATH`, locate it (try looking in `/Library/PostgreSQL/{version_#}/bin`) and add it so the `pg` gem can install properly.

**Ubuntu:**

Postgresql 13 can be downloaded using `apt`. To do so, add the Postgres APT repository to your machine, then download/install the packages listed below.

```shell
sudo apt -y install bash-completion wget
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install postgresql-13 libpq-dev
```

If you'd like to use Postgres without a password, you'll need to update your `pg_hba.conf` file to `trust` local users. See [here](https://dba.stackexchange.com/questions/83164/postgresql-remove-password-requirement-for-user-postgres) for instructions.

#### Redis

[Redis](https://redis.io/) backs Sidekiq and Action Cable, and a Redis server will need to be running on your machine while using the scraping portions of the app.

- **macOS:**: `brew install redis`

**Ubuntu:**

On Ubuntu 18.04, the `yarn` keyword is associated with another tool, `cmdtest`. To get the desired Yarn,

```shell
sudo apt remove cmdtest
sudo apt remove yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
```

#### ChromeDriver

Used for scraping.

- **macOS:** `brew install --cask chromedriver`
- **Ubuntu:** `sudo apt-get install chromium-driver`

#### ffmpeg

ffmpeg is a video processing library. It's used on that Mars helicopter and at YouTube, so it's fine. We need to install it to process previews for videos.

- **macOS:** `brew install ffmpeg`
- **Ubuntu:** `sudo apt-get install ffmpeg`

#### vips

A faster image manipulation library than ImageMagick.

- **macOS:** `brew install vips`

#### [Yarn](https://classic.yarnpkg.com)

An open-source JavaScript package manager used to install/manage JavaScript dependencies. We only use it for installing development dependencies, specifically ESLint for linting our JavaScript. **We do not install Node packages for use in the app itself.** Instead, we use the Rails 7+ preference for [importmaps](https://github.com/rails/importmap-rails).

**Note:** Yarn went through a significant architectural change in v2, while we continue to use the "classic" v1.

### Installation

1. Install all the prerequisites, including the version of Ruby indicated in [/.ruby-version](.ruby-version), ensuring Ruby source files are stored locally (`--keep`)
1. Clone this repo: `git clone https://github.com/TechAndCheck/zenodotus`
1. Navigate into the project folder `cd zenodotus` (or whatever)
1. Optional: If you intend to develop the [birdsong](https://github.com/cguess/birdsong) and [zorki](https://github.com/cguess/zorki) Gems, clone them to a separate location and update the Zenodotus [./Gemfile](Gemfile) to point to the local instances
1. Install all the Gems: `bundle install` (this may take a few minutes)
1. Make sure Postgres is running
1. Set up the database: `rails db:create && rails db:setup`
1. Set up your environment variables:
   1. For local development, `touch config/application.yml` and ask another developer for the config values
   1. For production, make sure the environment variables are set properly
1. Add the following entries to your `/etc/hosts` file:
   ```
   127.0.0.1	www.factcheckinsights.local
   127.0.0.1	vault.factcheckinsights.local
   ```
1. Bootstrap Tailwind: `rails assets:precompile`
   - This is only necessary as long as we're including Tailwind, as our application CSS is bundled using the standard asset pipeline
1. In your shell, run `rails s`

✨ The app should now be running and available at [http://www.factcheckinsights.local:3000](http://www.factcheckinsights.local:3000) (Insights) and [http://vault.factcheckinsights.local:3000](http://vault.factcheckinsights.local:3000) (MediaVault). If not, contact @cguess or another developer.

#### Starting the scraper

If you plan to do anything that will trigger the scraper, such as **archiving a new URL** or checking the status of jobs, you will also need to fire up Redis and Sidekiq:

1. Make sure Redis is running (e.g., `redis-server` from anywhere on your system)
1. Start Sidekiq from the project directory: `sidekiq`

### Optional: tmux

Personally, I love [tmux](https://github.com/tmux/tmux), it allows you to have multiple consoles while being able to hide and bring them back, tile them, automate stuff, it's just awesome. You can easily install it through most package managers like `brew install tmux` (for Homebrew) or `sudo apt-get install tmux` (for Debian/Ubuntu and the like).

The reason this is mentioned here is because this repo is set up to use [tmuxinator](https://github.com/tmuxinator/tmuxinator), a tmux manager that lets you script setup windows, panes and the like. If you decide to use `tmuxinator`,

If you want to use this (I recommend it) do the following:

1. Install tmux, see above
1. Duplicate the `.tmuxinator.yml.example` file in the root directory of this projects
1. Rename the new file removing the `.example` at the end of the filename (do not commit the new one)
1. Change the `root` key in `tmuxinator.yml` to reflect the project's path on your machine
1. Make sure you ran `bundle install` when setting the project up in the first place
1. Run `tmuxinator` on the command line, and you should see everything pop up and start running properly.

## Notes on tech used

We use mostly a standard Rails stack, with a few new things that are generally recommended by the Rails core team.

- We have converted to the Rails 7+ [importmap](https://github.com/rails/importmap-rails) lifestyle for JavaScript assets
- We use [StimulusJS](https://stimulus.hotwired.dev) for our JavaScript
- We use [Turbo](https://turbo.hotwired.dev) for all the page load stuff
- We use [Sorbet](https://sorbet.org) to add type-checking to our Ruby and prevent a bunch of runtime bugs early
- We use [Rubocop](https://rubocop.org) for linting

## Development

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for additional development setup instructions.

## License

See [LICENSE](./LICENSE) for the terms governing this software.
