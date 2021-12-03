# frozen_string_literal: true

require 'optparse'
require 'json'

# Base class to make tools to dump license and copyright of packages managed
# by package managers written in Ruby
class Deps
  def self.formats
    %i[json csv]
  end

  def initialize(pkgfile, lockfile)
    @default_pkgfile = pkgfile
    @default_lockfile = lockfile
    @pkgfile = nil
    @lockfile = nil
    @targets = []
    @format = :json
  end

  def run(argv)
    parse_options(argv)
    if Deps.formats.include?(@format)
      list_deps
    else
      puts "error: unknown format '#{@format}'"
    end
  end

  private

  def parse_options(argv)
    option_parser.parse!(argv)
    @pkgfile = argv[0] || @default_pkgfile
    @lockfile = argv[1] || @default_lockfile
  end

  def option_parser
    OptionParser.new do |opt|
      opt.banner = "usage: #{File.basename(__FILE__)} [options] [<#{@default_pkgfile}> [<#{@default_lockfile}]]"
      opt.on('-eENVIRONMENT', '--env ENVIRONMENT', 'add an environment') do |env|
        @targets << env.to_sym
      end
      opt.on('-fFORMAT', '--format FORMAT', "output format (#{Deps.formats.join(', ')})") do |fmt|
        if Deps.formats.include?(fmt.to_sym)
          @format = fmt.to_sym
        else
          puts "error: unknown format '#{fmt}'"
          exit 1
        end
      end
      opt.on('-h', '--help', 'print help') do
        puts opt
        exit
      end
    end
  end

  def list_deps
    case @format
    when :json
      list_in_json(pkgs_to_trace)
    when :csv
      list_in_csv(pkgs_to_trace)
    end
  end

  def list_in_json(pkgs)
    puts pkgs.to_json
  end

  def list_in_csv(pkgs)
    puts 'Name,Version,License,URL,VendorUrl,VendorName'
    pkgs.each do |pkg|
      puts pkg.values.join(',')
    end
  end
end
