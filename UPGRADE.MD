Upgrade notes from CAS 5.3 to 6.1
=================================

1. Fix keys:
   - flyway.* -> spring.flyway.*
   - endpoints...
   - spring.endpoints?

2. Run in mongo: `db.services.update({ "multifactorPolicy.failureMode": "NOT_SET"}, { $set: { "multifactorPolicy.failureMode": "UNDEFINED" } }, { multi: true });`
3. Update log4j config, make Spring Boot logger sync instead of async so that startup failures are logged.

