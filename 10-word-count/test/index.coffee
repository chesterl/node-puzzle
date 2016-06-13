assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count words in a phrase with letters and numbers', (done) ->
    input = 'This sentence has w0rds and 2 numbers'
    expected = words: 7, lines: 1
    helper input, expected, done

  it 'should count camel case words in a phrase', (done) ->
    input = 'camelCase words should be included'
    expected = words: 6, lines: 1
    helper input, expected, done

  it 'should exclude first capital words', (done) ->
    input = 'This should split the CamelCase words'
    expected = words: 7, lines: 1
    helper input, expected, done

  # This edge case is debatable as one may see CapitalID as being split as Capital, I, D
  it 'should count consecutive capital letters in camel case as one word', (done) ->
    input = 'CapitalID is split into Capital and ID'
    expected = words: 8, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count any characters in quotes as a single word', (done) ->
    input = 'what on "%^&* (@u 9O" are you doing'
    expected = words: 6, lines: 1
    helper input, expected, done

  it 'should count words when multiple spaces are present', (done) ->
    input = 'these big  spaces    should not effect counting'
    expected = words: 7, lines: 1
    helper input, expected, done

  it 'should count words and lines with new lines', (done) ->
    input = 'this has \n three total lines \n in this sentence'
    expected = words: 8, lines: 3
    helper input, expected, done

  it 'should count words and lines with new line at end of sentence', (done) ->
    input = 'this has \n three total lines in this sentence \n'
    expected = words: 8, lines: 2
    helper input, expected, done

  it 'should count words and lines with quoted words, numeral characters and camel case', (done) ->
    input = 'this has \n multiple "@343 jsoj" lines and\ncharact3rs doesIt'
    expected = words: 9, lines: 3
    helper input, expected, done
