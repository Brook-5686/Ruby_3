# frozen_string_literal: true
require 'fileutils'
class Benefits < ApplicationRecord

  def self.save(file, backup = false)
    data_path = Rails.root.join("public", "data")
    sanitized_filename = sanitize_filename(file.original_filename)
    full_file_name = "#{data_path}/#{sanitized_filename}"
    f = File.open(full_file_name, "wb+")
    f.write file.read
    f.close
    make_backup(sanitized_filename, data_path, full_file_name) if backup == "true"
  end

  def self.make_backup(filename, data_path, full_file_name)
    if File.exist?(full_file_name)
      backup_file_name = "#{data_path}/bak#{Time.zone.now.to_i}_#{filename}"
      silence_streams(STDERR) { FileUtils.cp(full_file_name, backup_file_name) }
    end
  end

  def self.silence_streams(*streams)
    on_hold = streams.collect { |stream| stream.dup }
    streams.each do |stream|
      stream.reopen(RUBY_PLATFORM =~ /mswin/ ? "NUL:" : "/dev/null")
      stream.sync = true
    end
    yield
  ensure
    streams.each_with_index do |stream, i|
      stream.reopen(on_hold[i])
    end
  end
  def self.sanitize_filename(filename)
    filename.gsub(/[^0-9A-Za-z.\-_]/, '_')
  end
end
