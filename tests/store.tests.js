describe("Space.flux - Store", function() {

  StoreTestModule = Space.Module.define('StoreTestModule', {
    requiredModules: ['Space.flux'],
    singletons: ['StoreTestModule.BlogPostsStore']
  });

  Space.flux.defineEvents('StoreTestModule', {
    PostIdChanged: { id: String },
    CategoryFilterChanged: { category: String },
    UserCommentChanged: { value: String }
  });

  Space.flux.Store.extend('StoreTestModule.BlogPostsStore', {
    /**
     * Reactive vars should be used for values that can be inferred by
     * state like the current route or computed data. These won't "survive"
     * hot-code pushes but will be rebuilt on every reload.
     */
    reactiveVars() {
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
    sessionVars() {
      return [{
        // Imagine a comment textarea where the user writes something.
        // This should survive hot-code pushes and save the value!
        userCommentValue: ''
      }];
    },

    eventSubscriptions() {
      return [{
        'StoreTestModule.PostIdChanged': this.updatePostId,
        'StoreTestModule.CategoryFilterChanged': this.updateCategoryFilter,
        'StoreTestModule.UserCommentChanged': this.updateUserComment
      }];
    },

    updatePostId(event) {
      this._setReactiveVar('postId', event.id);
    },

    updateCategoryFilter(event) {
      this._setReactiveVar('categoryFilter', event.category);
    },

    updateUserComment(event) {
      this._setSessionVar('userCommentValue', event.value);
    }
  });

  it("assigns default values", function() {
    StoreTestModule.test(StoreTestModule.BlogPostsStore)
    .expect({
      postId: null,
      categoryFilter: 'all',
      userCommentValue: ''
    });
  });

  it("changes state when handling events", function() {
    StoreTestModule.test(StoreTestModule.BlogPostsStore)
    .when([
      new StoreTestModule.PostIdChanged({ id: 'postId123' }),
      new StoreTestModule.CategoryFilterChanged({ category: 'changedCategory' }),
      new StoreTestModule.UserCommentChanged({ value: 'new comment' })
    ])
    .expect({
      postId: 'postId123',
      categoryFilter: 'changedCategory',
      userCommentValue: 'new comment'
    });
  });

});
