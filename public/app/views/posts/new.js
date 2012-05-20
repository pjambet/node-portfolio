App.NewPostView = Ember.View.extend({
  tagName:      'form',
  templateName: 'app/templates/posts/edit',

  init: function() {
    this._super();
    this.set("post", App.Post.create());
  },

  didInsertElement: function() {
    this._super();
    this.$('input:first').focus();
  },

  cancelForm: function() {
    this.get("parentView").hideNew();
  },

  submit: function(event) {
    var self = this;
    var post = this.get("post");

    event.preventDefault();

    post.saveResource()
      .fail( function(e) {
        App.displayError(e);
      })
      .done(function() {
        App.postsController.pushObject(post);
        self.get("parentView").hideNew();
      });
  }
});
