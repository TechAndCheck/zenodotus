# Zenodotus (Ζηνόδοτος)
Zenodotus is an archive system for media that has been fact checked to provide durable, long-term storage for research purposes primarily. The project is named after [Zenodotus](https://en.wikipedia.org/wiki/Zenodotus), the first superintendent of the Library of Alexandria and the man credited with inventing the first tagging system.

Additional documentation can be found in the `/docs` folder.

## Setup

### Requirements
There's a few prereqs that you need on your machine to run this system. All of this was designed for MacOS, though any Linux distribution should be pretty similar. As for Windows, I have no idea, though @oneroyalace may be able to help with that (I imagine the answer is WSL).

Things we need to install include (steps below for all this):
- Homebrew (for MacOS)
- Ruby (3.0.1 as of writing, but check in [/.ruby-verison](.ruby-version) for the most up to date version)
- Chrome, whatever version is newest
- Postgresql 13
- Yarn (1.22.10 as of writing)
- Chromedriver

#### Homebrew
A package manager for MacOS similar to Apt or Yum in the Linux world. You'll want this if you don't have it because it makes installing the other prereqs SUPER easy. Install it from [here](https://brew.sh).

#### Ruby
The version of Ruby that comes installed on your system, or can be installed through a package manager (Yum, Apt, Homebrew etc) are almost certainly out of date. It also means you can't use multiple versions on the same device. So instead, we use a specific Ruby version manager. There's a few of these out there.

Follow the instructions in any of the repos to properly install it. Make sure to install the version indicated in [/.ruby-verison](.ruby-version).

##### [Rbenv](https://github.com/rbenv/rbenv)
*This is the one I (@cguess) use.*
It's lightweight, well maintained, and works pretty flawlessly.

##### [RVM](https://rvm.io)
This is the classic one. Most people I know have moved on to Rbenv, but it works perfectly fine, if not a little heavier than Rbenv is.

##### [Chruby](https://github.com/postmodern/chruby)
Don't use this one, for the most part, it's both too complex and too difficult and probably not what you're actually looking for if you're reading this section anyways.

##### [ASDF](https://github.com/asdf-vm/asdf)
A version manager for multiple programming languages. Some people like it so you don't have to use multiple different managers on your machine. The Ruby plugin for it is [here](https://github.com/asdf-vm/asdf-ruby). I've never used it myself, but it's well maintained and I've heard good things.

#### Chrome
Well, if you don't have this already I'm not sure what to tell you.

#### Postgresql 13
Mac:

You can download it from [here](https://www.postgresql.org/download/) for your system. Personally, if you can, just use the desktop [version](https://postgresapp.com/) so you don't accidentally have a database running 24/7 in the background. Keep the default credentials unless you know what you're doing, this is just development so we don't care about security and the like. Should you happen to change the credentials, you'll need to update the default rails db settings in `./config/database.yml` (and avoid committing the changes).

If `pg_config` isn't already in your `PATH`, locate it (try looking in `/Library/PostgreSQL/{version_#}/bin`) and add it so the `pg` gem can install properly.

Ubuntu:

Postgresql 13 can be downloaded using `apt`. To do so, add the Postgres APT repository to your machine, then download/install the packages listed below.
```shell
sudo apt -y install bash-completion wget
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install postgresql-13 libpq-dev
```

If you'd like to use Postgres without a password, you'll need to update your `pg_hba.conf` file to `trust` local users. See [here](https://dba.stackexchange.com/questions/83164/postgresql-remove-password-requirement-for-user-postgres) for instructions

#### Yarn
An open-source Javascript package manager used to install/manage Webpack and some other package dependencies

On Ubuntu 18.04, the `yarn` keyword is associated with another tool, `cmdtest`. To get the desired Yarn,
```shell
sudo apt remove cmdtest
sudo apt remove yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
```

#### Chromedriver

Used for scraping.

Mac: `brew install --cask chromedriver`

Ubuntu: `sudo apt-get install chromium-driver`

#### FFMPEG
FFMPEG is a video processing library. It's used on that Mars helicopter and at YouTube, so it's fine.
We need to install it to process previews for videos.

MacOS: `brew install ffmpeg`

Ubuntu: `sudo apt-get install ffmpeg`

## Setup Steps
*Note: this is a first pass, there may be odd errors since I wasn't on a pristine box when I wrote it. Please message @cguess with any error messages, it's probably missing dependencies.*

1. Install all the prereqs including the latest Ruby version
1. Clone this repo `git clone https://github.com/TechAndCheck/zenodotus`
1. Clone the [birdsong](https://github.com/cguess/birdsong) and [zorki](https://github.com/cguess/zorki) repos elsewhere.
1. Navigate into the project folder `cd zenodotus` (or whatever)
1. If you'd like to use local versions of `birdsong` and `zorki`, update their respective paths in the `Gemfile`. 
1. Install all the gems `bundle install`. This may take a few minutes
1. Make sure Postgres is running
1. Set up the database: `rails db:create && rails db:setup`
1. Open two terminal windows up
1. In one, run `./bin/webpack-dev-server`
1. In another, run `rails s`

You should everything booting up now. Try to hit up [http://localhost:3000](http://localhost:3000) to make sure it's up. If that doesn't work, contact @cguess.

### Tmux
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
We use mostly a standard Rails set, with a few new things that are generally recommended by the Rails core team.

- Our css is in [TailwindCSS](https://tailwindcss.com)
- We use [StimulusJS](https://stimulus.hotwire.dev) for our javascript
- We use [Turbo](https://turbo.hotwire.dev) for all the page load stuff
- [Sorbet](https://sorbet.org) is used to add type checking to our Ruby and prevent a bunch of run time bugs early.
- For linting we use [Rubocop](https://rubocop.org), this makes sure our code lines up

## Development

See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for setup instructions












