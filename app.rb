require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/artist')
require('./lib/song')
require('pry')
also_reload('lib/**/*.rb')
require('pg')

DB = PG.connect({:dbname => 'record_store'})

get('/test') do
  @something = "this is a variable"
  erb(:whatever)
end

get('/') do
  @albums = Album.all
  @artists = Artist.all
  erb(:index)
end

get ('/albums') do
  if params["search"]
    @albums = Album.search(params[:search])
  elsif params["sort"]
    @albums = Album.sort()
  else
    @albums = Album.all
  end
  erb(:albums)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/new') do
  erb(:new_album)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  values = *params.values
  @album.update(params)
  @albums = Album.all
  erb(:albums)
end

post('/albums') do
  album = Album.new(params)
  album.save()
  @albums = Album.all() # Adding this line will fix the error.
  erb(:albums)
end

get ('/artists') do
  if params["search"]
    @artists = Artist.search(params[:search])
  elsif params["sort"]
    @artists = Artist.sort()
  else
    @artists = Artist.all
  end
  erb(:artists)
end

get('/artists/new') do
  erb(:new_artist)
end


get('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  erb(:artist)
end


post('/artists/:id') do
  @artist = Artist.find(params[:id].to_i)
  @artist.update({:album_name => params[:album_name]})
  erb(:artist)
end

post('/artists') do
  puts params
  artist = Artist.new({:name => params[:artist_name], :id => nil})
  artist.save()
  @artists = Artist.all() # Adding this line will fix the error.
  erb(:artists)
end


patch('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  values = *params.values
  @artist.update(params)
  @artists = Artist.all
  erb(:artists)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

delete('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.delete()
  @artists = Artist.all
  erb(:artists)
end
get('/custom_route') do
  "We can even create custom routes, but we should only do this when needed."
end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(:name => params[:song_name], :album_id => @album.id, :id => nil)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end
