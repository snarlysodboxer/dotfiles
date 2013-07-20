#!/usr/bin/env ruby
require 'fileutils'

working_dir = File.expand_path(File.dirname(__FILE__))
home_dir = File.expand_path("~")
dot_files = Dir.glob(File.join("#{working_dir}/linked_files","*"))

dot_files.each do |filename|
  sym_link = File.join(home_dir,".#{File.basename(filename)}")

  FileUtils.rm sym_link if File.symlink?(sym_link) || File.exist?(sym_link)
  FileUtils.ln_s filename,sym_link
  puts "#{filename} -> #{sym_link}"
end

if File.directory? "#{home_dir}/.config/htop"
  config_file = "#{home_dir}/.config/htop/htoprc"
  FileUtils.rm(config_file) if File.exist?(config_file) || File.symlink?(config_file)
  FileUtils.ln_s "#{home_dir}/.dotfiles/linked_files/htoprc",config_file
  puts "#{home_dir}/.dotfiles/linked_files/htoprc -> #{config_file}"
end
