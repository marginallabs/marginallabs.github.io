---
layout: post
title: "Regression Discontinuity: Causal Inference at the Cutoff"
date: 2026-04-23
categories: [econometrics, research, methodology, statistics, public-policy]
type: blog
abstract: "Regression discontinuity design exploits sharp cutoffs in policy assignment. This post explains the intuition, the assumptions, and how to implement it."
---

# The Idea

Units just above and just below a cutoff are nearly identical, except for treatment status. That is your experiment.

# Implementation

Choose a bandwidth, estimate separately on each side, and check for manipulation of the running variable.
