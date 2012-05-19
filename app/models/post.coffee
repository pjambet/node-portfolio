Spine = require('spine')

class Post extends Spine.Model
  @configure 'Post', 'title', 'author'

module.exports = Post
