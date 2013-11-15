# Turboutil

All good utilities follow a small set of well-known patterns for their
command-line parameters.  Now, your utility grocs these patterns, too.

## Installation

Because Turboutil is instantly usable, you will probably want to install it
globally:

    $ gem install turboutil

And in any project that becomes big enough for a Gemfile:

    gem 'turboutil'

And then execute:

    $ bundle

## Usage

All good utilities follow a small set of well-known patterns for their
command-line parameters.  Now, your utility grocs these patterns, too.

For example:

* -f means to turn on feature 'foo'
* -f- means to turn off feature 'foo'
* --foo means to turn on feature 'foo'
* Etc.

Turboutil was written to be useful during all phases of development of
your utility.  The minimum is just to include it.  By doing only that, 
you get the $argv global variable which can be queried for what the user
chose for the invocation's command line.

    yourutil -x --bar --baz quxx --jolly=good -y- --foo

    $argv.x       # => true
    $argv.y       # => false
    $argv.z       # => nil
    $argv.bar     # => true
    $argv.baz     # => 'quxx'
    $argv.jolly   # => 'good'
    $argv.foo     # => true

Later, when you need more sophistication, you can tell Turboutil more
about your utility.  In the above example, -f and --foo were two different
ways that the user could have turned on feature foo.

    $argv.usage do |config|
      config.option '-f', '--foo'
      config.option '--url'
      config.option '--save'
    end

Typically, your code will look like:

    if !$argv.f && !$argv.foo
      $argv.show_usage '' 3
    elsif !$argv.url
      $argv.show_usage "No URL" 3
    else
      foo = YourUtil::Foo.new($argv.f || $argv.foo)
      img = YourUtil::Image.new($argv.url)

      if $argv.save
        img.save(foo)
      else
        foo.show(img)
      end
    end
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
