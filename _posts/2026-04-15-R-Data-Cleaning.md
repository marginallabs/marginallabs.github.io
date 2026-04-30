---
layout: post
title: "Data Cleaning in R: The 80% Problem"
date: 2026-04-15
categories: [r, general, statistics]
type: blog
abstract: "Data scientists spend 80% of their time cleaning data. This post shares a practical workflow for wrangling messy datasets in R."
---

# The Reality

Real data is never clean. Missing values, weird encodings, and inconsistent formatting are the norm.

# A Workflow

Start with `dplyr` and `tidyr`. Filter, mutate, and reshape until your data is tidy. Then you can actually analyse it.
