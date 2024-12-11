require "csv" # CSVファイルを扱うためのライブラリを読み込んでいます

puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する"

memo_type = gets.to_i # ユーザーの入力値を取得し、数字へ変換しています

# if文を使用して続きを作成していきましょう。
# 「memo_type」の値（1 or 2）によって処理を分岐させていきましょう。

def list_csv_files
  Dir.glob("*.csv")
end

def prompt_for_csv_data
  data = []
  loop do
    puts "--------------------------------------------------------------------------\n"
    puts "データを入力してください（カンマ区切り形式）。\n終了するには 'exit' と入力してください。\n"
    puts "--------------------------------------------------------------------------\n"
    input = gets.chomp
    break if input.downcase == "exit"
    data << input.split(",")
  end
  data
end

def create_csv(file_path, data, mode: :new)
  CSV.open(file_path, "w") do |csv|
    data.each { |row| csv << row }
  end

  if mode == :new
    puts "\n#{file_path} を新規作成しました。"
  elsif mode == :overwrite
    puts "\n#{file_path} を正常に上書きしました。"
  end
rescue => e
  puts "CSV作成中にエラーが発生しました: #{e.message}"
end

def prompt_and_create_csv(file_name)
  file_name_with_extension = file_name + ".csv"
  data = prompt_for_csv_data
  create_csv(file_name_with_extension, data, mode: :new)
end

def prompt_and_overwrite_csv(file_path)
  data = prompt_for_csv_data
  create_csv(file_path, data, mode: :overwrite)
rescue => e
  puts "上書き中にエラーが発生しました: #{e.message}"
end

def select_csv_for_editing
  files = list_csv_files
  if files.empty?
    puts "このディレクトリ内にCSVファイルは存在しません。"
    return
  end

  puts "以下のCSVファイルから選択してください:"
  files.each_with_index { |file, index| puts "#{index + 1}: #{file}" }

  selected_index = gets.chomp.to_i
  if selected_index.between?(1, files.size)
    files[selected_index - 1]
  else
    puts "無効な選択です。"
    nil
  end
end

if memo_type == 1
  puts "ファイル名を入力してください（拡張子は不要です）:"
  create_file_name = gets.chomp
  prompt_and_create_csv(create_file_name)
elsif memo_type == 2
  selected_file = select_csv_for_editing
  prompt_and_overwrite_csv(selected_file) if selected_file
else
  puts "1 または 2 を入力してください。"
end