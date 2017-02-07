# GitShowcase

[![Code Climate](https://codeclimate.com/github/pedsmoreira/gitshowcase/badges/gpa.svg)](https://codeclimate.com/github/pedsmoreira/gitshowcase)
[![Build Status](https://travis-ci.org/pedsmoreira/gitshowcase.svg?branch=master)](https://travis-ci.org/pedsmoreira/gitshowcase)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg)](https://github.com/RichardLitt/standard-readme)

![Get noticed with a rockstar Portfolio](./public/preview.png)

GitShowcase exists to help developers to present their awesomeness, showing their skills, projects and social networks
in a way that is easy to understand.

Contact us @ [jedi@gitshowcase.com](mailto:jedi@gitshowcase.com)

# Table of Contents
- [Install](#install)
- [Road map](#road-map)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)

## Install

### System Requirements
- Ruby `2.2.2+`
- Postgres 9.2+
- [NodeJS](https://nodejs.org/) _(for compiling javascript resources)_

### Fork and bundle
- Fork the project
- Run bundle to install gems
```bash
bundle install
```

### Create your GitHub application

Unless you only want to edit the homepage, you'll need your own GitHub credentials for development.
 
Go to your settings, than [OAuth applications](https://github.com/settings/developers) and register a new application.

### Configure your environment

Copy the file `.env.example` to `.env` and fill the fields

```bash
DB_USERNAME=
DB_PASSWORD=

GITHUB_KEY=
GITHUB_SECRET=
```

If you're using Linux or OSX, you probably don't need to fill the `DB_` fields

### Database setup

[Download and Install Postgres](https://www.postgresql.org/download/)

- Create the databases:
```bash
rails db:create
```

- Run migrations to create tables:
```bash
rails db:migrate
```

- Seeding:
```bash
rails db:seed
```

### Running Tests

To run the tests, use:

```bash
bundle exec rspec
```

### Running Server

```bash
rails s
```

## Road map

We have a road map of what we are going to implement next. It is available at our projects page

[https://github.com/pedsmoreira/gitshowcase/projects](https://github.com/pedsmoreira/gitshowcase/projects)

If you wish to add features that are not on the road map, you're very welcome to do so. We encourage you to
[create an Issue](https://github.com/pedsmoreira/gitshowcase/issues/new)
before coding, so we can all discuss the relevance to the community.

Please keep in mind that the focus is to create a great product, so we might not implement/accept all the suggested features.

## Maintainers

Pedro Moreira _(Developer)_ - [https://www.gitshowcase.com/pedsmoreira](https://www.gitshowcase.com/pedsmoreira)

Victor Hunter _(UI/UX)_ - [https://www.gitshowcase.com/victorgaard](https://www.gitshowcase.com/victorgaard)

## Contribute

All contributions must be written in *English*, so everyone can communicate :)

Feel free to [Open an issue](https://github.com/pedsmoreira/gitshowcase/issues/new) or submit PRs. If you choose
to open a PR, please do so on the `development` branch.

GitShowcase follows the [Contributor Covenant](http://contributor-covenant.org/version/1/4) Code of Conduct.

### Code Style

TODO - Add code styling (Rubocop) to Travis CI

### Code Quality

The Pull Request must not present issues on Code Climate.  

### Commit Messages

Commit messages should be verb based, such as:

- Fixing ...
- Adding ...
- Updating ...
- Removing ...

### Tests

Please update the tests to reflect your changes.

Travis CI will run on your PR and it has to pass for the PR to be accepted :)

## License

[gitshowcase.com/license](http://gitshowcase.com/license)
