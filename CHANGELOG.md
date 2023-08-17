# Changelog

This project partially adheres to [semver
2.0.0](http://semver.org/spec/v2.0.0.html) with the exception that breaking
changes can be introduced on MINOR level up until v1.0.0. It also follows the
recommendations of [keepachangelog.com](http://keepachangelog.com/).

## Unreleased

### Breaking Changes
- Rename config to configuration

### Added
- None

### Fixed
- None

### Changed
- None

### Removed
- None

### Security
- None

### Deprecated
- None

## v0.3.6

### Fixed
- `Response` instance now includes required `min_api_version` in the root of request params taken from inputs.

## v0.3.5

### Added
- `Response` instance now delegates to params via `method_missing`.
```
params = { foo: { bar: :baz }}
response = Viberroo::Response.new(params)
# Previously, those could only be accessed through params:
puts response.params.foo.bar
# Now those can be accessed directly:
puts response.foo.bar
```

## v0.3.4
Start a changelog.

### Breaking Changes
- None

### Fixed
- Add empty default `Viberroo::Response` instance to `Viberroo::Bot` constructor to avoid setting redundant objects during webhook subscription phase e.g. `Viberro::Bot.new(response: Viberroo::Response.new({})).set_webhook` becomes `Viberro::Bot.new.set_webhook`.
- Fix Ruby version compatibility from `2.4` to correctly specified `2.3`.

### Deprecated
- Deprecate `Bot#send`. Will get replaced by `Bot#send_message` in next minor release.

### Added
- Add `Bot#send_message` that acts same as `Bot#send`.

### Removed
- Logger entry for every `Bot` request that had no configuration options.

