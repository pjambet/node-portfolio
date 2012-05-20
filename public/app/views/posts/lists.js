App.ListPostsView = Ember.View.extend({
  templateName:    'app/templates/posts/list',
  postsBinding: 'App.postsController',

  showNew: function(){
    this.set('isNewVisible', true)
  },

  hideNew: function(){
    this.set('isNewVisible', false)
  },

  refreshListing: function() {
    App.postsController.findAll();
  }
});
