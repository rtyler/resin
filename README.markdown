# Resin: a simple environment for Amber development


## About

Resin is a simple [Sinatra](http://sinatrarb.com) application which allows for
a rapid-bootstrap of an [Amber](http://amber-lang.net) project.

The gem bundles a version of Amber and provides the necessary routes to
transparently serve up Amber assets *or* user-defined assets in their current
project directory

## Getting Started

Read further, or you could just [watch this fanciful screencast](http://youtu.be/9NHCGJxQKlA)

First you'll need to install the Gem and make your project directory:

    % mkdir my-project
    % cd my-project
    % gem install resin

Once the gem is installed, make some directories to store your own custom Amber
code:

    % mkdir st js


These directories will allow you to commit your code from the Amber IDE, so
once they're created, just run Resin and navigate to
[localhost:4567](http://localhost:4567)

    % runresin


## Custom Views

Adding custom views is pretty easy, just create the `views` directory and start
adding [HAML](http://haml-lang.com) files into it. If for example if you wanted
to create a URL [localhost:4567/user](http://localhost:4567/user) then you
would create `views/user.haml` and fill in your template accordingly.

To embed the Amber JavaScripts in your custom views, you can just call the
`embed_amber` function:

    %html
        %head
            %title
                My Custom View
            = embed_amber
        %body
            Hello World
