/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 005_profiles.sql
 * Objetivo : Información complementaria de perfiles y redes sociales
 * Compatible: PostgreSQL 17+
 ******************************************************************************************/

/******************************************************************************************
 * PROFILE SOCIAL LINKS
 ******************************************************************************************/
CREATE TABLE profile_social_links
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_profile_id     UUID NOT NULL,

    social_network      VARCHAR(50) NOT NULL,

    profile_url         TEXT NOT NULL,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_social_profile
        FOREIGN KEY(user_profile_id)
        REFERENCES user_profiles(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE profile_social_links IS
'Redes sociales asociadas al perfil del usuario.';


/******************************************************************************************
 * PROFILE PHONES
 ******************************************************************************************/
CREATE TABLE profile_phones
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_profile_id     UUID NOT NULL,

    phone_type          VARCHAR(30),

    country_code        VARCHAR(5),

    phone_number        VARCHAR(30) NOT NULL,

    is_primary          BOOLEAN NOT NULL DEFAULT FALSE,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_phone_profile
        FOREIGN KEY(user_profile_id)
        REFERENCES user_profiles(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE profile_phones IS
'Números telefónicos del usuario.';


/******************************************************************************************
 * PROFILE PREFERENCES
 ******************************************************************************************/
CREATE TABLE profile_preferences
(
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_profile_id             UUID NOT NULL,

    receive_notifications       BOOLEAN NOT NULL DEFAULT TRUE,

    receive_email               BOOLEAN NOT NULL DEFAULT TRUE,

    receive_marketing           BOOLEAN NOT NULL DEFAULT FALSE,

    share_location              BOOLEAN NOT NULL DEFAULT TRUE,

    dark_mode                   BOOLEAN NOT NULL DEFAULT FALSE,

    language_code               VARCHAR(10) DEFAULT 'es-PE',

    created_at                  TIMESTAMP NOT NULL DEFAULT NOW(),

    updated_at                  TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_preferences_profile
        FOREIGN KEY(user_profile_id)
        REFERENCES user_profiles(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_preferences_profile
        UNIQUE(user_profile_id)
);

COMMENT ON TABLE profile_preferences IS
'Preferencias de configuración del usuario.';


/******************************************************************************************
 * PROFILE FAVORITE DISTRICTS
 ******************************************************************************************/
CREATE TABLE profile_favorite_districts
(
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_profile_id     UUID NOT NULL,

    district_id         UUID NOT NULL,

    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_favorite_profile
        FOREIGN KEY(user_profile_id)
        REFERENCES user_profiles(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_favorite_district
        FOREIGN KEY(district_id)
        REFERENCES districts(id),

    CONSTRAINT uq_profile_district
        UNIQUE(user_profile_id, district_id)
);

COMMENT ON TABLE profile_favorite_districts IS
'Distritos de interés para búsquedas y notificaciones.';


/******************************************************************************************
 * PROFILE FOLLOWERS
 ******************************************************************************************/
CREATE TABLE profile_followers
(
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    follower_profile_id     UUID NOT NULL,

    followed_profile_id     UUID NOT NULL,

    created_at              TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_follower
        FOREIGN KEY(follower_profile_id)
        REFERENCES user_profiles(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_followed
        FOREIGN KEY(followed_profile_id)
        REFERENCES user_profiles(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_follow
        UNIQUE(follower_profile_id, followed_profile_id),

    CONSTRAINT chk_not_self_follow
        CHECK (follower_profile_id <> followed_profile_id)
);

COMMENT ON TABLE profile_followers IS
'Relación de seguimiento entre perfiles.';


/******************************************************************************************
 * ÍNDICES
 ******************************************************************************************/
CREATE INDEX idx_social_profile
ON profile_social_links(user_profile_id);

CREATE INDEX idx_phone_profile
ON profile_phones(user_profile_id);

CREATE INDEX idx_pref_profile
ON profile_preferences(user_profile_id);

CREATE INDEX idx_followers_followed
ON profile_followers(followed_profile_id);

CREATE INDEX idx_followers_follower
ON profile_followers(follower_profile_id);

CREATE INDEX idx_favorite_district
ON profile_favorite_districts(district_id);
