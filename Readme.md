# Btjunkie

Unofficial API for [Btjunkie](http://btjunkie.org/)

## How to use

Fetch torrents from the [video section](http://btjunkie.org/browse/Video?o=72&t=0).

### Most recent

```` ruby
Btjunkie.category(:movies)
````

### Specify a page

```` ruby
Btjunkie.page(12).movies
````

Default is `1`.

### Cookies

Btjunkie requires that you pass some cookies to fetch there data.
You can easily do that by specifying the `sessid`.

```` ruby
Btjunkie.cookies({
  sessid: "1212lksdjfkj3lkeda090w83922af6b"
})
````

## Data to work with

As soon as the `torrents` method is applied to the query a request to *Btjunkie* is made.
The `torrents` method returns a list of `Torrent` object with the following methods.

- **title**      (*String*) The title.
- **details**    (*String*) The url to the details page.
- **torrent**    (*String*) The url. This should be a direct link to the torrent.
- **tid**        (*String*) The `tid` method, also known as `torrent id` is a *truly* unique identifier for all torrents. It is generated using a [MD5](http://sv.wikipedia.org/wiki/MD5) with the torrent domain and the `id` method as a seed.
- **torrent_id** (*String*) The same as the `tid` method.
- **imdb**       (*String*) The imdb link for the torrent, if the details view contains one. 
- **imdb_id**    (*String*) The imdb id for the torrent, if the details view contain one. Example: tt0066026.
- **tracker**    (*String*) The given tracker.
- **open?**      (*Boolean*) Is the given tracker open?
- **dead?**      (*Boolean*) Check to see if the torrent has no seeders. If it has no seeders, then `dead?` will be true.
- **id**         (*Fixnum*) An unique id for the torrent. The id is only unique for this specific torrent, not all torrents.
- **seeders**    (*Fixnum*) The amount of seeders.
- **subtitle**   (*[Undertexter](https://github.com/oleander/Undertexter)*) The subtitle for the torrent. Takes one argument, the language for the subtitle. Default is `:english`. Read more about it [here](https://github.com/oleander/Undertexter).
- **movie**      (*[MovieSearcher](https://github.com/oleander/MovieSearcher)*) Read more about the returned object at the [MovieSearcher](https://github.com/oleander/MovieSearcher) project page.

```` ruby
torrents = Btjunkie.movies.torrents
puts torrents.class       # => Array
puts torrents.first.class # => BtjunkieContainer::Torrent
````

## How do install

    [sudo] gem install btjunkie

## Requirements

*Btjunkie* is tested in *OS X 10.6.7* using Ruby *1.8.7*, *1.9.2*.

## License

*Btjunkie* is released under the *MIT license*.