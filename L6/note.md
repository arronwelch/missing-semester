# [Lecture 6: Version Control(git)](https://youtu.be/2sjqTHE0zok)
Version control systems(VCSs) are tools used to track changes to source code(or other collections of files and folders).As the name implies,these tools help maintain a history of changes;furthermore,they facilitate collaboration.VCSs track changes to a folder and its contents in a series of snapshots,where each snapshot encapsulates the entire state of files/folders within a top-level directory.VCSs also maintain metadata like who created each snapshot,messages associated with each snapshot,and so on.

Why is version control useful?Even when you're working by yourself,it can let you look at old snapshots of a project,keep a log of why certain changes were made,work on parallel branches of development,and much more.When working with others,it's an invaluable tool for seeing what other people have changed,as well as resolving conflicts in concurrent development.

Modern VCSs also let you easily (and often automatically) answer questions like:
- Who wrote this module?
- When was this particular line of this particular file edited?By whom?Why was it edited?
- Over the last 1000 revisions,when/why did a particular unit test stop working?

While other VCSs exist,**Git** is the de facto standard for version control.This [XKCD comic](https://xkcd.com/1597/) caputures Git's reputation:

![](https://imgs.xkcd.com/comics/git.png)

Because Git's interface is a leaky abstraction,learning Git top-down(starting with its interface/command-line interface) can lead to a lot of confusion.It's possible to memorize a handful of commands and think of them as magic incantations,and follow the approach in the comic above whenever anything goes wrong.

While Git admittedly has an ugly interface,its underlying design and ideas are beautiful.While an ugly interface has to be *memorized*,a beautiful design can be *understood*.For this reason,we give a bottom-up explanation of Git,starting with its data model and later covering the command-line interface.Once the data model is understood,the commands can be better understood in terms of how they manipulate the underlying data model.

## Git's data model
There are many ad-hoc approaches you could take to version control.Git has a well-thought-out model that enables all the nice features of version control,like maintaining history,supporting branches,and enabling collaboration.

### Snapshots
Git models the history of a collection of files and folders within some top-level directory as a series fo snapshots.In Git terminology,a file is called a "blob",and it's just a bunch of bytes.A directory is called a "tree",and it maps names to blobs or trees (so directories can contain other directories).A snapshot is the top-level tree that is being tracked.For example,we might have a tree as follows:
```bash
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
| 
+- baz.txt (blob, contents = "git is wonderful")
```

The top-level tree contains two elements,a tree "foo" (that itself contains one element,a blob "bar.txt"),and a blob "baz.txt".
### Modeling history:relating snapshots
How should a version control system relate snapshots?One simple model would be to have a linear history.A history would be a list of snapshots in time-order.For many reasons,Git doesn't use a simple model like this.

In Git,a history is a directed acyclic graph(DAG) of snapshots.That may sound like a fancy math word,but don't be intimidatead.All this means is that each snapshot in Git refers to a set of "parents",the snapshots that preceded it.It's a set of parents rather than s single parent (as would be the case in a linear history)because a snapshot might descend from multiple parents,for example,due to combining(merging) two parallel branches of development.

Git calls these snapshots "commit"s.Visualizing a commit history might look something like this:
```bash
 o <-- o <-- o <-- o
			 ^
			  \
			   --- o <-- o
```
In the ASCII art above,the **`o`**s correspond to individual commits(snapshots).The arrows point to the parent of each commit(it's a "comes before" relation,not "comes afer").After the third commit,the history branches into two separate branches.This might correspond to,for example,two separate features being developed in parallel,independently from each other.In the future,these branches may be merged to create a new snapshot that incorporates both of the features,producing a new snapshot that incorporates both of the features,producing a new history that looks like this,with the newly created merge commit shown in bold:
```bash
 o <-- o <-- o <-- o <--- o
			 ^           /
			  \         v
			   --- o <--o
```
Commits in Git are immutable.This doesn't mean that mistakes can't be corrected,however;it's just that "edits" to the commit history are actually creating entirely new commits,and references (see below) are updated to point to the new ones.

### Data model,as pseudocode
It may be instructive to see Git's data model written down in pseudocode:
```bash
// a file is a bunch of bytes
type blob = array<byte>

// a directory contains named files and directories
type tree = map<string, tree | blob>

// a commit has parents, metadata, and the top-level tree
type commit = struct {
	parents: array<commit>
	author: string
	message: string
	snapshot: tree
}
```

It's a clean,simple model of history.

### Objects and content-addressing
An "object" is a blob,tree,or commit:
```bash
type object = blob | tree | commit
```
In Git data store,all objects are content-addressed by their [SHA-1 hash](https://en.wikipedia.org/wiki/SHA-1).
```bash
objects = map<string, object>

def store(object):
	id = sha1(object)
	objects[id] = object

def load(id):
	return objects[id]
```
Blobs,trees,and commits are unified in this way:they are all objects.When they reference other objects,they don't actually *contain* them in their on-disk representation,but have a reference to them by their hash.

For example,the tree for the example directory structure [above](#snapshot)(visualized using **git cat-file -p 698281bc680d1995c5f4caaf3359721a5a58d48d**),looks like this:
```bash
100644 blob 4448adbf7ecd394f42ae135bbeed9676e894af85    baz.txt
040000 tree c68d233a33c5c06e0340e4c224f0afca87c8ce87    foo
```
The tree itself contains pointers to its contents,**baz.txt**(a blob) and **foo**(a tree).If we look at the contents addresses by the hash corresponding to baz.txt with **git cat-file -p 4448adbf7ecd394f42ae135bbeed9676e894af85**,we get the following:
```bash
git is wonderful
```
### References
Now,all snapshots can be identified by their SHA-1 hashes.That's inconvenient,because humans aren't good at remembering string of 40 hexadecimal characters.


