/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 010_views.sql
 * Objetivo : Vistas de consulta para el MVP
 * Compatible: PostgreSQL 17+
 ******************************************************************************************/

/******************************************************************************************
 * VW_PUBLIC_PROFILES
 ******************************************************************************************/
CREATE OR REPLACE VIEW vw_public_profiles AS
SELECT
    u.id                                AS user_id,
    up.id                               AS profile_id,
    up.community_alias,
    up.full_name,
    up.profile_photo_url,
    up.bio,
    up.reference_url,
    r.code                              AS role_code,
    r.name                              AS role_name,
    c.name                              AS country,
    d.name                              AS department,
    di.name                             AS district,
    up.is_public,
    u.email_verified,
    u.created_at
FROM users u
INNER JOIN user_profiles up
    ON up.user_id = u.id
INNER JOIN roles r
    ON r.id = u.role_id
LEFT JOIN countries c
    ON c.id = up.country_id
LEFT JOIN departments d
    ON d.id = up.department_id
LEFT JOIN districts di
    ON di.id = up.district_id
WHERE u.deleted_at IS NULL
  AND up.deleted_at IS NULL;


/******************************************************************************************
 * VW_COMPANIES
 ******************************************************************************************/
CREATE OR REPLACE VIEW vw_companies AS
SELECT
    cp.id                               AS company_profile_id,
    cp.company_name,
    cc.name                             AS category,
    cp.description,
    cp.website,
    cp.whatsapp,
    cp.logo_url,
    vs.code                             AS verification_status,
    u.primary_email,
    up.profile_photo_url
FROM company_profiles cp
INNER JOIN users u
    ON u.id = cp.user_id
INNER JOIN user_profiles up
    ON up.user_id = u.id
INNER JOIN company_categories cc
    ON cc.id = cp.category_id
INNER JOIN verification_status vs
    ON vs.id = cp.verification_status_id
WHERE cp.deleted_at IS NULL;


/******************************************************************************************
 * VW_RESCUERS
 ******************************************************************************************/
CREATE OR REPLACE VIEW vw_rescuers AS
SELECT
    rp.id                               AS rescuer_profile_id,
    up.full_name,
    up.community_alias,
    rp.whatsapp,
    rp.rescued_pets,
    rp.year_started,
    vs.code                             AS verification_status,
    up.profile_photo_url
FROM rescuer_profiles rp
INNER JOIN users u
    ON u.id = rp.user_id
INNER JOIN user_profiles up
    ON up.user_id = u.id
INNER JOIN verification_status vs
    ON vs.id = rp.verification_status_id;


/******************************************************************************************
 * VW_SHELTERS
 ******************************************************************************************/
CREATE OR REPLACE VIEW vw_shelters AS
SELECT
    sp.id                               AS shelter_profile_id,
    sp.shelter_name,
    sp.whatsapp,
    sp.pets_capacity,
    sp.foundation_year,
    vs.code                             AS verification_status
FROM shelter_profiles sp
INNER JOIN verification_status vs
    ON vs.id = sp.verification_status_id;


/******************************************************************************************
 * VW_COMPANY_LOCATIONS
 ******************************************************************************************/
CREATE OR REPLACE VIEW vw_company_locations AS
SELECT
    cl.id,
    cp.company_name,
    cl.name                             AS branch_name,
    cl.address,
    co.name                             AS country,
    dp.name                             AS department,
    dt.name                             AS district,
    cl.latitude,
    cl.longitude,
    cl.is_main
FROM company_locations cl
INNER JOIN company_profiles cp
    ON cp.id = cl.company_profile_id
LEFT JOIN countries co
    ON co.id = cl.country_id
LEFT JOIN departments dp
    ON dp.id = cl.department_id
LEFT JOIN districts dt
    ON dt.id = cl.district_id;


/******************************************************************************************
 * VW_LOGIN_AUDIT
 ******************************************************************************************/
CREATE OR REPLACE VIEW vw_login_audit AS
SELECT
    la.id,
    u.primary_email,
    ap.code                 AS provider,
    la.login_identifier,
    la.success,
    la.ip_address,
    la.country,
    la.city,
    la.user_agent,
    la.error_message,
    la.created_at
FROM login_audit la
LEFT JOIN users u
    ON u.id = la.user_id
LEFT JOIN auth_providers ap
    ON ap.id = la.provider_id;


/******************************************************************************************
 * VW_ACTIVE_SESSIONS
 ******************************************************************************************/
CREATE OR REPLACE VIEW vw_active_sessions AS
SELECT
    st.session_id,
    u.primary_email,
    st.ip_address,
    st.user_agent,
    st.started_at,
    st.expires_at
FROM session_tokens st
INNER JOIN users u
    ON u.id = st.user_id
WHERE st.closed_at IS NULL
  AND (st.expires_at IS NULL OR st.expires_at > NOW());

