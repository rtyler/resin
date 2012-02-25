# Resin: a simple environment for A,ber development


## About

Resin is a simple [Sinatra](http://sinatrarb.com) application which allows for
a rapid-bootstrap of an [Amber](http://amber-lang.net) project.

The gem bundles a version of Amber and provides the necessary routes to
transparently serve up Amber assets *or* user-defined assets in their current
project directory

## Getting Started


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


