# The website for https://crystal-china.org

# Development dependencies

- Crystal Progrmaming Language
- postgresql
- nodejs(yarn)
- (Optional)wasm-pack (only for used with bin/tinysearch to create search index for markdowns)

## Development

Install all necessary development dependencies, then run `lucky dev`.

## deployment

There are no runtime dependencies when deploying to a remote Linux environment except
one static binary with assets baked into it, and will auto mount when running.

Following is the process for create the static binary:

1. Run `shards run index` to create a [tinysearch](https://github.com/tinysearch/tinysearch) index for doc search.

2. Run `yarn prod` to package assets with mix(webpack).

3. To built a static binary use [sb_static](https://github.com/crystal-china/magic-haversack/blob/main/bin/sb_static) script.
   for more details instructions on building a static binary use zigcc, check [use zig gcc as an an alternative linker](https://github.com/crystal-china/magic-haversack/blob/main/docs/use_zig_cc_as_an_alternative_linker.md)

4. copy the built binary(`bin/crystal_china`) into remote linux host as `bin/crystal_china`, then 
   set the necessary ENV in file `.env`, check the [.env.sample](/.env.sample) for a example.
   You will have the following directory structure:
	```
	   .
	   ├── .env
	   └── bin/crystal_china
	```
    If server was started, you have to stop it before copy the binary. a more robust way to do this 
    is use a [binary diff tools](https://github.com/petervas/bsdifflib/) create patch locally, and then apply it on server.
    this way the server no stop requried, just need reboot systemd service after done patching.

5. Add a systemd service to start the server, review the configuration for the [crystal_china.service](/nginx/crystal_china.service)

6. Consider using [procodile](https://github.com/crystal-china/procodile) as an alternative for above .env and systemd services.

7. Optionally, use nginx as a reverse proxy. You can find configuration details in [nginx folder](/nginx)

## Contributing

1. Fork it (<https://github.com/zw963/website/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Billy.Zheng](https://github.com/zw963) - creator and maintainer
