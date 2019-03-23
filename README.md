# lucky-realworld

[![Build Status](https://travis-ci.org/HarrisonB/lucky-realworld.svg?branch=master)](https://travis-ci.org/HarrisonB/lucky-realworld)

This is an implementation of the [realworld spec](https://github.com/gothinkster/realworld) to demonstrate how to build a backend web app using [Lucky](https://luckyframework.org/), a web framework designed to catch errors at compile-time.

Note that *this project is still in active development*!

### Setting up the project

1. [Install required dependencies](http://luckyframework.org/guides/installing.html#install-required-dependencies)
1. Run `script/setup`
1. Run `lucky dev` to start the app

### Learning Lucky

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](http://luckyframework.org/guides).


### Progress

- [x] Authentication
- [x] Registration
- [x] Get Current User
- [x] Update User
- [x] Get Profile
- [ ] Follow user
- [ ] Unfollow user
- [ ] Create Article
- [ ] List Articles
  - [ ] Filter by tag
  - [ ] Filter by author
  - [ ] Filter by user
  - [ ] Favorited by user
  - [ ] Limit number of articles (default is 20)
  - [ ] Offset/skip number of articles (default is 0)
- [ ] Feed Articles
  - [ ] Limit number of articles (default is 20)
  - [ ] Offset/skip number of articlse (default is 0)
- [ ] Get Article
- [ ] Update Article
- [ ] Delete Article
- [ ] Add Comments to an Article
- [ ] Get Comments from an Article
- [ ] Delete Comment
- [ ] Favorite Article
- [ ] Unfavorite Article
- [ ] Get Tags
