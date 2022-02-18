# Contributing

We use GIT for all of our code repositories, with some specifics around how to label stuff and the like. Please follow the steps below, as it makes it so it's easier for everyone on the team to know what's going on the whole time.

## Branching

All new work should be done on branches. Seriously, do not push directly to `master` or else bad things will happen to you and everyone else.

All branches should relate to an issue created in the GitHub repo. So if you're fixing something and there's not an issue for it already, make sure to create one. All branches should have the following syntax `branch_number`-`description-of-issue`. So, for instance, if a branch is number `22` on GitHub with the name `Implement user account recovery` a valid name would be 22-user-account-recovery`. This guarantees unique branch names while being also descriptive.

## Commit Messages

Commit messages should have the following format:

Title: no more than 50 characters (keep it short)
Message: Descriptive as hell, get into it. Of course this is going to be for communications between the dev and reviewer, so if everyone is up to date on the issue you can shorten it up. However, in general, it should be descriptive of the problem (even if you have to restate the issue) and the solution, along with the reason for it.

You should tag people as needed.

## PR's

Once all your code for a feature is done create a PR from the branch in GitHub's interface. All of the formatting rules for commit messages follows the PR title and description, sort of a "master commit" message. Assign a person to the PR (usually that's you) and request a review from at least one other person.

We don't have a sign-off process aside from the standard GitHub PR structure, because it's overkill for now.


## Checklist

This is a checklist from the beginning to the end of getting a feature merged.

1. Create an issue describing the problem to be fixed
1. Make sure you're on the right branch you want to branch from `git status`. Usually this is `master`
1. Branch locally using the format described above `git checkout -b 22-user-account-recovery`
1. Make sure you're actually on the right branch `git status`
1. Do your work, committing as you go (every logical break please!)
1. When done make sure everything is added and committed
1. Create a PR from the branch, using the title and description format
1. Assign the PR to yourself, and request at least one reviewer
1. Let the reviewer know just in cases they're not staring at their GitHub notifications
1. As reviewer run tests and code coverage, along with Rubocop, making sure everything is clean
1. Reviewer and PR owner goes back and forth requesting fixes, new features etc.
1. Once approved, merge with the parent branch and delete the branch
