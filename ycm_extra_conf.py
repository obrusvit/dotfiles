# This file is NOT licensed under the GPLv3, which is the license for the rest
# of YouCompleteMe.
#
# Here's the license text for this file:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

compilationDatabase = ''

flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
'-DNDEBUG',

# set the language
'-x',
'c++',
'-std=c++2a',

'-I', 'include',

# run 'c++ -v -E -x c++ -'
'-isystem', '/usr/include/c++/9',
'-isystem', '/usr/include/x86_64-linux-gnu/c++/9',
'-isystem', '/usr/include/c++/9/backward',
'-isystem', '/usr/lib/clang/10/include',
'-isystem', '/usr/local/include',
'-isystem', '/usr/include/x86_64-linux-gnu',
'-isystem', '/usr/include',

]

def getCompileCommandsDirs(jsonPath):
    import json
    import re
    retSet = set()  # set to prevent duplicates

    with open(jsonPath) as f:
        compileCommands = json.loads(f.read())

    for fileCompiled in compileCommands:
        command = fileCompiled['command']
        for d in re.findall(r'(-isystem){1}(\s)([^\s]+)', command):
            # system includes, res in group3: (-isystem){1}(\s)([^\s]+)
            retSet.add(d[0] + d[2] )
        for d in re.findall(r'(\-I[^\s]+)', command):
            # include directories
            retSet.add(''.join(d))
        for d in re.findall(r'(\-D[^\s]+)', command):
            # compiler directives in group1:  (\-D[^\s]+)
            retSet.add(''.join(d))
        for d in re.findall(r'(\-W[^\s]+)', command):
            # warning flags
            retSet.add(''.join(d))
    return list(retSet)


def Settings( **kwargs ):
    import os
    global flags
    global compilationDatabase
    if os.path.isfile(compilationDatabase):
        flagsFromDatabase = getCompileCommandsDirs(compilationDatabase)
        finalFlags = flags + flagsFromDatabase
    else:
        finalFlags = flags
    return {
        'flags': finalFlags,
    }
