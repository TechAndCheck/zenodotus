# Zenodotus (Ζηνόδοτος)
Zenodotus is an archive system for media that has been fact checked to provide durable, long-term storage for research purposes primarily. The project is named after [Zenodotus](https://en.wikipedia.org/wiki/Zenodotus), the first superintendent of the Library of Alexandria and the man credited with inventing the first tagging system.

## Setup

### Neo4J

We use Neo4J for graph database stuff. You'll have to set it up locally for dev and testing.

#### Mac
1. Install Neo4J (I use the desktop download)
1. Install SeaBolt using HomeBrew `brew install michael-simons/homebrew-seabolt/seabolt`
1. Link SeaBolt `brew link seabolt`
1. Run `bundle install` to get the gems properly in there if you haven't already
