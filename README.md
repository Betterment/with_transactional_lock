# with_transactional_lock

[![Build Status](https://travis-ci.com/Betterment/with_transactional_lock.svg?token=6b6DErRMUHX47kEoBZ3t&branch=master)](https://travis-ci.com/Betterment/with_transactional_lock)

A simple extension to ActiveRecord for performing advisory locking on
MySQL and PostgreSQL.

An advisory lock is a database-level mutex that can be used to prevent
concurrent access to a shared resource or to prevent two workers from
performing the same process concurrently.

This gem is different from other advisory locking gems because it
uses advisory transaction locks instead of advisory session locks. 
Advisory transaction locks only hold the lock until your critical 
section has completed and no longer. Concretely, this means that the 
lock is co-transactionally released when you commit your transaction 
-- i.e. when you've done whatever mutative things you meant to be 
doing and your new state-of-the-world is visible to others.

Additionally, this gem does not use a try-based approach to lock
acquisition. It will wait until the lock can be acquired instead of 
immediately returning false and forcing the application code to manage 
retry behavior. Additionally, by waiting in line for locks that cannot 
be immediately acquired, you get fairness in the acquisition sequence.

In contrast, when using a try-based strategy your ability to acquire 
a lock can get worse at higher levels of concurrency. You may spend 
more time spinning in application code issuing requests for a lock
instead of waiting on I/O (possibly allowing another thread to use the
CPU).

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'with_transactional_lock'
```

And then bundle install:

```
$ bundle install
```

And then if you're using MySQL, you will need to run the installer:

```
$ rails g with_transactional_lock:install
```

This will create a migration that will add an `advisory_locks` table to 
your database.

## Usage

```ruby
ActiveRecord::Base.with_transactional_lock('name_of_a_resource') do
  # do something critical in here
  # this block is already inside a transaction
end
```

This call will attempt to acquire an exclusive lock using the provided 
lock name. It will wait indefinitely for that lock -- or at least as
long as your database connection timeout is willing to allow. Once the
lock is acquired you will have exclusive ownership of the advisory lock
with the name that you provided. Your block is free to execute its
critical work. Upon completion of your transaction, the lock will be 
released.

## Supported databases

### PostgreSQL

PostgreSQL has first-class support for transactional advisory locks via
`pg_advisory_xact_lock`. This is an exclusive lock that is held for the
duration of a given transaction and automatically released upon
transaction commit.

### MySQL

MySQL does not have built-in support for transactional advisory locks.
So, MySQL gets a special treatment. We emulate the behavior of PostgreSQL
using a special `advisory_locks` table with a unique index on the `name`
column. This allows us to provide the same transactional and mutual
exclusivity guarantees as PostgreSQL. The trade-off is that you need to
add another table to your database, and that table will slowly
accumulate rows. You can cull the table with whatever frequency you
like.

In order to ease the culling of the `advisory_locks` table for the MySQL
implementation, there is a helper:

```ruby
WithTransactionalLock::MySqlHelper.cleanup
```

This helper will perform batch deletions of the `advisory_locks` table
in a loop until it deletes at least the amount of locks that were in the
table when it started -- i.e. it does not guarantee that it will empty
the table.

## License

Any contributions made to this project are covered under the MIT License, found [here](LICENSE)
