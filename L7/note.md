# [Lecture 7:Debugging and Profiling](https://youtu.be/l812pUnKxME)
A golden rule in programming is that code does not do what you expect it to do,but what you tell it to do.Bridging that gap can sometimes be a quite difficult feat.In this lecture we are going to cover useful techniques for dealing with buggy and resource hungry code:debugging and profiling.

## Debugging
### Printf debugging and Logging
"The most effective debugging tool is still careful thought,coupled with judiciously placed print statements"--- Brian kernighan,*Unix for Beginners*.

A first approach to debug a program is to add print statements around where you have detected the problem,and keep iterating until you have extracted enough information to understand what is responsible for the issue.

A second approach is to use logging in your program,instead of ad hoc print statements.Logging is better than regular print statements for serveral reasons:
- You can log to files,sockets or even remote servers instead of standard output.
- Logging supports severity levels(such as INFO,DEBUG,WARN,ERROR,&c),that allow you to filter the output accordingly.
- For new issues,there's a fair chance that your logs will contain enough information to detect what is going wrong.

[Here](https://missing.csail.mit.edu/static/files/logger.py) is an example code that logs messages:
```bash
$ wget https://missing.csail.mit.edu/static/files/logger.py
$ ls
$ python logger.py
# Raw output as with just prints
$ python logger.py log
# Log formatted output
$ python logger.py log ERROR
# Print only ERROR levels and abve
$ python logger.py color
# Color formatted output
```
One of my favorite tips for making logs more readable is to color code them.By now you probably have realized that your terminal uses colors to make things more readable.But how does it do it?Programs like __ls__ or __grep__ are using [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code),which are special sequences of characters to indicate your shell to change the color of the output.For example,executing __echo -e "\e[38;2;255;0;0mThis is red\e[0m"__ prints the message __This is red__ in red on your terminal,as long as it supports [true color](https://github.com/termstandard/colors#truecolor-support-in-output-devices).
