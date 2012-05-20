App.ListPostsView = Ember.View.extend({
  templateName:    'list',
  postsBinding: 'App.postsController',

  refreshListing: function() {
    App.postsController.findAll();
  }
});
