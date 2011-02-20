$(function(){
  window.Rad = {};

  Rad.Resource = Backbone.Model.extend({
    initialize: function() {
      this.endpoints = new Rad.Endpoints( this.get('endpoints') );
      this.endpoints.url = 'resources/' + this.get('name') + '/endpoints';
    }
  });

  Rad.Resources = Backbone.Collection.extend({
    model: Rad.Resource,
    url: "resources"
  });

  Rad.Endpoint = Backbone.Model.extend({
    
  });

  Rad.Endpoints = Backbone.Collection.extend({
    model: Rad.Endpoint
  });

  Rad.ResourceView = Backbone.View.extend({
    tagName: "li",
    template: $("#mustache-resource").html(),

    initialize: function() {
      _.bindAll(this, "render", "addEndpoints", "addEndpoint");
    },

    render: function() {
      $(this.el).html( Mustache.to_html( this.template, this.model.toJSON() ) );
      this.addEndpoints();
      return this;
    },

    addEndpoints: function() {
      this.model.endpoints.each(this.addEndpoint);
    },

    addEndpoint: function(endpoint) {
      var view = new Rad.EndpointView({ model: endpoint });
      this.$(".endpoints").append(view.render().el);
    }
  });

  Rad.EndpointView = Backbone.View.extend({
    tagName: "li",
    template: $("#mustache-endpoint").html(),

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

  new Rad.AppView({ collection: new Rad.Resources });
});