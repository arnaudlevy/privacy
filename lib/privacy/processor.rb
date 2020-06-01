require 'creek'
require 'write_xlsx'
require 'privacy/person'

class Privacy::Processor
  attr_reader :file

  DIRECTORY = 'processed'

  def initialize(file)
    @file = file
    process unless @file.start_with? '~'
  end

  protected

  def process
    puts "Processing #{@file}"
    make_directory
    filter_data
    write_file
  end

  def make_directory
    Dir.mkdir DIRECTORY unless File.exists? DIRECTORY
  end

  def filter_data
    @ppmec = Privacy::Person.new 'ppmec'
    @ppmec.identify_columns sheet.rows.first
    @ppvic = Privacy::Person.new 'ppvic'
    @ppvic.identify_columns sheet.rows.first
    sheet.rows.first.each do |key, value|
      worksheet.write key, value
    end
    sheet.rows.each_with_index do |row, index|
      next if index.zero?
      @ppmec.anonymize row, index
      @ppvic.anonymize row, index
      row.each do |key, value|
        worksheet.write key, value
      end
    end
  end

  def write_file
    workbook.close
  end

  # New file
  # http://cxn03651.github.io/write_xlsx/index.html

  def workbook
    @workbook ||= WriteXLSX.new processed_file_name
  end

  def worksheet
    @worksheet ||= workbook.add_worksheet
  end

  def processed_file_name
    "#{DIRECTORY}/#{file}"
  end

  # Current file
  # https://github.com/pythonicrubyist/creek

  def path
    @path ||= File.expand_path file
  end

  def data
    @data ||= Creek::Book.new path, with_headers: true
  end

  def sheet
    @sheet ||= data.sheets[0]
  end
end
