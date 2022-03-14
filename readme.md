# Gather Town Ruby
A Ruby library for interfacing with [Gather Town](https://www.gather.town/) via their [API](https://support.gather.town/help/gather-api).

## Quick Start
1. In your terminal, install the gem: 
```
rubygem install gather_town_ruby
```
2. Save your Gather API key as an environment variable called `GATHER_API_KEY`: 
```ruby
ENV['GATHER_API_KEY'] = 'pfSgVgjJnHufedlu' # change this to your actual API key
```
3. In your Ruby file or console: 
```ruby
require 'gather_town_ruby'
```
4. Initiate an instance of `GatherTown` with your space's web URL and map ID:
```ruby
connection = GatherTown::Connection.new("https://app.gather.town/app/WNuZeOaoycxQQvUX/My%20Office", map_id: 'office-cozy')
```
5. If the above succeeds, you can now run either `connection.get_map` or `connection.set_map(updated_map)`, both of which are detailed below.


### Get the Map (`get_map`)
Create a new connection, if you haven't already:
```ruby
connection = GatherTown::Connection.new("https://app.gather.town/app/WNuZeOaoycxQQvUX/My%20Office", map_id: 'office-cozy', test_connection: false)
# `test_connection: false` will be faster, but without it, an exception will be raised if the connection isn't working.
```

Retrieve the contents of your space with the `get_map` method:
```
map = connection.get_map
```

This should return a `GatherTown::Map` object with your map's data.


### Set the Map (`set_map(updated_map)`)
Create a new connection, and retrieve your map (same as above). 

Next, search your map for a `text_objects` and change its message:
```ruby
map.text_objects(with_message: "Foo").first["properties"]["message"] = "Bar"
```

Finally, update your map:
```ruby
connection.set_map(map)
```

## About The Gather API
Gather has some [basic API documentation](https://support.gather.town/help/gather-api), but it's work in progress. Here's how I got started:

1. Log in to Gather
2. Generate and API key here: [https://gather.town/apiKeys](https://gather.town/apiKeys)
3. Find your Space ID. You can pull this from the URL in your browser once you're in your space. For example, 
```
https://app.gather.town/app/nMLXVlxJDwpMZPcu/Neomind Office
```
has a Space ID of `nMLXVlxJDwpMZPcu\Neomind%20Office`. Note that we **reversed the forward slash to a backslash**, and **URL encoded the later part** (in this case, the space became `%20`).

4. Find your Map ID. You can find a valid Map ID by opening the Mapmaker, and looking in the "Rooms" tab on the right. For example, `office-cozy`.

5. Now that you have an API Key, a Space ID and a Map ID, you can put them together and make your first request: a `GET` request for the contents of a room:
```
https://gather.town/api/getMap?spaceId=nMLXVlxJDwpMZPcu\Neomind%20Office&mapId=office-cozy&apiKey=jRpu4UeCpVmSmASj
```
This should return a JSON object with all of the room's data.

