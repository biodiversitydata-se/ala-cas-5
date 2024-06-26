Upgrade notes from CAS 6.5.6-1 to 6.5.6-2
====================================

1. Default attribute releases have been removed, must add attribute releases to CAS services entries in CAS Mgmt application.
  a. Upgrade existing service to support Attribute resolution:
```json
db.services.updateOne({serviceId: '^https?://.*'}, {'$set': { 'attributeReleasePolicy._class': 'org.apereo.cas.services.ReturnAllAttributeReleasePolicy' } });
```
  b. Delete the default IMAPS/HTTPS provided by Apereo just in case the default ALA isn't evaluated first:
```json
db.services.deleteOne({serviceId: '(https|imaps)://.*'})
```
2. There is a bug in the CAS management app that will reset any OIDC/OAuth attribute release policy to denyAll if you edit it in the UI.  Blanket fix after any update until bug is fixed:
```json
db.services.updateMany({"_class": "org.apereo.cas.services.OidcRegisteredService"}, {$set: {"attributeReleasePolicy._class": "org.apereo.cas.services.ReturnAllowedAttributeReleasePolicy"}});
```

Upgrade notes from CAS 5.3 to 6.5
=================================

1. Spring Boot 2 application.yml config key updates:
    - flyway.* -> spring.flyway.*
    - server.context-path -> server.servlet.context-path
    - TODO More to come
2. Fix application.yml config keys:
    - endpoints...
    - spring.endpoints?
3. Create a Mongo database for Spring Sessions, eg spring-sessions and assign the CAS mongo user readWrite access to it.

4. Update cas-service-registry in mongo: `db.services.update({ "multifactorPolicy.failureMode": "NOT_SET"}, { $set: { "multifactorPolicy.failureMode": "UNDEFINED" } }, { multi: true });`
5. Remove existing tickets in mongo (optionally, drop collections as well):
```javascript
    db.ticketGrantingTicketsCollection.remove({})
    db.serviceTicketsCollection.remove({})
    db.transientSessionTicketsCollection.remove({})
    db.proxyGrantingTicketsCollection.remove({})
    db.proxyTicketsCollection.remove({})
    db.oauthAccessTokensCache.remove({})
    db.oauthCodesCache.remove({})
    db.oauthDeviceTokensCache.remove({})
    db.oauthDeviceUserCodesCache.remove({})
    db.oauthRefreshTokensCache.remove({})
```
This is to prevent the ticket cleaner from crashing.  To keep tickets, need to figure out the change in date format and
write a script to update it on all tickets.
6. Update log4j config, make Spring Boot logger sync instead of async so that startup failures are logged.
7. Check attributes stored procedure can be called after flyway runs (test threw a non matching collations error)
8. Check FB, Google, Twitter, AAF callback URLs
9. Check load balancer has correct actuator health endpoints
10. Drop this index from the services collection:
```json
	{
		"v" : 2,
		"unique" : true,
		"key" : {
			"serviceId" : 1
		},
		"name" : "serviceId_1",
		"ns" : "cas-service-registry.services"
	},

```
