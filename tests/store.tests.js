describe("Space.flux - Store", function () {

  StoreTest = Space.namespace('StoreTest');

  Space.flux.defineEvents('StoreTest', {
    PostIdChanged: { id: String },
    CategoryFilterChanged: { category: String },
    UserCommentChanged: { value: String }
  });

  StoreTest.BlogPostsStore = Space.flux.Store.extend({
    /**
     * Reactive vars should be used for values that can be inferred by
     * state like the current route or computed data. These won't "survive"
     * hot-code pushes but will be rebuilt on every reload.
     */
    reactiveVars: function() {
      return [{
        // These things can be inferred e.g: by looking at the current route
        postId: null,
        categoryFilter: 'all'
      }];
    },
    /**
     * Session vars should be used for values that cannot be inferred by
     * routes or loaded data and should survive hot-code pushes.
     */
    sessionVars: function() {
      return [{
        // Imagine a comment textarea where the user writes something.
        // This should survive hot-code pushes and save the value!
        userCommentValue: ''
      }];
    },

    events: function() {
      return [{
        'StoreTest.PostIdChanged': this.updatePostId,
        'StoreTest.CategoryFilterChanged': this.updateCategoryFilter,
        'StoreTest.UserCommentChanged': this.updateUserComment,
      }];
    },

    updatePostId: function(event) {
      this._setReactiveVar('postId', event.id);
    },

    updateCategoryFilter: function(event) {
      this._setReactiveVar('categoryFilter', event.category);
    },

    updateUserComment: function(event) {
      this._setSessionVar('userCommentValue', event.value);
    },
  });

  it("assigns default values", function () {
    StoreTest.BlogPostsStore
    .given() // defaults
    .expectState({
      postId: null,
      categoryFilter: 'all',
      userCommentValue: ''
    });
  });

  it("changes state when handling events", function () {
    StoreTest.BlogPostsStore
    .given()
    .when([
      new StoreTest.PostIdChanged({ id: 'postId123' }),
      new StoreTest.CategoryFilterChanged({ category: 'changedCategory' }),
      new StoreTest.UserCommentChanged({ value: 'new comment' })
    ])
    .expectState({
      postId: 'postId123',
      categoryFilter: 'changedCategory',
      userCommentValue: 'new comment'
    });
  });

});
