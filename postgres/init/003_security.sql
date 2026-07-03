/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 003_security.sql
 * Objetivo : Modelo de Seguridad, Autenticación y OAuth2/OpenID Connect
 * Compatible: PostgreSQL 17+
 ******************************************************************************************/

/******************************************************************************************
 * USERS
 ******************************************************************************************/
CREATE TABLE users
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    role_id             UUID NOT NULL,
    status_id           UUID NOT NULL,

    primary_email       CITEXT NOT NULL,

    email_verified      BOOLEAN NOT NULL DEFAULT FALSE,

    last_login_at       TIMESTAMP,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMP,

    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id),

    CONSTRAINT fk_users_status
        FOREIGN KEY (status_id)
        REFERENCES user_status(id),

    CONSTRAINT uq_users_email
        UNIQUE(primary_email)
);

COMMENT ON TABLE users IS
'Entidad principal de identidad dentro de Huelli.';


/******************************************************************************************
 * IDENTITIES
 ******************************************************************************************/
CREATE TABLE identities
(
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id                 UUID NOT NULL,

    provider_id             UUID NOT NULL,

    provider_user_id        VARCHAR(255),

    login_identifier        CITEXT,

    password_hash           VARCHAR(255),

    is_primary              BOOLEAN NOT NULL DEFAULT FALSE,

    last_login_at           TIMESTAMP,

    created_at              TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at              TIMESTAMP,

    CONSTRAINT fk_identity_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_identity_provider
        FOREIGN KEY(provider_id)
        REFERENCES auth_providers(id)
);

COMMENT ON TABLE identities IS
'Métodos de autenticación (LOCAL, GOOGLE, APPLE, FACEBOOK, MICROSOFT).';


/******************************************************************************************
 * REFRESH TOKENS
 ******************************************************************************************/
CREATE TABLE refresh_tokens
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id         UUID NOT NULL,

    token_hash      TEXT NOT NULL,

    expires_at      TIMESTAMP NOT NULL,

    revoked_at      TIMESTAMP,

    ip_address      INET,

    user_agent      TEXT,

    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_refresh_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE refresh_tokens IS
'Refresh Tokens JWT.';


/******************************************************************************************
 * EMAIL VERIFICATION
 ******************************************************************************************/
CREATE TABLE verification_tokens
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id         UUID NOT NULL,

    token           UUID NOT NULL DEFAULT gen_random_uuid(),

    expires_at      TIMESTAMP NOT NULL,

    used_at         TIMESTAMP,

    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_verification_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE verification_tokens IS
'Tokens para verificar correo electrónico.';


/******************************************************************************************
 * PASSWORD RESET
 ******************************************************************************************/
CREATE TABLE password_reset_tokens
(
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id         UUID NOT NULL,

    token           UUID NOT NULL DEFAULT gen_random_uuid(),

    expires_at      TIMESTAMP NOT NULL,

    used_at         TIMESTAMP,

    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_password_reset_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE password_reset_tokens IS
'Tokens para recuperación de contraseña.';


/******************************************************************************************
 * USER DEVICES
 ******************************************************************************************/
CREATE TABLE user_devices
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id             UUID NOT NULL,

    device_name         VARCHAR(150),

    platform            VARCHAR(50),

    os_version          VARCHAR(50),

    app_version         VARCHAR(50),

    device_identifier   VARCHAR(255),

    push_token          TEXT,

    last_seen_at        TIMESTAMP,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_device_user
        FOREIGN KEY(user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE user_devices IS
'Dispositivos registrados por el usuario.';


/******************************************************************************************
 * LOGIN AUDIT
 ******************************************************************************************/
CREATE TABLE login_audit
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id             UUID,

    provider_id         UUID,

    login_identifier    VARCHAR(255),

    success             BOOLEAN NOT NULL,

    ip_address          INET,

    country             VARCHAR(100),

    city                VARCHAR(100),

    user_agent          TEXT,

    error_message       TEXT,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_login_user
        FOREIGN KEY(user_id)
        REFERENCES users(id),

    CONSTRAINT fk_login_provider
        FOREIGN KEY(provider_id)
        REFERENCES auth_providers(id)
);

COMMENT ON TABLE login_audit IS
'Auditoría de autenticación.';


/******************************************************************************************
 * ÍNDICES
 ******************************************************************************************/
CREATE UNIQUE INDEX ux_identity_provider
ON identities(provider_id, provider_user_id)
WHERE provider_user_id IS NOT NULL;

CREATE UNIQUE INDEX ux_identity_login
ON identities(provider_id, login_identifier)
WHERE login_identifier IS NOT NULL;

CREATE INDEX idx_users_role
ON users(role_id);

CREATE INDEX idx_users_status
ON users(status_id);

CREATE INDEX idx_identity_user
ON identities(user_id);

CREATE INDEX idx_identity_provider
ON identities(provider_id);

CREATE INDEX idx_refresh_user
ON refresh_tokens(user_id);

CREATE INDEX idx_verification_user
ON verification_tokens(user_id);

CREATE INDEX idx_password_reset_user
ON password_reset_tokens(user_id);

CREATE INDEX idx_device_user
ON user_devices(user_id);

CREATE INDEX idx_login_user
ON login_audit(user_id);


/******************************************************************************************
 * VALIDACIÓN
 ******************************************************************************************/
ALTER TABLE identities
ADD CONSTRAINT chk_local_or_oauth
CHECK (
    password_hash IS NOT NULL
    OR provider_user_id IS NOT NULL
);

COMMENT ON COLUMN identities.login_identifier IS
'Correo electrónico o username utilizado para autenticación LOCAL.';

COMMENT ON COLUMN identities.provider_user_id IS
'Identificador emitido por el proveedor OAuth/OpenID Connect.';

COMMENT ON COLUMN identities.password_hash IS
'Hash BCrypt/Argon2 de la contraseña local.';
