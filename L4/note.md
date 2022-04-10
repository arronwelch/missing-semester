# [Data Wrangling[()
Have you ever wanted to tale data in one format and turn it into a different
format?Of course you have!That,in very general terms,is what this lecture is
all about.Specifically,massaging data,whether in text or binary format,until
you end up with exactly what you wanted.

We've already seen some basic data wrangling in past lectures.Pretty much any
time you use the **|** operator,you are performing some kind of data wrangling.
Consider a command like **journalctl | grep -i intel**.It finds all system
log entries that mention Intel(case insensitive).You may not think of it as
wrangling data,but it is going from one format(your entire system log) to a
format that is more useful to you(just the intel log entries).Most data
wrangling is about knowing what tools you have at your disposal,and how to
combine them.

Let's start from the beginning.To wrangle data,we need two things:data to
wrangle,and something to do with it.Logs often make for a good use-case,
because you often want to investigate things about them,and reading the
whole thing isn't feasible.Let's figure out who's triying to log into my server
by looking at my server's log:
```bash
ssh myserver journalctl
```
That's far too much stuff.Let's limit it to ssh stuff:
```bash
ssh myserver journalctl | grep sshd
```
