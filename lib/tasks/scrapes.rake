namespace :scrapes do
  desc "Scrape all anime genres"
  task genres: :environment do
    html = Nokogiri::HTML(open('https://myanimelist.net/info.php?go=genre'))
    html.css('li').each do |genre|
      name = genre.css("strong").text
      genre.replace(genre.css("strong"))
      description = genre.text
      description[0..2] = ""
      Genre.create(name: name, description: description)
    end
  end

  desc "Scrape all anime types"
  task types: :environment do
    html = Nokogiri::HTML(open('https://myanimelist.net/info.php?go=type'))
    html.css('li').each do |type|
      name = type.css("strong").text
      type.replace(type.css("strong"))
      description = type.text
      description[0..2] = ""
      Type.create(name: name, description: description)
    end
  end

  desc "Scrape anime info and characters"
  task animes: :environment do
    [
    'https://myanimelist.net/anime/16498/Shingeki_no_Kyojin',
    'https://myanimelist.net/anime/558/Major_S2',
    'https://myanimelist.net/anime/11771/Kuroko_no_Basket',
    'https://myanimelist.net/anime/11757/Sword_Art_Online',
    'https://myanimelist.net/anime/5114/Fullmetal_Alchemist__Brotherhood',
    'https://myanimelist.net/anime/30276/One_Punch_Man',
    'https://myanimelist.net/anime/20/Naruto',
    'https://myanimelist.net/anime/31964/Boku_no_Hero_Academia',
    'https://myanimelist.net/anime/1575/Code_Geass__Hangyaku_no_Lelouch',
    'https://myanimelist.net/anime/20507/Noragami',
    'https://myanimelist.net/anime/1735/Naruto__Shippuuden',
    'https://myanimelist.net/anime/11061/Hunter_x_Hunter_2011',
    'https://myanimelist.net/anime/6702/Fairy_Tail',
    'https://myanimelist.net/anime/22199/Akame_ga_Kill',
    'https://myanimelist.net/anime/269/Bleach',
    'https://myanimelist.net/anime/25777/Shingeki_no_Kyojin_Season_2',
    'https://myanimelist.net/anime/18679/Kill_la_Kill',
    'https://myanimelist.net/anime/23755/Nanatsu_no_Taizai',
    'https://myanimelist.net/anime/3588/Soul_Eater',
    'https://myanimelist.net/anime/21/One_Piece',
    'https://myanimelist.net/anime/1/Cowboy_Bebop',
    'https://myanimelist.net/anime/8074/Highschool_of_the_Dead',
    'https://myanimelist.net/anime/24833/Ansatsu_Kyoushitsu',
    'https://myanimelist.net/anime/36456/Boku_no_Hero_Academia_3rd_Season',
    'https://myanimelist.net/anime/28121/Dungeon_ni_Deai_wo_Motomeru_no_wa_Machigatteiru_Darou_ka',
    'https://myanimelist.net/anime/29803/Overlord',
    'https://myanimelist.net/anime/813/Dragon_Ball_Z',
    'https://myanimelist.net/anime/38000/Kimetsu_no_Yaiba',
    'https://myanimelist.net/anime/35760/Shingeki_no_Kyojin_Season_3',
    'https://myanimelist.net/anime/34134/One_Punch_Man_2nd_Season',
    'https://myanimelist.net/anime/15451/High_School_DxD_New'
    ].each do |anime_link|

    html = Nokogiri::HTML(open(anime_link),nil,"UTF-8")

    title = html.css(".spaceit_pad")
    if title[0].css(".dark_text").text == "English:"
       title[0].replace(title[0].css(".dark_text"))
       english = sanitize(title[0].text)
    elsif title[0].css(".dark_text").text == "Synonyms:"
      title[0].replace(title[0].css(".dark_text"))
      synonyms = sanitize(title[0].text)
    elsif title[0].css(".dark_text").text == "Japanese:"
      title[0].replace(title[0].css(".dark_text"))
      japanese = sanitize(title[0].text)
    end

   if title[1].css(".dark_text").text == "Synonyms:"
      title[1].replace(title[1].css(".dark_text"))
      synonyms = sanitize(title[1].text)
      if title[2].css(".dark_text").text == "Japanese:"
         title[2].replace(title[2].css(".dark_text"))
         japanese = sanitize(title[2].text)
      end
   elsif title[1].css(".dark_text").text == "Japanese:"
     title[1].replace(title[1].css(".dark_text"))
      japanese = sanitize(title[1].text)
      synonyms = ""
   end

    sumarry= html.css('span[itemprop="description"]').text

    episodes = html.css(".spaceit").find do |element|
      element.css("span").text == "Episodes:"
    end
    episodes.replace(episodes.css(".dark_text"))
    episodes = sanitize(episodes.text)

    current_type = Type.all.find do |type|
      type.name == html.css(".information.type").text
    end

    aired = html.css(".spaceit").find do |element|
      element.css("span").text == "Aired:"
    end
    aired.replace(aired.css(".dark_text"))
    aired = sanitize(aired.text)

     anime = Anime.create(
      english: english, 
      synonyms: synonyms, 
      japanese: japanese, 
      sumarry: sumarry,
      episodes: episodes,
      type_id: current_type.id,
      aired: aired
    )
     anime_id = anime.id

     genres = html.css('span[itemprop="genre"]').each do |genre|
       genre = Genre.find_by(name: genre.text)
       AnimeGenre.create(anime_id: anime_id, genre_id: genre.id)
     end

     characters = html.css('.detail-characters-list')[0].css('table').css('.borderClass').each do |character|
       if !character.attr('align')
         if !character.attr('width')
           char_name = character.css('a').text
           char_role = character.css('small').text
           role = Role.find_by(name: char_role)
           Character.create(name: char_name,anime_id: anime_id,role_id: role.id)
          end
       end
      end
    end
  end

  def sanitize(html)
    html[0..5] = ""
    html[-1] = ""
    html[-1] = ""
    html[-1] = ""
    html
  end
end
