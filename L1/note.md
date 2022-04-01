# Lecture 1:Course Overview + The Shell(2020)

We want to teach you how to make the most of the tools you know,
show you new tools to add to your toolbox,and hopefully instill in you
some excitement for exploring(and perhaps building) more tools your own.

- Topic 1:The Shell
    - What is the shell?
	> current working directory
	> ~(short for home)
	> The $ is tells you that you are not the root user.
> *missing:~$* echo hello
> hello
In this case, we told the shell to execute the program *echo* with the argument
*hello*.The *echo* program simply prints out its arguments. The Shell parses
the command by splitting it by whitespace, and then runs the program
indicated by the first word, supplying each subsequent word as an argument
that the program can access.If you wnat to provide an argument that contains
spaces or other special characters(e.g., a directory named "My Photos"), you
can rither quote the argument with *'* or *"* (*"My Photos"*), or escape just the
relevant characters with *\* (*My\ Photos*).

> "cd -": switch to previously path(toggle bwtween two different directorie)
> "[Ctrl + c]" : can cancel current terminal input
> ">>" : means append
> "<" : angle bracket sign means rewire input from ...
> ">" : end angle bracket sign means rewire outpu to ...
