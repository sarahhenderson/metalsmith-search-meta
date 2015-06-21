metalsmith-search-meta
======================

A [Metalsmith](http://metalsmith.io) plugin that generates file metadata to use in conjuction with [metalsmith-lunr](https://github.com/CMClay/metalsmith-lunr) and [lunr.js](http://lunrjs.com/).

The [metalsmith-lunr](https://github.com/CMClay/metalsmith-lunr) plugin generates a search index JSON file.  The [lunr](http://lunrjs.com/) search engine uses this to perform a search and returns the keys that match.   I wanted to display some post metadata in the search results view, and so I created this plugin to generate a metadata file using the same keys to use in my search results page.

Usage
-----

The plugin indexes the same set of files as the metalsmith-lunr plugin: files with `lunr: true` set in the metadata.

You need to specify the path where the metadata file will be created, and the file properties you want included.

```javascript
var searchMeta = require('metalsmith-searchmeta');
Metalsmith.use(searchMeta(
   {
      path: 'searchMeta.json',
      properties: ['title', 'date', 'author']   
   }));
```

This will generate a JSON file with metadata for every file included in the lunr search.  The structure will be similar to the metalsmith file structure, with the file containing a single JSON object, with the urls being the keys, and the metadata being the values.
For instance, the file might look like this:

```json
{
   "page1/index.html":
      {
         "title":"Page 1",
         "date":"2015-04-01T00:00:00.000Z",
         "author":"Builder"
      },
   "page2/index.html":
      {
         "title":"Page 2",
         "date":"2015-04-09T00:00:00.000Z",
         "author":"Builder"
      }
}
```

On your search page, you can take the results returned by lunr, retrieve the file metadata and then display it using your client-side templating engine of choice.

Defaults
--------

You can use the plugin without supplying any options.  If no options are supplied, the following defaults will be used:

```javascript
   var defaults = { 
      path: 'searchMeta.json',
      properties: ['title', 'date', 'author', 'tags', 'image', 'wordCount', 'readingTime', 'path']
   };
```

If these properties do not exist on your files, they will just be ignored.

Tests
-----
   
`$ npm test`
   
Licence
-------

GPLv2
