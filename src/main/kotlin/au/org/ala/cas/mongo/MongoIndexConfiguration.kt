package au.org.ala.cas.mongo

import au.org.ala.utils.logger
import com.mongodb.client.MongoCollection
import org.apereo.cas.configuration.CasConfigurationProperties
import org.apereo.cas.ticket.TicketCatalog
import org.apereo.cas.ticket.registry.TicketHolder
import org.apereo.cas.ticket.registry.TicketRegistry
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Configuration
import org.springframework.data.domain.Sort
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.index.Index
import javax.annotation.PostConstruct

@Configuration
@EnableConfigurationProperties(CasConfigurationProperties::class)
class MongoIndexConfiguration {

    companion object {
        private val log = logger()
        private val MONGO_INDEX_KEYS = setOf("v", "key", "name", "ns")
    }

    @Autowired
    lateinit var mongoDbTicketRegistryTemplate: MongoTemplate

    @Autowired
    lateinit var ticketRegistry: TicketRegistry

    @Autowired
    lateinit var ticketCatalog: TicketCatalog

    @PostConstruct
    fun initMongoIndices() {
        val definitions = ticketCatalog.findAll()
        definitions.forEach { t ->
            val name = t.properties.storageName
            val c = mongoDbTicketRegistryTemplate.db.getCollection(name)
            val index = Index().on(TicketHolder.FIELD_NAME_ID, Sort.Direction.ASC).unique()
            c.ensureIndex(index)
            log.debug("Ensured MongoDb collection {} index for [{}.{}]", TicketHolder.FIELD_NAME_ID, c.namespace.fullName)
        }
    }

    private fun <T> MongoCollection<T>.ensureIndex(index: Index) {
        // Mongo will throw an Exception if attempting to create an index whose key already exists
        // as an index but has different options.  No exception is thrown if the index is exactly the same.
        // So drop existing indices on the same keys but with different options before recreating them.
        val indexKeys = index.indexKeys
        val existingMismatch = listIndexes().any { existing ->
            val keyMatches = existing["key"] == indexKeys
            val indexOptions = index.indexOptions
            val optionsMatch = indexOptions.entries.all { entry -> entry.value == existing[entry.key] }
            val noExtraOptions = existing.keys.all { key -> MONGO_INDEX_KEYS.contains(key) || indexOptions.keys.contains(key) }

            keyMatches && !(optionsMatch && noExtraOptions)
        }
        if (existingMismatch) {
            log.debug("Removing MongoDb index [{}] from [{}] because it appears to already exist in a different form", indexKeys, namespace)
            dropIndex(indexKeys)
        }
        mongoDbTicketRegistryTemplate.indexOps(namespace.collectionName).ensureIndex(index)
    }
}