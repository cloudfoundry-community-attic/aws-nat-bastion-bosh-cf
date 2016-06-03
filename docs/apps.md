# Apps for Validating Your CF + BOSH Deployment

While you could deploy any application for which you can expose a service and convert to 12-factor, it doesn't always make sense to jump _straight_ to deploying a real production app. Often these have multiple moving parts and getting them deployed under the best of circumstances can often be described as "easier said than done".

Additionally, "real" applications may run the risk of firing long-forgotten automated tasks, like kicking off emails, notifications, changing and/or consuming various credentials, settling financial transactions, etc.

Instead of going through that complexity and running that risk, we invite you to deploy one of the following super-simple applications instead, just for the purposes of validating your CF + BOSH deployment. Since these applications are overly-simplistic, identifying an error/issue should (theoretically, anyway) be much easier since there are far, far fewer things that can possibly go wrong. (Contrast an app with no external dependencies with a live production application with several different worker types in Resque, maybe some stuff talking to RabbitMQ under the hood, importing/parsing social media data every N minutes, etc.)

## Ruby

Here are some applications in Ruby you're welcome to try.

[http-nobacking-ruby](https://github.com/jaustinhughey/http-nobacking-ruby)

A simple HTTP/1.1 API with one valid route for retrieving info about the running process, Ruby version/engine/location, etc.

+ No authentication (too complex for a test app, out of scope)
+ Example `curl` request included in project `readme.md`
+ Zero external service dependencies
+ RubyGems (libraries/code dependencies) bundled with the app for convenience
+ Useful for proving that the absolute minimum pieces of a Ruby application work

[http-redis-ruby](https://github.com/jaustinhughey/http-redis-ruby)

Another simple HTTP/1.1 API accessible over `curl`. **Requires valid [redis](http://redis.io) service and a URL exposed as an environment variable accessible to the app.** More details on that in the readme.

+ No authentication (out of scope)
+ Gems bundled with the application for convenience
+ **Depends on a valid redis service**
+ Example `curl` requests for getting and/or setting keys in the project `readme.md`
+ Useful for proving your service broker works, that your [redis](http://redis.io) data store is up, running and accessible to the app over the network, and that your application will have access to the proper environment variables at runtime.

## WANTED: Additional applications!

Do you have a good application in mind that should be in this document? Fork this repo, update this doc and open a pull request so we can take a look!

In general, a good application for *testing/validation purposes* consists of:

+ A very simple, direct user interaction flow (e.g. visit this URL and yay, all's good! or make this HTTP request)
+ Very limited number of external dependencies; we'd advise maybe ~2 external "services" (e.g. something the service broker needs to know about) at most but special cases with good reasoning are definitely fair game
+ Easy to deploy because they have dependencies packaged with the app to the extent it makes sense
+ Consistent with the [12-Factor App Methodology](http://12factor.net)
+ Avoid writing data to disk, instead writing to a persistent data store (e.g. S3 for pictures, PostgreSQL for relational data, etc.)
+ **Are well documented with simple setup and use instructions and CLI/code examples**; also *be sure that documentation is up to date and **stays** up to date*
+ Are written in a fairly common-place web scripting langage and not something that the "mainstream" might consider esoteric; in other words, let's avoid the hottest pet language out there and opt for something in the way of available buildpacks...

### Buildpacks for this project

The available buildpacks can be seen by issuing `cf buildpacks` from your bastion host after full setup is complete, and/or by reviewing source code in, for example, [cf-tiny.yml](../config/aws/cf-tiny.yml) (`grep` for "buildpack" and you'll see the list there). As of this writing, we have the following buildpacks available:

+ [PHP](http://php.net)
+ [Ruby](http://ruby-lang.org)
+ [Go](http://golang.org)
+ [NodeJS](http://nodejs.org)
+ [Python](http://www.python.org)
+ [Java](https://www.oracle.com/java/)

This list is indeed subject to change, and you are of course able to change it by altering the appropriate sections of your CF configuration YAML file. See [config/aws/cf-*.yml](../config/aws) for examples.
