# Ffe

A minimalistic Feature Flag engine, cause i was bored of unleash and other overloaded ones.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "ffe"
```

And then execute:
```bash
$ bundle install
```

Copy over the initializer with:
```bash
$ bin/rails g ffe:install
```
and adjust it to your needs.

Install the migration with:
```bash
$ bin/rails ffe:install:migrations
```
(have an eye on the length of the `milieu` bit mask)

Mount the engine in your application's `config/routes.rb` file:
```ruby
mount Ffe::Engine => "/feature_flags"
```

## Usage

coming soon


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
