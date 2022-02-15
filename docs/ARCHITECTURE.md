# Models
## Archive and Media Models

Zenodotus is designed to store data on media posts. At the heart of its architecture are two models,`ArchiveItem` and `ArchiveEntity`, that act as "containers" for child models that store different segements of data

Specifically, `ArchiveItem`s are containers for models that store data on media posts (e.g. Tweets or Instagram Posts), and `ArchiveEntities` are containers for models that store data on media post authors (e.g. Tweeters or Facebook users). 

To explain a couple concepts, I'll describe how the model architecture works for `ArchiveItems`, but `ArchiveEntities` work almost identically. 

Because `ArchiveItems` act as containers for different types of posts (e.g. Tweets and Instagram posts), the child post model they hold has a delegated, rather than static, type. This child model, `ArchivableItem`, can vary type between `Sources::Tweet`, `Sources::FacebookPost`, `Sources::InstagramPost`, and so on.  (For more on delegated types in Rails, [see here](https://edgeapi.rubyonrails.org/classes/ActiveRecord/DelegatedType.html)). 

Because of the delegated types, an `ArchiveItem`'s post data is accessed like `archive_item.tweet`, as opposed to `archive_item.archivable_item`. 

Further downstream, the model architecture is traditional. Posts belong to `author`s of varying types (`Sources::TwitterUser`, `Sources::Instagramuser`, and so on) and may have `images` and `videos` attached (accessed like, e.g., `Sources::Tweet.images`).


## Search models

Zenodotus allows its users to search its archive using image or text inputs. Search logic is contained in the `run` functions of the [Image Search](https://github.com/TechAndCheck/zenodotus/blob/master/app/models/image_search.rb) and [Text Search](https://github.com/TechAndCheck/zenodotus/blob/master/app/models/text_search.rb) models. Creating models for searching lets us move logic out of controllers and gives us the added benefit of being able to store search history by instantiating and saving search objects (each search belongs to a `User`). 

## User and organization models

Zenodotus' `User` model handles authentication for the app via [Devise](https://github.com/heartcombo/devise). Users belong to an `Organization` and may be designated as an organization's `admin`, allowing them to delete the profiles of other users in the organization.

## MediaReview

# Media archiving flow

Media posts can be archived in Zenodotus via web UI or via API. If posts are archived via web UI, Zenodotus immediately has access to the post's URL and proceeds to scrape it (see below). 

### Accepting inputs via API

Zenodotus accepts API calls to archive media from enclosed MediaReview payloads (See [IngestController](https://github.com/techandcheck/hypatia)). Zenodotus also accepts API calls containing URLs for webages that have MediaReview embedded within them. When these are submitted, Zenodotus scrapes the webpage in question, retrieves MediaReview items, and then continues through the archiving flow. 

### Scraping media sources

After acquiring a URL to a media post, Zenodotus checks whether the post's source (Twitter, Instagram, etc.) is covered by one of its scrapers and, if it is, sends a request to a [scraping server](https://github.com/techandcheck/hypatia) to scrape the post. 

### Storing media post data

Once Zenodotus has retrieved data on a post, it creates an `ArchiveItem` (see above) and corresponding downstream model instances. Once this is complete, the media post has been fully archived. 
