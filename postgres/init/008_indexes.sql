/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 008_indexes.sql
 * Objetivo : Índices adicionales para optimizar consultas del MVP
 * Compatible: PostgreSQL 17+
 ******************************************************************************************/

/******************************************************************************************
 * USERS
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_users_email
ON users(primary_email);

CREATE INDEX IF NOT EXISTS idx_users_last_login
ON users(last_login_at);

CREATE INDEX IF NOT EXISTS idx_users_created_at
ON users(created_at);


/******************************************************************************************
 * IDENTITIES
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_identities_login
ON identities(login_identifier);

CREATE INDEX IF NOT EXISTS idx_identities_provider_user
ON identities(provider_user_id);


/******************************************************************************************
 * USER PROFILES
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_profile_full_name
ON user_profiles(full_name);

CREATE INDEX IF NOT EXISTS idx_profile_alias
ON user_profiles(community_alias);

CREATE INDEX IF NOT EXISTS idx_profile_public
ON user_profiles(is_public);

CREATE INDEX IF NOT EXISTS idx_profile_created
ON user_profiles(created_at);


/******************************************************************************************
 * COMPANY PROFILES
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_company_name
ON company_profiles(company_name);

CREATE INDEX IF NOT EXISTS idx_company_created
ON company_profiles(created_at);


/******************************************************************************************
 * COMPANY LOCATIONS
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_company_location_coordinates
ON company_locations(latitude, longitude);

CREATE INDEX IF NOT EXISTS idx_company_location_main
ON company_locations(is_main);


/******************************************************************************************
 * COMPANY SERVICES
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_company_service_name
ON company_services(name);

CREATE INDEX IF NOT EXISTS idx_company_service_active
ON company_services(is_active);


/******************************************************************************************
 * COMPANY REVIEWS
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_company_review_rating
ON company_reviews(rating);

CREATE INDEX IF NOT EXISTS idx_company_review_created
ON company_reviews(created_at);


/******************************************************************************************
 * TOKENS
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_refresh_expiration
ON refresh_tokens(expires_at);

CREATE INDEX IF NOT EXISTS idx_refresh_revoked
ON refresh_tokens(revoked_at);

CREATE INDEX IF NOT EXISTS idx_password_reset_expiration
ON password_reset_tokens(expires_at);

CREATE INDEX IF NOT EXISTS idx_verification_expiration
ON verification_tokens(expires_at);

CREATE INDEX IF NOT EXISTS idx_api_token_expiration
ON api_tokens(expires_at);

CREATE INDEX IF NOT EXISTS idx_blacklist_expiration
ON token_blacklist(expires_at);

CREATE INDEX IF NOT EXISTS idx_session_expiration
ON session_tokens(expires_at);


/******************************************************************************************
 * LOGIN AUDIT
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS idx_login_created
ON login_audit(created_at);

CREATE INDEX IF NOT EXISTS idx_login_success
ON login_audit(success);

CREATE INDEX IF NOT EXISTS idx_login_ip
ON login_audit(ip_address);


/******************************************************************************************
 * TRIGRAM SEARCH (pg_trgm)
 ******************************************************************************************/
CREATE INDEX IF NOT EXISTS gin_profile_name
ON user_profiles
USING GIN (full_name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS gin_company_name
ON company_profiles
USING GIN (company_name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS gin_service_name
ON company_services
USING GIN (name gin_trgm_ops);


/******************************************************************************************
 * OBSERVACIÓN
 * Los índices GIN requieren que la extensión pg_trgm haya sido instalada
 * previamente mediante 001_extensions.sql.
 ******************************************************************************************/
