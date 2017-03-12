define skipdir_python
python
# get all sources loadable by gdb
def GetSources():
    sources = []
    for line in gdb.execute('info sources',to_string=True).splitlines():
        if line.startswith("/"):
            sources += [source.strip() for source in line.split(",")]
    return sources

# get a list of all sources already skipped
def GetSkipSources():
    sources = set();
    for line in gdb.execute('info skip',to_string=True).splitlines():
        sources.add(line.split()[3]);
    return sources

# skip source files of which the (absolute) path starts with 'dir'
def SkipDir(dir):
    sources = GetSources()
    skipsources = GetSkipSources()
    for source in sources:
        if source.startswith(dir):
            if source not in skipsources:
                gdb.execute('skip file %s' % source, to_string=True)

# time function
def Timed(timed, function, *args, **kwargs):
    if timed:
        import timeit
        t = timeit.Timer(lambda: function(*args, **kwargs))
        try:
            print t.timeit(1)," Seconds"
        except:
            t.print_exc()
    else:
        function(*args, **kwargs)

# apply only for c++
if 'c++' in gdb.execute('show language', to_string=True):
    dir = str(gdb.parse_and_eval("$skipdirargument"))
    dir = dir.replace("\"","");
    show_runtime = False
    Timed(show_runtime,SkipDir,dir)
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

