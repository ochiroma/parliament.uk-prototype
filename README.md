# Parliament.uk prototype
Parliament.uk prototype is a [Rails 5][rails] application designed to be the beginnings of a new [parliament.uk][parliament] website and API.

[![License][shield-license]][info-license]

### Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [Running the application](#running-the-application)
    - [Member Service API?](#member-service-api)
    - [Running with Foreman and a Local Version of the API](#running-with-foreman-and-a-local-version-of-the-api)
      - [Foreman?](#foreman)
    - [Running the application standalone, without an API](#running-the-application-standalone-without-an-api)
  - [Running the tests](#running-the-tests)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Requirements
Parliament.uk prototype requires the following:
* [Ruby][ruby] - for the exact version, [click here][ruby-version].
* [Node][node]
* [NPM][npm]

## Getting Started
Setup the main application repository:
```bash
git clone https://github.com/ukparliament/parliament.uk-prototype.git
cd parliament.uk-prototype
bundle install
cp .env.sample .env
```

### Running the application
There are two options for running the parliament.uk prototype, either with a local version of the member API at the same time, or as a standalone rails application.

#### Member Service API?
Along with this prototype there is a paired [member-service-api][member-service-api] project. This API's role is to consume data from a triple store and generate .ttl files which our parliament.uk prototype can consume.

#### Running with Foreman and a Local Version of the API
> **NOTE:** In order to use [foreman][foreman] to run the API and application together, we are assuming you have the [member-service-api][member-service-api] project cloned and set-up in the same location as the parliament.uk-prototype project. For example, your folders should look something like the following:
> ```
> /                         (projects root)
> /parliament.uk-prototype/ (prototype)
> /member-service-api/      (api)
> ```
> With this setup, foreman runs the API directly from within the member-service-api directory.

```bash
bundle exec foreman start
```

The application and API should now be viewable in your local browser at http://localhost:3000 (application) and http://localhost:3030 (API). With this setup, you can make changes to the local API repository and test them right away.

##### Foreman?
[Foreman][foreman] allows us to run multiple applications concurrently, making local development of the Parliament.uk prototype much faster. Using foreman you can make changes to both the member-service-api and prototype in tandem without the need for deployment delays.


#### Running the application standalone, without an API
> **NOTE:** In order to run the application without a local copy of the [member-service-api][member-service-api], you'll need to update your `.env` file to include remote `API_ENDPOINT` and `API_ENDPOINT_HOST` values. The included sample assumes you are running the API locally with foreman.

```bash
bundle exec rails s
```

The application should now be viewable in your local browser at: http://localhost:3000.


### Running the tests
We use [RSpec][rspec] as our testing framework and tests can be run using:
```bash
bundle exec rspec
```


### Running the application using Docker Compose

To run the application using Docker Compose, make sure that you have checked out
the [member-service-api][member-service-api] project into the same location as
the parliament.uk-prototype project as described above in
[Running with Foreman and a Local Version of the API](#running-with-foreman-and-a-local-version-of-the-api).

Next create a folder in your home directory called `~/.ukpds` and within this,
create two files:

**~/.ukpds/parliament.uk-prototype.env**
```
GTM_KEY=<GTM key>
ASSET_LOCATION_URL=<asset location URL>
```

**~/.ukpds/member-service-api.env**
```
UKPDS_DATA_URI_PREFIX=<UKPDS data URI prefix>
UKPDS_DATA_ENDPOINT=<UKPDS data endpoint URL>
```

Then in this folder, run `docker-compose up` or, if you prefer to run it in the
background, `docker-compose up -d`.

You should then be able to access the web application on http://localhost:3000/
and the members' service on http://localhost:3030/ as above.


## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License
[Parliament.uk Prototype][parliament.uk-prototype] is licensed under the [Open Parliament Licence][info-license].

[rails]:                   http://rubyonrails.org
[parliament]:              http://www.parliament.uk
[ruby]:                    https://www.ruby-lang.org/en/
[node]:                    https://nodejs.org/en/
[npm]:                     https://www.npmjs.com
[member-service-api]:      https://github.com/ukparliament/member-service-api
[foreman]:                 https://github.com/ddollar/foreman
[rspec]:                   http://rspec.info
[parliament.uk-prototype]: https://github.com/ukparliament/parliament.uk-prototype
[ruby-version]:            https://github.com/ukparliament/parliament.uk-prototype/blob/master/.ruby-version

[info-license]:   http://www.parliament.uk/site-information/copyright/open-parliament-licence/
[shield-license]: https://img.shields.io/badge/license-Open%20Parliament%20Licence-blue.svg
