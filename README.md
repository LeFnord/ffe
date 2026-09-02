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
Defaults are:
```rb
config.bitlength = 4
config.milieus = { development: 0, staging: 1, production: 2 }
config.env_variable = 'RAILS_ENV'
# actual supported: :solid_queue, :sidekiq
config.queue_adapter = :solid_queue 
```

Install the migration with:
```bash
$ bin/rails ffe:install:migrations
$ bin/rails db:migrate
```
(have an eye on the length of the `milieu` bit mask)

Mount the engine in your application's `config/routes.rb` file:
```ruby
mount Ffe::Engine => "/feature_flags"
```

### Views

The engine provides base views for operating on FeatureFlags.

But I recommend implement your own ones, as it is usually easier to customize. See: [views/ffe/feature_flags](https://github.com/LeFnord/ffe/tree/master/app/views/ffe/feature_flags).

## Usage

Run your app and go to [http://localhost:3000/ffe/feature_flags](http://localhost:3000/ffe/feature_flags) to create your first feature flag.

1. general usage, respecting only the environment
    ```rb
   FeatureFlag.enabled?(:flag)
   # or
   FeatureFlag.disabled?(:flag)
   ```
  

2. check if a user is allowed
    ```rb
    FeatureFlag.enabled_for?(:flag, user: current_user)
    ```


## Contributing

Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
