require "nokogiri"

class PaintingsController < ApplicationController
  def index
    html = File.read("files/van-gogh-paintings.html")
    doc = Nokogiri::HTML5(html)
    artworks = []

    doc.css(".klitem").each_with_index do |item, idx|
      data = {
        "name" => item.css(".kltat")[0].content,
        "extensions" => item.css(".klmeta").map { |meta| meta.content },
        "link" => "https://www.google.com" + item["href"],
        "image" => item.css("img")[0].attr("src")
      }
      artworks << data
    end

    # render html: html.html_safe
    render json: { artworks: artworks }
  end
end
