/*!
 * jQuery Once v2.1.1 - http://github.com/robloach/jquery-once
 * @license MIT, GPL-2.0
 *   http://opensource.org/licenses/MIT
 *   http://opensource.org/licenses/GPL-2.0
 */
(function(e){"use strict";if(typeof exports==="object"){e(require("jquery"))}else if(typeof define==="function"&&define.amd){define(["jquery"],e)}else{e(jQuery)}})(function(e){"use strict";var n=function(e){e=e||"once";if(typeof e!=="string"){throw new Error("The jQuery Once id parameter must be a string")}return e};e.fn.once=function(t){var r="jquery-once-"+n(t);return this.filter(function(){return e(this).data(r)!==true}).data(r,true)};e.fn.removeOnce=function(e){return this.findOnce(e).removeData("jquery-once-"+n(e))};e.fn.findOnce=function(t){var r="jquery-once-"+n(t);return this.filter(function(){return e(this).data(r)===true})}});

(function(t){var e=typeof self=="object"&&self.self==self&&self||typeof global=="object"&&global.global==global&&global;if(typeof define==="function"&&define.amd){define(["underscore","jquery","exports"],function(i,r,n){e.Backbone=t(e,n,i,r)})}else if(typeof exports!=="undefined"){var i=require("underscore"),r;try{r=require("jquery")}catch(n){}t(e,exports,i,r)}else{e.Backbone=t(e,{},e._,e.jQuery||e.Zepto||e.ender||e.$)}})(function(t,e,i,r){var n=t.Backbone;var s=Array.prototype.slice;e.VERSION="1.2.3";e.$=r;e.noConflict=function(){t.Backbone=n;return this};e.emulateHTTP=false;e.emulateJSON=false;var a=function(t,e,r){switch(t){case 1:return function(){return i[e](this[r])};case 2:return function(t){return i[e](this[r],t)};case 3:return function(t,n){return i[e](this[r],h(t,this),n)};case 4:return function(t,n,s){return i[e](this[r],h(t,this),n,s)};default:return function(){var t=s.call(arguments);t.unshift(this[r]);return i[e].apply(i,t)}}};var o=function(t,e,r){i.each(e,function(e,n){if(i[n])t.prototype[n]=a(e,n,r)})};var h=function(t,e){if(i.isFunction(t))return t;if(i.isObject(t)&&!e._isModel(t))return u(t);if(i.isString(t))return function(e){return e.get(t)};return t};var u=function(t){var e=i.matches(t);return function(t){return e(t.attributes)}};var l=e.Events={};var c=/\s+/;var f=function(t,e,r,n,s){var a=0,o;if(r&&typeof r==="object"){if(n!==void 0&&"context"in s&&s.context===void 0)s.context=n;for(o=i.keys(r);a<o.length;a++){e=f(t,e,o[a],r[o[a]],s)}}else if(r&&c.test(r)){for(o=r.split(c);a<o.length;a++){e=t(e,o[a],n,s)}}else{e=t(e,r,n,s)}return e};l.on=function(t,e,i){return d(this,t,e,i)};var d=function(t,e,i,r,n){t._events=f(v,t._events||{},e,i,{context:r,ctx:t,listening:n});if(n){var s=t._listeners||(t._listeners={});s[n.id]=n}return t};l.listenTo=function(t,e,r){if(!t)return this;var n=t._listenId||(t._listenId=i.uniqueId("l"));var s=this._listeningTo||(this._listeningTo={});var a=s[n];if(!a){var o=this._listenId||(this._listenId=i.uniqueId("l"));a=s[n]={obj:t,objId:n,id:o,listeningTo:s,count:0}}d(t,e,r,this,a);return this};var v=function(t,e,i,r){if(i){var n=t[e]||(t[e]=[]);var s=r.context,a=r.ctx,o=r.listening;if(o)o.count++;n.push({callback:i,context:s,ctx:s||a,listening:o})}return t};l.off=function(t,e,i){if(!this._events)return this;this._events=f(g,this._events,t,e,{context:i,listeners:this._listeners});return this};l.stopListening=function(t,e,r){var n=this._listeningTo;if(!n)return this;var s=t?[t._listenId]:i.keys(n);for(var a=0;a<s.length;a++){var o=n[s[a]];if(!o)break;o.obj.off(e,r,this)}if(i.isEmpty(n))this._listeningTo=void 0;return this};var g=function(t,e,r,n){if(!t)return;var s=0,a;var o=n.context,h=n.listeners;if(!e&&!r&&!o){var u=i.keys(h);for(;s<u.length;s++){a=h[u[s]];delete h[a.id];delete a.listeningTo[a.objId]}return}var l=e?[e]:i.keys(t);for(;s<l.length;s++){e=l[s];var c=t[e];if(!c)break;var f=[];for(var d=0;d<c.length;d++){var v=c[d];if(r&&r!==v.callback&&r!==v.callback._callback||o&&o!==v.context){f.push(v)}else{a=v.listening;if(a&&--a.count===0){delete h[a.id];delete a.listeningTo[a.objId]}}}if(f.length){t[e]=f}else{delete t[e]}}if(i.size(t))return t};l.once=function(t,e,r){var n=f(p,{},t,e,i.bind(this.off,this));return this.on(n,void 0,r)};l.listenToOnce=function(t,e,r){var n=f(p,{},e,r,i.bind(this.stopListening,this,t));return this.listenTo(t,n)};var p=function(t,e,r,n){if(r){var s=t[e]=i.once(function(){n(e,s);r.apply(this,arguments)});s._callback=r}return t};l.trigger=function(t){if(!this._events)return this;var e=Math.max(0,arguments.length-1);var i=Array(e);for(var r=0;r<e;r++)i[r]=arguments[r+1];f(m,this._events,t,void 0,i);return this};var m=function(t,e,i,r){if(t){var n=t[e];var s=t.all;if(n&&s)s=s.slice();if(n)_(n,r);if(s)_(s,[e].concat(r))}return t};var _=function(t,e){var i,r=-1,n=t.length,s=e[0],a=e[1],o=e[2];switch(e.length){case 0:while(++r<n)(i=t[r]).callback.call(i.ctx);return;case 1:while(++r<n)(i=t[r]).callback.call(i.ctx,s);return;case 2:while(++r<n)(i=t[r]).callback.call(i.ctx,s,a);return;case 3:while(++r<n)(i=t[r]).callback.call(i.ctx,s,a,o);return;default:while(++r<n)(i=t[r]).callback.apply(i.ctx,e);return}};l.bind=l.on;l.unbind=l.off;i.extend(e,l);var y=e.Model=function(t,e){var r=t||{};e||(e={});this.cid=i.uniqueId(this.cidPrefix);this.attributes={};if(e.collection)this.collection=e.collection;if(e.parse)r=this.parse(r,e)||{};r=i.defaults({},r,i.result(this,"defaults"));this.set(r,e);this.changed={};this.initialize.apply(this,arguments)};i.extend(y.prototype,l,{changed:null,validationError:null,idAttribute:"id",cidPrefix:"c",initialize:function(){},toJSON:function(t){return i.clone(this.attributes)},sync:function(){return e.sync.apply(this,arguments)},get:function(t){return this.attributes[t]},escape:function(t){return i.escape(this.get(t))},has:function(t){return this.get(t)!=null},matches:function(t){return!!i.iteratee(t,this)(this.attributes)},set:function(t,e,r){if(t==null)return this;var n;if(typeof t==="object"){n=t;r=e}else{(n={})[t]=e}r||(r={});if(!this._validate(n,r))return false;var s=r.unset;var a=r.silent;var o=[];var h=this._changing;this._changing=true;if(!h){this._previousAttributes=i.clone(this.attributes);this.changed={}}var u=this.attributes;var l=this.changed;var c=this._previousAttributes;for(var f in n){e=n[f];if(!i.isEqual(u[f],e))o.push(f);if(!i.isEqual(c[f],e)){l[f]=e}else{delete l[f]}s?delete u[f]:u[f]=e}this.id=this.get(this.idAttribute);if(!a){if(o.length)this._pending=r;for(var d=0;d<o.length;d++){this.trigger("change:"+o[d],this,u[o[d]],r)}}if(h)return this;if(!a){while(this._pending){r=this._pending;this._pending=false;this.trigger("change",this,r)}}this._pending=false;this._changing=false;return this},unset:function(t,e){return this.set(t,void 0,i.extend({},e,{unset:true}))},clear:function(t){var e={};for(var r in this.attributes)e[r]=void 0;return this.set(e,i.extend({},t,{unset:true}))},hasChanged:function(t){if(t==null)return!i.isEmpty(this.changed);return i.has(this.changed,t)},changedAttributes:function(t){if(!t)return this.hasChanged()?i.clone(this.changed):false;var e=this._changing?this._previousAttributes:this.attributes;var r={};for(var n in t){var s=t[n];if(i.isEqual(e[n],s))continue;r[n]=s}return i.size(r)?r:false},previous:function(t){if(t==null||!this._previousAttributes)return null;return this._previousAttributes[t]},previousAttributes:function(){return i.clone(this._previousAttributes)},fetch:function(t){t=i.extend({parse:true},t);var e=this;var r=t.success;t.success=function(i){var n=t.parse?e.parse(i,t):i;if(!e.set(n,t))return false;if(r)r.call(t.context,e,i,t);e.trigger("sync",e,i,t)};z(this,t);return this.sync("read",this,t)},save:function(t,e,r){var n;if(t==null||typeof t==="object"){n=t;r=e}else{(n={})[t]=e}r=i.extend({validate:true,parse:true},r);var s=r.wait;if(n&&!s){if(!this.set(n,r))return false}else{if(!this._validate(n,r))return false}var a=this;var o=r.success;var h=this.attributes;r.success=function(t){a.attributes=h;var e=r.parse?a.parse(t,r):t;if(s)e=i.extend({},n,e);if(e&&!a.set(e,r))return false;if(o)o.call(r.context,a,t,r);a.trigger("sync",a,t,r)};z(this,r);if(n&&s)this.attributes=i.extend({},h,n);var u=this.isNew()?"create":r.patch?"patch":"update";if(u==="patch"&&!r.attrs)r.attrs=n;var l=this.sync(u,this,r);this.attributes=h;return l},destroy:function(t){t=t?i.clone(t):{};var e=this;var r=t.success;var n=t.wait;var s=function(){e.stopListening();e.trigger("destroy",e,e.collection,t)};t.success=function(i){if(n)s();if(r)r.call(t.context,e,i,t);if(!e.isNew())e.trigger("sync",e,i,t)};var a=false;if(this.isNew()){i.defer(t.success)}else{z(this,t);a=this.sync("delete",this,t)}if(!n)s();return a},url:function(){var t=i.result(this,"urlRoot")||i.result(this.collection,"url")||F();if(this.isNew())return t;var e=this.get(this.idAttribute);return t.replace(/[^\/]$/,"$&/")+encodeURIComponent(e)},parse:function(t,e){return t},clone:function(){return new this.constructor(this.attributes)},isNew:function(){return!this.has(this.idAttribute)},isValid:function(t){return this._validate({},i.defaults({validate:true},t))},_validate:function(t,e){if(!e.validate||!this.validate)return true;t=i.extend({},this.attributes,t);var r=this.validationError=this.validate(t,e)||null;if(!r)return true;this.trigger("invalid",this,r,i.extend(e,{validationError:r}));return false}});var b={keys:1,values:1,pairs:1,invert:1,pick:0,omit:0,chain:1,isEmpty:1};o(y,b,"attributes");var x=e.Collection=function(t,e){e||(e={});if(e.model)this.model=e.model;if(e.comparator!==void 0)this.comparator=e.comparator;this._reset();this.initialize.apply(this,arguments);if(t)this.reset(t,i.extend({silent:true},e))};var w={add:true,remove:true,merge:true};var E={add:true,remove:false};var k=function(t,e,i){i=Math.min(Math.max(i,0),t.length);var r=Array(t.length-i);var n=e.length;for(var s=0;s<r.length;s++)r[s]=t[s+i];for(s=0;s<n;s++)t[s+i]=e[s];for(s=0;s<r.length;s++)t[s+n+i]=r[s]};i.extend(x.prototype,l,{model:y,initialize:function(){},toJSON:function(t){return this.map(function(e){return e.toJSON(t)})},sync:function(){return e.sync.apply(this,arguments)},add:function(t,e){return this.set(t,i.extend({merge:false},e,E))},remove:function(t,e){e=i.extend({},e);var r=!i.isArray(t);t=r?[t]:i.clone(t);var n=this._removeModels(t,e);if(!e.silent&&n)this.trigger("update",this,e);return r?n[0]:n},set:function(t,e){if(t==null)return;e=i.defaults({},e,w);if(e.parse&&!this._isModel(t))t=this.parse(t,e);var r=!i.isArray(t);t=r?[t]:t.slice();var n=e.at;if(n!=null)n=+n;if(n<0)n+=this.length+1;var s=[];var a=[];var o=[];var h={};var u=e.add;var l=e.merge;var c=e.remove;var f=false;var d=this.comparator&&n==null&&e.sort!==false;var v=i.isString(this.comparator)?this.comparator:null;var g;for(var p=0;p<t.length;p++){g=t[p];var m=this.get(g);if(m){if(l&&g!==m){var _=this._isModel(g)?g.attributes:g;if(e.parse)_=m.parse(_,e);m.set(_,e);if(d&&!f)f=m.hasChanged(v)}if(!h[m.cid]){h[m.cid]=true;s.push(m)}t[p]=m}else if(u){g=t[p]=this._prepareModel(g,e);if(g){a.push(g);this._addReference(g,e);h[g.cid]=true;s.push(g)}}}if(c){for(p=0;p<this.length;p++){g=this.models[p];if(!h[g.cid])o.push(g)}if(o.length)this._removeModels(o,e)}var y=false;var b=!d&&u&&c;if(s.length&&b){y=this.length!=s.length||i.some(this.models,function(t,e){return t!==s[e]});this.models.length=0;k(this.models,s,0);this.length=this.models.length}else if(a.length){if(d)f=true;k(this.models,a,n==null?this.length:n);this.length=this.models.length}if(f)this.sort({silent:true});if(!e.silent){for(p=0;p<a.length;p++){if(n!=null)e.index=n+p;g=a[p];g.trigger("add",g,this,e)}if(f||y)this.trigger("sort",this,e);if(a.length||o.length)this.trigger("update",this,e)}return r?t[0]:t},reset:function(t,e){e=e?i.clone(e):{};for(var r=0;r<this.models.length;r++){this._removeReference(this.models[r],e)}e.previousModels=this.models;this._reset();t=this.add(t,i.extend({silent:true},e));if(!e.silent)this.trigger("reset",this,e);return t},push:function(t,e){return this.add(t,i.extend({at:this.length},e))},pop:function(t){var e=this.at(this.length-1);return this.remove(e,t)},unshift:function(t,e){return this.add(t,i.extend({at:0},e))},shift:function(t){var e=this.at(0);return this.remove(e,t)},slice:function(){return s.apply(this.models,arguments)},get:function(t){if(t==null)return void 0;var e=this.modelId(this._isModel(t)?t.attributes:t);return this._byId[t]||this._byId[e]||this._byId[t.cid]},at:function(t){if(t<0)t+=this.length;return this.models[t]},where:function(t,e){return this[e?"find":"filter"](t)},findWhere:function(t){return this.where(t,true)},sort:function(t){var e=this.comparator;if(!e)throw new Error("Cannot sort a set without a comparator");t||(t={});var r=e.length;if(i.isFunction(e))e=i.bind(e,this);if(r===1||i.isString(e)){this.models=this.sortBy(e)}else{this.models.sort(e)}if(!t.silent)this.trigger("sort",this,t);return this},pluck:function(t){return i.invoke(this.models,"get",t)},fetch:function(t){t=i.extend({parse:true},t);var e=t.success;var r=this;t.success=function(i){var n=t.reset?"reset":"set";r[n](i,t);if(e)e.call(t.context,r,i,t);r.trigger("sync",r,i,t)};z(this,t);return this.sync("read",this,t)},create:function(t,e){e=e?i.clone(e):{};var r=e.wait;t=this._prepareModel(t,e);if(!t)return false;if(!r)this.add(t,e);var n=this;var s=e.success;e.success=function(t,e,i){if(r)n.add(t,i);if(s)s.call(i.context,t,e,i)};t.save(null,e);return t},parse:function(t,e){return t},clone:function(){return new this.constructor(this.models,{model:this.model,comparator:this.comparator})},modelId:function(t){return t[this.model.prototype.idAttribute||"id"]},_reset:function(){this.length=0;this.models=[];this._byId={}},_prepareModel:function(t,e){if(this._isModel(t)){if(!t.collection)t.collection=this;return t}e=e?i.clone(e):{};e.collection=this;var r=new this.model(t,e);if(!r.validationError)return r;this.trigger("invalid",this,r.validationError,e);return false},_removeModels:function(t,e){var i=[];for(var r=0;r<t.length;r++){var n=this.get(t[r]);if(!n)continue;var s=this.indexOf(n);this.models.splice(s,1);this.length--;if(!e.silent){e.index=s;n.trigger("remove",n,this,e)}i.push(n);this._removeReference(n,e)}return i.length?i:false},_isModel:function(t){return t instanceof y},_addReference:function(t,e){this._byId[t.cid]=t;var i=this.modelId(t.attributes);if(i!=null)this._byId[i]=t;t.on("all",this._onModelEvent,this)},_removeReference:function(t,e){delete this._byId[t.cid];var i=this.modelId(t.attributes);if(i!=null)delete this._byId[i];if(this===t.collection)delete t.collection;t.off("all",this._onModelEvent,this)},_onModelEvent:function(t,e,i,r){if((t==="add"||t==="remove")&&i!==this)return;if(t==="destroy")this.remove(e,r);if(t==="change"){var n=this.modelId(e.previousAttributes());var s=this.modelId(e.attributes);if(n!==s){if(n!=null)delete this._byId[n];if(s!=null)this._byId[s]=e}}this.trigger.apply(this,arguments)}});var S={forEach:3,each:3,map:3,collect:3,reduce:4,foldl:4,inject:4,reduceRight:4,foldr:4,find:3,detect:3,filter:3,select:3,reject:3,every:3,all:3,some:3,any:3,include:3,includes:3,contains:3,invoke:0,max:3,min:3,toArray:1,size:1,first:3,head:3,take:3,initial:3,rest:3,tail:3,drop:3,last:3,without:0,difference:0,indexOf:3,shuffle:1,lastIndexOf:3,isEmpty:1,chain:1,sample:3,partition:3,groupBy:3,countBy:3,sortBy:3,indexBy:3};o(x,S,"models");var I=e.View=function(t){this.cid=i.uniqueId("view");i.extend(this,i.pick(t,P));this._ensureElement();this.initialize.apply(this,arguments)};var T=/^(\S+)\s*(.*)$/;var P=["model","collection","el","id","attributes","className","tagName","events"];i.extend(I.prototype,l,{tagName:"div",$:function(t){return this.$el.find(t)},initialize:function(){},render:function(){return this},remove:function(){this._removeElement();this.stopListening();return this},_removeElement:function(){this.$el.remove()},setElement:function(t){this.undelegateEvents();this._setElement(t);this.delegateEvents();return this},_setElement:function(t){this.$el=t instanceof e.$?t:e.$(t);this.el=this.$el[0]},delegateEvents:function(t){t||(t=i.result(this,"events"));if(!t)return this;this.undelegateEvents();for(var e in t){var r=t[e];if(!i.isFunction(r))r=this[r];if(!r)continue;var n=e.match(T);this.delegate(n[1],n[2],i.bind(r,this))}return this},delegate:function(t,e,i){this.$el.on(t+".delegateEvents"+this.cid,e,i);return this},undelegateEvents:function(){if(this.$el)this.$el.off(".delegateEvents"+this.cid);return this},undelegate:function(t,e,i){this.$el.off(t+".delegateEvents"+this.cid,e,i);return this},_createElement:function(t){return document.createElement(t)},_ensureElement:function(){if(!this.el){var t=i.extend({},i.result(this,"attributes"));if(this.id)t.id=i.result(this,"id");if(this.className)t["class"]=i.result(this,"className");this.setElement(this._createElement(i.result(this,"tagName")));this._setAttributes(t)}else{this.setElement(i.result(this,"el"))}},_setAttributes:function(t){this.$el.attr(t)}});e.sync=function(t,r,n){var s=H[t];i.defaults(n||(n={}),{emulateHTTP:e.emulateHTTP,emulateJSON:e.emulateJSON});var a={type:s,dataType:"json"};if(!n.url){a.url=i.result(r,"url")||F()}if(n.data==null&&r&&(t==="create"||t==="update"||t==="patch")){a.contentType="application/json";a.data=JSON.stringify(n.attrs||r.toJSON(n))}if(n.emulateJSON){a.contentType="application/x-www-form-urlencoded";a.data=a.data?{model:a.data}:{}}if(n.emulateHTTP&&(s==="PUT"||s==="DELETE"||s==="PATCH")){a.type="POST";if(n.emulateJSON)a.data._method=s;var o=n.beforeSend;n.beforeSend=function(t){t.setRequestHeader("X-HTTP-Method-Override",s);if(o)return o.apply(this,arguments)}}if(a.type!=="GET"&&!n.emulateJSON){a.processData=false}var h=n.error;n.error=function(t,e,i){n.textStatus=e;n.errorThrown=i;if(h)h.call(n.context,t,e,i)};var u=n.xhr=e.ajax(i.extend(a,n));r.trigger("request",r,u,n);return u};var H={create:"POST",update:"PUT",patch:"PATCH","delete":"DELETE",read:"GET"};e.ajax=function(){return e.$.ajax.apply(e.$,arguments)};var $=e.Router=function(t){t||(t={});if(t.routes)this.routes=t.routes;this._bindRoutes();this.initialize.apply(this,arguments)};var A=/\((.*?)\)/g;var C=/(\(\?)?:\w+/g;var R=/\*\w+/g;var j=/[\-{}\[\]+?.,\\\^$|#\s]/g;i.extend($.prototype,l,{initialize:function(){},route:function(t,r,n){if(!i.isRegExp(t))t=this._routeToRegExp(t);if(i.isFunction(r)){n=r;r=""}if(!n)n=this[r];var s=this;e.history.route(t,function(i){var a=s._extractParameters(t,i);if(s.execute(n,a,r)!==false){s.trigger.apply(s,["route:"+r].concat(a));s.trigger("route",r,a);e.history.trigger("route",s,r,a)}});return this},execute:function(t,e,i){if(t)t.apply(this,e)},navigate:function(t,i){e.history.navigate(t,i);return this},_bindRoutes:function(){if(!this.routes)return;this.routes=i.result(this,"routes");var t,e=i.keys(this.routes);while((t=e.pop())!=null){this.route(t,this.routes[t])}},_routeToRegExp:function(t){t=t.replace(j,"\\$&").replace(A,"(?:$1)?").replace(C,function(t,e){return e?t:"([^/?]+)"}).replace(R,"([^?]*?)");return new RegExp("^"+t+"(?:\\?([\\s\\S]*))?$")},_extractParameters:function(t,e){var r=t.exec(e).slice(1);return i.map(r,function(t,e){if(e===r.length-1)return t||null;return t?decodeURIComponent(t):null})}});var M=e.History=function(){this.handlers=[];this.checkUrl=i.bind(this.checkUrl,this);if(typeof window!=="undefined"){this.location=window.location;this.history=window.history}};var N=/^[#\/]|\s+$/g;var O=/^\/+|\/+$/g;var U=/#.*$/;M.started=false;i.extend(M.prototype,l,{interval:50,atRoot:function(){var t=this.location.pathname.replace(/[^\/]$/,"$&/");return t===this.root&&!this.getSearch()},matchRoot:function(){var t=this.decodeFragment(this.location.pathname);var e=t.slice(0,this.root.length-1)+"/";return e===this.root},decodeFragment:function(t){return decodeURI(t.replace(/%25/g,"%2525"))},getSearch:function(){var t=this.location.href.replace(/#.*/,"").match(/\?.+/);return t?t[0]:""},getHash:function(t){var e=(t||this).location.href.match(/#(.*)$/);return e?e[1]:""},getPath:function(){var t=this.decodeFragment(this.location.pathname+this.getSearch()).slice(this.root.length-1);return t.charAt(0)==="/"?t.slice(1):t},getFragment:function(t){if(t==null){if(this._usePushState||!this._wantsHashChange){t=this.getPath()}else{t=this.getHash()}}return t.replace(N,"")},start:function(t){if(M.started)throw new Error("Backbone.history has already been started");M.started=true;this.options=i.extend({root:"/"},this.options,t);this.root=this.options.root;this._wantsHashChange=this.options.hashChange!==false;this._hasHashChange="onhashchange"in window&&(document.documentMode===void 0||document.documentMode>7);this._useHashChange=this._wantsHashChange&&this._hasHashChange;this._wantsPushState=!!this.options.pushState;this._hasPushState=!!(this.history&&this.history.pushState);this._usePushState=this._wantsPushState&&this._hasPushState;this.fragment=this.getFragment();this.root=("/"+this.root+"/").replace(O,"/");if(this._wantsHashChange&&this._wantsPushState){if(!this._hasPushState&&!this.atRoot()){var e=this.root.slice(0,-1)||"/";this.location.replace(e+"#"+this.getPath());return true}else if(this._hasPushState&&this.atRoot()){this.navigate(this.getHash(),{replace:true})}}if(!this._hasHashChange&&this._wantsHashChange&&!this._usePushState){this.iframe=document.createElement("iframe");this.iframe.src="javascript:0";this.iframe.style.display="none";this.iframe.tabIndex=-1;var r=document.body;var n=r.insertBefore(this.iframe,r.firstChild).contentWindow;n.document.open();n.document.close();n.location.hash="#"+this.fragment}var s=window.addEventListener||function(t,e){return attachEvent("on"+t,e)};if(this._usePushState){s("popstate",this.checkUrl,false)}else if(this._useHashChange&&!this.iframe){s("hashchange",this.checkUrl,false)}else if(this._wantsHashChange){this._checkUrlInterval=setInterval(this.checkUrl,this.interval)}if(!this.options.silent)return this.loadUrl()},stop:function(){var t=window.removeEventListener||function(t,e){return detachEvent("on"+t,e)};if(this._usePushState){t("popstate",this.checkUrl,false)}else if(this._useHashChange&&!this.iframe){t("hashchange",this.checkUrl,false)}if(this.iframe){document.body.removeChild(this.iframe);this.iframe=null}if(this._checkUrlInterval)clearInterval(this._checkUrlInterval);M.started=false},route:function(t,e){this.handlers.unshift({route:t,callback:e})},checkUrl:function(t){var e=this.getFragment();if(e===this.fragment&&this.iframe){e=this.getHash(this.iframe.contentWindow)}if(e===this.fragment)return false;if(this.iframe)this.navigate(e);this.loadUrl()},loadUrl:function(t){if(!this.matchRoot())return false;t=this.fragment=this.getFragment(t);return i.some(this.handlers,function(e){if(e.route.test(t)){e.callback(t);return true}})},navigate:function(t,e){if(!M.started)return false;if(!e||e===true)e={trigger:!!e};t=this.getFragment(t||"");var i=this.root;if(t===""||t.charAt(0)==="?"){i=i.slice(0,-1)||"/"}var r=i+t;t=this.decodeFragment(t.replace(U,""));if(this.fragment===t)return;this.fragment=t;if(this._usePushState){this.history[e.replace?"replaceState":"pushState"]({},document.title,r)}else if(this._wantsHashChange){this._updateHash(this.location,t,e.replace);if(this.iframe&&t!==this.getHash(this.iframe.contentWindow)){var n=this.iframe.contentWindow;if(!e.replace){n.document.open();n.document.close()}this._updateHash(n.location,t,e.replace)}}else{return this.location.assign(r)}if(e.trigger)return this.loadUrl(t)},_updateHash:function(t,e,i){if(i){var r=t.href.replace(/(javascript:|#).*$/,"");t.replace(r+"#"+e)}else{t.hash="#"+e}}});e.history=new M;var q=function(t,e){var r=this;var n;if(t&&i.has(t,"constructor")){n=t.constructor}else{n=function(){return r.apply(this,arguments)}}i.extend(n,r,e);var s=function(){this.constructor=n};s.prototype=r.prototype;n.prototype=new s;if(t)i.extend(n.prototype,t);n.__super__=r.prototype;return n};y.extend=x.extend=$.extend=I.extend=M.extend=q;var F=function(){throw new Error('A "url" property or function must be specified')};var z=function(t,e){var i=e.error;e.error=function(r){if(i)i.call(e.context,t,r,e);t.trigger("error",t,r,e)}};return e});

/**
 * @file
 * Parse inline JSON and initialize the drupalSettings global object.
 */

(function () {

  'use strict';

  // Use direct child elements to harden against XSS exploits when CSP is on.
  var settingsElement = document.querySelector('head > script[type="application/json"][data-drupal-selector="drupal-settings-json"], body > script[type="application/json"][data-drupal-selector="drupal-settings-json"]');

  /**
   * Variable generated by Drupal with all the configuration created from PHP.
   *
   * @global
   *
   * @type {object}
   */
  window.drupalSettings = {};

  if (settingsElement !== null) {
    window.drupalSettings = JSON.parse(settingsElement.textContent);
  }
})();
;
/**
 * @file
 * Defines the Drupal JavaScript API.
 */

/**
 * A jQuery object, typically the return value from a `$(selector)` call.
 *
 * Holds an HTMLElement or a collection of HTMLElements.
 *
 * @typedef {object} jQuery
 *
 * @prop {number} length=0
 *   Number of elements contained in the jQuery object.
 */

/**
 * Variable generated by Drupal that holds all translated strings from PHP.
 *
 * Content of this variable is automatically created by Drupal when using the
 * Interface Translation module. It holds the translation of strings used on
 * the page.
 *
 * This variable is used to pass data from the backend to the frontend. Data
 * contained in `drupalSettings` is used during behavior initialization.
 *
 * @global
 *
 * @var {object} drupalTranslations
 */

/**
 * Global Drupal object.
 *
 * All Drupal JavaScript APIs are contained in this namespace.
 *
 * @global
 *
 * @namespace
 */
window.Drupal = {behaviors: {}, locale: {}};

// Class indicating that JavaScript is enabled; used for styling purpose.
document.documentElement.className += ' js';

// Allow other JavaScript libraries to use $.
if (window.jQuery) {
  jQuery.noConflict();
}

// JavaScript should be made compatible with libraries other than jQuery by
// wrapping it in an anonymous closure.
(function (domready, Drupal, drupalSettings, drupalTranslations) {

  'use strict';

  /**
   * Helper to rethrow errors asynchronously.
   *
   * This way Errors bubbles up outside of the original callstack, making it
   * easier to debug errors in the browser.
   *
   * @param {Error|string} error
   *   The error to be thrown.
   */
  Drupal.throwError = function (error) {
    setTimeout(function () { throw error; }, 0);
  };

  /**
   * Custom error thrown after attach/detach if one or more behaviors failed.
   * Initializes the JavaScript behaviors for page loads and Ajax requests.
   *
   * @callback Drupal~behaviorAttach
   *
   * @param {HTMLDocument|HTMLElement} context
   *   An element to detach behaviors from.
   * @param {?object} settings
   *   An object containing settings for the current context. It is rarely used.
   *
   * @see Drupal.attachBehaviors
   */

  /**
   * Reverts and cleans up JavaScript behavior initialization.
   *
   * @callback Drupal~behaviorDetach
   *
   * @param {HTMLDocument|HTMLElement} context
   *   An element to attach behaviors to.
   * @param {object} settings
   *   An object containing settings for the current context.
   * @param {string} trigger
   *   One of `'unload'`, `'move'`, or `'serialize'`.
   *
   * @see Drupal.detachBehaviors
   */

  /**
   * @typedef {object} Drupal~behavior
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Function run on page load and after an Ajax call.
   * @prop {Drupal~behaviorDetach} detach
   *   Function run when content is serialized or removed from the page.
   */

  /**
   * Holds all initialization methods.
   *
   * @namespace Drupal.behaviors
   *
   * @type {Object.<string, Drupal~behavior>}
   */

  /**
   * Defines a behavior to be run during attach and detach phases.
   *
   * Attaches all registered behaviors to a page element.
   *
   * Behaviors are event-triggered actions that attach to page elements,
   * enhancing default non-JavaScript UIs. Behaviors are registered in the
   * {@link Drupal.behaviors} object using the method 'attach' and optionally
   * also 'detach'.
   *
   * {@link Drupal.attachBehaviors} is added below to the `jQuery.ready` event
   * and therefore runs on initial page load. Developers implementing Ajax in
   * their solutions should also call this function after new page content has
   * been loaded, feeding in an element to be processed, in order to attach all
   * behaviors to the new content.
   *
   * Behaviors should use `var elements =
   * $(context).find(selector).once('behavior-name');` to ensure the behavior is
   * attached only once to a given element. (Doing so enables the reprocessing
   * of given elements, which may be needed on occasion despite the ability to
   * limit behavior attachment to a particular element.)
   *
   * @example
   * Drupal.behaviors.behaviorName = {
   *   attach: function (context, settings) {
   *     // ...
   *   },
   *   detach: function (context, settings, trigger) {
   *     // ...
   *   }
   * };
   *
   * @param {HTMLDocument|HTMLElement} [context=document]
   *   An element to attach behaviors to.
   * @param {object} [settings=drupalSettings]
   *   An object containing settings for the current context. If none is given,
   *   the global {@link drupalSettings} object is used.
   *
   * @see Drupal~behaviorAttach
   * @see Drupal.detachBehaviors
   *
   * @throws {Drupal~DrupalBehaviorError}
   */
  Drupal.attachBehaviors = function (context, settings) {
    context = context || document;
    settings = settings || drupalSettings;
    var behaviors = Drupal.behaviors;
    // Execute all of them.
    for (var i in behaviors) {
      if (behaviors.hasOwnProperty(i) && typeof behaviors[i].attach === 'function') {
        // Don't stop the execution of behaviors in case of an error.
        try {
          behaviors[i].attach(context, settings);
        }
        catch (e) {
          Drupal.throwError(e);
        }
      }
    }
  };

  // Attach all behaviors.
  domready(function () { Drupal.attachBehaviors(document, drupalSettings); });

  /**
   * Detaches registered behaviors from a page element.
   *
   * Developers implementing Ajax in their solutions should call this function
   * before page content is about to be removed, feeding in an element to be
   * processed, in order to allow special behaviors to detach from the content.
   *
   * Such implementations should use `.findOnce()` and `.removeOnce()` to find
   * elements with their corresponding `Drupal.behaviors.behaviorName.attach`
   * implementation, i.e. `.removeOnce('behaviorName')`, to ensure the behavior
   * is detached only from previously processed elements.
   *
   * @param {HTMLDocument|HTMLElement} [context=document]
   *   An element to detach behaviors from.
   * @param {object} [settings=drupalSettings]
   *   An object containing settings for the current context. If none given,
   *   the global {@link drupalSettings} object is used.
   * @param {string} [trigger='unload']
   *   A string containing what's causing the behaviors to be detached. The
   *   possible triggers are:
   *   - `'unload'`: The context element is being removed from the DOM.
   *   - `'move'`: The element is about to be moved within the DOM (for example,
   *     during a tabledrag row swap). After the move is completed,
   *     {@link Drupal.attachBehaviors} is called, so that the behavior can undo
   *     whatever it did in response to the move. Many behaviors won't need to
   *     do anything simply in response to the element being moved, but because
   *     IFRAME elements reload their "src" when being moved within the DOM,
   *     behaviors bound to IFRAME elements (like WYSIWYG editors) may need to
   *     take some action.
   *   - `'serialize'`: When an Ajax form is submitted, this is called with the
   *     form as the context. This provides every behavior within the form an
   *     opportunity to ensure that the field elements have correct content
   *     in them before the form is serialized. The canonical use-case is so
   *     that WYSIWYG editors can update the hidden textarea to which they are
   *     bound.
   *
   * @throws {Drupal~DrupalBehaviorError}
   *
   * @see Drupal~behaviorDetach
   * @see Drupal.attachBehaviors
   */
  Drupal.detachBehaviors = function (context, settings, trigger) {
    context = context || document;
    settings = settings || drupalSettings;
    trigger = trigger || 'unload';
    var behaviors = Drupal.behaviors;
    // Execute all of them.
    for (var i in behaviors) {
      if (behaviors.hasOwnProperty(i) && typeof behaviors[i].detach === 'function') {
        // Don't stop the execution of behaviors in case of an error.
        try {
          behaviors[i].detach(context, settings, trigger);
        }
        catch (e) {
          Drupal.throwError(e);
        }
      }
    }
  };

  /**
   * Encodes special characters in a plain-text string for display as HTML.
   *
   * @param {string} str
   *   The string to be encoded.
   *
   * @return {string}
   *   The encoded string.
   *
   * @ingroup sanitization
   */
  Drupal.checkPlain = function (str) {
    str = str.toString()
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
    return str;
  };

  /**
   * Replaces placeholders with sanitized values in a string.
   *
   * @param {string} str
   *   A string with placeholders.
   * @param {object} args
   *   An object of replacements pairs to make. Incidences of any key in this
   *   array are replaced with the corresponding value. Based on the first
   *   character of the key, the value is escaped and/or themed:
   *    - `'!variable'`: inserted as is.
   *    - `'@variable'`: escape plain text to HTML ({@link Drupal.checkPlain}).
   *    - `'%variable'`: escape text and theme as a placeholder for user-
   *      submitted content ({@link Drupal.checkPlain} +
   *      `{@link Drupal.theme}('placeholder')`).
   *
   * @return {string}
   *   The formatted string.
   *
   * @see Drupal.t
   */
  Drupal.formatString = function (str, args) {
    // Keep args intact.
    var processedArgs = {};
    // Transform arguments before inserting them.
    for (var key in args) {
      if (args.hasOwnProperty(key)) {
        switch (key.charAt(0)) {
          // Escaped only.
          case '@':
            processedArgs[key] = Drupal.checkPlain(args[key]);
            break;

          // Pass-through.
          case '!':
            processedArgs[key] = args[key];
            break;

          // Escaped and placeholder.
          default:
            processedArgs[key] = Drupal.theme('placeholder', args[key]);
            break;
        }
      }
    }

    return Drupal.stringReplace(str, processedArgs, null);
  };

  /**
   * Replaces substring.
   *
   * The longest keys will be tried first. Once a substring has been replaced,
   * its new value will not be searched again.
   *
   * @param {string} str
   *   A string with placeholders.
   * @param {object} args
   *   Key-value pairs.
   * @param {Array|null} keys
   *   Array of keys from `args`. Internal use only.
   *
   * @return {string}
   *   The replaced string.
   */
  Drupal.stringReplace = function (str, args, keys) {
    if (str.length === 0) {
      return str;
    }

    // If the array of keys is not passed then collect the keys from the args.
    if (!Array.isArray(keys)) {
      keys = [];
      for (var k in args) {
        if (args.hasOwnProperty(k)) {
          keys.push(k);
        }
      }

      // Order the keys by the character length. The shortest one is the first.
      keys.sort(function (a, b) { return a.length - b.length; });
    }

    if (keys.length === 0) {
      return str;
    }

    // Take next longest one from the end.
    var key = keys.pop();
    var fragments = str.split(key);

    if (keys.length) {
      for (var i = 0; i < fragments.length; i++) {
        // Process each fragment with a copy of remaining keys.
        fragments[i] = Drupal.stringReplace(fragments[i], args, keys.slice(0));
      }
    }

    return fragments.join(args[key]);
  };

  /**
   * Translates strings to the page language, or a given language.
   *
   * See the documentation of the server-side t() function for further details.
   *
   * @param {string} str
   *   A string containing the English text to translate.
   * @param {Object.<string, string>} [args]
   *   An object of replacements pairs to make after translation. Incidences
   *   of any key in this array are replaced with the corresponding value.
   *   See {@link Drupal.formatString}.
   * @param {object} [options]
   *   Additional options for translation.
   * @param {string} [options.context='']
   *   The context the source string belongs to.
   *
   * @return {string}
   *   The formatted string.
   *   The translated string.
   */
  Drupal.t = function (str, args, options) {
    options = options || {};
    options.context = options.context || '';

    // Fetch the localized version of the string.
    if (typeof drupalTranslations !== 'undefined' && drupalTranslations.strings && drupalTranslations.strings[options.context] && drupalTranslations.strings[options.context][str]) {
      str = drupalTranslations.strings[options.context][str];
    }

    if (args) {
      str = Drupal.formatString(str, args);
    }
    return str;
  };

  /**
   * Returns the URL to a Drupal page.
   *
   * @param {string} path
   *   Drupal path to transform to URL.
   *
   * @return {string}
   *   The full URL.
   */
  Drupal.url = function (path) {
    return drupalSettings.path.baseUrl + drupalSettings.path.pathPrefix + path;
  };

  /**
   * Returns the passed in URL as an absolute URL.
   *
   * @param {string} url
   *   The URL string to be normalized to an absolute URL.
   *
   * @return {string}
   *   The normalized, absolute URL.
   *
   * @see https://github.com/angular/angular.js/blob/v1.4.4/src/ng/urlUtils.js
   * @see https://grack.com/blog/2009/11/17/absolutizing-url-in-javascript
   * @see https://github.com/jquery/jquery-ui/blob/1.11.4/ui/tabs.js#L53
   */
  Drupal.url.toAbsolute = function (url) {
    var urlParsingNode = document.createElement('a');

    // Decode the URL first; this is required by IE <= 6. Decoding non-UTF-8
    // strings may throw an exception.
    try {
      url = decodeURIComponent(url);
    }
    catch (e) {
      // Empty.
    }

    urlParsingNode.setAttribute('href', url);

    // IE <= 7 normalizes the URL when assigned to the anchor node similar to
    // the other browsers.
    return urlParsingNode.cloneNode(false).href;
  };

  /**
   * Returns true if the URL is within Drupal's base path.
   *
   * @param {string} url
   *   The URL string to be tested.
   *
   * @return {bool}
   *   `true` if local.
   *
   * @see https://github.com/jquery/jquery-ui/blob/1.11.4/ui/tabs.js#L58
   */
  Drupal.url.isLocal = function (url) {
    // Always use browser-derived absolute URLs in the comparison, to avoid
    // attempts to break out of the base path using directory traversal.
    var absoluteUrl = Drupal.url.toAbsolute(url);
    var protocol = location.protocol;

    // Consider URLs that match this site's base URL but use HTTPS instead of HTTP
    // as local as well.
    if (protocol === 'http:' && absoluteUrl.indexOf('https:') === 0) {
      protocol = 'https:';
    }
    var baseUrl = protocol + '//' + location.host + drupalSettings.path.baseUrl.slice(0, -1);

    // Decoding non-UTF-8 strings may throw an exception.
    try {
      absoluteUrl = decodeURIComponent(absoluteUrl);
    }
    catch (e) {
      // Empty.
    }
    try {
      baseUrl = decodeURIComponent(baseUrl);
    }
    catch (e) {
      // Empty.
    }

    // The given URL matches the site's base URL, or has a path under the site's
    // base URL.
    return absoluteUrl === baseUrl || absoluteUrl.indexOf(baseUrl + '/') === 0;
  };

  /**
   * Formats a string containing a count of items.
   *
   * This function ensures that the string is pluralized correctly. Since
   * {@link Drupal.t} is called by this function, make sure not to pass
   * already-localized strings to it.
   *
   * See the documentation of the server-side
   * \Drupal\Core\StringTranslation\TranslationInterface::formatPlural()
   * function for more details.
   *
   * @param {number} count
   *   The item count to display.
   * @param {string} singular
   *   The string for the singular case. Please make sure it is clear this is
   *   singular, to ease translation (e.g. use "1 new comment" instead of "1
   *   new"). Do not use @count in the singular string.
   * @param {string} plural
   *   The string for the plural case. Please make sure it is clear this is
   *   plural, to ease translation. Use @count in place of the item count, as in
   *   "@count new comments".
   * @param {object} [args]
   *   An object of replacements pairs to make after translation. Incidences
   *   of any key in this array are replaced with the corresponding value.
   *   See {@link Drupal.formatString}.
   *   Note that you do not need to include @count in this array.
   *   This replacement is done automatically for the plural case.
   * @param {object} [options]
   *   The options to pass to the {@link Drupal.t} function.
   *
   * @return {string}
   *   A translated string.
   */
  Drupal.formatPlural = function (count, singular, plural, args, options) {
    args = args || {};
    args['@count'] = count;

    var pluralDelimiter = drupalSettings.pluralDelimiter;
    var translations = Drupal.t(singular + pluralDelimiter + plural, args, options).split(pluralDelimiter);
    var index = 0;

    // Determine the index of the plural form.
    if (typeof drupalTranslations !== 'undefined' && drupalTranslations.pluralFormula) {
      index = count in drupalTranslations.pluralFormula ? drupalTranslations.pluralFormula[count] : drupalTranslations.pluralFormula['default'];
    }
    else if (args['@count'] !== 1) {
      index = 1;
    }

    return translations[index];
  };

  /**
   * Encodes a Drupal path for use in a URL.
   *
   * For aesthetic reasons slashes are not escaped.
   *
   * @param {string} item
   *   Unencoded path.
   *
   * @return {string}
   *   The encoded path.
   */
  Drupal.encodePath = function (item) {
    return window.encodeURIComponent(item).replace(/%2F/g, '/');
  };

  /**
   * Generates the themed representation of a Drupal object.
   *
   * All requests for themed output must go through this function. It examines
   * the request and routes it to the appropriate theme function. If the current
   * theme does not provide an override function, the generic theme function is
   * called.
   *
   * @example
   * <caption>To retrieve the HTML for text that should be emphasized and
   * displayed as a placeholder inside a sentence.</caption>
   * Drupal.theme('placeholder', text);
   *
   * @namespace
   *
   * @param {function} func
   *   The name of the theme function to call.
   * @param {...args}
   *   Additional arguments to pass along to the theme function.
   *
   * @return {string|object|HTMLElement|jQuery}
   *   Any data the theme function returns. This could be a plain HTML string,
   *   but also a complex object.
   */
  Drupal.theme = function (func) {
    var args = Array.prototype.slice.apply(arguments, [1]);
    if (func in Drupal.theme) {
      return Drupal.theme[func].apply(this, args);
    }
  };

  /**
   * Formats text for emphasized display in a placeholder inside a sentence.
   *
   * @param {string} str
   *   The text to format (plain-text).
   *
   * @return {string}
   *   The formatted text (html).
   */
  Drupal.theme.placeholder = function (str) {
    return '<em class="placeholder">' + Drupal.checkPlain(str) + '</em>';
  };

})(domready, Drupal, window.drupalSettings, window.drupalTranslations);
;
!function(t,a,e){"use strict";a.extlink=a.extlink||{},a.extlink.attach=function(e,n){if(n.data.hasOwnProperty("extlink")){var l,i=/^(([^\/:]+?\.)*)([^\.:]{4,})((\.[a-z]{1,4})*)(:[0-9]{1,5})?$/,s=window.location.host.replace(i,"$3$4"),x=window.location.host.replace(i,"$1");l=n.data.extlink.extSubdomains?"([^/]*\\.)?":"www."===x||""===x?"(www\\.)?":x.replace(".","\\.");var p=new RegExp("^https?://"+l+s,"i"),d=!1;n.data.extlink.extInclude&&(d=new RegExp(n.data.extlink.extInclude.replace(/\\/,"\\"),"i"));var r=!1;n.data.extlink.extExclude&&(r=new RegExp(n.data.extlink.extExclude.replace(/\\/,"\\"),"i"));var k=!1;n.data.extlink.extCssExclude&&(k=n.data.extlink.extCssExclude);var c=!1;n.data.extlink.extCssExplicit&&(c=n.data.extlink.extCssExplicit);var o=[],h=[];t("a:not(."+n.data.extlink.extClass+", ."+n.data.extlink.mailtoClass+"), area:not(."+n.data.extlink.extClass+", ."+n.data.extlink.mailtoClass+")",e).each(function(a){try{var e=this.href.toLowerCase();0!==e.indexOf("http")||(e.match(p)||r&&e.match(r))&&(!d||!e.match(d))||k&&t(this).parents(k).length>0||c&&t(this).parents(c).length<1?"AREA"===this.tagName||0!==e.indexOf("mailto:")||k&&t(this).parents(k).length>0||c&&t(this).parents(c).length<1||h.push(this):o.push(this)}catch(n){return!1}}),n.data.extlink.extClass&&a.extlink.applyClassAndSpan(o,n.data.extlink.extClass),n.data.extlink.mailtoClass&&a.extlink.applyClassAndSpan(h,n.data.extlink.mailtoClass),n.data.extlink.extTarget&&n.data.extlink.extTarget&&t(o).attr("target","_blank"),a.extlink=a.extlink||{},a.extlink.popupClickHandler=a.extlink.popupClickHandler||function(){return n.data.extlink.extAlert?confirm(n.data.extlink.extAlertText):void 0},t(o).click(function(t){return a.extlink.popupClickHandler(t)})}},a.extlink.applyClassAndSpan=function(a,n){var l;if(e.data.extlink.extImgClass)l=t(a);else{var i=t(a).find("img").parents("a");l=t(a).not(i)}l.addClass(n);var s,x=l.length;for(s=0;x>s;s++){var p=t(l[s]);("inline"===p.css("display")||"inline-block"===p.css("display"))&&(n===e.data.extlink.mailtoClass?p.append('<span class="'+n+'"><span class="element-invisible"> '+e.data.extlink.mailtoLabel+"</span></span>"):p.append('<span class="'+n+'"><span class="element-invisible"> '+e.data.extlink.extLabel+"</span></span>"))}},a.behaviors.extlink=a.behaviors.extlink||{},a.behaviors.extlink.attach=function(t,e){"function"==typeof extlinkAttach?extlinkAttach(t):a.extlink.attach(t,e)}}(jQuery,Drupal,drupalSettings);
;
/*!
 * jQuery Form Plugin
 * version: 3.51.0-2014.06.20
 * Requires jQuery v1.5 or later
 * Copyright (c) 2014 M. Alsup
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Project repository: https://github.com/malsup/form
 * Dual licensed under the MIT and GPL licenses.
 * https://github.com/malsup/form#copyright-and-license
 */
!function(e){"use strict";"function"==typeof define&&define.amd?define(["jquery"],e):e("undefined"!=typeof jQuery?jQuery:window.Zepto)}(function(e){"use strict";function t(t){var r=t.data;t.isDefaultPrevented()||(t.preventDefault(),e(t.target).ajaxSubmit(r))}function r(t){var r=t.target,a=e(r);if(!a.is("[type=submit],[type=image]")){var n=a.closest("[type=submit]");if(0===n.length)return;r=n[0]}var i=this;if(i.clk=r,"image"==r.type)if(void 0!==t.offsetX)i.clk_x=t.offsetX,i.clk_y=t.offsetY;else if("function"==typeof e.fn.offset){var o=a.offset();i.clk_x=t.pageX-o.left,i.clk_y=t.pageY-o.top}else i.clk_x=t.pageX-r.offsetLeft,i.clk_y=t.pageY-r.offsetTop;setTimeout(function(){i.clk=i.clk_x=i.clk_y=null},100)}function a(){if(e.fn.ajaxSubmit.debug){var t="[jquery.form] "+Array.prototype.join.call(arguments,"");window.console&&window.console.log?window.console.log(t):window.opera&&window.opera.postError&&window.opera.postError(t)}}var n={};n.fileapi=void 0!==e("<input type='file'/>").get(0).files,n.formdata=void 0!==window.FormData;var i=!!e.fn.prop;e.fn.attr2=function(){if(!i)return this.attr.apply(this,arguments);var e=this.prop.apply(this,arguments);return e&&e.jquery||"string"==typeof e?e:this.attr.apply(this,arguments)},e.fn.ajaxSubmit=function(t){function r(r){var a,n,i=e.param(r,t.traditional).split("&"),o=i.length,s=[];for(a=0;o>a;a++)i[a]=i[a].replace(/\+/g," "),n=i[a].split("="),s.push([decodeURIComponent(n[0]),decodeURIComponent(n[1])]);return s}function o(a){for(var n=new FormData,i=0;i<a.length;i++)n.append(a[i].name,a[i].value);if(t.extraData){var o=r(t.extraData);for(i=0;i<o.length;i++)o[i]&&n.append(o[i][0],o[i][1])}t.data=null;var s=e.extend(!0,{},e.ajaxSettings,t,{contentType:!1,processData:!1,cache:!1,type:u||"POST"});t.uploadProgress&&(s.xhr=function(){var r=e.ajaxSettings.xhr();return r.upload&&r.upload.addEventListener("progress",function(e){var r=0,a=e.loaded||e.position,n=e.total;e.lengthComputable&&(r=Math.ceil(a/n*100)),t.uploadProgress(e,a,n,r)},!1),r}),s.data=null;var c=s.beforeSend;return s.beforeSend=function(e,r){r.data=t.formData?t.formData:n,c&&c.call(this,e,r)},e.ajax(s)}function s(r){function n(e){var t=null;try{e.contentWindow&&(t=e.contentWindow.document)}catch(r){a("cannot get iframe.contentWindow document: "+r)}if(t)return t;try{t=e.contentDocument?e.contentDocument:e.document}catch(r){a("cannot get iframe.contentDocument: "+r),t=e.document}return t}function o(){function t(){try{var e=n(g).readyState;a("state = "+e),e&&"uninitialized"==e.toLowerCase()&&setTimeout(t,50)}catch(r){a("Server abort: ",r," (",r.name,")"),s(k),j&&clearTimeout(j),j=void 0}}var r=f.attr2("target"),i=f.attr2("action"),o="multipart/form-data",c=f.attr("enctype")||f.attr("encoding")||o;w.setAttribute("target",p),(!u||/post/i.test(u))&&w.setAttribute("method","POST"),i!=m.url&&w.setAttribute("action",m.url),m.skipEncodingOverride||u&&!/post/i.test(u)||f.attr({encoding:"multipart/form-data",enctype:"multipart/form-data"}),m.timeout&&(j=setTimeout(function(){T=!0,s(D)},m.timeout));var l=[];try{if(m.extraData)for(var d in m.extraData)m.extraData.hasOwnProperty(d)&&l.push(e.isPlainObject(m.extraData[d])&&m.extraData[d].hasOwnProperty("name")&&m.extraData[d].hasOwnProperty("value")?e('<input type="hidden" name="'+m.extraData[d].name+'">').val(m.extraData[d].value).appendTo(w)[0]:e('<input type="hidden" name="'+d+'">').val(m.extraData[d]).appendTo(w)[0]);m.iframeTarget||v.appendTo("body"),g.attachEvent?g.attachEvent("onload",s):g.addEventListener("load",s,!1),setTimeout(t,15);try{w.submit()}catch(h){var x=document.createElement("form").submit;x.apply(w)}}finally{w.setAttribute("action",i),w.setAttribute("enctype",c),r?w.setAttribute("target",r):f.removeAttr("target"),e(l).remove()}}function s(t){if(!x.aborted&&!F){if(M=n(g),M||(a("cannot access response document"),t=k),t===D&&x)return x.abort("timeout"),void S.reject(x,"timeout");if(t==k&&x)return x.abort("server abort"),void S.reject(x,"error","server abort");if(M&&M.location.href!=m.iframeSrc||T){g.detachEvent?g.detachEvent("onload",s):g.removeEventListener("load",s,!1);var r,i="success";try{if(T)throw"timeout";var o="xml"==m.dataType||M.XMLDocument||e.isXMLDoc(M);if(a("isXml="+o),!o&&window.opera&&(null===M.body||!M.body.innerHTML)&&--O)return a("requeing onLoad callback, DOM not available"),void setTimeout(s,250);var u=M.body?M.body:M.documentElement;x.responseText=u?u.innerHTML:null,x.responseXML=M.XMLDocument?M.XMLDocument:M,o&&(m.dataType="xml"),x.getResponseHeader=function(e){var t={"content-type":m.dataType};return t[e.toLowerCase()]},u&&(x.status=Number(u.getAttribute("status"))||x.status,x.statusText=u.getAttribute("statusText")||x.statusText);var c=(m.dataType||"").toLowerCase(),l=/(json|script|text)/.test(c);if(l||m.textarea){var f=M.getElementsByTagName("textarea")[0];if(f)x.responseText=f.value,x.status=Number(f.getAttribute("status"))||x.status,x.statusText=f.getAttribute("statusText")||x.statusText;else if(l){var p=M.getElementsByTagName("pre")[0],h=M.getElementsByTagName("body")[0];p?x.responseText=p.textContent?p.textContent:p.innerText:h&&(x.responseText=h.textContent?h.textContent:h.innerText)}}else"xml"==c&&!x.responseXML&&x.responseText&&(x.responseXML=X(x.responseText));try{E=_(x,c,m)}catch(y){i="parsererror",x.error=r=y||i}}catch(y){a("error caught: ",y),i="error",x.error=r=y||i}x.aborted&&(a("upload aborted"),i=null),x.status&&(i=x.status>=200&&x.status<300||304===x.status?"success":"error"),"success"===i?(m.success&&m.success.call(m.context,E,"success",x),S.resolve(x.responseText,"success",x),d&&e.event.trigger("ajaxSuccess",[x,m])):i&&(void 0===r&&(r=x.statusText),m.error&&m.error.call(m.context,x,i,r),S.reject(x,"error",r),d&&e.event.trigger("ajaxError",[x,m,r])),d&&e.event.trigger("ajaxComplete",[x,m]),d&&!--e.active&&e.event.trigger("ajaxStop"),m.complete&&m.complete.call(m.context,x,i),F=!0,m.timeout&&clearTimeout(j),setTimeout(function(){m.iframeTarget?v.attr("src",m.iframeSrc):v.remove(),x.responseXML=null},100)}}}var c,l,m,d,p,v,g,x,y,b,T,j,w=f[0],S=e.Deferred();if(S.abort=function(e){x.abort(e)},r)for(l=0;l<h.length;l++)c=e(h[l]),i?c.prop("disabled",!1):c.removeAttr("disabled");if(m=e.extend(!0,{},e.ajaxSettings,t),m.context=m.context||m,p="jqFormIO"+(new Date).getTime(),m.iframeTarget?(v=e(m.iframeTarget),b=v.attr2("name"),b?p=b:v.attr2("name",p)):(v=e('<iframe name="'+p+'" src="'+m.iframeSrc+'" />'),v.css({position:"absolute",top:"-1000px",left:"-1000px"})),g=v[0],x={aborted:0,responseText:null,responseXML:null,status:0,statusText:"n/a",getAllResponseHeaders:function(){},getResponseHeader:function(){},setRequestHeader:function(){},abort:function(t){var r="timeout"===t?"timeout":"aborted";a("aborting upload... "+r),this.aborted=1;try{g.contentWindow.document.execCommand&&g.contentWindow.document.execCommand("Stop")}catch(n){}v.attr("src",m.iframeSrc),x.error=r,m.error&&m.error.call(m.context,x,r,t),d&&e.event.trigger("ajaxError",[x,m,r]),m.complete&&m.complete.call(m.context,x,r)}},d=m.global,d&&0===e.active++&&e.event.trigger("ajaxStart"),d&&e.event.trigger("ajaxSend",[x,m]),m.beforeSend&&m.beforeSend.call(m.context,x,m)===!1)return m.global&&e.active--,S.reject(),S;if(x.aborted)return S.reject(),S;y=w.clk,y&&(b=y.name,b&&!y.disabled&&(m.extraData=m.extraData||{},m.extraData[b]=y.value,"image"==y.type&&(m.extraData[b+".x"]=w.clk_x,m.extraData[b+".y"]=w.clk_y)));var D=1,k=2,A=e("meta[name=csrf-token]").attr("content"),L=e("meta[name=csrf-param]").attr("content");L&&A&&(m.extraData=m.extraData||{},m.extraData[L]=A),m.forceSync?o():setTimeout(o,10);var E,M,F,O=50,X=e.parseXML||function(e,t){return window.ActiveXObject?(t=new ActiveXObject("Microsoft.XMLDOM"),t.async="false",t.loadXML(e)):t=(new DOMParser).parseFromString(e,"text/xml"),t&&t.documentElement&&"parsererror"!=t.documentElement.nodeName?t:null},C=e.parseJSON||function(e){return window.eval("("+e+")")},_=function(t,r,a){var n=t.getResponseHeader("content-type")||"",i="xml"===r||!r&&n.indexOf("xml")>=0,o=i?t.responseXML:t.responseText;return i&&"parsererror"===o.documentElement.nodeName&&e.error&&e.error("parsererror"),a&&a.dataFilter&&(o=a.dataFilter(o,r)),"string"==typeof o&&("json"===r||!r&&n.indexOf("json")>=0?o=C(o):("script"===r||!r&&n.indexOf("javascript")>=0)&&e.globalEval(o)),o};return S}if(!this.length)return a("ajaxSubmit: skipping submit process - no element selected"),this;var u,c,l,f=this;"function"==typeof t?t={success:t}:void 0===t&&(t={}),u=t.type||this.attr2("method"),c=t.url||this.attr2("action"),l="string"==typeof c?e.trim(c):"",l=l||window.location.href||"",l&&(l=(l.match(/^([^#]+)/)||[])[1]),t=e.extend(!0,{url:l,success:e.ajaxSettings.success,type:u||e.ajaxSettings.type,iframeSrc:/^https/i.test(window.location.href||"")?"javascript:false":"about:blank"},t);var m={};if(this.trigger("form-pre-serialize",[this,t,m]),m.veto)return a("ajaxSubmit: submit vetoed via form-pre-serialize trigger"),this;if(t.beforeSerialize&&t.beforeSerialize(this,t)===!1)return a("ajaxSubmit: submit aborted via beforeSerialize callback"),this;var d=t.traditional;void 0===d&&(d=e.ajaxSettings.traditional);var p,h=[],v=this.formToArray(t.semantic,h);if(t.data&&(t.extraData=t.data,p=e.param(t.data,d)),t.beforeSubmit&&t.beforeSubmit(v,this,t)===!1)return a("ajaxSubmit: submit aborted via beforeSubmit callback"),this;if(this.trigger("form-submit-validate",[v,this,t,m]),m.veto)return a("ajaxSubmit: submit vetoed via form-submit-validate trigger"),this;var g=e.param(v,d);p&&(g=g?g+"&"+p:p),"GET"==t.type.toUpperCase()?(t.url+=(t.url.indexOf("?")>=0?"&":"?")+g,t.data=null):t.data=g;var x=[];if(t.resetForm&&x.push(function(){f.resetForm()}),t.clearForm&&x.push(function(){f.clearForm(t.includeHidden)}),!t.dataType&&t.target){var y=t.success||function(){};x.push(function(r){var a=t.replaceTarget?"replaceWith":"html";e(t.target)[a](r).each(y,arguments)})}else t.success&&x.push(t.success);if(t.success=function(e,r,a){for(var n=t.context||this,i=0,o=x.length;o>i;i++)x[i].apply(n,[e,r,a||f,f])},t.error){var b=t.error;t.error=function(e,r,a){var n=t.context||this;b.apply(n,[e,r,a,f])}}if(t.complete){var T=t.complete;t.complete=function(e,r){var a=t.context||this;T.apply(a,[e,r,f])}}var j=e("input[type=file]:enabled",this).filter(function(){return""!==e(this).val()}),w=j.length>0,S="multipart/form-data",D=f.attr("enctype")==S||f.attr("encoding")==S,k=n.fileapi&&n.formdata;a("fileAPI :"+k);var A,L=(w||D)&&!k;t.iframe!==!1&&(t.iframe||L)?t.closeKeepAlive?e.get(t.closeKeepAlive,function(){A=s(v)}):A=s(v):A=(w||D)&&k?o(v):e.ajax(t),f.removeData("jqxhr").data("jqxhr",A);for(var E=0;E<h.length;E++)h[E]=null;return this.trigger("form-submit-notify",[this,t]),this},e.fn.ajaxForm=function(n){if(n=n||{},n.delegation=n.delegation&&e.isFunction(e.fn.on),!n.delegation&&0===this.length){var i={s:this.selector,c:this.context};return!e.isReady&&i.s?(a("DOM not ready, queuing ajaxForm"),e(function(){e(i.s,i.c).ajaxForm(n)}),this):(a("terminating; zero elements found by selector"+(e.isReady?"":" (DOM not ready)")),this)}return n.delegation?(e(document).off("submit.form-plugin",this.selector,t).off("click.form-plugin",this.selector,r).on("submit.form-plugin",this.selector,n,t).on("click.form-plugin",this.selector,n,r),this):this.ajaxFormUnbind().bind("submit.form-plugin",n,t).bind("click.form-plugin",n,r)},e.fn.ajaxFormUnbind=function(){return this.unbind("submit.form-plugin click.form-plugin")},e.fn.formToArray=function(t,r){var a=[];if(0===this.length)return a;var i,o=this[0],s=this.attr("id"),u=t?o.getElementsByTagName("*"):o.elements;if(u&&!/MSIE [678]/.test(navigator.userAgent)&&(u=e(u).get()),s&&(i=e(':input[form="'+s+'"]').get(),i.length&&(u=(u||[]).concat(i))),!u||!u.length)return a;var c,l,f,m,d,p,h;for(c=0,p=u.length;p>c;c++)if(d=u[c],f=d.name,f&&!d.disabled)if(t&&o.clk&&"image"==d.type)o.clk==d&&(a.push({name:f,value:e(d).val(),type:d.type}),a.push({name:f+".x",value:o.clk_x},{name:f+".y",value:o.clk_y}));else if(m=e.fieldValue(d,!0),m&&m.constructor==Array)for(r&&r.push(d),l=0,h=m.length;h>l;l++)a.push({name:f,value:m[l]});else if(n.fileapi&&"file"==d.type){r&&r.push(d);var v=d.files;if(v.length)for(l=0;l<v.length;l++)a.push({name:f,value:v[l],type:d.type});else a.push({name:f,value:"",type:d.type})}else null!==m&&"undefined"!=typeof m&&(r&&r.push(d),a.push({name:f,value:m,type:d.type,required:d.required}));if(!t&&o.clk){var g=e(o.clk),x=g[0];f=x.name,f&&!x.disabled&&"image"==x.type&&(a.push({name:f,value:g.val()}),a.push({name:f+".x",value:o.clk_x},{name:f+".y",value:o.clk_y}))}return a},e.fn.formSerialize=function(t){return e.param(this.formToArray(t))},e.fn.fieldSerialize=function(t){var r=[];return this.each(function(){var a=this.name;if(a){var n=e.fieldValue(this,t);if(n&&n.constructor==Array)for(var i=0,o=n.length;o>i;i++)r.push({name:a,value:n[i]});else null!==n&&"undefined"!=typeof n&&r.push({name:this.name,value:n})}}),e.param(r)},e.fn.fieldValue=function(t){for(var r=[],a=0,n=this.length;n>a;a++){var i=this[a],o=e.fieldValue(i,t);null===o||"undefined"==typeof o||o.constructor==Array&&!o.length||(o.constructor==Array?e.merge(r,o):r.push(o))}return r},e.fieldValue=function(t,r){var a=t.name,n=t.type,i=t.tagName.toLowerCase();if(void 0===r&&(r=!0),r&&(!a||t.disabled||"reset"==n||"button"==n||("checkbox"==n||"radio"==n)&&!t.checked||("submit"==n||"image"==n)&&t.form&&t.form.clk!=t||"select"==i&&-1==t.selectedIndex))return null;if("select"==i){var o=t.selectedIndex;if(0>o)return null;for(var s=[],u=t.options,c="select-one"==n,l=c?o+1:u.length,f=c?o:0;l>f;f++){var m=u[f];if(m.selected){var d=m.value;if(d||(d=m.attributes&&m.attributes.value&&!m.attributes.value.specified?m.text:m.value),c)return d;s.push(d)}}return s}return e(t).val()},e.fn.clearForm=function(t){return this.each(function(){e("input,select,textarea",this).clearFields(t)})},e.fn.clearFields=e.fn.clearInputs=function(t){var r=/^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i;return this.each(function(){var a=this.type,n=this.tagName.toLowerCase();r.test(a)||"textarea"==n?this.value="":"checkbox"==a||"radio"==a?this.checked=!1:"select"==n?this.selectedIndex=-1:"file"==a?/MSIE/.test(navigator.userAgent)?e(this).replaceWith(e(this).clone(!0)):e(this).val(""):t&&(t===!0&&/hidden/.test(a)||"string"==typeof t&&e(this).is(t))&&(this.value="")})},e.fn.resetForm=function(){return this.each(function(){("function"==typeof this.reset||"object"==typeof this.reset&&!this.reset.nodeType)&&this.reset()})},e.fn.enable=function(e){return void 0===e&&(e=!0),this.each(function(){this.disabled=!e})},e.fn.selected=function(t){return void 0===t&&(t=!0),this.each(function(){var r=this.type;if("checkbox"==r||"radio"==r)this.checked=t;else if("option"==this.tagName.toLowerCase()){var a=e(this).parent("select");t&&a[0]&&"select-one"==a[0].type&&a.find("option").selected(!1),this.selected=t}})},e.fn.ajaxSubmit.debug=!1});
;
/*!
 * jQuery UI Position 1.11.4
 * http://jqueryui.com
 *
 * Copyright jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/position/
 */(function(e){typeof define=="function"&&define.amd?define(["jquery"],e):e(jQuery)})(function(e){return function(){function h(e,t,n){return[parseFloat(e[0])*(l.test(e[0])?t/100:1),parseFloat(e[1])*(l.test(e[1])?n/100:1)]}function p(t,n){return parseInt(e.css(t,n),10)||0}function d(t){var n=t[0];return n.nodeType===9?{width:t.width(),height:t.height(),offset:{top:0,left:0}}:e.isWindow(n)?{width:t.width(),height:t.height(),offset:{top:t.scrollTop(),left:t.scrollLeft()}}:n.preventDefault?{width:0,height:0,offset:{top:n.pageY,left:n.pageX}}:{width:t.outerWidth(),height:t.outerHeight(),offset:t.offset()}}e.ui=e.ui||{};var t,n,r=Math.max,i=Math.abs,s=Math.round,o=/left|center|right/,u=/top|center|bottom/,a=/[\+\-]\d+(\.[\d]+)?%?/,f=/^\w+/,l=/%$/,c=e.fn.position;e.position={scrollbarWidth:function(){if(t!==undefined)return t;var n,r,i=e("<div style='display:block;position:absolute;width:50px;height:50px;overflow:hidden;'><div style='height:100px;width:auto;'></div></div>"),s=i.children()[0];return e("body").append(i),n=s.offsetWidth,i.css("overflow","scroll"),r=s.offsetWidth,n===r&&(r=i[0].clientWidth),i.remove(),t=n-r},getScrollInfo:function(t){var n=t.isWindow||t.isDocument?"":t.element.css("overflow-x"),r=t.isWindow||t.isDocument?"":t.element.css("overflow-y"),i=n==="scroll"||n==="auto"&&t.width<t.element[0].scrollWidth,s=r==="scroll"||r==="auto"&&t.height<t.element[0].scrollHeight;return{width:s?e.position.scrollbarWidth():0,height:i?e.position.scrollbarWidth():0}},getWithinInfo:function(t){var n=e(t||window),r=e.isWindow(n[0]),i=!!n[0]&&n[0].nodeType===9;return{element:n,isWindow:r,isDocument:i,offset:n.offset()||{left:0,top:0},scrollLeft:n.scrollLeft(),scrollTop:n.scrollTop(),width:r||i?n.width():n.outerWidth(),height:r||i?n.height():n.outerHeight()}}},e.fn.position=function(t){if(!t||!t.of)return c.apply(this,arguments);t=e.extend({},t);var l,v,m,g,y,b,w=e(t.of),E=e.position.getWithinInfo(t.within),S=e.position.getScrollInfo(E),x=(t.collision||"flip").split(" "),T={};return b=d(w),w[0].preventDefault&&(t.at="left top"),v=b.width,m=b.height,g=b.offset,y=e.extend({},g),e.each(["my","at"],function(){var e=(t[this]||"").split(" "),n,r;e.length===1&&(e=o.test(e[0])?e.concat(["center"]):u.test(e[0])?["center"].concat(e):["center","center"]),e[0]=o.test(e[0])?e[0]:"center",e[1]=u.test(e[1])?e[1]:"center",n=a.exec(e[0]),r=a.exec(e[1]),T[this]=[n?n[0]:0,r?r[0]:0],t[this]=[f.exec(e[0])[0],f.exec(e[1])[0]]}),x.length===1&&(x[1]=x[0]),t.at[0]==="right"?y.left+=v:t.at[0]==="center"&&(y.left+=v/2),t.at[1]==="bottom"?y.top+=m:t.at[1]==="center"&&(y.top+=m/2),l=h(T.at,v,m),y.left+=l[0],y.top+=l[1],this.each(function(){var o,u,a=e(this),f=a.outerWidth(),c=a.outerHeight(),d=p(this,"marginLeft"),b=p(this,"marginTop"),N=f+d+p(this,"marginRight")+S.width,C=c+b+p(this,"marginBottom")+S.height,k=e.extend({},y),L=h(T.my,a.outerWidth(),a.outerHeight());t.my[0]==="right"?k.left-=f:t.my[0]==="center"&&(k.left-=f/2),t.my[1]==="bottom"?k.top-=c:t.my[1]==="center"&&(k.top-=c/2),k.left+=L[0],k.top+=L[1],n||(k.left=s(k.left),k.top=s(k.top)),o={marginLeft:d,marginTop:b},e.each(["left","top"],function(n,r){e.ui.position[x[n]]&&e.ui.position[x[n]][r](k,{targetWidth:v,targetHeight:m,elemWidth:f,elemHeight:c,collisionPosition:o,collisionWidth:N,collisionHeight:C,offset:[l[0]+L[0],l[1]+L[1]],my:t.my,at:t.at,within:E,elem:a})}),t.using&&(u=function(e){var n=g.left-k.left,s=n+v-f,o=g.top-k.top,u=o+m-c,l={target:{element:w,left:g.left,top:g.top,width:v,height:m},element:{element:a,left:k.left,top:k.top,width:f,height:c},horizontal:s<0?"left":n>0?"right":"center",vertical:u<0?"top":o>0?"bottom":"middle"};v<f&&i(n+s)<v&&(l.horizontal="center"),m<c&&i(o+u)<m&&(l.vertical="middle"),r(i(n),i(s))>r(i(o),i(u))?l.important="horizontal":l.important="vertical",t.using.call(this,e,l)}),a.offset(e.extend(k,{using:u}))})},e.ui.position={fit:{left:function(e,t){var n=t.within,i=n.isWindow?n.scrollLeft:n.offset.left,s=n.width,o=e.left-t.collisionPosition.marginLeft,u=i-o,a=o+t.collisionWidth-s-i,f;t.collisionWidth>s?u>0&&a<=0?(f=e.left+u+t.collisionWidth-s-i,e.left+=u-f):a>0&&u<=0?e.left=i:u>a?e.left=i+s-t.collisionWidth:e.left=i:u>0?e.left+=u:a>0?e.left-=a:e.left=r(e.left-o,e.left)},top:function(e,t){var n=t.within,i=n.isWindow?n.scrollTop:n.offset.top,s=t.within.height,o=e.top-t.collisionPosition.marginTop,u=i-o,a=o+t.collisionHeight-s-i,f;t.collisionHeight>s?u>0&&a<=0?(f=e.top+u+t.collisionHeight-s-i,e.top+=u-f):a>0&&u<=0?e.top=i:u>a?e.top=i+s-t.collisionHeight:e.top=i:u>0?e.top+=u:a>0?e.top-=a:e.top=r(e.top-o,e.top)}},flip:{left:function(e,t){var n=t.within,r=n.offset.left+n.scrollLeft,s=n.width,o=n.isWindow?n.scrollLeft:n.offset.left,u=e.left-t.collisionPosition.marginLeft,a=u-o,f=u+t.collisionWidth-s-o,l=t.my[0]==="left"?-t.elemWidth:t.my[0]==="right"?t.elemWidth:0,c=t.at[0]==="left"?t.targetWidth:t.at[0]==="right"?-t.targetWidth:0,h=-2*t.offset[0],p,d;if(a<0){p=e.left+l+c+h+t.collisionWidth-s-r;if(p<0||p<i(a))e.left+=l+c+h}else if(f>0){d=e.left-t.collisionPosition.marginLeft+l+c+h-o;if(d>0||i(d)<f)e.left+=l+c+h}},top:function(e,t){var n=t.within,r=n.offset.top+n.scrollTop,s=n.height,o=n.isWindow?n.scrollTop:n.offset.top,u=e.top-t.collisionPosition.marginTop,a=u-o,f=u+t.collisionHeight-s-o,l=t.my[1]==="top",c=l?-t.elemHeight:t.my[1]==="bottom"?t.elemHeight:0,h=t.at[1]==="top"?t.targetHeight:t.at[1]==="bottom"?-t.targetHeight:0,p=-2*t.offset[1],d,v;if(a<0){v=e.top+c+h+p+t.collisionHeight-s-r;if(v<0||v<i(a))e.top+=c+h+p}else if(f>0){d=e.top-t.collisionPosition.marginTop+c+h+p-o;if(d>0||i(d)<f)e.top+=c+h+p}}},flipfit:{left:function(){e.ui.position.flip.left.apply(this,arguments),e.ui.position.fit.left.apply(this,arguments)},top:function(){e.ui.position.flip.top.apply(this,arguments),e.ui.position.fit.top.apply(this,arguments)}}},function(){var t,r,i,s,o,u=document.getElementsByTagName("body")[0],a=document.createElement("div");t=document.createElement(u?"div":"body"),i={visibility:"hidden",width:0,height:0,border:0,margin:0,background:"none"},u&&e.extend(i,{position:"absolute",left:"-1000px",top:"-1000px"});for(o in i)t.style[o]=i[o];t.appendChild(a),r=u||document.documentElement,r.insertBefore(t,r.firstChild),a.style.cssText="position: absolute; left: 10.7432222px;",s=e(a).offset().left,n=s>10&&s<11,t.innerHTML="",r.removeChild(t)}()}(),e.ui.position});;
/**
 * @file
 * Adapted from underscore.js with the addition Drupal namespace.
 */

/**
 * Limits the invocations of a function in a given time frame.
 *
 * The debounce function wrapper should be used sparingly. One clear use case
 * is limiting the invocation of a callback attached to the window resize event.
 *
 * Before using the debounce function wrapper, consider first whether the
 * callback could be attached to an event that fires less frequently or if the
 * function can be written in such a way that it is only invoked under specific
 * conditions.
 *
 * @param {function} func
 *   The function to be invoked.
 * @param {number} wait
 *   The time period within which the callback function should only be
 *   invoked once. For example if the wait period is 250ms, then the callback
 *   will only be called at most 4 times per second.
 * @param {bool} immediate
 *   Whether we wait at the beginning or end to execute the function.
 *
 * @return {function}
 *   The debounced function.
 */
Drupal.debounce = function (func, wait, immediate) {

  'use strict';

  var timeout;
  var result;
  return function () {
    var context = this;
    var args = arguments;
    var later = function () {
      timeout = null;
      if (!immediate) {
        result = func.apply(context, args);
      }
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) {
      result = func.apply(context, args);
    }
    return result;
  };
};
;
/**
 * @file
 * Manages elements that can offset the size of the viewport.
 *
 * Measures and reports viewport offset dimensions from elements like the
 * toolbar that can potentially displace the positioning of other elements.
 */

/**
 * @typedef {object} Drupal~displaceOffset
 *
 * @prop {number} top
 * @prop {number} left
 * @prop {number} right
 * @prop {number} bottom
 */

/**
 * Triggers when layout of the page changes.
 *
 * This is used to position fixed element on the page during page resize and
 * Toolbar toggling.
 *
 * @event drupalViewportOffsetChange
 */

(function ($, Drupal, debounce) {

  'use strict';

  /**
   * @name Drupal.displace.offsets
   *
   * @type {Drupal~displaceOffset}
   */
  var offsets = {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0
  };

  /**
   * Registers a resize handler on the window.
   *
   * @type {Drupal~behavior}
   */
  Drupal.behaviors.drupalDisplace = {
    attach: function () {
      // Mark this behavior as processed on the first pass.
      if (this.displaceProcessed) {
        return;
      }
      this.displaceProcessed = true;

      $(window).on('resize.drupalDisplace', debounce(displace, 200));
    }
  };

  /**
   * Informs listeners of the current offset dimensions.
   *
   * @function Drupal.displace
   *
   * @prop {Drupal~displaceOffset} offsets
   *
   * @param {bool} [broadcast]
   *   When true or undefined, causes the recalculated offsets values to be
   *   broadcast to listeners.
   *
   * @return {Drupal~displaceOffset}
   *   An object whose keys are the for sides an element -- top, right, bottom
   *   and left. The value of each key is the viewport displacement distance for
   *   that edge.
   *
   * @fires event:drupalViewportOffsetChange
   */
  function displace(broadcast) {
    offsets = Drupal.displace.offsets = calculateOffsets();
    if (typeof broadcast === 'undefined' || broadcast) {
      $(document).trigger('drupalViewportOffsetChange', offsets);
    }
    return offsets;
  }

  /**
   * Determines the viewport offsets.
   *
   * @return {Drupal~displaceOffset}
   *   An object whose keys are the for sides an element -- top, right, bottom
   *   and left. The value of each key is the viewport displacement distance for
   *   that edge.
   */
  function calculateOffsets() {
    return {
      top: calculateOffset('top'),
      right: calculateOffset('right'),
      bottom: calculateOffset('bottom'),
      left: calculateOffset('left')
    };
  }

  /**
   * Gets a specific edge's offset.
   *
   * Any element with the attribute data-offset-{edge} e.g. data-offset-top will
   * be considered in the viewport offset calculations. If the attribute has a
   * numeric value, that value will be used. If no value is provided, one will
   * be calculated using the element's dimensions and placement.
   *
   * @function Drupal.displace.calculateOffset
   *
   * @param {string} edge
   *   The name of the edge to calculate. Can be 'top', 'right',
   *   'bottom' or 'left'.
   *
   * @return {number}
   *   The viewport displacement distance for the requested edge.
   */
  function calculateOffset(edge) {
    var edgeOffset = 0;
    var displacingElements = document.querySelectorAll('[data-offset-' + edge + ']');
    var n = displacingElements.length;
    for (var i = 0; i < n; i++) {
      var el = displacingElements[i];
      // If the element is not visible, do consider its dimensions.
      if (el.style.display === 'none') {
        continue;
      }
      // If the offset data attribute contains a displacing value, use it.
      var displacement = parseInt(el.getAttribute('data-offset-' + edge), 10);
      // If the element's offset data attribute exits
      // but is not a valid number then get the displacement
      // dimensions directly from the element.
      if (isNaN(displacement)) {
        displacement = getRawOffset(el, edge);
      }
      // If the displacement value is larger than the current value for this
      // edge, use the displacement value.
      edgeOffset = Math.max(edgeOffset, displacement);
    }

    return edgeOffset;
  }

  /**
   * Calculates displacement for element based on its dimensions and placement.
   *
   * @param {HTMLElement} el
   *   The jQuery element whose dimensions and placement will be measured.
   *
   * @param {string} edge
   *   The name of the edge of the viewport that the element is associated
   *   with.
   *
   * @return {number}
   *   The viewport displacement distance for the requested edge.
   */
  function getRawOffset(el, edge) {
    var $el = $(el);
    var documentElement = document.documentElement;
    var displacement = 0;
    var horizontal = (edge === 'left' || edge === 'right');
    // Get the offset of the element itself.
    var placement = $el.offset()[horizontal ? 'left' : 'top'];
    // Subtract scroll distance from placement to get the distance
    // to the edge of the viewport.
    placement -= window['scroll' + (horizontal ? 'X' : 'Y')] || document.documentElement['scroll' + (horizontal) ? 'Left' : 'Top'] || 0;
    // Find the displacement value according to the edge.
    switch (edge) {
      // Left and top elements displace as a sum of their own offset value
      // plus their size.
      case 'top':
        // Total displacement is the sum of the elements placement and size.
        displacement = placement + $el.outerHeight();
        break;

      case 'left':
        // Total displacement is the sum of the elements placement and size.
        displacement = placement + $el.outerWidth();
        break;

      // Right and bottom elements displace according to their left and
      // top offset. Their size isn't important.
      case 'bottom':
        displacement = documentElement.clientHeight - placement;
        break;

      case 'right':
        displacement = documentElement.clientWidth - placement;
        break;

      default:
        displacement = 0;
    }
    return displacement;
  }

  /**
   * Assign the displace function to a property of the Drupal global object.
   *
   * @ignore
   */
  Drupal.displace = displace;
  $.extend(Drupal.displace, {

    /**
     * Expose offsets to other scripts to avoid having to recalculate offsets.
     *
     * @ignore
     */
    offsets: offsets,

    /**
     * Expose method to compute a single edge offsets.
     *
     * @ignore
     */
    calculateOffset: calculateOffset
  });

})(jQuery, Drupal, Drupal.debounce);
;
/*! jquery.cookie v1.4.1 | MIT */
!function(a){"function"==typeof define&&define.amd?define(["jquery"],a):"object"==typeof exports?a(require("jquery")):a(jQuery)}(function(a){function b(a){return h.raw?a:encodeURIComponent(a)}function c(a){return h.raw?a:decodeURIComponent(a)}function d(a){return b(h.json?JSON.stringify(a):String(a))}function e(a){0===a.indexOf('"')&&(a=a.slice(1,-1).replace(/\\"/g,'"').replace(/\\\\/g,"\\"));try{return a=decodeURIComponent(a.replace(g," ")),h.json?JSON.parse(a):a}catch(b){}}function f(b,c){var d=h.raw?b:e(b);return a.isFunction(c)?c(d):d}var g=/\+/g,h=a.cookie=function(e,g,i){if(void 0!==g&&!a.isFunction(g)){if(i=a.extend({},h.defaults,i),"number"==typeof i.expires){var j=i.expires,k=i.expires=new Date;k.setTime(+k+864e5*j)}return document.cookie=[b(e),"=",d(g),i.expires?"; expires="+i.expires.toUTCString():"",i.path?"; path="+i.path:"",i.domain?"; domain="+i.domain:"",i.secure?"; secure":""].join("")}for(var l=e?void 0:{},m=document.cookie?document.cookie.split("; "):[],n=0,o=m.length;o>n;n++){var p=m[n].split("="),q=c(p.shift()),r=p.join("=");if(e&&e===q){l=f(r,g);break}e||void 0===(r=f(r))||(l[q]=r)}return l};h.defaults={},a.removeCookie=function(b,c){return void 0===a.cookie(b)?!1:(a.cookie(b,"",a.extend({},c,{expires:-1})),!a.cookie(b))}});;
/**
 * @file
 * Drupal Bootstrap object.
 */

/**
 * All Drupal Bootstrap JavaScript APIs are contained in this namespace.
 *
 * @namespace
 */
(function ($, Drupal) {
  'use strict';

  Drupal.bootstrap = {
    settings: drupalSettings.bootstrap || {}
  };

  /**
   * Wraps Drupal.checkPlain() to ensure value passed isn't empty.
   *
   * Encodes special characters in a plain-text string for display as HTML.
   *
   * @param {string} str
   *   The string to be encoded.
   *
   * @return {string}
   *   The encoded string.
   *
   * @ingroup sanitization
   */
  Drupal.bootstrap.checkPlain = function (str) {
    return str && Drupal.checkPlain(str) || '';
  };

  /**
   * Extends a Bootstrap plugin constructor.
   *
   * @param {string} id
   *   A Bootstrap plugin identifier located in $.fn.
   * @param {function} [callback]
   *   A callback to extend the plugin constructor.
   *
   * @return {function|boolean}
   *   The Bootstrap plugin or FALSE if the plugin does not exist.
   */
  Drupal.bootstrap.extendPlugin = function (id, callback) {
    // Immediately return if the plugin does not exist.
    if (!$.fn[id] || !$.fn[id].Constructor) return false;

    // Extend the plugin if a callback was provided.
    if ($.isFunction(callback)) {
      var ret = callback.apply($.fn[id].Constructor, [this.settings]);
      if ($.isPlainObject(ret)) {
        $.extend(true, $.fn[id].Constructor, ret);
      }
    }

    // Add a jQuery UI like option getter/setter method.
    if ($.fn[id].Constructor.prototype.option === void(0)) {
      $.fn[id].Constructor.prototype.option = this.option;
    }

    return $.fn[id].Constructor;
  };

  /**
   * Replaces a Bootstrap jQuery plugin definition.
   *
   * @param {string} id
   *   A Bootstrap plugin identifier located in $.fn.
   * @param {function} [callback]
   *   A callback to replace the jQuery plugin definition. The callback must
   *   return a function that is used to construct a jQuery plugin.
   *
   * @return {function|boolean}
   *   The Bootstrap jQuery plugin definition or FALSE if the plugin does not
   *   exist.
   */
  Drupal.bootstrap.replacePlugin = function (id, callback) {
    // Immediately return if plugin does not exist or not a valid callback.
    if (!$.fn[id] || !$.fn[id].Constructor || !$.isFunction(callback)) return false;
    var constructor = $.fn[id].Constructor;

    var plugin = callback.apply(constructor);
    if ($.isFunction(plugin)) {
      plugin.Constructor = constructor;

      var old = $.fn[id];
      plugin.noConflict = function () { $.fn[id] = old; return this; };
      $.fn[id] = plugin;
    }
  };

  /**
   * Provide jQuery UI like ability to get/set options for Bootstrap plugins.
   *
   * @param {string|object} key
   *   A string value of the option to set, can be dot like to a nested key.
   *   An object of key/value pairs.
   * @param {*} [value]
   *   (optional) A value to set for key.
   *
   * @returns {*}
   *   - Returns nothing if key is an object or both key and value parameters
   *   were provided to set an option.
   *   - Returns the a value for a specific setting if key was provided.
   *   - Returns an object of key/value pairs of all the options if no key or
   *   value parameter was provided.
   *
   * @see https://github.com/jquery/jquery-ui/blob/master/ui/widget.js
   *
   * @todo This isn't fully working since Bootstrap plugins don't allow
   * methods to return values.
   */
  Drupal.bootstrap.option = function (key, value) {
    var options = key;
    var parts, curOption, i;

    // Don't return a reference to the internal hash.
    if (arguments.length === 0) {
      return $.extend({}, this.options);
    }

    // Handle a specific option.
    if (typeof key === "string") {
      // Handle nested keys, e.g., "foo.bar" => { foo: { bar: ___ } }
      options = {};
      parts = key.split(".");
      key = parts.shift();
      if (parts.length) {
        curOption = options[key] = $.extend({}, this.options[key]);
        for (i = 0; i < parts.length - 1; i++) {
          curOption[parts[i]] = curOption[parts[i]] || {};
          curOption = curOption[parts[i]];
        }
        key = parts.pop();
        if (arguments.length === 1) {
          return curOption[key] === undefined ? null : curOption[key];
        }
        curOption[key] = value;
      }
      else {
        if (arguments.length === 1) {
          return this.options[key] === undefined ? null : this.options[key];
        }
        options[key] = value;
      }
    }

    // Set the new option(s).
    for (key in options) {
      if (!options.hasOwnProperty(key)) continue;
      this.options[key] = options[key];
    }
    return this;
  };

})(window.jQuery, window.Drupal, window.drupalSettings);
;
(function ($, _) {

  /**
   * Class to help modify attributes.
   *
   * @param {object} object
   *   An object to initialize attributes with.
   *
   * @constructor
   */
  var Attributes = function (object) {
    this.data = object && _.isObject(object) && _.clone(object) || {};
  };

  /**
   * Renders the attributes object as a string to inject into an HTML element.
   *
   * @returns {string}
   */
  Attributes.prototype.toString = function () {
    var output = '';
    var name, value;
    var checkPlain = function (str) {
      return str && str.toString().replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;') || '';
    };
    for (name in this.data) {
      if (!this.data.hasOwnProperty(name)) continue;
      value = this.data[name];
      if (_.isFunction(value)) value = value();
      if (_.isObject(value)) value = _.values(value);
      if (_.isArray(value)) value = value.join(' ');
      output += ' ' + checkPlain(name) + '="' + checkPlain(value) + '"';
    }
    return output;
  };

  /**
   * Add class(es) to the array.
   *
   * @param {string|Array} value
   *   An individual class or an array of classes to add.
   *
   * @return {Attributes}
   *
   * @chainable
   */
  Attributes.prototype.addClass = function (value) {
    var classes = this.getClasses();
    value = [].concat(classes, value);
    this.set('class', _.uniq(value));
    return this;
  };

  /**
   * Returns whether the requested attribute exists.
   *
   * @param {string} name
   *   An attribute name to check.
   *
   * @return {boolean}
   *   TRUE or FALSE
   */
  Attributes.prototype.exists = function (name) {
    return this.data[name] !== void(0) && this.data[name] !== null;
  };

  /**
   * Retrieve a specific attribute from the array.
   *
   * @param {string} name
   *   The specific attribute to retrieve.
   * @param {*} defaultValue
   *   (optional) The default value to set if the attribute does not exist.
   *
   * @return {*}
   *   A specific attribute value, passed by reference.
   */
  Attributes.prototype.get = function (name, defaultValue) {
    if (!this.exists(name)) this.data[name] = defaultValue;
    return this.data[name];
  };

  /**
   * Retrieves a cloned copy of the internal attributes data object.
   *
   * @returns {Object}
   */
  Attributes.prototype.getData = function () {
    return _.clone(this.data);
  };

  /**
   * Retrieves classes from the array.
   *
   * @return {Array}
   *   The classes array.
   */
  Attributes.prototype.getClasses = function () {
    var classes = [].concat(this.get('class', []));
    return _.uniq(classes);
  };

  /**
   * Indicates whether a class is present in the array.
   *
   * @param {string|Array} name
   *   The class(es) to search for.
   *
   * @return {boolean}
   *   TRUE or FALSE
   */
  Attributes.prototype.hasClass = function (name) {
    name = [].concat(name);
    var classes = this.getClasses();
    var found = false;
    _.each(name, function (value) { if (_.indexOf(classes, value) !== -1) found = true; });
    return found;
  };

  /**
   * Merges multiple values into the array.
   *
   * @param {object} values
   *   An associative key/value array.
   * @param {boolean} [recursive]
   *   Flag determining whether or not to recursively merge key/value pairs.
   *
   * @return {Attributes}
   *
   * @chainable
   */
  Attributes.prototype.merge = function (values, recursive) {
    values = values instanceof Attributes ? values.getData() : values;
    if (recursive === void(0) || recursive) {
      this.data = $.extend(true, {}, this.data, values);
    }
    else {
      $.extend(this.data, values);
    }
    return this;
  };

  /**
   * Removes an attribute from the array.
   *
   * @param {string} name
   *   The name of the attribute to remove.
   *
   * @return {Attributes}
   *
   * @chainable
   */
  Attributes.prototype.remove = function (name) {
    if (this.exists(name)) delete this.data[name];
    return this;
  };

  /**
   * Removes a class from the attributes array.
   *
   * @param {string|Array} value
   *   An individual class or an array of classes to remove.
   *
   * @return {Attributes}
   *
   * @chainable
   */
  Attributes.prototype.removeClass = function (value) {
    this.set('class', _.without(this.getClasses(), [].concat(value)));
    return this;
  };

  /**
   * Replaces a class in the attributes array.
   *
   * @param {string} oldValue
   *   The old class to remove.
   * @param {string} newValue
   *   The new class. It will not be added if the old class does not exist.
   *
   * @return {Attributes}
   *
   * @chainable
   */
  Attributes.prototype.replaceClass = function (oldValue, newValue) {
    var classes = this.getClasses();
    var i = _.indexOf(oldValue, classes);
    if (i >= 0) {
      classes[i] = newValue;
      this.set('class', classes);
    }
    return this;
  };

  /**
   * Sets an attribute on the array.
   *
   * @param {string} name
   *   The name of the attribute to set.
   * @param {*} value
   *   The value of the attribute to set.
   *
   * @return {Attributes}
   *
   * @chainable
   */
  Attributes.prototype.set = function (name, value) {
    this.data[name] = value;
    return this;
  };

  /**
   * Creates an Attributes instance.
   *
   * @param {object|Attributes} object
   *   An object to initialize attributes with.
   *
   * @returns {Attributes}
   *
   * @global
   *
   * @constructor
   */
  window.Attributes = function (object) {
    return object instanceof Attributes ? object : new Attributes(object);
  };

})(window.jQuery, window._);
;
/**
 * @file
 * Theme hooks for the Drupal Bootstrap base theme.
 */
(function ($, Drupal, Bootstrap) {

  /**
   * Fallback for theming an icon if the Icon API module is not installed.
   */
  if (!Drupal.icon) Drupal.icon = { bundles: {} };
  if (!Drupal.theme.icon || Drupal.theme.prototype.icon) {
    $.extend(Drupal.theme, /** @lends Drupal.theme */ {
      /**
       * Renders an icon.
       *
       * @param {string} bundle
       *   The bundle which the icon belongs to.
       * @param {string} icon
       *   The name of the icon to render.
       * @param {object|Attributes} [attributes]
       *   An object of attributes to also apply to the icon.
       *
       * @returns {string}
       */
      icon: function (bundle, icon, attributes) {
        if (!Drupal.icon.bundles[bundle]) return '';
        attributes = Attributes(attributes).addClass('icon').set('aria-hidden', 'true');
        icon = Drupal.icon.bundles[bundle](icon, attributes);
        return '<span' + attributes + '></span>';
      }
    });
  }

  /**
   * Callback for modifying an icon in the "bootstrap" icon bundle.
   *
   * @param {string} icon
   *   The icon being rendered.
   * @param {Attributes} attributes
   *   Attributes object for the icon.
   */
  Drupal.icon.bundles.bootstrap = function (icon, attributes) {
    attributes.addClass(['glyphicon', 'glyphicon-' + icon]);
  };

  /**
   * Add necessary theming hooks.
   */
  $.extend(Drupal.theme, /** @lends Drupal.theme */ {

    /**
     * Renders a Bootstrap AJAX glyphicon throbber.
     *
     * @returns {string}
     */
    ajaxThrobber: function () {
      return Drupal.theme.bootstrapIcon('refresh', {'class': ['ajax-throbber', 'glyphicon-spin'] });
    },

    /**
     * Renders a button element.
     *
     * @param {object|Attributes} attributes
     *   An object of attributes to apply to the button. If it contains one of:
     *   - value: The label of the button.
     *   - context: The context type of Bootstrap button, can be one of:
     *     - default
     *     - primary
     *     - success
     *     - info
     *     - warning
     *     - danger
     *     - link
     *
     * @returns {string}
     */
    button: function (attributes) {
      attributes = Attributes(attributes).addClass('btn');
      var context = attributes.get('context', 'default');
      var label = attributes.get('value', '');
      attributes.remove('context').remove('value');
      if (!attributes.hasClass(['btn-default', 'btn-primary', 'btn-success', 'btn-info', 'btn-warning', 'btn-danger', 'btn-link'])) {
        attributes.addClass('btn-' + Bootstrap.checkPlain(context));
      }
      return '<button' + attributes + '>' + label + '</button>';
    },

    /**
     * Alias for "button" theme hook.
     *
     * @param {object|Attributes} attributes
     *   An object of attributes to apply to the button.
     *
     * @see Drupal.theme.button()
     *
     * @returns {string}
     */
    btn: function (attributes) {
      return Drupal.theme('button', attributes);
    },

    /**
     * Renders a button block element.
     *
     * @param {object|Attributes} attributes
     *   An object of attributes to apply to the button.
     *
     * @see Drupal.theme.button()
     *
     * @returns {string}
     */
    'btn-block': function (attributes) {
      return Drupal.theme('button', Attributes(attributes).addClass('btn-block'));
    },

    /**
     * Renders a large button element.
     *
     * @param {object|Attributes} attributes
     *   An object of attributes to apply to the button.
     *
     * @see Drupal.theme.button()
     *
     * @returns {string}
     */
    'btn-lg': function (attributes) {
      return Drupal.theme('button', Attributes(attributes).addClass('btn-lg'));
    },

    /**
     * Renders a small button element.
     *
     * @param {object|Attributes} attributes
     *   An object of attributes to apply to the button.
     *
     * @see Drupal.theme.button()
     *
     * @returns {string}
     */
    'btn-sm': function (attributes) {
      return Drupal.theme('button', Attributes(attributes).addClass('btn-sm'));
    },

    /**
     * Renders an extra small button element.
     *
     * @param {object|Attributes} attributes
     *   An object of attributes to apply to the button.
     *
     * @see Drupal.theme.button()
     *
     * @returns {string}
     */
    'btn-xs': function (attributes) {
      return Drupal.theme('button', Attributes(attributes).addClass('btn-xs'));
    },

    /**
     * Renders a glyphicon.
     *
     * @param {string} name
     *   The name of the glyphicon.
     * @param {object|Attributes} [attributes]
     *   An object of attributes to apply to the icon.
     *
     * @returns {string}
     */
    bootstrapIcon: function (name, attributes) {
      return Drupal.theme('icon', 'bootstrap', name, attributes);
    }

  });

})(window.jQuery, window.Drupal, window.Drupal.bootstrap);
;
/**
 * @file
 * Form features.
 */

/**
 * Triggers when a value in the form changed.
 *
 * The event triggers when content is typed or pasted in a text field, before
 * the change event triggers.
 *
 * @event formUpdated
 */

(function ($, Drupal, debounce) {

  'use strict';

  /**
   * Retrieves the summary for the first element.
   *
   * @return {string}
   *   The text of the summary.
   */
  $.fn.drupalGetSummary = function () {
    var callback = this.data('summaryCallback');
    return (this[0] && callback) ? $.trim(callback(this[0])) : '';
  };

  /**
   * Sets the summary for all matched elements.
   *
   * @param {function} callback
   *   Either a function that will be called each time the summary is
   *   retrieved or a string (which is returned each time).
   *
   * @return {jQuery}
   *   jQuery collection of the current element.
   *
   * @fires event:summaryUpdated
   *
   * @listens event:formUpdated
   */
  $.fn.drupalSetSummary = function (callback) {
    var self = this;

    // To facilitate things, the callback should always be a function. If it's
    // not, we wrap it into an anonymous function which just returns the value.
    if (typeof callback !== 'function') {
      var val = callback;
      callback = function () { return val; };
    }

    return this
      .data('summaryCallback', callback)
      // To prevent duplicate events, the handlers are first removed and then
      // (re-)added.
      .off('formUpdated.summary')
      .on('formUpdated.summary', function () {
        self.trigger('summaryUpdated');
      })
      // The actual summaryUpdated handler doesn't fire when the callback is
      // changed, so we have to do this manually.
      .trigger('summaryUpdated');
  };

  /**
   * Prevents consecutive form submissions of identical form values.
   *
   * Repetitive form submissions that would submit the identical form values
   * are prevented, unless the form values are different to the previously
   * submitted values.
   *
   * This is a simplified re-implementation of a user-agent behavior that
   * should be natively supported by major web browsers, but at this time, only
   * Firefox has a built-in protection.
   *
   * A form value-based approach ensures that the constraint is triggered for
   * consecutive, identical form submissions only. Compared to that, a form
   * button-based approach would (1) rely on [visible] buttons to exist where
   * technically not required and (2) require more complex state management if
   * there are multiple buttons in a form.
   *
   * This implementation is based on form-level submit events only and relies
   * on jQuery's serialize() method to determine submitted form values. As such,
   * the following limitations exist:
   *
   * - Event handlers on form buttons that preventDefault() do not receive a
   *   double-submit protection. That is deemed to be fine, since such button
   *   events typically trigger reversible client-side or server-side
   *   operations that are local to the context of a form only.
   * - Changed values in advanced form controls, such as file inputs, are not
   *   part of the form values being compared between consecutive form submits
   *   (due to limitations of jQuery.serialize()). That is deemed to be
   *   acceptable, because if the user forgot to attach a file, then the size of
   *   HTTP payload will most likely be small enough to be fully passed to the
   *   server endpoint within (milli)seconds. If a user mistakenly attached a
   *   wrong file and is technically versed enough to cancel the form submission
   *   (and HTTP payload) in order to attach a different file, then that
   *   edge-case is not supported here.
   *
   * Lastly, all forms submitted via HTTP GET are idempotent by definition of
   * HTTP standards, so excluded in this implementation.
   *
   * @type {Drupal~behavior}
   */
  Drupal.behaviors.formSingleSubmit = {
    attach: function () {
      function onFormSubmit(e) {
        var $form = $(e.currentTarget);
        var formValues = $form.serialize();
        var previousValues = $form.attr('data-drupal-form-submit-last');
        if (previousValues === formValues) {
          e.preventDefault();
        }
        else {
          $form.attr('data-drupal-form-submit-last', formValues);
        }
      }

      $('body').once('form-single-submit')
        .on('submit.singleSubmit', 'form:not([method~="GET"])', onFormSubmit);
    }
  };

  /**
   * Sends a 'formUpdated' event each time a form element is modified.
   *
   * @param {HTMLElement} element
   *   The element to trigger a form updated event on.
   *
   * @fires event:formUpdated
   */
  function triggerFormUpdated(element) {
    $(element).trigger('formUpdated');
  }

  /**
   * Collects the IDs of all form fields in the given form.
   *
   * @param {HTMLFormElement} form
   *   The form element to search.
   *
   * @return {Array}
   *   Array of IDs for form fields.
   */
  function fieldsList(form) {
    var $fieldList = $(form).find('[name]').map(function (index, element) {
      // We use id to avoid name duplicates on radio fields and filter out
      // elements with a name but no id.
      return element.getAttribute('id');
    });
    // Return a true array.
    return $.makeArray($fieldList);
  }

  /**
   * Triggers the 'formUpdated' event on form elements when they are modified.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches formUpdated behaviors.
   * @prop {Drupal~behaviorDetach} detach
   *   Detaches formUpdated behaviors.
   *
   * @fires event:formUpdated
   */
  Drupal.behaviors.formUpdated = {
    attach: function (context) {
      var $context = $(context);
      var contextIsForm = $context.is('form');
      var $forms = (contextIsForm ? $context : $context.find('form')).once('form-updated');
      var formFields;

      if ($forms.length) {
        // Initialize form behaviors, use $.makeArray to be able to use native
        // forEach array method and have the callback parameters in the right
        // order.
        $.makeArray($forms).forEach(function (form) {
          var events = 'change.formUpdated input.formUpdated ';
          var eventHandler = debounce(function (event) { triggerFormUpdated(event.target); }, 300);
          formFields = fieldsList(form).join(',');

          form.setAttribute('data-drupal-form-fields', formFields);
          $(form).on(events, eventHandler);
        });
      }
      // On ajax requests context is the form element.
      if (contextIsForm) {
        formFields = fieldsList(context).join(',');
        // @todo replace with form.getAttribute() when #1979468 is in.
        var currentFields = $(context).attr('data-drupal-form-fields');
        // If there has been a change in the fields or their order, trigger
        // formUpdated.
        if (formFields !== currentFields) {
          triggerFormUpdated(context);
        }
      }

    },
    detach: function (context, settings, trigger) {
      var $context = $(context);
      var contextIsForm = $context.is('form');
      if (trigger === 'unload') {
        var $forms = (contextIsForm ? $context : $context.find('form')).removeOnce('form-updated');
        if ($forms.length) {
          $.makeArray($forms).forEach(function (form) {
            form.removeAttribute('data-drupal-form-fields');
            $(form).off('.formUpdated');
          });
        }
      }
    }
  };

  /**
   * Prepopulate form fields with information from the visitor browser.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches the behavior for filling user info from browser.
   */
  Drupal.behaviors.fillUserInfoFromBrowser = {
    attach: function (context, settings) {
      var userInfo = ['name', 'mail', 'homepage'];
      var $forms = $('[data-user-info-from-browser]').once('user-info-from-browser');
      if ($forms.length) {
        userInfo.map(function (info) {
          var $element = $forms.find('[name=' + info + ']');
          var browserData = localStorage.getItem('Drupal.visitor.' + info);
          var emptyOrDefault = ($element.val() === '' || ($element.attr('data-drupal-default-value') === $element.val()));
          if ($element.length && emptyOrDefault && browserData) {
            $element.val(browserData);
          }
        });
      }
      $forms.on('submit', function () {
        userInfo.map(function (info) {
          var $element = $forms.find('[name=' + info + ']');
          if ($element.length) {
            localStorage.setItem('Drupal.visitor.' + info, $element.val());
          }
        });
      });
    }
  };

})(jQuery, Drupal, Drupal.debounce);
;
/**
 * @file
 * Extends methods from core/misc/form.js.
 */

(function ($, window, Drupal, drupalSettings) {

  /**
   * Behavior for "forms_has_error_value_toggle" theme setting.
   */
  Drupal.behaviors.bootstrapForm = {
    attach: function (context) {
      if (drupalSettings.bootstrap && drupalSettings.bootstrap.forms_has_error_value_toggle) {
        var $context = $(context);
        $context.find('.form-item.has-error:not(.form-type-password.has-feedback)').once('error').each(function () {
          var $formItem = $(this);
          var $input = $formItem.find(':input');
          $input.on('keyup focus blur', function () {
            var value = $input.val() || false;
            $formItem[value ? 'removeClass' : 'addClass']('has-error');
            $input[value ? 'removeClass' : 'addClass']('error');
          });
        });
      }
    }
  };


})(jQuery, this, Drupal, drupalSettings);
;
/**
 * @file
 * Progress bar.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * Theme function for the progress bar.
   *
   * @param {string} id
   *   The id for the progress bar.
   *
   * @return {string}
   *   The HTML for the progress bar.
   */
  Drupal.theme.progressBar = function (id) {
    return '<div id="' + id + '" class="progress" aria-live="polite">' +
      '<div class="progress__label">&nbsp;</div>' +
      '<div class="progress__track"><div class="progress__bar"></div></div>' +
      '<div class="progress__percentage"></div>' +
      '<div class="progress__description">&nbsp;</div>' +
      '</div>';
  };

  /**
   * A progressbar object. Initialized with the given id. Must be inserted into
   * the DOM afterwards through progressBar.element.
   *
   * Method is the function which will perform the HTTP request to get the
   * progress bar state. Either "GET" or "POST".
   *
   * @example
   * pb = new Drupal.ProgressBar('myProgressBar');
   * some_element.appendChild(pb.element);
   *
   * @constructor
   *
   * @param {string} id
   *   The id for the progressbar.
   * @param {function} updateCallback
   *   Callback to run on update.
   * @param {string} method
   *   HTTP method to use.
   * @param {function} errorCallback
   *   Callback to call on error.
   */
  Drupal.ProgressBar = function (id, updateCallback, method, errorCallback) {
    this.id = id;
    this.method = method || 'GET';
    this.updateCallback = updateCallback;
    this.errorCallback = errorCallback;

    // The WAI-ARIA setting aria-live="polite" will announce changes after
    // users
    // have completed their current activity and not interrupt the screen
    // reader.
    this.element = $(Drupal.theme('progressBar', id));
  };

  $.extend(Drupal.ProgressBar.prototype, /** @lends Drupal.ProgressBar# */{

    /**
     * Set the percentage and status message for the progressbar.
     *
     * @param {number} percentage
     *   The progress percentage.
     * @param {string} message
     *   The message to show the user.
     * @param {string} label
     *   The text for the progressbar label.
     */
    setProgress: function (percentage, message, label) {
      if (percentage >= 0 && percentage <= 100) {
        $(this.element).find('div.progress__bar').css('width', percentage + '%');
        $(this.element).find('div.progress__percentage').html(percentage + '%');
      }
      $('div.progress__description', this.element).html(message);
      $('div.progress__label', this.element).html(label);
      if (this.updateCallback) {
        this.updateCallback(percentage, message, this);
      }
    },

    /**
     * Start monitoring progress via Ajax.
     *
     * @param {string} uri
     *   The URI to use for monitoring.
     * @param {number} delay
     *   The delay for calling the monitoring URI.
     */
    startMonitoring: function (uri, delay) {
      this.delay = delay;
      this.uri = uri;
      this.sendPing();
    },

    /**
     * Stop monitoring progress via Ajax.
     */
    stopMonitoring: function () {
      clearTimeout(this.timer);
      // This allows monitoring to be stopped from within the callback.
      this.uri = null;
    },

    /**
     * Request progress data from server.
     */
    sendPing: function () {
      if (this.timer) {
        clearTimeout(this.timer);
      }
      if (this.uri) {
        var pb = this;
        // When doing a post request, you need non-null data. Otherwise a
        // HTTP 411 or HTTP 406 (with Apache mod_security) error may result.
        var uri = this.uri;
        if (uri.indexOf('?') === -1) {
          uri += '?';
        }
        else {
          uri += '&';
        }
        uri += '_format=json';
        $.ajax({
          type: this.method,
          url: uri,
          data: '',
          dataType: 'json',
          success: function (progress) {
            // Display errors.
            if (progress.status === 0) {
              pb.displayError(progress.data);
              return;
            }
            // Update display.
            pb.setProgress(progress.percentage, progress.message, progress.label);
            // Schedule next timer.
            pb.timer = setTimeout(function () { pb.sendPing(); }, pb.delay);
          },
          error: function (xmlhttp) {
            var e = new Drupal.AjaxError(xmlhttp, pb.uri);
            pb.displayError('<pre>' + e.message + '</pre>');
          }
        });
      }
    },

    /**
     * Display errors on the page.
     *
     * @param {string} string
     *   The error message to show the user.
     */
    displayError: function (string) {
      var error = $('<div class="messages messages--error"></div>').html(string);
      $(this.element).before(error).hide();

      if (this.errorCallback) {
        this.errorCallback(this);
      }
    }
  });

})(jQuery, Drupal);
;
/**
 * @file
 * Extends methods from core/misc/progress.js.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * Theme function for the progress bar.
   *
   * @param {string} id
   *
   * @return {string}
   *   The HTML for the progress bar.
   */
  Drupal.theme.progressBar = function (id) {
    return '<div class="progress-wrapper" aria-live="polite">' +
             '<div class="message"></div>'+
             '<div id ="' + id + '" class="progress progress-striped active">' +
               '<div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">' +
                 '<span class="percentage"></span>' +
               '</div>' +
             '</div>' +
             '<div class="progress-label"></div>' +
           '</div>';
  };

  $.extend(Drupal.ProgressBar.prototype, /** @lends Drupal.ProgressBar */{

    /**
     * Set the percentage and status message for the progressbar.
     *
     * @param {number} percentage
     * @param {string} message
     * @param {string} label
     */
    setProgress: function (percentage, message, label) {
      if (percentage >= 0 && percentage <= 100) {
        $(this.element).find('.progress-bar').css('width', percentage + '%').attr('aria-valuenow', percentage);
        $(this.element).find('.percentage').html(percentage + '%');
      }
      if (message) {
        // Remove the unnecessary whitespace at the end of the message.
        message = message.replace(/<br\/>&nbsp;|\s*$/, '');

        $('.message', this.element).html(message);
      }
      if (label) {
        $('.progress-label', this.element).html(label);
      }
      if (this.updateCallback) {
        this.updateCallback(percentage, message, this);
      }
    },

    /**
     * Display errors on the page.
     *
     * @param {string} string
     */
    displayError: function (string) {
      var error = $('<div class="alert alert-block alert-error"><a class="close" data-dismiss="alert" href="#">&times;</a><h4>' + Drupal.t('Error message') + '</h4></div>').append(string);
      $(this.element).before(error).hide();

      if (this.errorCallback) {
        this.errorCallback(this);
      }
    }
  });

})(jQuery, Drupal);
;
/**
 * @file
 * Provides Ajax page updating via jQuery $.ajax.
 *
 * Ajax is a method of making a request via JavaScript while viewing an HTML
 * page. The request returns an array of commands encoded in JSON, which is
 * then executed to make any changes that are necessary to the page.
 *
 * Drupal uses this file to enhance form elements with `#ajax['url']` and
 * `#ajax['wrapper']` properties. If set, this file will automatically be
 * included to provide Ajax capabilities.
 */

(function ($, window, Drupal, drupalSettings) {

  'use strict';

  /**
   * Attaches the Ajax behavior to each Ajax form element.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Initialize all {@link Drupal.Ajax} objects declared in
   *   `drupalSettings.ajax` or initialize {@link Drupal.Ajax} objects from
   *   DOM elements having the `use-ajax-submit` or `use-ajax` css class.
   * @prop {Drupal~behaviorDetach} detach
   *   During `unload` remove all {@link Drupal.Ajax} objects related to
   *   the removed content.
   */
  Drupal.behaviors.AJAX = {
    attach: function (context, settings) {

      function loadAjaxBehavior(base) {
        var element_settings = settings.ajax[base];
        if (typeof element_settings.selector === 'undefined') {
          element_settings.selector = '#' + base;
        }
        $(element_settings.selector).once('drupal-ajax').each(function () {
          element_settings.element = this;
          element_settings.base = base;
          Drupal.ajax(element_settings);
        });
      }

      // Load all Ajax behaviors specified in the settings.
      for (var base in settings.ajax) {
        if (settings.ajax.hasOwnProperty(base)) {
          loadAjaxBehavior(base);
        }
      }

      // Bind Ajax behaviors to all items showing the class.
      $('.use-ajax').once('ajax').each(function () {
        var element_settings = {};
        // Clicked links look better with the throbber than the progress bar.
        element_settings.progress = {type: 'throbber'};

        // For anchor tags, these will go to the target of the anchor rather
        // than the usual location.
        var href = $(this).attr('href');
        if (href) {
          element_settings.url = href;
          element_settings.event = 'click';
        }
        element_settings.dialogType = $(this).data('dialog-type');
        element_settings.dialog = $(this).data('dialog-options');
        element_settings.base = $(this).attr('id');
        element_settings.element = this;
        Drupal.ajax(element_settings);
      });

      // This class means to submit the form to the action using Ajax.
      $('.use-ajax-submit').once('ajax').each(function () {
        var element_settings = {};

        // Ajax submits specified in this manner automatically submit to the
        // normal form action.
        element_settings.url = $(this.form).attr('action');
        // Form submit button clicks need to tell the form what was clicked so
        // it gets passed in the POST request.
        element_settings.setClick = true;
        // Form buttons use the 'click' event rather than mousedown.
        element_settings.event = 'click';
        // Clicked form buttons look better with the throbber than the progress
        // bar.
        element_settings.progress = {type: 'throbber'};
        element_settings.base = $(this).attr('id');
        element_settings.element = this;

        Drupal.ajax(element_settings);
      });
    },

    detach: function (context, settings, trigger) {
      if (trigger === 'unload') {
        Drupal.ajax.expired().forEach(function (instance) {
          // Set this to null and allow garbage collection to reclaim
          // the memory.
          Drupal.ajax.instances[instance.instanceIndex] = null;
        });
      }
    }
  };

  /**
   * Extends Error to provide handling for Errors in Ajax.
   *
   * @constructor
   *
   * @augments Error
   *
   * @param {XMLHttpRequest} xmlhttp
   *   XMLHttpRequest object used for the failed request.
   * @param {string} uri
   *   The URI where the error occurred.
   * @param {string} customMessage
   *   The custom message.
   */
  Drupal.AjaxError = function (xmlhttp, uri, customMessage) {

    var statusCode;
    var statusText;
    var pathText;
    var responseText;
    var readyStateText;
    if (xmlhttp.status) {
      statusCode = '\n' + Drupal.t('An AJAX HTTP error occurred.') + '\n' + Drupal.t('HTTP Result Code: !status', {'!status': xmlhttp.status});
    }
    else {
      statusCode = '\n' + Drupal.t('An AJAX HTTP request terminated abnormally.');
    }
    statusCode += '\n' + Drupal.t('Debugging information follows.');
    pathText = '\n' + Drupal.t('Path: !uri', {'!uri': uri});
    statusText = '';
    // In some cases, when statusCode === 0, xmlhttp.statusText may not be
    // defined. Unfortunately, testing for it with typeof, etc, doesn't seem to
    // catch that and the test causes an exception. So we need to catch the
    // exception here.
    try {
      statusText = '\n' + Drupal.t('StatusText: !statusText', {'!statusText': $.trim(xmlhttp.statusText)});
    }
    catch (e) {
      // Empty.
    }

    responseText = '';
    // Again, we don't have a way to know for sure whether accessing
    // xmlhttp.responseText is going to throw an exception. So we'll catch it.
    try {
      responseText = '\n' + Drupal.t('ResponseText: !responseText', {'!responseText': $.trim(xmlhttp.responseText)});
    }
    catch (e) {
      // Empty.
    }

    // Make the responseText more readable by stripping HTML tags and newlines.
    responseText = responseText.replace(/<("[^"]*"|'[^']*'|[^'">])*>/gi, '');
    responseText = responseText.replace(/[\n]+\s+/g, '\n');

    // We don't need readyState except for status == 0.
    readyStateText = xmlhttp.status === 0 ? ('\n' + Drupal.t('ReadyState: !readyState', {'!readyState': xmlhttp.readyState})) : '';

    customMessage = customMessage ? ('\n' + Drupal.t('CustomMessage: !customMessage', {'!customMessage': customMessage})) : '';

    /**
     * Formatted and translated error message.
     *
     * @type {string}
     */
    this.message = statusCode + pathText + statusText + customMessage + responseText + readyStateText;

    /**
     * Used by some browsers to display a more accurate stack trace.
     *
     * @type {string}
     */
    this.name = 'AjaxError';
  };

  Drupal.AjaxError.prototype = new Error();
  Drupal.AjaxError.prototype.constructor = Drupal.AjaxError;

  /**
   * Provides Ajax page updating via jQuery $.ajax.
   *
   * This function is designed to improve developer experience by wrapping the
   * initialization of {@link Drupal.Ajax} objects and storing all created
   * objects in the {@link Drupal.ajax.instances} array.
   *
   * @example
   * Drupal.behaviors.myCustomAJAXStuff = {
   *   attach: function (context, settings) {
   *
   *     var ajaxSettings = {
   *       url: 'my/url/path',
   *       // If the old version of Drupal.ajax() needs to be used those
   *       // properties can be added
   *       base: 'myBase',
   *       element: $(context).find('.someElement')
   *     };
   *
   *     var myAjaxObject = Drupal.ajax(ajaxSettings);
   *
   *     // Declare a new Ajax command specifically for this Ajax object.
   *     myAjaxObject.commands.insert = function (ajax, response, status) {
   *       $('#my-wrapper').append(response.data);
   *       alert('New content was appended to #my-wrapper');
   *     };
   *
   *     // This command will remove this Ajax object from the page.
   *     myAjaxObject.commands.destroyObject = function (ajax, response, status) {
   *       Drupal.ajax.instances[this.instanceIndex] = null;
   *     };
   *
   *     // Programmatically trigger the Ajax request.
   *     myAjaxObject.execute();
   *   }
   * };
   *
   * @param {object} settings
   *   The settings object passed to {@link Drupal.Ajax} constructor.
   * @param {string} [settings.base]
   *   Base is passed to {@link Drupal.Ajax} constructor as the 'base'
   *   parameter.
   * @param {HTMLElement} [settings.element]
   *   Element parameter of {@link Drupal.Ajax} constructor, element on which
   *   event listeners will be bound.
   *
   * @return {Drupal.Ajax}
   *   The created Ajax object.
   *
   * @see Drupal.AjaxCommands
   */
  Drupal.ajax = function (settings) {
    if (arguments.length !== 1) {
      throw new Error('Drupal.ajax() function must be called with one configuration object only');
    }
    // Map those config keys to variables for the old Drupal.ajax function.
    var base = settings.base || false;
    var element = settings.element || false;
    delete settings.base;
    delete settings.element;

    // By default do not display progress for ajax calls without an element.
    if (!settings.progress && !element) {
      settings.progress = false;
    }

    var ajax = new Drupal.Ajax(base, element, settings);
    ajax.instanceIndex = Drupal.ajax.instances.length;
    Drupal.ajax.instances.push(ajax);

    return ajax;
  };

  /**
   * Contains all created Ajax objects.
   *
   * @type {Array.<Drupal.Ajax|null>}
   */
  Drupal.ajax.instances = [];

  /**
   * List all objects where the associated element is not in the DOM
   *
   * This method ignores {@link Drupal.Ajax} objects not bound to DOM elements
   * when created with {@link Drupal.ajax}.
   *
   * @return {Array.<Drupal.Ajax>}
   *   The list of expired {@link Drupal.Ajax} objects.
   */
  Drupal.ajax.expired = function () {
    return Drupal.ajax.instances.filter(function (instance) {
      return instance && instance.element !== false && !document.body.contains(instance.element);
    });
  };

  /**
   * Settings for an Ajax object.
   *
   * @typedef {object} Drupal.Ajax~element_settings
   *
   * @prop {string} url
   *   Target of the Ajax request.
   * @prop {?string} [event]
   *   Event bound to settings.element which will trigger the Ajax request.
   * @prop {bool} [keypress=true]
   *   Triggers a request on keypress events.
   * @prop {?string} selector
   *   jQuery selector targeting the element to bind events to or used with
   *   {@link Drupal.AjaxCommands}.
   * @prop {string} [effect='none']
   *   Name of the jQuery method to use for displaying new Ajax content.
   * @prop {string|number} [speed='none']
   *   Speed with which to apply the effect.
   * @prop {string} [method]
   *   Name of the jQuery method used to insert new content in the targeted
   *   element.
   * @prop {object} [progress]
   *   Settings for the display of a user-friendly loader.
   * @prop {string} [progress.type='throbber']
   *   Type of progress element, core provides `'bar'`, `'throbber'` and
   *   `'fullscreen'`.
   * @prop {string} [progress.message=Drupal.t('Please wait...')]
   *   Custom message to be used with the bar indicator.
   * @prop {object} [submit]
   *   Extra data to be sent with the Ajax request.
   * @prop {bool} [submit.js=true]
   *   Allows the PHP side to know this comes from an Ajax request.
   * @prop {object} [dialog]
   *   Options for {@link Drupal.dialog}.
   * @prop {string} [dialogType]
   *   One of `'modal'` or `'dialog'`.
   * @prop {string} [prevent]
   *   List of events on which to stop default action and stop propagation.
   */

  /**
   * Ajax constructor.
   *
   * The Ajax request returns an array of commands encoded in JSON, which is
   * then executed to make any changes that are necessary to the page.
   *
   * Drupal uses this file to enhance form elements with `#ajax['url']` and
   * `#ajax['wrapper']` properties. If set, this file will automatically be
   * included to provide Ajax capabilities.
   *
   * @constructor
   *
   * @param {string} [base]
   *   Base parameter of {@link Drupal.Ajax} constructor
   * @param {HTMLElement} [element]
   *   Element parameter of {@link Drupal.Ajax} constructor, element on which
   *   event listeners will be bound.
   * @param {Drupal.Ajax~element_settings} element_settings
   *   Settings for this Ajax object.
   */
  Drupal.Ajax = function (base, element, element_settings) {
    var defaults = {
      event: element ? 'mousedown' : null,
      keypress: true,
      selector: base ? '#' + base : null,
      effect: 'none',
      speed: 'none',
      method: 'replaceWith',
      progress: {
        type: 'throbber',
        message: Drupal.t('Please wait...')
      },
      submit: {
        js: true
      }
    };

    $.extend(this, defaults, element_settings);

    /**
     * @type {Drupal.AjaxCommands}
     */
    this.commands = new Drupal.AjaxCommands();

    /**
     * @type {bool|number}
     */
    this.instanceIndex = false;

    // @todo Remove this after refactoring the PHP code to:
    //   - Call this 'selector'.
    //   - Include the '#' for ID-based selectors.
    //   - Support non-ID-based selectors.
    if (this.wrapper) {

      /**
       * @type {string}
       */
      this.wrapper = '#' + this.wrapper;
    }

    /**
     * @type {HTMLElement}
     */
    this.element = element;

    /**
     * @type {Drupal.Ajax~element_settings}
     */
    this.element_settings = element_settings;

    // If there isn't a form, jQuery.ajax() will be used instead, allowing us to
    // bind Ajax to links as well.
    if (this.element && this.element.form) {

      /**
       * @type {jQuery}
       */
      this.$form = $(this.element.form);
    }

    // If no Ajax callback URL was given, use the link href or form action.
    if (!this.url) {
      var $element = $(this.element);
      if ($element.is('a')) {
        this.url = $element.attr('href');
      }
      else if (this.element && element.form) {
        this.url = this.$form.attr('action');
      }
    }

    // Replacing 'nojs' with 'ajax' in the URL allows for an easy method to let
    // the server detect when it needs to degrade gracefully.
    // There are four scenarios to check for:
    // 1. /nojs/
    // 2. /nojs$ - The end of a URL string.
    // 3. /nojs? - Followed by a query (e.g. path/nojs?destination=foobar).
    // 4. /nojs# - Followed by a fragment (e.g.: path/nojs#myfragment).
    var originalUrl = this.url;

    /**
     * Processed Ajax URL.
     *
     * @type {string}
     */
    this.url = this.url.replace(/\/nojs(\/|$|\?|#)/g, '/ajax$1');
    // If the 'nojs' version of the URL is trusted, also trust the 'ajax'
    // version.
    if (drupalSettings.ajaxTrustedUrl[originalUrl]) {
      drupalSettings.ajaxTrustedUrl[this.url] = true;
    }

    // Set the options for the ajaxSubmit function.
    // The 'this' variable will not persist inside of the options object.
    var ajax = this;

    /**
     * Options for the jQuery.ajax function.
     *
     * @name Drupal.Ajax#options
     *
     * @type {object}
     *
     * @prop {string} url
     *   Ajax URL to be called.
     * @prop {object} data
     *   Ajax payload.
     * @prop {function} beforeSerialize
     *   Implement jQuery beforeSerialize function to call
     *   {@link Drupal.Ajax#beforeSerialize}.
     * @prop {function} beforeSubmit
     *   Implement jQuery beforeSubmit function to call
     *   {@link Drupal.Ajax#beforeSubmit}.
     * @prop {function} beforeSend
     *   Implement jQuery beforeSend function to call
     *   {@link Drupal.Ajax#beforeSend}.
     * @prop {function} success
     *   Implement jQuery success function to call
     *   {@link Drupal.Ajax#success}.
     * @prop {function} complete
     *   Implement jQuery success function to clean up ajax state and trigger an
     *   error if needed.
     * @prop {string} dataType='json'
     *   Type of the response expected.
     * @prop {string} type='POST'
     *   HTTP method to use for the Ajax request.
     */
    ajax.options = {
      url: ajax.url,
      data: ajax.submit,
      beforeSerialize: function (element_settings, options) {
        return ajax.beforeSerialize(element_settings, options);
      },
      beforeSubmit: function (form_values, element_settings, options) {
        ajax.ajaxing = true;
        return ajax.beforeSubmit(form_values, element_settings, options);
      },
      beforeSend: function (xmlhttprequest, options) {
        ajax.ajaxing = true;
        return ajax.beforeSend(xmlhttprequest, options);
      },
      success: function (response, status, xmlhttprequest) {
        // Sanity check for browser support (object expected).
        // When using iFrame uploads, responses must be returned as a string.
        if (typeof response === 'string') {
          response = $.parseJSON(response);
        }

        // Prior to invoking the response's commands, verify that they can be
        // trusted by checking for a response header. See
        // \Drupal\Core\EventSubscriber\AjaxResponseSubscriber for details.
        // - Empty responses are harmless so can bypass verification. This
        //   avoids an alert message for server-generated no-op responses that
        //   skip Ajax rendering.
        // - Ajax objects with trusted URLs (e.g., ones defined server-side via
        //   #ajax) can bypass header verification. This is especially useful
        //   for Ajax with multipart forms. Because IFRAME transport is used,
        //   the response headers cannot be accessed for verification.
        if (response !== null && !drupalSettings.ajaxTrustedUrl[ajax.url]) {
          if (xmlhttprequest.getResponseHeader('X-Drupal-Ajax-Token') !== '1') {
            var customMessage = Drupal.t('The response failed verification so will not be processed.');
            return ajax.error(xmlhttprequest, ajax.url, customMessage);
          }
        }

        return ajax.success(response, status);
      },
      complete: function (xmlhttprequest, status) {
        ajax.ajaxing = false;
        if (status === 'error' || status === 'parsererror') {
          return ajax.error(xmlhttprequest, ajax.url);
        }
      },
      dataType: 'json',
      type: 'POST'
    };

    if (element_settings.dialog) {
      ajax.options.data.dialogOptions = element_settings.dialog;
    }

    // Ensure that we have a valid URL by adding ? when no query parameter is
    // yet available, otherwise append using &.
    if (ajax.options.url.indexOf('?') === -1) {
      ajax.options.url += '?';
    }
    else {
      ajax.options.url += '&';
    }
    ajax.options.url += Drupal.ajax.WRAPPER_FORMAT + '=drupal_' + (element_settings.dialogType || 'ajax');

    // Bind the ajaxSubmit function to the element event.
    $(ajax.element).on(element_settings.event, function (event) {
      if (!drupalSettings.ajaxTrustedUrl[ajax.url] && !Drupal.url.isLocal(ajax.url)) {
        throw new Error(Drupal.t('The callback URL is not local and not trusted: !url', {'!url': ajax.url}));
      }
      return ajax.eventResponse(this, event);
    });

    // If necessary, enable keyboard submission so that Ajax behaviors
    // can be triggered through keyboard input as well as e.g. a mousedown
    // action.
    if (element_settings.keypress) {
      $(ajax.element).on('keypress', function (event) {
        return ajax.keypressResponse(this, event);
      });
    }

    // If necessary, prevent the browser default action of an additional event.
    // For example, prevent the browser default action of a click, even if the
    // Ajax behavior binds to mousedown.
    if (element_settings.prevent) {
      $(ajax.element).on(element_settings.prevent, false);
    }
  };

  /**
   * URL query attribute to indicate the wrapper used to render a request.
   *
   * The wrapper format determines how the HTML is wrapped, for example in a
   * modal dialog.
   *
   * @const {string}
   *
   * @default
   */
  Drupal.ajax.WRAPPER_FORMAT = '_wrapper_format';

  /**
   * Request parameter to indicate that a request is a Drupal Ajax request.
   *
   * @const {string}
   *
   * @default
   */
  Drupal.Ajax.AJAX_REQUEST_PARAMETER = '_drupal_ajax';

  /**
   * Execute the ajax request.
   *
   * Allows developers to execute an Ajax request manually without specifying
   * an event to respond to.
   *
   * @return {object}
   *   Returns the jQuery.Deferred object underlying the Ajax request. If
   *   pre-serialization fails, the Deferred will be returned in the rejected
   *   state.
   */
  Drupal.Ajax.prototype.execute = function () {
    // Do not perform another ajax command if one is already in progress.
    if (this.ajaxing) {
      return;
    }

    try {
      this.beforeSerialize(this.element, this.options);
      // Return the jqXHR so that external code can hook into the Deferred API.
      return $.ajax(this.options);
    }
    catch (e) {
      // Unset the ajax.ajaxing flag here because it won't be unset during
      // the complete response.
      this.ajaxing = false;
      window.alert('An error occurred while attempting to process ' + this.options.url + ': ' + e.message);
      // For consistency, return a rejected Deferred (i.e., jqXHR's superclass)
      // so that calling code can take appropriate action.
      return $.Deferred().reject();
    }
  };

  /**
   * Handle a key press.
   *
   * The Ajax object will, if instructed, bind to a key press response. This
   * will test to see if the key press is valid to trigger this event and
   * if it is, trigger it for us and prevent other keypresses from triggering.
   * In this case we're handling RETURN and SPACEBAR keypresses (event codes 13
   * and 32. RETURN is often used to submit a form when in a textfield, and
   * SPACE is often used to activate an element without submitting.
   *
   * @param {HTMLElement} element
   *   Element the event was triggered on.
   * @param {jQuery.Event} event
   *   Triggered event.
   */
  Drupal.Ajax.prototype.keypressResponse = function (element, event) {
    // Create a synonym for this to reduce code confusion.
    var ajax = this;

    // Detect enter key and space bar and allow the standard response for them,
    // except for form elements of type 'text', 'tel', 'number' and 'textarea',
    // where the spacebar activation causes inappropriate activation if
    // #ajax['keypress'] is TRUE. On a text-type widget a space should always
    // be a space.
    if (event.which === 13 || (event.which === 32 && element.type !== 'text' &&
      element.type !== 'textarea' && element.type !== 'tel' && element.type !== 'number')) {
      event.preventDefault();
      event.stopPropagation();
      $(ajax.element_settings.element).trigger(ajax.element_settings.event);
    }
  };

  /**
   * Handle an event that triggers an Ajax response.
   *
   * When an event that triggers an Ajax response happens, this method will
   * perform the actual Ajax call. It is bound to the event using
   * bind() in the constructor, and it uses the options specified on the
   * Ajax object.
   *
   * @param {HTMLElement} element
   *   Element the event was triggered on.
   * @param {jQuery.Event} event
   *   Triggered event.
   */
  Drupal.Ajax.prototype.eventResponse = function (element, event) {
    event.preventDefault();
    event.stopPropagation();

    // Create a synonym for this to reduce code confusion.
    var ajax = this;

    // Do not perform another Ajax command if one is already in progress.
    if (ajax.ajaxing) {
      return;
    }

    try {
      if (ajax.$form) {
        // If setClick is set, we must set this to ensure that the button's
        // value is passed.
        if (ajax.setClick) {
          // Mark the clicked button. 'form.clk' is a special variable for
          // ajaxSubmit that tells the system which element got clicked to
          // trigger the submit. Without it there would be no 'op' or
          // equivalent.
          element.form.clk = element;
        }

        ajax.$form.ajaxSubmit(ajax.options);
      }
      else {
        ajax.beforeSerialize(ajax.element, ajax.options);
        $.ajax(ajax.options);
      }
    }
    catch (e) {
      // Unset the ajax.ajaxing flag here because it won't be unset during
      // the complete response.
      ajax.ajaxing = false;
      window.alert('An error occurred while attempting to process ' + ajax.options.url + ': ' + e.message);
    }
  };

  /**
   * Handler for the form serialization.
   *
   * Runs before the beforeSend() handler (see below), and unlike that one, runs
   * before field data is collected.
   *
   * @param {object} [element]
   *   Ajax object's `element_settings`.
   * @param {object} options
   *   jQuery.ajax options.
   */
  Drupal.Ajax.prototype.beforeSerialize = function (element, options) {
    // Allow detaching behaviors to update field values before collecting them.
    // This is only needed when field values are added to the POST data, so only
    // when there is a form such that this.$form.ajaxSubmit() is used instead of
    // $.ajax(). When there is no form and $.ajax() is used, beforeSerialize()
    // isn't called, but don't rely on that: explicitly check this.$form.
    if (this.$form) {
      var settings = this.settings || drupalSettings;
      Drupal.detachBehaviors(this.$form.get(0), settings, 'serialize');
    }

    // Inform Drupal that this is an AJAX request.
    options.data[Drupal.Ajax.AJAX_REQUEST_PARAMETER] = 1;

    // Allow Drupal to return new JavaScript and CSS files to load without
    // returning the ones already loaded.
    // @see \Drupal\Core\Theme\AjaxBasePageNegotiator
    // @see \Drupal\Core\Asset\LibraryDependencyResolverInterface::getMinimalRepresentativeSubset()
    // @see system_js_settings_alter()
    var pageState = drupalSettings.ajaxPageState;
    options.data['ajax_page_state[theme]'] = pageState.theme;
    options.data['ajax_page_state[theme_token]'] = pageState.theme_token;
    options.data['ajax_page_state[libraries]'] = pageState.libraries;
  };

  /**
   * Modify form values prior to form submission.
   *
   * @param {Array.<object>} form_values
   *   Processed form values.
   * @param {jQuery} element
   *   The form node as a jQuery object.
   * @param {object} options
   *   jQuery.ajax options.
   */
  Drupal.Ajax.prototype.beforeSubmit = function (form_values, element, options) {
    // This function is left empty to make it simple to override for modules
    // that wish to add functionality here.
  };

  /**
   * Prepare the Ajax request before it is sent.
   *
   * @param {XMLHttpRequest} xmlhttprequest
   *   Native Ajax object.
   * @param {object} options
   *   jQuery.ajax options.
   */
  Drupal.Ajax.prototype.beforeSend = function (xmlhttprequest, options) {
    // For forms without file inputs, the jQuery Form plugin serializes the
    // form values, and then calls jQuery's $.ajax() function, which invokes
    // this handler. In this circumstance, options.extraData is never used. For
    // forms with file inputs, the jQuery Form plugin uses the browser's normal
    // form submission mechanism, but captures the response in a hidden IFRAME.
    // In this circumstance, it calls this handler first, and then appends
    // hidden fields to the form to submit the values in options.extraData.
    // There is no simple way to know which submission mechanism will be used,
    // so we add to extraData regardless, and allow it to be ignored in the
    // former case.
    if (this.$form) {
      options.extraData = options.extraData || {};

      // Let the server know when the IFRAME submission mechanism is used. The
      // server can use this information to wrap the JSON response in a
      // TEXTAREA, as per http://jquery.malsup.com/form/#file-upload.
      options.extraData.ajax_iframe_upload = '1';

      // The triggering element is about to be disabled (see below), but if it
      // contains a value (e.g., a checkbox, textfield, select, etc.), ensure
      // that value is included in the submission. As per above, submissions
      // that use $.ajax() are already serialized prior to the element being
      // disabled, so this is only needed for IFRAME submissions.
      var v = $.fieldValue(this.element);
      if (v !== null) {
        options.extraData[this.element.name] = v;
      }
    }

    // Disable the element that received the change to prevent user interface
    // interaction while the Ajax request is in progress. ajax.ajaxing prevents
    // the element from triggering a new request, but does not prevent the user
    // from changing its value.
    $(this.element).prop('disabled', true);

    if (!this.progress || !this.progress.type) {
      return;
    }

    // Insert progress indicator.
    var progressIndicatorMethod = 'setProgressIndicator' + this.progress.type.slice(0, 1).toUpperCase() + this.progress.type.slice(1).toLowerCase();
    if (progressIndicatorMethod in this && typeof this[progressIndicatorMethod] === 'function') {
      this[progressIndicatorMethod].call(this);
    }
  };

  /**
   * Sets the progress bar progress indicator.
   */
  Drupal.Ajax.prototype.setProgressIndicatorBar = function () {
    var progressBar = new Drupal.ProgressBar('ajax-progress-' + this.element.id, $.noop, this.progress.method, $.noop);
    if (this.progress.message) {
      progressBar.setProgress(-1, this.progress.message);
    }
    if (this.progress.url) {
      progressBar.startMonitoring(this.progress.url, this.progress.interval || 1500);
    }
    this.progress.element = $(progressBar.element).addClass('ajax-progress ajax-progress-bar');
    this.progress.object = progressBar;
    $(this.element).after(this.progress.element);
  };

  /**
   * Sets the throbber progress indicator.
   */
  Drupal.Ajax.prototype.setProgressIndicatorThrobber = function () {
    this.progress.element = $('<div class="ajax-progress ajax-progress-throbber"><div class="throbber">&nbsp;</div></div>');
    if (this.progress.message) {
      this.progress.element.find('.throbber').after('<div class="message">' + this.progress.message + '</div>');
    }
    $(this.element).after(this.progress.element);
  };

  /**
   * Sets the fullscreen progress indicator.
   */
  Drupal.Ajax.prototype.setProgressIndicatorFullscreen = function () {
    this.progress.element = $('<div class="ajax-progress ajax-progress-fullscreen">&nbsp;</div>');
    $('body').after(this.progress.element);
  };

  /**
   * Handler for the form redirection completion.
   *
   * @param {Array.<Drupal.AjaxCommands~commandDefinition>} response
   *   Drupal Ajax response.
   * @param {number} status
   *   XMLHttpRequest status.
   */
  Drupal.Ajax.prototype.success = function (response, status) {
    // Remove the progress element.
    if (this.progress.element) {
      $(this.progress.element).remove();
    }
    if (this.progress.object) {
      this.progress.object.stopMonitoring();
    }
    $(this.element).prop('disabled', false);

    // Save element's ancestors tree so if the element is removed from the dom
    // we can try to refocus one of its parents. Using addBack reverse the
    // result array, meaning that index 0 is the highest parent in the hierarchy
    // in this situation it is usually a <form> element.
    var elementParents = $(this.element).parents('[data-drupal-selector]').addBack().toArray();

    // Track if any command is altering the focus so we can avoid changing the
    // focus set by the Ajax command.
    var focusChanged = false;
    for (var i in response) {
      if (response.hasOwnProperty(i) && response[i].command && this.commands[response[i].command]) {
        this.commands[response[i].command](this, response[i], status);
        if (response[i].command === 'invoke' && response[i].method === 'focus') {
          focusChanged = true;
        }
      }
    }

    // If the focus hasn't be changed by the ajax commands, try to refocus the
    // triggering element or one of its parents if that element does not exist
    // anymore.
    if (!focusChanged && this.element && !$(this.element).data('disable-refocus')) {
      var target = false;

      for (var n = elementParents.length - 1; !target && n > 0; n--) {
        target = document.querySelector('[data-drupal-selector="' + elementParents[n].getAttribute('data-drupal-selector') + '"]');
      }

      if (target) {
        $(target).trigger('focus');
      }
    }

    // Reattach behaviors, if they were detached in beforeSerialize(). The
    // attachBehaviors() called on the new content from processing the response
    // commands is not sufficient, because behaviors from the entire form need
    // to be reattached.
    if (this.$form) {
      var settings = this.settings || drupalSettings;
      Drupal.attachBehaviors(this.$form.get(0), settings);
    }

    // Remove any response-specific settings so they don't get used on the next
    // call by mistake.
    this.settings = null;
  };

  /**
   * Build an effect object to apply an effect when adding new HTML.
   *
   * @param {object} response
   *   Drupal Ajax response.
   * @param {string} [response.effect]
   *   Override the default value of {@link Drupal.Ajax#element_settings}.
   * @param {string|number} [response.speed]
   *   Override the default value of {@link Drupal.Ajax#element_settings}.
   *
   * @return {object}
   *   Returns an object with `showEffect`, `hideEffect` and `showSpeed`
   *   properties.
   */
  Drupal.Ajax.prototype.getEffect = function (response) {
    var type = response.effect || this.effect;
    var speed = response.speed || this.speed;

    var effect = {};
    if (type === 'none') {
      effect.showEffect = 'show';
      effect.hideEffect = 'hide';
      effect.showSpeed = '';
    }
    else if (type === 'fade') {
      effect.showEffect = 'fadeIn';
      effect.hideEffect = 'fadeOut';
      effect.showSpeed = speed;
    }
    else {
      effect.showEffect = type + 'Toggle';
      effect.hideEffect = type + 'Toggle';
      effect.showSpeed = speed;
    }

    return effect;
  };

  /**
   * Handler for the form redirection error.
   *
   * @param {object} xmlhttprequest
   *   Native XMLHttpRequest object.
   * @param {string} uri
   *   Ajax Request URI.
   * @param {string} [customMessage]
   *   Extra message to print with the Ajax error.
   */
  Drupal.Ajax.prototype.error = function (xmlhttprequest, uri, customMessage) {
    // Remove the progress element.
    if (this.progress.element) {
      $(this.progress.element).remove();
    }
    if (this.progress.object) {
      this.progress.object.stopMonitoring();
    }
    // Undo hide.
    $(this.wrapper).show();
    // Re-enable the element.
    $(this.element).prop('disabled', false);
    // Reattach behaviors, if they were detached in beforeSerialize().
    if (this.$form) {
      var settings = this.settings || drupalSettings;
      Drupal.attachBehaviors(this.$form.get(0), settings);
    }
    throw new Drupal.AjaxError(xmlhttprequest, uri, customMessage);
  };

  /**
   * @typedef {object} Drupal.AjaxCommands~commandDefinition
   *
   * @prop {string} command
   * @prop {string} [method]
   * @prop {string} [selector]
   * @prop {string} [data]
   * @prop {object} [settings]
   * @prop {bool} [asterisk]
   * @prop {string} [text]
   * @prop {string} [title]
   * @prop {string} [url]
   * @prop {object} [argument]
   * @prop {string} [name]
   * @prop {string} [value]
   * @prop {string} [old]
   * @prop {string} [new]
   * @prop {bool} [merge]
   * @prop {Array} [args]
   *
   * @see Drupal.AjaxCommands
   */

  /**
   * Provide a series of commands that the client will perform.
   *
   * @constructor
   */
  Drupal.AjaxCommands = function () {};
  Drupal.AjaxCommands.prototype = {

    /**
     * Command to insert new content into the DOM.
     *
     * @param {Drupal.Ajax} ajax
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.data
     *   The data to use with the jQuery method.
     * @param {string} [response.method]
     *   The jQuery DOM manipulation method to be used.
     * @param {string} [response.selector]
     *   A optional jQuery selector string.
     * @param {object} [response.settings]
     *   An optional array of settings that will be used.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    insert: function (ajax, response, status) {
      // Get information from the response. If it is not there, default to
      // our presets.
      var $wrapper = response.selector ? $(response.selector) : $(ajax.wrapper);
      var method = response.method || ajax.method;
      var effect = ajax.getEffect(response);
      var settings;

      // We don't know what response.data contains: it might be a string of text
      // without HTML, so don't rely on jQuery correctly interpreting
      // $(response.data) as new HTML rather than a CSS selector. Also, if
      // response.data contains top-level text nodes, they get lost with either
      // $(response.data) or $('<div></div>').replaceWith(response.data).
      var $new_content_wrapped = $('<div></div>').html(response.data);
      var $new_content = $new_content_wrapped.contents();

      // For legacy reasons, the effects processing code assumes that
      // $new_content consists of a single top-level element. Also, it has not
      // been sufficiently tested whether attachBehaviors() can be successfully
      // called with a context object that includes top-level text nodes.
      // However, to give developers full control of the HTML appearing in the
      // page, and to enable Ajax content to be inserted in places where <div>
      // elements are not allowed (e.g., within <table>, <tr>, and <span>
      // parents), we check if the new content satisfies the requirement
      // of a single top-level element, and only use the container <div> created
      // above when it doesn't. For more information, please see
      // https://www.drupal.org/node/736066.
      if ($new_content.length !== 1 || $new_content.get(0).nodeType !== 1) {
        $new_content = $new_content_wrapped;
      }

      // If removing content from the wrapper, detach behaviors first.
      switch (method) {
        case 'html':
        case 'replaceWith':
        case 'replaceAll':
        case 'empty':
        case 'remove':
          settings = response.settings || ajax.settings || drupalSettings;
          Drupal.detachBehaviors($wrapper.get(0), settings);
      }

      // Add the new content to the page.
      $wrapper[method]($new_content);

      // Immediately hide the new content if we're using any effects.
      if (effect.showEffect !== 'show') {
        $new_content.hide();
      }

      // Determine which effect to use and what content will receive the
      // effect, then show the new content.
      if ($new_content.find('.ajax-new-content').length > 0) {
        $new_content.find('.ajax-new-content').hide();
        $new_content.show();
        $new_content.find('.ajax-new-content')[effect.showEffect](effect.showSpeed);
      }
      else if (effect.showEffect !== 'show') {
        $new_content[effect.showEffect](effect.showSpeed);
      }

      // Attach all JavaScript behaviors to the new content, if it was
      // successfully added to the page, this if statement allows
      // `#ajax['wrapper']` to be optional.
      if ($new_content.parents('html').length > 0) {
        // Apply any settings from the returned JSON if available.
        settings = response.settings || ajax.settings || drupalSettings;
        Drupal.attachBehaviors($new_content.get(0), settings);
      }
    },

    /**
     * Command to remove a chunk from the page.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.selector
     *   A jQuery selector string.
     * @param {object} [response.settings]
     *   An optional array of settings that will be used.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    remove: function (ajax, response, status) {
      var settings = response.settings || ajax.settings || drupalSettings;
      $(response.selector).each(function () {
        Drupal.detachBehaviors(this, settings);
      })
        .remove();
    },

    /**
     * Command to mark a chunk changed.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The JSON response object from the Ajax request.
     * @param {string} response.selector
     *   A jQuery selector string.
     * @param {bool} [response.asterisk]
     *   An optional CSS selector. If specified, an asterisk will be
     *   appended to the HTML inside the provided selector.
     * @param {number} [status]
     *   The request status.
     */
    changed: function (ajax, response, status) {
      var $element = $(response.selector);
      if (!$element.hasClass('ajax-changed')) {
        $element.addClass('ajax-changed');
        if (response.asterisk) {
          $element.find(response.asterisk).append(' <abbr class="ajax-changed" title="' + Drupal.t('Changed') + '">*</abbr> ');
        }
      }
    },

    /**
     * Command to provide an alert.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The JSON response from the Ajax request.
     * @param {string} response.text
     *   The text that will be displayed in an alert dialog.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    alert: function (ajax, response, status) {
      window.alert(response.text, response.title);
    },

    /**
     * Command to set the window.location, redirecting the browser.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.url
     *   The URL to redirect to.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    redirect: function (ajax, response, status) {
      window.location = response.url;
    },

    /**
     * Command to provide the jQuery css() function.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.selector
     *   A jQuery selector string.
     * @param {object} response.argument
     *   An array of key/value pairs to set in the CSS for the selector.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    css: function (ajax, response, status) {
      $(response.selector).css(response.argument);
    },

    /**
     * Command to set the settings used for other commands in this response.
     *
     * This method will also remove expired `drupalSettings.ajax` settings.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {bool} response.merge
     *   Determines whether the additional settings should be merged to the
     *   global settings.
     * @param {object} response.settings
     *   Contains additional settings to add to the global settings.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    settings: function (ajax, response, status) {
      var ajaxSettings = drupalSettings.ajax;

      // Clean up drupalSettings.ajax.
      Drupal.ajax.expired().forEach(function (instance) {
        // If the Ajax object has been created through drupalSettings.ajax
        // it will have a selector. When there is no selector the object
        // has been initialized with a special class name picked up by the
        // Ajax behavior.
        if (instance.selector) {
          var selector = instance.selector.replace('#', '');
          if (ajaxSettings && selector in ajaxSettings) {
            delete ajaxSettings[selector];
          }
        }
      });

      if (response.merge) {
        $.extend(true, drupalSettings, response.settings);
      }
      else {
        ajax.settings = response.settings;
      }
    },

    /**
     * Command to attach data using jQuery's data API.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.name
     *   The name or key (in the key value pair) of the data attached to this
     *   selector.
     * @param {string} response.selector
     *   A jQuery selector string.
     * @param {string|object} response.value
     *   The value of to be attached.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    data: function (ajax, response, status) {
      $(response.selector).data(response.name, response.value);
    },

    /**
     * Command to apply a jQuery method.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {Array} response.args
     *   An array of arguments to the jQuery method, if any.
     * @param {string} response.method
     *   The jQuery method to invoke.
     * @param {string} response.selector
     *   A jQuery selector string.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    invoke: function (ajax, response, status) {
      var $element = $(response.selector);
      $element[response.method].apply($element, response.args);
    },

    /**
     * Command to restripe a table.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.selector
     *   A jQuery selector string.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    restripe: function (ajax, response, status) {
      // :even and :odd are reversed because jQuery counts from 0 and
      // we count from 1, so we're out of sync.
      // Match immediate children of the parent element to allow nesting.
      $(response.selector).find('> tbody > tr:visible, > tr:visible')
        .removeClass('odd even')
        .filter(':even').addClass('odd').end()
        .filter(':odd').addClass('even');
    },

    /**
     * Command to update a form's build ID.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.old
     *   The old form build ID.
     * @param {string} response.new
     *   The new form build ID.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    update_build_id: function (ajax, response, status) {
      $('input[name="form_build_id"][value="' + response.old + '"]').val(response.new);
    },

    /**
     * Command to add css.
     *
     * Uses the proprietary addImport method if available as browsers which
     * support that method ignore @import statements in dynamically added
     * stylesheets.
     *
     * @param {Drupal.Ajax} [ajax]
     *   {@link Drupal.Ajax} object created by {@link Drupal.ajax}.
     * @param {object} response
     *   The response from the Ajax request.
     * @param {string} response.data
     *   A string that contains the styles to be added.
     * @param {number} [status]
     *   The XMLHttpRequest status.
     */
    add_css: function (ajax, response, status) {
      // Add the styles in the normal way.
      $('head').prepend(response.data);
      // Add imports in the styles using the addImport method if available.
      var match;
      var importMatch = /^@import url\("(.*)"\);$/igm;
      if (document.styleSheets[0].addImport && importMatch.test(response.data)) {
        importMatch.lastIndex = 0;
        do {
          match = importMatch.exec(response.data);
          document.styleSheets[0].addImport(match[1]);
        } while (match);
      }
    }
  };

})(jQuery, window, Drupal, drupalSettings);
;
/**
 * @file
 * Extends methods from core/misc/ajax.js.
 */

(function ($, window, Drupal, drupalSettings) {

  /**
   * Attempts to find the closest glyphicon progress indicator.
   *
   * @param {jQuery|Element} element
   *   A DOM element.
   *
   * @returns {jQuery}
   *   A jQuery object.
   */
  Drupal.Ajax.prototype.findGlyphicon = function (element) {
    return $(element).closest('.form-item').find('.ajax-progress.glyphicon')
  };

  /**
   * Starts the spinning of the glyphicon progress indicator.
   *
   * @param {jQuery|Element} element
   *   A DOM element.
   * @param {string} [message]
   *   An optional message to display (tooltip) for the progress.
   *
   * @returns {jQuery}
   *   A jQuery object.
   */
  Drupal.Ajax.prototype.glyphiconStart = function (element, message) {
    var $glyphicon = this.findGlyphicon(element);
    if ($glyphicon[0]) {
      $glyphicon.addClass('glyphicon-spin');

      // Add any message as a tooltip to the glyphicon.
      if (drupalSettings.bootstrap.tooltip_enabled) {
        $glyphicon
          .removeAttr('data-toggle')
          .removeAttr('data-original-title')
          .removeAttr('title')
          .tooltip('destroy')
        ;

        if (message) {
          $glyphicon.attr('data-toggle', 'tooltip').attr('title', message).tooltip();
        }
      }

      // Append a message for screen readers.
      if (message) {
        $glyphicon.parent().append('<div class="sr-only message">' + message + '</div>');
      }
    }
    return $glyphicon;
  };

  /**
   * Stop the spinning of a glyphicon progress indicator.
   *
   * @param {jQuery|Element} element
   *   A DOM element.
   */
  Drupal.Ajax.prototype.glyphiconStop = function (element) {
    var $glyphicon = this.findGlyphicon(element);
    if ($glyphicon[0]) {
      $glyphicon.removeClass('glyphicon-spin');
      if (drupalSettings.bootstrap.tooltip_enabled) {
        $glyphicon
          .removeAttr('data-toggle')
          .removeAttr('data-original-title')
          .removeAttr('title')
          .tooltip('destroy')
        ;
      }
    }
  };

  /**
   * Sets the throbber progress indicator.
   */
  Drupal.Ajax.prototype.setProgressIndicatorThrobber = function () {
    var $element = $(this.element);

    // Find an existing glyphicon progress indicator.
    var $glyphicon = this.glyphiconStart($element, this.progress.message);
    if ($glyphicon[0]) {
      this.progress.element = $glyphicon.parent();
      this.progress.glyphicon = true;
      return;
    }

    // Otherwise, add a glyphicon throbber after the element.
    if (!this.progress.element) {
      this.progress.element = $(Drupal.theme('ajaxThrobber'));
    }
    if (this.progress.message) {
      this.progress.element.after('<div class="message">' + this.progress.message + '</div>');
    }

    // If element is an input DOM element type (not :input), append after.
    if ($element.is('input')) {
      $element.after(this.progress.element);
    }
    // Otherwise append the throbber inside the element.
    else {
      $element.append(this.progress.element);
    }
  };


  /**
   * Handler for the form redirection completion.
   *
   * @param {Array.<Drupal.AjaxCommands~commandDefinition>} response
   * @param {number} status
   */
  Drupal.Ajax.prototype.success = function (response, status) {
    if (this.progress.element) {

      // Stop a glyphicon throbber.
      if (this.progress.glyphicon) {
        this.glyphiconStop(this.progress.element);
      }
      // Remove the progress element.
      else {
        this.progress.element.remove();
      }

      // Remove any message set.
      this.progress.element.parent().find('.message').remove();
    }

    // --------------------------------------------------------
    // Everything below is from core/misc/ajax.js.
    // --------------------------------------------------------

    if (this.progress.object) {
      this.progress.object.stopMonitoring();
    }
    $(this.element).prop('disabled', false);

    // Save element's ancestors tree so if the element is removed from the dom
    // we can try to refocus one of its parents. Using addBack reverse the
    // result array, meaning that index 0 is the highest parent in the hierarchy
    // in this situation it is usually a <form> element.
    var elementParents = $(this.element).parents('[data-drupal-selector]').addBack().toArray();

    // Track if any command is altering the focus so we can avoid changing the
    // focus set by the Ajax command.
    var focusChanged = false;
    for (var i in response) {
      if (response.hasOwnProperty(i) && response[i].command && this.commands[response[i].command]) {
        this.commands[response[i].command](this, response[i], status);
        if (response[i].command === 'invoke' && response[i].method === 'focus') {
          focusChanged = true;
        }
      }
    }

    // If the focus hasn't be changed by the ajax commands, try to refocus the
    // triggering element or one of its parents if that element does not exist
    // anymore.
    if (!focusChanged && this.element && !$(this.element).data('disable-refocus')) {
      var target = false;

      for (var n = elementParents.length - 1; !target && n > 0; n--) {
        target = document.querySelector('[data-drupal-selector="' + elementParents[n].getAttribute('data-drupal-selector') + '"]');
      }

      if (target) {
        $(target).trigger('focus');
      }
    }

    // Reattach behaviors, if they were detached in beforeSerialize(). The
    // attachBehaviors() called on the new content from processing the response
    // commands is not sufficient, because behaviors from the entire form need
    // to be reattached.
    if (this.$form) {
      var settings = this.settings || drupalSettings;
      Drupal.attachBehaviors(this.$form.get(0), settings);
    }

    // Remove any response-specific settings so they don't get used on the next
    // call by mistake.
    this.settings = null;
  };

})(jQuery, this, Drupal, drupalSettings);
;
/**
 * @file
 * Bootstrap Modals.
 */
(function ($, Drupal, Bootstrap) {
  "use strict";

  /**
   * Extend the Bootstrap Modal plugin constructor class.
   */
  Bootstrap.extendPlugin('modal', function (settings) {
    return {
      DEFAULTS: {
        animation: !!settings.modal_animation,
        backdrop: settings.modal_backdrop === 'static' ? 'static' : !!settings.modal_backdrop,
        keyboard: !!settings.modal_keyboard,
        show: !!settings.modal_show,
        size: settings.modal_size
      }
    };
  });

  /**
   * Replace the Bootstrap Modal jQuery plugin definition.
   *
   * Replacing this is needed so that the "option" method can return values.
   */
  Bootstrap.replacePlugin('modal', function () {
    var Modal = this;

    // Extract the arguments.
    var args = Array.prototype.slice.call(arguments, 1);

    // Modal jQuery Plugin Definition.
    return function (option, _relatedTarget) {
      var ret = void(0);
      this.each(function () {
        var $this   = $(this);
        var data    = $this.data('bs.modal');
        var options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option == 'object' && option);

        if (!data) $this.data('bs.modal', (data = new Modal(this, options)));
        if (typeof option == 'string') ret = data[option].apply(data, args);
        else if (options.show) data.show(_relatedTarget);
      });

      // If just one element and there was a result returned for the option passed,
      // then return the result. Otherwise, just return the jQuery object.
      return this.length === 1 && ret !== void(0) ? ret : this;
    }
  });

  /**
   * Extend Drupal theming functions.
   */
  $.extend(Drupal.theme, /** @lend Drupal.theme */ {
    /**
     * Theme function for a Bootstrap Modal.
     *
     * @param {object}[variables]
     *   An object with the following keys:
     *   - title: The name of the tab.
     *
     * @return {string}
     *   The HTML for the modal.
     */
    bootstrapModal: function (variables) {
      var settings = drupalSettings.bootstrap || {};
      var defaults = {
        body: '',
        closeButton: true,
        description: {
          content: null,
          position: 'before'
        },
        footer: '',
        id: 'drupal-modal',
        size: settings.modal_size ? settings.modal_size : '',
        title: Drupal.t('Loading...')
      };
      variables = $.extend(true, {}, defaults, variables);
      var output = '';

      // Build the modal wrapper.
      var classes = ['modal'];
      if (settings.modal_animation) {
        classes.push('fade');
      }
      output += '<div id="' + variables.id + '" class="' + classes.join(' ') + '" tabindex="-1" role="dialog">';

      // Build the modal-dialog wrapper.
      var dialogClasses = ['modal-dialog'];
      if (variables.size) {
        // @todo This should really be a clean CSS class method instead.
        dialogClasses.push(Drupal.checkPlain(variables.size));
      }
      output += '<div class="' + dialogClasses.join(' ') + '" role="document">';

      // Build the modal-content wrapper.
      output += '<div class="modal-content">';

      // Build the header wrapper and title.
      output += Drupal.theme.bootstrapModalHeader(variables.title, variables.closeButton);

      // Build the body.
      output += Drupal.theme.bootstrapModalBody(variables.id + '--body', variables.body, variables.description);

      // Build the footer.
      output += Drupal.theme.bootstrapModalFooter(variables.footer);

      // Close the modal-content wrapper.
      output += '</div>';

      // Close the modal-dialog wrapper.
      output += '</div>';

      // Close the modal wrapper.
      output += '</div>';

      // Return the constructed modal.
      return output;
    },

    /**
     * Theme function for a Bootstrap Modal body markup.
     *
     * @param {string} id
     *   A unique ID for the modal body div.
     * @param {string} body
     *   The HTML markup to place in the body.
     * @param {string|object} description
     *   A description to show. Can either be a string or an object with the
     *   following key/value pairs:
     *   - content: The description value.
     *   - position: (optional) A display setting that can have these values:
     *     - before: The description is displayed before the body. This is the
     *       default value.
     *     - after: The description is display after the body.
     *     - invisible: The description is displayed after the element, hidden
     *       visually but available to screen readers.
     *
     * @return {string}
     *   The HTML for the modal close button.
     */
    bootstrapModalBody: function (id, body, description) {
      var output = '';
      output += '<div id="' + id + '" class="modal-body">';
      if (!description || !$.isPlainObject(description)) {
        description = { content: description};
      }
      description = $.extend({ position: 'before' }, description);

      var descriptionClasses = ['help-block'];
      if (description.content && description.position === 'invisible') {
        descriptionClasses.push('sr-only');
      }
      if (description.content && description.position === 'before') {
        output += '<p class="' + descriptionClasses.join(' ') + '">' + description.content + '</p>';
      }
      output += body;
      if (description.content && (description.position === 'after' || description.position === 'invisible')) {
        output += '<p class="' + descriptionClasses.join(' ') + '">' + description.content + '</p>';
      }
      output += '</div>';
      return output;
    },

    /**
     * Theme function for a Bootstrap Modal close button.
     *
     * @return {string}
     *   The HTML for the modal close button.
     */
    bootstrapModalClose: function () {
      return '<button type="button" class="close" data-dismiss="modal" aria-label="' + Drupal.t('Close') + '"><span aria-hidden="true">&times;</span></button>';
    },

    /**
     * Theme function for a Bootstrap Modal footer.
     *
     * @param {string} [footer]
     *   The HTML markup to place in the footer.
     * @param {boolean} [force]
     *   Flag to force the rendering of the footer.
     *
     * @return {string}
     *   The HTML for the modal footer.
     */
    bootstrapModalFooter: function (footer, force) {
      return footer || force ? '<div class="modal-footer">' + (footer || '') + '</div>' : '';
    },

    /**
     * Theme function for a Bootstrap Modal header.
     *
     * @param {string} [title]
     *   The title for the header.
     * @param {boolean} [closeButton]
     *   Flag indicating whether or not to show the close button in the header.
     *
     * @return {string}
     *   The HTML for the modal header.
     */
    bootstrapModalHeader: function (title, closeButton) {
      var output = '';
      if (title) {
        closeButton = closeButton !== void(0) ? closeButton : true;
        output += '<div class="modal-header">';
        if (closeButton) {
          output += Drupal.theme.bootstrapModalClose();
        }
        output += '<h4 class="modal-title">' + Drupal.checkPlain(title) + '</h4>';
        output += '</div>';
      }
      return output;
    }
  })

})(window.jQuery, window.Drupal, window.Drupal.bootstrap);
;
/**
 * @file
 * Dialog API inspired by HTML5 dialog element.
 *
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/commands.html#the-dialog-element
 */

(function ($, Drupal, drupalSettings) {

  'use strict';

  /**
   * Default dialog options.
   *
   * @type {object}
   *
   * @prop {bool} [autoOpen=true]
   * @prop {string} [dialogClass='']
   * @prop {string} [buttonClass='button']
   * @prop {string} [buttonPrimaryClass='button--primary']
   * @prop {function} close
   */
  drupalSettings.dialog = {
    autoOpen: true,
    dialogClass: '',
    // Drupal-specific extensions: see dialog.jquery-ui.js.
    buttonClass: 'button',
    buttonPrimaryClass: 'button--primary',
    // When using this API directly (when generating dialogs on the client
    // side), you may want to override this method and do
    // `jQuery(event.target).remove()` as well, to remove the dialog on
    // closing.
    close: function (event) {
      Drupal.detachBehaviors(event.target, null, 'unload');
    }
  };

  /**
   * @typedef {object} Drupal.dialog~dialogDefinition
   *
   * @prop {boolean} open
   *   Is the dialog open or not.
   * @prop {*} returnValue
   *   Return value of the dialog.
   * @prop {function} show
   *   Method to display the dialog on the page.
   * @prop {function} showModal
   *   Method to display the dialog as a modal on the page.
   * @prop {function} close
   *   Method to hide the dialog from the page.
   */

  /**
   * Polyfill HTML5 dialog element with jQueryUI.
   *
   * @param {HTMLElement} element
   * @param {object} options
   *   jQuery UI options to be passed to the dialog.
   *
   * @return {Drupal.dialog~dialogDefinition}
   */
  Drupal.dialog = function (element, options) {
    var $element = $(element);

    function openDialog(settings) {
      settings = $.extend({}, drupalSettings.dialog, options, settings);
      // Trigger a global event to allow scripts to bind events to the dialog.
      $(window).trigger('dialog:beforecreate', [dialog, $element, settings]);
      $element
        .modal(settings)
        .on('shown.bs.modal.drupal', function () {
          dialog.open = true;
          $(window).trigger('dialog:aftercreate', [dialog, $element, settings]);
        })
      ;
    }

    function closeDialog(value) {
      $(window).trigger('dialog:beforeclose', [dialog, $element]);
      $element
        .on('hidden.bs.modal.drupal', function () {
          dialog.returnValue = value;
          dialog.open = false;
          $(window).trigger('dialog:afterclose', [dialog, $element]);
        })
        .modal('hide');
    }

    var dialog = {
      open: false,
      returnValue: void(0),
      show: function () {
        openDialog({show: false});
      },
      showModal: function () {
        openDialog({show: true});
      },
      close: closeDialog
    };

    return dialog;
  };

})(jQuery, Drupal, drupalSettings);
;
/**
 * @file
 * Attaches behavior for the Quick Edit module.
 *
 * Everything happens asynchronously, to allow for:
 *   - dynamically rendered contextual links
 *   - asynchronously retrieved (and cached) per-field in-place editing metadata
 *   - asynchronous setup of in-place editable field and "Quick edit" link.
 *
 * To achieve this, there are several queues:
 *   - fieldsMetadataQueue: fields whose metadata still needs to be fetched.
 *   - fieldsAvailableQueue: queue of fields whose metadata is known, and for
 *     which it has been confirmed that the user has permission to edit them.
 *     However, FieldModels will only be created for them once there's a
 *     contextual link for their entity: when it's possible to initiate editing.
 *   - contextualLinksQueue: queue of contextual links on entities for which it
 *     is not yet known whether the user has permission to edit at >=1 of them.
 */

(function ($, _, Backbone, Drupal, drupalSettings, JSON, storage) {

  'use strict';

  var options = $.extend(drupalSettings.quickedit,
    // Merge strings on top of drupalSettings so that they are not mutable.
    {
      strings: {
        quickEdit: Drupal.t('Quick edit')
      }
    }
  );

  /**
   * Tracks fields without metadata. Contains objects with the following keys:
   *   - DOM el
   *   - String fieldID
   *   - String entityID
   */
  var fieldsMetadataQueue = [];

  /**
   * Tracks fields ready for use. Contains objects with the following keys:
   *   - DOM el
   *   - String fieldID
   *   - String entityID
   */
  var fieldsAvailableQueue = [];

  /**
   * Tracks contextual links on entities. Contains objects with the following
   * keys:
   *   - String entityID
   *   - DOM el
   *   - DOM region
   */
  var contextualLinksQueue = [];

  /**
   * Tracks how many instances exist for each unique entity. Contains key-value
   * pairs:
   * - String entityID
   * - Number count
   */
  var entityInstancesTracker = {};

  /**
   *
   * @type {Drupal~behavior}
   */
  Drupal.behaviors.quickedit = {
    attach: function (context) {
      // Initialize the Quick Edit app once per page load.
      $('body').once('quickedit-init').each(initQuickEdit);

      // Find all in-place editable fields, if any.
      var $fields = $(context).find('[data-quickedit-field-id]').once('quickedit');
      if ($fields.length === 0) {
        return;
      }

      // Process each entity element: identical entities that appear multiple
      // times will get a numeric identifier, starting at 0.
      $(context).find('[data-quickedit-entity-id]').once('quickedit').each(function (index, entityElement) {
        processEntity(entityElement);
      });

      // Process each field element: queue to be used or to fetch metadata.
      // When a field is being rerendered after editing, it will be processed
      // immediately. New fields will be unable to be processed immediately,
      // but will instead be queued to have their metadata fetched, which occurs
      // below in fetchMissingMetaData().
      $fields.each(function (index, fieldElement) {
        processField(fieldElement);
      });

      // Entities and fields on the page have been detected, try to set up the
      // contextual links for those entities that already have the necessary
      // meta- data in the client-side cache.
      contextualLinksQueue = _.filter(contextualLinksQueue, function (contextualLink) {
        return !initializeEntityContextualLink(contextualLink);
      });

      // Fetch metadata for any fields that are queued to retrieve it.
      fetchMissingMetadata(function (fieldElementsWithFreshMetadata) {
        // Metadata has been fetched, reprocess fields whose metadata was
        // missing.
        _.each(fieldElementsWithFreshMetadata, processField);

        // Metadata has been fetched, try to set up more contextual links now.
        contextualLinksQueue = _.filter(contextualLinksQueue, function (contextualLink) {
          return !initializeEntityContextualLink(contextualLink);
        });
      });
    },
    detach: function (context, settings, trigger) {
      if (trigger === 'unload') {
        deleteContainedModelsAndQueues($(context));
      }
    }
  };

  /**
   *
   * @namespace
   */
  Drupal.quickedit = {

    /**
     * A {@link Drupal.quickedit.AppView} instance.
     */
    app: null,

    /**
     * @type {object}
     *
     * @prop {Array.<Drupal.quickedit.EntityModel>} entities
     * @prop {Array.<Drupal.quickedit.FieldModel>} fields
     */
    collections: {
      // All in-place editable entities (Drupal.quickedit.EntityModel) on the
      // page.
      entities: null,
      // All in-place editable fields (Drupal.quickedit.FieldModel) on the page.
      fields: null
    },

    /**
     * In-place editors will register themselves in this object.
     *
     * @namespace
     */
    editors: {},

    /**
     * Per-field metadata that indicates whether in-place editing is allowed,
     * which in-place editor should be used, etc.
     *
     * @namespace
     */
    metadata: {

      /**
       * Check if a field exists in storage.
       *
       * @param {string} fieldID
       *   The field id to check.
       *
       * @return {bool}
       *   Whether it was found or not.
       */
      has: function (fieldID) {
        return storage.getItem(this._prefixFieldID(fieldID)) !== null;
      },

      /**
       * Add metadata to a field id.
       *
       * @param {string} fieldID
       *   The field ID to add data to.
       * @param {object} metadata
       *   Metadata to add.
       */
      add: function (fieldID, metadata) {
        storage.setItem(this._prefixFieldID(fieldID), JSON.stringify(metadata));
      },

      /**
       * Get a key from a field id.
       *
       * @param {string} fieldID
       *   The field ID to check.
       * @param {string} [key]
       *   The key to check. If empty, will return all metadata.
       *
       * @return {object|*}
       *   The value for the key, if defined. Otherwise will return all metadata
       *   for the specified field id.
       *
       */
      get: function (fieldID, key) {
        var metadata = JSON.parse(storage.getItem(this._prefixFieldID(fieldID)));
        return (typeof key === 'undefined') ? metadata : metadata[key];
      },

      /**
       * Prefix the field id.
       *
       * @param {string} fieldID
       *   The field id to prefix.
       *
       * @return {string}
       *   A prefixed field id.
       */
      _prefixFieldID: function (fieldID) {
        return 'Drupal.quickedit.metadata.' + fieldID;
      },

      /**
       * Unprefix the field id.
       *
       * @param {string} fieldID
       *   The field id to unprefix.
       *
       * @return {string}
       *   An unprefixed field id.
       */
      _unprefixFieldID: function (fieldID) {
        // Strip "Drupal.quickedit.metadata.", which is 26 characters long.
        return fieldID.substring(26);
      },

      /**
       * Intersection calculation.
       *
       * @param {Array} fieldIDs
       *   An array of field ids to compare to prefix field id.
       *
       * @return {Array}
       *   The intersection found.
       */
      intersection: function (fieldIDs) {
        var prefixedFieldIDs = _.map(fieldIDs, this._prefixFieldID);
        var intersection = _.intersection(prefixedFieldIDs, _.keys(sessionStorage));
        return _.map(intersection, this._unprefixFieldID);
      }
    }
  };

  // Clear the Quick Edit metadata cache whenever the current user's set of
  // permissions changes.
  var permissionsHashKey = Drupal.quickedit.metadata._prefixFieldID('permissionsHash');
  var permissionsHashValue = storage.getItem(permissionsHashKey);
  var permissionsHash = drupalSettings.user.permissionsHash;
  if (permissionsHashValue !== permissionsHash) {
    if (typeof permissionsHash === 'string') {
      _.chain(storage).keys().each(function (key) {
        if (key.substring(0, 26) === 'Drupal.quickedit.metadata.') {
          storage.removeItem(key);
        }
      });
    }
    storage.setItem(permissionsHashKey, permissionsHash);
  }

  /**
   * Detect contextual links on entities annotated by quickedit.
   *
   * Queue contextual links to be processed.
   *
   * @param {jQuery.Event} event
   *   The `drupalContextualLinkAdded` event.
   * @param {object} data
   *   An object containing the data relevant to the event.
   *
   * @listens event:drupalContextualLinkAdded
   */
  $(document).on('drupalContextualLinkAdded', function (event, data) {
    if (data.$region.is('[data-quickedit-entity-id]')) {
      // If the contextual link is cached on the client side, an entity instance
      // will not yet have been assigned. So assign one.
      if (!data.$region.is('[data-quickedit-entity-instance-id]')) {
        data.$region.once('quickedit');
        processEntity(data.$region.get(0));
      }
      var contextualLink = {
        entityID: data.$region.attr('data-quickedit-entity-id'),
        entityInstanceID: data.$region.attr('data-quickedit-entity-instance-id'),
        el: data.$el[0],
        region: data.$region[0]
      };
      // Set up contextual links for this, otherwise queue it to be set up
      // later.
      if (!initializeEntityContextualLink(contextualLink)) {
        contextualLinksQueue.push(contextualLink);
      }
    }
  });

  /**
   * Extracts the entity ID from a field ID.
   *
   * @param {string} fieldID
   *   A field ID: a string of the format
   *   `<entity type>/<id>/<field name>/<language>/<view mode>`.
   *
   * @return {string}
   *   An entity ID: a string of the format `<entity type>/<id>`.
   */
  function extractEntityID(fieldID) {
    return fieldID.split('/').slice(0, 2).join('/');
  }

  /**
   * Initialize the Quick Edit app.
   *
   * @param {HTMLElement} bodyElement
   *   This document's body element.
   */
  function initQuickEdit(bodyElement) {
    Drupal.quickedit.collections.entities = new Drupal.quickedit.EntityCollection();
    Drupal.quickedit.collections.fields = new Drupal.quickedit.FieldCollection();

    // Instantiate AppModel (application state) and AppView, which is the
    // controller of the whole in-place editing experience.
    Drupal.quickedit.app = new Drupal.quickedit.AppView({
      el: bodyElement,
      model: new Drupal.quickedit.AppModel(),
      entitiesCollection: Drupal.quickedit.collections.entities,
      fieldsCollection: Drupal.quickedit.collections.fields
    });
  }

  /**
   * Assigns the entity an instance ID.
   *
   * @param {HTMLElement} entityElement
   *   A Drupal Entity API entity's DOM element with a data-quickedit-entity-id
   *   attribute.
   */
  function processEntity(entityElement) {
    var entityID = entityElement.getAttribute('data-quickedit-entity-id');
    if (!entityInstancesTracker.hasOwnProperty(entityID)) {
      entityInstancesTracker[entityID] = 0;
    }
    else {
      entityInstancesTracker[entityID]++;
    }

    // Set the calculated entity instance ID for this element.
    var entityInstanceID = entityInstancesTracker[entityID];
    entityElement.setAttribute('data-quickedit-entity-instance-id', entityInstanceID);
  }

  /**
   * Fetch the field's metadata; queue or initialize it (if EntityModel exists).
   *
   * @param {HTMLElement} fieldElement
   *   A Drupal Field API field's DOM element with a data-quickedit-field-id
   *   attribute.
   */
  function processField(fieldElement) {
    var metadata = Drupal.quickedit.metadata;
    var fieldID = fieldElement.getAttribute('data-quickedit-field-id');
    var entityID = extractEntityID(fieldID);
    // Figure out the instance ID by looking at the ancestor
    // [data-quickedit-entity-id] element's data-quickedit-entity-instance-id
    // attribute.
    var entityElementSelector = '[data-quickedit-entity-id="' + entityID + '"]';
    var entityElement = $(fieldElement).closest(entityElementSelector);
    // In the case of a full entity view page, the entity title is rendered
    // outside of "the entity DOM node": it's rendered as the page title. So in
    // this case, we find the lowest common parent element (deepest in the tree)
    // and consider that the entity element.
    if (entityElement.length === 0) {
      var $lowestCommonParent = $(entityElementSelector).parents().has(fieldElement).first();
      entityElement = $lowestCommonParent.find(entityElementSelector);
    }
    var entityInstanceID = entityElement
      .get(0)
      .getAttribute('data-quickedit-entity-instance-id');

    // Early-return if metadata for this field is missing.
    if (!metadata.has(fieldID)) {
      fieldsMetadataQueue.push({
        el: fieldElement,
        fieldID: fieldID,
        entityID: entityID,
        entityInstanceID: entityInstanceID
      });
      return;
    }
    // Early-return if the user is not allowed to in-place edit this field.
    if (metadata.get(fieldID, 'access') !== true) {
      return;
    }

    // If an EntityModel for this field already exists (and hence also a "Quick
    // edit" contextual link), then initialize it immediately.
    if (Drupal.quickedit.collections.entities.findWhere({entityID: entityID, entityInstanceID: entityInstanceID})) {
      initializeField(fieldElement, fieldID, entityID, entityInstanceID);
    }
    // Otherwise: queue the field. It is now available to be set up when its
    // corresponding entity becomes in-place editable.
    else {
      fieldsAvailableQueue.push({el: fieldElement, fieldID: fieldID, entityID: entityID, entityInstanceID: entityInstanceID});
    }
  }

  /**
   * Initialize a field; create FieldModel.
   *
   * @param {HTMLElement} fieldElement
   *   The field's DOM element.
   * @param {string} fieldID
   *   The field's ID.
   * @param {string} entityID
   *   The field's entity's ID.
   * @param {string} entityInstanceID
   *   The field's entity's instance ID.
   */
  function initializeField(fieldElement, fieldID, entityID, entityInstanceID) {
    var entity = Drupal.quickedit.collections.entities.findWhere({
      entityID: entityID,
      entityInstanceID: entityInstanceID
    });

    $(fieldElement).addClass('quickedit-field');

    // The FieldModel stores the state of an in-place editable entity field.
    var field = new Drupal.quickedit.FieldModel({
      el: fieldElement,
      fieldID: fieldID,
      id: fieldID + '[' + entity.get('entityInstanceID') + ']',
      entity: entity,
      metadata: Drupal.quickedit.metadata.get(fieldID),
      acceptStateChange: _.bind(Drupal.quickedit.app.acceptEditorStateChange, Drupal.quickedit.app)
    });

    // Track all fields on the page.
    Drupal.quickedit.collections.fields.add(field);
  }

  /**
   * Fetches metadata for fields whose metadata is missing.
   *
   * Fields whose metadata is missing are tracked at fieldsMetadataQueue.
   *
   * @param {function} callback
   *   A callback function that receives field elements whose metadata will just
   *   have been fetched.
   */
  function fetchMissingMetadata(callback) {
    if (fieldsMetadataQueue.length) {
      var fieldIDs = _.pluck(fieldsMetadataQueue, 'fieldID');
      var fieldElementsWithoutMetadata = _.pluck(fieldsMetadataQueue, 'el');
      var entityIDs = _.uniq(_.pluck(fieldsMetadataQueue, 'entityID'), true);
      // Ensure we only request entityIDs for which we don't have metadata yet.
      entityIDs = _.difference(entityIDs, Drupal.quickedit.metadata.intersection(entityIDs));
      fieldsMetadataQueue = [];

      $.ajax({
        url: Drupal.url('quickedit/metadata'),
        type: 'POST',
        data: {
          'fields[]': fieldIDs,
          'entities[]': entityIDs
        },
        dataType: 'json',
        success: function (results) {
          // Store the metadata.
          _.each(results, function (fieldMetadata, fieldID) {
            Drupal.quickedit.metadata.add(fieldID, fieldMetadata);
          });

          callback(fieldElementsWithoutMetadata);
        }
      });
    }
  }

  /**
   * Loads missing in-place editor's attachments (JavaScript and CSS files).
   *
   * Missing in-place editors are those whose fields are actively being used on
   * the page but don't have.
   *
   * @param {function} callback
   *   Callback function to be called when the missing in-place editors (if any)
   *   have been inserted into the DOM. i.e. they may still be loading.
   */
  function loadMissingEditors(callback) {
    var loadedEditors = _.keys(Drupal.quickedit.editors);
    var missingEditors = [];
    Drupal.quickedit.collections.fields.each(function (fieldModel) {
      var metadata = Drupal.quickedit.metadata.get(fieldModel.get('fieldID'));
      if (metadata.access && _.indexOf(loadedEditors, metadata.editor) === -1) {
        missingEditors.push(metadata.editor);
        // Set a stub, to prevent subsequent calls to loadMissingEditors() from
        // loading the same in-place editor again. Loading an in-place editor
        // requires talking to a server, to download its JavaScript, then
        // executing its JavaScript, and only then its Drupal.quickedit.editors
        // entry will be set.
        Drupal.quickedit.editors[metadata.editor] = false;
      }
    });
    missingEditors = _.uniq(missingEditors);
    if (missingEditors.length === 0) {
      callback();
      return;
    }

    // @see https://www.drupal.org/node/2029999.
    // Create a Drupal.Ajax instance to load the form.
    var loadEditorsAjax = Drupal.ajax({
      url: Drupal.url('quickedit/attachments'),
      submit: {'editors[]': missingEditors}
    });
    // Implement a scoped insert AJAX command: calls the callback after all AJAX
    // command functions have been executed (hence the deferred calling).
    var realInsert = Drupal.AjaxCommands.prototype.insert;
    loadEditorsAjax.commands.insert = function (ajax, response, status) {
      _.defer(callback);
      realInsert(ajax, response, status);
    };
    // Trigger the AJAX request, which will should return AJAX commands to
    // insert any missing attachments.
    loadEditorsAjax.execute();
  }

  /**
   * Attempts to set up a "Quick edit" link and corresponding EntityModel.
   *
   * @param {object} contextualLink
   *   An object with the following properties:
   *     - String entityID: a Quick Edit entity identifier, e.g. "node/1" or
   *       "block_content/5".
   *     - String entityInstanceID: a Quick Edit entity instance identifier,
   *       e.g. 0, 1 or n (depending on whether it's the first, second, or n+1st
   *       instance of this entity).
   *     - DOM el: element pointing to the contextual links placeholder for this
   *       entity.
   *     - DOM region: element pointing to the contextual region of this entity.
   *
   * @return {bool}
   *   Returns true when a contextual the given contextual link metadata can be
   *   removed from the queue (either because the contextual link has been set
   *   up or because it is certain that in-place editing is not allowed for any
   *   of its fields). Returns false otherwise.
   */
  function initializeEntityContextualLink(contextualLink) {
    var metadata = Drupal.quickedit.metadata;
    // Check if the user has permission to edit at least one of them.
    function hasFieldWithPermission(fieldIDs) {
      for (var i = 0; i < fieldIDs.length; i++) {
        var fieldID = fieldIDs[i];
        if (metadata.get(fieldID, 'access') === true) {
          return true;
        }
      }
      return false;
    }

    // Checks if the metadata for all given field IDs exists.
    function allMetadataExists(fieldIDs) {
      return fieldIDs.length === metadata.intersection(fieldIDs).length;
    }

    // Find all fields for this entity instance and collect their field IDs.
    var fields = _.where(fieldsAvailableQueue, {
      entityID: contextualLink.entityID,
      entityInstanceID: contextualLink.entityInstanceID
    });
    var fieldIDs = _.pluck(fields, 'fieldID');

    // No fields found yet.
    if (fieldIDs.length === 0) {
      return false;
    }
    // The entity for the given contextual link contains at least one field that
    // the current user may edit in-place; instantiate EntityModel,
    // EntityDecorationView and ContextualLinkView.
    else if (hasFieldWithPermission(fieldIDs)) {
      var entityModel = new Drupal.quickedit.EntityModel({
        el: contextualLink.region,
        entityID: contextualLink.entityID,
        entityInstanceID: contextualLink.entityInstanceID,
        id: contextualLink.entityID + '[' + contextualLink.entityInstanceID + ']',
        label: Drupal.quickedit.metadata.get(contextualLink.entityID, 'label')
      });
      Drupal.quickedit.collections.entities.add(entityModel);
      // Create an EntityDecorationView associated with the root DOM node of the
      // entity.
      var entityDecorationView = new Drupal.quickedit.EntityDecorationView({
        el: contextualLink.region,
        model: entityModel
      });
      entityModel.set('entityDecorationView', entityDecorationView);

      // Initialize all queued fields within this entity (creates FieldModels).
      _.each(fields, function (field) {
        initializeField(field.el, field.fieldID, contextualLink.entityID, contextualLink.entityInstanceID);
      });
      fieldsAvailableQueue = _.difference(fieldsAvailableQueue, fields);

      // Initialization should only be called once. Use Underscore's once method
      // to get a one-time use version of the function.
      var initContextualLink = _.once(function () {
        var $links = $(contextualLink.el).find('.contextual-links');
        var contextualLinkView = new Drupal.quickedit.ContextualLinkView($.extend({
          el: $('<li class="quickedit"><a href="" role="button" aria-pressed="false"></a></li>').prependTo($links),
          model: entityModel,
          appModel: Drupal.quickedit.app.model
        }, options));
        entityModel.set('contextualLinkView', contextualLinkView);
      });

      // Set up ContextualLinkView after loading any missing in-place editors.
      loadMissingEditors(initContextualLink);

      return true;
    }
    // There was not at least one field that the current user may edit in-place,
    // even though the metadata for all fields within this entity is available.
    else if (allMetadataExists(fieldIDs)) {
      return true;
    }

    return false;
  }

  /**
   * Delete models and queue items that are contained within a given context.
   *
   * Deletes any contained EntityModels (plus their associated FieldModels and
   * ContextualLinkView) and FieldModels, as well as the corresponding queues.
   *
   * After EntityModels, FieldModels must also be deleted, because it is
   * possible in Drupal for a field DOM element to exist outside of the entity
   * DOM element, e.g. when viewing the full node, the title of the node is not
   * rendered within the node (the entity) but as the page title.
   *
   * Note: this will not delete an entity that is actively being in-place
   * edited.
   *
   * @param {jQuery} $context
   *   The context within which to delete.
   */
  function deleteContainedModelsAndQueues($context) {
    $context.find('[data-quickedit-entity-id]').addBack('[data-quickedit-entity-id]').each(function (index, entityElement) {
      // Delete entity model.
      var entityModel = Drupal.quickedit.collections.entities.findWhere({el: entityElement});
      if (entityModel) {
        var contextualLinkView = entityModel.get('contextualLinkView');
        contextualLinkView.undelegateEvents();
        contextualLinkView.remove();
        // Remove the EntityDecorationView.
        entityModel.get('entityDecorationView').remove();
        // Destroy the EntityModel; this will also destroy its FieldModels.
        entityModel.destroy();
      }

      // Filter queue.
      function hasOtherRegion(contextualLink) {
        return contextualLink.region !== entityElement;
      }

      contextualLinksQueue = _.filter(contextualLinksQueue, hasOtherRegion);
    });

    $context.find('[data-quickedit-field-id]').addBack('[data-quickedit-field-id]').each(function (index, fieldElement) {
      // Delete field models.
      Drupal.quickedit.collections.fields.chain()
        .filter(function (fieldModel) { return fieldModel.get('el') === fieldElement; })
        .invoke('destroy');

      // Filter queues.
      function hasOtherFieldElement(field) {
        return field.el !== fieldElement;
      }

      fieldsMetadataQueue = _.filter(fieldsMetadataQueue, hasOtherFieldElement);
      fieldsAvailableQueue = _.filter(fieldsAvailableQueue, hasOtherFieldElement);
    });
  }

})(jQuery, _, Backbone, Drupal, drupalSettings, window.JSON, window.sessionStorage);
;
/**
 * @file
 * Provides utility functions for Quick Edit.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * @namespace
   */
  Drupal.quickedit.util = Drupal.quickedit.util || {};

  /**
   * @namespace
   */
  Drupal.quickedit.util.constants = {};

  /**
   *
   * @type {string}
   */
  Drupal.quickedit.util.constants.transitionEnd = 'transitionEnd.quickedit webkitTransitionEnd.quickedit transitionend.quickedit msTransitionEnd.quickedit oTransitionEnd.quickedit';

  /**
   * Converts a field id into a formatted url path.
   *
   * @example
   * Drupal.quickedit.util.buildUrl(
   *   'node/1/body/und/full',
   *   '/quickedit/form/!entity_type/!id/!field_name/!langcode/!view_mode'
   * );
   *
   * @param {string} id
   *   The id of an editable field.
   * @param {string} urlFormat
   *   The Controller route for field processing.
   *
   * @return {string}
   *   The formatted URL.
   */
  Drupal.quickedit.util.buildUrl = function (id, urlFormat) {
    var parts = id.split('/');
    return Drupal.formatString(decodeURIComponent(urlFormat), {
      '!entity_type': parts[0],
      '!id': parts[1],
      '!field_name': parts[2],
      '!langcode': parts[3],
      '!view_mode': parts[4]
    });
  };

  /**
   * Shows a network error modal dialog.
   *
   * @param {string} title
   *   The title to use in the modal dialog.
   * @param {string} message
   *   The message to use in the modal dialog.
   */
  Drupal.quickedit.util.networkErrorModal = function (title, message) {
    var $message = $('<div>' + message + '</div>');
    var networkErrorModal = Drupal.dialog($message.get(0), {
      title: title,
      dialogClass: 'quickedit-network-error',
      buttons: [
        {
          text: Drupal.t('OK'),
          click: function () {
            networkErrorModal.close();
          },
          primary: true
        }
      ],
      create: function () {
        $(this).parent().find('.ui-dialog-titlebar-close').remove();
      },
      close: function (event) {
        // Automatically destroy the DOM element that was used for the dialog.
        $(event.target).remove();
      }
    });
    networkErrorModal.showModal();
  };

  /**
   * @namespace
   */
  Drupal.quickedit.util.form = {

    /**
     * Loads a form, calls a callback to insert.
     *
     * Leverages {@link Drupal.Ajax}' ability to have scoped (per-instance)
     * command implementations to be able to call a callback.
     *
     * @param {object} options
     *   An object with the following keys:
     * @param {string} options.fieldID
     *   The field ID that uniquely identifies the field for which this form
     *   will be loaded.
     * @param {bool} options.nocssjs
     *   Boolean indicating whether no CSS and JS should be returned (necessary
     *   when the form is invisible to the user).
     * @param {bool} options.reset
     *   Boolean indicating whether the data stored for this field's entity in
     *   PrivateTempStore should be used or reset.
     * @param {function} callback
     *   A callback function that will receive the form to be inserted, as well
     *   as the ajax object, necessary if the callback wants to perform other
     *   Ajax commands.
     */
    load: function (options, callback) {
      var fieldID = options.fieldID;

      // Create a Drupal.ajax instance to load the form.
      var formLoaderAjax = Drupal.ajax({
        url: Drupal.quickedit.util.buildUrl(fieldID, Drupal.url('quickedit/form/!entity_type/!id/!field_name/!langcode/!view_mode')),
        submit: {
          nocssjs: options.nocssjs,
          reset: options.reset
        },
        error: function (xhr, url) {
          // Show a modal to inform the user of the network error.
          var fieldLabel = Drupal.quickedit.metadata.get(fieldID, 'label');
          var message = Drupal.t('Could not load the form for <q>@field-label</q>, either due to a website problem or a network connection problem.<br>Please try again.', {'@field-label': fieldLabel});
          Drupal.quickedit.util.networkErrorModal(Drupal.t('Network problem!'), message);

          // Change the state back to "candidate", to allow the user to start
          // in-place editing of the field again.
          var fieldModel = Drupal.quickedit.app.model.get('activeField');
          fieldModel.set('state', 'candidate');
        }
      });
      // Implement a scoped quickeditFieldForm AJAX command: calls the callback.
      formLoaderAjax.commands.quickeditFieldForm = function (ajax, response, status) {
        callback(response.data, ajax);
        Drupal.ajax.instances[this.instanceIndex] = null;
      };
      // This will ensure our scoped quickeditFieldForm AJAX command gets
      // called.
      formLoaderAjax.execute();
    },

    /**
     * Creates a {@link Drupal.Ajax} instance that is used to save a form.
     *
     * @param {object} options
     *   Submit options to the form.
     * @param {bool} options.nocssjs
     *   Boolean indicating whether no CSS and JS should be returned (necessary
     *   when the form is invisible to the user).
     * @param {Array.<string>} options.other_view_modes
     *   Array containing view mode IDs (of other instances of this field on the
     *   page).
     * @param {jQuery} $submit
     *   The submit element.
     *
     * @return {Drupal.Ajax}
     *   A {@link Drupal.Ajax} instance.
     */
    ajaxifySaving: function (options, $submit) {
      // Re-wire the form to handle submit.
      var settings = {
        url: $submit.closest('form').attr('action'),
        setClick: true,
        event: 'click.quickedit',
        progress: false,
        submit: {
          nocssjs: options.nocssjs,
          other_view_modes: options.other_view_modes
        },

        /**
         * Reimplement the success handler.
         *
         * Ensure {@link Drupal.attachBehaviors} does not get called on the
         * form.
         *
         * @param {Drupal.AjaxCommands~commandDefinition} response
         *   The Drupal AJAX response.
         * @param {number} [status]
         *   The HTTP status code.
         */
        success: function (response, status) {
          for (var i in response) {
            if (response.hasOwnProperty(i) && response[i].command && this.commands[response[i].command]) {
              this.commands[response[i].command](this, response[i], status);
            }
          }
        },
        base: $submit.attr('id'),
        element: $submit[0]
      };

      return Drupal.ajax(settings);
    },

    /**
     * Cleans up the {@link Drupal.Ajax} instance that is used to save the form.
     *
     * @param {Drupal.Ajax} ajax
     *   A {@link Drupal.Ajax} instance that was returned by
     *   {@link Drupal.quickedit.form.ajaxifySaving}.
     */
    unajaxifySaving: function (ajax) {
      $(ajax.element).off('click.quickedit');
    }

  };

})(jQuery, Drupal);
;
/**
 * @file
 * A Backbone Model subclass that enforces validation when calling set().
 */

(function (Drupal, Backbone) {

  'use strict';

  Drupal.quickedit.BaseModel = Backbone.Model.extend(/** @lends Drupal.quickedit.BaseModel# */{

    /**
     * @constructs
     *
     * @augments Backbone.Model
     *
     * @param {object} options
     *   Options for the base model-
     *
     * @return {Drupal.quickedit.BaseModel}
     *   A quickedit base model.
     */
    initialize: function (options) {
      this.__initialized = true;
      return Backbone.Model.prototype.initialize.call(this, options);
    },

    /**
     * Set a value on the model
     *
     * @param {object|string} key
     *   The key to set a value for.
     * @param {*} val
     *   The value to set.
     * @param {object} [options]
     *   Options for the model.
     *
     * @return {*}
     *   The result of `Backbone.Model.prototype.set` with the specified
     *   parameters.
     */
    set: function (key, val, options) {
      if (this.__initialized) {
        // Deal with both the "key", value and {key:value}-style arguments.
        if (typeof key === 'object') {
          key.validate = true;
        }
        else {
          if (!options) {
            options = {};
          }
          options.validate = true;
        }
      }
      return Backbone.Model.prototype.set.call(this, key, val, options);
    }

  });

}(Drupal, Backbone));
;
/**
 * @file
 * A Backbone Model for the state of the in-place editing application.
 *
 * @see Drupal.quickedit.AppView
 */

(function (Backbone, Drupal) {

  'use strict';

  /**
   * @constructor
   *
   * @augments Backbone.Model
   */
  Drupal.quickedit.AppModel = Backbone.Model.extend(/** @lends Drupal.quickedit.AppModel# */{

    /**
     * @type {object}
     *
     * @prop {Drupal.quickedit.FieldModel} highlightedField
     * @prop {Drupal.quickedit.FieldModel} activeField
     * @prop {Drupal.dialog~dialogDefinition} activeModal
     */
    defaults: /** @lends Drupal.quickedit.AppModel# */{

      /**
       * The currently state='highlighted' Drupal.quickedit.FieldModel, if any.
       *
       * @type {Drupal.quickedit.FieldModel}
       *
       * @see Drupal.quickedit.FieldModel.states
       */
      highlightedField: null,

      /**
       * The currently state = 'active' Drupal.quickedit.FieldModel, if any.
       *
       * @type {Drupal.quickedit.FieldModel}
       *
       * @see Drupal.quickedit.FieldModel.states
       */
      activeField: null,

      /**
       * Reference to a {@link Drupal.dialog} instance if a state change
       * requires confirmation.
       *
       * @type {Drupal.dialog~dialogDefinition}
       */
      activeModal: null
    }

  });

}(Backbone, Drupal));
;
/**
 * @file
 * A Backbone Model for the state of an in-place editable entity in the DOM.
 */

(function (_, $, Backbone, Drupal) {

  'use strict';

  Drupal.quickedit.EntityModel = Drupal.quickedit.BaseModel.extend(/** @lends Drupal.quickedit.EntityModel# */{

    /**
     * @type {object}
     */
    defaults: /** @lends Drupal.quickedit.EntityModel# */{

      /**
       * The DOM element that represents this entity.
       *
       * It may seem bizarre to have a DOM element in a Backbone Model, but we
       * need to be able to map entities in the DOM to EntityModels in memory.
       *
       * @type {HTMLElement}
       */
      el: null,

      /**
       * An entity ID, of the form `<entity type>/<entity ID>`
       *
       * @example
       * "node/1"
       *
       * @type {string}
       */
      entityID: null,

      /**
       * An entity instance ID.
       *
       * The first instance of a specific entity (i.e. with a given entity ID)
       * is assigned 0, the second 1, and so on.
       *
       * @type {number}
       */
      entityInstanceID: null,

      /**
       * The unique ID of this entity instance on the page, of the form
       * `<entity type>/<entity ID>[entity instance ID]`
       *
       * @example
       * "node/1[0]"
       *
       * @type {string}
       */
      id: null,

      /**
       * The label of the entity.
       *
       * @type {string}
       */
      label: null,

      /**
       * A FieldCollection for all fields of the entity.
       *
       * @type {Drupal.quickedit.FieldCollection}
       *
       * @see Drupal.quickedit.FieldCollection
       */
      fields: null,

      // The attributes below are stateful. The ones above will never change
      // during the life of a EntityModel instance.

      /**
       * Indicates whether this entity is currently being edited in-place.
       *
       * @type {bool}
       */
      isActive: false,

      /**
       * Whether one or more fields are already been stored in PrivateTempStore.
       *
       * @type {bool}
       */
      inTempStore: false,

      /**
       * Indicates whether a "Save" button is necessary or not.
       *
       * Whether one or more fields have already been stored in PrivateTempStore
       * *or* the field that's currently being edited is in the 'changed' or a
       * later state.
       *
       * @type {bool}
       */
      isDirty: false,

      /**
       * Whether the request to the server has been made to commit this entity.
       *
       * Used to prevent multiple such requests.
       *
       * @type {bool}
       */
      isCommitting: false,

      /**
       * The current processing state of an entity.
       *
       * @type {string}
       */
      state: 'closed',

      /**
       * IDs of fields whose new values have been stored in PrivateTempStore.
       *
       * We must store this on the EntityModel as well (even though it already
       * is on the FieldModel) because when a field is rerendered, its
       * FieldModel is destroyed and this allows us to transition it back to
       * the proper state.
       *
       * @type {Array.<string>}
       */
      fieldsInTempStore: [],

      /**
       * A flag the tells the application that this EntityModel must be reloaded
       * in order to restore the original values to its fields in the client.
       *
       * @type {bool}
       */
      reload: false
    },

    /**
     * @constructs
     *
     * @augments Drupal.quickedit.BaseModel
     */
    initialize: function () {
      this.set('fields', new Drupal.quickedit.FieldCollection());

      // Respond to entity state changes.
      this.listenTo(this, 'change:state', this.stateChange);

      // The state of the entity is largely dependent on the state of its
      // fields.
      this.listenTo(this.get('fields'), 'change:state', this.fieldStateChange);

      // Call Drupal.quickedit.BaseModel's initialize() method.
      Drupal.quickedit.BaseModel.prototype.initialize.call(this);
    },

    /**
     * Updates FieldModels' states when an EntityModel change occurs.
     *
     * @param {Drupal.quickedit.EntityModel} entityModel
     *   The entity model
     * @param {string} state
     *   The state of the associated entity. One of
     *   {@link Drupal.quickedit.EntityModel.states}.
     * @param {object} options
     *   Options for the entity model.
     */
    stateChange: function (entityModel, state, options) {
      var to = state;
      switch (to) {
        case 'closed':
          this.set({
            isActive: false,
            inTempStore: false,
            isDirty: false
          });
          break;

        case 'launching':
          break;

        case 'opening':
          // Set the fields to candidate state.
          entityModel.get('fields').each(function (fieldModel) {
            fieldModel.set('state', 'candidate', options);
          });
          break;

        case 'opened':
          // The entity is now ready for editing!
          this.set('isActive', true);
          break;

        case 'committing':
          // The user indicated they want to save the entity.
          var fields = this.get('fields');
          // For fields that are in an active state, transition them to
          // candidate.
          fields.chain()
            .filter(function (fieldModel) {
              return _.intersection([fieldModel.get('state')], ['active']).length;
            })
            .each(function (fieldModel) {
              fieldModel.set('state', 'candidate');
            });
          // For fields that are in a changed state, field values must first be
          // stored in PrivateTempStore.
          fields.chain()
            .filter(function (fieldModel) {
              return _.intersection([fieldModel.get('state')], Drupal.quickedit.app.changedFieldStates).length;
            })
            .each(function (fieldModel) {
              fieldModel.set('state', 'saving');
            });
          break;

        case 'deactivating':
          var changedFields = this.get('fields')
            .filter(function (fieldModel) {
              return _.intersection([fieldModel.get('state')], ['changed', 'invalid']).length;
            });
          // If the entity contains unconfirmed or unsaved changes, return the
          // entity to an opened state and ask the user if they would like to
          // save the changes or discard the changes.
          //   1. One of the fields is in a changed state. The changed field
          //   might just be a change in the client or it might have been saved
          //   to tempstore.
          //   2. The saved flag is empty and the confirmed flag is empty. If
          //   the entity has been saved to the server, the fields changed in
          //   the client are irrelevant. If the changes are confirmed, then
          //   proceed to set the fields to candidate state.
          if ((changedFields.length || this.get('fieldsInTempStore').length) && (!options.saved && !options.confirmed)) {
            // Cancel deactivation until the user confirms save or discard.
            this.set('state', 'opened', {confirming: true});
            // An action in reaction to state change must be deferred.
            _.defer(function () {
              Drupal.quickedit.app.confirmEntityDeactivation(entityModel);
            });
          }
          else {
            var invalidFields = this.get('fields')
              .filter(function (fieldModel) {
                return _.intersection([fieldModel.get('state')], ['invalid']).length;
              });
            // Indicate if this EntityModel needs to be reloaded in order to
            // restore the original values of its fields.
            entityModel.set('reload', (this.get('fieldsInTempStore').length || invalidFields.length));
            // Set all fields to the 'candidate' state. A changed field may have
            // to go through confirmation first.
            entityModel.get('fields').each(function (fieldModel) {
              // If the field is already in the candidate state, trigger a
              // change event so that the entityModel can move to the next state
              // in deactivation.
              if (_.intersection([fieldModel.get('state')], ['candidate', 'highlighted']).length) {
                fieldModel.trigger('change:state', fieldModel, fieldModel.get('state'), options);
              }
              else {
                fieldModel.set('state', 'candidate', options);
              }
            });
          }
          break;

        case 'closing':
          // Set all fields to the 'inactive' state.
          options.reason = 'stop';
          this.get('fields').each(function (fieldModel) {
            fieldModel.set({
              inTempStore: false,
              state: 'inactive'
            }, options);
          });
          break;
      }
    },

    /**
     * Updates a Field and Entity model's "inTempStore" when appropriate.
     *
     * Helper function.
     *
     * @param {Drupal.quickedit.EntityModel} entityModel
     *   The model of the entity for which a field's state attribute has
     *   changed.
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The model of the field whose state attribute has changed.
     *
     * @see Drupal.quickedit.EntityModel#fieldStateChange
     */
    _updateInTempStoreAttributes: function (entityModel, fieldModel) {
      var current = fieldModel.get('state');
      var previous = fieldModel.previous('state');
      var fieldsInTempStore = entityModel.get('fieldsInTempStore');
      // If the fieldModel changed to the 'saved' state: remember that this
      // field was saved to PrivateTempStore.
      if (current === 'saved') {
        // Mark the entity as saved in PrivateTempStore, so that we can pass the
        // proper "reset PrivateTempStore" boolean value when communicating with
        // the server.
        entityModel.set('inTempStore', true);
        // Mark the field as saved in PrivateTempStore, so that visual
        // indicators signifying just that may be rendered.
        fieldModel.set('inTempStore', true);
        // Remember that this field is in PrivateTempStore, restore when
        // rerendered.
        fieldsInTempStore.push(fieldModel.get('fieldID'));
        fieldsInTempStore = _.uniq(fieldsInTempStore);
        entityModel.set('fieldsInTempStore', fieldsInTempStore);
      }
      // If the fieldModel changed to the 'candidate' state from the
      // 'inactive' state, then this is a field for this entity that got
      // rerendered. Restore its previous 'inTempStore' attribute value.
      else if (current === 'candidate' && previous === 'inactive') {
        fieldModel.set('inTempStore', _.intersection([fieldModel.get('fieldID')], fieldsInTempStore).length > 0);
      }
    },

    /**
     * Reacts to state changes in this entity's fields.
     *
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The model of the field whose state attribute changed.
     * @param {string} state
     *   The state of the associated field. One of
     *   {@link Drupal.quickedit.FieldModel.states}.
     */
    fieldStateChange: function (fieldModel, state) {
      var entityModel = this;
      var fieldState = state;
      // Switch on the entityModel state.
      // The EntityModel responds to FieldModel state changes as a function of
      // its state. For example, a field switching back to 'candidate' state
      // when its entity is in the 'opened' state has no effect on the entity.
      // But that same switch back to 'candidate' state of a field when the
      // entity is in the 'committing' state might allow the entity to proceed
      // with the commit flow.
      switch (this.get('state')) {
        case 'closed':
        case 'launching':
          // It should be impossible to reach these: fields can't change state
          // while the entity is closed or still launching.
          break;

        case 'opening':
          // We must change the entity to the 'opened' state, but it must first
          // be confirmed that all of its fieldModels have transitioned to the
          // 'candidate' state.
          // We do this here, because this is called every time a fieldModel
          // changes state, hence each time this is called, we get closer to the
          // goal of having all fieldModels in the 'candidate' state.
          // A state change in reaction to another state change must be
          // deferred.
          _.defer(function () {
            entityModel.set('state', 'opened', {
              'accept-field-states': Drupal.quickedit.app.readyFieldStates
            });
          });
          break;

        case 'opened':
          // Set the isDirty attribute when appropriate so that it is known when
          // to display the "Save" button in the entity toolbar.
          // Note that once a field has been changed, there's no way to discard
          // that change, hence it will have to be saved into PrivateTempStore,
          // or the in-place editing of this field will have to be stopped
          // completely. In other words: once any field enters the 'changed'
          // field, then for the remainder of the in-place editing session, the
          // entity is by definition dirty.
          if (fieldState === 'changed') {
            entityModel.set('isDirty', true);
          }
          else {
            this._updateInTempStoreAttributes(entityModel, fieldModel);
          }
          break;

        case 'committing':
          // If the field save returned a validation error, set the state of the
          // entity back to 'opened'.
          if (fieldState === 'invalid') {
            // A state change in reaction to another state change must be
            // deferred.
            _.defer(function () {
              entityModel.set('state', 'opened', {reason: 'invalid'});
            });
          }
          else {
            this._updateInTempStoreAttributes(entityModel, fieldModel);
          }

          // Attempt to save the entity. If the entity's fields are not yet all
          // in a ready state, the save will not be processed.
          var options = {
            'accept-field-states': Drupal.quickedit.app.readyFieldStates
          };
          if (entityModel.set('isCommitting', true, options)) {
            entityModel.save({
              success: function () {
                entityModel.set({
                  state: 'deactivating',
                  isCommitting: false
                }, {saved: true});
              },
              error: function () {
                // Reset the "isCommitting" mutex.
                entityModel.set('isCommitting', false);
                // Change the state back to "opened", to allow the user to hit
                // the "Save" button again.
                entityModel.set('state', 'opened', {reason: 'networkerror'});
                // Show a modal to inform the user of the network error.
                var message = Drupal.t('Your changes to <q>@entity-title</q> could not be saved, either due to a website problem or a network connection problem.<br>Please try again.', {'@entity-title': entityModel.get('label')});
                Drupal.quickedit.util.networkErrorModal(Drupal.t('Network problem!'), message);
              }
            });
          }
          break;

        case 'deactivating':
          // When setting the entity to 'closing', require that all fieldModels
          // are in either the 'candidate' or 'highlighted' state.
          // A state change in reaction to another state change must be
          // deferred.
          _.defer(function () {
            entityModel.set('state', 'closing', {
              'accept-field-states': Drupal.quickedit.app.readyFieldStates
            });
          });
          break;

        case 'closing':
          // When setting the entity to 'closed', require that all fieldModels
          // are in the 'inactive' state.
          // A state change in reaction to another state change must be
          // deferred.
          _.defer(function () {
            entityModel.set('state', 'closed', {
              'accept-field-states': ['inactive']
            });
          });
          break;
      }
    },

    /**
     * Fires an AJAX request to the REST save URL for an entity.
     *
     * @param {object} options
     *   An object of options that contains:
     * @param {function} [options.success]
     *   A function to invoke if the entity is successfully saved.
     */
    save: function (options) {
      var entityModel = this;

      // Create a Drupal.ajax instance to save the entity.
      var entitySaverAjax = Drupal.ajax({
        url: Drupal.url('quickedit/entity/' + entityModel.get('entityID')),
        error: function () {
          // Let the Drupal.quickedit.EntityModel Backbone model's error()
          // method handle errors.
          options.error.call(entityModel);
        }
      });
      // Entity saved successfully.
      entitySaverAjax.commands.quickeditEntitySaved = function (ajax, response, status) {
        // All fields have been moved from PrivateTempStore to permanent
        // storage, update the "inTempStore" attribute on FieldModels, on the
        // EntityModel and clear EntityModel's "fieldInTempStore" attribute.
        entityModel.get('fields').each(function (fieldModel) {
          fieldModel.set('inTempStore', false);
        });
        entityModel.set('inTempStore', false);
        entityModel.set('fieldsInTempStore', []);

        // Invoke the optional success callback.
        if (options.success) {
          options.success.call(entityModel);
        }
      };
      // Trigger the AJAX request, which will will return the
      // quickeditEntitySaved AJAX command to which we then react.
      entitySaverAjax.execute();
    },

    /**
     * Validate the entity model.
     *
     * @param {object} attrs
     *   The attributes changes in the save or set call.
     * @param {object} options
     *   An object with the following option:
     * @param {string} [options.reason]
     *   A string that conveys a particular reason to allow for an exceptional
     *   state change.
     * @param {Array} options.accept-field-states
     *   An array of strings that represent field states that the entities must
     *   be in to validate. For example, if `accept-field-states` is
     *   `['candidate', 'highlighted']`, then all the fields of the entity must
     *   be in either of these two states for the save or set call to
     *   validate and proceed.
     *
     * @return {string}
     *   A string to say something about the state of the entity model.
     */
    validate: function (attrs, options) {
      var acceptedFieldStates = options['accept-field-states'] || [];

      // Validate state change.
      var currentState = this.get('state');
      var nextState = attrs.state;
      if (currentState !== nextState) {
        // Ensure it's a valid state.
        if (_.indexOf(this.constructor.states, nextState) === -1) {
          return '"' + nextState + '" is an invalid state';
        }

        // Ensure it's a state change that is allowed.
        // Check if the acceptStateChange function accepts it.
        if (!this._acceptStateChange(currentState, nextState, options)) {
          return 'state change not accepted';
        }
        // If that function accepts it, then ensure all fields are also in an
        // acceptable state.
        else if (!this._fieldsHaveAcceptableStates(acceptedFieldStates)) {
          return 'state change not accepted because fields are not in acceptable state';
        }
      }

      // Validate setting isCommitting = true.
      var currentIsCommitting = this.get('isCommitting');
      var nextIsCommitting = attrs.isCommitting;
      if (currentIsCommitting === false && nextIsCommitting === true) {
        if (!this._fieldsHaveAcceptableStates(acceptedFieldStates)) {
          return 'isCommitting change not accepted because fields are not in acceptable state';
        }
      }
      else if (currentIsCommitting === true && nextIsCommitting === true) {
        return 'isCommitting is a mutex, hence only changes are allowed';
      }
    },

    /**
     * Checks if a state change can be accepted.
     *
     * @param {string} from
     *   From state.
     * @param {string} to
     *   To state.
     * @param {object} context
     *   Context for the check.
     * @param {string} context.reason
     *   The reason for the state change.
     * @param {bool} context.confirming
     *   Whether context is confirming or not.
     *
     * @return {bool}
     *   Whether the state change is accepted or not.
     *
     * @see Drupal.quickedit.AppView#acceptEditorStateChange
     */
    _acceptStateChange: function (from, to, context) {
      var accept = true;

      // In general, enforce the states sequence. Disallow going back from a
      // "later" state to an "earlier" state, except in explicitly allowed
      // cases.
      if (!this.constructor.followsStateSequence(from, to)) {
        accept = false;

        // Allow: closing -> closed.
        // Necessary to stop editing an entity.
        if (from === 'closing' && to === 'closed') {
          accept = true;
        }
        // Allow: committing -> opened.
        // Necessary to be able to correct an invalid field, or to hit the
        // "Save" button again after a server/network error.
        else if (from === 'committing' && to === 'opened' && context.reason && (context.reason === 'invalid' || context.reason === 'networkerror')) {
          accept = true;
        }
        // Allow: deactivating -> opened.
        // Necessary to be able to confirm changes with the user.
        else if (from === 'deactivating' && to === 'opened' && context.confirming) {
          accept = true;
        }
        // Allow: opened -> deactivating.
        // Necessary to be able to stop editing.
        else if (from === 'opened' && to === 'deactivating' && context.confirmed) {
          accept = true;
        }
      }

      return accept;
    },

    /**
     * Checks if fields have acceptable states.
     *
     * @param {Array} acceptedFieldStates
     *   An array of acceptable field states to check for.
     *
     * @return {bool}
     *   Whether the fields have an acceptable state.
     *
     * @see Drupal.quickedit.EntityModel#validate
     */
    _fieldsHaveAcceptableStates: function (acceptedFieldStates) {
      var accept = true;

      // If no acceptable field states are provided, assume all field states are
      // acceptable. We want to let validation pass as a default and only
      // check validity on calls to set that explicitly request it.
      if (acceptedFieldStates.length > 0) {
        var fieldStates = this.get('fields').pluck('state') || [];
        // If not all fields are in one of the accepted field states, then we
        // still can't allow this state change.
        if (_.difference(fieldStates, acceptedFieldStates).length) {
          accept = false;
        }
      }

      return accept;
    },

    /**
     * Destroys the entity model.
     *
     * @param {object} options
     *   Options for the entity model.
     */
    destroy: function (options) {
      Drupal.quickedit.BaseModel.prototype.destroy.call(this, options);

      this.stopListening();

      // Destroy all fields of this entity.
      this.get('fields').reset();
    },

    /**
     * @inheritdoc
     */
    sync: function () {
      // We don't use REST updates to sync.
      return;
    }

  }, /** @lends Drupal.quickedit.EntityModel */{

    /**
     * Sequence of all possible states an entity can be in during quickediting.
     *
     * @type {Array.<string>}
     */
    states: [
      // Initial state, like field's 'inactive' OR the user has just finished
      // in-place editing this entity.
      // - Trigger: none (initial) or EntityModel (finished).
      // - Expected behavior: (when not initial state): tear down
      //   EntityToolbarView, in-place editors and related views.
      'closed',
      // User has activated in-place editing of this entity.
      // - Trigger: user.
      // - Expected behavior: the EntityToolbarView is gets set up, in-place
      //   editors (EditorViews) and related views for this entity's fields are
      //   set up. Upon completion of those, the state is changed to 'opening'.
      'launching',
      // Launching has finished.
      // - Trigger: application.
      // - Guarantees: in-place editors ready for use, all entity and field
      //   views have been set up, all fields are in the 'inactive' state.
      // - Expected behavior: all fields are changed to the 'candidate' state
      //   and once this is completed, the entity state will be changed to
      //   'opened'.
      'opening',
      // Opening has finished.
      // - Trigger: EntityModel.
      // - Guarantees: see 'opening', all fields are in the 'candidate' state.
      // - Expected behavior: the user is able to actually use in-place editing.
      'opened',
      // User has clicked the 'Save' button (and has thus changed at least one
      // field).
      // - Trigger: user.
      // - Guarantees: see 'opened', plus: either a changed field is in
      //   PrivateTempStore, or the user has just modified a field without
      //   activating (switching to) another field.
      // - Expected behavior: 1) if any of the fields are not yet in
      //   PrivateTempStore, save them to PrivateTempStore, 2) if then any of
      //   the fields has the 'invalid' state, then change the entity state back
      //   to 'opened', otherwise: save the entity by committing it from
      //   PrivateTempStore into permanent storage.
      'committing',
      // User has clicked the 'Close' button, or has clicked the 'Save' button
      // and that was successfully completed.
      // - Trigger: user or EntityModel.
      // - Guarantees: when having clicked 'Close' hardly any: fields may be in
      //   a variety of states; when having clicked 'Save': all fields are in
      //   the 'candidate' state.
      // - Expected behavior: transition all fields to the 'candidate' state,
      //   possibly requiring confirmation in the case of having clicked
      //   'Close'.
      'deactivating',
      // Deactivation has been completed.
      // - Trigger: EntityModel.
      // - Guarantees: all fields are in the 'candidate' state.
      // - Expected behavior: change all fields to the 'inactive' state.
      'closing'
    ],

    /**
     * Indicates whether the 'from' state comes before the 'to' state.
     *
     * @param {string} from
     *   One of {@link Drupal.quickedit.EntityModel.states}.
     * @param {string} to
     *   One of {@link Drupal.quickedit.EntityModel.states}.
     *
     * @return {bool}
     *   Whether the 'from' state comes before the 'to' state.
     */
    followsStateSequence: function (from, to) {
      return _.indexOf(this.states, from) < _.indexOf(this.states, to);
    }

  });

  /**
   * @constructor
   *
   * @augments Backbone.Collection
   */
  Drupal.quickedit.EntityCollection = Backbone.Collection.extend(/** @lends Drupal.quickedit.EntityCollection# */{

    /**
     * @type {Drupal.quickedit.EntityModel}
     */
    model: Drupal.quickedit.EntityModel
  });

}(_, jQuery, Backbone, Drupal));
;
/**
 * @file
 * A Backbone Model for the state of an in-place editable field in the DOM.
 */

(function (_, Backbone, Drupal) {

  'use strict';

  Drupal.quickedit.FieldModel = Drupal.quickedit.BaseModel.extend(/** @lends Drupal.quickedit.FieldModel# */{

    /**
     * @type {object}
     */
    defaults: /** @lends Drupal.quickedit.FieldModel# */{

      /**
       * The DOM element that represents this field. It may seem bizarre to have
       * a DOM element in a Backbone Model, but we need to be able to map fields
       * in the DOM to FieldModels in memory.
       */
      el: null,

      /**
       * A field ID, of the form
       * `<entity type>/<id>/<field name>/<language>/<view mode>`
       *
       * @example
       * "node/1/field_tags/und/full"
       */
      fieldID: null,

      /**
       * The unique ID of this field within its entity instance on the page, of
       * the form `<entity type>/<id>/<field name>/<language>/<view
       * mode>[entity instance ID]`.
       *
       * @example
       * "node/1/field_tags/und/full[0]"
       */
      id: null,

      /**
       * A {@link Drupal.quickedit.EntityModel}. Its "fields" attribute, which
       * is a FieldCollection, is automatically updated to include this
       * FieldModel.
       */
      entity: null,

      /**
       * This field's metadata as returned by the
       * QuickEditController::metadata().
       */
      metadata: null,

      /**
       * Callback function for validating changes between states. Receives the
       * previous state, new state, context, and a callback.
       */
      acceptStateChange: null,

      /**
       * A logical field ID, of the form
       * `<entity type>/<id>/<field name>/<language>`, i.e. the fieldID without
       * the view mode, to be able to identify other instances of the same
       * field on the page but rendered in a different view mode.
       *
       * @example
       * "node/1/field_tags/und".
       */
      logicalFieldID: null,

      // The attributes below are stateful. The ones above will never change
      // during the life of a FieldModel instance.

      /**
       * In-place editing state of this field. Defaults to the initial state.
       * Possible values: {@link Drupal.quickedit.FieldModel.states}.
       */
      state: 'inactive',

      /**
       * The field is currently in the 'changed' state or one of the following
       * states in which the field is still changed.
       */
      isChanged: false,

      /**
       * Is tracked by the EntityModel, is mirrored here solely for decorative
       * purposes: so that FieldDecorationView.renderChanged() can react to it.
       */
      inTempStore: false,

      /**
       * The full HTML representation of this field (with the element that has
       * the data-quickedit-field-id as the outer element). Used to propagate
       * changes from this field to other instances of the same field storage.
       */
      html: null,

      /**
       * An object containing the full HTML representations (values) of other
       * view modes (keys) of this field, for other instances of this field
       * displayed in a different view mode.
       */
      htmlForOtherViewModes: null
    },

    /**
     * State of an in-place editable field in the DOM.
     *
     * @constructs
     *
     * @augments Drupal.quickedit.BaseModel
     *
     * @param {object} options
     *   Options for the field model.
     */
    initialize: function (options) {
      // Store the original full HTML representation of this field.
      this.set('html', options.el.outerHTML);

      // Enlist field automatically in the associated entity's field collection.
      this.get('entity').get('fields').add(this);

      // Automatically generate the logical field ID.
      this.set('logicalFieldID', this.get('fieldID').split('/').slice(0, 4).join('/'));

      // Call Drupal.quickedit.BaseModel's initialize() method.
      Drupal.quickedit.BaseModel.prototype.initialize.call(this, options);
    },

    /**
     * Destroys the field model.
     *
     * @param {object} options
     *   Options for the field model.
     */
    destroy: function (options) {
      if (this.get('state') !== 'inactive') {
        throw new Error('FieldModel cannot be destroyed if it is not inactive state.');
      }
      Drupal.quickedit.BaseModel.prototype.destroy.call(this, options);
    },

    /**
     * @inheritdoc
     */
    sync: function () {
      // We don't use REST updates to sync.
      return;
    },

    /**
     * Validate function for the field model.
     *
     * @param {object} attrs
     *   The attributes changes in the save or set call.
     * @param {object} options
     *   An object with the following option:
     * @param {string} [options.reason]
     *   A string that conveys a particular reason to allow for an exceptional
     *   state change.
     * @param {Array} options.accept-field-states
     *   An array of strings that represent field states that the entities must
     *   be in to validate. For example, if `accept-field-states` is
     *   `['candidate', 'highlighted']`, then all the fields of the entity must
     *   be in either of these two states for the save or set call to
     *   validate and proceed.
     *
     * @return {string}
     *   A string to say something about the state of the field model.
     */
    validate: function (attrs, options) {
      var current = this.get('state');
      var next = attrs.state;
      if (current !== next) {
        // Ensure it's a valid state.
        if (_.indexOf(this.constructor.states, next) === -1) {
          return '"' + next + '" is an invalid state';
        }
        // Check if the acceptStateChange callback accepts it.
        if (!this.get('acceptStateChange')(current, next, options, this)) {
          return 'state change not accepted';
        }
      }
    },

    /**
     * Extracts the entity ID from this field's ID.
     *
     * @return {string}
     *   An entity ID: a string of the format `<entity type>/<id>`.
     */
    getEntityID: function () {
      return this.get('fieldID').split('/').slice(0, 2).join('/');
    },

    /**
     * Extracts the view mode ID from this field's ID.
     *
     * @return {string}
     *   A view mode ID.
     */
    getViewMode: function () {
      return this.get('fieldID').split('/').pop();
    },

    /**
     * Find other instances of this field with different view modes.
     *
     * @return {Array}
     *   An array containing view mode IDs.
     */
    findOtherViewModes: function () {
      var currentField = this;
      var otherViewModes = [];
      Drupal.quickedit.collections.fields
        // Find all instances of fields that display the same logical field
        // (same entity, same field, just a different instance and maybe a
        // different view mode).
        .where({logicalFieldID: currentField.get('logicalFieldID')})
        .forEach(function (field) {
          // Ignore the current field.
          if (field === currentField) {
            return;
          }
          // Also ignore other fields with the same view mode.
          else if (field.get('fieldID') === currentField.get('fieldID')) {
            return;
          }
          else {
            otherViewModes.push(field.getViewMode());
          }
        });
      return otherViewModes;
    }

  }, /** @lends Drupal.quickedit.FieldModel */{

    /**
     * Sequence of all possible states a field can be in during quickediting.
     *
     * @type {Array.<string>}
     */
    states: [
      // The field associated with this FieldModel is linked to an EntityModel;
      // the user can choose to start in-place editing that entity (and
      // consequently this field). No in-place editor (EditorView) is associated
      // with this field, because this field is not being in-place edited.
      // This is both the initial (not yet in-place editing) and the end state
      // (finished in-place editing).
      'inactive',
      // The user is in-place editing this entity, and this field is a
      // candidate
      // for in-place editing. In-place editor should not
      // - Trigger: user.
      // - Guarantees: entity is ready, in-place editor (EditorView) is
      //   associated with the field.
      // - Expected behavior: visual indicators
      //   around the field indicate it is available for in-place editing, no
      //   in-place editor presented yet.
      'candidate',
      // User is highlighting this field.
      // - Trigger: user.
      // - Guarantees: see 'candidate'.
      // - Expected behavior: visual indicators to convey highlighting, in-place
      //   editing toolbar shows field's label.
      'highlighted',
      // User has activated the in-place editing of this field; in-place editor
      // is activating.
      // - Trigger: user.
      // - Guarantees: see 'candidate'.
      // - Expected behavior: loading indicator, in-place editor is loading
      //   remote data (e.g. retrieve form from back-end). Upon retrieval of
      //   remote data, the in-place editor transitions the field's state to
      //   'active'.
      'activating',
      // In-place editor has finished loading remote data; ready for use.
      // - Trigger: in-place editor.
      // - Guarantees: see 'candidate'.
      // - Expected behavior: in-place editor for the field is ready for use.
      'active',
      // User has modified values in the in-place editor.
      // - Trigger: user.
      // - Guarantees: see 'candidate', plus in-place editor is ready for use.
      // - Expected behavior: visual indicator of change.
      'changed',
      // User is saving changed field data in in-place editor to
      // PrivateTempStore. The save mechanism of the in-place editor is called.
      // - Trigger: user.
      // - Guarantees: see 'candidate' and 'active'.
      // - Expected behavior: saving indicator, in-place editor is saving field
      //   data into PrivateTempStore. Upon successful saving (without
      //   validation errors), the in-place editor transitions the field's state
      //   to 'saved', but to 'invalid' upon failed saving (with validation
      //   errors).
      'saving',
      // In-place editor has successfully saved the changed field.
      // - Trigger: in-place editor.
      // - Guarantees: see 'candidate' and 'active'.
      // - Expected behavior: transition back to 'candidate' state because the
      //   deed is done. Then: 1) transition to 'inactive' to allow the field
      //   to be rerendered, 2) destroy the FieldModel (which also destroys
      //   attached views like the EditorView), 3) replace the existing field
      //   HTML with the existing HTML and 4) attach behaviors again so that the
      //   field becomes available again for in-place editing.
      'saved',
      // In-place editor has failed to saved the changed field: there were
      // validation errors.
      // - Trigger: in-place editor.
      // - Guarantees: see 'candidate' and 'active'.
      // - Expected behavior: remain in 'invalid' state, let the user make more
      //   changes so that he can save it again, without validation errors.
      'invalid'
    ],

    /**
     * Indicates whether the 'from' state comes before the 'to' state.
     *
     * @param {string} from
     *   One of {@link Drupal.quickedit.FieldModel.states}.
     * @param {string} to
     *   One of {@link Drupal.quickedit.FieldModel.states}.
     *
     * @return {bool}
     *   Whether the 'from' state comes before the 'to' state.
     */
    followsStateSequence: function (from, to) {
      return _.indexOf(this.states, from) < _.indexOf(this.states, to);
    }

  });

  /**
   * @constructor
   *
   * @augments Backbone.Collection
   */
  Drupal.quickedit.FieldCollection = Backbone.Collection.extend(/** @lends Drupal.quickedit.FieldCollection */{

    /**
     * @type {Drupal.quickedit.FieldModel}
     */
    model: Drupal.quickedit.FieldModel
  });

}(_, Backbone, Drupal));
;
/**
 * @file
 * A Backbone Model for the state of an in-place editor.
 *
 * @see Drupal.quickedit.EditorView
 */

(function (Backbone, Drupal) {

  'use strict';

  /**
   * @constructor
   *
   * @augments Backbone.Model
   */
  Drupal.quickedit.EditorModel = Backbone.Model.extend(/** @lends Drupal.quickedit.EditorModel# */{

    /**
     * @type {object}
     *
     * @prop {string} originalValue
     * @prop {string} currentValue
     * @prop {Array} validationErrors
     */
    defaults: /** @lends Drupal.quickedit.EditorModel# */{

      /**
       * Not the full HTML representation of this field, but the "actual"
       * original value of the field, stored by the used in-place editor, and
       * in a representation that can be chosen by the in-place editor.
       *
       * @type {string}
       */
      originalValue: null,

      /**
       * Analogous to originalValue, but the current value.
       *
       * @type {string}
       */
      currentValue: null,

      /**
       * Stores any validation errors to be rendered.
       *
       * @type {Array}
       */
      validationErrors: null
    }

  });

}(Backbone, Drupal));
;
/**
 * @file
 * A Backbone View that controls the overall "in-place editing application".
 *
 * @see Drupal.quickedit.AppModel
 */

(function ($, _, Backbone, Drupal) {

  'use strict';

  // Indicates whether the page should be reloaded after in-place editing has
  // shut down. A page reload is necessary to re-instate the original HTML of
  // the edited fields if in-place editing has been canceled and one or more of
  // the entity's fields were saved to PrivateTempStore: one of them may have
  // been changed to the empty value and hence may have been rerendered as the
  // empty string, which makes it impossible for Quick Edit to know where to
  // restore the original HTML.
  var reload = false;

  Drupal.quickedit.AppView = Backbone.View.extend(/** @lends Drupal.quickedit.AppView# */{

    /**
     * @constructs
     *
     * @augments Backbone.View
     *
     * @param {object} options
     *   An object with the following keys:
     * @param {Drupal.quickedit.AppModel} options.model
     *   The application state model.
     * @param {Drupal.quickedit.EntityCollection} options.entitiesCollection
     *   All on-page entities.
     * @param {Drupal.quickedit.FieldCollection} options.fieldsCollection
     *   All on-page fields
     */
    initialize: function (options) {
      // AppView's configuration for handling states.
      // @see Drupal.quickedit.FieldModel.states
      this.activeFieldStates = ['activating', 'active'];
      this.singleFieldStates = ['highlighted', 'activating', 'active'];
      this.changedFieldStates = ['changed', 'saving', 'saved', 'invalid'];
      this.readyFieldStates = ['candidate', 'highlighted'];

      // Track app state.
      this.listenTo(options.entitiesCollection, 'change:state', this.appStateChange);
      this.listenTo(options.entitiesCollection, 'change:isActive', this.enforceSingleActiveEntity);

      // Track app state.
      this.listenTo(options.fieldsCollection, 'change:state', this.editorStateChange);
      // Respond to field model HTML representation change events.
      this.listenTo(options.fieldsCollection, 'change:html', this.renderUpdatedField);
      this.listenTo(options.fieldsCollection, 'change:html', this.propagateUpdatedField);
      // Respond to addition.
      this.listenTo(options.fieldsCollection, 'add', this.rerenderedFieldToCandidate);
      // Respond to destruction.
      this.listenTo(options.fieldsCollection, 'destroy', this.teardownEditor);
    },

    /**
     * Handles setup/teardown and state changes when the active entity changes.
     *
     * @param {Drupal.quickedit.EntityModel} entityModel
     *   An instance of the EntityModel class.
     * @param {string} state
     *   The state of the associated field. One of
     *   {@link Drupal.quickedit.EntityModel.states}.
     */
    appStateChange: function (entityModel, state) {
      var app = this;
      var entityToolbarView;
      switch (state) {
        case 'launching':
          reload = false;
          // First, create an entity toolbar view.
          entityToolbarView = new Drupal.quickedit.EntityToolbarView({
            model: entityModel,
            appModel: this.model
          });
          entityModel.toolbarView = entityToolbarView;
          // Second, set up in-place editors.
          // They must be notified of state changes, hence this must happen
          // while the associated fields are still in the 'inactive' state.
          entityModel.get('fields').each(function (fieldModel) {
            app.setupEditor(fieldModel);
          });
          // Third, transition the entity to the 'opening' state, which will
          // transition all fields from 'inactive' to 'candidate'.
          _.defer(function () {
            entityModel.set('state', 'opening');
          });
          break;

        case 'closed':
          entityToolbarView = entityModel.toolbarView;
          // First, tear down the in-place editors.
          entityModel.get('fields').each(function (fieldModel) {
            app.teardownEditor(fieldModel);
          });
          // Second, tear down the entity toolbar view.
          if (entityToolbarView) {
            entityToolbarView.remove();
            delete entityModel.toolbarView;
          }
          // A page reload may be necessary to re-instate the original HTML of
          // the edited fields.
          if (reload) {
            reload = false;
            location.reload();
          }
          break;
      }
    },

    /**
     * Accepts or reject editor (Editor) state changes.
     *
     * This is what ensures that the app is in control of what happens.
     *
     * @param {string} from
     *   The previous state.
     * @param {string} to
     *   The new state.
     * @param {null|object} context
     *   The context that is trying to trigger the state change.
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The fieldModel to which this change applies.
     *
     * @return {bool}
     *   Whether the editor change was accepted or rejected.
     */
    acceptEditorStateChange: function (from, to, context, fieldModel) {
      var accept = true;

      // If the app is in view mode, then reject all state changes except for
      // those to 'inactive'.
      if (context && (context.reason === 'stop' || context.reason === 'rerender')) {
        if (from === 'candidate' && to === 'inactive') {
          accept = true;
        }
      }
      // Handling of edit mode state changes is more granular.
      else {
        // In general, enforce the states sequence. Disallow going back from a
        // "later" state to an "earlier" state, except in explicitly allowed
        // cases.
        if (!Drupal.quickedit.FieldModel.followsStateSequence(from, to)) {
          accept = false;
          // Allow: activating/active -> candidate.
          // Necessary to stop editing a field.
          if (_.indexOf(this.activeFieldStates, from) !== -1 && to === 'candidate') {
            accept = true;
          }
          // Allow: changed/invalid -> candidate.
          // Necessary to stop editing a field when it is changed or invalid.
          else if ((from === 'changed' || from === 'invalid') && to === 'candidate') {
            accept = true;
          }
          // Allow: highlighted -> candidate.
          // Necessary to stop highlighting a field.
          else if (from === 'highlighted' && to === 'candidate') {
            accept = true;
          }
          // Allow: saved -> candidate.
          // Necessary when successfully saved a field.
          else if (from === 'saved' && to === 'candidate') {
            accept = true;
          }
          // Allow: invalid -> saving.
          // Necessary to be able to save a corrected, invalid field.
          else if (from === 'invalid' && to === 'saving') {
            accept = true;
          }
          // Allow: invalid -> activating.
          // Necessary to be able to correct a field that turned out to be
          // invalid after the user already had moved on to the next field
          // (which we explicitly allow to have a fluent UX).
          else if (from === 'invalid' && to === 'activating') {
            accept = true;
          }
        }

        // If it's not against the general principle, then here are more
        // disallowed cases to check.
        if (accept) {
          var activeField;
          var activeFieldState;
          // Ensure only one field (editor) at a time is active … but allow a
          // user to hop from one field to the next, even if we still have to
          // start saving the field that is currently active: assume it will be
          // valid, to allow for a fluent UX. (If it turns out to be invalid,
          // this block of code also handles that.)
          if ((this.readyFieldStates.indexOf(from) !== -1 || from === 'invalid') && this.activeFieldStates.indexOf(to) !== -1) {
            activeField = this.model.get('activeField');
            if (activeField && activeField !== fieldModel) {
              activeFieldState = activeField.get('state');
              // Allow the state change. If the state of the active field is:
              // - 'activating' or 'active': change it to 'candidate'
              // - 'changed' or 'invalid': change it to 'saving'
              // - 'saving' or 'saved': don't do anything.
              if (this.activeFieldStates.indexOf(activeFieldState) !== -1) {
                activeField.set('state', 'candidate');
              }
              else if (activeFieldState === 'changed' || activeFieldState === 'invalid') {
                activeField.set('state', 'saving');
              }

              // If the field that's being activated is in fact already in the
              // invalid state (which can only happen because above we allowed
              // the user to move on to another field to allow for a fluent UX;
              // we assumed it would be saved successfully), then we shouldn't
              // allow the field to enter the 'activating' state, instead, we
              // simply change the active editor. All guarantees and
              // assumptions for this field still hold!
              if (from === 'invalid') {
                this.model.set('activeField', fieldModel);
                accept = false;
              }
              // Do not reject: the field is either in the 'candidate' or
              // 'highlighted' state and we allow it to enter the 'activating'
              // state!
            }
          }
          // Reject going from activating/active to candidate because of a
          // mouseleave.
          else if (_.indexOf(this.activeFieldStates, from) !== -1 && to === 'candidate') {
            if (context && context.reason === 'mouseleave') {
              accept = false;
            }
          }
          // When attempting to stop editing a changed/invalid property, ask for
          // confirmation.
          else if ((from === 'changed' || from === 'invalid') && to === 'candidate') {
            if (context && context.reason === 'mouseleave') {
              accept = false;
            }
            else {
              // Check whether the transition has been confirmed?
              if (context && context.confirmed) {
                accept = true;
              }
            }
          }
        }
      }

      return accept;
    },

    /**
     * Sets up the in-place editor for the given field.
     *
     * Must happen before the fieldModel's state is changed to 'candidate'.
     *
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The field for which an in-place editor must be set up.
     */
    setupEditor: function (fieldModel) {
      // Get the corresponding entity toolbar.
      var entityModel = fieldModel.get('entity');
      var entityToolbarView = entityModel.toolbarView;
      // Get the field toolbar DOM root from the entity toolbar.
      var fieldToolbarRoot = entityToolbarView.getToolbarRoot();
      // Create in-place editor.
      var editorName = fieldModel.get('metadata').editor;
      var editorModel = new Drupal.quickedit.EditorModel();
      var editorView = new Drupal.quickedit.editors[editorName]({
        el: $(fieldModel.get('el')),
        model: editorModel,
        fieldModel: fieldModel
      });

      // Create in-place editor's toolbar for this field — stored inside the
      // entity toolbar, the entity toolbar will position itself appropriately
      // above (or below) the edited element.
      var toolbarView = new Drupal.quickedit.FieldToolbarView({
        el: fieldToolbarRoot,
        model: fieldModel,
        $editedElement: $(editorView.getEditedElement()),
        editorView: editorView,
        entityModel: entityModel
      });

      // Create decoration for edited element: padding if necessary, sets
      // classes on the element to style it according to the current state.
      var decorationView = new Drupal.quickedit.FieldDecorationView({
        el: $(editorView.getEditedElement()),
        model: fieldModel,
        editorView: editorView
      });

      // Track these three views in FieldModel so that we can tear them down
      // correctly.
      fieldModel.editorView = editorView;
      fieldModel.toolbarView = toolbarView;
      fieldModel.decorationView = decorationView;
    },

    /**
     * Tears down the in-place editor for the given field.
     *
     * Must happen after the fieldModel's state is changed to 'inactive'.
     *
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The field for which an in-place editor must be torn down.
     */
    teardownEditor: function (fieldModel) {
      // Early-return if this field was not yet decorated.
      if (typeof fieldModel.editorView === 'undefined') {
        return;
      }

      // Unbind event handlers; remove toolbar element; delete toolbar view.
      fieldModel.toolbarView.remove();
      delete fieldModel.toolbarView;

      // Unbind event handlers; delete decoration view. Don't remove the element
      // because that would remove the field itself.
      fieldModel.decorationView.remove();
      delete fieldModel.decorationView;

      // Unbind event handlers; delete editor view. Don't remove the element
      // because that would remove the field itself.
      fieldModel.editorView.remove();
      delete fieldModel.editorView;
    },

    /**
     * Asks the user to confirm whether he wants to stop editing via a modal.
     *
     * @param {Drupal.quickedit.EntityModel} entityModel
     *   An instance of the EntityModel class.
     *
     * @see Drupal.quickedit.AppView#acceptEditorStateChange
     */
    confirmEntityDeactivation: function (entityModel) {
      var that = this;
      var discardDialog;

      function closeDiscardDialog(action) {
        discardDialog.close(action);
        // The active modal has been removed.
        that.model.set('activeModal', null);

        // If the targetState is saving, the field must be saved, then the
        // entity must be saved.
        if (action === 'save') {
          entityModel.set('state', 'committing', {confirmed: true});
        }
        else {
          entityModel.set('state', 'deactivating', {confirmed: true});
          // Editing has been canceled and the changes will not be saved. Mark
          // the page for reload if the entityModel declares that it requires
          // a reload.
          if (entityModel.get('reload')) {
            reload = true;
            entityModel.set('reload', false);
          }
        }
      }

      // Only instantiate if there isn't a modal instance visible yet.
      if (!this.model.get('activeModal')) {
        var $unsavedChanges = $('<div>' + Drupal.t('You have unsaved changes') + '</div>');
        discardDialog = Drupal.dialog($unsavedChanges.get(0), {
          title: Drupal.t('Discard changes?'),
          dialogClass: 'quickedit-discard-modal',
          resizable: false,
          buttons: [
            {
              text: Drupal.t('Save'),
              click: function () {
                closeDiscardDialog('save');
              },
              primary: true
            },
            {
              text: Drupal.t('Discard changes'),
              click: function () {
                closeDiscardDialog('discard');
              }
            }
          ],
          // Prevent this modal from being closed without the user making a
          // choice as per http://stackoverflow.com/a/5438771.
          closeOnEscape: false,
          create: function () {
            $(this).parent().find('.ui-dialog-titlebar-close').remove();
          },
          beforeClose: false,
          close: function (event) {
            // Automatically destroy the DOM element that was used for the
            // dialog.
            $(event.target).remove();
          }
        });
        this.model.set('activeModal', discardDialog);

        discardDialog.showModal();
      }
    },

    /**
     * Reacts to field state changes; tracks global state.
     *
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The `fieldModel` holding the state.
     * @param {string} state
     *   The state of the associated field. One of
     *   {@link Drupal.quickedit.FieldModel.states}.
     */
    editorStateChange: function (fieldModel, state) {
      var from = fieldModel.previous('state');
      var to = state;

      // Keep track of the highlighted field in the global state.
      if (_.indexOf(this.singleFieldStates, to) !== -1 && this.model.get('highlightedField') !== fieldModel) {
        this.model.set('highlightedField', fieldModel);
      }
      else if (this.model.get('highlightedField') === fieldModel && to === 'candidate') {
        this.model.set('highlightedField', null);
      }

      // Keep track of the active field in the global state.
      if (_.indexOf(this.activeFieldStates, to) !== -1 && this.model.get('activeField') !== fieldModel) {
        this.model.set('activeField', fieldModel);
      }
      else if (this.model.get('activeField') === fieldModel && to === 'candidate') {
        // Discarded if it transitions from a changed state to 'candidate'.
        if (from === 'changed' || from === 'invalid') {
          fieldModel.editorView.revert();
        }
        this.model.set('activeField', null);
      }
    },

    /**
     * Render an updated field (a field whose 'html' attribute changed).
     *
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The FieldModel whose 'html' attribute changed.
     * @param {string} html
     *   The updated 'html' attribute.
     * @param {object} options
     *   An object with the following keys:
     * @param {bool} options.propagation
     *   Whether this change to the 'html' attribute occurred because of the
     *   propagation of changes to another instance of this field.
     */
    renderUpdatedField: function (fieldModel, html, options) {
      // Get data necessary to rerender property before it is unavailable.
      var $fieldWrapper = $(fieldModel.get('el'));
      var $context = $fieldWrapper.parent();

      var renderField = function () {
        // Destroy the field model; this will cause all attached views to be
        // destroyed too, and removal from all collections in which it exists.
        fieldModel.destroy();

        // Replace the old content with the new content.
        $fieldWrapper.replaceWith(html);

        // Attach behaviors again to the modified piece of HTML; this will
        // create a new field model and call rerenderedFieldToCandidate() with
        // it.
        Drupal.attachBehaviors($context.get(0));
      };

      // When propagating the changes of another instance of this field, this
      // field is not being actively edited and hence no state changes are
      // necessary. So: only update the state of this field when the rerendering
      // of this field happens not because of propagation, but because it is
      // being edited itself.
      if (!options.propagation) {
        // Deferred because renderUpdatedField is reacting to a field model
        // change event, and we want to make sure that event fully propagates
        // before making another change to the same model.
        _.defer(function () {
          // First set the state to 'candidate', to allow all attached views to
          // clean up all their "active state"-related changes.
          fieldModel.set('state', 'candidate');

          // Similarly, the above .set() call's change event must fully
          // propagate before calling it again.
          _.defer(function () {
            // Set the field's state to 'inactive', to enable the updating of
            // its DOM value.
            fieldModel.set('state', 'inactive', {reason: 'rerender'});

            renderField();
          });
        });
      }
      else {
        renderField();
      }
    },

    /**
     * Propagates changes to an updated field to all instances of that field.
     *
     * @param {Drupal.quickedit.FieldModel} updatedField
     *   The FieldModel whose 'html' attribute changed.
     * @param {string} html
     *   The updated 'html' attribute.
     * @param {object} options
     *   An object with the following keys:
     * @param {bool} options.propagation
     *   Whether this change to the 'html' attribute occurred because of the
     *   propagation of changes to another instance of this field.
     *
     * @see Drupal.quickedit.AppView#renderUpdatedField
     */
    propagateUpdatedField: function (updatedField, html, options) {
      // Don't propagate field updates that themselves were caused by
      // propagation.
      if (options.propagation) {
        return;
      }

      var htmlForOtherViewModes = updatedField.get('htmlForOtherViewModes');
      Drupal.quickedit.collections.fields
        // Find all instances of fields that display the same logical field
        // (same entity, same field, just a different instance and maybe a
        // different view mode).
        .where({logicalFieldID: updatedField.get('logicalFieldID')})
        .forEach(function (field) {
          // Ignore the field that was already updated.
          if (field === updatedField) {
            return;
          }
          // If this other instance of the field has the same view mode, we can
          // update it easily.
          else if (field.getViewMode() === updatedField.getViewMode()) {
            field.set('html', updatedField.get('html'));
          }
          // If this other instance of the field has a different view mode, and
          // that is one of the view modes for which a re-rendered version is
          // available (and that should be the case unless this field was only
          // added to the page after editing of the updated field began), then
          // use that view mode's re-rendered version.
          else {
            if (field.getViewMode() in htmlForOtherViewModes) {
              field.set('html', htmlForOtherViewModes[field.getViewMode()], {propagation: true});
            }
          }
        });
    },

    /**
     * If the new in-place editable field is for the entity that's currently
     * being edited, then transition it to the 'candidate' state.
     *
     * This happens when a field was modified, saved and hence rerendered.
     *
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   A field that was just added to the collection of fields.
     */
    rerenderedFieldToCandidate: function (fieldModel) {
      var activeEntity = Drupal.quickedit.collections.entities.findWhere({isActive: true});

      // Early-return if there is no active entity.
      if (!activeEntity) {
        return;
      }

      // If the field's entity is the active entity, make it a candidate.
      if (fieldModel.get('entity') === activeEntity) {
        this.setupEditor(fieldModel);
        fieldModel.set('state', 'candidate');
      }
    },

    /**
     * EntityModel Collection change handler.
     *
     * Handler is called `change:isActive` and enforces a single active entity.
     *
     * @param {Drupal.quickedit.EntityModel} changedEntityModel
     *   The entityModel instance whose active state has changed.
     */
    enforceSingleActiveEntity: function (changedEntityModel) {
      // When an entity is deactivated, we don't need to enforce anything.
      if (changedEntityModel.get('isActive') === false) {
        return;
      }

      // This entity was activated; deactivate all other entities.
      changedEntityModel.collection.chain()
        .filter(function (entityModel) {
          return entityModel.get('isActive') === true && entityModel !== changedEntityModel;
        })
        .each(function (entityModel) {
          entityModel.set('state', 'deactivating');
        });
    }

  });

}(jQuery, _, Backbone, Drupal));
;
/**
 * @file
 * A Backbone View that decorates the in-place edited element.
 */

(function ($, Backbone, Drupal) {

  'use strict';

  Drupal.quickedit.FieldDecorationView = Backbone.View.extend(/** @lends Drupal.quickedit.FieldDecorationView# */{

    /**
     * @type {null}
     */
    _widthAttributeIsEmpty: null,

    /**
     * @type {object}
     */
    events: {
      'mouseenter.quickedit': 'onMouseEnter',
      'mouseleave.quickedit': 'onMouseLeave',
      'click': 'onClick',
      'tabIn.quickedit': 'onMouseEnter',
      'tabOut.quickedit': 'onMouseLeave'
    },

    /**
     * @constructs
     *
     * @augments Backbone.View
     *
     * @param {object} options
     *   An object with the following keys:
     * @param {Drupal.quickedit.EditorView} options.editorView
     *   The editor object view.
     */
    initialize: function (options) {
      this.editorView = options.editorView;

      this.listenTo(this.model, 'change:state', this.stateChange);
      this.listenTo(this.model, 'change:isChanged change:inTempStore', this.renderChanged);
    },

    /**
     * @inheritdoc
     */
    remove: function () {
      // The el property is the field, which should not be removed. Remove the
      // pointer to it, then call Backbone.View.prototype.remove().
      this.setElement();
      Backbone.View.prototype.remove.call(this);
    },

    /**
     * Determines the actions to take given a change of state.
     *
     * @param {Drupal.quickedit.FieldModel} model
     *   The `FieldModel` model.
     * @param {string} state
     *   The state of the associated field. One of
     *   {@link Drupal.quickedit.FieldModel.states}.
     */
    stateChange: function (model, state) {
      var from = model.previous('state');
      var to = state;
      switch (to) {
        case 'inactive':
          this.undecorate();
          break;

        case 'candidate':
          this.decorate();
          if (from !== 'inactive') {
            this.stopHighlight();
            if (from !== 'highlighted') {
              this.model.set('isChanged', false);
              this.stopEdit();
            }
          }
          this._unpad();
          break;

        case 'highlighted':
          this.startHighlight();
          break;

        case 'activating':
          // NOTE: this state is not used by every editor! It's only used by
          // those that need to interact with the server.
          this.prepareEdit();
          break;

        case 'active':
          if (from !== 'activating') {
            this.prepareEdit();
          }
          if (this.editorView.getQuickEditUISettings().padding) {
            this._pad();
          }
          break;

        case 'changed':
          this.model.set('isChanged', true);
          break;

        case 'saving':
          break;

        case 'saved':
          break;

        case 'invalid':
          break;
      }
    },

    /**
     * Adds a class to the edited element that indicates whether the field has
     * been changed by the user (i.e. locally) or the field has already been
     * changed and stored before by the user (i.e. remotely, stored in
     * PrivateTempStore).
     */
    renderChanged: function () {
      this.$el.toggleClass('quickedit-changed', this.model.get('isChanged') || this.model.get('inTempStore'));
    },

    /**
     * Starts hover; transitions to 'highlight' state.
     *
     * @param {jQuery.Event} event
     *   The mouse event.
     */
    onMouseEnter: function (event) {
      var that = this;
      that.model.set('state', 'highlighted');
      event.stopPropagation();
    },

    /**
     * Stops hover; transitions to 'candidate' state.
     *
     * @param {jQuery.Event} event
     *   The mouse event.
     */
    onMouseLeave: function (event) {
      var that = this;
      that.model.set('state', 'candidate', {reason: 'mouseleave'});
      event.stopPropagation();
    },

    /**
     * Transition to 'activating' stage.
     *
     * @param {jQuery.Event} event
     *   The click event.
     */
    onClick: function (event) {
      this.model.set('state', 'activating');
      event.preventDefault();
      event.stopPropagation();
    },

    /**
     * Adds classes used to indicate an elements editable state.
     */
    decorate: function () {
      this.$el.addClass('quickedit-candidate quickedit-editable');
    },

    /**
     * Removes classes used to indicate an elements editable state.
     */
    undecorate: function () {
      this.$el.removeClass('quickedit-candidate quickedit-editable quickedit-highlighted quickedit-editing');
    },

    /**
     * Adds that class that indicates that an element is highlighted.
     */
    startHighlight: function () {
      // Animations.
      var that = this;
      // Use a timeout to grab the next available animation frame.
      that.$el.addClass('quickedit-highlighted');
    },

    /**
     * Removes the class that indicates that an element is highlighted.
     */
    stopHighlight: function () {
      this.$el.removeClass('quickedit-highlighted');
    },

    /**
     * Removes the class that indicates that an element as editable.
     */
    prepareEdit: function () {
      this.$el.addClass('quickedit-editing');

      // Allow the field to be styled differently while editing in a pop-up
      // in-place editor.
      if (this.editorView.getQuickEditUISettings().popup) {
        this.$el.addClass('quickedit-editor-is-popup');
      }
    },

    /**
     * Removes the class that indicates that an element is being edited.
     *
     * Reapplies the class that indicates that a candidate editable element is
     * again available to be edited.
     */
    stopEdit: function () {
      this.$el.removeClass('quickedit-highlighted quickedit-editing');

      // Done editing in a pop-up in-place editor; remove the class.
      if (this.editorView.getQuickEditUISettings().popup) {
        this.$el.removeClass('quickedit-editor-is-popup');
      }

      // Make the other editors show up again.
      $('.quickedit-candidate').addClass('quickedit-editable');
    },

    /**
     * Adds padding around the editable element to make it pop visually.
     */
    _pad: function () {
      // Early return if the element has already been padded.
      if (this.$el.data('quickedit-padded')) {
        return;
      }
      var self = this;

      // Add 5px padding for readability. This means we'll freeze the current
      // width and *then* add 5px padding, hence ensuring the padding is added
      // "on the outside".
      // 1) Freeze the width (if it's not already set); don't use animations.
      if (this.$el[0].style.width === '') {
        this._widthAttributeIsEmpty = true;
        this.$el
          .addClass('quickedit-animate-disable-width')
          .css('width', this.$el.width());
      }

      // 2) Add padding; use animations.
      var posProp = this._getPositionProperties(this.$el);
      setTimeout(function () {
        // Re-enable width animations (padding changes affect width too!).
        self.$el.removeClass('quickedit-animate-disable-width');

        // Pad the editable.
        self.$el
          .css({
            'position': 'relative',
            'top': posProp.top - 5 + 'px',
            'left': posProp.left - 5 + 'px',
            'padding-top': posProp['padding-top'] + 5 + 'px',
            'padding-left': posProp['padding-left'] + 5 + 'px',
            'padding-right': posProp['padding-right'] + 5 + 'px',
            'padding-bottom': posProp['padding-bottom'] + 5 + 'px',
            'margin-bottom': posProp['margin-bottom'] - 10 + 'px'
          })
          .data('quickedit-padded', true);
      }, 0);
    },

    /**
     * Removes the padding around the element being edited when editing ceases.
     */
    _unpad: function () {
      // Early return if the element has not been padded.
      if (!this.$el.data('quickedit-padded')) {
        return;
      }
      var self = this;

      // 1) Set the empty width again.
      if (this._widthAttributeIsEmpty) {
        this.$el
          .addClass('quickedit-animate-disable-width')
          .css('width', '');
      }

      // 2) Remove padding; use animations (these will run simultaneously with)
      // the fading out of the toolbar as its gets removed).
      var posProp = this._getPositionProperties(this.$el);
      setTimeout(function () {
        // Re-enable width animations (padding changes affect width too!).
        self.$el.removeClass('quickedit-animate-disable-width');

        // Unpad the editable.
        self.$el
          .css({
            'position': 'relative',
            'top': posProp.top + 5 + 'px',
            'left': posProp.left + 5 + 'px',
            'padding-top': posProp['padding-top'] - 5 + 'px',
            'padding-left': posProp['padding-left'] - 5 + 'px',
            'padding-right': posProp['padding-right'] - 5 + 'px',
            'padding-bottom': posProp['padding-bottom'] - 5 + 'px',
            'margin-bottom': posProp['margin-bottom'] + 10 + 'px'
          });
      }, 0);
      // Remove the marker that indicates that this field has padding. This is
      // done outside the timed out function above so that we don't get numerous
      // queued functions that will remove padding before the data marker has
      // been removed.
      this.$el.removeData('quickedit-padded');
    },

    /**
     * Gets the top and left properties of an element.
     *
     * Convert extraneous values and information into numbers ready for
     * subtraction.
     *
     * @param {jQuery} $e
     *   The element to get position properties from.
     *
     * @return {object}
     *   An object containing css values for the needed properties.
     */
    _getPositionProperties: function ($e) {
      var p;
      var r = {};
      var props = [
        'top', 'left', 'bottom', 'right',
        'padding-top', 'padding-left', 'padding-right', 'padding-bottom',
        'margin-bottom'
      ];

      var propCount = props.length;
      for (var i = 0; i < propCount; i++) {
        p = props[i];
        r[p] = parseInt(this._replaceBlankPosition($e.css(p)), 10);
      }
      return r;
    },

    /**
     * Replaces blank or 'auto' CSS `position: <value>` values with "0px".
     *
     * @param {string} [pos]
     *   The value for a CSS position declaration.
     *
     * @return {string}
     *   A CSS value that is valid for `position`.
     */
    _replaceBlankPosition: function (pos) {
      if (pos === 'auto' || !pos) {
        pos = '0px';
      }
      return pos;
    }

  });

})(jQuery, Backbone, Drupal);
;
/**
 * @file
 * A Backbone view that decorates the in-place editable entity.
 */

(function (Drupal, $, Backbone) {

  'use strict';

  Drupal.quickedit.EntityDecorationView = Backbone.View.extend(/** @lends Drupal.quickedit.EntityDecorationView# */{

    /**
     * Associated with the DOM root node of an editable entity.
     *
     * @constructs
     *
     * @augments Backbone.View
     */
    initialize: function () {
      this.listenTo(this.model, 'change', this.render);
    },

    /**
     * @inheritdoc
     */
    render: function () {
      this.$el.toggleClass('quickedit-entity-active', this.model.get('isActive'));
    },

    /**
     * @inheritdoc
     */
    remove: function () {
      this.setElement(null);
      Backbone.View.prototype.remove.call(this);
    }

  });

}(Drupal, jQuery, Backbone));
;
/**
 * @file
 * A Backbone View that provides an entity level toolbar.
 */

(function ($, _, Backbone, Drupal, debounce) {

  'use strict';

  Drupal.quickedit.EntityToolbarView = Backbone.View.extend(/** @lends Drupal.quickedit.EntityToolbarView# */{

    /**
     * @type {jQuery}
     */
    _fieldToolbarRoot: null,

    /**
     * @return {object}
     *   A map of events.
     */
    events: function () {
      var map = {
        'click button.action-save': 'onClickSave',
        'click button.action-cancel': 'onClickCancel',
        'mouseenter': 'onMouseenter'
      };
      return map;
    },

    /**
     * @constructs
     *
     * @augments Backbone.View
     *
     * @param {object} options
     *   Options to construct the view.
     * @param {Drupal.quickedit.AppModel} options.appModel
     *   A quickedit `AppModel` to use in the view.
     */
    initialize: function (options) {
      var that = this;
      this.appModel = options.appModel;
      this.$entity = $(this.model.get('el'));

      // Rerender whenever the entity state changes.
      this.listenTo(this.model, 'change:isActive change:isDirty change:state', this.render);
      // Also rerender whenever a different field is highlighted or activated.
      this.listenTo(this.appModel, 'change:highlightedField change:activeField', this.render);
      // Rerender when a field of the entity changes state.
      this.listenTo(this.model.get('fields'), 'change:state', this.fieldStateChange);

      // Reposition the entity toolbar as the viewport and the position within
      // the viewport changes.
      $(window).on('resize.quickedit scroll.quickedit', debounce($.proxy(this.windowChangeHandler, this), 150));

      // Adjust the fence placement within which the entity toolbar may be
      // positioned.
      $(document).on('drupalViewportOffsetChange.quickedit', function (event, offsets) {
        if (that.$fence) {
          that.$fence.css(offsets);
        }
      });

      // Set the entity toolbar DOM element as the el for this view.
      var $toolbar = this.buildToolbarEl();
      this.setElement($toolbar);
      this._fieldToolbarRoot = $toolbar.find('.quickedit-toolbar-field').get(0);

      // Initial render.
      this.render();
    },

    /**
     * @inheritdoc
     *
     * @return {Drupal.quickedit.EntityToolbarView}
     *   The entity toolbar view.
     */
    render: function () {
      if (this.model.get('isActive')) {
        // If the toolbar container doesn't exist, create it.
        var $body = $('body');
        if ($body.children('#quickedit-entity-toolbar').length === 0) {
          $body.append(this.$el);
        }
        // The fence will define a area on the screen that the entity toolbar
        // will be position within.
        if ($body.children('#quickedit-toolbar-fence').length === 0) {
          this.$fence = $(Drupal.theme('quickeditEntityToolbarFence'))
            .css(Drupal.displace())
            .appendTo($body);
        }
        // Adds the entity title to the toolbar.
        this.label();

        // Show the save and cancel buttons.
        this.show('ops');
        // If render is being called and the toolbar is already visible, just
        // reposition it.
        this.position();
      }

      // The save button text and state varies with the state of the entity
      // model.
      var $button = this.$el.find('.quickedit-button.action-save');
      var isDirty = this.model.get('isDirty');
      // Adjust the save button according to the state of the model.
      switch (this.model.get('state')) {
        // Quick editing is active, but no field is being edited.
        case 'opened':
          // The saving throbber is not managed by AJAX system. The
          // EntityToolbarView manages this visual element.
          $button
            .removeClass('action-saving icon-throbber icon-end')
            .text(Drupal.t('Save'))
            .removeAttr('disabled')
            .attr('aria-hidden', !isDirty);
          break;

        // The changes to the fields of the entity are being committed.
        case 'committing':
          $button
            .addClass('action-saving icon-throbber icon-end')
            .text(Drupal.t('Saving'))
            .attr('disabled', 'disabled');
          break;

        default:
          $button.attr('aria-hidden', true);
          break;
      }

      return this;
    },

    /**
     * @inheritdoc
     */
    remove: function () {
      // Remove additional DOM elements controlled by this View.
      this.$fence.remove();

      // Stop listening to additional events.
      $(window).off('resize.quickedit scroll.quickedit');
      $(document).off('drupalViewportOffsetChange.quickedit');

      Backbone.View.prototype.remove.call(this);
    },

    /**
     * Repositions the entity toolbar on window scroll and resize.
     *
     * @param {jQuery.Event} event
     *   The scroll or resize event.
     */
    windowChangeHandler: function (event) {
      this.position();
    },

    /**
     * Determines the actions to take given a change of state.
     *
     * @param {Drupal.quickedit.FieldModel} model
     *   The `FieldModel` model.
     * @param {string} state
     *   The state of the associated field. One of
     *   {@link Drupal.quickedit.FieldModel.states}.
     */
    fieldStateChange: function (model, state) {
      switch (state) {
        case 'active':
          this.render();
          break;

        case 'invalid':
          this.render();
          break;
      }
    },

    /**
     * Uses the jQuery.ui.position() method to position the entity toolbar.
     *
     * @param {HTMLElement} [element]
     *   The element against which the entity toolbar is positioned.
     */
    position: function (element) {
      clearTimeout(this.timer);

      var that = this;
      // Vary the edge of the positioning according to the direction of language
      // in the document.
      var edge = (document.documentElement.dir === 'rtl') ? 'right' : 'left';
      // A time unit to wait until the entity toolbar is repositioned.
      var delay = 0;
      // Determines what check in the series of checks below should be
      // evaluated.
      var check = 0;
      // When positioned against an active field that has padding, we should
      // ignore that padding when positioning the toolbar, to not unnecessarily
      // move the toolbar horizontally, which feels annoying.
      var horizontalPadding = 0;
      var of;
      var activeField;
      var highlightedField;
      // There are several elements in the page that the entity toolbar might be
      // positioned against. They are considered below in a priority order.
      do {
        switch (check) {
          case 0:
            // Position against a specific element.
            of = element;
            break;

          case 1:
            // Position against a form container.
            activeField = Drupal.quickedit.app.model.get('activeField');
            of = activeField && activeField.editorView && activeField.editorView.$formContainer && activeField.editorView.$formContainer.find('.quickedit-form');
            break;

          case 2:
            // Position against an active field.
            of = activeField && activeField.editorView && activeField.editorView.getEditedElement();
            if (activeField && activeField.editorView && activeField.editorView.getQuickEditUISettings().padding) {
              horizontalPadding = 5;
            }
            break;

          case 3:
            // Position against a highlighted field.
            highlightedField = Drupal.quickedit.app.model.get('highlightedField');
            of = highlightedField && highlightedField.editorView && highlightedField.editorView.getEditedElement();
            delay = 250;
            break;

          default:
            var fieldModels = this.model.get('fields').models;
            var topMostPosition = 1000000;
            var topMostField = null;
            // Position against the topmost field.
            for (var i = 0; i < fieldModels.length; i++) {
              var pos = fieldModels[i].get('el').getBoundingClientRect().top;
              if (pos < topMostPosition) {
                topMostPosition = pos;
                topMostField = fieldModels[i];
              }
            }
            of = topMostField.get('el');
            delay = 50;
            break;
        }
        // Prepare to check the next possible element to position against.
        check++;
      } while (!of);

      /**
       * Refines the positioning algorithm of jquery.ui.position().
       *
       * Invoked as the 'using' callback of jquery.ui.position() in
       * positionToolbar().
       *
       * @param {*} view
       *   The view the positions will be calculated from.
       * @param {object} suggested
       *   A hash of top and left values for the position that should be set. It
       *   can be forwarded to .css() or .animate().
       * @param {object} info
       *   The position and dimensions of both the 'my' element and the 'of'
       *   elements, as well as calculations to their relative position. This
       *   object contains the following properties:
       * @param {object} info.element
       *   A hash that contains information about the HTML element that will be
       *   positioned. Also known as the 'my' element.
       * @param {object} info.target
       *   A hash that contains information about the HTML element that the
       *   'my' element will be positioned against. Also known as the 'of'
       *   element.
       */
      function refinePosition(view, suggested, info) {
        // Determine if the pointer should be on the top or bottom.
        var isBelow = suggested.top > info.target.top;
        info.element.element.toggleClass('quickedit-toolbar-pointer-top', isBelow);
        // Don't position the toolbar past the first or last editable field if
        // the entity is the target.
        if (view.$entity[0] === info.target.element[0]) {
          // Get the first or last field according to whether the toolbar is
          // above or below the entity.
          var $field = view.$entity.find('.quickedit-editable').eq((isBelow) ? -1 : 0);
          if ($field.length > 0) {
            suggested.top = (isBelow) ? ($field.offset().top + $field.outerHeight(true)) : $field.offset().top - info.element.element.outerHeight(true);
          }
        }
        // Don't let the toolbar go outside the fence.
        var fenceTop = view.$fence.offset().top;
        var fenceHeight = view.$fence.height();
        var toolbarHeight = info.element.element.outerHeight(true);
        if (suggested.top < fenceTop) {
          suggested.top = fenceTop;
        }
        else if ((suggested.top + toolbarHeight) > (fenceTop + fenceHeight)) {
          suggested.top = fenceTop + fenceHeight - toolbarHeight;
        }
        // Position the toolbar.
        info.element.element.css({
          left: Math.floor(suggested.left),
          top: Math.floor(suggested.top)
        });
      }

      /**
       * Calls the jquery.ui.position() method on the $el of this view.
       */
      function positionToolbar() {
        that.$el
          .position({
            my: edge + ' bottom',
            // Move the toolbar 1px towards the start edge of the 'of' element,
            // plus any horizontal padding that may have been added to the
            // element that is being added, to prevent unwanted horizontal
            // movement.
            at: edge + '+' + (1 + horizontalPadding) + ' top',
            of: of,
            collision: 'flipfit',
            using: refinePosition.bind(null, that),
            within: that.$fence
          })
          // Resize the toolbar to match the dimensions of the field, up to a
          // maximum width that is equal to 90% of the field's width.
          .css({
            'max-width': (document.documentElement.clientWidth < 450) ? document.documentElement.clientWidth : 450,
            // Set a minimum width of 240px for the entity toolbar, or the width
            // of the client if it is less than 240px, so that the toolbar
            // never folds up into a squashed and jumbled mess.
            'min-width': (document.documentElement.clientWidth < 240) ? document.documentElement.clientWidth : 240,
            'width': '100%'
          });
      }

      // Uses the jQuery.ui.position() method. Use a timeout to move the toolbar
      // only after the user has focused on an editable for 250ms. This prevents
      // the toolbar from jumping around the screen.
      this.timer = setTimeout(function () {
        // Render the position in the next execution cycle, so that animations
        // on the field have time to process. This is not strictly speaking, a
        // guarantee that all animations will be finished, but it's a simple
        // way to get better positioning without too much additional code.
        _.defer(positionToolbar);
      }, delay);
    },

    /**
     * Set the model state to 'saving' when the save button is clicked.
     *
     * @param {jQuery.Event} event
     *   The click event.
     */
    onClickSave: function (event) {
      event.stopPropagation();
      event.preventDefault();
      // Save the model.
      this.model.set('state', 'committing');
    },

    /**
     * Sets the model state to candidate when the cancel button is clicked.
     *
     * @param {jQuery.Event} event
     *   The click event.
     */
    onClickCancel: function (event) {
      event.preventDefault();
      this.model.set('state', 'deactivating');
    },

    /**
     * Clears the timeout that will eventually reposition the entity toolbar.
     *
     * Without this, it may reposition itself, away from the user's cursor!
     *
     * @param {jQuery.Event} event
     *   The mouse event.
     */
    onMouseenter: function (event) {
      clearTimeout(this.timer);
    },

    /**
     * Builds the entity toolbar HTML; attaches to DOM; sets starting position.
     *
     * @return {jQuery}
     *   The toolbar element.
     */
    buildToolbarEl: function () {
      var $toolbar = $(Drupal.theme('quickeditEntityToolbar', {
        id: 'quickedit-entity-toolbar'
      }));

      $toolbar
        .find('.quickedit-toolbar-entity')
        // Append the "ops" toolgroup into the toolbar.
        .prepend(Drupal.theme('quickeditToolgroup', {
          classes: ['ops'],
          buttons: [
            {
              label: Drupal.t('Save'),
              type: 'submit',
              classes: 'action-save quickedit-button icon',
              attributes: {
                'aria-hidden': true
              }
            },
            {
              label: Drupal.t('Close'),
              classes: 'action-cancel quickedit-button icon icon-close icon-only'
            }
          ]
        }));

      // Give the toolbar a sensible starting position so that it doesn't
      // animate on to the screen from a far off corner.
      $toolbar
        .css({
          left: this.$entity.offset().left,
          top: this.$entity.offset().top
        });

      return $toolbar;
    },

    /**
     * Returns the DOM element that fields will attach their toolbars to.
     *
     * @return {jQuery}
     *   The DOM element that fields will attach their toolbars to.
     */
    getToolbarRoot: function () {
      return this._fieldToolbarRoot;
    },

    /**
     * Generates a state-dependent label for the entity toolbar.
     */
    label: function () {
      // The entity label.
      var label = '';
      var entityLabel = this.model.get('label');

      // Label of an active field, if it exists.
      var activeField = Drupal.quickedit.app.model.get('activeField');
      var activeFieldLabel = activeField && activeField.get('metadata').label;
      // Label of a highlighted field, if it exists.
      var highlightedField = Drupal.quickedit.app.model.get('highlightedField');
      var highlightedFieldLabel = highlightedField && highlightedField.get('metadata').label;
      // The label is constructed in a priority order.
      if (activeFieldLabel) {
        label = Drupal.theme('quickeditEntityToolbarLabel', {
          entityLabel: entityLabel,
          fieldLabel: activeFieldLabel
        });
      }
      else if (highlightedFieldLabel) {
        label = Drupal.theme('quickeditEntityToolbarLabel', {
          entityLabel: entityLabel,
          fieldLabel: highlightedFieldLabel
        });
      }
      else {
        // @todo Add XSS regression test coverage in https://www.drupal.org/node/2547437
        label = Drupal.checkPlain(entityLabel);
      }

      this.$el
        .find('.quickedit-toolbar-label')
        .html(label);
    },

    /**
     * Adds classes to a toolgroup.
     *
     * @param {string} toolgroup
     *   A toolgroup name.
     * @param {string} classes
     *   A string of space-delimited class names that will be applied to the
     *   wrapping element of the toolbar group.
     */
    addClass: function (toolgroup, classes) {
      this._find(toolgroup).addClass(classes);
    },

    /**
     * Removes classes from a toolgroup.
     *
     * @param {string} toolgroup
     *   A toolgroup name.
     * @param {string} classes
     *   A string of space-delimited class names that will be removed from the
     *   wrapping element of the toolbar group.
     */
    removeClass: function (toolgroup, classes) {
      this._find(toolgroup).removeClass(classes);
    },

    /**
     * Finds a toolgroup.
     *
     * @param {string} toolgroup
     *   A toolgroup name.
     *
     * @return {jQuery}
     *   The toolgroup DOM element.
     */
    _find: function (toolgroup) {
      return this.$el.find('.quickedit-toolbar .quickedit-toolgroup.' + toolgroup);
    },

    /**
     * Shows a toolgroup.
     *
     * @param {string} toolgroup
     *   A toolgroup name.
     */
    show: function (toolgroup) {
      this.$el.removeClass('quickedit-animate-invisible');
    }

  });

})(jQuery, _, Backbone, Drupal, Drupal.debounce);
;
/**
 * @file
 * A Backbone View that provides a dynamic contextual link.
 */

(function ($, Backbone, Drupal) {

  'use strict';

  Drupal.quickedit.ContextualLinkView = Backbone.View.extend(/** @lends Drupal.quickedit.ContextualLinkView# */{

    /**
     * Define all events to listen to.
     *
     * @return {object}
     *   A map of events.
     */
    events: function () {
      // Prevents delay and simulated mouse events.
      function touchEndToClick(event) {
        event.preventDefault();
        event.target.click();
      }

      return {
        'click a': function (event) {
          event.preventDefault();
          this.model.set('state', 'launching');
        },
        'touchEnd a': touchEndToClick
      };
    },

    /**
     * Create a new contextual link view.
     *
     * @constructs
     *
     * @augments Backbone.View
     *
     * @param {object} options
     *   An object with the following keys:
     * @param {Drupal.quickedit.EntityModel} options.model
     *   The associated entity's model.
     * @param {Drupal.quickedit.AppModel} options.appModel
     *   The application state model.
     * @param {object} options.strings
     *   The strings for the "Quick edit" link.
     */
    initialize: function (options) {
      // Insert the text of the quick edit toggle.
      this.$el.find('a').text(options.strings.quickEdit);
      // Initial render.
      this.render();
      // Re-render whenever this entity's isActive attribute changes.
      this.listenTo(this.model, 'change:isActive', this.render);
    },

    /**
     * Render function for the contextual link view.
     *
     * @param {Drupal.quickedit.EntityModel} entityModel
     *   The associated `EntityModel`.
     * @param {bool} isActive
     *   Whether the in-place editor is active or not.
     *
     * @return {Drupal.quickedit.ContextualLinkView}
     *   The `ContextualLinkView` in question.
     */
    render: function (entityModel, isActive) {
      this.$el.find('a').attr('aria-pressed', isActive);

      // Hides the contextual links if an in-place editor is active.
      this.$el.closest('.contextual').toggle(!isActive);

      return this;
    }

  });

})(jQuery, Backbone, Drupal);
;
/**
 * @file
 * A Backbone View that provides an interactive toolbar (1 per in-place editor).
 */

(function ($, _, Backbone, Drupal) {

  'use strict';

  Drupal.quickedit.FieldToolbarView = Backbone.View.extend(/** @lends Drupal.quickedit.FieldToolbarView# */{

    /**
     * The edited element, as indicated by EditorView.getEditedElement.
     *
     * @type {jQuery}
     */
    $editedElement: null,

    /**
     * A reference to the in-place editor.
     *
     * @type {Drupal.quickedit.EditorView}
     */
    editorView: null,

    /**
     * @type {string}
     */
    _id: null,

    /**
     * @constructs
     *
     * @augments Backbone.View
     *
     * @param {object} options
     *   Options object to construct the field toolbar.
     * @param {jQuery} options.$editedElement
     *   The element being edited.
     * @param {Drupal.quickedit.EditorView} options.editorView
     *   The EditorView the toolbar belongs to.
     */
    initialize: function (options) {
      this.$editedElement = options.$editedElement;
      this.editorView = options.editorView;

      /**
       * @type {jQuery}
       */
      this.$root = this.$el;

      // Generate a DOM-compatible ID for the form container DOM element.
      this._id = 'quickedit-toolbar-for-' + this.model.id.replace(/[\/\[\]]/g, '_');

      this.listenTo(this.model, 'change:state', this.stateChange);
    },

    /**
     * @inheritdoc
     *
     * @return {Drupal.quickedit.FieldToolbarView}
     *   The current FieldToolbarView.
     */
    render: function () {
      // Render toolbar and set it as the view's element.
      this.setElement($(Drupal.theme('quickeditFieldToolbar', {
        id: this._id
      })));

      // Attach to the field toolbar $root element in the entity toolbar.
      this.$el.prependTo(this.$root);

      return this;
    },

    /**
     * Determines the actions to take given a change of state.
     *
     * @param {Drupal.quickedit.FieldModel} model
     *   The quickedit FieldModel
     * @param {string} state
     *   The state of the associated field. One of
     *   {@link Drupal.quickedit.FieldModel.states}.
     */
    stateChange: function (model, state) {
      var from = model.previous('state');
      var to = state;
      switch (to) {
        case 'inactive':
          break;

        case 'candidate':
          // Remove the view's existing element if we went to the 'activating'
          // state or later, because it will be recreated. Not doing this would
          // result in memory leaks.
          if (from !== 'inactive' && from !== 'highlighted') {
            this.$el.remove();
            this.setElement();
          }
          break;

        case 'highlighted':
          break;

        case 'activating':
          this.render();

          if (this.editorView.getQuickEditUISettings().fullWidthToolbar) {
            this.$el.addClass('quickedit-toolbar-fullwidth');
          }

          if (this.editorView.getQuickEditUISettings().unifiedToolbar) {
            this.insertWYSIWYGToolGroups();
          }
          break;

        case 'active':
          break;

        case 'changed':
          break;

        case 'saving':
          break;

        case 'saved':
          break;

        case 'invalid':
          break;
      }
    },

    /**
     * Insert WYSIWYG markup into the associated toolbar.
     */
    insertWYSIWYGToolGroups: function () {
      this.$el
        .append(Drupal.theme('quickeditToolgroup', {
          id: this.getFloatedWysiwygToolgroupId(),
          classes: ['wysiwyg-floated', 'quickedit-animate-slow', 'quickedit-animate-invisible', 'quickedit-animate-delay-veryfast'],
          buttons: []
        }))
        .append(Drupal.theme('quickeditToolgroup', {
          id: this.getMainWysiwygToolgroupId(),
          classes: ['wysiwyg-main', 'quickedit-animate-slow', 'quickedit-animate-invisible', 'quickedit-animate-delay-veryfast'],
          buttons: []
        }));

      // Animate the toolgroups into visibility.
      this.show('wysiwyg-floated');
      this.show('wysiwyg-main');
    },

    /**
     * Retrieves the ID for this toolbar's container.
     *
     * Only used to make sane hovering behavior possible.
     *
     * @return {string}
     *   A string that can be used as the ID for this toolbar's container.
     */
    getId: function () {
      return 'quickedit-toolbar-for-' + this._id;
    },

    /**
     * Retrieves the ID for this toolbar's floating WYSIWYG toolgroup.
     *
     * Used to provide an abstraction for any WYSIWYG editor to plug in.
     *
     * @return {string}
     *   A string that can be used as the ID.
     */
    getFloatedWysiwygToolgroupId: function () {
      return 'quickedit-wysiwyg-floated-toolgroup-for-' + this._id;
    },

    /**
     * Retrieves the ID for this toolbar's main WYSIWYG toolgroup.
     *
     * Used to provide an abstraction for any WYSIWYG editor to plug in.
     *
     * @return {string}
     *   A string that can be used as the ID.
     */
    getMainWysiwygToolgroupId: function () {
      return 'quickedit-wysiwyg-main-toolgroup-for-' + this._id;
    },

    /**
     * Finds a toolgroup.
     *
     * @param {string} toolgroup
     *   A toolgroup name.
     *
     * @return {jQuery}
     *   The toolgroup element.
     */
    _find: function (toolgroup) {
      return this.$el.find('.quickedit-toolgroup.' + toolgroup);
    },

    /**
     * Shows a toolgroup.
     *
     * @param {string} toolgroup
     *   A toolgroup name.
     */
    show: function (toolgroup) {
      var $group = this._find(toolgroup);
      // Attach a transitionEnd event handler to the toolbar group so that
      // update events can be triggered after the animations have ended.
      $group.on(Drupal.quickedit.util.constants.transitionEnd, function (event) {
        $group.off(Drupal.quickedit.util.constants.transitionEnd);
      });
      // The call to remove the class and start the animation must be started in
      // the next animation frame or the event handler attached above won't be
      // triggered.
      window.setTimeout(function () {
        $group.removeClass('quickedit-animate-invisible');
      }, 0);
    }

  });

})(jQuery, _, Backbone, Drupal);
;
/**
 * @file
 * An abstract Backbone View that controls an in-place editor.
 */

(function ($, Backbone, Drupal) {

  'use strict';

  Drupal.quickedit.EditorView = Backbone.View.extend(/** @lends Drupal.quickedit.EditorView# */{

    /**
     * A base implementation that outlines the structure for in-place editors.
     *
     * Specific in-place editor implementations should subclass (extend) this
     * View and override whichever method they deem necessary to override.
     *
     * Typically you would want to override this method to set the
     * originalValue attribute in the FieldModel to such a value that your
     * in-place editor can revert to the original value when necessary.
     *
     * @example
     * <caption>If you override this method, you should call this
     * method (the parent class' initialize()) first.</caption>
     * Drupal.quickedit.EditorView.prototype.initialize.call(this, options);
     *
     * @constructs
     *
     * @augments Backbone.View
     *
     * @param {object} options
     *   An object with the following keys:
     * @param {Drupal.quickedit.EditorModel} options.model
     *   The in-place editor state model.
     * @param {Drupal.quickedit.FieldModel} options.fieldModel
     *   The field model.
     *
     * @see Drupal.quickedit.EditorModel
     * @see Drupal.quickedit.editors.plain_text
     */
    initialize: function (options) {
      this.fieldModel = options.fieldModel;
      this.listenTo(this.fieldModel, 'change:state', this.stateChange);
    },

    /**
     * @inheritdoc
     */
    remove: function () {
      // The el property is the field, which should not be removed. Remove the
      // pointer to it, then call Backbone.View.prototype.remove().
      this.setElement();
      Backbone.View.prototype.remove.call(this);
    },

    /**
     * Returns the edited element.
     *
     * For some single cardinality fields, it may be necessary or useful to
     * not in-place edit (and hence decorate) the DOM element with the
     * data-quickedit-field-id attribute (which is the field's wrapper), but a
     * specific element within the field's wrapper.
     * e.g. using a WYSIWYG editor on a body field should happen on the DOM
     * element containing the text itself, not on the field wrapper.
     *
     * @return {jQuery}
     *   A jQuery-wrapped DOM element.
     *
     * @see Drupal.quickedit.editors.plain_text
     */
    getEditedElement: function () {
      return this.$el;
    },

    /**
     *
     * @return {object}
     * Returns 3 Quick Edit UI settings that depend on the in-place editor:
     *  - Boolean padding: indicates whether padding should be applied to the
     *    edited element, to guarantee legibility of text.
     *  - Boolean unifiedToolbar: provides the in-place editor with the ability
     *    to insert its own toolbar UI into Quick Edit's tightly integrated
     *    toolbar.
     *  - Boolean fullWidthToolbar: indicates whether Quick Edit's tightly
     *    integrated toolbar should consume the full width of the element,
     *    rather than being just long enough to accommodate a label.
     */
    getQuickEditUISettings: function () {
      return {padding: false, unifiedToolbar: false, fullWidthToolbar: false, popup: false};
    },

    /**
     * Determines the actions to take given a change of state.
     *
     * @param {Drupal.quickedit.FieldModel} fieldModel
     *   The quickedit `FieldModel` that holds the state.
     * @param {string} state
     *   The state of the associated field. One of
     *   {@link Drupal.quickedit.FieldModel.states}.
     */
    stateChange: function (fieldModel, state) {
      var from = fieldModel.previous('state');
      var to = state;
      switch (to) {
        case 'inactive':
          // An in-place editor view will not yet exist in this state, hence
          // this will never be reached. Listed for sake of completeness.
          break;

        case 'candidate':
          // Nothing to do for the typical in-place editor: it should not be
          // visible yet. Except when we come from the 'invalid' state, then we
          // clean up.
          if (from === 'invalid') {
            this.removeValidationErrors();
          }
          break;

        case 'highlighted':
          // Nothing to do for the typical in-place editor: it should not be
          // visible yet.
          break;

        case 'activating':
          // The user has indicated he wants to do in-place editing: if
          // something needs to be loaded (CSS/JavaScript/server data/…), then
          // do so at this stage, and once the in-place editor is ready,
          // set the 'active' state. A "loading" indicator will be shown in the
          // UI for as long as the field remains in this state.
          var loadDependencies = function (callback) {
            // Do the loading here.
            callback();
          };
          loadDependencies(function () {
            fieldModel.set('state', 'active');
          });
          break;

        case 'active':
          // The user can now actually use the in-place editor.
          break;

        case 'changed':
          // Nothing to do for the typical in-place editor. The UI will show an
          // indicator that the field has changed.
          break;

        case 'saving':
          // When the user has indicated he wants to save his changes to this
          // field, this state will be entered. If the previous saving attempt
          // resulted in validation errors, the previous state will be
          // 'invalid'. Clean up those validation errors while the user is
          // saving.
          if (from === 'invalid') {
            this.removeValidationErrors();
          }
          this.save();
          break;

        case 'saved':
          // Nothing to do for the typical in-place editor. Immediately after
          // being saved, a field will go to the 'candidate' state, where it
          // should no longer be visible (after all, the field will then again
          // just be a *candidate* to be in-place edited).
          break;

        case 'invalid':
          // The modified field value was attempted to be saved, but there were
          // validation errors.
          this.showValidationErrors();
          break;
      }
    },

    /**
     * Reverts the modified value to the original, before editing started.
     */
    revert: function () {
      // A no-op by default; each editor should implement reverting itself.
      // Note that if the in-place editor does not cause the FieldModel's
      // element to be modified, then nothing needs to happen.
    },

    /**
     * Saves the modified value in the in-place editor for this field.
     */
    save: function () {
      var fieldModel = this.fieldModel;
      var editorModel = this.model;
      var backstageId = 'quickedit_backstage-' + this.fieldModel.id.replace(/[\/\[\]\_\s]/g, '-');

      function fillAndSubmitForm(value) {
        var $form = $('#' + backstageId).find('form');
        // Fill in the value in any <input> that isn't hidden or a submit
        // button.
        $form.find(':input[type!="hidden"][type!="submit"]:not(select)')
          // Don't mess with the node summary.
          .not('[name$="\\[summary\\]"]').val(value);
        // Submit the form.
        $form.find('.quickedit-form-submit').trigger('click.quickedit');
      }

      var formOptions = {
        fieldID: this.fieldModel.get('fieldID'),
        $el: this.$el,
        nocssjs: true,
        other_view_modes: fieldModel.findOtherViewModes(),
        // Reset an existing entry for this entity in the PrivateTempStore (if
        // any) when saving the field. Logically speaking, this should happen in
        // a separate request because this is an entity-level operation, not a
        // field-level operation. But that would require an additional request,
        // that might not even be necessary: it is only when a user saves a
        // first changed field for an entity that this needs to happen:
        // precisely now!
        reset: !this.fieldModel.get('entity').get('inTempStore')
      };

      var self = this;
      Drupal.quickedit.util.form.load(formOptions, function (form, ajax) {
        // Create a backstage area for storing forms that are hidden from view
        // (hence "backstage" — since the editing doesn't happen in the form, it
        // happens "directly" in the content, the form is only used for saving).
        var $backstage = $(Drupal.theme('quickeditBackstage', {id: backstageId})).appendTo('body');
        // Hidden forms are stuffed into the backstage container for this field.
        var $form = $(form).appendTo($backstage);
        // Disable the browser's HTML5 validation; we only care about server-
        // side validation. (Not disabling this will actually cause problems
        // because browsers don't like to set HTML5 validation errors on hidden
        // forms.)
        $form.prop('novalidate', true);
        var $submit = $form.find('.quickedit-form-submit');
        self.formSaveAjax = Drupal.quickedit.util.form.ajaxifySaving(formOptions, $submit);

        function removeHiddenForm() {
          Drupal.quickedit.util.form.unajaxifySaving(self.formSaveAjax);
          delete self.formSaveAjax;
          $backstage.remove();
        }

        // Successfully saved.
        self.formSaveAjax.commands.quickeditFieldFormSaved = function (ajax, response, status) {
          removeHiddenForm();
          // First, transition the state to 'saved'.
          fieldModel.set('state', 'saved');
          // Second, set the 'htmlForOtherViewModes' attribute, so that when
          // this field is rerendered, the change can be propagated to other
          // instances of this field, which may be displayed in different view
          // modes.
          fieldModel.set('htmlForOtherViewModes', response.other_view_modes);
          // Finally, set the 'html' attribute on the field model. This will
          // cause the field to be rerendered.
          fieldModel.set('html', response.data);
        };

        // Unsuccessfully saved; validation errors.
        self.formSaveAjax.commands.quickeditFieldFormValidationErrors = function (ajax, response, status) {
          removeHiddenForm();
          editorModel.set('validationErrors', response.data);
          fieldModel.set('state', 'invalid');
        };

        // The quickeditFieldForm AJAX command is only called upon loading the
        // form for the first time, and when there are validation errors in the
        // form; Form API then marks which form items have errors. This is
        // useful for the form-based in-place editor, but pointless for any
        // other: the form itself won't be visible at all anyway! So, we just
        // ignore it.
        self.formSaveAjax.commands.quickeditFieldForm = function () {};

        fillAndSubmitForm(editorModel.get('currentValue'));
      });
    },

    /**
     * Shows validation error messages.
     *
     * Should be called when the state is changed to 'invalid'.
     */
    showValidationErrors: function () {
      var $errors = $('<div class="quickedit-validation-errors"></div>')
        .append(this.model.get('validationErrors'));
      this.getEditedElement()
        .addClass('quickedit-validation-error')
        .after($errors);
    },

    /**
     * Cleans up validation error messages.
     *
     * Should be called when the state is changed to 'candidate' or 'saving'. In
     * the case of the latter: the user has modified the value in the in-place
     * editor again to attempt to save again. In the case of the latter: the
     * invalid value was discarded.
     */
    removeValidationErrors: function () {
      this.getEditedElement()
        .removeClass('quickedit-validation-error')
        .next('.quickedit-validation-errors')
        .remove();
    }

  });

}(jQuery, Backbone, Drupal));
;
/**
 * @file
 * Provides theme functions for all of Quick Edit's client-side HTML.
 */

(function ($, Drupal) {

  'use strict';

  /**
   * Theme function for a "backstage" for the Quick Edit module.
   *
   * @param {object} settings
   *   Settings object used to construct the markup.
   * @param {string} settings.id
   *   The id to apply to the backstage.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditBackstage = function (settings) {
    var html = '';
    html += '<div id="' + settings.id + '" />';
    return html;
  };

  /**
   * Theme function for a toolbar container of the Quick Edit module.
   *
   * @param {object} settings
   *   Settings object used to construct the markup.
   * @param {string} settings.id
   *   the id to apply to the backstage.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditEntityToolbar = function (settings) {
    var html = '';
    html += '<div id="' + settings.id + '" class="quickedit quickedit-toolbar-container clearfix">';
    html += '<i class="quickedit-toolbar-pointer"></i>';
    html += '<div class="quickedit-toolbar-content">';
    html += '<div class="quickedit-toolbar quickedit-toolbar-entity clearfix icon icon-pencil">';
    html += '<div class="quickedit-toolbar-label" />';
    html += '</div>';
    html += '<div class="quickedit-toolbar quickedit-toolbar-field clearfix" />';
    html += '</div><div class="quickedit-toolbar-lining"></div></div>';
    return html;
  };

  /**
   * Theme function for a toolbar container of the Quick Edit module.
   *
   * @param {object} settings
   *   Settings object used to construct the markup.
   * @param {string} settings.entityLabel
   *   The title of the active entity.
   * @param {string} settings.fieldLabel
   *   The label of the highlighted or active field.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditEntityToolbarLabel = function (settings) {
    // @todo Add XSS regression test coverage in https://www.drupal.org/node/2547437
    return '<span class="field">' + Drupal.checkPlain(settings.fieldLabel) + '</span>' + Drupal.checkPlain(settings.entityLabel);
  };

  /**
   * Element defining a containing box for the placement of the entity toolbar.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditEntityToolbarFence = function () {
    return '<div id="quickedit-toolbar-fence" />';
  };

  /**
   * Theme function for a toolbar container of the Quick Edit module.
   *
   * @param {object} settings
   *   Settings object used to construct the markup.
   * @param {string} settings.id
   *   The id to apply to the toolbar container.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditFieldToolbar = function (settings) {
    return '<div id="' + settings.id + '" />';
  };

  /**
   * Theme function for a toolbar toolgroup of the Quick Edit module.
   *
   * @param {object} settings
   *   Settings object used to construct the markup.
   * @param {string} [settings.id]
   *   The id of the toolgroup.
   * @param {string} settings.classes
   *   The class of the toolgroup.
   * @param {Array} settings.buttons
   *   See {@link Drupal.theme.quickeditButtons}.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditToolgroup = function (settings) {
    // Classes.
    var classes = (settings.classes || []);
    classes.unshift('quickedit-toolgroup');
    var html = '';
    html += '<div class="' + classes.join(' ') + '"';
    if (settings.id) {
      html += ' id="' + settings.id + '"';
    }
    html += '>';
    html += Drupal.theme('quickeditButtons', {buttons: settings.buttons});
    html += '</div>';
    return html;
  };

  /**
   * Theme function for buttons of the Quick Edit module.
   *
   * Can be used for the buttons both in the toolbar toolgroups and in the
   * modal.
   *
   * @param {object} settings
   *   Settings object used to construct the markup.
   * @param {Array} settings.buttons
   * - String type: the type of the button (defaults to 'button')
   * - Array classes: the classes of the button.
   * - String label: the label of the button.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditButtons = function (settings) {
    var html = '';
    for (var i = 0; i < settings.buttons.length; i++) {
      var button = settings.buttons[i];
      if (!button.hasOwnProperty('type')) {
        button.type = 'button';
      }
      // Attributes.
      var attributes = [];
      var attrMap = settings.buttons[i].attributes || {};
      for (var attr in attrMap) {
        if (attrMap.hasOwnProperty(attr)) {
          attributes.push(attr + ((attrMap[attr]) ? '="' + attrMap[attr] + '"' : ''));
        }
      }
      html += '<button type="' + button.type + '" class="' + button.classes + '"' + ' ' + attributes.join(' ') + '>';
      html += button.label;
      html += '</button>';
    }
    return html;
  };

  /**
   * Theme function for a form container of the Quick Edit module.
   *
   * @param {object} settings
   *   Settings object used to construct the markup.
   * @param {string} settings.id
   *   The id to apply to the toolbar container.
   * @param {string} settings.loadingMsg
   *   The message to show while loading.
   *
   * @return {string}
   *   The corresponding HTML.
   */
  Drupal.theme.quickeditFormContainer = function (settings) {
    var html = '';
    html += '<div id="' + settings.id + '" class="quickedit-form-container">';
    html += '  <div class="quickedit-form">';
    html += '    <div class="placeholder">';
    html += settings.loadingMsg;
    html += '    </div>';
    html += '  </div>';
    html += '</div>';
    return html;
  };

})(jQuery, Drupal);
;
/**
 * @file
 * Attaches behaviors for Drupal's active link marking.
 */

(function (Drupal, drupalSettings) {

  'use strict';

  /**
   * Append is-active class.
   *
   * The link is only active if its path corresponds to the current path, the
   * language of the linked path is equal to the current language, and if the
   * query parameters of the link equal those of the current request, since the
   * same request with different query parameters may yield a different page
   * (e.g. pagers, exposed View filters).
   *
   * Does not discriminate based on element type, so allows you to set the
   * is-active class on any element: a, li…
   *
   * @type {Drupal~behavior}
   */
  Drupal.behaviors.activeLinks = {
    attach: function (context) {
      // Start by finding all potentially active links.
      var path = drupalSettings.path;
      var queryString = JSON.stringify(path.currentQuery);
      var querySelector = path.currentQuery ? "[data-drupal-link-query='" + queryString + "']" : ':not([data-drupal-link-query])';
      var originalSelectors = ['[data-drupal-link-system-path="' + path.currentPath + '"]'];
      var selectors;

      // If this is the front page, we have to check for the <front> path as
      // well.
      if (path.isFront) {
        originalSelectors.push('[data-drupal-link-system-path="<front>"]');
      }

      // Add language filtering.
      selectors = [].concat(
        // Links without any hreflang attributes (most of them).
        originalSelectors.map(function (selector) { return selector + ':not([hreflang])'; }),
        // Links with hreflang equals to the current language.
        originalSelectors.map(function (selector) { return selector + '[hreflang="' + path.currentLanguage + '"]'; })
      );

      // Add query string selector for pagers, exposed filters.
      selectors = selectors.map(function (current) { return current + querySelector; });

      // Query the DOM.
      var activeLinks = context.querySelectorAll(selectors.join(','));
      var il = activeLinks.length;
      for (var i = 0; i < il; i++) {
        activeLinks[i].classList.add('is-active');
      }
    },
    detach: function (context, settings, trigger) {
      if (trigger === 'unload') {
        var activeLinks = context.querySelectorAll('[data-drupal-link-system-path].is-active');
        var il = activeLinks.length;
        for (var i = 0; i < il; i++) {
          activeLinks[i].classList.remove('is-active');
        }
      }
    }
  };

})(Drupal, drupalSettings);
;
/**
 * @file
 * Bootstrap Popovers.
 */

var Drupal = Drupal || {};

(function ($, Drupal, Bootstrap) {
  "use strict";

  /**
   * Extend the Bootstrap Popover plugin constructor class.
   */
  Bootstrap.extendPlugin('popover', function (settings) {
    return {
      DEFAULTS: {
        animation: !!settings.popover_animation,
        html: !!settings.popover_html,
        placement: settings.popover_placement,
        selector: settings.popover_selector,
        trigger: settings.popover_trigger,
        triggerAutoclose: !!settings.popover_trigger_autoclose,
        title: settings.popover_title,
        content: settings.popover_content,
        delay: parseInt(settings.popover_delay, 10),
        container: settings.popover_container
      }
    };
  });

  /**
   * Bootstrap Popovers.
   *
   * @todo This should really be properly delegated if selector option is set.
   */
  Drupal.behaviors.bootstrapPopovers = {
    attach: function (context) {

      // Popover autoclose.
      if ($.fn.popover.Constructor.DEFAULTS.triggerAutoclose) {
        var $currentPopover = null;
        $(document)
          .on('show.bs.popover', '[data-toggle=popover]', function () {
            var $trigger = $(this);
            var popover = $trigger.data('bs.popover');

            // Only keep track of clicked triggers that we're manually handling.
            if (popover.options.originalTrigger === 'click') {
              if ($currentPopover && !$currentPopover.is($trigger)) {
                $currentPopover.popover('hide');
              }
              $currentPopover = $trigger;
            }
          })
          .on('click', function (e) {
            var $target = $(e.target);
            var popover = $target.is('[data-toggle=popover]') && $target.data('bs.popover');
            if ($currentPopover && !$target.is('[data-toggle=popover]') && !$target.closest('.popover.in')[0]) {
              $currentPopover.popover('hide');
              $currentPopover = null;
            }
          })
        ;
      }

      var elements = $(context).find('[data-toggle=popover]').toArray();
      for (var i = 0; i < elements.length; i++) {
        var $element = $(elements[i]);
        var options = $.extend({}, $.fn.popover.Constructor.DEFAULTS, $element.data());

        // Store the original trigger.
        options.originalTrigger = options.trigger;

        // If the trigger is "click", then we'll handle it manually here.
        if (options.trigger === 'click') {
          options.trigger = 'manual';
        }

        // Retrieve content from a target element.
        var $target = $(options.target || $element.is('a[href^="#"]') && $element.attr('href')).clone();
        if (!options.content && $target[0]) {
          $target.removeClass('visually-hidden hidden').removeAttr('aria-hidden');
          options.content = $target.wrap('<div/>').parent()[options.html ? 'html' : 'text']() || '';
        }

        // Initialize the popover.
        $element.popover(options);

        // Handle clicks manually.
        if (options.originalTrigger === 'click') {
          // To ensure the element is bound multiple times, remove any
          // previously set event handler before adding another one.
          $element
            .off('click.drupal.bootstrap.popover')
            .on('click.drupal.bootstrap.popover', function (e) {
              $(this).popover('toggle');
              e.preventDefault();
              e.stopPropagation();
            })
          ;
        }
      }
    },
    detach: function (context) {
      // Destroy all popovers.
      $(context).find('[data-toggle="popover"]')
        .off('click.drupal.bootstrap.popover')
        .popover('destroy')
      ;
    }
  };

})(window.jQuery, window.Drupal, window.Drupal.bootstrap);
;
/**
 * @file
 * Bootstrap Tooltips.
 */

var Drupal = Drupal || {};

(function ($, Drupal, Bootstrap) {
  "use strict";

  /**
   * Extend the Bootstrap Tooltip plugin constructor class.
   */
  Bootstrap.extendPlugin('tooltip', function (settings) {
    return {
      DEFAULTS: {
        animation: !!settings.tooltip_animation,
        html: !!settings.tooltip_html,
        placement: settings.tooltip_placement,
        selector: settings.tooltip_selector,
        trigger: settings.tooltip_trigger,
        delay: parseInt(settings.tooltip_delay, 10),
        container: settings.tooltip_container
      }
    };
  });

  /**
   * Bootstrap Tooltips.
   *
   * @todo This should really be properly delegated if selector option is set.
   */
  Drupal.behaviors.bootstrapTooltips = {
    attach: function (context) {
      var elements = $(context).find('[data-toggle="tooltip"]').toArray();
      for (var i = 0; i < elements.length; i++) {
        var $element = $(elements[i]);
        var options = $.extend({}, $.fn.tooltip.Constructor.DEFAULTS, $element.data());
        $element.tooltip(options);
      }
    },
    detach: function (context) {
      // Destroy all tooltips.
      $(context).find('[data-toggle="tooltip"]').tooltip('destroy');
    }
  };

})(window.jQuery, window.Drupal, window.Drupal.bootstrap);
;
/**
 * @file
 * JavaScript API for the History module, with client-side caching.
 *
 * May only be loaded for authenticated users, with the History module enabled.
 */

(function ($, Drupal, drupalSettings, storage) {

  'use strict';

  var currentUserID = parseInt(drupalSettings.user.uid, 10);

  // Any comment that is older than 30 days is automatically considered read,
  // so for these we don't need to perform a request at all!
  var thirtyDaysAgo = Math.round(new Date().getTime() / 1000) - 30 * 24 * 60 * 60;

  // Use the data embedded in the page, if available.
  var embeddedLastReadTimestamps = false;
  if (drupalSettings.history && drupalSettings.history.lastReadTimestamps) {
    embeddedLastReadTimestamps = drupalSettings.history.lastReadTimestamps;
  }

  /**
   * @namespace
   */
  Drupal.history = {

    /**
     * Fetch "last read" timestamps for the given nodes.
     *
     * @param {Array} nodeIDs
     *   An array of node IDs.
     * @param {function} callback
     *   A callback that is called after the requested timestamps were fetched.
     */
    fetchTimestamps: function (nodeIDs, callback) {
      // Use the data embedded in the page, if available.
      if (embeddedLastReadTimestamps) {
        callback();
        return;
      }

      $.ajax({
        url: Drupal.url('history/get_node_read_timestamps'),
        type: 'POST',
        data: {'node_ids[]': nodeIDs},
        dataType: 'json',
        success: function (results) {
          for (var nodeID in results) {
            if (results.hasOwnProperty(nodeID)) {
              storage.setItem('Drupal.history.' + currentUserID + '.' + nodeID, results[nodeID]);
            }
          }
          callback();
        }
      });
    },

    /**
     * Get the last read timestamp for the given node.
     *
     * @param {number|string} nodeID
     *   A node ID.
     *
     * @return {number}
     *   A UNIX timestamp.
     */
    getLastRead: function (nodeID) {
      // Use the data embedded in the page, if available.
      if (embeddedLastReadTimestamps && embeddedLastReadTimestamps[nodeID]) {
        return parseInt(embeddedLastReadTimestamps[nodeID], 10);
      }
      return parseInt(storage.getItem('Drupal.history.' + currentUserID + '.' + nodeID) || 0, 10);
    },

    /**
     * Marks a node as read, store the last read timestamp client-side.
     *
     * @param {number|string} nodeID
     *   A node ID.
     */
    markAsRead: function (nodeID) {
      $.ajax({
        url: Drupal.url('history/' + nodeID + '/read'),
        type: 'POST',
        dataType: 'json',
        success: function (timestamp) {
          // If the data is embedded in the page, don't store on the client
          // side.
          if (embeddedLastReadTimestamps && embeddedLastReadTimestamps[nodeID]) {
            return;
          }

          storage.setItem('Drupal.history.' + currentUserID + '.' + nodeID, timestamp);
        }
      });
    },

    /**
     * Determines whether a server check is necessary.
     *
     * Any content that is >30 days old never gets a "new" or "updated"
     * indicator. Any content that was published before the oldest known reading
     * also never gets a "new" or "updated" indicator, because it must've been
     * read already.
     *
     * @param {number|string} nodeID
     *   A node ID.
     * @param {number} contentTimestamp
     *   The time at which some content (e.g. a comment) was published.
     *
     * @return {bool}
     *   Whether a server check is necessary for the given node and its
     *   timestamp.
     */
    needsServerCheck: function (nodeID, contentTimestamp) {
      // First check if the content is older than 30 days, then we can bail
      // early.
      if (contentTimestamp < thirtyDaysAgo) {
        return false;
      }

      // Use the data embedded in the page, if available.
      if (embeddedLastReadTimestamps && embeddedLastReadTimestamps[nodeID]) {
        return contentTimestamp > parseInt(embeddedLastReadTimestamps[nodeID], 10);
      }

      var minLastReadTimestamp = parseInt(storage.getItem('Drupal.history.' + currentUserID + '.' + nodeID) || 0, 10);
      return contentTimestamp > minLastReadTimestamp;
    }
  };

})(jQuery, Drupal, drupalSettings, window.localStorage);
;
/**
 * Attaches behaviors for the Tracker module's History module integration.
 *
 * May only be loaded for authenticated users, with the History module enabled.
 */
(function ($, Drupal, window) {

  'use strict';

  /**
   * Render "new" and "updated" node indicators, as well as "X new" replies links.
   */
  Drupal.behaviors.trackerHistory = {
    attach: function (context) {
      // Find all "new" comment indicator placeholders newer than 30 days ago that
      // have not already been read after their last comment timestamp.
      var nodeIDs = [];
      var $nodeNewPlaceholders = $(context)
        .find('[data-history-node-timestamp]')
        .once('history')
        .filter(function () {
          var nodeTimestamp = parseInt(this.getAttribute('data-history-node-timestamp'), 10);
          var nodeID = this.getAttribute('data-history-node-id');
          if (Drupal.history.needsServerCheck(nodeID, nodeTimestamp)) {
            nodeIDs.push(nodeID);
            return true;
          }
          else {
            return false;
          }
        });

      // Find all "new" comment indicator placeholders newer than 30 days ago that
      // have not already been read after their last comment timestamp.
      var $newRepliesPlaceholders = $(context)
        .find('[data-history-node-last-comment-timestamp]')
        .once('history')
        .filter(function () {
          var lastCommentTimestamp = parseInt(this.getAttribute('data-history-node-last-comment-timestamp'), 10);
          var nodeTimestamp = parseInt(this.previousSibling.previousSibling.getAttribute('data-history-node-timestamp'), 10);
          // Discard placeholders that have zero comments.
          if (lastCommentTimestamp === nodeTimestamp) {
            return false;
          }
          var nodeID = this.previousSibling.previousSibling.getAttribute('data-history-node-id');
          if (Drupal.history.needsServerCheck(nodeID, lastCommentTimestamp)) {
            if (nodeIDs.indexOf(nodeID) === -1) {
              nodeIDs.push(nodeID);
            }
            return true;
          }
          else {
            return false;
          }
        });

      if ($nodeNewPlaceholders.length === 0 && $newRepliesPlaceholders.length === 0) {
        return;
      }

      // Fetch the node read timestamps from the server.
      Drupal.history.fetchTimestamps(nodeIDs, function () {
        processNodeNewIndicators($nodeNewPlaceholders);
        processNewRepliesIndicators($newRepliesPlaceholders);
      });
    }
  };

  function processNodeNewIndicators($placeholders) {
    var newNodeString = Drupal.t('new');
    var updatedNodeString = Drupal.t('updated');

    $placeholders.each(function (index, placeholder) {
      var timestamp = parseInt(placeholder.getAttribute('data-history-node-timestamp'), 10);
      var nodeID = placeholder.getAttribute('data-history-node-id');
      var lastViewTimestamp = Drupal.history.getLastRead(nodeID);

      if (timestamp > lastViewTimestamp) {
        var message = (lastViewTimestamp === 0) ? newNodeString : updatedNodeString;
        $(placeholder).append('<span class="marker">' + message + '</span>');
      }
    });
  }

  function processNewRepliesIndicators($placeholders) {
    // Figure out which placeholders need the "x new" replies links.
    var placeholdersToUpdate = {};
    $placeholders.each(function (index, placeholder) {
      var timestamp = parseInt(placeholder.getAttribute('data-history-node-last-comment-timestamp'), 10);
      var nodeID = placeholder.previousSibling.previousSibling.getAttribute('data-history-node-id');
      var lastViewTimestamp = Drupal.history.getLastRead(nodeID);

      // Queue this placeholder's "X new" replies link to be downloaded from the
      // server.
      if (timestamp > lastViewTimestamp) {
        placeholdersToUpdate[nodeID] = placeholder;
      }
    });

    // Perform an AJAX request to retrieve node view timestamps.
    var nodeIDs = Object.keys(placeholdersToUpdate);
    if (nodeIDs.length === 0) {
      return;
    }
    $.ajax({
      url: Drupal.url('comments/render_new_comments_node_links'),
      type: 'POST',
      data: {'node_ids[]': nodeIDs},
      dataType: 'json',
      success: function (results) {
        for (var nodeID in results) {
          if (results.hasOwnProperty(nodeID) && placeholdersToUpdate.hasOwnProperty(nodeID)) {
            var url = results[nodeID].first_new_comment_link;
            var text = Drupal.formatPlural(results[nodeID].new_comment_count, '1 new', '@count new');
            $(placeholdersToUpdate[nodeID]).append('<br /><a href="' + url + '">' + text + '</a>');
          }
        }
      }
    });
  }

})(jQuery, Drupal, window);
;
/**
 * @file
 * Responsive table functionality.
 */

(function ($, Drupal, window) {

  'use strict';

  /**
   * Attach the tableResponsive function to {@link Drupal.behaviors}.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *   Attaches tableResponsive functionality.
   */
  Drupal.behaviors.tableResponsive = {
    attach: function (context, settings) {
      var $tables = $(context).find('table.responsive-enabled').once('tableresponsive');
      if ($tables.length) {
        var il = $tables.length;
        for (var i = 0; i < il; i++) {
          TableResponsive.tables.push(new TableResponsive($tables[i]));
        }
      }
    }
  };

  /**
   * The TableResponsive object optimizes table presentation for screen size.
   *
   * A responsive table hides columns at small screen sizes, leaving the most
   * important columns visible to the end user. Users should not be prevented
   * from accessing all columns, however. This class adds a toggle to a table
   * with hidden columns that exposes the columns. Exposing the columns will
   * likely break layouts, but it provides the user with a means to access
   * data, which is a guiding principle of responsive design.
   *
   * @constructor Drupal.TableResponsive
   *
   * @param {HTMLElement} table
   *   The table element to initialize the responsive table on.
   */
  function TableResponsive(table) {
    this.table = table;
    this.$table = $(table);
    this.showText = Drupal.t('Show all columns');
    this.hideText = Drupal.t('Hide lower priority columns');
    // Store a reference to the header elements of the table so that the DOM is
    // traversed only once to find them.
    this.$headers = this.$table.find('th');
    // Add a link before the table for users to show or hide weight columns.
    this.$link = $('<button type="button" class="link tableresponsive-toggle"></button>')
      .attr('title', Drupal.t('Show table cells that were hidden to make the table fit within a small screen.'))
      .on('click', $.proxy(this, 'eventhandlerToggleColumns'));

    this.$table.before($('<div class="tableresponsive-toggle-columns"></div>').append(this.$link));

    // Attach a resize handler to the window.
    $(window)
      .on('resize.tableresponsive', $.proxy(this, 'eventhandlerEvaluateColumnVisibility'))
      .trigger('resize.tableresponsive');
  }

  /**
   * Extend the TableResponsive function with a list of managed tables.
   */
  $.extend(TableResponsive, /** @lends Drupal.TableResponsive */{

    /**
     * Store all created instances.
     *
     * @type {Array.<Drupal.TableResponsive>}
     */
    tables: []
  });

  /**
   * Associates an action link with the table that will show hidden columns.
   *
   * Columns are assumed to be hidden if their header has the class priority-low
   * or priority-medium.
   */
  $.extend(TableResponsive.prototype, /** @lends Drupal.TableResponsive# */{

    /**
     * @param {jQuery.Event} e
     *   The event triggered.
     */
    eventhandlerEvaluateColumnVisibility: function (e) {
      var pegged = parseInt(this.$link.data('pegged'), 10);
      var hiddenLength = this.$headers.filter('.priority-medium:hidden, .priority-low:hidden').length;
      // If the table has hidden columns, associate an action link with the
      // table to show the columns.
      if (hiddenLength > 0) {
        this.$link.show().text(this.showText);
      }
      // When the toggle is pegged, its presence is maintained because the user
      // has interacted with it. This is necessary to keep the link visible if
      // the user adjusts screen size and changes the visibility of columns.
      if (!pegged && hiddenLength === 0) {
        this.$link.hide().text(this.hideText);
      }
    },

    /**
     * Toggle the visibility of columns based on their priority.
     *
     * Columns are classed with either 'priority-low' or 'priority-medium'.
     *
     * @param {jQuery.Event} e
     *   The event triggered.
     */
    eventhandlerToggleColumns: function (e) {
      e.preventDefault();
      var self = this;
      var $hiddenHeaders = this.$headers.filter('.priority-medium:hidden, .priority-low:hidden');
      this.$revealedCells = this.$revealedCells || $();
      // Reveal hidden columns.
      if ($hiddenHeaders.length > 0) {
        $hiddenHeaders.each(function (index, element) {
          var $header = $(this);
          var position = $header.prevAll('th').length;
          self.$table.find('tbody tr').each(function () {
            var $cells = $(this).find('td').eq(position);
            $cells.show();
            // Keep track of the revealed cells, so they can be hidden later.
            self.$revealedCells = $().add(self.$revealedCells).add($cells);
          });
          $header.show();
          // Keep track of the revealed headers, so they can be hidden later.
          self.$revealedCells = $().add(self.$revealedCells).add($header);
        });
        this.$link.text(this.hideText).data('pegged', 1);
      }
      // Hide revealed columns.
      else {
        this.$revealedCells.hide();
        // Strip the 'display:none' declaration from the style attributes of
        // the table cells that .hide() added.
        this.$revealedCells.each(function (index, element) {
          var $cell = $(this);
          var properties = $cell.attr('style').split(';');
          var newProps = [];
          // The hide method adds display none to the element. The element
          // should be returned to the same state it was in before the columns
          // were revealed, so it is necessary to remove the display none value
          // from the style attribute.
          var match = /^display\s*\:\s*none$/;
          for (var i = 0; i < properties.length; i++) {
            var prop = properties[i];
            prop.trim();
            // Find the display:none property and remove it.
            var isDisplayNone = match.exec(prop);
            if (isDisplayNone) {
              continue;
            }
            newProps.push(prop);
          }
          // Return the rest of the style attribute values to the element.
          $cell.attr('style', newProps.join(';'));
        });
        this.$link.text(this.showText).data('pegged', 0);
        // Refresh the toggle link.
        $(window).trigger('resize.tableresponsive');
      }
    }
  });

  // Make the TableResponsive object available in the Drupal namespace.
  Drupal.TableResponsive = TableResponsive;

})(jQuery, Drupal, window);
;
