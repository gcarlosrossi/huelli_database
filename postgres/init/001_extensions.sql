/******************************************************************************************
 * Proyecto : Huelli
 * Archivo  : 001_extensions.sql
 * Objetivo : Habilitar extensiones requeridas por la plataforma.
 *
 * Compatible con PostgreSQL 17+
 ******************************************************************************************/

-- ========================================================================================
-- UUID
-- ========================================================================================
-- Permite generar UUID v4 mediante gen_random_uuid().
-- Reemplaza la necesidad de uuid_generate_v4() de uuid-ossp.
-- ========================================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

COMMENT ON EXTENSION pgcrypto IS
'Extensión para funciones criptográficas y generación de UUID mediante gen_random_uuid().';

-- ========================================================================================
-- CITEXT
-- ========================================================================================
-- Tipo de dato Case Insensitive.
-- Ideal para emails, usernames y códigos únicos.
-- ========================================================================================

CREATE EXTENSION IF NOT EXISTS citext;

COMMENT ON EXTENSION citext IS
'Tipo de dato Case Insensitive para comparaciones sin distinguir mayúsculas/minúsculas.';

-- ========================================================================================
-- UUID-OSSP (Opcional)
-- ========================================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

COMMENT ON EXTENSION "uuid-ossp" IS
'Compatibilidad para generación de UUID mediante uuid_generate_v4().';

-- ========================================================================================
-- PG_TRGM
-- ========================================================================================

CREATE EXTENSION IF NOT EXISTS pg_trgm;

COMMENT ON EXTENSION pg_trgm IS
'Búsquedas por similitud utilizando índices GIN/GIST.';

-- ========================================================================================
-- UNACCENT
-- ========================================================================================

CREATE EXTENSION IF NOT EXISTS unaccent;

COMMENT ON EXTENSION unaccent IS
'Elimina acentos para búsquedas más amigables.';

-- ========================================================================================
-- BTREE_GIN
-- ========================================================================================

CREATE EXTENSION IF NOT EXISTS btree_gin;

COMMENT ON EXTENSION btree_gin IS
'Operadores BTREE sobre índices GIN.';

-- ========================================================================================
-- Verificación
-- ========================================================================================

DO
$$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '==============================================';
    RAISE NOTICE ' Huelli - Extensiones instaladas correctamente ';
    RAISE NOTICE '==============================================';
    RAISE NOTICE '';
END;
$$;
