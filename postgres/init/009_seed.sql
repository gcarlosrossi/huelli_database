/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 009_seed.sql
 * Objetivo : Datos iniciales para el MVP
 * Compatible: PostgreSQL 17+
 ******************************************************************************************/

/******************************************************************************************
 * ROLES
 ******************************************************************************************/
INSERT INTO roles(code,name,description)
VALUES
('ADMIN','Administrador','Administrador del sistema'),
('USER','Usuario','Usuario de la comunidad'),
('COMPANY','Empresa','Empresa afiliada'),
('SHELTER','Albergue','Albergue de mascotas'),
('RESCUER','Rescatista','Rescatista independiente')
ON CONFLICT (code) DO NOTHING;


/******************************************************************************************
 * AUTH PROVIDERS
 ******************************************************************************************/
INSERT INTO auth_providers(code,name)
VALUES
('LOCAL','Correo y contraseña'),
('GOOGLE','Google'),
('APPLE','Apple'),
('FACEBOOK','Facebook'),
('MICROSOFT','Microsoft')
ON CONFLICT (code) DO NOTHING;


/******************************************************************************************
 * USER STATUS
 ******************************************************************************************/
INSERT INTO user_status(code,name)
VALUES
('PENDING','Pendiente'),
('ACTIVE','Activo'),
('BLOCKED','Bloqueado'),
('DELETED','Eliminado')
ON CONFLICT (code) DO NOTHING;


/******************************************************************************************
 * VERIFICATION STATUS
 ******************************************************************************************/
INSERT INTO verification_status(code,name,description)
VALUES
('PENDING','Pendiente','Pendiente de revisión'),
('IN_REVIEW','En revisión','Proceso de validación'),
('VERIFIED','Verificado','Perfil verificado'),
('REJECTED','Rechazado','Solicitud rechazada')
ON CONFLICT (code) DO NOTHING;


/******************************************************************************************
 * COMPANY CATEGORIES
 ******************************************************************************************/
INSERT INTO company_categories(code,name,description)
VALUES
('VET','Veterinaria','Clínicas y veterinarias'),
('PETSHOP','Pet Shop','Tiendas para mascotas'),
('GROOMING','Grooming','Baño y corte'),
('TRAINING','Entrenamiento','Entrenamiento canino'),
('HOTEL','Hotel','Hospedaje para mascotas'),
('DAYCARE','Guardería','Guardería de mascotas'),
('WALKER','Paseador','Paseadores'),
('TRANSPORT','Transporte','Transporte de mascotas'),
('OTHER','Otros','Otros servicios')
ON CONFLICT (code) DO NOTHING;


/******************************************************************************************
 * COUNTRY
 ******************************************************************************************/
INSERT INTO countries(iso2,iso3,numeric_code,name)
VALUES
('PE','PER','604','Perú')
ON CONFLICT (iso2) DO NOTHING;


/******************************************************************************************
 * DEPARTMENT
 ******************************************************************************************/
INSERT INTO departments(country_id,code,name)
SELECT c.id,'15','Lima'
FROM countries c
WHERE c.iso2='PE'
ON CONFLICT (country_id,name) DO NOTHING;


/******************************************************************************************
 * DISTRICTS
 ******************************************************************************************/
INSERT INTO districts(department_id,code,name)
SELECT d.id,v.code,v.name
FROM departments d
JOIN (
VALUES
('150122','Miraflores'),
('150131','San Isidro'),
('150115','La Molina'),
('150140','Santiago de Surco'),
('150121','Magdalena del Mar'),
('150104','Barranco'),
('150141','San Borja')
) AS v(code,name)
ON TRUE
WHERE d.name='Lima'
ON CONFLICT (department_id,name) DO NOTHING;


/******************************************************************************************
 * ADMIN USER
 * Password temporal: Admin123!
 * IMPORTANTE: Reemplazar por un hash BCrypt generado por la aplicación.
 ******************************************************************************************/
INSERT INTO users
(
    role_id,
    status_id,
    primary_email,
    email_verified
)
SELECT
    r.id,
    s.id,
    'admin@huelli.com',
    TRUE
FROM roles r
CROSS JOIN user_status s
WHERE r.code='ADMIN'
AND s.code='ACTIVE'
AND NOT EXISTS(
    SELECT 1 FROM users u WHERE u.primary_email='admin@huelli.com'
);


/******************************************************************************************
 * ADMIN LOCAL IDENTITY
 ******************************************************************************************/
INSERT INTO identities
(
    user_id,
    provider_id,
    login_identifier,
    password_hash,
    is_primary
)
SELECT
    u.id,
    p.id,
    'admin@huelli.com',
    '$2b$12$REPLACE_WITH_BCRYPT_HASH',
    TRUE
FROM users u
JOIN auth_providers p
ON p.code='LOCAL'
WHERE u.primary_email='admin@huelli.com'
AND NOT EXISTS(
    SELECT 1
    FROM identities i
    WHERE i.login_identifier='admin@huelli.com'
);


/******************************************************************************************
 * ADMIN PROFILE
 ******************************************************************************************/
INSERT INTO user_profiles
(
    user_id,
    full_name,
    community_alias,
    bio,
    is_public
)
SELECT
    u.id,
    'Administrador Huelli',
    'admin',
    'Administrador del sistema',
    FALSE
FROM users u
WHERE u.primary_email='admin@huelli.com'
AND NOT EXISTS(
    SELECT 1 FROM user_profiles p WHERE p.user_id=u.id
);
