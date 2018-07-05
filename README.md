# scrabble-bench
Benchmarks on how to implement scrabble scoring.

## Background
I was talking to someone online about a game idea he had, where he wanted to
use difficulty to type a word as a metric for that word's value.  While
scrabble scoring doesn't reflect that, I thought of it as an easy way to
prototype the word value system before later tuning.  One thing led to another
and now here are benchmarks on various ways to calculate the scrabble score.

## Benchmarks
The benchmarks' code can be found in `src/Main.hs`.  Each benchmark uses a
different data structure to lookup the scores for individual letters, but each
benchmark looks up the same phrase: `['a'..'z']`.  Based on these metrics,
the ranking of the results is as follows:

1. Data.Map.Strict
2. Data.IntMap.Strict
3. Data.HashMap.Strict
4. List

The full results can be found in `results.txt`.

## Improvements
It may be slightly unfair to benchmark by looking up every letter once, if
instead the benchmark looks up each letter N times weighted by frequency of
that letter in English it may be more fair.

An unbalanced binary tree matching frequency distributions in English could
be a better data structure than any of the above options when the benchmark
looks up each letter N times weighted by their frequency in English.

For example,

```
         e
        / \
       a   t
          / \
         i   o
          \
           n
```

This tree is probably not optimal though.  I would try constructing it in a
way similar to that used for Huffman coding.
