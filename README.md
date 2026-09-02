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

It also adds a loader for `feature_flags.json`, so you can easily load feature flags from a file.
But to this later under `Scenarios`.

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

## Usage Scenarios


**Use Case**: Cleaning-Up -- The functionality is available to everyone.

> Please don't forget to remove feature flags after its use isn't needed anymore.

> Every unused feature flag, makes the code noisy and uncomfortable to read and understand.

1. Clean up the code after the feature flag has been disabled, or doesn't changed over a long time!

**Use Case**: A new functionality is to be developed that is accessible to specific users and/or environments via a feature flag.

1. Create a feature flag in production
2. Dump the flags, then replace the `config/feature_flags.json` file locally and commit it.
3. Continue developing against the feature as before.

**Use Case**: Functionality is available to only a small number of users.

1. Create a feature flag in production, and add allowed users.
2. Dump the flags, then replace the `config/feature_flags.json` file locally and commit it.
3. Edit the flag locally and specify a corresponding user.
4. Continue developing against the feature as before.

**Use Case**: Set a feature flag for an announcement, or something similar, for a specific period of time.

> This requires the use of ActiveJob; currently, only `SolidQueue` and `Sidekiq` are supported. But feel free to add more.

1. Create a feature flag in production, but without setting the expires date.
2. Dump the flags, then replace the `config/feature_flags.json` file locally and commit it.
3. Continue developing against the feature as before.
4. After deployment to production, set the expiration date on the flag -- the flag will be automatically disabled after the expiration date.


## Contributing

Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
