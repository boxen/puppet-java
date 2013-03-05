#!/bin/sh
#
# Invoke java with the $DYLD_LIBRARY_PATH set with the homebrew lib dir.
# This allows java to load native libraries installed via homebrew.

export DYLD_FALLBACK_LIBRARY_PATH="$BOXEN_HOME/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH"

if [ -x /usr/libexec/java_home ]; then
  export JAVA_HOME=`/usr/libexec/java_home`
fi

exec /usr/bin/java "$@"
