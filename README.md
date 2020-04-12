This question comes round again every once in a while: *How do I combine `curl|bash` with prompting for user input?*

Let's assume there's a genuine need to solve the problem, and you've already thought deeply about whether
the tradeoffs of using `curl|bash` make sense for your situation.

To recap the problem:

`curl $URL | bash` reads a script from your webserver and pipes it to `bash`'s stdin. Because stdin is tied up
with receiving the script, any attempt to read interactive user input is actually going to cannibalize your script
content.

Simple example:

```
$ cat foo
echo -n "Enter some input: "
read X
# example comment
echo "You wrote \"$X\""
```
```
$ cat foo | bash
Enter some input: You wrote "# example comment"
```
Or if you prefer an online example:
```
$ curl -sL https://raw.githubusercontent.com/jlabusch/curl_bash_with_input/master/script.sh | bash
Enter some input: You wrote "# example comment"
```

Working around this situation has two parts:
 * Get your script content downloaded completely
 * Make stdin work for user input

The first part is solved with a wrapper script:
```
curl -sL $MY_URL -o foo
chmod 755 foo
exec foo
```
(Full example [here](https://github.com/jlabusch/curl_bash_with_input/blob/master/wrapper.sh))

The second part is solved using some less common `exec` syntax (described more fully
[here](https://www.tldp.org/LDP/abs/html/x17974.html)) and the fact that underneath it all
there's really no difference between stdin, stdout and stderr. They're all just files, as far
as Linux is concerned. So we're going to repurpose stderr as our new stdin.
```
$ cat foo
exec 0<$(realpath /proc/self/fd/2)  # 0 is stdin's file descriptor,
                                    # /proc/self/fd/2 points to our stderr e.g. /dev/pts/27
echo -n "Enter some input: "
read X
# example comment
echo "You wrote \"$X\""
```
Putting it all together:
```
curl -sL https://raw.githubusercontent.com/jlabusch/curl_bash_with_input/master/wrapper.sh | bash
```
