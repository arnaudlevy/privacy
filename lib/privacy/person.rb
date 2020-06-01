class Privacy::Person
  attr_reader :identifier, :row, :index, :columns, :data, :combinations, :initials

  COLUMNS_TO_ANONYMIZE = [
    'Nom _identifier_',
    'Prénom _identifier_',
    'Date de naissance _identifier_',
    'Lieu naissance Pays _identifier_',
    'Lieu naissance Ville _identifier_',
    'Lieu naissance Département _identifier_',
    'Sexe _identifier_',
    'Nationalité _identifier_',
    'Adresse _identifier_ [Date]',
    'Adresse _identifier_ [Département]',
    'Adresse _identifier_ [Ville]',
    'Adresse _identifier_ [Pays]',
    'Profession _identifier_',
    'Date profession _identifier_'
  ]

  INITIALS_SEPARATORS = [
    '',
    '.'
  ]

  def initialize(identifier)
    @identifier = identifier
    puts "Identify #{identifier}"
  end

  def identify_columns(row)
    @columns = {}
    row.each do |key, value|
      COLUMNS_TO_ANONYMIZE.each do |column|
        name = column_with_identifier column
        if value == name
          letter = key.gsub '1', ''
          @columns[letter] = name
          puts "  #{name} on column #{letter}"
        end
      end
    end
  end

  def anonymize(row, index)
    @row = row
    @index = index + 1 # Excel is 1-indexed
    anonymize_personal_data
    build_combinations
    remove_combinations
  end

  protected

  def anonymize_personal_data
    @data = {}
    puts
    puts "Anonymize row #{index}"
    puts "  #{identifier}"
    @columns.each do |letter, column|
      cell = "#{letter}#{index}"
      value = row[cell]
      next if value.nil?
      @data[column] = value
      puts "      #{value} (#{column})"
      row[cell] = "[#{column}]"
    end
  end

  def build_combinations
    puts 'build_combinations'
    @combinations = []
    first_name_column = column_with_identifier 'Prénom _identifier_'
    last_name_column = column_with_identifier 'Nom _identifier_'
    first_name = data[first_name_column]
    last_name = data[last_name_column]
    if !first_name.nil? && !last_name.nil?
      initials = []
      first_name.split(' ').each { |l| initials << l[0].upcase }
      last_name.split(' ').each { |l| initials << l[0].upcase }
      @combinations << "#{first_name} #{last_name}"
      @combinations << " #{first_name} #{last_name}"
      @combinations << "#{first_name} #{last_name} "
      @combinations << "#{last_name} #{first_name}"
      @combinations << " #{last_name} #{first_name}"
      @combinations << "#{last_name} #{first_name} "
      @combinations += initials_combinations(initials)
    end
    puts "Combinations: #{@combinations.join(', ')}"
  end

  def column_with_identifier(column)
    column.gsub '_identifier_', identifier
  end

  def initials_combinations(initials)
    puts "Initials for #{initials}"
    combinations = []
    initials.each do |letter|
      initials.shift
      recursive_combinations = initials_combinations initials
      INITIALS_SEPARATORS.each do |separator|
        initial_with_separator = "#{letter}#{separator}"
        if recursive_combinations.none?
          combinations << "#{initial_with_separator}"
          combinations << "#{initial_with_separator} "
          combinations << " #{initial_with_separator}"
        else
          recursive_combinations.each do |c|
            combinations << "#{initial_with_separator}#{c}"
            combinations << " #{initial_with_separator}#{c}"
            combinations << "#{initial_with_separator} #{c}"
            combinations << "#{initial_with_separator} #{c} "
            combinations << "#{initial_with_separator}#{c} "
          end
        end
      end
    end
    combinations.uniq
  end

  def remove_combinations
    row.each do |key, value|
      anonymized_value = value
      if value.is_a? String
        combinations.each do |token|
          anonymized_value = anonymized_value.gsub(token, "[#{identifier}]")
        end
      end
      row[key] = anonymized_value
    end
  end
end
