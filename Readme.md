# Btjunkie

Unofficial API for [Btjunkie](http://btjunkie.org/)

## How to use

Fetch torrents from the [video section](http://btjunkie.org/browse/Video?o=72&t=0).

### Most recent

```` ruby
Btjunkie.movies
````

### Most recent using step

`Btjunkie.step` makes it possible to step through all pages.

```` ruby
Btjunkie.step.movies
````

If you for example want to fetch all torrents on all pages, then something like this might be useful.

```` ruby
bt = Btjunkie.step

while bt.movies.any?
  bt.movies # Do something with the data
end
````

### Cookies

Btjunkie requires that you pass some cookies to fetch there data.
You can easily do that by specifying the `sessid`.

```` ruby
Btjunkie.cookies({
  sessid: "1212lksdjfkj3lkeda090w83922af6b"
})
````

## How do install

    [sudo] gem install btjunkie

## Requirements

*Btjunkie* is tested in *OS X 10.6.7* using Ruby *1.8.7*, *1.9.2*.

## License

*Btjunkie* is released under the *MIT license*.