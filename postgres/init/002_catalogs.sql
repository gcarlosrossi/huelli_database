/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 002_catalogs.sql
 * Objetivo : Creación de tablas maestras (Catálogos)
 * PostgreSQL 17+
 ******************************************************************************************/

CREATE TABLE countries
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    iso2            CHAR(2)        NOT NULL,
    iso3            CHAR(3),
    numeric_code    VARCHAR(5),
    name            CITEXT         NOT NULL,
    is_active       BOOLEAN        NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP      NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP      NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_countries_iso2 UNIQUE (iso2),
    CONSTRAINT uq_countries_name UNIQUE (name)
);

COMMENT ON TABLE countries IS 'Listado de países.';

CREATE TABLE departments
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    country_id      UUID NOT NULL,
    code            VARCHAR(20),
    name            CITEXT NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_departments_country
        FOREIGN KEY(country_id)
        REFERENCES countries(id),
    CONSTRAINT uq_department
        UNIQUE(country_id,name)
);

COMMENT ON TABLE departments IS 'Departamentos o estados.';

CREATE TABLE districts
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    department_id   UUID NOT NULL,
    code            VARCHAR(20),
    name            CITEXT NOT NULL,
    latitude        NUMERIC(10,7),
    longitude       NUMERIC(10,7),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_district_department
        FOREIGN KEY(department_id)
        REFERENCES departments(id),
    CONSTRAINT uq_district
        UNIQUE(department_id,name)
);

COMMENT ON TABLE districts IS 'Distritos o ciudades.';

CREATE TABLE roles
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code            VARCHAR(30) NOT NULL,
    name            VARCHAR(100) NOT NULL,
    description     TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_role_code UNIQUE(code),
    CONSTRAINT uq_role_name UNIQUE(name)
);

COMMENT ON TABLE roles IS 'Roles funcionales de Huelli.';

CREATE TABLE company_categories
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code            VARCHAR(30) NOT NULL,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    icon            VARCHAR(250),
    color           VARCHAR(20),
    sort_order      INTEGER DEFAULT 0,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_company_category_code UNIQUE(code),
    CONSTRAINT uq_company_category_name UNIQUE(name)
);

COMMENT ON TABLE company_categories IS 'Categorías para empresas.';

CREATE TABLE auth_providers
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code            VARCHAR(30) NOT NULL,
    name            VARCHAR(100) NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_auth_provider_code UNIQUE(code)
);

COMMENT ON TABLE auth_providers IS 'Proveedores de autenticación.';

CREATE TABLE verification_status
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code            VARCHAR(30) NOT NULL,
    name            VARCHAR(100) NOT NULL,
    description     TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    CONSTRAINT uq_verification_status UNIQUE(code)
);

COMMENT ON TABLE verification_status IS 'Estado de verificación de perfiles.';

CREATE TABLE user_status
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code            VARCHAR(30) NOT NULL,
    name            VARCHAR(100) NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW(),
    CONSTRAINT uq_user_status UNIQUE(code)
);

COMMENT ON TABLE user_status IS 'Estado del usuario.';

COMMENT ON COLUMN countries.created_at IS 'Fecha creación.';
COMMENT ON COLUMN countries.updated_at IS 'Fecha actualización.';
COMMENT ON COLUMN departments.created_at IS 'Fecha creación.';
COMMENT ON COLUMN departments.updated_at IS 'Fecha actualización.';
COMMENT ON COLUMN districts.created_at IS 'Fecha creación.';
COMMENT ON COLUMN districts.updated_at IS 'Fecha actualización.';
COMMENT ON COLUMN roles.created_at IS 'Fecha creación.';
COMMENT ON COLUMN roles.updated_at IS 'Fecha actualización.';
COMMENT ON COLUMN company_categories.created_at IS 'Fecha creación.';
COMMENT ON COLUMN company_categories.updated_at IS 'Fecha actualización.';
