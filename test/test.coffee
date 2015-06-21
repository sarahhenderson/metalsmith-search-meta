coffee      = require 'coffee-script/register'
mocha       = require 'mocha'
rimraf      = require 'rimraf'
should      = require('chai').should()
exists      = require('fs').existsSync
join        = require('path').join
each        = require('lodash').each
_           = require('lodash')

Metalsmith  = require 'metalsmith'
plugin      = require '..'

describe 'metalsmith-search-meta', () ->

   beforeEach (done) ->
      rimraf __dirname + '/build', done
   
   describe 'using default options', ()->
      
      it 'should generate JSON file', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin()
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               should.exist files['searchMeta.json']
               done()
   
      it 'should generate JSON file containing correct files', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin()
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               contents = JSON.parse(files['searchMeta.json'].contents)
               should.exist contents['page1.md']
               should.exist contents['page3.md']
               done()
               
      
      it 'should include the default metadata items', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin()
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               contents = JSON.parse(files['searchMeta.json'].contents)
               post = contents['page1.md']
               should.exist(post)
               post.title.should.equal 'test title'
               post.author.should.equal 'test-author'
               post.image.should.equal 'test.jpg'
               post.wordCount.should.equal 42
               post.readingTime.should.equal 2
               done()
   
      it 'should omit metadata items that do not exist in the source file', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin()
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               contents = JSON.parse(files['searchMeta.json'].contents)
               post = contents['page3.md']
               should.exist(post)
               post.title.should.equal 'page3'
               should.not.exist post.author
               should.not.exist post.image
               done()
   
   
   describe 'using explicit options', ()->
      
      it 'should generate JSON file with specified name', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin
               path: 'search/meta.json'
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               should.exist files['search/meta.json']
               done()
   
      it 'should include only the specified metadata items', (done)->
         
         Metalsmith(__dirname)
            .source('fixtures/src')
            .use plugin
               properties: ['title', 'slug', 'image']
            .build (err, files) ->
               should.not.exist(err)
               should.exist(files)
               contents = JSON.parse(files['searchMeta.json'].contents)
               post = contents['page1.md']
               should.exist(post)
               post.title.should.equal 'test title'
               post.slug.should.equal 'test-slug'
               post.image.should.equal 'test.jpg'
               should.not.exist post.author
               should.not.exist post.wordCount
               should.not.exist post.readingTime
               done()
   
   
   afterEach (done) ->
      rimraf __dirname + '/build', done
   
   