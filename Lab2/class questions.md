# class questions



##### **Failure A: “User A sees User B’s data”**

###### 

###### Cause: CloudFront cached a personalized API response, but the cache key did not include the user identity (auth/session).

###### 

###### Fix: Don’t cache personalized /api/\* responses. (Best default.) If you must cache, include the identity in the cache key (usually not worth it).

###### 

##### **Failure B: “Random 403 after enabling ‘forward all headers’”**

###### 

###### Cause: You forwarded/cached too many headers, so CloudFront started sending requests that don’t match what the origin expects, or your policies conflict and produce inconsistent behavior.

###### 

###### Fix: Whitelist only the headers you truly need. Keep the cache key small and predictable.

###### 

##### **Failure C: “Cache hit ratio tanked”**

###### 

###### Cause: Cache key includes too many cookies/headers/query strings, so CloudFront creates tons of unique cache entries (fragmentation).

###### 

###### Fix: Remove unnecessary values from the cache key. Only include what actually changes the response.

###### 

##### **Short written explanation**

###### 

###### 1\) “What is my cache key for /api/ and why?”\*

###### My /api/\* cache key is minimal (or caching disabled) so CloudFront does not store personalized/dynamic responses. This prevents stale reads and prevents user data mixups.

###### 

###### 2\) “What am I forwarding to origin and why?”

###### I forward only what the origin needs to respond correctly (for example: required cookies, required query strings, and a small whitelist of headers). I do not forward extra headers because it increases cache fragmentation and can cause random behavior.

