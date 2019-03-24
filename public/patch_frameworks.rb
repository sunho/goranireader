#!/usr/bin/env ruby

require 'xcodeproj'
require 'yaml'
require 'set'

class IgnoreEntry
  attr_reader :dependency
  @targets

  def initialize(object)
    if object.instance_of? String then
      @dependency = object
      @targets = Set.new
    elsif object.is_a? Hash then
      dependency, targets = object.first

      @dependency = dependency
      @targets = Set.new(targets.flat_map(&:values).flatten)
    else
      @dependency = nil
      @targets = nil
      raise "Unexpected ignoreMap format"
    end
  end

  def should_ignore?
    @targets.empty?
  end

  def should_ignore_target?(target)
    return @targets.empty? || @targets.member?(target)
  end
end

def find_resolved_deps
  raw_deps = File.read(File.join(Dir.pwd, "Cartfile.resolved")).split("\n")
  regexp = %r{"(?<repo>[\w\d@\:\-\_\.\/]+)"?}

  raw_deps.map { |x|
    match = regexp.match(x)
    repo = match[:repo] unless match.nil?

    if not repo.nil? then
      repo = %x[read -a array <<< '#{repo}'; basename ${array[0]} | awk -F '.' '{print $1}']
      repo.chop
    end
  }.compact
end

def xcproject_from_workspace_at_path(dependency, directory)
  workspace_path = File.join(directory, "#{dependency}.xcworkspace")
  return unless File.exists?(workspace_path)

  workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)
  project_ref = workspace.file_references.detect { |ref|
    ref if File.basename(ref.path, File.extname(ref.path)) == dependency
  }

  return nil if project_ref.nil?

  project_path = project_ref.absolute_path(directory)
  Xcodeproj::Project.open(project_path)
end

def xcodeproj_for_dependency(dependency, directory = "#{Dir.pwd}/Carthage/Checkouts/#{dependency}")
  project_path = Dir.chdir(directory) { |pwd|
    candidates = ["#{dependency}.xcodeproj"] + Dir.glob("*.xcodeproj")

    candidates.map { |name|
      File.join(pwd, name)
    }.detect { |path|
      File.exists?(path)
    }
  }

  return xcproject_from_workspace_at_path(dependency, directory) if project_path.nil?

  Xcodeproj::Project.open(project_path)
end

def patch_match_o_type(dependency, ignore_entry)
  if !ignore_entry.nil? && ignore_entry.should_ignore? then
    puts "Skipping dependency <#{dependency}>. Ignored by Patchfile"
    return
  end

  project = xcodeproj_for_dependency(dependency)

  project.native_targets.each do |target|
    if target.product_type != 'com.apple.product-type.framework' || target.resources_build_phase.files.count > 0 then
      next
    end

    target.build_configurations.each do |config|
      if not ignore_entry.nil? and ignore_entry.should_ignore_target?(target.name) then
        puts "Skipping target <#{target.name}, #{config.name}>. Ignored by Patchfile"
        next
      end

      match_o_type = config.build_settings['MACH_O_TYPE']

      if match_o_type.nil? || match_o_type == 'mh_dylib' then
        puts "Patching target <#{target.name} #{config.name}>"

        config.build_settings['MACH_O_TYPE'] = 'staticlib'
        project.save
      else
        puts "Skipping target <#{target.name} #{config.name}>. Already has MACH_O_TYPE set to <#{match_o_type}>"
      end

      config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
      project.save
    end
  end
end

def prepare_ignore_hash
  config_path = File.join(Dir.pwd, "Patchfile")
  config = File.file?(config_path) ? YAML.load_file(config_path) : {}
  raw_ignore_map = config.fetch("ignoreMap", {})
  ignore_map = {}

  if raw_ignore_map.count > 0 then
    ignore_map = raw_ignore_map.map { |x|
      entry = IgnoreEntry.new(x)
      [entry.dependency, entry]
    }.to_h
  end

  ignore_map
end

ignore_hash = prepare_ignore_hash
resolved_deps = find_resolved_deps

resolved_deps.each { |dependency|
  puts "Processing dependency <#{dependency}>"
  patch_match_o_type(dependency, ignore_hash[dependency])
  puts "\n"
}