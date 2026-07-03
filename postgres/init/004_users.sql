/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 004_users.sql
 * Objetivo : Perfiles de usuario y perfiles especializados
 * Compatible: PostgreSQL 17+
 *
 * Requiere:
 *   - 001_extensions.sql
 *   - 002_catalogs.sql
 *   - 003_security.sql
 ******************************************************************************************/

/******************************************************************************************
 * USER PROFILES
 ******************************************************************************************/
CREATE TABLE user_profiles
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id             UUID NOT NULL,

    community_alias     CITEXT,

    full_name           VARCHAR(150) NOT NULL,

    profile_photo_url   TEXT,

    bio                 TEXT,

    reference_url       TEXT,

    country_id          UUID,
    department_id       UUID,
    district_id         UUID,

    is_public           BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMP,

    CONSTRAINT fk_profile_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_profile_country
        FOREIGN KEY(country_id)
        REFERENCES countries(id),

    CONSTRAINT fk_profile_department
        FOREIGN KEY(department_id)
        REFERENCES departments(id),

    CONSTRAINT fk_profile_district
        FOREIGN KEY(district_id)
        REFERENCES districts(id),

    CONSTRAINT uq_profile_user UNIQUE(user_id),
    CONSTRAINT uq_profile_alias UNIQUE(community_alias)
);

COMMENT ON TABLE user_profiles IS
'Perfil público del usuario.';

/******************************************************************************************
 * COMPANY PROFILES
 ******************************************************************************************/
CREATE TABLE company_profiles
(
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id                     UUID NOT NULL,

    company_name                VARCHAR(250) NOT NULL,

    category_id                 UUID NOT NULL,

    verification_status_id      UUID NOT NULL,

    whatsapp                    VARCHAR(30),

    description                 TEXT,

    website                     TEXT,

    year_started                SMALLINT,

    logo_url                    TEXT,

    created_at                  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at                  TIMESTAMP,

    CONSTRAINT fk_company_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_company_category
        FOREIGN KEY(category_id)
        REFERENCES company_categories(id),

    CONSTRAINT fk_company_status
        FOREIGN KEY(verification_status_id)
        REFERENCES verification_status(id),

    CONSTRAINT uq_company_user UNIQUE(user_id)
);

COMMENT ON TABLE company_profiles IS
'Perfil de empresa.';

/******************************************************************************************
 * COMPANY LOCATIONS
 ******************************************************************************************/
CREATE TABLE company_locations
(
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    company_profile_id      UUID NOT NULL,

    name                    VARCHAR(150),

    address                 TEXT,

    country_id              UUID,
    department_id           UUID,
    district_id             UUID,

    latitude                NUMERIC(10,7),
    longitude               NUMERIC(10,7),

    is_main                 BOOLEAN NOT NULL DEFAULT FALSE,

    created_at              TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_location_company
        FOREIGN KEY(company_profile_id)
        REFERENCES company_profiles(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_location_country
        FOREIGN KEY(country_id)
        REFERENCES countries(id),

    CONSTRAINT fk_location_department
        FOREIGN KEY(department_id)
        REFERENCES departments(id),

    CONSTRAINT fk_location_district
        FOREIGN KEY(district_id)
        REFERENCES districts(id)
);

COMMENT ON TABLE company_locations IS
'Sedes de empresas.';

/******************************************************************************************
 * RESCUER PROFILES
 ******************************************************************************************/
CREATE TABLE rescuer_profiles
(
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id                     UUID NOT NULL,

    whatsapp                    VARCHAR(30),

    rescued_pets                INTEGER NOT NULL DEFAULT 0,

    year_started                SMALLINT,

    verification_status_id      UUID NOT NULL,

    created_at                  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_rescuer_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_rescuer_status
        FOREIGN KEY(verification_status_id)
        REFERENCES verification_status(id),

    CONSTRAINT uq_rescuer_user UNIQUE(user_id)
);

COMMENT ON TABLE rescuer_profiles IS
'Perfil del rescatista.';

/******************************************************************************************
 * SHELTER PROFILES
 ******************************************************************************************/
CREATE TABLE shelter_profiles
(
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id                     UUID NOT NULL,

    shelter_name                VARCHAR(250) NOT NULL,

    whatsapp                    VARCHAR(30),

    pets_capacity               INTEGER,

    foundation_year             SMALLINT,

    verification_status_id      UUID NOT NULL,

    created_at                  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at                  TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_shelter_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_shelter_status
        FOREIGN KEY(verification_status_id)
        REFERENCES verification_status(id),

    CONSTRAINT uq_shelter_user UNIQUE(user_id)
);

COMMENT ON TABLE shelter_profiles IS
'Perfil de albergue.';

/******************************************************************************************
 * ÍNDICES
 ******************************************************************************************/
CREATE INDEX idx_profile_country
ON user_profiles(country_id);

CREATE INDEX idx_profile_department
ON user_profiles(department_id);

CREATE INDEX idx_profile_district
ON user_profiles(district_id);

CREATE INDEX idx_company_category
ON company_profiles(category_id);

CREATE INDEX idx_company_status
ON company_profiles(verification_status_id);

CREATE INDEX idx_rescuer_status
ON rescuer_profiles(verification_status_id);

CREATE INDEX idx_shelter_status
ON shelter_profiles(verification_status_id);
