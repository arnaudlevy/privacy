require 'creek'
require 'write_xlsx'
require 'person'

class Privacy::Processor
  attr_reader :file

  DIRECTORY = 'processed'
  PRIVATE_DATA = {
    'Nom ppmec': '[Nom]',
    'Prénom ppmec': '[Prénom]',
    'Nom ppvic': '[Nom]',
    'Prénom ppvic': '[Prénom]'
  }

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
    @ppmec = Person.new 'ppmec'
    @ppmec.identify_columns sheet.rows.first
    @ppvic = Person.new 'ppvic'
    @ppvic.identify_columns sheet.rows.first

    sheet.rows.first.each do |key, value|
      worksheet.write key, value
    end
    sheet.rows.each_with_index do |row, index|
      next if index.zero?
      identify_private_values row, index
      row.each do |key, value|
        worksheet.write key, filter_value(key, value)
      end
    end
  end

  def identify_private_values(row, index)
    # TODO find all private data in the row, so we can generate custom filter values
    # first_name = 'Anne'
    # last_name = 'Dupont'
    # replacements = {
    #   'Anne Dupont' => '[Prénom] [Nom]',
    #   'Dupont Anne' => '[Nom] [Prénom]',
    #   'A. D.' => [Initiales],
    #   'A.D.' => [Initiales],
    #   'A. D' => [Initiales]
    #   'A.D' => [Initiales]
    #   'A D.' => [Initiales]
    #   'AD.' => [Initiales]
    #   'AD' => [Initiales]
    # }
  end

  def filter_value(key, value)
    # TODO replace specific keys
    # TODO replace some
    value
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
