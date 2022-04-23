
$ git push
ssh: connect to host github.com port 22: Connection timed out
fatal: Could not read from remote repository.

# This should also timeout
$ ssh -T git@github.com
ssh: connect to host github.com port 22: Connection timed out

# but this might work
$ ssh -T -p 443 git@ssh.github.com
...           yes
Hi xxxx! You've successfully authenticated, but GitHub does not provide shell access.

# Override SSH settings

$ vim ~/.ssh/config
```
Host github.com
	Hostname ssh.github.com
	Port 443
```

$ ssh -T git@github.com
Hi xxxxx! You've successfully authenticated, but GitHub does not
provide shell access.

$ git push
