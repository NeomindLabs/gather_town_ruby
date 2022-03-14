# Gather.Town Ruby

## Quick Start
1. In your terminal, install the gem: 
```
rubygem install gather_town_ruby
```
2. Save your Gather API key as an environment variable called `GATHER_API_KEY`: 
```ruby
ENV['GATHER_API_KEY'] = 'pfSgVgjJnHufedlu' # change this to your actual API key (this is a random string which won't work!)
```
3. In your Ruby file or console: 
```ruby
require 'gather_town_ruby'
```
4. Initiate an instance of `GatherTown` with your space's web URL and map ID:
```ruby
my_space = GatherTown.new("https://app.gather.town/app/WNuZeOaoycxQQvUX/My%20Office", map_id: 'office-cozy') # change this to the URL you use to visit your Gather Town space in your browser. 
```
5. Retrieve the contents of your space with the `get_map()` method:
```
my_space_map_contents = my_space.get_map
```

## About The Gather API
Gather has some [basic API documentation here](https://www.notion.so/Gather-HTTP-API-3bbf6c59325f40aca7ef5ce14c677444#d3d3dd3d72c544a79fcafa4c68e85534), but it's a bit light. Here's how I got started:

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

