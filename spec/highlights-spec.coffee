path = require 'path'
Highlights = require '../src/highlights'

describe "Highlights", ->
  describe "when an includePath is specified", ->
    it "includes the grammar when the path is a file", ->
      highlights = new Highlights(includePath: path.join(__dirname, 'fixtures', 'includes'))
      html = highlights.highlightSync(fileContents: 'test', scopeName: 'include1')
      expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="include1"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'

    it "includes the grammars when the path is a directory", ->
      highlights = new Highlights(includePath: path.join(__dirname, 'fixtures', 'includes', 'include1.cson'))
      html = highlights.highlightSync(fileContents: 'test', scopeName: 'include1')
      expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="include1"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'

    it "overrides built-in grammars", ->
      highlights = new Highlights(includePath: path.join(__dirname, 'fixtures', 'includes'))
      html = highlights.highlightSync(fileContents: 's = "test"', scopeName: 'source.coffee')
      expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>s&nbsp;=&nbsp;&quot;test&quot;</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'

  describe "highlightSync", ->
    it "returns an HTML string", ->
      highlights = new Highlights()
      html = highlights.highlightSync(fileContents: 'test')
      expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="text plain null-grammar"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'

    it "uses the given scope name as the grammar to tokenize with", ->
      highlights = new Highlights()
      html = highlights.highlightSync(fileContents: 'test', scopeName: 'source.coffee')
      expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'

    it "uses the best grammar match when no scope name is specified", ->
      highlights = new Highlights()
      html = highlights.highlightSync(fileContents: 'test', filePath: 'test.coffee')
      expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'

  describe "requireGrammarsSync", ->
    it "loads the grammars from a file-based npm module path", ->
      highlights = new Highlights()
      highlights.requireGrammarsSync(modulePath: require.resolve('language-erlang/package.json'))
      expect(highlights.registry.grammarForScopeName('source.erlang').path).toBe path.resolve(__dirname, '..', 'node_modules', 'language-erlang', 'grammars', 'erlang.cson')

    it "loads the grammars from a folder-based npm module path", ->
      highlights = new Highlights()
      highlights.requireGrammarsSync(modulePath: path.resolve(__dirname, '..', 'node_modules', 'language-erlang'))
      expect(highlights.registry.grammarForScopeName('source.erlang').path).toBe path.resolve(__dirname, '..', 'node_modules', 'language-erlang', 'grammars', 'erlang.cson')

    it "loads defaolt grammars prior to loading grammar from module", ->
      highlights = new Highlights()
      highlights.requireGrammarsSync(modulePath: require.resolve('language-erlang/package.json'))
      html = highlights.highlightSync(fileContents: 'test', scopeName: 'source.coffee')
      expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'

  #
  # async tests
  #

  describe "async: when an includePath is specified", ->
    it "includes the grammar when the path is a file", (done) ->
      highlights = new Highlights(includePath: path.join(__dirname, 'fixtures', 'includes'))
      highlights.highlight(fileContents: 'test', scopeName: 'include1', (err, html) ->
        expect(!err).toBe true
        expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="include1"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'
        done()
      )

    it "includes the grammars when the path is a directory", (done) ->
      highlights = new Highlights(includePath: path.join(__dirname, 'fixtures', 'includes', 'include1.cson'))
      highlights.highlight fileContents: 'test', scopeName: 'include1', (err, html) ->
        expect(!err).toBe true
        expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="include1"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'
        done()

    it "overrides built-in grammars", (done) ->
      highlights = new Highlights(includePath: path.join(__dirname, 'fixtures', 'includes'))
      highlights.highlight(fileContents: 's = "test"', scopeName: 'source.coffee',(err, html) ->
        expect(!err).toBe true
        expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>s&nbsp;=&nbsp;&quot;test&quot;</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'
        done()
      )

  describe "async: highlight", ->
    it "calls back an HTML string", (done) ->
      highlights = new Highlights()
      highlights.highlight fileContents: 'test', (err, html) ->
        expect(!err).toBe true
        expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="text plain null-grammar"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'
        done()

    it "uses the given scope name as the grammar to tokenize with", (done) ->
      highlights = new Highlights()
      highlights.highlight fileContents: 'test', scopeName: 'source.coffee', (err, html) ->
        expect(!err).toBe true
        expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'
        done()

    it "uses the best grammar match when no scope name is specified", (done) ->
      highlights = new Highlights()
      highlights.highlight fileContents: 'test', filePath: 'test.coffee', (err, html) ->
        expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'
        done()

  describe "async: requireGrammars", ->
    it "loads the grammars async from a file-based npm module path", (done) ->
      highlights = new Highlights()
      highlights.requireGrammars modulePath: require.resolve('language-erlang/package.json'),(err) ->
        expect(!err).toBe true
        expect(highlights.registry.grammarForScopeName('source.erlang')?.path).toBe path.resolve(__dirname, '..', 'node_modules', 'language-erlang', 'grammars', 'erlang.cson')
        done()

    it "loads the grammars from a folder-based npm module path", (done) ->
      highlights = new Highlights()
      highlights.requireGrammars modulePath: path.resolve(__dirname, '..', 'node_modules', 'language-erlang'),(err) ->
        expect(!err).toBe true
        expect(highlights.registry.grammarForScopeName('source.erlang')?.path).toBe path.resolve(__dirname, '..', 'node_modules', 'language-erlang', 'grammars', 'erlang.cson')
        done()

    it "loads defaolt grammars prior to loading grammar from module", (done) ->
      highlights = new Highlights()
      highlights.requireGrammars modulePath: require.resolve('language-erlang/package.json'), (err, html) ->
        highlights.highlight fileContents: 'test', scopeName: 'source.coffee', (err,html) ->
          expect(!err).toBe true
          expect(html).toBe '<div class="code">\n\t<ol>\n\t\t<li class="line" id="L1"><span class="source coffee"><span>test</span></span></li>\n\t</ol>\n</div>\n<div class="line-numbers">\n\t<ol>\n\t\t<li><a href="#L1"></a></li>\n\t</ol>\n</div>'
          done()
