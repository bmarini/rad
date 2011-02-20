$(function(){
  window.Rad = {};

  Rad.Resource = Backbone.Model.extend({
    
  });

  Rad.ResourceList = Backbone.Collection.extend({
    model: Rad.Resource,
    url: "resources"
  });

  Rad.Resources = new Rad.ResourceList;

  Rad.ResourceView = Backbone.View.extend({
    tagName: "li",
    template: $("#mustache-resource").html(),

    initialize: function() {
      _.bindAll(this, "render");
    },

    render: function() {
      $(this.el).html( Mustache.to_html( this.template, this.model.toJSON() ) );
      return this;
    }
  });

  Rad.AppView = Backbone.View.extend({
    el: $("#documentation"),

    initialize: function() {
      _.bindAll(this, "addAll", "addOne");
      this.collection.bind("refresh", this.addAll);
      this.collection.fetch();
    },

    addAll: function() {
      this.collection.each(this.addOne);
    },

    addOne: function(resource) {
      var view = new Rad.ResourceView({ model: resource });
      $(this.el).append(view.render().el);
    }
  });

  new Rad.AppView({ collection: Rad.Resources });
});