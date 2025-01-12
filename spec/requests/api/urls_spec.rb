require 'rails_helper'

RSpec.describe 'Urls API', type: :request do
  let!(:url) { Url.create(original_url: 'https://example.com') }

  it 'creates a shortened URL' do
    post '/api/urls', params: { url: { original_url: 'https://test.com' } }
    expect(response).to have_http_status(:created)
  end

  it 'lists all URLs' do
    get '/api/urls'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to eq(1)
  end

  it 'redirects to original URL' do
    get "/#{url.short_url}"
    expect(response).to have_http_status(:redirect)
  end
end
