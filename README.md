# ElixirSassReloader

This module will watch for file changes in `priv/scss/` and launch sassc to
compile them and write them to `priv/static/css/app.css`.
This can be usefull during development when you don't want to use webpack.

## Installation

```elixir
def deps do
  [
    {:elixir_sass_reloader, git: "https://github.com/l-vincent-l/elixir-sass-reloader.git"}
  ]
end
```
