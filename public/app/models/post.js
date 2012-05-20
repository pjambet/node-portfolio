App.Post = Ember.Resource.extend({
  resourceUrl: '/posts',
  resourceName: 'post',
  resourceProperties: ['title', 'content'],

  validate: function(){
    if (this.get('title') === undefined || this.get('title') === '' ||
        this.get('content') === undefined  || this.get('content') === '') {
      return 'Posts require a title and a content.';
    }
  },

  fullName: Ember.computed(function() {
    return ' ' + this.get('title');
  }).property('title')

});
