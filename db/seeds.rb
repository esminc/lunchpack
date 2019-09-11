require "csv"
require 'yaml'

User.create!(email: 'sample@esm.co.jp', password: 'password')

CSV.foreach('db/seed/member.csv', headers: true) do |row|
  Member.create!(
    hundle_name: row['GitHub'],
    real_name: row['氏名 (本名)'].tr(' ', ''),
    email: row['会社メールアドレス'],
  )
end

YAML.load_file('db/seed/project.yml').each do |project_name|
  Project.create!(name: project_name)
end

CSV.foreach('db/seed/lunch-40-1Q.csv') do |row|
  date = Date.parse(row[0])
  names = row[1].split('、')
  quarter = Quarter.find_or_create_quarter(date)
  quarter.lunches.create!(
    date: date,
    members: Member.where(real_name: names),
    created_by: User.find_by(email: 'sample@esm.co.jp')
  )
end
