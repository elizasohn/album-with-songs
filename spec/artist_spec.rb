describe('#update') do
  it("adds an album to an artist") do
    artist = Artist.new({:name => "John Coltrane", :id => nil})
    artist.save()
    album = Album.new({:name => "A Love Supreme", :id => nil})
    album.save()
    artist.update({:album_name => "A Love Supreme"})
    expect(artist.albums).to(eq([album]))
  end
end
