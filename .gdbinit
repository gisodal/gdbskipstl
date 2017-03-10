define skipdir_python
python
# get all sources loadable by gdb
def GetSources():
    sources = []
    for line in gdb.execute('info sources',to_string=True).splitlines():
        if line.startswith("/"):
            sources += [source.strip() for source in line.split(",")]
    return sources

# skip source files of which the (absolute) path starts with 'dir'
def SkipDir(dir):
    sources = GetSources()
    for source in sources:
        if source.startswith(dir):
            gdb.execute('skip file %s' % source, to_string=True)

# apply only for c++
if 'c++' in gdb.execute('show language', to_string=True):
    dir = str(gdb.parse_and_eval("$skipdirargument"))
    dir = dir.replace("\"","");
    SkipDir(dir)
end
end

# skip all files in provided directory
define skipdir
    if $argc != 1
        echo Usage: skipdir </absolute/path>\n
    else
        set $skipdirargument = "$arg0"
        skipdir_python
    end
end

# skip all STL source files and other libraries in '/usr'
define skipstl
    skipdir /usr/include
end

# hooks that run skipstl
define hookpost-run
    skipstl
end
define hookpost-start
    skipstl
end
define hookpost-attach
    skipstl
end

