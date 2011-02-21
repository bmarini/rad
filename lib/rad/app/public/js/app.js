$(function(){
  window.Rad = {};

  Rad.Resource = Backbone.Model.extend({
    initialize: function() {
      this.endpoints = new Rad.Endpoints( this.get('endpoints') );
    }
  });

  Rad.Resources = Backbone.Collection.extend({
    model: Rad.Resource,
    url: "resources"
  });

  Rad.Endpoint = Backbone.Model.extend({
    initialize: function() {
      this.params = new Rad.Params( this.get('params') );
    }
  });

  Rad.Endpoints = Backbone.Collection.extend({
    model: Rad.Endpoint
  });

  Rad.Param = Backbone.Model.extend({
    initialize: function() {
      _.bindAll(this, "inputType");
    },

    inputType: function() {
      if ( this.get('allowable_values') ) {
        return "select";
      } else {
        return "text";
      }
    }
  });

  Rad.Params = Backbone.Collection.extend({
    model: Rad.Param
  });

  Rad.ResourceView = Backbone.View.extend({
    tagName: "li",
    className: "resource",
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
    className: "endpoint",
    template: $("#mustache-endpoint").html(),

    events: {
      "click .heading": "toggleParams",
      "submit form": "proxyRequest"
    },

    initialize: function() {
      _.bindAll(this, "render", "addParams", "addParam", "toggleParams", "proxyRequest");
    },

    render: function() {
      $(this.el).html( Mustache.to_html( this.template, this.model.toJSON() ) );
      this.addParams();
      return this;
    },

    addParams: function() {
      this.model.params.each(this.addParam);
    },

    addParam: function(param) {
      var view = new Rad.ParamView({ model: param });
      this.$(".params table").append(view.render().el);
    },

    toggleParams: function() {
      this.$(".params").slideToggle();
    },

    proxyRequest: function() {
      $.post('/proxy',
        this.$("form").serialize(),
        function(data) {}
      );

      return false;
    }
  });

  Rad.ParamView = Backbone.View.extend({
    tagName: "tr",
    className: "param",
    template: $("#mustache-param").html(),

    initialize: function() {
      _.bindAll(this, "render", "addField");
    },

    render: function() {
      $(this.el).html( Mustache.to_html( this.template, this.model.toJSON() ) );
      this.addField();
      return this;
    },

    addField: function() {
      var template = $("#mustache-param-" + this.model.inputType() ).html();
      var html = Mustache.to_html( template, this.model.toJSON() );
      this.$(".field").html(html);
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