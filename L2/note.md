# [Shell Tools and Scripting](https://www.youtube.com/watch?v=kgII-YWo3Zw)
In this lecture,we will present some of the basics of using bash as a 
scripting language along with a number of shell tools that cover several
of the most common tasks that you will be constantly performing in the 
command line.
## Shell Scripting
So far we have seen how to execute commands in the shell and pipe them
together.However,in many scenarios you will want to perform a series of
commands and make use of control flow expressions like conditionals or
loops.

Shell scripts are the next step in complexity.Most shells have their 
own scripting different from other scripting programming language is
that it is optimized for performing shell-related tasks.Thus,creating 
command pipelines,saving results into files,and reading from standard
input are primitives in shell scripting,which makes it easier to use 
then general purpose scripting languages.For this section we will focus
on bash scripting since it it the most common.

To assign variables in bash,use the syntax **`foo=bar`** and access the
value of the variable with **`$foo`**.Note that **`foo = bar`** will not
work since it is interpreted as calling the **`foo`** program with arguments
 **`=`** and **`bar`**.In general,in shell scripts the space
character will perform argument splitting.This behavior can be confusing 
to use at first,so always check for that.

String in bash can be defined with **`'`** and **`"`** delimiters,but they
are not equivalent.Strings delimited with **`'`** are literal strings and 
will not substitute variable values whereas **`"`** delimited strings
will.
```bash
$ foo=bar
$ echo "$foo"
bar
$ echo '$foo'
$foo
```
AS with most programming languages,bash supports control flow techniques
including **`if`**,**`case`**,**`while`** and **`for`**.Similarly,
**`bash`** has functions that take arguments and can operate with them.
Here is an example of a function that creates a directory and **`cd`**
s into it.
```bash
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```
Here $1 is the first argument to the scrip/function.Unlike other scripting
languages,bash uses a variety of special variables to refer to arguments,
error codes,and other relevant variables.Below is a list of some of them.
A more comprehensive list can be found [here](https://tldp.org/LDP/abs/html/special-chars.html).

- **`$0`** -Name of the script  
- **`$1`** to **`$9`** -Arguments to the script.**`$1`** is the first argument and so on.
- **`$@`** -All the arguments
- **`$#`** -Number of arguments
- **`$?`** -Return code of the previous command
- **`$$`** -Process identification number(PID)for the current script
- **`!!`** -Entire last command,includeing arguments.A common pattern 
is to execute a command only for it to fail due to missing permissions;
you can quickly re-execute the command with sudo by doing **`sudo !!`**
- **`$_`** -Last argument from the last command.If you are in an 
interactive shell,you can also quickly get this value by typing **`Esc`**
followed by **`.`** or **`Alt+`**
Commands will often return output using **`STDOUT`**,errors through 
**`STDERR`**,and a Return Code to report errors in a more script-friendly
manner.The return code or exit status is the way scripts/commands have 
to communicate how execution went.A value of 0 usually means everything
went OK;anything different from 0 means an error occurred.

Exit codes can be used to conditionally execute commands using **`&&`**
(and operator) and **`||`**(or operator),both of which are 
**`short-circuiting`** operators.Commands can also be separated within
the same line using a semicolon **`;`**.The **`true`** program will 
always have a 0 return code and the **`false`** command will always 
have a 1 return code.Let's see some examples:
```bash
$ false || echo "Oops, fail"
Oops,fail
$ true || echo "Will not be printed"
$ true && echo "Things went well"
Things went well
$ false && echo "Will not be printed"
$ true ; echo "This will always run"
This will always run
$ false ; echo "This will always run"
This will always run
```
Another common pattern is wanting to get the output of a command as a
variable.This can be done with *command substitution*.Whenever you place
**`$( CMD )`** it will execute **`CMD`**,get the output of the command 
and substitute it in place.For example,if you do **`for file in $(ls)`**,
the shell will first call **`ls`** and then iterate over those values.
A lesser known similar feature is [*process substitution*](https://tldp.org/LDP/abs/html/process-sub.html)
,**`<( CMD )`**will execute **`CMD`** and place the output in a temporary file and
substitute the **`<()`** with that file's name.This is useful when 
commands expect values to be passed by file instead of by STDIN.For
example,**`diff <(ls foo) <(ls bar)`** will show differences between files
in dirs **`foo`** and **`bar`**.

Since that was a huge information dump,let's see an example that showcases
some of these features.It will iterate through the arguments we provide,
**`grep`** for the string **`foobar`**,and append it to the file as a
command if it's not found.
```bash
#!/bin/bash

echo "Starting program at $(date)" # Date will be substituted

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```
In the comparison we tested whether $? was not equal to 0.Bash implements
many comparisons of this sort --- you can find a detailed list in the
manpage for [test](https://www.man7.org/linux/man-pages/man1/test.1.html).
When performing comparisons in bash,try to use
double brackets **`[[ ]]`** in favor of simple brackets **`[ ]`**.
Chances of making mistakes are lower although it won't be portable to
**`sh`**.A more detailed explanation can be found [here](http://mywiki.wooledge.org/BashFAQ/031).

When launching scripts,you will often want to provide arguments that are
similar.Bash has ways of making this easier,expanding expressions by 
carrying out filename expansion.These techniques are often referred to 
as shell *globbing*.

- Wildcards---Whenever you want to perform some sort of wildcard matching,
you can use **`?`** and **`*`** to match one or any amount of characters
respectively.For instance,given files **foo**,**foo1**,**foo2**,
**foo10** and **bar**,the command **`rm foo?`** will delete **foo1**
and **foo2** whereas **`rm foo*`** will delete all but **bar**.
- Curly braces **`{}`** ---Whenever you have a common substring in a
series of commands,you can use curly braces for bash to expand this 
automatically.This comes in very handy when moving or converting files.
```bash
$ convert image.{png,jpg}
# Will expand to
$ convert image.png imahe.jpg

$ cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
$ cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files

mkdir foo bar
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Show differences between files in foo and bar
diff <(ls foo) <(ls bar)
# Output
# < x
# ---
# > y
```

Writing **`bash`** scripts can be tricky and unintuitive.There are tools like
[**`shellcheck`**](https://github.com/koalaman/shellcheck) that will help you 
find errors in your sh/bash scripts.

Note that scripts need not necessarily be written in bash to be called form the
terminal.For instance,here's a simple Python script that outputs its arguments
in reserved order:
```python
#!/usr/bin/python3
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```
The kernel knowns to execute this script with a python interpreter instead of a
shell command because we included a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))line at the top of the script.It is good practice to write
shebang lines using the [env](https://www.man7.org/linux/man-pages/man1/env.1.html) command that will resolve to wherever the command lives in the system,
increasing the portability of your scripts.To resolve the location,**`env`**
will make use of the **`PATH`** environment variable we introduced in the first
lecture.For this example the shebang line would look like **`#!/usr/bin/env python.

Some differences between shell functions and script that you should keep in mind
are:
- Function have to be in the same language as the shell,which scripts can be 
written in any language.This is why including a shebang for scripts is 
important.
- Functions are loaded once when their definition is read.Script are loaded
every time they are executed.This makes functions slightly faster to load,but
whenever you change them you will have to reload their definition.
- Functions are executed in the current shell environment whereas scripts
execute in their own process.Thus,functions can modify environment
variables,e.g. change your current directory,whereas scripts can't.Scripts
will be passed by value environment variables that have been exported using
**`export`**
- As with any programming language,functions are a powerful construct to
achieve modularity,code reuse,and clarity of shell code.Often shell scripts
will include their own function definitions.
## Shell Tools
### Finding how to use commands
At this point,you might be wondering how to find the flags for the commands
in the aliasing section such as **`ls -l`**,**`mv -i`** and **`mkdir -p`**.More
generally,given a command,how do you go about finding out what it does and its
different options?You could always start googling,but since UNIX predates
StackOverflow,there are built-in ways of getting this information.

As we saw in the shell lecture,the first-order approach is to call said command
with the **`-h`** or **`--help`** flags.A more detailed approach is to use the 
**`man`** command.Short for manual,**`man`** provides a manual page(called 
manpage) for a command along with the flags that it takes,including the **`-i`**
flag we showed earlier.In fact,what I have been linking so far for every command
is the online version of the Linux manpages for the commands.Even non-native
commands that you install will have manpage entries if the developer wrote
them and included them as part of the installation process.For interactive tools
such as the ones based on ncurses,help for the commands can often be accessed
within the program using the **`:help`** command or typing **`?`**.

Sometimes manpages can provide overly detailed descriptions of the
commands,making it hard to decipher what flags/syntax to use for common
use cases.TLDR pages are a nifty complementary solution that focuses on
giving example use cases of a command so you can quickly figure out which
options to use.For instance,I find myself referring back to the tldr pages for
**`tar`** and **`ffmpeg`** way more often than the manpages.
