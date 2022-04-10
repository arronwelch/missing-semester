# [Data Wrangling[(https://youtu.be/sz_dsktIjt4)
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
Notice that we're using a pipe to stream a *remote* file through **grep** on our
local computer!**ssh** is magical,and we will talk more about it in the next
lecture on the command-line environment.This is still way more stuff than we
wanted though.And pretty hard to read.Let's do better:
```bash
ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' | less
```
Why the additional quoting?Well,our logs may be quite large,and it's wasteful
to stream it all to our computer and then do the filtering.Instead,we can do the
filtering on the remote server,and then massage the data locally.**less** gives
us a "pager" that allows us to scroll up and down through the long output.To
save some additional traffic while we debug our command-line,we can even
stick the current filtered logs into a file so that we don't have to access the
network while developing:
```bash
$ ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' > ssh.log
$ less ssh.log
```
There's still a lot of noise here.There are a lot of ways to get rid of that,but let's
look at one of the most powerful tools in your toolkit:**sed**.

**sed** is a "stream editor" that builds on top of the old **ed** editor.In it,you
basically give short commands for how to modify the file,rather than
manipulate its contents directly(although you can do that too).There are tons
of commands,but one of the most common ones is **s**:substitution.For
example,we can write:
```bash
ssh myserver journalctl
    | grep sshd
    | grep "Disconnected from"
    | sed 's/.*Disconnected from //'
```
What we just wrote was a simple *regular* expression;a powerful construct that
lets you match text against patterns.The **s** command is written on the form:
**s/REGEX/SUBSTITUTION/**,where **REGEX** is the regular expression you want to
search for,and **SUBSTITUTION** is the text you want to substitute matching text
with.

(You may recognize this syntax from the "Search and replace" section of our
Vim [lecture notes]()!Indeed,Vim uses a syntax for searching and replacing that is
similar to **sed**'s substitution command.Learing one tool often helps you
become more proficient with others.)

## Regular expressions
Regular expressions are common and useful enough that it's worthwhile to
take some time to understand how they work.Let's start by looking at the one
we used above:**\/\.\*Disconnected from \/**.Regular expressions are usually
(though not always)surrounded by **/**.Most ASCII characters just carry their
normal meaning,but some characters have "special" matching behaviour.
Exactly which characters do what vary somewhat between different
implementations of regular expressions,which is a source of great frustration.
Very common patterns are:
	- **.** means "any single character" except newline  
	- __*__ zero or more of the preceding match  
	- __+__ one or more of the preceding match  
	- __[abc]__ any one character of **a**,**b**,and **c**  
	- __(RX1|RX2)__ either something that matches **RX1** or **RX2**  
	- **^** the start of the line  
    - **$** the end of the line  
**sed**'s regular expressions are somewhat weird,and will require you to put a **\**
before most of these to give them their special meaning.Or you can pass **-E**.

So,looking back at __\/\.\*Disconnected from \/__,we see that it matches any text
that starts with any number of characters,followed by the literal string
"Disconnected from".Which is what we wanted.But beware,regular expressions are trixy.
What if someone tried to log in with the username "Disconnected from"?We'd have:
```bash
Jan 17 03:13:00 thesquareplanet.com sshd[2631]: Disconnected from invalid user Disconnected from 46.97.239.16 port 55920 [preauth]
```
What would we end up with?Well,__*__ and __+__ are,by default,"greedy".They will
match as much text as they can.So,in the above,we'd end up with just
```bash
46.97.239.16 port 55920 [preauth]
```





