# The website for https://crystal-china.org

# Development dependencies

- Crystal Progrmaming Language
- postgresql
- node(yarn)
- wasm-pack (only for bin/tinysearch create index for docs)

## Development

Install all necessry development dependencies, then run `lucky dev`

## deployment

There is no any dependenies when deploy to a remote linux server,
except one static binary, with assets baked into the bianry itself.

Following is the process for create the static binary:

1. `shards run index` to create a [tinysearch](https://github.com/tinysearch/tinysearch) index file into tmp/index.json.
2. `yarn wasm` create wasm file from index.json which used in doc search.
3. `yarn prod` to package the assets use mix with webpack.
4.  built static binary use [sb_static](https://github.com/crystal-china/magic-haversack/blob/main/bin/sb_static) script.
    more details about how to built a static binary use zigcc check [use zig gcc as an an alternative linker](https://github.com/crystal-china/magic-haversack/blob/main/docs/use_zig_cc_as_an_alternative_linker.md)
5. copy this binary(e.g. crystal china) into remote linux host, use following form.
   .
   ├── .env
   └── bin/crystal_china
6. set the necessory ENV into .env

## Contributing

1. Fork it (<https://github.com/zw963/website/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Billy.Zheng](https://github.com/zw963) - creator and maintainer
