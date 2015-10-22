package org.fao.geonet.repository.specification;

import org.fao.geonet.domain.Constants;
import org.fao.geonet.domain.MetadataIdentifierTemplate;
import org.fao.geonet.domain.MetadataIdentifierTemplate_;
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.*;

/**
 * Specifications for querying MetadataIdentifierTemplate.
 *
 * @author Jose García
 */
public class MetadataIdentifierTemplateSpecs {
    private MetadataIdentifierTemplateSpecs() {
        // don't permit instantiation
    }

    public static Specification<MetadataIdentifierTemplate> isDefault(final boolean isDefault) {
        return new Specification<MetadataIdentifierTemplate>() {
            @Override
            public Predicate toPredicate(Root<MetadataIdentifierTemplate> root, CriteriaQuery<?> query, CriteriaBuilder cb) {

                Path<Character> defaultAttributePath = root.get(MetadataIdentifierTemplate_.default_JPAWorkaround);
                Predicate equalDefaultPredicate = cb.equal(defaultAttributePath,  cb.literal(Constants.toYN_EnabledChar(isDefault)));
                return equalDefaultPredicate;
            }
        };
    }
}