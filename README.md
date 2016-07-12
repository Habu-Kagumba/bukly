<div style="text-align:center;">
    <a href="http://bukly.herokuapp.com"><img src="https://res.cloudinary.com/habu-kagumba/image/upload/v1467210107/bukly_oemne0.svg" alt="Bubkly" width="200"></a>
</div>

[![Build Status](https://travis-ci.org/andela-hkagumba/bukly.svg?branch=master)](https://travis-ci.org/andela-hkagumba/bukly) [![Coverage Status](https://coveralls.io/repos/github/andela-hkagumba/bukly/badge.svg?branch=master)](https://coveralls.io/github/andela-hkagumba/bukly?branch=master) [![Code Climate](https://codeclimate.com/github/andela-hkagumba/bukly/badges/gpa.svg)](https://codeclimate.com/github/andela-hkagumba/bukly)

# Bukly

Keep track of your life goals conviniently with **Bukly**, a *bucket list* API.

**Documentation** - [bukly.herokuapp.com](http://bukly.herokuapp.com).

**Source code** - [github.com/andela-hkagumba/bukly](https://github.com/andela-hkagumba/bukly).

# Running the application

### Install dependencies

You need to install the following:

1. [Ruby](https://github.com/rbenv/rbenv)
2. [PostgreSQL](http://www.postgresql.org/download/macosx/)
3. [Bundler](http://bundler.io/)
4. [Rails](http://guides.rubyonrails.org/getting_started.html#installing-rails)
5. [RSpec](http://rspec.info/)

### Clone the repository

Clone the application to your local machine:

```
$ git clone https://github.com/andela-hkagumba/bukly.git
```

Install the dependencies

```
$ bundle install
```

Setup database and seed data

```
$ rake db:setup
```

To run the application;

```
$ rails s
```

To test the application;

```
$ rspec -fd
```

# Description

**Bukly** is a restful and versioned API and all interactions will be defined using basic HTTP verbs.

All calls to the API should include the header,

```sh

    Accept: application/vnd.bukly+json; version=1

```

Failure to which the API will return the error,

```sh
HTTP/1.1 404 Not Found
Cache-Control: no-cache
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: 8110f2cf-9529-4bf1-b299-f318cbaacf56
X-Runtime: 0.038873
X-XSS-Protection: 1; mode=block

{
    "errors": "Invalid route, please refer to the API docs for available routes"
}

```

All endpoints except for `/signup` and `/auth/login` require the `Authorization` header.

```sh

    Authorization: auth_token_string

```

Failure to which the API will return the error,

```sh

HTTP/1.1 401 Unauthorized
Cache-Control: no-cache
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: 15460395-2448-4817-85e2-b402318842fd
X-Runtime: 0.082715
X-XSS-Protection: 1; mode=block

{
    "errors": "Access Denied. Missing token"
}

```

## The API Endpoints

POST /bucketlists/ | Create a new bucket list
-----|-------
GET /bucketlists/ | List all the created bucket lists
GET /bucketlists/{id} | Get single bucket list
PUT /bucketlists/{id} | Update this bucket list
DELETE /bucketlists/{id} | Delete this single bucket list
POST /bucketlists/{bucket_id}/items/ | Create a new item in bucket list
GET /bucketlists/{bucket_id}/items | List all the created items in a bucket list
GET /bucketlists/{bucket_id}/items/{id} | Get a single item in a bucket list
PUT /bucketlists/{bucket_id}/items/{item_id} | Update a bucket list item
DELETE /bucketlists/{bucket_id}/items/{item_id} | Delete an item in a bucket list
