desc "Importa palestras do arquivo CSV"
task import_csv: :environment do
  require 'csv'

  # Especifique o caminho para o seu arquivo CSV
  csv_file = 'palestras.csv'

  # Abra e leia o arquivo CSV
  CSV.foreach(csv_file, headers: true) do |row|
    # Crie um novo registro de palestra no banco de dados
    Lecture.create(
      title: row['Tema da Palestra'],
      duration: row['Duração']
    )
  end

  puts "Importação concluída!"
end
