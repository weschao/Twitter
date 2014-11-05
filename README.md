### Twitter

This is a basic twitter app to read and compose tweets using the [Twitter API](https://apps.twitter.com/).

Time spent: 11.5h week 1, 2.5h week 2 3:00


### Features

#### Required

* Week 1:
 - [x] User can sign in using OAuth login flow
 - [x] User can view last 20 tweets from their home timeline
 - [x] The current signed in user will be persisted across restarts
 - [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. 
 - [x] User can pull to refresh
 - [x] User can compose a new tweet by tapping on a compose button.
 - [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 - [ ] Provide controls for retweet/favorite/reply within the timeline.
* Week 2: Hamburger menu
 - [x] Dragging anywhere in the view should reveal the menu.
 - [x] The menu should include links to your profile, the home timeline, and the mentions view.
* Week 2: Profile page
 - [x] Contains the user header view
 - [ ] Contains a section with the users basic stats: # tweets, # following, # followers
Week 2: Home Timeline
 - [ ] Tapping on a user image should bring up that user's profile page

#### Optional

* Week 1
 - [x] When composing, you should have a countdown in the upper right for the tweet limit.
 - [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 - [x] Retweeting and favoriting should increment the retweet and favorite count.
 - [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
 - [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
 - [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
* Week 2: Profile page
 - [ ] Implement the paging view for the user description.
 - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
 - [ ] Pulling down the profile page should blur and resize the header image.
* Week 2: Account switching
 - [ ] Long press on tab bar to bring up Account view with animation
 - [ ] Tap account to switch to
 - [ ] Include a plus button to Add an Account
 - [ ] Swipe to delete an account

### Walkthrough
![Video Walkthrough](http://i.imgur.com/fdB7qE4.gif)

Credits
---------
* [Twitter API](https://apps.twitter.com/)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [DateTools](https://github.com/MatthewYork/DateTools)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)