require "csv"
require 'yaml'

CSV.foreach('db/seed/member.csv', headers: true) do |row|
  Member.create!(
    hundle_name: row['GitHub'],
    real_name: row['氏名 (本名)'].tr(' ', ''),
  )
end

YAML.load_file('db/seed/project.yml').each do |project_name|
  Project.create!(name: project_name)
end
