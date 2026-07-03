/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 006_companies.sql
 * Objetivo : Empresas, sucursales, servicios y horarios
 * Compatible: PostgreSQL 17+
 ******************************************************************************************/

/******************************************************************************************
 * COMPANY SERVICES
 ******************************************************************************************/
CREATE TABLE company_services
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_profile_id  UUID NOT NULL,

    name                VARCHAR(150) NOT NULL,

    description         TEXT,

    price               NUMERIC(10,2),

    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_company_service
        FOREIGN KEY(company_profile_id)
        REFERENCES company_profiles(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE company_services IS
'Servicios ofrecidos por empresas.';


/******************************************************************************************
 * COMPANY BUSINESS HOURS
 ******************************************************************************************/
CREATE TABLE company_business_hours
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_location_id UUID NOT NULL,

    day_of_week         SMALLINT NOT NULL CHECK(day_of_week BETWEEN 1 AND 7),

    open_time           TIME NOT NULL,

    close_time          TIME NOT NULL,

    is_closed           BOOLEAN NOT NULL DEFAULT FALSE,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_business_hours_location
        FOREIGN KEY(company_location_id)
        REFERENCES company_locations(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_location_day
        UNIQUE(company_location_id, day_of_week)
);

COMMENT ON TABLE company_business_hours IS
'Horario de atención por sede.';


/******************************************************************************************
 * COMPANY GALLERY
 ******************************************************************************************/
CREATE TABLE company_gallery
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_profile_id  UUID NOT NULL,

    image_url           TEXT NOT NULL,

    title               VARCHAR(150),

    sort_order          INTEGER DEFAULT 0,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_gallery_company
        FOREIGN KEY(company_profile_id)
        REFERENCES company_profiles(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE company_gallery IS
'Galería de imágenes de la empresa.';


/******************************************************************************************
 * COMPANY REVIEWS
 ******************************************************************************************/
CREATE TABLE company_reviews
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_profile_id  UUID NOT NULL,

    user_id             UUID NOT NULL,

    rating              SMALLINT NOT NULL CHECK(rating BETWEEN 1 AND 5),

    comment             TEXT,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_review_company
        FOREIGN KEY(company_profile_id)
        REFERENCES company_profiles(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_review_user
        UNIQUE(company_profile_id, user_id)
);

COMMENT ON TABLE company_reviews IS
'Reseñas realizadas por usuarios a empresas.';


/******************************************************************************************
 * COMPANY CONTACTS
 ******************************************************************************************/
CREATE TABLE company_contacts
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_profile_id  UUID NOT NULL,

    contact_name        VARCHAR(150),

    position            VARCHAR(100),

    phone               VARCHAR(30),

    email               CITEXT,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_contact_company
        FOREIGN KEY(company_profile_id)
        REFERENCES company_profiles(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE company_contacts IS
'Contactos administrativos de la empresa.';


/******************************************************************************************
 * ÍNDICES
 ******************************************************************************************/
CREATE INDEX idx_company_services_company
ON company_services(company_profile_id);

CREATE INDEX idx_company_gallery_company
ON company_gallery(company_profile_id);

CREATE INDEX idx_company_reviews_company
ON company_reviews(company_profile_id);

CREATE INDEX idx_company_reviews_user
ON company_reviews(user_id);

CREATE INDEX idx_company_contacts_company
ON company_contacts(company_profile_id);

CREATE INDEX idx_company_hours_location
ON company_business_hours(company_location_id);
