Prop
===
![Peg Leg Bates Photo](https://raw.github.com/NathanielWroblewski/prop/master/app/assets/images/peg-leg-bates.jpg)

Description
---
Prop is a Rails 4 template with customized defaults and an opinionated workflow.

Installation
---
First, clone the repo, and name your app.
```bash
git clone https://github.com/NathanielWroblewski/prop.git <name of your app here>
cd <name of your app here>
```
Bundle to install the dependencies.
```bash
bundle
```
Open four tabs in your terminal.  In the first, start [zeus](https://github.com/burke/zeus).
```bash
zeus start
```
Zeus pre-loads your Rails app making specs, rake tasks, and generators run much faster.  Common tasks run through zeus include:
```bash
zeus g migration <name of migration>
zeus d migration <name of migration>
zeus rake db:create
zeus rake db:migrate
zeus rake db:test:prepare
zeus c
zeus s
```
In general, anything that would normally be `rails blah` is now `zeus blah`, and anything that would be `rake blah` is now `zeus rake blah`.  Ctrl+c will exit.

In the next tab, start the zeus server.
```bash
zeus s
```
Use Ctrl+c to exit.

In the third tab, run [guard](https://github.com/guard/guard).
```bash
guard
```
Guard watches your spec files so that anytime you make a change, your specs will run.  You can also hit your enter/return key to run all your specs.  `exit` will exit guard.

I use the final tab as my normal terminal window/git branching/for entering `zeus c` when necessary.

Finally, create your database.

```bash
zeus rake db:create
```

Workflow
---
At a high level, have a `production` branch, a `master` branch for staging, and your development branches which are prefixed with your initials.  Use continuous integration/continuous deployment so that when you push to master, your tests are run and your app is deployed to staging.  When you push to production, your tests are run and the app is deployed to production.  Rollbar is used to monitor errors, and Codeship is used for CI.  The following git practices were inspired by [Thoughtbot](http://www.thoughtbot.com/)'s [protocol](https://github.com/thoughtbot/guides/tree/master/protocol).

1. Start a story in Pivotal Tracker (http://www.pivotaltracker.com) by clicking the 'start' button of a story assigned to you.

2. Create a new branch with
```bash
$ git checkout -b <your initials>-<name of branch>
```
  For example:
```bash
$ git checkout -b nw-promo-codes
```

3. After changing files, stage your changes
```bash
$ git status
$ git add <changed file>
```

4. Commit your changes with a commit message that is under 80 characters
```bash
$ git commit -m '<commit message>'
```

5. If you have multiple, smaller commits that could be grouped into a larger commit, check the log to see how many commits you need to group together and then rebase them.
```bash
$ git log
$ git rebase -i HEAD~<the number of commits to be rebased>
```
  For example:
```bash
$ git rebase -i HEAD~3
```

  Note: The syntax is HEAD followed by a tilde (~) not a dash (-)

  You will receive a message like this:
```bash
pick 95f08f0 <commit message>
pick 09d7d95 <commit message>
pick c86dd4e <commit message>
# Rebase 665d9f8..c86dd4e onto 665d9f8
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
```

  Change the 'pick' to the appropriate command.  In general, the top commit will receive an 'r' while the following commits will be fixed up with an 'f':
```bash
r 95f08f0 <commit message>
f 09d7d95 <commit message>
f c86dd4e <commit message>
# Rebase 665d9f8..c86dd4e onto 665d9f8
#
# Commands:
#  p, pick = use commit
#  r, reword = use commit, but edit the commit message
#  e, edit = use commit, but stop for amending
#  s, squash = use commit, but meld into previous commit
#  f, fixup = like "squash", but discard this commit's log message
#  x, exec = run command (the rest of the line) using shell
```

  You will then be prompted to rename the commit message.  The commit message should be assigned the Pivotal Tracker story id, followed by an 80 character commit message title, and an optional '*' delimited log of more detailed changes.

  Generally, it should follow the form:
  
  ```
  [#<Pivotal Tracker Story ID>] <80-character commit message>
  
  * <detailed commit message>
  * <detailed commit message>
  ```

  For example:
  ```
  [#12345678] Added a new kit page
  
  * Generated a new kit controller
  * Generated a new kit migration
  ...
  ```

6. If you have not yet pushed, or you didn't squash any commits or otherwise change history, you can leave off the `-f` flag on the following push.  Otherwise, the branch you are working on should then be force pushed to change history.  Then, open a pull request.
```bash
$ git branch
$ git push origin <branch name> -f
```

  For example:

  ```bash
  $ git push origin nw-promo-codes -f
  ```

  A pull request can be made by visiting your github repo, selecting your branch name from the drop down, selecting the pull request icon, and then selecting the button to make a pull request.

7.  When your pull request has been accepted, you should be sure to fetch the lastest master, and rebase master under your latest commit.  Then force push to your branch to change history.
```bash
$ git fetch
$ git rebase origin/master
$ git push origin <name of branch> -f
```

  If you have conflicts, be sure to continue the rebase after resolving the conflicts.  Do not commit.
  ```bash
  $ git status
  $ git add <file after resolving conflicts>
  $ git rebase --continue
  ```

8. Then, checkout master, pull the latest changes, and merge your branch into master only if there will not be a merge conflict.
```bash
$ git checkout master
$ git pull origin master
$ git merge <name of branch> --ff-only
```
  For example:
  ```bash
  $ git merge nw-promo-codes --ff-only
  ```

9. Now push your changes and delete your branch locally and remotely.
```bash
$ git push origin master
$ git branch -d <name of branch>
$ git push origin :<name of branch>
```
  For example:
```bash
$ git branch -d nw-promo-codes
$ git push origin :nw-promo-codes
```

10. Mark your story in Pivotal Tracker as finished.

11. Once codeship has verified the tests pass, checkout your changes on staging on Heroku.

12.  If your changes have been tested on staging, mark your story as delivered in Pivotal.

13.  Once your story has been accepted and if it is time to push to production, checkout the production branch, merge master into it, and push your changes.
```bash
$ git checkout production
$ git merge master --ff-only
$ git push origin production
```

14.  Once codeship has verified the tests pass, checkout your changes at on production.  Monitor rollbar for any errors that may be occurring.






