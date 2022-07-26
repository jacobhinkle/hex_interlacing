---
title: An Interlacing Algorithm for Hexagonal Grids
author: |
  | Jacob Hinkle
  | Oak Ridge National Laboratory
  | hinklejd@ornl.gov
numbersections: true
documentclass: article
bibliography: hex.bib
abstract: |
  Progressive refinement of images...
---

# Introduction {#sec:intro}

Foo

Motivation: optimal sampling with progressive

Briefly discuss interlaced video.

In this note, I introduce a method akin to Adam7 for interlacing when using hexagonal grid sampling. The method is simple, scales to any required depth or resolution, and can be implemented with a series of simple rotated rectilinear sampling grids.

# Background

## The Adam7 Algorithm {#sec:adam7}

The Adam7 algorithm

```
1 6 4 6 2 6 4 6
7 7 7 7 7 7 7 7
5 6 5 6 5 6 5 6
7 7 7 7 7 7 7 7
3 6 4 6 3 6 4 6
7 7 7 7 7 7 7 7
5 6 5 6 5 6 5 6
7 7 7 7 7 7 7 7
```

Note that although Adam7 contains 7 passes, it is trivially extended to any number of passes.

## Wavelets and Other Methods

## Hexagonal Grid Methods

# Hexagonal Interlacing {#sec:hexinter}

Similar to Adam7 [@sec:intro],

## Montaging {#sec:montaging}

Work out how this works with montaging.

# Conclusion
