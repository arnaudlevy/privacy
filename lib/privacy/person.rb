class Privacy::Person
  attr_reader :identifier

  COLUMNS_TO_ANONYMIZE = [
    'Nom _identifier_',
    'Prénom _identifier_',
    'Date de naissance _identifier_'
  ]

  def initialize(identifier)
    @identifier = identifier
    puts "Person #{identifier}"
  end

  def identify_columns(row)
    puts "Identify columns"
    @columns = {}
    row.each do |key, value|
      COLUMNS_TO_ANONYMIZE.each do |column|
        name = column.gsub '_identifier_', identifier
        if key == name
          letter = key.gsub '1', ''
          @columns[letter] = name
          puts "#{name} on column #{letter}"
        end
      end
    end
  end
end
