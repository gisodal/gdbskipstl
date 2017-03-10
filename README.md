# Prevent GDB from stepping into STL headers

The .gdbinit file contains the script to prevent GDB from stepping into STL source files and other in '/usr'. It searches through the sources that gdb has loaded or will potentially load (gdb command info sources), and skips them when their absolute path starts with "/usr". It's hooked to the run command, because symbols might get reloaded when executing it.

Its easy to extend the script to also skip other directories, by adding a call to SkipDir(<some/absolute/path>).
