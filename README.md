# TinySync Ruby Library

TinySync is a set of libraries used to develop cross-platform synchronized database systems.
Each library uses a set of conventions to establish a common synchronization method that works on various client and server platforms.


## Installation

Add this line to your application's Gemfile:

    gem 'tinysync'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tinysync

## Usage

This library is used to set up a Ruby web application as a tinysync server.
There are several tools provided to assemble your system, but exactly how they're used depends on your system implementation.


### Configuration

TinySync can be configured by passing a block to *TinySync.configure*:

```ruby
    TinySync.configure do |config|
        config.dialect = :nobrainer # ORM used to define models [:nobrainer]
    end
```

All possible configuration options are shown with their default values being assigned and possible values in the comments.

If your server is a Rails application, this configuration should be placed in an initializer.


### Models

If you're using an ORM, each model class you'd like to be synced to clients must include the *TinySync::Syncable* module:

```ruby
    class Post
        include NoBrainer::Document
        include TinySync::Syncable
        ...
    end
```

*NOTE: Currently only NoBrainer is supported, but Mongoid support is planned. Please submit an issue if you'd like a different ORM*

The Syncable module adds several fields to your model:

* sync_state (string): Used by TinySync to determine if a record is new or deleted.

You also must have a *last_updated* field on each model you'd like to sync.
This is included by default in NoBrainer and can be included with the *Mongoid::Timestamps* module in Mongoid.


### Schema Generation

TinySync uses a standard JSON representation of database schema communicate the structure of your data between platforms.
The *TinySync.schema* function parses your models and returns a hash representing the schema.

```ruby
    TinySync.schema.to_json
    => {
         "created_at": "2014-01-06T10:56:31-06:00",
         "tables": [
           {
             "name": "authors",
             "fields": [ ... ]
             ]
           },
           ...
         ]
    }
```


## Sync Requests and Responses

The basic mechanism of synchronizing data between the client and server in TinySync can be summarized as:

1. The client sends a *sync request* to the server containing


## Code Generation



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
