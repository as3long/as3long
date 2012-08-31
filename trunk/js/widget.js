define("#widget/1.0.0/daparser",["$"],function(e,t){function o(e){return e.toLowerCase().replace(r,function(e,t){return(t+"").toUpperCase()})}function u(e){for(var t in e)if(e.hasOwnProperty(t)){var n=e[t];if(typeof n!="string")continue;i.test(n)?(n=n.replace(/'/g,'"'),e[t]=u(s(n))):e[t]=a(n)}return e}function a(e){if(e.toLowerCase()==="false")e=!1;else if(e.toLowerCase()==="true")e=!0;else if(/\d/.test(e)&&/[^a-z]/i.test(e)){var t=parseFloat(e);t+""===e&&(e=t)}return e}var n=e("$");t.parseElement=function(e,t){e=n(e)[0];var r={};if(e.dataset)r=n.extend({},e.dataset);else{var i=e.attributes;for(var s=0,a=i.length;s<a;s++){var f=i[s],l=f.name;l.indexOf("data-")===0&&(l=o(l.substring(5)),r[l]=f.value)}}return t===!0?r:u(r)};var r=/-([a-z])/g,i=/^\s*[\[{].*[\]}]\s*$/,s=this.JSON?JSON.parse:n.parseJSON}),define("#widget/1.0.0/auto-render",["$"],function(e,t){var n=e("$"),r="data-widget-auto-rendered";t.autoRender=function(e){return(new this(e)).render()},t.autoRenderAll=function(e,i){typeof e=="function"&&(i=e,e=null),e=n(e||document.body);var s=[],o=[];e.find("[data-widget]").each(function(e,n){t.isDataApiOff(n)||(s.push(n.getAttribute("data-widget").toLowerCase()),o.push(n))}),s.length&&seajs.use(s,function(){for(var e=0;e<arguments.length;e++){var t=arguments[e],s=n(o[e]);if(s.attr(r))continue;t.autoRender&&t.autoRender({element:s,renderType:"auto"}),s.attr(r,"true")}i&&i()})};var i=n(document.body).attr("data-api")==="off";t.isDataApiOff=function(e){var t=n(e).attr("data-api");return t==="off"||t!=="on"&&i}}),define("#widget/1.0.0/widget",["./daparser","./auto-render","#base/1.0.0/base","#class/1.0.0/class","#events/1.0.0/events","$"],function(e,t,n){function d(){return"widget-"+p++}function v(e){return h.call(e)==="[object String]"}function m(e){return h.call(e)==="[object Function]"}function g(e){for(var t in e)if(e.hasOwnProperty(t))return!1;return!0}function b(e){return y(document.documentElement,e)}function w(e){return e.charAt(0).toUpperCase()+e.substring(1)}function T(e){return m(e.events)&&(e.events=e.events()),e.events}function N(e,t){var n=e.match(E),r=n[1]+u+t.cid,i=n[2]||undefined;return i&&i.indexOf("{{")>-1&&(i=C(i,t)),{type:r,selector:i}}function C(e,t){return e.replace(S,function(e,n){var r=n.split("."),i=t,s;while(s=r.shift())i===t.attrs?i=t.get(s):i=i[s];return v(i)?i:x})}function k(e){return e==null||(v(e)||i.isArray(e))&&e.length===0||i.isPlainObject(e)&&g(e)}var r=e("#base/1.0.0/base"),i=e("$"),s=e("./daparser"),o=e("./auto-render"),u=".delegate-events-",a="_onRender",f="data-widget-cid",l={},c=r.extend({propsInAttrs:["element","template","model","events"],element:null,template:"<div></div>",model:null,events:null,attrs:{id:"",className:"",style:{},parentNode:document.body},initialize:function(e){this.cid=d();var t=this._parseDataAttrsConfig(e);this.initAttrs(e,t),this.parseElement(),this.initProps(),this.delegateEvents(),this.setup(),this._stamp()},_parseDataAttrsConfig:function(e){var t,n;return e&&(t=i(e.element)),t&&t[0]&&!o.isDataApiOff(t)&&(n=s.parseElement(t)),n},parseElement:function(){var e=this.element;e?this.element=i(e):this.get("template")&&this.parseElementFromTemplate();if(!this.element||!this.element[0])throw new Error("element is invalid")},parseElementFromTemplate:function(){this.element=i(this.get("template"))},initProps:function(){},delegateEvents:function(e,t){e||(e=T(this));if(!e)return;if(v(e)&&m(t)){var n={};n[e]=t,e=n}for(var r in e){if(!e.hasOwnProperty(r))continue;var i=N(r,this),s=i.type,o=i.selector;(function(e,t){var n=function(n){m(e)?e.call(t,n):t[e](n)};o?t.element.on(s,o,n):t.element.on(s,n)})(e[r],this)}return this},undelegateEvents:function(e){var t={};return arguments.length===0?t.type=u+this.cid:t=N(e,this),this.element.off(t.type,t.selector),this},setup:function(){},render:function(){this.rendered||(this._renderAndBindAttrs(),this.rendered=!0);var e=this.get("parentNode");return e&&!b(this.element[0])&&this.element.appendTo(e),this},_renderAndBindAttrs:function(){var e=this,t=e.attrs;for(var n in t){if(!t.hasOwnProperty(n))continue;var r=a+w(n);if(this[r]){var i=this.get(n);k(i)||this[r](i,undefined,n),function(t){e.on("change:"+n,function(n,r,i){e[t](n,r,i)})}(r)}}},_onRenderId:function(e){this.element.attr("id",e)},_onRenderClassName:function(e){this.element.addClass(e)},_onRenderStyle:function(e){this.element.css(e)},_stamp:function(){var e=this.cid;this.element.attr(f,e),l[e]=this},$:function(e){return this.element.find(e)},destroy:function(){this.undelegateEvents(),delete l[this.cid],c.superclass.destroy.call(this)}});c.query=function(e){var t=i(e).eq(0),n;return t&&(n=t.attr(f)),l[n]},c.autoRender=o.autoRender,c.autoRenderAll=o.autoRenderAll,c.StaticsWhiteList=["autoRender"],n.exports=c;var h=Object.prototype.toString,p=0,y=i.contains||function(e,t){return!!(e.compareDocumentPosition(t)&16)},E=/^(\S+)\s*(.*)$/,S=/{{([^}]+)}}/g,x="INVALID_SELECTOR"});