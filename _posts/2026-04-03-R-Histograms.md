---
layout: post
title: "Quick Histograms in R with ggplot2"
date: 2026-04-03
categories: [r, econometrics, statistics]
type: blog
permalink: /blog/:title/
abstract: "A short tutorial on producing publication-quality histograms in R using ggplot2, with tips on bin width and overlaying density curves."
---

# Getting Started

Load ggplot2 and pick a variable. A histogram is one line of code.

# Choosing Bin Width

The default bin width rarely looks good. Use the Freedman-Diaconis rule or just experiment until the shape is clear.
