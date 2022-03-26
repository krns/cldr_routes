# Cldr Routes

Generate localized routes and route helper
modules.

This module when `use`d , provides a `localize/1` macro that is designed to wrap the standard Phoenix route macros such as `get/3`, `put/3` and `resources/3` and localises them for each locale defined in a Gettext backend module attached to a Cldr backend module.

Translations for the parts of a given route path are translated at compile-time which are then combined into a localised route that is added to the standard Phoenix routing framework.

As a result, users can enter URLs using localised terms which can enhance user engagement and content relevance.

Similarly, a localised path and URL helpers are generated that wrap the standard Phoenix helpers to supporting generating localised paths and URLs.

## Setting up

A `Cldr` backend module that configures an associated `gettext` backend is required.

Path parts (the parts between "/") are translated at compile time using `Gettext`. Therefore localization can only be applied to locales that are defined in a [gettext backend module](https://hexdocs.pm/gettext/Gettext.html#module-using-gettext) that attached to a `Cldr` backend module. For example:

```elixir
defmodule MyApp.Cldr do
  use Cldr,
    locales: ["en", "fr"],
    default_locale: "en".
    gettext: MyApp.Gettext
    providers: [Cldr.Routes]

end
```

Here the `MyApp.Cldr` backend module is used to instrospect the configured locales in order to drive the localization generation.

Next, configure the router module to use the `localize/1` macro by adding `use MyApp.Cldr.Routes` to the module and invoke the `localize/1` macro to wrap the required routes. For example:

```elixir
defmodule MyApp.Router do
  use Phoenix.Router
  use MyApp.Cldr.Routes

  localize do
    get "/pages/:page", PageController, :show
    resources "/users", UsersController
  end
end
```

The following routes are generated (assuming that translations are updated in the `Gettext` configuration). For this example, the `:fr` translations are the same as the `:en` text with `_fr` appended. 

```bash 
% mix phx.routes MyApp.Router
 page_path  GET     /pages/:page        PageController :show
 page_path  GET     /pages_fr/:page     PageController :show
users_path  GET     /users              UsersController :index
users_path  GET     /users/:id/edit     UsersController :edit
users_path  GET     /users/new          UsersController :new
users_path  GET     /users/:id          UsersController :show
users_path  POST    /users              UsersController :create
users_path  PATCH   /users/:id          UsersController :update
            PUT     /users/:id          UsersController :update
users_path  DELETE  /users/:id          UsersController :delete
users_path  GET     /users_fr           UsersController :index
users_path  GET     /users_fr/:id/edit  UsersController :edit
users_path  GET     /users_fr/new       UsersController :new
users_path  GET     /users_fr/:id       UsersController :show
users_path  POST    /users_fr           UsersController :create
users_path  PATCH   /users_fr/:id       UsersController :update
            PUT     /users_fr/:id       UsersController :update
users_path  DELETE  /users_fr/:id       UsersController :delete
```

## Translations

In order for routes to be localized, translations must be provided for each path segment in each locale. This translation is performed by `Gettext.dgettext/3` with the domain "routes". Therefore for each configured locale, a "routes.pot" file is required containing the path segment translations for that locale.

Using the example Cldr backend that has "en" and "fr" Gettext locales then the directory structure would look like the following (if the default Gettext configuration is used):

    priv/gettext
    ├── default.pot
    ├── en
    │   └── LC_MESSAGES
    │       ├── default.po
    │       ├── errors.po
    │       └── routes.po
    ├── errors.pot
    └── fr
        └── LC_MESSAGES
            ├── default.po
            ├── errors.po
            └── routes.po

**Note** that since the translations are performed with `Gettext.dgettext/3` at compile time, the message ids are not autoamtically populated and must be manually added to the "routes.pot" file for each locale. That is, the mix tasks `mix gettext.extract` and `mix gettext.merge` will not detect or extract the route segments.
  
  
## Path Helpers

In the same way that Phoenix generates a `MyApp.Router.Helpers` module, `ex_cldr_routes` also generates a `MyApp.Router.LocalizedHelpers` module that translates localized paths. Since this module is generated alongside the standard `Helpers` module, an application can decide to generate either canonical paths or localized paths.  Here are some examples, assuming the same `Cldr` and `Gettext` configuration as the previous examples:

```elixir
iex> MyApp.Router.LocalizedHelpers.page_path %Plug.Conn{}, :show, 1
"/pages/1"
iex> Gettext.put_locale MyAppWeb.Gettext, "fr"         
nil
iex> MyApp.Router.LocalizedHelpers.page_path %Plug.Conn{}, :show, 1
"/pages_fr/1"

```

## Assigns

For each localized path, the Cldr locale is added to the `:assigns` for the route under the `:cldr_locale` key. This allows the developer to recognise which locale was used to generate the localized route.

## Installation

The package can be installed by adding `ex_cldr_routes` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_cldr_routes, "~> 0.1.0"}
  ]
end
```

The docs canbe found at <https://hexdocs.pm/ex_cldr_routes>.

