(window.webpackJsonpreader=window.webpackJsonpreader||[]).push([[0],{156:function(n,e,t){n.exports=t(386)},369:function(n,e,t){},370:function(n,e,t){n.exports=t.p+"static/media/lora-latin-400.0d78d370.woff"},371:function(n,e,t){n.exports=t.p+"static/media/lora-latin-700.1617380e.woff"},372:function(n,e,t){n.exports=t.p+"static/media/noto-sans-kr-latin-400.4c50be0f.woff"},373:function(n,e,t){n.exports=t.p+"static/media/noto-sans-kr-latin-500.28601458.woff"},374:function(n,e,t){n.exports=t.p+"static/media/noto-sans-kr-latin-700.b9e989a9.woff"},386:function(n,e,t){"use strict";t.r(e);var i=t(3),r=(t(157),t(369),t(370),t(371),t(372),t(373),t(374),t(51)),o=t(52),a=function(){function n(){Object(r.a)(this,n),this.handlers=[]}return Object(o.a)(n,[{key:"on",value:function(n){this.handlers.push(n)}},{key:"off",value:function(n){this.handlers=this.handlers.filter(function(e){return e!==n})}},{key:"trigger",value:function(n){console.log(this.handlers),this.handlers.slice(0).forEach(function(e){return e(n)})}},{key:"expose",value:function(){return this}}]),n}(),c=function(){function n(){Object(r.a)(this,n),this.onFlushPaginate=new a,this.onCancelSelect=new a,this.onStartReader=new a,this.onStartQuiz=new a}return Object(o.a)(n,[{key:"setDev",value:function(){window.app=new u}},{key:"setIOS",value:function(){window.app=new d}},{key:"startReader",value:function(n,e){this.onStartReader.trigger({sentences:n,sid:e})}},{key:"startQuiz",value:function(n,e){this.onStartQuiz.trigger({questions:n,qid:e})}},{key:"flushPaginate",value:function(){this.onFlushPaginate.trigger()}},{key:"cancelSelect",value:function(){this.onCancelSelect.trigger()}}]),n}(),u=function(){function n(){Object(r.a)(this,n)}return Object(o.a)(n,[{key:"initComplete",value:function(){console.log("[app] init complete")}},{key:"setLoading",value:function(n){console.log("[app] loading: "+n)}},{key:"atStart",value:function(){console.log("[app] at start")}},{key:"atMiddle",value:function(){console.log("[app] at middle")}},{key:"atEnd",value:function(){console.log("[app] at end")}},{key:"wordSelected",value:function(n,e,t){console.log("[app] at end i: "+e+" sid:"+t)}},{key:"paginate",value:function(n){console.log("[app] paginate sids"),console.log(n)}},{key:"sentenceSelected",value:function(n){console.log("[app] sentence selected sid:"+n)}},{key:"readingSentenceChange",value:function(n){console.log("[app] reading setence changed")}},{key:"dictSearch",value:function(n){return JSON.stringify({addable:!1,words:[{word:"hello",pron:"",defs:[{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1}]},{word:"hello",pron:"",defs:[{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1},{def:"asdfasf",id:1}]}]})}},{key:"addUnknownSentence",value:function(n){console.log("addUnknownSentence sid: ".concat(n))}},{key:"addUnknownWord",value:function(n,e,t,i){console.log("addUnknownWord sid: ".concat(n," wordIndex: ").concat(e," word: ").concat(t," def: ").concat(i))}},{key:"submitQuestion",value:function(n,e,t){}},{key:"setReadingQuestion",value:function(n){}},{key:"endQuiz",value:function(){}}]),n}(),d=function(){function n(){Object(r.a)(this,n),this.resolveDict=void 0}return Object(o.a)(n,[{key:"initComplete",value:function(){window.webkit.messageHandlers.bridge.postMessage({type:"initComplete"})}},{key:"setLoading",value:function(n){window.webkit.messageHandlers.bridge.postMessage({type:"setLoading",load:n})}},{key:"atStart",value:function(){window.webkit.messageHandlers.bridge.postMessage({type:"atStart"})}},{key:"atMiddle",value:function(){window.webkit.messageHandlers.bridge.postMessage({type:"atMiddle"})}},{key:"atEnd",value:function(){window.webkit.messageHandlers.bridge.postMessage({type:"atEnd"})}},{key:"wordSelected",value:function(n,e,t){window.webkit.messageHandlers.bridge.postMessage({type:"wordSelected",i:e,sid:t,word:n})}},{key:"paginate",value:function(n){window.webkit.messageHandlers.bridge.postMessage({type:"paginate",sids:n})}},{key:"sentenceSelected",value:function(n){window.webkit.messageHandlers.bridge.postMessage({type:"sentenceSelected",sid:n})}},{key:"readingSentenceChange",value:function(n){window.webkit.messageHandlers.bridge.postMessage({type:"readingSentenceChange",sid:n})}},{key:"dictSearch",value:function(n){var e=this;return window.webkit.messageHandlers.bridge.postMessage({type:"dictSearch",word:n}),new Promise(function(n,t){e.resolveDict=n})}},{key:"dictSearchResolve",value:function(n){this.resolveDict&&this.resolveDict(n)}},{key:"addUnknownSentence",value:function(n){window.webkit.messageHandlers.bridge.postMessage({type:"addUnknownSentence",sid:n}),console.log("addUnknownSentence sid: ".concat(n))}},{key:"addUnknownWord",value:function(n,e,t,i){window.webkit.messageHandlers.bridge.postMessage({type:"addUnknownWord",sid:n,wordIndex:e,word:t,def:i})}},{key:"submitQuestion",value:function(n,e,t){window.webkit.messageHandlers.bridge.postMessage({type:"submitQuestion",qid:n,option:e,right:t})}},{key:"setReadingQuestion",value:function(n){window.webkit.messageHandlers.bridge.postMessage({type:"setReadingQuestion",qid:n})}},{key:"endQuiz",value:function(){window.webkit.messageHandlers.bridge.postMessage({type:"endQuiz"})}}]),n}(),s=t(1),l=t.n(s),f=t(150),p=t.n(f),g=t(24);function w(n,e){function t(t){n.current&&!n.current.contains(t.target)&&e()}Object(s.useEffect)(function(){return document.addEventListener("touchstart",t),function(){document.removeEventListener("touchstart",t)}})}function b(n,e,t){function i(n){e(n)}Object(s.useEffect)(function(){return n.on(i),function(){n.off(i)}},t)}var v=t(151),m=t.n(v),h=t(4);function y(){var n=Object(i.a)(["\n      opacity: 0;\n      pointer-events: none;\n    "]);return y=function(){return n},n}function k(){var n=Object(i.a)(["\n  padding: 7px;\n  background: #AB7756;\n  font-weight: 700;\n  color: white;\n  ","\n"]);return k=function(){return n},n}function O(){var n=Object(i.a)(["\n  display: flex;\n  flex-shrink: 0;\n  padding-left: 10px;\n  padding-right: 10px;\n  padding-top: 10px;\n  justify-content: space-between;\n"]);return O=function(){return n},n}function j(){var n=Object(i.a)(["\n  margin-top: 5px;\n  overflow-y: auto;\n  font-weight: 400;\n  & > div {\n    background: lightgray;\n    padding: 10px;\n    margin-bottom: 10px;\n    margin-left: 10px;\n    margin-right: 10px;\n    border-radius: 10px;\n    &:active {\n      background: gray;\n    }\n  }\n"]);return j=function(){return n},n}function x(){var n=Object(i.a)(["\n  flex-shrink: 0;\n  margin-bottom: 10px;\n  padding-top: 10px;\n  padding-left: 10px;\n  padding-right: 10px;\n  font-weight: 500;\n  font-size: 21px;\n"]);return x=function(){return n},n}function S(){var n=Object(i.a)(["\n      visibility: none;\n    "]);return S=function(){return n},n}function E(){var n=Object(i.a)(["\n          bottom: 10px;\n        "]);return E=function(){return n},n}function C(){var n=Object(i.a)(["\n          top: 10px;\n        "]);return C=function(){return n},n}function M(){var n=Object(i.a)(["\n  position: fixed;\n  font-family: 'Noto Sans KR', sans-serif;\n  font-size: 14px;\n  ","\n  ","\n  background: white;\n  height: calc(40%);\n  width: calc(100% - 40px);\n  display: flex;\n  flex-direction: column;\n  box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22);\n  margin-left: 20px;\n  z-index: 999;\n"]);return M=function(){return n},n}var R=h.c.div(M(),function(n){return n.up?Object(h.b)(C()):Object(h.b)(E())},function(n){return n.hide&&Object(h.b)(S())}),z=h.c.div(x()),Q=h.c.div(j()),q=h.c.div(O()),H=h.c.div(k(),function(n){return!n.enabled&&Object(h.b)(y())}),I=function(n){var e=Object(s.useState)(void 0),t=Object(g.a)(e,2),i=t[0],r=t[1],o=Object(s.useState)(0),a=Object(g.a)(o,2),c=a[0],u=a[1],d=Object(s.useRef)(void 0),f=n.selectedWord,p=f.word,b=f.wordIndex,v=f.up,m=f.sentenceId;Object(s.useEffect)(function(){var n=window.app.dictSearch(p);if("string"===typeof n){var e=JSON.parse(n);r(e)}else n.then(function(n){var e=JSON.parse(n);r(e)})},[n]),w(d,function(){console.log("asdf"),window.webapp.cancelSelect()});var h,y=l.a.createElement("div",null,"Not found");return l.a.createElement(R,{hide:!i,ref:function(n){return d.current=n},up:v},i&&i.words[c]?(h=i.words[c],l.a.createElement(l.a.Fragment,null,1!==i.words.length&&l.a.createElement(q,null,l.a.createElement(H,{onClick:function(){u(c-1)},enabled:0!==c},"prev"),l.a.createElement(H,{onClick:function(){u(c+1)},enabled:c!==i.words.length-1},"next")),l.a.createElement(z,null,h.word),l.a.createElement(Q,null,h.defs.map(function(n,e){return l.a.createElement("div",{key:e,onClick:function(){window.app.addUnknownWord(m,b,h.word,n.def),window.webapp.cancelSelect()}},n.def)})))):y)};function B(){var n=Object(i.a)(["\n        top: ","px;\n      "]);return B=function(){return n},n}function T(){var n=Object(i.a)(["\n        top: ","px;\n      "]);return T=function(){return n},n}function U(){var n=Object(i.a)(["\n  display: flex;\n  position: fixed;\n  ","\n\n  & > div {\n    background: #AB7756;\n    padding: 4px;\n    margin-left: 6px;\n    font-family: 'Noto Sans KR', sans-serif;\n    font-weight: 700;\n    color: white;\n  }\n  z-index: 999;\n"]);return U=function(){return n},n}var L=h.c.div(U(),function(n){return n.up?Object(h.b)(T(),n.top-60):Object(h.b)(B(),n.bottom+8)}),N=function(n){var e=Object(s.useRef)(void 0);return w(e,function(){window.webapp.cancelSelect()}),l.a.createElement(L,{ref:function(n){e.current=n},up:n.selectedSentence.up,top:n.selectedSentence.top,bottom:n.selectedSentence.bottom},l.a.createElement("div",{onClick:function(){window.app.addUnknownSentence(n.selectedSentence.sentenceId),window.webapp.cancelSelect()}},"I have no idea!"))};function A(){var n=Object(i.a)(["\n      margin-left: 4px;\n    "]);return A=function(){return n},n}function W(){var n=Object(i.a)(["\n      background: gray;\n      font-weight: 700;\n      padding: 4px;\n      color: white;\n    "]);return W=function(){return n},n}function F(){var n=Object(i.a)(["\n  display: inline;\n  ","\n  ","\n"]);return F=function(){return n},n}function P(){var n=Object(i.a)(["\n      background: gray;\n      padding: 4px;\n      font-weight: 700;\n      color: white;\n    "]);return P=function(){return n},n}function D(){var n=Object(i.a)(["\n      display: inline;\n      margin: 0;\n    "]);return D=function(){return n},n}function J(){var n=Object(i.a)(["\n  padding: 0;\n  margin: 10px 0;\n\n  ","\n  ","\n"]);return J=function(){return n},n}var K=h.c.p(J(),function(n){return!n.inline&&Object(h.b)(D())},function(n){return n.selected&&Object(h.b)(P())}),X=h.c.span(F(),function(n){return n.selected&&Object(h.b)(W())},function(n){return n.first&&Object(h.b)(A())}),Y=/([^a-zA-Z-']+)/,Z=function(n){var e=Object(s.useState)(void 0),t=Object(g.a)(e,2),i=t[0],r=t[1],o=Object(s.useState)(void 0),a=Object(g.a)(o,2),c=a[0],u=a[1],d=Object(s.useRef)(void 0),f=function(n){var e=n.parentElement.parentElement.getBoundingClientRect(),t=n.parentElement.getBoundingClientRect();return Math.pow(e.top-t.top,2)>Math.pow(t.bottom-e.bottom,2)},p=function(n){var e=n.parentElement.parentElement.getBoundingClientRect(),t=n.getBoundingClientRect();return Math.pow(e.top-t.top,2)>Math.pow(t.bottom-e.bottom,2)},w=function(n,e,t,i,o,a){var c="".concat(e,"-").concat(t);d.current&&(r(void 0),u(void 0),clearTimeout(d.current.timer),d.current=void 0);var s=setTimeout(function(){!function o(){d.current&&(1===d.current.n?(r({id:"".concat(e,"-").concat(t),word:i,sentenceId:b[e].id,wordIndex:t/2,up:p(n)}),window.app.wordSelected(i,Math.floor(t/2),b[e].id),u(void 0),d.current.n=2,d.current.timer=setTimeout(function(){o()},800)):2===d.current.n&&(r(void 0),u({id:e.toString(),sentenceId:b[e].id,top:n.parentElement.getBoundingClientRect().top,bottom:n.parentElement.getBoundingClientRect().bottom,up:f(n)}),d.current=void 0))}()},300);d.current={n:1,timer:s,id:c,x:o,y:a}};Object(s.useEffect)(function(){var n;return i?n=function(){r(void 0)}:c&&(n=function(){u(void 0)}),n&&window.webapp.onCancelSelect.on(n),function(){n&&window.webapp.onCancelSelect.off(n)}},[c,i]);var b=n.sentences;return l.a.createElement(l.a.Fragment,null,i&&l.a.createElement(I,{selectedWord:i}),c&&l.a.createElement(N,{selectedSentence:c}),b.map(function(n,e){return l.a.createElement(K,{selected:!!c&&c.id===e.toString(),inline:!n.start,key:e},n.content.split(Y).filter(function(n){return 0!==n.length}).map(function(n,t){return l.a.createElement(X,{selected:!!i&&i.id==="".concat(e,"-").concat(t),first:0===t,key:t,onTouchEnd:function(){d.current&&clearTimeout(d.current.timer)},onTouchMove:function(n){if(1===n.touches.length){var e=n.touches[0].clientX,t=n.touches[0].clientY;d.current&&Math.sqrt(Math.pow(e-d.current.x,2)+Math.pow(t-d.current.y,2))>30&&clearTimeout(d.current.timer)}},onTouchCancel:function(n){d.current&&clearTimeout(d.current.timer)},onTouchStart:n.match(Y)?void 0:function(i){1===i.touches.length?w(i.target,e,t,n,i.touches[0].clientX,i.touches[0].clientY):d.current&&clearTimeout(d.current.timer)}},n)}))}))};function G(){var n=Object(i.a)(["\n      opacity: 0;\n      pointer-events: none;\n    "]);return G=function(){return n},n}function V(){var n=Object(i.a)(["\n  overflow: hidden;\n  height: 100%;\n  width: 100%;\n  & > div {\n    height: 100%;\n  }\n\n  & > * > div {\n    height: 100%;\n  }\n\n  ","\n"]);return V=function(){return n},n}function $(){var n=Object(i.a)(["\n  max-height: 100%;\n  height: 100%;\n  overflow: hidden;\n"]);return $=function(){return n},n}function _(){var n=Object(i.a)(["\n  height: calc(100vh - 20px);\n  padding: 10px 5px;\n  width: calc(100% - 10px);\n"]);return _=function(){return n},n}var nn=h.c.div(_()),en=h.c.div($()),tn=Object(h.c)(m.a)(V(),function(n){return n.loading&&Object(h.b)(G())}),rn=function(n){var e=n.sentences,t=Object(s.useState)(null),i=Object(g.a)(t,2),r=i[0],o=i[1],a=Object(s.useRef)([]),c=Object(s.useRef)(null),u=Object(s.useRef)(new Map),d=Object(s.useRef)(n.readingSentence),f=r||[],p=function(n){return n===f.length?e.slice(f[n-1]||0):e.slice(f[n-1]||0,f[n])},w=function(){var n=u.current.get(d.current)||0;0===n&&window.app.atStart(),n===f.length&&window.app.atEnd(),0!==n&&n!==f.length&&window.app.atMiddle(),window.app.readingSentenceChange(d.current)};Object(s.useEffect)(function(){r&&(window.app.setLoading(!1),w())}),Object(s.useEffect)(function(){for(var t=a.current[0],i=t.getBoundingClientRect(),r=i.top,c=i.height,s=r,l=0,f=[],p=0;p<t.children.length;p+=1){t.children[p].getBoundingClientRect().bottom-s+20>=c&&(s=(t.children[p-1]||t.children[p]).getBoundingClientRect().bottom,f[l]=p,l+=1)}d.current=n.readingSentence,u.current=Array(f.length+1).fill(1).flatMap(function(n,t){return(i=t,i===f.length?e.slice(f[i-1]||0):e.slice(f[i-1]||0,f[i])).map(function(n){return[n.id,t]});var i}).reduce(function(n,e){return n.set(e[0],e[1]),n},new Map),o(f)},[]),b(window.webapp.onFlushPaginate,function(){var n=u.current.get(d.current)||0;window.app.paginate(p(n).map(function(n){return n.id}))},[]);var v={startSlide:u.current.get(d.current)||0,continuous:!1,callback:function(){if(c.current){var n=p(c.current.getPos()),e=u.current.get(d.current)||0,t=u.current.get(n[0].id)||0;d.current=n[0].id,t>e&&window.app.paginate(p(e).map(function(n){return n.id})),window.webapp.cancelSelect(),w()}}};return l.a.createElement(nn,null,l.a.createElement(tn,{loading:!r,swipeOptions:v,ref:function(n){return c.current=n},childCount:f.length+1},Array(f.length+1).fill(1).map(function(n,e){return l.a.createElement(en,{style:{cursor:"pointer"},key:e,ref:function(n){a.current[e]=n}},l.a.createElement(Z,{sentences:p(e)}))})))};function on(){var n=Object(i.a)(["\n  display: flex;\n  flex-direction: column;\n  height: 100%;\n"]);return on=function(){return n},n}function an(){var n=Object(i.a)(["\n  margin-top: 50px;\n  display: flex;\n  justify-content: flex-end;\n  margin-bottom: 20px;\n"]);return an=function(){return n},n}function cn(){var n=Object(i.a)(["\n      opacity: 1;\n    "]);return cn=function(){return n},n}function un(){var n=Object(i.a)(["\n  padding: 10px 20px;\n  display: inline-block;\n  background: #AB7756;\n  opacity: 0;\n  color: white;\n\n  ","\n"]);return un=function(){return n},n}function dn(){var n=Object(i.a)(["\n  margin-top: auto;\n"]);return dn=function(){return n},n}function sn(){var n=Object(i.a)(["\n      background: #bf9478;\n    "]);return sn=function(){return n},n}function ln(){var n=Object(i.a)(["\n  margin-top: 10px;\n  padding: 10px;\n  background: #f5c3a4;\n\n  ","\n"]);return ln=function(){return n},n}function fn(){var n=Object(i.a)(["\n      background: gray;\n      padding: 4px;\n      font-weight: 700;\n      color: white;\n  "]);return fn=function(){return n},n}function pn(){var n=Object(i.a)(["\n  display: inline;\n\n  ","\n"]);return pn=function(){return n},n}function gn(){var n=Object(i.a)(["\n  margin-top: 10px;\n  background: lightgray;\n  padding: 10px;\n  font-family: 'Lora', serif;\n"]);return gn=function(){return n},n}function wn(){var n=Object(i.a)(["\n  margin-top: 20px;\n"]);return wn=function(){return n},n}function bn(){var n=Object(i.a)(["\n  height: calc(100vh - 20px);\n  padding: 10px 10px;\n  width: calc(100% - 20px);\n  font-family: 'Noto Sans KR', sans-serif;\n  font-size: 17px;\n"]);return bn=function(){return n},n}var vn=h.c.div(bn()),mn=h.c.div(wn()),hn=h.c.div(gn()),yn=h.c.div(pn(),function(n){return n.selected&&Object(h.b)(fn())}),kn=h.c.div(ln(),function(n){return n.selected&&Object(h.b)(sn())}),On=h.c.div(dn()),jn=h.c.div(un(),function(n){return n.selected&&Object(h.b)(cn())}),xn=h.c.div(an()),Sn=h.c.div(on()),En=function(n){var e=n.questions,t=Object(s.useState)(n.readingQuestion),i=Object(g.a)(t,2),r=i[0],o=i[1],a=Object(s.useState)(null),c=Object(g.a)(a,2),u=c[0],d=c[1],f=e.findIndex(function(n){return n.id===r}),p=-1===f?0:f,w=e[p];Object(s.useEffect)(function(){window.app.setLoading(!1)},[]);var b=function(){if(null!=u)if(window.app.submitQuestion(r,w.options[u],u===w.answer),p===e.length-1)window.app.endQuiz();else{var n=e[p+1].id;window.app.setReadingQuestion(n),o(n),d(null)}};return l.a.createElement(vn,null,"word"===w.type&&l.a.createElement(Sn,null,l.a.createElement(mn,null,"Choose the definition of highlighted word in this paragraph."),l.a.createElement(hn,null,w.sentence.split(Y).filter(function(n){return 0!==n.length}).map(function(n,e){return l.a.createElement(yn,{selected:Math.floor(e/2)===w.wordIndex&&!n.match(Y)},n)})),l.a.createElement(On,null,w.options.map(function(n,e){return l.a.createElement(kn,{onClick:function(){d(e)},key:e,selected:u===e},n)})),l.a.createElement(xn,null,l.a.createElement(jn,{onClick:function(){b()},selected:null!==u},"Next"))),"summary"===w.type&&l.a.createElement(Sn,null,l.a.createElement(mn,null,"Choose the most accurate summary of the last chapter."),l.a.createElement(On,null,w.options.map(function(n,e){return l.a.createElement(kn,{onClick:function(){d(e)},key:e,selected:u===e},n)})),l.a.createElement(xn,null,l.a.createElement(jn,{onClick:function(){b()},selected:null!==u},"Next"))))},Cn=function(){var n=Object(s.useState)(null),e=Object(g.a)(n,2),t=e[0],i=e[1];b(window.webapp.onStartReader,function(n){i(null),i({type:"reader",sentences:n.sentences,sid:n.sid})},[]),b(window.webapp.onStartQuiz,function(n){i(null),i({type:"quiz",questions:n.questions,qid:n.qid})},[]),Object(s.useEffect)(function(){window.app.initComplete()},[]);var r=l.a.createElement(l.a.Fragment,null);return t&&("reader"===t.type&&(r=l.a.createElement(rn,{sentences:t.sentences,readingSentence:t.sid})),"quiz"===t.type&&(r=l.a.createElement(En,{questions:t.questions,readingQuestion:t.qid}))),r};function Mn(){var n=Object(i.a)(["\n  body {\n    margin: 0;\n    font-family: 'Lora', serif;\n    -webkit-font-smoothing: antialiased;\n    -moz-osx-font-smoothing: grayscale;\n    font-size: 21px;\n    user-select: none;\n    -moz-user-select: none;\n    -khtml-user-select: none;\n    -webkit-user-select: none;\n    -o-user-select: none;\n  }\n"]);return Mn=function(){return n},n}var Rn=Object(h.a)(Mn());window.webapp=new c,"ios"===navigator.userAgent&&window.webapp.setIOS(),p.a.render(l.a.createElement("div",null,l.a.createElement(Rn,null),l.a.createElement(Cn,null)),document.getElementById("root"))}},[[156,1,2]]]);
//# sourceMappingURL=main.570d5a0a.chunk.js.map