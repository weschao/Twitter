### Twitter

This is a basic twitter app to read and compose tweets using the [Twitter API](https://apps.twitter.com/).

Time spent: 5h. 9:20

### Features

#### Required

 - [x] User can sign in using OAuth login flow
 - [x] User can view last 20 tweets from their home timeline
 - [x] The current signed in user will be persisted across restarts
 - [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. 
 - [x] User can pull to refresh
 - [x] User can compose a new tweet by tapping on a compose button.
 - [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

#### Optional

 - [x] When composing, you should have a countdown in the upper right for the tweet limit.
 - [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 - [ ] Retweeting and favoriting should increment the retweet and favorite count.
 - [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
 - [ ] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
 - [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
 - [ ] Tapping on a profile icon displays the user's profile
 - [ ] Display an indicator if the tweet is retweeted

undo retweet only works if we pull to refresh the main view

### Walkthrough
![Video Walkthrough](http://i.imgur.com/4pDzo12.gif)

Credits
---------
* [Twitter API](https://apps.twitter.com/)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)