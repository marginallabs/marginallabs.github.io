---
layout: post
title: "Policy Evaluation in a Second-Best World"
date: 2026-04-19
categories: [economics, econometrics, research, fallacy, stata, r, public-policy, experiment, causal-inference, welfare, regulation, labor]
type: blog
abstract: "Evaluating policy when you cannot run experiments is hard. This post surveys diff-in-diff, RDD, and synthetic control methods with code examples."
---

# The Challenge

Randomised trials are the gold standard, but most policies are not randomised. We need quasi-experimental methods.

# Three Workhorses

Difference-in-differences compares trends. Regression discontinuity exploits cutoffs. Synthetic control builds a counterfactual. Each has assumptions and limitations.
