App.ShowPostView = Ember.View.extend({
  templateName: 'show',
  classNames:   ['show-post'],
  tagName:      'tr',

  doubleClick: function(){
    this.showEdit();
  },

  showEdit: function(){
    this.set('isEditing', true);
  },

  hideEdit: function(){
    this.set('isEditing', false);
  },

  destroyRecord: function(){
    var post = this.get('post');
    post.destroyResource()
      .fail( function(e){
        App.displayError(e);
      })
      .done( function(){
        App.postsController.removeObject(post);
      });
  }
});
