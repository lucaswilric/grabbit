Grabbit
-------

Grabbit is an RSS feed combiner. It takes feeds in, and spits feeds out.

Basically, its job is to pick URLs out of RSS feeds. It subscribes to the RSS feeds you choose, and grabs the links, either the `enclosure` node of each item in the feed, or the `link` node. Then it exposes the URLs in a consistent format. Then clients can parse each item consistently, and use it for ... well, whatever you want. 

You can use it as a podcatcher (a web-manageable one!) or to download, say, the torrents of StackOverflow's monthly data dump. It's also used to power the reading list at http://reading.lucasrichter.id.au and the link blog at http://links.lucasrichter.id.au


Getting started
---------------

`rails server` will get you started, or you can load it up in a proper web server. You'll also need a cronjob or something to run `rake fetch_feeds`. This will ping all your input feeds to get new stuff.

You can try the client scripts ad hoc, or use cron. Beyond that... well, you're fairly intelligent.

