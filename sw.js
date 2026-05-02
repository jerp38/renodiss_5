const CACHE_NAME = 'renodiss-cache-v2';

const urlsToCache = [

'./',
'./style.css',
'./script.js',
'./manifest.json'

];

// instalar
self.addEventListener('install', e => {

e.waitUntil(
caches.open(CACHE_NAME)
.then(cache => cache.addAll(urlsToCache))
);

});

// fetch estrategia híbrida

self.addEventListener('fetch', e => {

e.respondWith(

fetch(e.request)
.then(res => {

const resClone = res.clone();

caches.open(CACHE_NAME)
.then(cache => {
cache.put(e.request, resClone);
});

return res;

})
.catch(() => caches.match(e.request))

);

});