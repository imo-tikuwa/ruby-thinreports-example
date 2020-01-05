require 'sinatra'
require 'sinatra/reloader'
require 'thinreports'
require 'date'

# index.htmlを表示
get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

# PDFをダウンロードするルーティング
get '/download_pdf' do

  test1 = Time.now.strftime("%Y年%m月%d日 %H時%M分%S秒")
  file_name = Time.now.strftime("%Y%m%d%H%M%S") + '.pdf'
  file_path = 'output/' + file_name

  # PDF生成
  Thinreports::Report.generate(:filename => file_path, :layout => 'input/example.tlf') do
    start_new_page
    page.item(:test1).value(test1)
  end

  # PDFダウンロード
  stat = File::stat(file_path)
  send_file(file_path, :filename => file_name, :length => stat.size, :type => 'application/octet-stream')
end