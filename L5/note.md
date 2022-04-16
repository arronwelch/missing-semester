# [Command-line Environment](https://youtu.be/e8BO_dYxk5c)
In this lecture we will go through several ways in which you can improve your workflow when using the shell.We have been working with the shell for a while now,but we have mainly focused on executing different different commands.We will now see how to run several processes at the same time while keeping track of them,how to stop or pause a specific process and how to make a process run in the background.

We will also learn about different ways to improve your shell and other tools,by defining aliases and configuring them using dotfiles.Both of these can help you save time,e.g. by using the same configurations in all your machines without having to type long commands.We will look at how to work with remote machines using SSH.

## Job Control
In some cases you will need to interrupt a job while it is executing,for instance if a command is taking too long to complete(such as a **find** with a very large directory structure to search through).Most of the time,you can do **Ctrl-c** and the command will stop.But how does this actually work and why does it sometimes fail to stop the process?

### Killing a process
Your shell is using UNIX communication mechanism called a *signal* to communicate information to the process.When a process receives a signal it stops its execution,deals with the signal and potentially changes the flow of execution based on the information that the signal delivered.For this reason,signals are *software intterrupts*.

In out case,when typing **Ctrl-c** this prompts the shell to deliver a **SIGINT** signal to the process.

Here's a minimal example of a Python program that captures **SIGINT** and ignores it,no longer stopping.To kill this program we can now use the **SIGQUIT** signal instead,by typing **Ctrl-\**.
```python
#!/usr/bin/env python3
import signal, time

def handler(signum, time):
    print("\nI got a SIGINT, but I am not stopping")

signal.signal(signal.SIGINT,handler)
i = 0
while True:
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```
Here's what happens if we send **SIGINT** twice to this program,followed by **SIGQUIT**.Note that **^** is how **Ctrl** is displayed when typed in the terminal.
```bash
$ python sigint.py
24^C
I got a SIGINT, but I am not stopping
26^C
I got a SIGINT, but I am not stopping
^\[1]    152522 quit (core dumped)  python sigint.py
```
While **SIGINT** and **SIGQUIT** are both ususlly associated with terminal related requests,a more generic signal for asking a process to exit gracefully is the **SIGTERM** signal.To send this signal we can use the [kill](https://www.man7.org/linux/man-pages/man1/kill.1.html) command,with the syntax **kill -TERM [PID]**
### Psusing and backgrounding process
Signals can do other things beyond killing a process.For instance,**SIGSTOP** pauses a process.In the terminal,typing **Ctrl-z** will prompt the shell to send a **SIGTSTP** signal,short for Terminal Stop(i.e. the terminal's version of SIGSTOP).

We can then continue the paused job in the foreground or in the background using [fg](https://www.man7.org/linux/man-pages/man1/fg.1p.html) or [bg](http://man7.org/linux/man-pages/man1/bg.1p.html),respectively.

The [jobs](ihttps://www.man7.org/linux/man-pages/man1/jobs.1p.html) command lists the unfinished jobs associated with the current terminal session.You can refer to those jobs using their pid(you can use [pgrep]()to find that out).More intuitively,you can also refer to a process using the percent symbol followed by its jobs number(displayed by **jobs**).To refer to the last backgrounded job you can use the **$!** special parameter.

One more thing to know is that the **&** suffix in a command will run the command in the background,giving you the prompt back,although it will still use the shell's STDOUT which can be annoying (use shell redirections in that case).

To background an already running program you can do **Ctrl-Z** followed by **bg**.Note that backgrounded processes are still  children processes of your terminal and will die if you close the terminal (this will send yet another signal,**SIGHUP**).To prevent that from happening you can run the program with [nohup]() (a wrapper to ignore **SIGHUP**),or use **disown** if the process has already been started. Alternatively,you can use a terminal multiplexer as we will see in the next section.

Below is a sample session to showcase some of these concepts.
```bash
t:(master) ✗ sleep 1000
^Z
[1]  + 27147 suspended  sleep 1000
➜  L5 git:(master) ✗ nohup sleep 2000 &
[2] 27197
nohup: ignoring input and appending output to 'nohup.out'                                                     
➜  L5 git:(master) ✗ jobs
[1]  + suspended  sleep 1000
[2]  - running    nohup sleep 2000
➜  L5 git:(master) ✗ bg %1
[1]  - 27147 continued  sleep 1000
➜  L5 git:(master) ✗ jobs
[1]  - running    sleep 1000
[2]  + running    nohup sleep 2000
➜  L5 git:(master) ✗ kill -STOP %1
[1]  + 27147 suspended (signal)  sleep 1000                                                                   
➜  L5 git:(master) ✗ jobs
[1]  + suspended (signal)  sleep 1000
[2]  - running    nohup sleep 2000
➜  L5 git:(master) ✗ kill -SIGHUP %1
[1]  + 27147 hangup     sleep 1000                                                                            
➜  L5 git:(master) ✗ jobs
[2]  + running    nohup sleep 2000
➜  L5 git:(master) ✗ kill -SIGHUP %2
➜  L5 git:(master) ✗ jobs
[2]  + running    nohup sleep 2000
➜  L5 git:(master) ✗ kill %2        
[2]  + 27197 terminated  nohup sleep 2000                                                                     
➜  L5 git:(master) ✗ jobs   
```
A special signal is **SIGKILL** since it cannot be captured by the process and it will always terminate it immediately.However,it can have bad side effects such as leaving orphaned children processes.

You can learn more about these and other signals [here]() or typing [man 7 signal]() or **kill -l**.

## Terminal Multiplexers
When using the command line interface you will often want to run more than one thing at once.For instance,you might want to run your editor and your program side by side.Although this can be achieved by opening new terminal windows,using a terminal multiplexers is a more versatile solution.

Terminal multiplexers like [tmux]() allow you to multiplex terminal windows using panes and tabs so you can interact with multiple shell sessions.Moreover,terminal multiplexers let you detach a current terminal session and reattach at some point later in time.This can make your workflow much better when working with remote machines since it avoids the need to use **nohup** and similar tricks.

The most popular terminal multiplexer these days is [tmux]().**tmux** is highly configurable and by using the associated keybindings you can create multiple tabs and panes and quickly navigate through them.

**tmux** expects you to konw its keybindings,and they all have the form **<C-b>** **x** where that means(1) press **Ctrl+b**,(2)release **Ctrl+b**,and then(3) press **x**.**tmux** has the following hierarchy of objects:

- **Sessions**-a session is an independent workspace with one or more windows
    - **tmux** starts a new session.
    - **tmux new -s NAME** starts it with that name.
    - **tmux ls** lists the current sessions.
    - Within **tmux** typing **<C-b> d** detaches the current session.
    - **tmux a** attaches the last session.You can use **-t** flag to specify which
- **Windows**-Equivalent to tabs in editors or browsers,they are visually separate parts of the same session
    - **<C-b> c** Creates a new window.To close it you can just terminate the shells doing **<C-d>**

