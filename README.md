# GitShowcase

[![Code Climate](https://codeclimate.com/github/pedsmoreira/gitshowcase/badges/gpa.svg)](https://codeclimate.com/github/pedsmoreira/gitshowcase)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

![Get noticed with a rockstar Portfolio](./public/preview.png)

GitShowcase exists to help developers to present their awesomeness, showing their skills, projects and social networks
in a way that is easy to understand.

Contact us @ [jedi@gitshowcase.com](mailto:jedi@gitshowcase.com)

# Table of Contents
- [Install](#install)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)

## Install

### System Requirements
- Ruby `2.2.2+`
- [NodeJS](https://nodejs.org/) _(for compiling javascript resources)_

### Database setup

We highly recommend the usage of Postgres. Some features like JSON fields may not work as well on other databases.

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

## Maintainers

Pedro Moreira _(Developer)_ - [https://www.gitshowcase.com/pedsmoreira](https://www.gitshowcase.com/pedsmoreira)

Victor Hunter _(UI/UX)_ - [https://www.gitshowcase.com/victorgaard](https://www.gitshowcase.com/victorgaard)

### Running Tests

To run the tests, use:

```bash
rails test
```

### Running Server

```bash
rails s
```

## Contribute

Feel free to [Open an issue](https://github.com/pedsmoreira/gitshowcase/issues/new) or submit PRs. PRs must be opened on the `development` branch.

GitShowcase follows the [Contributor Covenant](http://contributor-covenant.org/version/1/4) Code of Conduct.

### Code Style

TODO - Set code style and integrate CI

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

TODO - Integrate CI

## License

[gitshowcase.com/license](http://gitshowcase.com/license)
