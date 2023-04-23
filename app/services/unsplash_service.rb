class UnsplashService
  def random_image(name)
    get_url("https://api.unsplash.com/search/photos/?client_id=eG4gDkR-8gsubeHyHJEo2mw8uL_Y4_7ZoqXSD8yZZ1w")
  end

  def project_logo
    get_url('https://api.unsplash.com/photos/pFqrYbhIAXs/?client_id=eG4gDkR-8gsubeHyHJEo2mw8uL_Y4_7ZoqXSD8yZZ1w')
  end

  def get_url(url)
    response = HTTParty.get(url)
    parsed_image = JSON.parse(response.body, symbolize_names: true)
  end
end
