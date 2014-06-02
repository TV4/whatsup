# Status

A extensible way of exposing information about a running web app.

## Usage

### Rails

Put it in your gemfile.

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

The app is built up by Collectors (Defined in Status::Collectors). A Collector
is something that responds to `call` without arguments. 

Included with the gem is collectors for:

* `RailsStatus`: Included if Rails is defined. Gives you information
  about Rails version, env, configuration and middleware
* `RubyStatus`: Always included. Includes Ruby version and GC stats.
* `CacheStatus`: Include if Rails is defined. Gives you information about 
  the Rails cache: type and stats, if `Rails.cache` responds to `#stats`.
* `ResqueStatus`: Included if Resque is defined. Gives you queue length
  of all queues returned by `Resque.queues`.
* `SinatraStatus`. Included if Sinatra is defined. Gives you Sinatra
  version.

## But I want more stuff in my status page!

Easy! Register your own collector. The simplest collector is:

    ->() { "hello world" }

Which can be registered by using the `register` method on the Configuration
object. If you are using Rails, this is obtained by `config.status_page` in
your application.rb.

Collectors is anything that responds to `#call`, which means you can either
use a proc or a class. See the included collectors for examples
(lib/status/collectors.rb)

  

