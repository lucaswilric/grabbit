Grabbit
-----

Grabbit is a ... thing, which does ... stuff.

Basically, its job is to pick URLs out of RSS feeds. It subscribes to the RSS feeds you choose, and grabs the links, either the `enclosure` node of each item in the feed, or the `link` node. Then it exposes the URLs in a consistent format. Then clients can parse each item consistently, and use it for ... well, whatever you want. 

The `client` folder contains a few shots at some client code. They grab info from the web app in JSON format, then do things like download them, or add torrents to Transmission via Transmission's JSON API.

You can use it as a podcatcher (a web-manageable one!) or to download, say, the torrents of StackOverflow's monthly data dump.


Getting Started
-----

`rails server` will get you started, or you can load it up in a proper web server. You can try the client scripts ad hoc, or use cron. Beyond that... well, you're fairly intelligent.

