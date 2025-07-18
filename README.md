# with_transactional_lock

A simple extension to ActiveRecord for performing advisory locking on
PostgreSQL.

An advisory lock is a database-level mutex that can be used to prevent
concurrent access to a shared resource or to prevent two workers from
performing the same process concurrently.

This gem is different from other advisory locking gems because it
uses advisory transaction locks instead of advisory session locks.

## Why transactional?

At Betterment correctness is paramount. As such, we chose to use
transaction-level locks because we find them to be more trustworthy for
our production use.

Some types of advisory locks can be held for the lifetime of a database
session. In a typical database connection pooling configuration, like
that of ActiveRecord, a connection and its associated session are not
reset when the connection is returned to the pool. In that case, if you
do not properly release a session-level lock, it will leak and become
effectively unreleasable. In our Betterment production systems, that
type of risk is unacceptable. Fortunately, because ActiveRecord
doesn't leak open transactions back into the connection pool, we can
use transactional locks as our safety device rather than becoming
familiar with the nuances necessary to be confident that we are
preventing leaks.

Additionally, application developers tend to think about discrete units
of database work in terms of transactions. By leveraging the transaction
boundary, we ensure the advisory lock is released at the earliest
possible moment that it can be and no sooner.

## Lock acquisition efficiency & fairness

Some libraries providing advisory locking use try-lock semantics. This
library uses a blocking strategy for lock acquisition. It will wait
until the lock can be acquired instead of immediately returning false
and forcing the application layer to manage retry behavior.
Additionally, by waiting in line (in the database) for locks that cannot
be immediately acquired, you get fairness in the acquisition sequence.

Notably, this library performs lock-waiting in the database rather than
using `Timeout.timeout`. That means that the waiting is bounded by your
database timeout rather than a library-specific option. We see this as a
strength of the library. In practice, we have found that if there is a
chance of contention that you can't afford to wait for, you should
perform the operation that requires the lock asynchronously and/or
reduce the time spent in your critical section so that you can afford to
wait.

In contrast, when using a try-based strategy your ability to acquire a
lock can get worse at higher levels of concurrency. You may spend more
time spinning in application code issuing requests for a lock instead of
waiting on I/O (possibly allowing another thread to use the CPU).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'with_transactional_lock'
```

And then bundle install:

```
bundle install
```

## Usage

Because transactional locks are meaningless outside of the context of a
transaction, we provide an interface that wraps your work in a
transaction and acquires the lock.

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

## License

Any contributions made to this project are covered under the MIT License, found [here](LICENSE)
