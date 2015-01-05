Iterators
=========

This library provides convenience functions for making integer iterators. Other types of iterator may be supported in the future.

range()
-------

Based on Python's [range()](https://docs.python.org/2/library/functions.html#range) function. This function may take anywhere from one to three arguments:

    function range(?start:Int = 0, end:Int, ?step:Int = 1)

The function iterates starting at `start`, incrementing by `step` each time, and stopping just before it reaches `end`.

Sample usage:

    Iterators.range(5) //Equivalent to 0...5; iterates over [0, 1, 2, 3, 4].
    Iterators.range(3, 5) //Equivalent to 3...6; iterates over [3, 4].
    Iterators.range(5, 0, -1) //Iterates over [5, 4, 3, 2, 1].
    Iterators.range(10, 20, 2) //Iterates over [10, 12, 14, 16, 18].

from()
------

`range()` always iterates upwards unless you tell it otherwise. On the other hand, `from()` chooses a `step` value automatically.

Sample usage:

    Iterators.from(0, 5) //Iterates over [0, 1, 2, 3, 4].
    Iterators.from(5, 0) //Iterates over [5, 4, 3, 2, 1].
