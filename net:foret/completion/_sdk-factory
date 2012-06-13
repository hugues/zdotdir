#compdef sdk-factory.sh

local arguments
arguments=(
        '(-s)'{-a,--enable-all-protocols}'[Enable all protocols]'
        {-c+,--config=}'[Selects config FILE to use]:file:_files'
        {-d,--debug-make}'[Add debugging verbosity to make]'
        '(-p)'{-f,--framework-only}'[Generates only the framework libraries]'
        '(-f)'{-p,--protocols-only}'[Generates only the protocols bundle libraries]'
        {-g,--enable-debug-info}'[Enable debug info in binaries]'
        {-h,--enable-host}'[Enable host binaries building]'
        {-n,--nomake}'[No make done]'
        {-s,--enable-specific-protocols}'[Enable specific protocols]'
        {-v,--verbose}'[Enable verbose compilation]'
        '1:targets:(($([ -n "$TARGET" ] && for i in "\:Standard_SDK"\
                                                   "-PLUGIN\:Plugin_SDK"\
                                                   "-APPSDK\:Advanced_Plugin_SDK"\
                                                   "-PERF\:Performance_tests" ;\
                                              echo $TARGET$i)))'
        )

_arguments $arguments

