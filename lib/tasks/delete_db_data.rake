namespace :delete_db_data do
  desc '同じクォーターの中で同じ日に同じメンバーと行ったランチ履歴を削除する'
  task delete_duplicate_lunch: :environment do
    puts '同じクォーターの中で同じ日に同じメンバーと行ったランチ履歴を削除します'
    quarters = Quarter.includes(lunches: [:lunches_members, :members])
      .order("quarters.start_date", "lunches.date", "lunches.created_at", "members.created_at")
    quarters.each do |quarter|
      finish_iterate_lunches = []
      quarter.lunches.each do |lunch|
        finish_iterate_lunches.each do |finish_iterate_lunch|
          next unless (finish_iterate_lunch.date == lunch.date) && (finish_iterate_lunch.members == lunch.members)

          puts <<~TEXT
            #{finish_iterate_lunch.inspect} #{finish_iterate_lunch.members.map(&:real_name).join(',')}のランチと
            #{lunch.inspect} #{lunch.members.map(&:real_name).join(',')}のランチが重複してます。
            #{lunch.inspect} #{lunch.members.map(&:real_name).join(',')}のランチを削除します
          TEXT

          lunch.delete
          puts '削除しました'
          break
        end
        finish_iterate_lunches << lunch if lunch.persisted?
      end
    end
  end
end
