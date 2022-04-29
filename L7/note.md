## Debugging
### Printf debugging and Logging
"The most effective debugging tool is still careful thought,coupled with judiciously placed print statements"--- Brian kernighan,**Unix for Beginners**.

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
One of my favorite tips for making logs more readable is to color code them.By now you probably have realized that your terminal uses colors to make things more readable.But how does it do it?Programs like __ls__ or __grep__ are using [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code),which are special sequences of characters to indicate your shell to change the color of the output.For example,executing __echo -e "\e[38;2;255;0;0mThis is red\e[0m"__ prints the message __This is red__ in red on your terminal,as long as it supports [true color](https://github.com/termstandard/colors#truecolor-support-in-output-devices).If your terminal doesn't support this(e.g. macOS's Terminal.app),you can use the more universeally supported escape codes for 16 color choices,for example __echo -e "\e[31;1mThis is red\e[0m"__.

The following script shows how to print many RGB colors into your terminal(again,as long as it supports true color).
```bash
#!/usr/bin/env python3
for R in $(seq 0 20 255); do
	for G in $(seq 0 20 255); do
		for B in $(seq 0 20 255); do
			printf "\e[38;2;${R};${G};${B}m\e[0m";
		done
	done
done
```
### Third party logs
As you start building larger software systems you will most probably run into dependencies that run as separate programs.Web servers,databases or message brokers are common examples of this kind of dependencies.When interacting with these systems it is often necessary to read their logs,since client side error messages might not suffice.

Luckily,most programs write their own logs somewhere in your system.In UNIX systems,it is commonplace for programs to write their logs under __/var/log__.For instance,the [NGINX](https://www.nginx.com/) webserver places its logs under __/var/log/nginx__.More recently,systems have started using a __`system log`__,which is increasingly where all of your log messages go.Most(but not all) Linux systems use __systemd__,a system daemon that controls many things in your system such as which services are enabled and running.__systemd__ places the logs under __/var/log/journal__ in a specialized format and you can use the [journalctl](https://www.man7.org/linux/man-pages/man1/journalctl.1.html) command to display the messages.Similarly,on macOS there is still __/var/log/system.log__ but an increasing number of tools use the system log,that can be displayed with [log show](https://www.manpagez.com/man/1/log/).On most UNIX systems you can also use the [dmesg](https://www.man7.org/linux/man-pages/man1/dmesg.1.html) command to access the kernel log.

For logging under the system logs you can use the [logger](https://www.man7.org/linux/man-pages/man1/logger.1.html) shell program.Here's an example of using __logger__ and how to check that the entry made it to the system logs.Moreover,most programming languages have bindings logging to the system log.
```bash
logger "Hello Logs"
# On macOS
log show --last 1m | grep Hello
# On Linux
journalctl --since "1m ago" | grep Hello
```

As we saw in the data wrangling lecture,logs can be quite verbose and they require some level of processing and filtering to get the information you want.If you find yourself heavily filtering through __journalctl__ and __log show__ you can consider using their flags,which can perform a first pass of filtering of their output.There are also some tools like [lnav](http://lnav.org/),that provide an improved presentation and navigation for log files.

### Debuggers

When printf debugging is not enough you should use a debugger.Debuggers are programs that let you interact with the execution of a program,allowing the following:
- Halt execution of the program when it reaches a certain line.
- Step through the program one instruction at a time.
- Inspect values of variables after the program crashed.
- Conditionally halt the execution when a given condition is met.
- And many more advanced features

Many programming languages come with some form of debugger.In Python this is the Python Debugger [pdb](https://docs.python.org/3/library/pdb.html).

Here is a brief description of some of the commands __pdb__ supports:

- l(ist):Displays 11 lines around the current line or continue the previous listing.
- s(tep):Execute the current line,stop at the first possible occasion.
- n(ext):Continue execution until the next line in the current function is reached or it returns.
- b(reak):Set a breakpoint(depending on the argument provided).
- p(rint):Evaluate the expression in the current context and print its value.
	There's also __pp__ to display using [pprint](https://docs.python.org/3/library/pprint.html) instead.
- r(eturn):Continue execution until the current function returns.
- q(uit):Quit the debugger.

Let's go through an example of using __pdb__ to fix the following buggy python code.(See the lecture video).
```python
def bubble_sort(arr):
	n = len(arr)
	for i in range(n):
		for j in range(n):
			if arr[j] > arr[j+1]:
				arr[j] = arr[j+1]
				arr[j+1] = arr[j]
	return arr

print(bubble_sort([4, 2, 1, 8, 7, 6]))
```
Note that since Python is an interpreted language we can use the __pdb__ shell to execute commands and to execute instructions.[ipdb](https://pypi.org/project/ipdb/) is an improved __pdb__ that uses the [IPython](https://ipython.org/) REPL enabling tab completion,syntax highlighting,better tracebacks,and better introspection while retaining the same interface as the __pdb__ module.

For more low level programming you will probably want to look into [gdb](https://www.gnu.org/software/gdb/) (and its quality of life modification [pwndbg](https://github.com/pwndbg/pwndbg)) and [lldb](https://lldb.llvm.org/).They are optimized for C-like language debugging but will let you probe pretty much any process and get its current machine stage:registers,stack,program counter,&c.

### Specialized Tools

Even if what you are trying to debug is a black box binary there are tools that can help you with that.Whenever programs need to perform actions that only the kernel can,they use [System Calls](https://en.wikipedia.org/wiki/System_call).There are commands that let you trace the syscalls your program makes.In Linux there's [strace](https://www.man7.org/linux/man-pages/man1/strace.1.html) and macOS and BSD have [dtrace](http://dtrace.org/blogs/about/).__dtrace__ can be tricky to use because it uses its own __D__language,but there is a wrapper called [dtruss](https://www.manpagez.com/man/1/dtruss/) that provides an interface more similar to __strace__ (more details [here](https://8thlight.com/blog/colin-jones/2015/11/06/dtrace-even-better-than-strace-for-osx.html).

Below are some examples of using __strace__ or __dtruss__ to show [stat](https://www.man7.org/linux/man-pages/man2/stat.2.html) syscall traces for an execution of __ls__.For a deeper dive into __strace__,[this article](https://blogs.oracle.com/linux/strace-the-sysadmins-microscope-v2) and [this zine](https://jvns.ca/strace-zine-unfolded.pdf) are good reads.
```bash
# On Linux
sudo strace -e lstat ls -l > /dev/null
# On macOS
sudo dtruss -t lstat64_extended ls -l > /dev/null
```

Under some circumstances,you may need to look at the network packets to figure out the issue in your program.Tools like [tcpdump](https://www.man7.org/linux/man-pages/man1/tcpdump.1.html) and [Wireshark](https://www.wireshark.org/) are network packet analyzers that let you read the contents of network packets and filter them based on different cirteria.

For web development,the Chrome/Firefox developer tools are quite handy.They feature a large number of tools,including:
- Source code:Inspect the HTML/CSS/JS source code of any website.
- Live HTML,CSS,JS modification:Change the website content,style and behavior to test(you can see for yourself that website screenshots are not valid proofs).
- Javascript shell:Execute commands in the JS REPL.
- Storage:Look into the Cookies and local application storage.

### Static Analysis
For some issues you do not need to run any code.For example,just by carefully looking at a piece of code you could realize that your loop variable is shadowing an already existing variable or function name;or that a program reads a variable before defining it.Here is where [static analysis](https://en.wikipedia.org/wiki/Static_program_analysis) tools come into play.Static analysis programs take source code as input and analyse it using coding rules to reason about its correctness.

In the following Python snippet there are several mistakes.First,our loop variable __foo__ shadows the previous definition of the function __foo__.We also wrote __baz__ instead of __bar__ in the last line,so the program will crash after completing the __sleep__ call(which will take one minute).
```python
import time

def foo():
	return 43

for foo in range(5):
	print(foo)
bar = 1
bar *= 0.2
time.sleep(60)
print(baz)
```
Static analysis tools can identify this kind of issues.When we run [pyflakes](https://pypi.org/project/pyflakes) on the code we get the errors related to  both bugs.[mypy](http://mypy-lang.org/) is another tool that can detect type checking issues.Here,__mypy__ will warn us that __bar__ is initially an __int__ and is then casted to a __float__.Again,note that all these issues were detected without having to run the code.
```bash
$ pyflakes foobar.py

$ mypy foobar.py
```
In the shell tools lecture we covered [shellcheck](https://www.shellcheck.net/),which is a similar tool for shell scripts.

Most editors and IDEs support displaying the output of thees tools within the editor itself,highlighting the locations of warnings and errors.This is often called __code linting__ and it can also be used to display other types of issues such as stylistic violations or insecure constructs.

In vim,the plugins [ale](https://vimawesome.com/plugin/ale) or [syntastic](https://vimawesome.com/plugin/syntastic) will let you do that.For Python,[pylint](https://github.com/PyCQA/pylint) and [pep8](https://pypi.org/project/pep8/) are examples of stylistic linters and [bandit](https://pypi.org/project/bandit/) is a tool designed to find common security issues.For other languages people have compiled comprehensive lists of useful static analysis tools,such as [Awesome Static Analysis](https://github.com/mre/awesome-static-analysis)(you may want to take a look at the Writing section) and for linters there is [Awesome Linters](https://github.com/caramelomartins/awesome-linters).

A complementary tool to stylistic linting are code formatters such as [black](https://github.com/psf/black) for python,__gofmt__ fot Go,__rustfmt__ for Rust or [prettier](https://prettier.io/) for JavaScript,HTML and CSS.These tools autoformat your code so that it's consistent with common stylistic patterns for the given programming language.Although you might be unwilling  to give stylistic control about your code,standardizing code format will help other people read your code and will make you better at reading other people's(stylistically standardized)code.

## Profiling
Even if your code functionally behaves as you would expect,that might not be good enough if it takes all your CPU or memory in the process.Algorithms classes often teach big **O** notation but not how to find hot spots in your programs.Since [premature optimization is the root of all evil](http://wiki.c2.com/?PrematureOptimization),you should learn about profilers and monitoring tools.They will help you understand which parts of your program are taking most of the time and/or resources so you can focus on optimizing those parts.

### Timing
Similarly to the debugging case,in many scenarios it can be enough to just print the time it took your code between two points.Here is an example in Python using the [time](https://docs.python.org/3/library/time.html) module.
```python
import time, random
n = random.randint(1, 10) * 100

# Get current time
start = time.time()

# Do some work
print("Sleeping for {} ms".format(n))
time.sleep(n/1000)

# Compute time between start and now
print(time.time() - start)

# Output
# Sleeping for 500 ms
```
However,wall clock time can be misleading since your computer might be running other processes at the same time or waiting for events to happen.It is common for tools to make a distinction between Real,User and Sys time.In general,User+Sys tells you how much time your process actually spent in the CPU(more detailed explanation [here](https://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1).

- Real: Wall clock elapsed time from start to finish of the program,including the time taken by other processes and time taken while blocked(e.g. waiting for I/O or network)
- User:Amount of time spent in the CPU running user code
- Sys:Amount of time spent in the CPU running kernel code

For example,try running a command that performs an HTTP request and prefixing it with [time](https://www.man7.org/linux/man-pages/man1/time.1.html).Under a slow connection you might get an output like the one below.Here it took over 2 seconds for the request to complete but the process only took 15ms of CPU user time and 12ms of kernel CPU time.
```bash
$ time curl https://missing.csail.mit.edu &> /dev/null
```

### Profilers
### CPU
Most of the time when people refer to __profilers__ they actually mean CPU profilers,which are the most common.There are two main types of CPU profilers:tracing and sampling profilers.Tracing profilers keep a record of every function call your program makes whereas sampling profiles probe your program periodically(commonly every millisecond)and record the program's stack.They use these records to present aggregate statistics of what your program spent the most time doing.[Here](https://jvns.ca/blog/2017/12/17/how-do-ruby---python-profilers-work-) is a good intro article if you want more detail on this topic.

Most programming languages have some sort of command line profiler that you can use to analyze your code.They often integrate with full fledged IDEs but for this lecture we are going to focus on the command line tools themselves.

In Python we can use the __cProfile__ module to profile time per function call.Here is a simple example that implements a rudimentary grep in Python:
```python
#!/usr/bin/env python

import sys, re

def grep(pattern, file):
	with open(file, 'r') as f:
		print(file)
		for i, line in enumerate(f.readlines()):
			pattern = re.compile(pattern)
			match = pattern.search(line)
			if match is not None:
				print("{}: {}".format(i, line), end="")

if __name__ == '__main__':
	times = int(sys.argv[1])
	pattern = sys.argv[2]
	for i in range(times):
		for file in sys.argv[3:]:
			grep(pattern, file)
```
We can profile this code using the following command.Analyzing the output we can see that IO is taking most of the time and that compiling the regex takes a fair amount of time as well.Since the regex only needs to be compiled once,we can factor it out of the for.
```bash
$ python3 -m cProfile -s tottime grep.py 1000 '^(import|\s*def)[^,]*$' *.py
```
A caveat of Python's __CProfile__ profiler (and many profilers for that matter)is that they display time per function call.That can become unintuitive really fast,especially if you are using third party libraries in your code since internal function calls are also accounted for.A more intuitive way of displaying profiling information is to included the time taken per line of code,which is what line profilers do.

For instance,the following piece of Python code performs a request to the class website and parses the reponse to get all URLs in the page:
```bash
#!/usr/bin/env python
import requests
from bs4 import BeautifulSoup

# This is a decorator that tells line_profiler
# that we want to analyze this function
@profile
def get_urls():
	response = requests.get('https://missing.csail.mit.edu')
	s = BeautifulSoup(response.content, 'lxml')
	urls = []
	for url in s.find_all('a'):
		urls.append(url['href'])

if __name__ == '__main__':
	get_urls()
```
If we used Python's __cProfile__ profiler we'd get over 2500 lines of output,and even with sorting it'd be hard to understand where the time is being spent.A quick run with [line_profiler](https://github.com/pyutils/line_profiler) shows the time taken per line:
```bash
$ kernprof -l -v a.py
```
### Memory
In languages like C or C++ memory leaks can cause your program to never release memory that it doesn't need anymore.To help in the process of memory debugging you can use tools like [Valgrind](https://valgrind.org/) that will help you identify memory leaks.

In garbage collected languages like Python it is still useful to use a memory profiler because as long as you have pointers to objects in memory they won't be garbage collected.Here's an example program and its associated output when running it with [memory-profiler](https://pypi.org/project/memory-profiler/)(note the decorator like in __line-profiler__).
```python
@profile
def my_func():
	a = [1] * (10 ** 6)
	b = [2] * (2 *10 **7)
	del b
	return a

if __name__ == '__main__':
	my_func()
```
```bash
$ python3 -m memory_profiler example.py
```
### Event Profiling
As it was the case for __strace__ for debugging,you might want to ignore the specifics of the code that you are running and treat it like a black box when profiling.The [pref](https://www.man7.org/linux/man-pages/man1/perf.1.html) command abstracts CPU differences away and does not report time or memory,but instead it reports system events related to your programs.For example,__pref__ can easily report poor cache locality,high amounts of page faults or livelocks.Here is an overview of the command:
- __pref list__:List the events that can be traced with perf
- __pref stat COMMAND ARG1 ARG2__:Gets counts of different events related a process or command
- __perf record COMMAND ARG1 ARG2__:Records the run of a command and saves the statistical data into a file called __perf.data__.
- __perf report__:Formats and prints the data collected in __perf.data__.

### Visualization
Profiler output for real world programs will contain large amounts of information because of the inherent complexity of software projects.Humans are visual creatures and are quite terrible at reading large amounts of numbers and making sense of them.Thus there are many tools for displaying profiler's output in an easier to parse way.

One common way to display CPU profiling information for sampling profilers is to use a [Flame Graph](http://www.brendangregg.com/flamegraphs.html),which will display a hierarchy of function calls across the Y axis and time taken proportional to the X axis.They are also interactive,letting you zoom into specific parts of the program and get their stack traces(try clicking in the image below).   

![1](http://www.brendangregg.com/FlameGraphs/cpu-bash-flamegraph.svg)

Call graphs or controls flow graphs display the relationships between subroutines within a program by including functions as nodes and functions calls between them as directed edges.When coupled with profiling information such as the number of calls and time taken,call graphs can be quite useful for interpreting the flow of a program.In Python you can use the [pycallgraph](http://pycallgraph.slowchop.com/en/master/) library to generate them.

![2](https://upload.wikimedia.org/wikipedia/commons/2/2f/A_Call_Graph_generated_by_pycallgraph.png)

### Resource Monitoring
Sometimes,the first step towards analyzing the performance of your program is to understand what its actual resource consumption is.Programs often run slowly when they are resource constrained,e.g. without enough memory or on a slow network connection.There are a myriad of command line tools for probing and displaying different system resources like CPU usage,memory usage,network,disk usage and so on.

- __General Monitoring__:Probably the most popular is [htop](https://htop.dev/),which is an improved version of [top](https://www.man7.org/linux/man-pages/man1/top.1.html).__htop__ presents various statistics for the currently running processes on the system.__htop__ has a myriad of options and keybinds,some useful ones are:__<F6>__ to sort processes,__t__ to show tree hierarchy and __h__ to toggle threads.See also [glances](https://nicolargo.github.io/glances/) for similar implementation with a great UI.For getting aggregate measures across all processes,[dstat](http://dag.wiee.rs/home-made/dstat/) is another nifty tool that computes real-time resource metrics for lots of different subsystems like I/O,networking,CPU utilization,context switches,&c.
- __I/O operations__:[iotop](https://www.man7.org/linux/man-pages/man8/iotop.8.html) displays live I/O usage information and is handy to check if a process is doing heavy I/O disk operations
- __Disk Usage__:[df](https://www.man7.org/linux/man-pages/man1/df.1.html) displays metrics per partitions and [du](http://man7.org/linux/man-pages/man1/du.1.html) displays disk usage per file for the current directory.In these tools the __-h__ flag tells the program to print with human readable format.A more interactive version of __du__ is [ncdu](https://dev.yorhel.nl/ncdu) which lets you navigate folders and delete files and folders as you navigate.
- __Memory Usage__:[free](https://www.man7.org/linux/man-pages/man1/free.1.html) displays the total amount of free and used memory in the system.Memory is also displayed in tools like __htop__.
- __Open Files__:[lsof](https://www.man7.org/linux/man-pages/man8/lsof.8.html) lists file information about files opened by processes.It can be quite useful for checking which process has opened a specific file.
- __Network Connections and Config__:[ss](https://www.man7.org/linux/man-pages/man8/ss.8.html) lets you monitor incoming and outgoing network packets statistics as well as interface statistics.A common use case of __ss__ is figuring out what process is using a given ports in a machine.For displaying routing,nerwork devices and interfaces you can use [ip](http://man7.org/linux/man-pages/man8/ip.8.html).Note that __netstat__ and __ifconfig__ have been deprecated in favor of the former tools respectively.
- __Network Usage__:[nethogs](https://github.com/raboof/nethogs) and [iftop](http://www.ex-parrot.com/pdw/iftop/) are good interactive CLI tools for monitoring network usage.

If you want to test these tools you can also artificially impose loads on the machine using the [stress](https://linux.die.net/man/1/stress) command.

### Specialized tools
Sometimes,black box benchmarking is all you need to determine what software to use.Tools like [hyperfine](https://github.com/sharkdp/hyperfine) let you quickly benchmark command line programs.For instance,in the shell tools and scripting lecture we recommanded __fd__ over __find__.We can use __hyperfine__ to compare them in tasks we run often.E.g. in the example below __fd__ was 20x faster than __find__ in my machine.
```bash
$ hyperfine --warmup 3 'fd -e jpg' 'find . -iname "*.jpg"'
```
As it was the case for debugging,browsers also come with a fantastic set of tools of profiling webpage loading,letting you figure out where time is being spent(loading,rendering,scripting,&c).More info for [Firefox](https://profiler.firefox.com/docs/) and [Chrome](https://developers.google.com/web/tools/chrome-devtools/rendering-tools).
