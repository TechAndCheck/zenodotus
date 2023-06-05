# Adding A New Domain Type
*Prepared by: Christopher Guess (@cguess)*

## Purpose
When a new domain type is found we must add it across numerous repositories. This facilitates doing that without losing track of where it should go.

Since there are multiple checks for domains this touches a bunch of places

## Steps
- [ ] Make sure the example URL you're adding the type of isn't taken down or anything

*If Facebook*
_Note: `Forki` doesn't actually check for the domain it just takes whatever you give it._
- [ ] In the `Forki` repo create a branch for new changes
- [ ] Add a test in `forki/test/post_test.rb` for the new domain style in `test_various_domain_types`
- [ ] Make sure the tests pass, otherwise modify the scraper until it does
- [ ] Bump the version of the gem in code
- [ ] Create a PR
- [ ] After the PR is accepted merge into master and `rake release` the gem

*If Instagram*
- [ ] In the `Zorki` repo create a branch for new changes
- [ ] Add a test in `zorki/test/post_test.rb` for the new domain style
- [ ] Make sure the tests pass, otherwise modify the scraper until it does
- [ ] Bump the version of the gem in code
- [ ] Create a PR
- [ ] After the PR is accepted merge into master and `rake release` the gem

*If Twitter*

*If YouTube*

- [ ] Hypatia
  - [ ] Create branch for new changes
  - [ ] Open `test/media_sources/media_source_test.rb`
  - [ ] In the test `test_urls_return_valid_media_source` add an example of the url type
        you're adding ensuring the model you want returned is correct
  - [ ] Run `rails test `test/models/media_source_test.rb`` to make sure the test fails

  *If Facebook*
  - [ ] Bump the version of Forki in the Gemfile
  - [ ] `bundle update forki` to install the update
  - [ ] Open `app/media_sources/facebook_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  *If Instagram*
  - [ ] Open `app/media_sources/instagram_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  *If Twitter*
  - [ ] Open `app/media_sources/twitter_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  *If YouTube*
  - [ ] Open `app/media_sources/youtube_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  **Continue from Here**
  - [ ] Run `rails test `test/models/media_source_test.rb`` to make sure the test passes
  - [ ] Assure that the test passes, if not, review your work
  - [ ] File a pull request with the changes


- [ ] Zenodotus
  - [ ] Create branch for new changes
  - [ ] Open `test/models/archive_item_test.rb`
  - [ ] In the`test "Submitting various URLs returns the correct model type"` add an example
        of the url type you're adding ensuring the model you want returned is correct
  - [ ] Run `rails test `test/models/archive_item_test.rb`` to make sure the test fails
  - [ ] Continue to the section for the type of domain you're adding

  *If Facebook*
  - [ ] Open `app/media_sources/facebook_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  *If Instagram*
  - [ ] Open `app/media_sources/instagram_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  *If Twitter*
  - [ ] Open `app/media_sources/twitter_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  *If YouTube*
  - [ ] Open `app/media_sources/youtube_media_source.rb`
  - [ ] Edit `def self.valid_host_name`
  - [ ] Add the domain to the array

  **Continue from Here**
  - [ ] Run `rails test `test/models/archive_item_test.rb`` to make sure the test passes
  - [ ] Assure that the test passes, if not, review your work
  - [ ] File a pull request with the changes
