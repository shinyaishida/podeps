#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cocoapods'
require "#{File.expand_path(__dir__)}/deps"

# Tool to dump license and copyright information of Pods managed by CocoaPods
class Podeps < Deps
  def initialize
    super('Podfile', 'Podfile.lock')
  end

  private

  def pkgs_to_trace
    unsymbolize_targets
    config = Pod::Config.instance
    packages = config.with_changes(silent: true) do
      Pod::Installer.targets_from_sandbox(
        config.sandbox,
        config.podfile,
        config.lockfile
      ).select { |target| @targets.include?(target.label) }.flat_map(&:pod_targets).uniq
    end
    packages.map { |package| hash(package) }
  end

  def unsymbolize_targets
    # Target label has prefix 'Pods-' preceding the target name defined in Podfile.
    @targets = @targets.map { |target| "Pods-#{target}" }
  end

  def hash(spec)
    {
      Name: spec.name,
      Version: spec.version,
      License: spec.root_spec.license[:type],
      URL: spec.root_spec.homepage,
      VendorUrl: spec.root_spec.homepage,
      VendorName: spec.root_spec.authors.keys[0]
    }
  end
end

deps = Podeps.new
deps.run(ARGV)
