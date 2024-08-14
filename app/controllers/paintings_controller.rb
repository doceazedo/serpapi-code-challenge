require "nokogiri"

class PaintingsController < ApplicationController
  def index
    html = File.read("files/van-gogh-paintings.html")
    doc = Nokogiri::HTML5(html)
    artworks = []

    images_script = doc.css("script").select { |script| script.text.include? "data:image/" }
    images = get_base64_images(images_script[0].text)

    doc.css(".klitem").each_with_index do |item, idx|
      data = {
        "name" => item.css(".kltat")[0].content,
        "extensions" => item.css(".klmeta").map { |meta| meta.content },
        "link" => "https://www.google.com" + item["href"],
        "image" => images[idx]
      }
      artworks << data
    end

    # render html: html.html_safe
    render json: { artworks: artworks }
  end
end

def get_base64_images(string)
  images = []
  start_marker = "data:image/"
  end_marker = "';var ii="

  while string.include? start_marker
    image_start_idx = string.index(start_marker)
    image_end_idx = string.index(end_marker) || image_start_idx + start_marker.length() + 1

    image_data = string[image_start_idx..image_end_idx - 1].gsub("\\x3d", "=")
    images << image_data

    string[image_start_idx..image_end_idx + end_marker.length() - 1] = ""
  end

  images
end
