---
title: How to not use master as default git branch
date: 2020-06-21T00:01:30
layout: single-github
permalink: /2020/06/git-not-use-master-branch
categories:
  - git
tags:
  - git
  - devops
  - github
  - development
github_comments_issueid: 17
---

As most people will be aware, GitHub, Gitlab and Azure DevOps announced that they will change the default behaviour of their git implementations. Instead of the racially loaded `master` term they will use a more neutral branch name.<br>
That's great news I believe, but will not necessarily cover all scenarios. For example, when development begins on someone's local device.

## Git Init

Typically, when I start work on something I don't straight away go and create a new repository on any of the platforms but I create a directory on my laptop and then execute `git init` inside that folder. This causes git to create the scaffolding for this new repo, including a pointer for `master` branch.<br>
This branch is not actually created at this point. Only when a user goes and commits for the first time does this `master` branch get created.<br>
Usually, I also don't focus too much on the branch but go straight into writing code or documentation and commit, and then notice that I was still on `master`.

## Git Alias

This not so well-known fact is one I'm going to use to never have to worry about `master` again but from this moment forward will always use `main` as my default branch (and all repositories created by [XIRUS](https://xirus.com.au){:target="_blank"} for that matter).<br>
Git supports [aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases){:target="_blank"} if you weren't aware and they're easy to configure. For global aliases that apply to all repositories ever on your machine you execute something like this:

```bash
git config --global alias.co checkout
```

Now, whenever you type `git co` you will actually do `git checkout`, much nicer.<br>

> I have not been able to overwrite built-in commands like `init`.

## Main as default git branch

The following git alias will cause git to always create new repositories with the first branch name being `main` instead of `master`:

`git config --global alias.init2 '! git init && git checkout -b main'`

As I mentioned, I have not been able to overwrite built-in commands, so I opted to use `init2` as the alias. Executing `git init2` will now create git repositories exactly as I want.

[![git init](/media/2020/06/git-init2.png)](/media/2020/06/git-init2.png)