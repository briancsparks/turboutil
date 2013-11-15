require "turboutil/version"

module Turboutil
  class Options
    def initialize
      @options = []
    end

    def option(*args)
      @curr = {}
      args.each do |arg|
        put(/^--(?<longname>[^=]+)$/.match(arg))
        put(/^-(?<shortname>[^\-]+)$/.match(arg))
        put(/^--(?<key>[^=]+)=(?<val>.+)$/.match(arg))
      end
      @options << @curr
      @curr = nil
    end

    def put(matcher)
      if matcher
        matcher.names.each do |key|
          @curr[key.to_sym] = matcher[key]
        end
      end
    end

    def show_usage
      @options.each do |option|
        message = [];
        option.keys.each do |key|

          message << "--#{option[key]}" if key == :longname
          message << "-#{option[key]}"  if key == :shortname

        end

        puts "\t" + message.join(" ")
      end
    end
  end

  class Params
    def initialize
      @args = ARGV.map { |x| x }
      @options = Turboutil::Options.new
    end

    def usage(options = nil, &blk)
      if block_given?
        blk.call @options
      end
    end

    def show_usage(msg = '', exit_code = nil)
      puts msg if msg != ''
      puts "Usage: "
      @options.show_usage
    end

    def [](key)
      parse
      @params[key.to_sym]
    end
    
    def on(key, &blk)
      if self[key]
        blk.call self[key]
      end
    end

    def method_missing(sym, *args, &blk)
      parse

      if @params.has_key?(sym)
        if block_given?
          blk.call @params[sym]
        end
        return @params[sym]
      end
      
      nil
    end

    def parse(manual_args = nil)
      return @params if @params
      run manual_args
    end

    def run(manual_args = nil)
      args = (manual_args.nil? ? @args : manual_args).map { |x| x }

      @params = {}
      loop {
        break if args.length == 0

        first   = style1 args[0]
        if first
          second = any_style args[1] if args.length > 1

          if !second && args.length > 1
            setm first, args[1]
            args.shift
          else
            setm first, true
          end

        else

          # -f- means unset
          first = style_false args[0]
          if first
            setm first, false
          else

            # --key=value
            first = style2 args[0]
            if first
              setm first, first[2]
            end
          end
        end

        args.shift
      }

      @params
    end

    def style1(str)
      str.match(/^--?([a-zA-Z0-9_][a-zA-Z0-9_\-]+[a-zA-Z0-9_])$/) || str.match(/^--?([a-zA-Z0-9_]+)$/)
    end

    def style2(str)
      str.match(/^--?([a-zA-Z0-9_\-]+)=(.+)$/)
    end

    def style_false(str)
      str.match(/^--?([a-zA-Z0-9_\-]+)-$/)
    end

    def any_style(str)
      style1(str) || style2(str)|| style_false(str) 
    end

    def set(key, value)
      @params[key.gsub(/-/, '_').to_sym] = value
    end

    def setm(key, value)
      set key[1], value
    end

    def setmm(key, value)
      set key[1], value[1]
    end
  end

end

#def test
#  o=Turboutil::Params.new
#  o.parse(['--a', '--b=c', '--d', 'e', '-f-', '-g'])
#  o
#end

$argv = Turboutil::Params.new


