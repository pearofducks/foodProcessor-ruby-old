# foodProcessor

a static recipe-website creator

## installation

There are two methods to install:

1. Docker
  - Clone the docker branch: `git clone https://github.com/pearofducks/foodprocessor.git -b docker`
  - In the foodprocessor directory, run `./docker_build.sh` to build the image
  - then run `./docker_start.sh INPUT_DIR OUTPUT_DIR` to start the container, both directories will be created if they don't exist
    - INPUT_DIR should be where your `*.recipe` files are located, as well as your `layouts` folder
    - OUTPUT_DIR will be where the HTML site is rendered to
2. Traditional
  - Clone the repo: `git clone https://github.com/pearofducks/foodprocessor.git`
  - Get the gems: `bundle`
  - Copy the binary somewhere in your PATH: `cp foodProcessor /usr/local/bin` - *edit the path at the top of this file if copying somewhere else*
  - Run: `foodProcessor INPUT_DIR OUTPUT_DIR`
  - I recommend setting this up as a post-recieve hook, and having your recipes as a git repo

## the recipe repo

```
- /recipes
  |
  |__ *.recipe
  |
  |__ /layouts
     |
     |__ layout.haml
     |__ index.haml
     |__ recipe.haml
```

## recipe files

The recipe file itself is based on YAML, and is intended to make transcription of recipes as quick as possible.

An example recipe template is included and commented in the repo.

## HTML templates

foodProcessor will look for three files when writing the site:

- `RECIPE_DIR/layouts/layout.haml`
  - contains the general HTML layout to be used in both *index* and *recipe*
  - must contain `=yield` for rendering the other templates inside the layout
- `RECIPE_DIR/layouts/index.haml`
  - used to render the main listing of all recipes
  - `recipes` is available here, which is an array of `recipe` objects
    - *fixme: referencing the file-path of the recipe is a bit ugly*
- `RECIPE_DIR/layouts/recipe.haml`
  - used to render each individual recipe page
  - the `recipe` object is available for use here, with two attributes available
    - `recipe.name`: the name string provided in the recipe file
    - `recipe.html`: the recipe file, pre-rendered into HTML

### example templates

#### layout.haml

```
!!!
%html
  %head
    %meta(charset="utf-8")
    - recipe ||= ""
    - if recipe.empty?
      %title= "awesome recipes"
    - else
      %title= "awesome recipes: #{recipe.name}"
  %body
    .container
      =yield
```

#### index.haml

```
%h1 awesome recipes
%ul
  -recipes.each do |recipe|
    %li
      %a{href: "recipes/#{recipe.name}.html"}= recipe.name
```

#### recipe.haml

```
%h2= recipe.name
= recipe.html
```
