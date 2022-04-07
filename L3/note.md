# [Editors (Vim)](https://youtu.be/a6Q8Na575qc)
Writing English words and writing code are very different activities.When
programming,you spend more time switching files,reading,navigating,and
editing code compared to writing a long stream.It makes sense that there are
different types of programs for writing English words versus code(e.g. Microsoft
Word versus Visual Studio Code).

As programmers,we spend most of our time editing code,so it's worth
inversting time mastering an editor that fits your needs.Here's how you learn a
new editor:  
 - start with a tutorial(i.e. this lecture,plus resources that we point out)  
 - Stick with using the editor for all your text editing needs (even if it slows you
down initialy)  
 - Look things up as you go: if ti seems like there should be a better way to do
something,there probably is  

If you follow the above method,fully committing to using the new program for
all text editing purposes,the timeline for learning a sophisticated text editor
looks like this.In an hour or two,you'll learn basic editor functions such as
opening and editing files,save/quit,and navigating buffers.Once you're 20 
hours in,you will have enough knowledge and muscle memory that using
the new editor saves you time.Modern text editors are fancy and powerful
tools,so the learning never stops:you'll get even faster as you learn more.

## Which editor to learn?
Programmers have [strong opinions](https://en.wikipedia.org/wiki/Editor_war) about their text editors.

Which editors are popular today?See this [Stack Overflow survey](https://insights.stackoverflow.com/survey/2019/#development-environments-and-tools)
(there may be some bias because Stack Overflow users may not be 
representative of programmers as a whole).[Visual Studio Code](https://code.visualstudio.com/)
is the most popular editor.[Vim](https://www.vim.org/)is the most popular command-line-based
editor.

### Vim

All the instructors of this class use Vim as their editor.Vim has a rich
history;it originated from the Vi editor(1976),and it's still being developed
today.Vim has some really neat ideas behind it,and for this reason,lots of 
tools support a Vim emulation mode (for example,1.4 million people have 
installed [Vim emulation for VS code](https://github.com/VSCodeVim/Vim)).
Vim is probably worth learning evern if you finally end up switching to 
some other text editor.

It's not possible to teach all of Vim's functionality in 50 minutes,so we're 
going to focus on explaining the philosophy of Vim,teaching you the basics,
showing you some of the more advanced functionality,and giving you the resources
to master the tool.

## Philosophy of Vim
When programming,you spend most of your time reading/editing,not writing.
For this reason,Vim is a *modal* editor:it has different modes for inserting
text vs manipulating text.Vim is programmable(with Vimscript and also other
languages like Python),and Vim's interface itself is a programming language:
keystrokes(with mnemonic names) are commands,and these commands are 
composable.Vim avoids the use of the mouse,because it's too slow;VIm even
avoids using the arrow keys because it requires too much movement.

The end result is an editor that can match the speed at which you think.

## Modal editing

Vim's design is based in the idead that a lot of programmer time is spent
reading,navigating,and making small edits,as opposed to writing long
streams of text.For this reason,Vim has multiple operating modes.

 - **Normal**: for moving around a file and making edits
 - **Insert**: for inserting text
 - **Replace**: for replacing text
 - **Visual**(plain,line,or block):for selecting blocks of text
 - **Command-line**:for running a command

Keystrobe have different meanings in different operating modes.For example,
the letter **x** in insert mode will just insert a literal character 'x',but
in Normal mode,it will delete the character under the curser,and in Visual
mode, it will delete the selection.

In its default configuration,Vim shows the current mode in the bottom left.
The initial/default mode is Normal mode.You'll generally spend most of your
time between Normal mode and Insert mdoe.

You changed modes by pressing **<Esc>** (the escape key) to switch form any
mode back to Normal mode.From Normal mdoe,enter Insert mode with **i**,
Replace mode with **R**,Visual mode with **v**,Visual Line mode with **V**,
Visual Block mode with **<C-v>**(Ctrl-V,sometimes also written **^V**),and 
Command-line mode with **:**.

You use the **<Esc>** key a lot when using Vim:consider remapping Caps Lock 
to Escape([macOS instructions](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_macOS)).

## Basics
### Inserting text
From Normal mode,press **i** to enter Insert mode.Now,Vim behaves like any
other text editor,untill you press **<Esc>** to return to Normal mode.This,
along with the basics explained above,are all you need to start editing files
using Vim(though not particularly efficiently,if you're spending all your
time editing from Insert mode).
### Buffer,tabs,and windows
Vim maintains a set of open files,called "buffers".A Vim session has a number
of tabs,each of which has a number of windows(split panes).Each window shows
a single buffer.Unlike other programs you are familiar with,like web browsers,there is not a 1-to-1 correspondence between buffers and windows;even within
the same tab.This can be quite handy,for example,to view two different parts
of a file at the same time.

By default,Vim opens with a single tab,which contains a single window.

### Command-line
Command mode can be enterred by typing **:** in in Normal mode.Your cursor will
jump to the command line at the bottom of the screen upon pressing **:**.This
mode has many functionalities,including opening,saving,and closing files,and
[quitting Vim](https://twitter.com/iamdevloper/status/435555976687923200).

 - **:q** quit(close window)
 - **:w** save("write")
 - **:wq** save and quit
 - **:e** {name of file} open file for editing
 - **:ls** show open buffers
 - **:help {topic}** open help
	 - **:help :w** opens help for the **:w** command
	 - **:help w** opens help for the **w** movement
## Vim's interface is a programming language
The most important idea in Vim is that Vim's interface itself is a programming
language.Keystrokes (with mnemonic names) are commands,and these commands compose..
This enables efficient movement and edits,especially once the commands become muscle
memory.

### Movement
You should spend most of your time in Normal mode,using movement commands to navigate 
the buffer.Movements in Vim are also callled "nouns",because they refer to chunks of text.
 - Basic movement: **hjkl**(left,down,up,right)
 - Words:**w**(next word),**b**(beginning of word),**e**(end of word)
 - Lines:**0**(begining of line),**^**(first non-blank character),**$**(end of lien)
 - Screen:**H** (top of screen),**M**(middle of screen),**L**(bottom of screen)
 - Scroll:**Ctrl-u**(up),**Ctrl-d**(down)
 - File:**gg**(beginning of file),**G**(end of file)
 - Line numbers:**:{number}<CR>** or **{number}G** (line{number})
 - Misc:**%** (corresponding item)
 - Find:**f{character}**,**t{character}**,**F{character}**,**T{character}**
	- find/to forward/backward{character} on the current line
	- **,** / **;** for navigating matches
 - Search:**/{regex}**,**n** / **N** for navigating matches

### Selection
Visual modes:
- Visual:**v**
- Visual Line:**V**
- Visual Block:**Ctrl-v**
Can use movement keys to make selection.

### Edits
Everything that you used to do with the mouse,you now do with the keyboard
using editing commands that compose with movement commands.Here's 
where Vim's interface starts to look like a programming language.Vim's editing
commands are also called "verbs",because verbs act on nouns.

- **i** enter insert mode
	- but for manipulating/deleting text,wnat to use something more than
	backspace
- **o** / **O** insert line below / above
- **d{motion}** delete {motion}
	- e.g. **dw** is delete word,**d$** is delete to end of line,**d0** is delete to
	beginning of line
- **c{motion}** change {motion}
	- e.g. **cw** is change word
	- like **d{motion} followed by **i**
- **x** delete character (equal to **dl**)
- **s** substitute character (equal to **xi**)
- Visual mode + manipulation
	- select text,**d** to delete it or **c** change it
- **u** to undo,**<C-r>** to redo
- **y** to copy / "yank"(some other commands like **d** also copy)
- **p** to paste
- Lots more to learn:e.g. **~** filps the case of a character

### Counts
You can combine nouns and verbs with a count,which will perform a given
action a number of times.

- **3w** move 3 words forward
- **5j** move 5 lines down
- **7dw** delete 7 words

### Modifiers
You can use modifiers to change the meaning of a noun.Some modifiers are **i**,
which means "inner" or "inside",and **a**,which means "around".

- **ci(** change the contents inside the current pair of parentheses
- **ci[** change the contents inside the current pair of square brackets
- **da'** delete a single-quoted string,including the surrounding single quotes

## Demo
Here is broken [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz) implementation:

```python
def fizz_buzz(limit):
	for i in range(limit):
		if i % 3 == 0:
			print('fizz')
		if i % 5 == 0:
			print('fizz')
		if i % 3 and i % 5:
			print(i)

def main():
	fizz_buzz(10)
```
we will fix the following issues:
- Main is never called
- Start at 0 instead of 1
- Prints "fizz" and "buzz" on separate lines for multiples of 15
- Prints "fizz" for multiples of 5
- Uses a hard-coded argument of 10 instead of taking a command-line argument

See the lecture video for the demonstration.Compare how the above changes
are made using Vim to how you might make the same edits using another
program.Notice how very few keystrobes are required in vim,allowing you to
edit at the speed you think.

## Customizing Vim
Vim is customized through a plain-text configuration file in **~/.vimrc**
(containing Vimscript commands).There are probably lost of basic settings that
you want to turn on.

We are providing a well-documented baisc config that you can use as a starting
point.We recommand using this because it fixes some of Vim's quirky defualt
behavior.**Download our cinfig [here](https://missing.csail.mit.edu/2020/files/vimrc) and save it to **`~/.vimrv`****.

Vim is heavily customizable,and it's worth spending time exploring
customization options.You can look at people's dotfiles on GitHub for
inspiration,for example,your instructors's Vim configs([Anish](),[Jon]()
(uses [neovim](),[Jose]()).There are lots of good blog posts on this topic too.
Try not to copy-and-paste people's full configuration,but read it,understand it,and take
what you need.
