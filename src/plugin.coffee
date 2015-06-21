_        = require 'lodash'

module.exports = (options) ->
   
   options ?= {}
   defaults = 
      path: 'searchMeta.json'
      properties: ['title', 'date', 'author', 'tags', 'image', 'wordCount', 'readingTime', 'path']

   _.defaults options, defaults

   getPostMetaDataFromFile = (file, options) ->
      # extract metadata about the post for display on tag pages
      post = {}
      for prop in options.properties
         post[prop] = file[prop]
         
      return post

      
   (files, metalsmith, next) ->
      
      json = {}
      
      # loop through each file to build its tags collection
      for filename of files
      
         # pull back the file data
         file = files[filename]
         
         # only pull metadata for searchable files
         continue unless file.lunr
         
         # get the post metadata
         post = getPostMetaDataFromFile(file, options)
         
         # key the post metadata with the filename
         json[filename] = post

      # create the file to be written my metalsmith
      file = 
         contents: new Buffer(JSON.stringify(json))
         mode: '0644'
         
                        
      # add the file to metadata for use in navigation
      files[options.path] = file
         
      next()
