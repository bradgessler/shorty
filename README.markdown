# Shorty

A modular URL shorting application implemented in Sinatra, Rack 
and DataMapper. 

## Installation

Shorty requires the following gems:

> sudo gem install sinatra
> sudo gem install rack
> sudo gem install dm-core
> sudo gem install dm-more

## Getting Started

Once you have your gems squared away, you'll need to migrate the
database. Just run:

> rake db:migrate

from the root of the shorty repository. Now you're ready to start
Shorty!

> rackup config.ru

Point your browser to

> http://localhost:9292/

and you should see the URL shortening page.

## Advanced Configuration

Shorty is configurable via Rack. The default stack uses Rack::Cascade
to deliver a Shorty server with a user interface and a root redirect:

> run Rack::Cascade.new([
>   Shorty::RootRedirect.new,
>   Shorty::UI,
>   Shorty::Core
> ])

Shorty could be run headless and point to your own website with the
following configuration:

> run Rack::Cascade.new([
>   Shorty::RootRedirect.new('http://www.polleverywhere.com/'),
>   Shorty::Core
> ])

Since Shorty takes full advantage of rack, it is possible to drop
other pieces of middleware into the application stack, like caching
and/or authentication.

## API

Shorty has a minimal API that is usable even via curl. If you just 
want a shortened URL and don't care about the resulting URL key, 
simply POST the long url to shorty:

> curl -X POST -d 'http://www.yahoo.com/', 'localhost:9292'
> Created http://localhost:9292/MrVojA

To name a short URL key, you PUT the url to the shortened URL that
you would like:

> curl -X PUT -d 'http://www.yahoo.com/', 'localhost:9292/yahoo'
> Created http://localhost:9292/yahoo

If that URL is taken, you'll get a 409 conflict as well as the following
message:

> curl -X PUT -d 'http://www.amazon.com/', 'localhost:9292/yahoo'
> http://localhost:9292/yahoo has been taken

Copyright (c) 2009 Bradley Gessler

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.