#compdef sdk-qa.sh

_arguments -A "-*" \
        -- \
        "*=FILE*:file:_files"\
        "*{-c,--config}:file:_files"\
        ":targets:($([ -n "$TARGET" ] && for i in "" "-PLUGIN" "-APPSDK" "-PERF" ; echo $TARGET$i))"

