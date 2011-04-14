# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #generate table with diskusage
  #To refactor this
  def diskusage
    html = "<table>"
    IO.popen("df -h") do |df_io|
      html += "<tr>"
      df_io.gets.split(" ").each do |word|
        html += "<th>#{word}</th>"
      end
      html += "</tr>"
      while !df_io.eof?
        line = df_io.gets
        if line.index(/^\/dev\/disk*/) != nil
          html += "<tr>"
          line.split(" ").each do |word|
            html += "<td>#{word}</td>"
          end
          html += "</tr>"
        end
      end
    end
    html +="</table>"
  end
end
