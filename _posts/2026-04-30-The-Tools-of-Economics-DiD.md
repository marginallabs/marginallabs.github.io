---
layout: post
title: "The Tools of Economics: Difference-in-Differences"
date: 2026-04-30
categories: [economics, econometrics, methodology, public-policy]
type: blog
series: "The Tools of Economics"
series_url: /series/the-tools-of-economics/
abstract: "Diff-in-diff compares the change in outcomes for a treated group to the change for a control group. Simple in concept, subtle in practice."
---

# The Parallel Trends Assumption

The identifying assumption is that treated and control groups would have followed the same trend in the absence of treatment. This cannot be proven, only tested for pre-treatment periods.

# Implementation

Estimate the treatment effect as the interaction term in a two-way fixed effects regression. Check for pre-trends and report robustness checks.
