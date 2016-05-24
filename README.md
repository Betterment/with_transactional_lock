# with_transactional_lock

What is this gem?

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'with_transactional_lock'
```

And then bundle install:

```
$ bundle install
```

## Usage

```ruby
SomeModel.with_transactional_lock('name_of_a_resource') do
  # do something critical in here
  # this block is already inside a transaction
end
```

While inside the block you have exclusive access to 

## Supported databases

### Postgresl

Postgres has first-class support for transactional advisory locks via
`pg_advisory_xact_lock`. This is an exclusive lock that is held for the
duration of a given transaction and automatically released upon
transaction commit.

### MySQL

MySQL does not have built-in support for transactional advisory locks.
So, MySQL gets a special treatment. We emulate the behavior of postgres
using a special `advisory_locks` table with a unique index on the `name`
column. This allows us to provide the same transactional and mutual
exclusivity guarantees as postgres. The trade-off is that you need to
add another table to your database, and that table will slowly
accumulate rows. You can cull the table with whatever frequency you
like.

## License

This project rocks and uses MIT-LICENSE.
