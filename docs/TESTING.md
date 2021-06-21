# Testing

Tests are good and can catch bugs and regressions. Test-driven development is noble and lets you design an application through tests and then write the code that passes the tests.

## Running Tests

- Run all tests: `rails test`
- Run a single test file: `rails test path/to/file.rb`

Run the full test suite at least twice on a new branch: first when branching (to see the current test state) and again before opening a PR (to make sure you didn't break anything new).

## Test Coverage

After running any test it'll output a file. You can look in here and see all the code that has been run during the tests. If you're writing new code anything checked in should have 100% test coverage (or give a VERY good reason it doesn't).
