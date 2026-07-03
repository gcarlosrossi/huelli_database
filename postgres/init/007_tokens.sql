/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 007_tokens.sql
 * Objetivo : Gestión de tokens de autenticación y notificaciones
 * Compatible: PostgreSQL 17+
 *
 * Requiere:
 *   - 003_security.sql
 ******************************************************************************************/

/******************************************************************************************
 * API TOKENS
 ******************************************************************************************/
CREATE TABLE api_tokens
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id             UUID NOT NULL,

    name                VARCHAR(100) NOT NULL,

    token_hash          TEXT NOT NULL,

    scopes              TEXT,

    expires_at          TIMESTAMP,

    revoked_at          TIMESTAMP,

    last_used_at        TIMESTAMP,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_api_token_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE api_tokens IS
'Tokens personales para acceso mediante API.';

/******************************************************************************************
 * PUSH TOKENS
 ******************************************************************************************/
CREATE TABLE push_tokens
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_device_id      UUID NOT NULL,

    provider            VARCHAR(30) NOT NULL,

    token               TEXT NOT NULL,

    is_active           BOOLEAN NOT NULL DEFAULT TRUE,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_push_device
        FOREIGN KEY(user_device_id)
        REFERENCES user_devices(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE push_tokens IS
'Tokens de notificaciones push (FCM/APNS).';

/******************************************************************************************
 * OAUTH AUTHORIZATION CODES
 ******************************************************************************************/
CREATE TABLE oauth_authorization_codes
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id             UUID NOT NULL,

    provider_id         UUID NOT NULL,

    code_hash           TEXT NOT NULL,

    redirect_uri        TEXT,

    expires_at          TIMESTAMP NOT NULL,

    consumed_at         TIMESTAMP,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_oauth_code_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_oauth_code_provider
        FOREIGN KEY(provider_id)
        REFERENCES auth_providers(id)
);

COMMENT ON TABLE oauth_authorization_codes IS
'Códigos temporales del flujo OAuth2.';

/******************************************************************************************
 * TOKEN BLACKLIST
 ******************************************************************************************/
CREATE TABLE token_blacklist
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    jwt_id              VARCHAR(255) NOT NULL,

    user_id             UUID NOT NULL,

    reason              VARCHAR(200),

    expires_at          TIMESTAMP NOT NULL,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_blacklist_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_blacklist_jti
        UNIQUE(jwt_id)
);

COMMENT ON TABLE token_blacklist IS
'JWT revocados antes de su expiración.';

/******************************************************************************************
 * SESSION TOKENS
 ******************************************************************************************/
CREATE TABLE session_tokens
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id             UUID NOT NULL,

    session_id          UUID NOT NULL DEFAULT gen_random_uuid(),

    refresh_token_id    UUID,

    ip_address          INET,

    user_agent          TEXT,

    started_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    expires_at          TIMESTAMP,

    closed_at           TIMESTAMP,

    CONSTRAINT fk_session_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_session_refresh
        FOREIGN KEY(refresh_token_id)
        REFERENCES refresh_tokens(id)
        ON DELETE SET NULL,

    CONSTRAINT uq_session_id
        UNIQUE(session_id)
);

COMMENT ON TABLE session_tokens IS
'Sesiones activas e históricas del usuario.';

/******************************************************************************************
 * ÍNDICES
 ******************************************************************************************/
CREATE INDEX idx_api_tokens_user
ON api_tokens(user_id);

CREATE INDEX idx_push_tokens_device
ON push_tokens(user_device_id);

CREATE INDEX idx_oauth_codes_user
ON oauth_authorization_codes(user_id);

CREATE INDEX idx_oauth_codes_provider
ON oauth_authorization_codes(provider_id);

CREATE INDEX idx_blacklist_user
ON token_blacklist(user_id);

CREATE INDEX idx_sessions_user
ON session_tokens(user_id);

CREATE INDEX idx_sessions_refresh
ON session_tokens(refresh_token_id);
