# Monty Hall Simulator

Simulator for [the Monty Hall problem](https://en.wikipedia.org/wiki/Monty_Hall_problem).


## Setup

requires ruby 2.7.0 or higher, and the gem `descriptive_statistics`.


## Usage: Running a Single Simulation

```
ruby birthday_paradox.rb run_once_infinity
ruby birthday_paradox.rb run_multiple_infinity <number of runs>
ruby birthday_paradox.rb run_once_limited <room size limit>
ruby birthday_paradox.rb run_multiple_limited <number of runs> <room size limit>
```

example output:

```
ruby birthday_paradox.rb run_multiple_limited 1000 100
# 1000 simulations run with rooms of 100 participants.
# 1000 runs were successful, with a success rate of 100.0%.
# Mean successful run required 24.5 participants.
# Median successful run required 23.0 participants.
# The smallest successful run required 2 participants.
# The 1st percentile successful run required 3 participants.
# The 5th percentile successful run required 6 participants.
# The 25th percentile successful run required 16 participants.
# The 75th percentile successful run required 32 participants.
# The 95th percentile successful run required 45 participants.
# The 99th percentile successful run required 56 participants.
# The largest successful run required 73 participants.
# The standard deviation was 11.8 participants.
```
