App.Post = Ember.Resource.extend({
  resourceUrl: '/posts',

  fullName: Ember.computed(function() {
    return ' ' + this.get('title');
  }).property('title')
});
