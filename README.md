# GSLR

:fire: High performance linear regression for Ruby, powered by [GSL](https://www.gnu.org/software/gsl/)

[![Build Status](https://travis-ci.org/ankane/gslr.svg?branch=master)](https://travis-ci.org/ankane/gslr)

## Installation

[Install GSL](#gsl-installation). For Homebrew, use:

```sh
brew install gsl
```

Add this line to your application’s Gemfile:

```ruby
gem 'gslr'
```

## Getting Started

### Ordinary Least Squares

Prep your data

```ruby
x = [[1, 3], [2, 3], [3, 5], [4, 5]]
y = [10, 11, 16, 17]
```

Train a model

```ruby
model = GSLR::OLS.new
model.fit(x, y)
```

Make predictions

```ruby
model.predict(x)
```

Get the coefficients and intercept

```ruby
model.coefficients
model.intercept
```

Pass weights

```ruby
weight = [1, 2, 3, 4]
model.fit(x, y, weight: weight)
```

Disable the intercept

```ruby
GSLR::OLS.new(intercept: false)
```

### Ridge

Train a model

```ruby
model = GSLR::Ridge.new
model.fit(x, y)
```

Set the regularization strength

```ruby
GSLR::Ridge.new(alpha: 1.0)
```

**Note:** Weights aren’t supported yet

## GSL Installation

### Mac

```sh
brew install gsl
```

### Windows

Check out [the options](https://www.gnu.org/software/gsl/extras/native_win_builds.html).

### Ubuntu

```sh
sudo apt-get install libgsl-dev
```

### Heroku

Use the [Apt buildpack](https://github.com/heroku/heroku-buildpack-apt) and create an `Aptfile` with:

```text
libgsl-dev
```

### Travis CI

Add to `.travis.yml`:

```yml
addons:
  apt:
    packages:
    - libgsl-dev
```

## History

View the [changelog](https://github.com/ankane/gslr/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/gslr/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/gslr/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/gslr.git
cd gslr
bundle install
bundle exec rake test
```
