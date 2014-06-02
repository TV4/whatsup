# Status

A extensible way of exposing information about a running web app.

It presents a JSON object with information about current ruby, rails
and anything else you want to show that can be accessed through ruby.

## Usage

Status can be used with any Rack app, by including the middleware
Status::StatusPage with a configuration object. See below for
framework specific instructions

### Rails

The status gem includes a Railtie which inserts the middleware in the
middleware chain and exposes the configuration object as `config.status_page`.

The only thing needed is to put it in your gemfile and configure it by in your
application.rb putting something like

        config.status_page.username = "admin"
        config.status_page.password = "topsecret"

### Sinatra

* Put it in your gemfile
* Add the following to your app:

        config = Status::Configuration.new
        config.username = "admin"
        config.password = "topsecret"
        use Status::StatusPage, config: config

### Then

After this, you can access the status at /__status, using the username and password
specified above.


## What does it show?

The app is built up by Collectors (The standard ones are defined in Status::Collectors).
A Collector is something that responds to `call` without arguments and returns a
Hash

Included with the gem is collectors for:

* `RailsStatus`: Included if Rails is defined. Gives you information
  about Rails version, env, configuration and middleware
* `RubyStatus`: Always included. Includes Ruby version and GC stats.
* `CacheStatus`: Included if Rails is defined. Gives you information about
  the Rails cache: type and stats, if `Rails.cache` responds to `#stats`.
* `ResqueStatus`: Included if Resque is defined. Gives you queue length
  of all queues returned by `Resque.queues`.
* `SinatraStatus`. Included if Sinatra is defined. Gives you Sinatra
  version.

## But I want more stuff in my status page!

Easy! Register your own collector. As mentioned earlier, a collector is something
that responds to `call` without arguments. That means that the simplest collector is:

    ->() { "hello world" }

but a collector can also be an object or a class.

Which can be registered by using the `register` method on the Configuration
object. It takes two arguments, the first is the key the collected information
will be under in the status json and the second is the actual collector.

If you are using Rails, this is obtained by `config.status_page` in
your application.rb:

    config.status_page.register(:hello, ->() { "Hello world" })

If using Sinatra, you already have a Configuration object to use:

    config = Status::Configuration.new
    config.username = "admin"
    config.password = "topsecret"
    config.register(:hello, ->() { "hello world" }
    use Status::StatusPage, config: config

For some examples, see the included collectors for examples
(lib/status/collectors.rb)

