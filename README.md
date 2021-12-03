# podeps
List OSS packages used in a CocoaPods project

## Installation

```bash
% git clone https://github.com/shinyaishida/podeps.git
% cd podeps
% bundle
```

## Usage

`podeps.rb` is a script to get a list of Pods managed by CocoaPods. This list
includes the name, version, and license of each Pod. This script requires that 
at least a build target defined in Podfile is specified by the `-e` option. 
Otherwise, no Pods are listed.

```bash
% ./podeps.rb -h
usage: deps.rb [options] [<Podfile> [<Podfile.lock>]]
    -e, --env ENVIRONMENT            add an environment
    -f, --format FORMAT              output format (json, csv)
    -h, --help                       print help
% cd /some/project/using/cocoapods
% /path/to/podeps/podeps.rb -e <target>
```

Note that, if a target you want to specify is an inner target without a 
`inherit! :search_paths` statement, you must join the outer and inner target
names with a hyphen; `<outer-target>-<inner-target>`.

This script is tested with Ruby 2.6.3 (macOS native, which is recommended by
CocoaPods).

## License

MIT

## Author

[shinyaishida](https://github.com/shinyaishida)
