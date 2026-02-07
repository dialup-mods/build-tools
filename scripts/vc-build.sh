#!/bin/bash
# VS Build wrapper

VCVARS="/c/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat"

cmd.exe /c "\"$VCVARS\" && make $*"

# capture / write status for makefile polling
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "OK" > .build_status
else
    echo "FAIL" > .build_status
fi

exit $EXIT_CODE
