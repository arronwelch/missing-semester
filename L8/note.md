# [Metaprogramming](https://youtu.be/_Ms1Z4xfqv4)
What do we mean by "metaprogramming"?Well,it was the best collective term we could come up with for the set of things that are more about *process* than they are about writing code or working more efficiently.In this lecture,we will look at systems for building and testing your code,and for managing dependencies.These may seem like they are of limited importance in your day-to-day as a student,but the moment you interact with a larger code base through an internship or once you enter the "real world",you will see this everywhere.We should note that "metaprogramming" can also mean "[programs that operate on programs](https://en.wikipedia.org/wiki/Metaprogramming)",whereas that is not quite the definition we are using for the purpose of this lecture.

## Build systems
If you write a paper in LaTex,what are the commands you need to run to produce your paper?What about the ones used to run your benchmarks,plot them,and then insert that plot into your paper?Or to compile the code provided in the class you're taking and then running the tests?

For most projects,whether they contain code or not,there is a "build process".Some sequence of operations you need to do to go from your inputs to your outputs.Often,that process might have many steps,and many branches.Run this to generate this plot,that to generate those results,and something else to produce the final paper.As with so many of the things we have seen in this class,you are not the first to encounter this annoyance,and luckily there exist many tools to help you!

These are usually called "build systems",and there are *many* of them.Which one you use depends on the task at hand,your language of preference,and the size of the project.At their core,they are all very similar though.You define a number of *dependencies*,a number of *targets*,and *rules* for going from one to the other.You tell the build system that you want a particular target,and its job is to find all the transitive dependencies of that target,and then apply the rules to produce intermediate targets all the way until the final target has been produced.Ideally,the build system does this without unnecessarily executing rules for targets whose dependencies haven't changed and where the result is available from a previouds build.

__make__ is one of the most common build systems out there,and you will usually find it installed on pretty much any UNIX-based computer.It has its warts,but works quite well for simple-to-moderate projects.When you run __make__,it consults a file called __Makefile__ in the current directory.All the targets,their dependencies,and the rules are defined in that file.Let's take a look at one:
```Makefile
paper.pdf: paper.tex plot-data.png
	pdflatex paper.tex
plot-%.png: %.dat plot.py
	./plot.py -i $*.dat -o $@
```
Each directive in this file is a rule for how to produce the left-hand side using the right-hand side.Or,phrased differently,the things named on the right-hand side are dependencies,and the left-hand side is the target.The indented block is a sequence of programs to produce the target from those dependencies.In __make__,the first directive also defines the default goal.If you run __make__ with no arguments,this is the target it will build.Alternatively,you can run something like __make plot-data.png__,and it will build that target instead.

The __%__ in a rule is a "pattern",and will match the same string on the left and on the right.For example,if the target __plot-foo.png__ is requested,__make__ will look for the dependencies __foo.dat__ and __plot.py__.Now let's look at what happens if we run __make__ with an empty source directory.

