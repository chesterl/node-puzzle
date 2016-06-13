through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 0

  transform = (chunk, encoding, cb) ->
    lines = chunk.split(/\r\n|\r|\n(?!$)/).length
    ###
     Filter method add on deals with the edge case (line 76) with a new line at the end of the sentence
     This approach might cause issues with further edge testing as it removes all falseiy values
    ###
    tokens = chunk.split(/\s(?=.*".*")|(?:[a-z])(?=[A-Z])|\s+(?!.*")/).filter(Boolean)
    words = tokens.length
    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
