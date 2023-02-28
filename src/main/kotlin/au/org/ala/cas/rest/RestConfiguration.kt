package au.org.ala.cas.rest

import au.org.ala.cas.AlaCasProperties
import org.apereo.cas.authentication.principal.PrincipalResolver
import org.apereo.cas.configuration.CasConfigurationProperties
import org.apereo.cas.oidc.OidcConfigurationContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.cloud.context.config.annotation.RefreshScope
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.ScopedProxyMode

@Configuration
@EnableConfigurationProperties(CasConfigurationProperties::class, AlaCasProperties::class)
class RestConfiguration {

    @Autowired
    lateinit var alaCasProperties: AlaCasProperties

    @Bean
    @RefreshScope(proxyMode = ScopedProxyMode.DEFAULT)
    fun userLookupResource(
        @Qualifier("oidcConfigurationContext") oidcConfigurationContext: OidcConfigurationContext,
        @Qualifier("defaultPrincipalResolver") principalResolver: PrincipalResolver
    ) = UserLookupResource(oidcConfigurationContext, principalResolver, alaCasProperties.rest.requiredScopes)

}