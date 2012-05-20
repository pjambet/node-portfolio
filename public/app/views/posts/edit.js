App.EditPostView = Ember.View.extend({
  tagName:      'form',
  templateName: 'edit',

  init: function() {
    this._super();
    // Create a new post that's a duplicate of the post in the parentView;
    // Changes made to the duplicate won't be applied to the original unless
    // everything goes well in submitForm()
    this.set("post", this.get('parentView').get('post').copy());
  },

  didInsertElement: function() {
    this._super();
    this.$('input:first').focus();
  },

  cancelForm: function() {
    this.get("parentView").hideEdit();
  },

  submit: function(event) {
    var self = this;
    var post = this.get("post");

    event.preventDefault();

    post.saveResource()
      .fail( function(e) {
        App.displayError(e);
      })
      .done( function() {
        var parentView = self.get("parentView");
        parentView.get("post").duplicateProperties(post);
        parentView.hideEdit();
      });
  }
});
