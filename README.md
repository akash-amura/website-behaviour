## Website Behaviour for Sell.Do

### Instructions to set up

1) git clone https://github.com/akash-amura/website-behaviour.git
2) cd website-behaviour
2) bundle install
3) rackup config.ru

### Base URL

*http://localhost:9292*

### Routes set up

1) Get Tracker js
   *GET /public/javascripts/tracker.js*

2) Get Sample html page to check out the js
   *GET /public/html/index.html*

3) Send a event to store
   *POST /events*
   Parameters: {client_id, lead_id, event_name, timestamp, url, title}

4) Subscribe to a particular client's events
   *POST /subscribe* 
   Parameters: {client_id, url}
