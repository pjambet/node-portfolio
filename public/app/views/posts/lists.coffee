App.ListPostsView extends Ember.View
  templateName:     'app/templates/posts/list'
  postsBinding:  'App.postsController'

  refreshListing: ->
    App.postsController.findAll()
