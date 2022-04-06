# [Editors (Vim)]()
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
installed [Vim emulation for VS code](https://github.com/VSCodeVim/Vim)).Vim is probably worth learning evern
if you finally end up switching to some other text editor.

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
