# HCL-VARIABLE-WIKI-GENERATOR

If you are tired of documenting the input variables for your terraform modules, then you can use this script

## Steps

- `bundle install`
- `ruby wiki_generator.rb <path-to-variables.tf>`

## Known Issues

- Defaults for map & list are not being deduced
